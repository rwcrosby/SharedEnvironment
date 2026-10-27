#!/bin/bash
#
# Remote-unlock helper for zorro's encrypted root pool.
#
# This is a convenience wrapper around the INTERACTIVE unlock. It waits for the
# initramfs to come up, hands you an ssh session running zfsunlock where you
# type the passphrase, then confirms the boot actually resumed.
#
# Passphrase:  op://shared/zpool zorro encryption key/credential
#
# RUN THIS FROM THE MAC. It cannot run on zorro -- zorro is the machine being
# unlocked. This file lands on zorro only because SharedEnvironment is a git
# repo shared to it.
#
# Typical use after a power loss:
#   ssh idrac "racadm serveraction powerup"
#   zorroUnlock.sh --wait 300
#
# ---------------------------------------------------------------------------
# Why this is not automated. Three approaches were tried and all failed; the
# passphrase cannot be delivered non-interactively through this path:
#
#   1. Pipe into `zfsunlock` over plain ssh. No effect: zfsunlock runs
#      `systemd-ask-password | zfs load-key`, and systemd-ask-password reads a
#      terminal, not stdin, so the piped passphrase is discarded.
#
#   2. Load the key directly, `zfs load-key -L file:///dev/stdin zorro`. This
#      DOES load the key but does NOT release the boot. decrypt_fs() sits in:
#          for _ in 1 2 3; do
#              systemd-ask-password --no-tty ... | zfs load-key "$ROOT" && break
#          done
#      With the key already loaded, `zfs load-key` returns 255 ("Key already
#      loaded"), so `&& break` never fires; killing the prompt only starts the
#      next iteration. zfsunlock also owns the completion handshake (it creates
#      /run/zfs_unlock_complete_notify, which the boot blocks on after
#      mounting), so bypassing it is wrong on a second count.
#
#   3. Feed zfsunlock through a pty with `ssh -tt`. Also failed.
#
# The architecturally correct route to an UNATTENDED boot is the packaged
# extension point /etc/zfs/initramfs-tools-load-key.d/, which decrypt_fs() runs
# BEFORE any prompt exists -- so there is no loop to escape and no handshake to
# bypass. That is the mechanism the USB key dongle design uses. See
# "HowTo - zorro Remote Unlock" and "2026-09 Network Enhancements" in the vault.
# ---------------------------------------------------------------------------

set -euo pipefail

SSH_HOST="zorro-unlock"       # ~/.ssh/config -> root@192.168.23.3 port 222
INITRAMFS_ADDR="192.168.23.3"
INITRAMFS_PORT="222"
# Deliberately an address that exists ONLY in the booted OS. The initramfs also
# has 192.168.23.3, so polling that would not distinguish "still at the prompt"
# from "booted". br4 comes up only with the real system.
BOOTED_ADDR="192.168.11.3"
BOOTED_USER="rcrosby"
POOL="zorro"
WAIT=0
CONFIRM_TIMEOUT=240

usage() {
    cat >&2 <<USAGE
Usage: $(basename "$0") [--wait SECONDS]

  --wait N   Poll up to N seconds for the initramfs ssh port to answer.
             Use after a power-on; the BMC answers long before the host does.

You will be prompted for the pool passphrase:
  op://shared/zpool zorro encryption key/credential
USAGE
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --wait) [[ $# -ge 2 ]] || usage; WAIT="$2"; shift 2 ;;
        -h|--help) usage ;;
        *) echo "Unknown argument: $1" >&2; usage ;;
    esac
done

die() { echo "$*" >&2; exit 1; }
port_open() { nc -z -w3 "$1" "$2" >/dev/null 2>&1; }

# --- preflight -------------------------------------------------------------
command -v nc >/dev/null || die "nc not found"
[[ -f "${HOME}/.ssh/zorro_unlock_ed25519" ]] || die "unlock key missing: ~/.ssh/zorro_unlock_ed25519"

# --- wait for the initramfs, if asked --------------------------------------
if [[ "$WAIT" -gt 0 ]]; then
    echo "Waiting up to ${WAIT}s for the initramfs on ${INITRAMFS_ADDR}:${INITRAMFS_PORT}..."
    deadline=$(( SECONDS + WAIT ))
    until port_open "$INITRAMFS_ADDR" "$INITRAMFS_PORT"; do
        (( SECONDS < deadline )) || die "Timed out waiting for the initramfs"
        sleep 5
    done
fi

port_open "$INITRAMFS_ADDR" "$INITRAMFS_PORT" || die \
"Nothing listening on ${INITRAMFS_ADDR}:${INITRAMFS_PORT}.
Is zorro powered on and at the initramfs prompt? Check:
  ssh idrac \"racadm serveraction powerstatus\"
If it is already booted, there is nothing to unlock."

# --- interactive unlock ----------------------------------------------------
cat <<BANNER

Opening an interactive unlock session. Enter the pool passphrase at the prompt:
  op://shared/zpool zorro encryption key/credential

BANNER

ssh -t "$SSH_HOST" zfsunlock || true

# --- confirm out of band ---------------------------------------------------
echo
echo "Confirming ${POOL} unlocked and the host booted..."
deadline=$(( SECONDS + CONFIRM_TIMEOUT ))
until status=$(ssh -o ConnectTimeout=5 -o BatchMode=yes "${BOOTED_USER}@${BOOTED_ADDR}" \
                 "zfs get -H -o value keystatus ${POOL}" 2>/dev/null) \
      && [[ "$status" == "available" ]]; do
    if (( SECONDS >= deadline )); then
        cat >&2 <<FAIL
${POOL}: could not confirm unlock within ${CONFIRM_TIMEOUT}s.

Check the iDRAC virtual console at 192.168.23.6 to see where the boot stopped.
The console passphrase prompt is always available as a last resort.
FAIL
        exit 1
    fi
    sleep 5
done

echo "${POOL}: unlocked, host is up."

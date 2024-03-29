---
numbersections: False
diststmt: 'Dist A: Approved for public release: distribution unlimited'
title: VSCODE information
---

# Keyboard

https://code.visualstudio.com/shortcuts/keyboard-shortcuts-macos.pdf

| Key                  | Description               |
|-                     |-|
| _\DejaSans ^_ l      | Center editor window      |
| _\DejaSans ⇧⌘_ i     | Insert org type timestamp |
|                      | |
| _\DejaSans ⌘_ d      | Extend selection          |
|                      | |
| _\DejaSans ^_ -      | Previous location         |
| _\DejaSans ⇧^_ -     | Next location             |
|                      | |
| _\DejaSans ^_ PgUp   | Scroll up line            |
| _\DejaSans ^_ PgDn   | Scroll down line          |
| _\DejaSans ⌘_ PgUp   | Scroll up page            |
| _\DejaSans ⌘_ PgDn   | Scroll down page          |
|                      | |
| _\DejaSans ⌥⌘↑_      | Insert cursor up          |
| _\DejaSans ⌥⌘↓_      | Insert cursor down        |
|                      | |
| _\DejaSans ⇧⌘._      | Focus to Breadcrumb       |


# Extensions

- Center Editor Window
- Org Mode (vscode-org-mode)
    + Not really using this one anymore
- Insert Date String
    - <2020-12-11 Fri 08:53> Adjusted format to match Org mode
    - <2021-01-15 Fri 09:05> Would be nice to be able to select date

# File Locations

Files are linked to from `SharedEnvironment/vscode`

- User Tasks: 
    + MacOS: `~/Library/Application Support/Code/User/tasks.json`

- User Settings:
    + MacOS: `~/Library/Application Support/Code/User/settings.json`

# Remote handling

- Won't start with fish shell on the remote
    - Correction, fish wasn't the problem

- Need to force the host type in the vscode remote settings
    `Remote.SSH: Host Platform`


# Wish List

- Better date/timestamp insertion capability
- Better todo list capability


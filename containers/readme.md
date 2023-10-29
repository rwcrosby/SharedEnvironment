# Notes

- <2023-10-17 Tue 15:52> Needed to reset shadow-utils to clear error on newuidmap

    - ` newuidmap 4949 0 $(id -u) 1 1 524288 100` failed
    - `sudo rpm --restore shadow-utils` fixed it...

    https://github.com/containers/buildah/issues/3834

    
#!/bin/bash
proot-distro install archlinux || true
proot-distro install ubuntu || true
proot-distro install fedora || true
proot-distro install debian || true

 ok "Proot distros instaladas."

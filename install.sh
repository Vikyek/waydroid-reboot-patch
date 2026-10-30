#!/bin/bash
# Manual install script for waydroid-reboot-patch
set -euo pipefail

SRCDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESTDIR="${DESTDIR:-}"
PREFIX="${DESTDIR}/usr/share/waydroid-reboot-patch"
HOOKDIR="${DESTDIR}/etc/pacman.d/hooks"
DROPIN_DIR="${DESTDIR}/etc/systemd/system/waydroid-container.service.d"
BINDIR="${DESTDIR}/usr/bin"
MANDIR="${DESTDIR}/usr/share/man/man1"

install -Dm644 "$SRCDIR/patches/hardware_manager.py" "$PREFIX/patches/hardware_manager.py"
install -Dm644 "$SRCDIR/systemd/restart.conf"        "$PREFIX/systemd/restart.conf"
install -Dm755 "$SRCDIR/waydroid-reboot-patch"        "$BINDIR/waydroid-reboot-patch"
install -Dm644 "$SRCDIR/hooks/waydroid-reboot-patch.hook" "$HOOKDIR/waydroid-reboot-patch.hook"
install -Dm644 "$SRCDIR/systemd/restart.conf"        "$DROPIN_DIR/restart.conf"
install -Dm644 "$SRCDIR/man1/waydroid-reboot-patch.1" "$MANDIR/waydroid-reboot-patch.1"

if [[ -z "$DESTDIR" ]]; then
    systemctl daemon-reload
    waydroid-reboot-patch apply
fi

echo "waydroid-reboot-patch installed."

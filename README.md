# waydroid-reboot-patch

Fixes Waydroid closing after an in-guest Android reboot and failing to reopen.

## Problem

When Android fires a reboot inside Waydroid, the LXC container shuts down and
needs to restart. Two race conditions prevent this:

1. `wait_for_running()` in `lxc.py` has a **10-second** hard timeout — too short
   after a binder node reset. It raises `OSError`, crashing the hardware manager
   service thread.
2. `waydroid-container.service` has no `Restart=` policy, so once it exits it
   stays dead.

## Patches

| File | Change |
|------|--------|
| `hardware_manager.py` | `reboot()` and `shutdownRequest()` retry `lxc.start()` up to 3× with 5 s gaps |
| `lxc.py` | `wait_for_running()` timeout bumped 10 s → 30 s |
| systemd drop-in | `Restart=on-failure` + `RestartSec=5` backstop |

A **pacman alpm hook** automatically re-applies all patches whenever `waydroid`
is upgraded.

## Installation

### Via PKGBUILD (recommended)

```bash
cd ~/Projects/waydroid-reboot-patch
makepkg -si
```

### Manual

```bash
sudo bash install.sh
```

## Usage

```bash
waydroid-reboot-patch apply    # apply patches (idempotent)
waydroid-reboot-patch check    # report patch status
waydroid-reboot-patch remove   # restore originals
```

## Compatibility

Developed against **waydroid 1.6.3**. After any `waydroid` upgrade the pacman
hook re-applies patches automatically. If upstream changes the relevant
functions significantly, `check` will report which patches no longer applied and
you can open an issue.

## License

GPL-3.0-or-later (same as waydroid).

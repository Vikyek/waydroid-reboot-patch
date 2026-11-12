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

---

## Support & Sponsorship

`waydroid-reboot-patch` is authored and maintained by **[Vikyek](https://github.com/Vikyek)** as an independent open-source project. Everything is 100% open-source, telemetry-free, and public.

<div align="center">


[![Sponsor Vikyek](https://img.shields.io/badge/Sponsor-%E2%9D%A4-ea4aaa?logo=github&style=for-the-badge)](https://github.com/sponsors/Vikyek)
[![Donate on Liberapay](https://img.shields.io/badge/Donate-Liberapay-f6c915?style=for-the-badge&logo=liberapay&logoColor=black)](https://liberapay.com/Vikyek)
[![Donate with Stripe](https://img.shields.io/badge/Donate-Stripe-635BFF?style=for-the-badge&logo=stripe&logoColor=white)](https://profile.stripe.com/@vikyek)

</div>

> ### 🎯 Active Sponsorship Goal: Monthly Living Essentials
> **Target:** **2,710 PLN / ~$680 USD per month** (`630 PLN / week`) — Rent & Essential Utilities  
> Covering basic living essentials directly unlocks dedicated, sustainable full-time independent open-source engineering across Arch Linux utilities, developer tools, and AI middleware free from corporate telemetry, ads, or paywalls.

If this project saves you time, optimizes your setup, or accelerates your workflow, consider supporting ongoing work:

- **GitHub Sponsors**: [github.com/sponsors/Vikyek](https://github.com/sponsors/Vikyek) *(Monthly tiers and one-time tips)*
- **Liberapay**: [liberapay.com/Vikyek](https://liberapay.com/Vikyek) *(0% platform fee recurrent patronage in EUR/USD/PLN)*
- **Direct Stripe Profile**: [profile.stripe.com/@vikyek](https://profile.stripe.com/@vikyek) *(Direct one-time tips & sponsorship)*

Every contribution—monthly or one-time—directly supports active maintenance, hardware testbeds, and new feature development!

---

## License

GPL-3.0-or-later (same as waydroid).

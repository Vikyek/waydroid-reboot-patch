# Maintainer: your-username <your-email>
pkgname=waydroid-reboot-patch
pkgver=1.0.0
pkgrel=1
pkgdesc="Fix Waydroid closing after Android in-guest reboot — retry logic + systemd restart policy"
arch=('any')
url="https://github.com/Vikyek/waydroid-reboot-patch"
license=('GPL-3.0-or-later')
depends=('waydroid')
backup=(
    'usr/share/waydroid-reboot-patch/patches/hardware_manager.py'
)
source=("$pkgname-$pkgver.tar.gz::https://github.com/Vikyek/$pkgname/archive/refs/tags/v$pkgver.tar.gz")
sha256sums=('SKIP')

package() {
    cd "$srcdir/$pkgname-$pkgver"
    make install DESTDIR="$pkgdir" PREFIX=/usr
}

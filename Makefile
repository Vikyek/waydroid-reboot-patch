.PHONY: install uninstall

PREFIX ?= /usr

install:
	install -Dm644 patches/hardware_manager.py $(DESTDIR)$(PREFIX)/share/waydroid-reboot-patch/patches/hardware_manager.py
	install -Dm644 systemd/restart.conf        $(DESTDIR)$(PREFIX)/share/waydroid-reboot-patch/systemd/restart.conf
	install -Dm755 waydroid-reboot-patch        $(DESTDIR)$(PREFIX)/bin/waydroid-reboot-patch
	install -Dm644 hooks/waydroid-reboot-patch.hook $(DESTDIR)/etc/pacman.d/hooks/waydroid-reboot-patch.hook
	install -Dm644 systemd/restart.conf        $(DESTDIR)/etc/systemd/system/waydroid-container.service.d/restart.conf
	install -Dm644 man1/waydroid-reboot-patch.1 $(DESTDIR)$(PREFIX)/share/man/man1/waydroid-reboot-patch.1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/share/waydroid-reboot-patch/patches/hardware_manager.py
	rm -f $(DESTDIR)$(PREFIX)/share/waydroid-reboot-patch/systemd/restart.conf
	rm -f $(DESTDIR)$(PREFIX)/bin/waydroid-reboot-patch
	rm -f $(DESTDIR)/etc/pacman.d/hooks/waydroid-reboot-patch.hook
	rm -f $(DESTDIR)/etc/systemd/system/waydroid-container.service.d/restart.conf
	rm -f $(DESTDIR)$(PREFIX)/share/man/man1/waydroid-reboot-patch.1

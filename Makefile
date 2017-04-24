BINDIR  = $(DESTDIR)/usr/bin

install:
	mkdir -p $(BINDIR)
	chmod 755 monitors.sh
	cp monitors.sh $(BINDIR)/monitors

uninstall:
	$(RM) $(BINDIR)/monitors

.PHONY: install uninstall

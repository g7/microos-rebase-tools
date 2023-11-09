DESTDIR ?= /

all: install

install: src/lib/*.sh src/microos-rebase.sh
	install -d $(DESTDIR)/usr/lib
	install -d $(DESTDIR)/usr/lib/microos-rebase-tools
	install -d $(DESTDIR)/usr/lib/microos-rebase-tools/src
	install -d $(DESTDIR)/usr/lib/microos-rebase-tools/src/lib
	install -d $(DESTDIR)/usr/lib/microos-rebase-tools/src/data
	install -d $(DESTDIR)/usr/sbin
	for src in $^; do \
		install -m 644 $${src} $(DESTDIR)/usr/lib/microos-rebase-tools/$${src} ; \
	done
	chmod +x $(DESTDIR)/usr/lib/microos-rebase-tools/src/microos-rebase.sh
	ln -s /usr/lib/microos-rebase-tools/src/microos-rebase.sh $(DESTDIR)/usr/sbin/microos-rebase

.PHONY: all install

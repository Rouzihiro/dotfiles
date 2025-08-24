# dmenu - dynamic menu
# See LICENSE file for copyright and license details.

.SILENT:

include config.mk

SRC = drw.c dmenu.c stest.c util.c
OBJ = $(SRC:.c=.o)

all: font options dmenu stest

options:
	@echo dmenu build options:
	@echo "CFLAGS   = $(CFLAGS)"
	@echo "LDFLAGS  = $(LDFLAGS)"
	@echo "CC       = $(CC)"

font:
	mkdir -p /usr/share/fonts/robotomono-nerd
	cp -f robotomono-nerd-medium.ttf /usr/share/fonts/robotomono-nerd/

.c.o:
	$(CC) -c $(CFLAGS) $<

$(OBJ): arg.h config.mk drw.h

dmenu: dmenu.o drw.o util.o
	$(CC) -o $@ dmenu.o drw.o util.o $(LDFLAGS)

stest: stest.o
	$(CC) -o $@ stest.o $(LDFLAGS)

clean:
	rm -f dmenu stest $(OBJ) dmenu-$(VERSION).tar.gz

dist: clean
	mkdir -p dmenu-$(VERSION)
	cp LICENSE Makefile README arg.h config.mk dmenu.1\
		drw.h util.h dmenu_path dmenu_run stest.1 $(SRC)\
		dmenu-$(VERSION)
	tar -cf dmenu-$(VERSION).tar dmenu-$(VERSION)
	gzip dmenu-$(VERSION).tar
	rm -rf dmenu-$(VERSION)

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f dmenu dmenu_path dmenu_run stest $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu_path
	chmod 755 $(DESTDIR)$(PREFIX)/bin/dmenu_run
	chmod 755 $(DESTDIR)$(PREFIX)/bin/stest
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < dmenu.1 > $(DESTDIR)$(MANPREFIX)/man1/dmenu.1
	sed "s/VERSION/$(VERSION)/g" < stest.1 > $(DESTDIR)$(MANPREFIX)/man1/stest.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/dmenu.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/stest.1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/dmenu\
		$(DESTDIR)$(PREFIX)/bin/dmenu_path\
		$(DESTDIR)$(PREFIX)/bin/dmenu_run\
		$(DESTDIR)$(PREFIX)/bin/stest\
		$(DESTDIR)$(MANPREFIX)/man1/dmenu.1\
		$(DESTDIR)$(MANPREFIX)/man1/stest.1
	rm -f /usr/share/fonts/robotomono-nerd/robotomono-nerd-medium.ttf

indent:
	indent --blank-lines-after-procedures --brace-indent0 --indent-level4 \
		--no-space-after-casts --no-space-after-function-call-names \
		--dont-break-procedure-type --format-all-comments \
		--line-length100 --comment-line-length100 --tab-size4 *.{c,h}

check-indentation:
	$(eval SOURCES := $(shell ls *.{c,h}))
	for i in $(SOURCES); do \
		export DIFFS=$$(diff $$i <(indent -st -bap -bli0 -i4 -ncs -npcs -npsl -fca -l100 -lc100 -ts4 $$i)); \
		if [ -z "$$DIFFS" ]; then echo -e "\033[0;32mValid indentation format -> $$i\033[0m"; else echo -e "\033[0;31mInvalid indentation format -> $$i\033[0m"; fi \
	done

check:
	@echo Checking indentation standards
	$(MAKE) check-indentation

.PHONY: all options clean dist install uninstall indent check-indentation check

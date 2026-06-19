VERSION = 0.92
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

all: noice

noice: noice.h
	cc ${DFLAGS} noice.c -Wall -Wextra -Wno-missing-field-initializers -O2 -o $@ -lncurses

noice.h:
	cp noice.def.h $@

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f noice ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/noice
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	cp -f noice.1 ${DESTDIR}${MANPREFIX}/man1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/noice.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/noice
	rm -f ${DESTDIR}${MANPREFIX}/man1/noice.1

dist: clean
	mkdir -p noice-${VERSION}
	cp `find . -maxdepth 1 -type f` noice-${VERSION}
	tar -c noice-${VERSION} | gzip > noice-${VERSION}.tar.gz

clean:
	rm -f noice noice.o noice-${VERSION}.tar.gz
	rm -rf noice-${VERSION}

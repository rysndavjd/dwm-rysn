# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dwm.c util.c
OBJ = ${SRC:.c=.o}

all: options dwm

options:
	@echo dwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.mk

cpptime:
	$(MAKE) -C cpptime.d

dwm: ${OBJ} cpptime
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	$(MAKE) -C cpptime.d clean
	rm -f dwm ${OBJ} dwm-${VERSION}.tar.gz

release: clean
	mkdir -p dwm-rysn-${VERSION}
	cp -R LICENSE Makefile README config-*.h config.mk patchs dwm-scripts\
		dwm.1 drw.h util.h ${SRC} dwm.png transient.c link.sh\ 
		cpptime.d dwm-rysn-${VERSION}
	tar -cf dwm-rysn-${VERSION}.tar dwm-rysn-${VERSION}
	gzip dwm-rysn-${VERSION}.tar
	rm -rf dwm-rysn-${VERSION}

install: all
	$(MAKE) -C cpptime.d install
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1
	mkdir -p ${DESTDIR}/share/dwm-rysn
	cp -fr dwm-scripts/* ${DESTDIR}/share/dwm-rysn
	chmod 755 ${DESTDIR}/share/dwm-rysn/* -R

uninstall:
	$(MAKE) -C cpptime.d uninstall
	rm -fr ${DESTDIR}${PREFIX}/bin/dwm\
		${DESTDIR}${MANPREFIX}/man1/dwm.1\
		${HELPERPREFIX}

.PHONY: all options clean release install uninstall

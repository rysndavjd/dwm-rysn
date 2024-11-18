# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

DWM_SRC = drw.c dwm.c util.c
DWM_OBJ = ${DWM_SRC:.c=.o}
CPPTIME_SRC = cpptime.cpp

all: options dwm

options:
	@echo cpptime build options:
	@echo "CXXFLAGS = ${CXXFLAGS}"
	@echo "LDFLAGS  = ${CPPTIME_LDFLAGS}"
	@echo "CXX      = ${CXX}"
	@echo ""
	@echo dwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${DWM_LDFLAGS}"
	@echo "CC       = ${CC}"
	@echo ""

.c.o:
	${CC} -c ${CFLAGS} $<

${DWM_OBJ}: config.mk

cpptime:
	${CXX} -o $@ ${CPPTIME_SRC} ${CXXFLAGS} ${CPPTIME_LDFLAGS}
	strip $@ 

dwm: ${DWM_OBJ} cpptime
	${CC} -o $@ ${DWM_OBJ} ${DWM_LDFLAGS}

clean:
	rm -f cpptime 
	rm -f dwm ${DWM_OBJ} dwm-${VERSION}.tar.gz

release: clean
	mkdir -p dwm-rysn-${VERSION}
	cp -R LICENSE Makefile README config-*.h config.mk patchs dwm-scripts\
		dwm.1 drw.h util.h ${DWM_SRC} ${CPPTIME_SRC} dwm.png transient.c\
		link.sh legacy dwm-rysn-${VERSION}
	tar -cf dwm-rysn-${VERSION}.tar dwm-rysn-${VERSION}
	gzip dwm-rysn-${VERSION}.tar
	rm -rf dwm-rysn-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1
	mkdir -p ${DESTDIR}${PREFIX}/share/dwm-rysn
	cp -fr dwm-scripts/* ${DESTDIR}${PREFIX}/share/dwm-rysn
	cp -f cpptime ${DESTDIR}${PREFIX}/share/dwm-rysn/cpptime
	chmod 755 ${DESTDIR}${PREFIX}/share/dwm-rysn/* -R

uninstall:
	rm -fr ${DESTDIR}${PREFIX}/bin/dwm\
		${DESTDIR}${MANPREFIX}/man1/dwm.1\
		${DESTDIR}${PREFIX}/share/dwm-rysn

.PHONY: all options clean release install uninstall

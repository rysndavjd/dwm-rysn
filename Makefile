# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

DWM_SRC = drw.c dwm.c util.c
DWM_OBJ = ${DWM_SRC:.c=.o}
CPPTIME_SRC = cpptime.cpp


all: options dwm cpptime

options:
	@echo cpptime build options:
	@echo "CXXFLAGS = ${CXXFLAGS}"
	@echo "LDFLAGS  = ${CPPTIME_LDFLAGS}"
	@echo "CXX      = ${CXX}"
	@echo ""
	@echo dwm-rysn build options:
	@echo "CONFIG   = ${CONFIG}"
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${DWM_LDFLAGS}"
	@echo "CC       = ${CC}"
	@echo ""

.c.o:
	${CC} -c ${CFLAGS} $<

${DWM_OBJ}: config.h config.mk

config.h:
	ln -srf ./config-${CONFIG}.h ./config.h

cpptime:
	${CXX} -o $@ ${CPPTIME_SRC} ${CXXFLAGS} ${CPPTIME_LDFLAGS}
	strip $@ 

dwm: ${DWM_OBJ}
	${CC} -o $@ ${DWM_OBJ} ${DWM_LDFLAGS}

clean:
	rm -f cpptime 
	rm -f dwm ${DWM_OBJ} dwm-rysn-${VERSION}.tar.gz
	rm -f config.h

release: clean
	mkdir -p dwm-rysn-${VERSION}
	cp -R LICENSE Makefile README config-*.h config.mk patchs addons\
		drw.h util.h ${DWM_SRC} ${CPPTIME_SRC} dwm.png transient.c\
		dwm-rysn.desktop dwm-rysn-${VERSION}
	tar -cf dwm-rysn-${VERSION}.tar dwm-rysn-${VERSION}
	gzip dwm-rysn-${VERSION}.tar
	rm -rf dwm-rysn-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dwm ${DESTDIR}${PREFIX}/bin/dwm-rysn
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm-rysn
	mkdir -p ${DESTDIR}/usr/share/dwm-rysn/dotfiles
	cp -rf addons/dotfiles/${CONFIG}/* ${DESTDIR}/usr/share/dwm-rysn/dotfiles/
	cp -f addons/scripts/* ${DESTDIR}/usr/share/dwm-rysn/
	cp -f cpptime ${DESTDIR}/usr/share/dwm-rysn/cpptime
	chmod 755 ${DESTDIR}/usr/share/dwm-rysn/ -R

uninstall:
	rm -fr ${DESTDIR}${PREFIX}/bin/dwm \
		${DESTDIR}${PREFIX}/share/dwm-rysn

.PHONY: all options clean release install uninstall

include config.mk

SRC = cpptime.cpp

all: options cpptime

options:
	@echo cpptime build options:
	@echo "CXXFLAGS = ${CXXFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CXX      = ${CXX}"

cpptime: 
	${CXX} -o cpptime ${SRC} ${CXXFLAGS} ${LDFLAGS}

clean:
	rm -f cpptime

install: all
	mkdir -p ${DESTDIR}${PREFIX}/share/dwm-rysn
	cp -f cpptime ${DESTDIR}${PREFIX}/share/dwm-rysn
	chmod 755 ${DESTDIR}${PREFIX}/share/dwm-rysn/cpptime
uninstall:
	rm -fr ${DESTDIR}${PREFIX}/share/dwm-rysn/cpptime

.PHONY: all clean

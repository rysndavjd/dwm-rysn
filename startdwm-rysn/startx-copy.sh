#!/usr/bin/sh

#
# This is just a sample implementation of a slightly less primitive
# interface than xinit. It looks for XINITRC and XSERVERRC environment
# variables, then user .xinitrc and .xserverrc files, and then system
# xinitrc and xserverrc files, else lets xinit choose its default.
# The system xinitrc should probably do things like check for
# .Xresources files and merge them in, start up a window manager, and
# pop a clock and several xterms.
#
# Site administrators are STRONGLY urged to write nicer versions.
#

xinitdir=/etc/X11/xinit
xterm=xterm
xserver=/usr/bin/X
xinit=xinit
bundle_id_prefix=org.x
xauth=xauth
bindir=/usr/bin
libexecdir=/usr/libexec
mk_cookie=/usr/bin/mcookie
has_cookie_maker=1

unset SESSION_MANAGER

userclientrc=$HOME/.xinitrc
[ -f "${XINITRC}" ] && userclientrc="${XINITRC}"
sysclientrc=/etc/X11/xinit/xinitrc

userserverrc=$HOME/.xserverrc
[ -f "${XSERVERRC}" ] && userserverrc="${XSERVERRC}"
sysserverrc=$xinitdir/xserverrc
defaultclient=$xterm
defaultserver=$xserver
defaultclientargs=""
defaultserverargs=""
defaultdisplay=""
clientargs=""
serverargs=""
vtarg=""

enable_xauth=1


# Automatically determine an unused $DISPLAY
d=0
while true ; do
    [ -e "/tmp/.X$d-lock" -o -S "/tmp/.X11-unix/X$d" ] ||

        grep -q "/tmp/.X11-unix/X$d" "/proc/net/unix" ||

        break
    d=$(($d + 1))
done
defaultdisplay=":$d"
unset d

whoseargs="client"
while [ "$1" != "" ]; do
    case "$1" in
    # '' required to prevent cpp from treating "/*" as a C comment.
    /''*|\./''*)
 if [ "$whoseargs" = "client" ]; then
     if [ "$client" = "" ] && [ "$clientargs" = "" ]; then
  client="$1"
     else
  clientargs="$clientargs $1"
     fi
 else
     if [ "$server" = "" ] && [ "$serverargs" = "" ]; then
  server="$1"
     else
  serverargs="$serverargs $1"
     fi
 fi
 ;;
    --)
 whoseargs="server"
 ;;
    *)
 if [ "$whoseargs" = "client" ]; then
     clientargs="$clientargs $1"
 else
     # display must be the FIRST server argument
     if [ "$serverargs" = "" ] && \
   expr "$1" : ':[0-9][0-9]*$' > /dev/null 2>&1; then
  display="$1"
     else
  serverargs="$serverargs $1"
     fi
 fi
 ;;
    esac
    shift
done

# process client arguments
if [ "$client" = "" ]; then
    client=$defaultclient

    # For compatibility reasons, only use startxrc if there were no client command line arguments
    if [ "$clientargs" = "" ]; then
        if [ -f "$userclientrc" ]; then
            client=$userclientrc
        elif [ -f "$sysclientrc" ]; then
            client=$sysclientrc
        fi
    fi
fi

# if no client arguments, use defaults
if [ "$clientargs" = "" ]; then
    clientargs=$defaultclientargs
fi

# process server arguments
if [ "$server" = "" ]; then
    server=$defaultserver

if [ "$(uname -s)" = "Linux" ] ; then
    # When starting the defaultserver start X on the current tty to avoid
    # the startx session being seen as inactive:
    # "https://bugzilla.redhat.com/show_bug.cgi?id=806491"
    tty=$(tty)
    if expr "$tty" : '/dev/tty[0-9][0-9]*$' > /dev/null; then
        tty_num=${tty#/dev/tty}
        vtarg="vt$tty_num -keeptty"
    fi
fi

    # For compatibility reasons, only use xserverrc if there were no server command line arguments
    if [ "$serverargs" = "" ] && [ "$display" = "" ]; then
 if [ -f "$userserverrc" ]; then
     server=$userserverrc
 elif [ -f "$sysserverrc" ]; then
     server=$sysserverrc
 fi
    fi
fi

# if no server arguments, use defaults
if [ "$serverargs" = "" ]; then
    serverargs=$defaultserverargs
fi

# if no vt is specified add vtarg (which may be empty)
have_vtarg="no"
for i in $serverargs; do
    if expr "$i" : 'vt[0-9][0-9]*$' > /dev/null; then
        have_vtarg="yes"
    fi
done
if [ "$have_vtarg" = "no" -a x"$vtarg" != x ]; then
    serverargs="$serverargs $vtarg"
    # Fedora specific mod to make X run as non root
    export XORG_RUN_AS_USER_OK=1
fi

# if no display, use default
if [ "$display" = "" ]; then
    display=$defaultdisplay
fi

if [ "$enable_xauth" = 1 ] ; then
    if [ "$XAUTHORITY" = "" ]; then
        XAUTHORITY=$HOME/.Xauthority
        export XAUTHORITY
    fi

    removelist=

    # set up default Xauth info for this machine
    hostname="$(uname -n)"

    authdisplay=${display:-:0}
    if [ -n "$has_cookie_maker" ] && [ -n "$mk_cookie" ] ; then
        mcookie=$($mk_cookie)
    else
        if [ -r /dev/urandom ]; then
            mcookie=$(dd if=dev/urandom bs=16 count=1 2>/dev/null | hexdump -e \\"%08x\\")
        else
            mcookie=$(dd if=/dev/random bs=16 count=1 2>/dev/null | hexdump -e \\"%08x\\")
        fi
    fi
    if [ "$mcookie" = "" ]; then
        echo "Couldn't create cookie"
        exit 1
    fi
    dummy=0

    # create a file with auth information for the server. ':0' is a dummy.
    xserverauthfile=$HOME/.serverauth.$$
    trap "rm -f '$xserverauthfile'" HUP INT QUIT ILL TRAP BUS TERM
    xauth -q -f "$xserverauthfile" << EOF
add :$dummy . $mcookie
EOF

    
    serverargs=${serverargs}" -auth "${xserverauthfile}

    # now add the same credentials to the client authority file
    # if '$displayname' already exists do not overwrite it as another
    # server may need it. Add them to the '$xserverauthfile' instead.
    for displayname in $authdisplay $hostname$authdisplay; do
        authcookie=$(xauth list "$displayname" \
        | sed -n 's/.*'"$displayname"'[[:space:]*].*[[:space:]*]//p' 2>/dev/null);
        if [ "z${authcookie}" = "z" ] ; then
            $xauth -q << EOF
add $displayname . $mcookie
EOF
        removelist="$displayname $removelist"
        else
            dummy=$(($dummy+1));
            $xauth -q -f "$xserverauthfile" << EOF
add :$dummy . $authcookie
EOF
        fi
    done
fi


echo "Client: $client"
echo "clientargs: $clientargs"
echo "server: $server"
echo "display: $display"
echo "serverargs: $serverargs"

$xinit "$client" $clientargs -- "$server" $display $serverargs

retval=$?

if [ "$enable_xauth" = 1 ] ; then
    if [ "$removelist" != "" ]; then
        $xauth remove $removelist
    fi
    if [ "$xserverauthfile" != "" ]; then
        rm -f "$xserverauthfile"
    fi
fi

if command -v deallocvt > /dev/null 2>&1; then
    deallocvt
fi

exit $retval

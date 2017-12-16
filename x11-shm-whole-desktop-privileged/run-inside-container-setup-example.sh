#!/bin/bash

# exit on empty variables
set -u

# exit on non-zero status
set -e

# This is an _example_ of a setup script to set up a usable desktop. It is a copy of my personal script and has been heavily gutted, so there are empty steps.

# 1 == do not install all apps, just a few internet-facing apps
ONLYINETAPPSKRBWORK=0

MYCONFDIR=$(pwd)
MAINUSERNAME=TODOusername

if [[ $# == 0 ]]; then
    echo "Supply numbers as arguments to perform the individual steps of setup from 1."
    echo "If everything works fine, it is enough to start from 1 and it will auto-execute the rest."
    exit 1
fi


if [[ $1 == "1" ]]; then
    echo "Running step $1"

    ln -s /usr/share/zoneinfo/Europe/Prague /etc/localtime -f || true

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "2" ]]; then
    echo "Running step $1"

    # don't exit on non-zero status
    set +e

    # sudo
    usermod -a $MAINUSERNAME -G wheel

    # add a second user for recovery tasks
    useradd -m -G wheel admin

    echo "Please set password for $MAINUSERNAME:"
    if passwd $MAINUSERNAME ; then
        # all good
        :
    else
        echo "Hey, really, please set password for $MAINUSERNAME!"
        passwd $MAINUSERNAME || exit 1
    fi

    echo "Please set password for admin:"
    if passwd admin ; then
        # all good
        :
    else
        echo "Hey, really, please set password for admin!"
        passwd admin || exit 1
    fi

    echo "Please set password for root:"
    if passwd root ; then
        # all good
        :
    else
        echo "Hey, really, please set password for root!"
        passwd root || exit 1
    fi

    # exit on non-zero status
    set -e

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi

cd /tmp


if [[ $1 == "3" ]]; then
    echo "Running step $1"

    # enable dnf cache so that dnf history undo works (https://bugzilla.redhat.com/show_bug.cgi?id=1218403)
    echo "keepcache=1" >> /etc/dnf/dnf.conf

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "4" ]]; then
    echo "Running step $1"

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "5" ]]; then
    echo "Running step $1"

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "6" ]]; then
    echo "Running step $1"

    dnf distro-sync -y 

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "7" ]]; then
    echo "Running step $1"

    if [[ $ONLYINETAPPSKRBWORK == 0 ]]
    then
        dnf install @xfce-desktop-environment -y
        dnf install xfce4-whiskermenu-plugin -y 
        dnf install 'xfce4*plugin' -y
        dnf install ristretto xfce4-taskmanager -y
        dnf install -y galculator evince
    fi

    dnf install iotop htop mc nmap seahorse p7zip p7zip-plugins  meld vim-X11 vim-enhanced ncdu bless cups-pdf system-config-users xterm  iftop smem gcc gcc-c++ firefox menulibre mousepad git -y ; 

    dnf install NetworkManager-tui network-manager-applet -y

    dnf install pcmanfm -y ;

    dnf install xdotool wmctrl -y ;

    dnf install wget curl xz sudo -y ;

    echo "status - install2"
    if [[ $ONLYINETAPPSKRBWORK == 1 ]]
    then
        dnf install thunderbird chromium -y ;
        # find the list of normally installed fonts by running the following in a full-fledged distro:
        # dnf list installed '*-fonts*' | awk '{print $1 }' | sed -r 's/(.*)\.[^.]*/\1/g' | tr '\n' ' '
        dnf install -y aajohan-comfortaa-fonts abattis-cantarell-fonts adobe-source-han-sans-cn-fonts adobe-source-han-sans-tw-fonts adobe-source-han-serif-cn-fonts adobe-source-han-serif-tw-fonts dejavu-fonts-common dejavu-sans-fonts dejavu-sans-mono-fonts dejavu-serif-fonts eosrei-emojione-fonts fontawesome-fonts gdouros-symbola-fonts gnu-free-fonts-common gnu-free-mono-fonts gnu-free-sans-fonts gnu-free-serif-fonts google-android-emoji-fonts google-crosextra-caladea-fonts google-crosextra-carlito-fonts google-noto-emoji-color-fonts google-noto-fonts-common google-noto-sans-lisu-fonts google-noto-sans-mandaic-fonts google-noto-sans-meetei-mayek-fonts google-noto-sans-sinhala-fonts google-noto-sans-tagalog-fonts google-noto-sans-tai-tham-fonts google-noto-sans-tai-viet-fonts jomolhari-fonts julietaula-montserrat-fonts khmeros-base-fonts khmeros-fonts-common liberation-fonts-common liberation-mono-fonts liberation-sans-fonts liberation-serif-fonts libreoffice-opensymbol-fonts lohit-assamese-fonts lohit-bengali-fonts lohit-devanagari-fonts lohit-gujarati-fonts lohit-gurmukhi-fonts lohit-kannada-fonts lohit-odia-fonts lohit-tamil-fonts lohit-telugu-fonts naver-nanum-fonts-common naver-nanum-gothic-fonts paktype-naskh-basic-fonts paratype-pt-sans-fonts sil-abyssinica-fonts sil-mingzat-fonts sil-nuosu-fonts sil-padauk-fonts smc-fonts-common smc-meera-fonts stix-fonts tabish-eeyek-fonts thai-scalable-fonts-common thai-scalable-waree-fonts urw-base35-bookman-fonts urw-base35-c059-fonts urw-base35-d050000l-fonts urw-base35-fonts urw-base35-fonts-common urw-base35-gothic-fonts urw-base35-nimbus-mono-ps-fonts urw-base35-nimbus-roman-fonts urw-base35-nimbus-sans-fonts urw-base35-nimbus-sans-narrow-fonts urw-base35-p052-fonts urw-base35-standard-symbols-ps-fonts urw-base35-z003-fonts vlgothic-fonts xorg-x11-fonts-ISO8859-1-100dpi xorg-x11-fonts-Type1 xorg-x11-fonts-misc || true
    else

        dnf install xournal  keepassx redshift pdfmod libreoffice libreoffice-pdfimport libreoffice-langpack-cs hunspell-cs hunspell-en-US bleachbit  powertop     genisoimage  -y ; 

        dnf install gimp gstreamer-plugins-good gstreamer-plugins-base  gstreamer-plugins-good-extras thunderbird recoll catdoc stardict stardict-dic-cs_CZ stardict-dic-en kleopatra antiword  -y ; 

        dnf install httrack -y; # fc24

        dnf install python-devel python-tools -y ; 

        dnf install okular -y ;

        dnf install selinux-policy-devel  setools-console   policycoreutils-gui -y

        dnf install selinux-policy-sandbox policycoreutils-sandbox -y

        dnf install arandr -y

        dnf install grive2 -y

        dnf install chromium links -y

        dnf install autoconf automake autoconf-archive libtool cmake -y

        dnf install highlight figlet links asciidoc fontawesome-fonts unclutter       -y

        dnf install vmtouch blktrace hdparm libcgroup-tools cpulimit -y

        dnf install fuse-encfs -y

    fi

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "8" ]]; then
    echo "Running step $1"

    # don't exit on non-zero status
    set +e

    echo "status - work xarchiver"

    # fix archiver in xfce (xarchiver sucks balls)
    dnf remove xarchiver -y ; 
    dnf install file-roller -y ;
    cd /usr/libexec/thunar-archive-plugin/ && ln -s file-roller.tap org.gnome.FileRoller.tap && cd - ; 
    update-desktop-database ; 

    # exit on non-zero status
    set -e

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "9" ]]; then
    echo "Running step $1"

    dnf install gnupg -y

    dnf install sssd krb5-workstation pam_krb5 -y

    if [[ $ONLYINETAPPSKRBWORK == 0 ]]
    then
        dnf install ansible -y
    fi

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "10" ]]; then
    echo "Running step $1"

    dnf install hexchat -y

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "11" ]]; then
    echo "Running step $1"

    # cups disable webinterface
    cp /etc/cups/cupsd.conf /etc/cups/cupsd.conf.tmp && cat /etc/cups/cupsd.conf.tmp | sed "s/^WebInterface Yes/WebInterface No/g" > /etc/cups/cupsd.conf && rm -f /etc/cups/cupsd.conf.tmp
    systemctl restart cups.service || true

    # cups-pdf
    cp /etc/cups/cups-pdf.conf /etc/cups/cups-pdf.conf.tmp && cat /etc/cups/cups-pdf.conf.tmp | sed "s/^Out \${DESKTOP}/Out \${HOME}\/PDF/g" > /etc/cups/cups-pdf.conf && rm -f /etc/cups/cups-pdf.conf.tmp

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "12" ]]; then
    echo "Running step $1"

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "13" ]]; then
    echo "Running step $1"

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "14" ]]; then
    echo "Running step $1"

    cp /etc/pulse/default.pa /etc/pulse/default.pa.tmp && cat /etc/pulse/default.pa.tmp | sed "s/^load-module module-role-cork/\#load-module module-role-cork/g"  > /etc/pulse/default.pa && rm -f /etc/pulse/default.pa.tmp

    pactl unload-module module-role-cork || true

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "15" ]]; then
    echo "Running step $1"

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi

cd /tmp


if [[ $1 == "16" ]]; then
    echo "Running step $1"

    # bash settings for the root user
    cat >> ~/.bashrc << EOF

export HISTSIZE="100000"

# https://stackoverflow.com/questions/791765/unable-to-forward-search-bash-history-similarly-as-with-ctrl-r
# disable XON/XOFF so that forward search in readline works (CTRL+S)
stty -ixon

EOF

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "17" ]]; then
    echo "Running step $1"

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "18" ]]; then
    echo "Running step $1"

    dnf install sssd krb5-workstation pam_krb5 -y
    dnf install authconfig -y

    echo "Continue with step $(( $1 + 1 ))"
    cd "$MYCONFDIR" && bash "$0" "$(( $1 + 1 ))"
    exit 0
fi


if [[ $1 == "19" ]]; then
    echo "Running step $1"
    echo "This is the last and empty step. The setup is completed"
    exit 0
fi

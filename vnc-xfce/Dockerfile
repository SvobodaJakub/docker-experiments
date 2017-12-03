FROM fedora:27

RUN dnf install procps-ng tigervnc-server firefox xeyes lxterminal -y
# not doing the whole dnf install @xfce-desktop-environment
# can be started with xfce4-session
RUN dnf install -y xfce4-session xfce4-panel thunar xfce4-settings xfwm4 xfdesktop xfce4-appfinder tumbler xfce4-terminal xfce4-whiskermenu-plugin xfce4-clipman-plugin  xfce4-screenshooter adwaita-gtk2-theme bash-completion fedora-icon-theme gnu-free-serif-fonts gnu-free-sans-fonts gnu-free-mono-fonts  gtk-xfce-engine liberation-serif-fonts liberation-sans-fonts liberation-mono-fonts 
# just assuming the uid and gid will be 1000
RUN useradd -m user
USER user
ENV HOME /home/user
EXPOSE 5901
RUN echo "#!/bin/sh " > /home/user/vnc.sh ; echo "rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1" >> /home/user/vnc.sh ; echo "echo enter password for vnc ; vncpasswd " >> /home/user/vnc.sh ; echo "vncserver :1 -geometry 1300x680 -depth 24 " >> /home/user/vnc.sh ; chmod a+x /home/user/vnc.sh

# build with 
# docker build -t vncxfcetest1 /path/to/dockerfile/

# then run without privileges (removes the container as soon as it exits)
# docker run -it --name vnctest1-1 --rm --env DISPLAY=":1" --user 1000:1000 --cap-drop=ALL --security-opt=no-new-privileges -p 127.0.0.1:5901:5901 vncxfcetest1 bash

# or with privileges (root shell is then able to install stuff)
# docker run -it --name vnctest1-1 --env DISPLAY=":1" --user 1000:1000  -p 127.0.0.1:5901:5901 vncxfcetest1 bash

# if the container already exists, start with:
# docker start vnctest1-1

# if the container is already running, start a user shell with:
# docker exec -it --user 1000:1000 vnctest1-1 bash

# to run a root shell concurrently:
# docker exec -it --user 0:0 vnctest1-1 bash


# connect with e.g.
# vinagre 127.0.0.1:5901


# after start, run on the command line:
# ~/vnc.sh
# and then you can e.g. run xfce4-session or lxterminal or firefox or whatever


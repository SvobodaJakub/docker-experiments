FROM fedora:27

# Barebones dockerfile for running X11 apps on host's X11 server with shared memory (fast graphics) insecurely (poor sandboxing).

RUN dnf install procps-ng firefox xeyes lxterminal -y
# not doing the whole dnf install @xfce-desktop-environment
# can be started with xfce4-session
RUN dnf install -y xfce4-session xfce4-panel thunar xfce4-settings xfwm4 xfdesktop xfce4-appfinder tumbler xfce4-terminal xfce4-whiskermenu-plugin xfce4-clipman-plugin  xfce4-screenshooter adwaita-gtk2-theme bash-completion fedora-icon-theme gnu-free-serif-fonts gnu-free-sans-fonts gnu-free-mono-fonts  gtk-xfce-engine liberation-serif-fonts liberation-sans-fonts liberation-mono-fonts 
# just assuming the uid and gid will be 1000
RUN useradd -m user
USER user
ENV HOME /home/user


# https://stackoverflow.com/a/29658804 says:
# > The two additional parameters are
# > 
# >     --ipc=host allows the container to use the same IPC namespace as the host and hence also has access to the same shared memory segments
# >     --pid=host lets the container see (and modify) the processes of the host. This is necessary, since X server port locking is done via /tmp/.Xi-lock lock files (replace i with your display port), which contains the pid of the X server running on port i.
# > 
# > You also have to change -v /tmp/.X11-unix:/tmp/.X11-unix to -v /tmp:/tmp in order to access the lock files in addition to the X11 unix socket within the container.
# > 
# > Although this works pretty well, you have to be aware that the two additional parameters and the access to the host's /tmp folder grant the container significant privileges which might pose a security risk in certain situations.


# build with 
# docker build -t x11xfcetest1 /path/to/dockerfile/

# then run without privileges (removes the container as soon as it exits)
# docker run -it --name x11test1-1 --rm  -v /tmp:/tmp --ipc=host --pid=host --env DISPLAY="$DISPLAY" --user 1000:1000 --cap-drop=ALL --security-opt=no-new-privileges x11xfcetest1 bash

# or with privileges (root shell is then able to install stuff)
# docker run -it --name x11test1-1 -v /tmp:/tmp --ipc=host --pid=host --env DISPLAY="$DISPLAY" --user 1000:1000  x11xfcetest1 bash

# if the container already exists, start with:
# docker start x11test1-1

# if the container is already running, start a user shell with:
# docker exec -it --user 1000:1000 x11test1-1 bash

# to run a root shell concurrently:
# docker exec -it --user 0:0 x11test1-1 bash


# after start, run on the command line e.g.:
# lxterminal
# and then you can e.g. run xfce4-session or lxterminal or firefox or whatever


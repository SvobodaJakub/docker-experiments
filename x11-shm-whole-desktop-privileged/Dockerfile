FROM fedora:27

# A dockerfile for running xfce desktop and X11 apps on host's X11 server with shared memory (fast
# graphics) insecurely (poor sandboxing).

# Docker is misused to provide a semi-standardized non-VM environment. Its ephemeral container
# features and sandboxing features are not used.

# It is possible to
# * run a desktop environment and apps from e.g. Fedora 27 on top of e.g. CentOS 7 using this
#   dockerfile.
# * run X11 apps that use shared memory (shm) for 2D acceleration
# * play and record audio (PulseAudio server on host required)
# * use webcam
# * use non-LSM-based sandboxed solutions like firejail, chromium
# * install and update packages like on a normal system
# * format flash drives (be careful, though, mounting from inside the container is untested, and any
#   LUKS/DM-crypt/LVM integration with the host is untested)
# * run VirtualBox (prerequisite is to install VirtualBox both on the host and inside the container)
# * run Docker (runs sibling containers, it is not docker-in-docker, see
#   https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/ )


# Security considerations:
# * It is just as secure as running the desktop environment directly without docker and without
#   SELinux/AppArmor.
# * You can improve security by e.g. using firejail to sandbox individual applications.
# * X11 is shared by all applications and therefore any app can attack X11 or sniff keystrokes from
#   other apps. Use e.g. firejail --x11 to sandbox X11 for individual apps.
# * --privileged is necessary for chromium or firejail to work
# * --security-opt label:disable is needed 
#     * so that /host_bind_mnt_run/media/ is accessible
#     * so that host's webcamera works inside the "container"
# * -v /dev:/dev is needed so that newly connected media are visible inside the container, which is
#   useful with
#     * VirtualBox's driver is available immediately after installation in the host, not only after
#       container restart
#     * VirtualBox running from the container but needing physical devices can be used right after
#       connecting the devices without restarting the container
#     * otherwise `--privileged` without `-v /dev:/dev` allows these actions, but the container has
#       to be restarted after each change in /dev for the change to be visible inside the container
# * -v /var/run/docker.sock:/var/run/docker.sock is needed so that docker is usable from within the
#   container, but it allows access to everything about docker on the host - see
#   https://stackoverflow.com/questions/40844197/what-is-the-docker-security-risk-of-var-run-docker-sock#41822163

# pulseaudio integration inspired by
# * https://github.com/TheBiggerGuy/docker-pulseaudio-example/blob/master/pulse-client.conf
# * https://github.com/TheBiggerGuy/docker-pulseaudio-example/blob/master/host_runner.sh
# * https://github.com/TheBiggerGuy/docker-pulseaudio-example/issues/1

# bugs:
# * don't expect 3D games or dual-gpu configurations to work; I have no plan to support this
# * no SELinux inside the container
# * no SELinux isolation between the host and the container
# * not tested on debian/ubuntu (not tested with AppArmor) - probably no isolation and no
#   availability of that as well
# * when routing on the host changes, these changes are not propagated into the container - e.g.
#   when the host connects to a VPN (no idea what's going on or how to fix it, but --net=host doesn't
#   help); a slight workaround is to connect to the VPN in question before starting the container and
#   then the VPN connection can be restarted and still accessible from inside the container as long as
#   the routes remain the same

# TODO/setup:
# * search for all TODO strings and edit them - username, paths
# * check that UID and GID match your host user and change the dockerfile accordingly if they don't
# * read everything
# * do all your setup (dnf install, etc.) inside the container, so that dnf distro-sync doesn't
#   result in multiple copies of the same files and so that the container is sensibly updatable
#   without redownloading everything everytime (the idea is to run a whole graphical system inside a
#   single container)
# * HISTSIZE configures the length of bash history; remove it if you are not interested in keeping
#   long bash history

RUN dnf install procps-ng xeyes lxterminal mc bash-completion setup passwd -y
RUN dnf install pulseaudio-utils -y 
COPY pulse-client.conf /etc/pulse/client.conf

# just assuming the uid and gid will be 1000 and assuming the username on the host also has uid and
# gid 1000
RUN useradd -m TODOUSERNAME
RUN usermod -a TODOUSERNAME -G wheel
RUN usermod -a TODOUSERNAME -G audio
RUN usermod -a TODOUSERNAME -G video
USER TODOUSERNAME
ENV HOME /home/TODOUSERNAME


# https://stackoverflow.com/a/29658804 says:
# > The two additional parameters are
# > 
# >     --ipc=host allows the container to use the same IPC namespace as the host and hence also has access to the same shared memory segments
# >     --pid=host lets the container see (and modify) the processes of the host. This is necessary, since X server port locking is done via /tmp/.Xi-lock lock files (replace i with your display port), which contains the pid of the X server running on port i.
# > 
# > You also have to change -v /tmp/.X11-unix:/tmp/.X11-unix to -v /tmp:/tmp in order to access the lock files in addition to the X11 unix socket within the container.
# > 
# > Although this works pretty well, you have to be aware that the two additional parameters and the access to the host's /tmp folder grant the container significant privileges which might pose a security risk in certain situations.


# build the image with 
# docker build -t x11shmworkmainf27 /path/to/dockerfile/


# create and run a new container
# docker run -it --name x11shmworkmainfc27c1 -h x11shmworkmainfc27c1 -v /tmp:/tmp -v /home/TODOUSERNAME/dockerfiles/x11-shm-work-main-home:/home/TODOUSERNAME -v /run/user/1000/pulse:/run/user/1000/pulse -v /var/run/docker.sock:/var/run/docker.sock --ipc=host -v /run:/host_bind_mnt_run --pid=host --env HISTSIZE=100000 --env DISPLAY="$DISPLAY" --env PULSE_SERVER=unix:/run/user/1000/pulse/native -v /dev:/dev --user 1000:1000 --privileged=true --security-opt label:disable x11shmworkmainf27 bash -c 'cd ~ ; source ~/.bash_profile ; bash'

# now is the time to install xfce and everything in the _container_ (not into the image)

# run for a second, third, etc. time together with session startup
# ( cd /home/TODOUSERNAME/dockerfiles/x11-shm-work-main-home/ ; systemctl start docker ; docker restart x11shmworkmainfc27c1 ; docker exec -it --user 1000:1000 x11shmworkmainfc27c1 bash -c 'cd ~ ; source ~/.bash_profile ; xfce4-session ' ; )


# if the container is already running, start another user shell with:
# docker exec -it --env HISTSIZE=100000 --env DISPLAY="$DISPLAY" --env PULSE_SERVER=unix:/run/user/1000/pulse/native --user 1000:1000 x11shmworkmainfc27c1 bash -c 'cd ~ ; source ~/.bash_profile ; bash'
# older docker doesn't have --env:
# docker exec -it --user 1000:1000 x11shmworkmainfc27c1 bash -c 'cd ~ ; source ~/.bash_profile ; bash'


# to run a root shell concurrently:
# docker exec -it --user 0:0 x11shmworkmainfc27c1 bash


# if host runs lxde, prepare it like this:
# killall xfconfd pcmanfm lxclipboard menu-cached clipit xfce4-notifyd xfwm4

# if host runs xfce, prepare it like this:
# killall Thunar xfdesktop xfsettingsd tumblerd xfconfd xfce-polkit xscreensaver gvfsd-trash thunar -9
# (several times until desktop goes out)
# or
# for i in {1..10} ; do killall Thunar xfdesktop  tumblerd  xscreensaver thunar xfce-polkit -9 ; sleep 0.1 ; done ; killall xfsettingsd ;

# once container is running and host desktop has been prepared (above), start session using
# xfce4-session
# and then run
# ( killall xfwm4 ; sleep 1 ; xfwm4 --replace ; sleep 6 ; xfwm4 --replace ; sleep 6 ; xfwm4 --replace ; sleep 6 ; xfwm4 --replace ; sleep 6 ; xfwm4 --replace ; ) & sleep 10 ; xfce4-panel --quit ; sleep 4 ; xfce4-panel & 
# (don't forget to have a button / script in host ready to start the window manager in case the docker container exits)







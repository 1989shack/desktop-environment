REPO_ROOT=$(dirname $(readlink -f $0))/../..

# Export desktop environment shell configuration
eval "$($REPO_ROOT/docker/scripts/environment.sh)"

# Ensure volumes that can be removed are owned before starting
$REPO_ROOT/docker/scripts/clean.sh

# Ensure the desktop environment network exists
docker network create $DESKTOP_ENVIRONMENT_DOCKER_NETWORK

# Start the desktop environment container
docker run \
  --cap-add NET_ADMIN \
  --cap-add SYS_PTRACE \
  --cap-add AUDIT_CONTROL \
  --cap-add AUDIT_READ \
  --cap-add AUDIT_WRITE \
  --cap-add BLOCK_SUSPEND \
  --cap-add CHOWN \
  --cap-add DAC_OVERRIDE \
  --cap-add DAC_READ_SEARCH \
  --cap-add FOWNER \
  --cap-add FSETID \
  --cap-add IPC_LOCK \
  --cap-add IPC_OWNER \
  --cap-add KILL \
  --cap-add LEASE \
  --cap-add LINUX_IMMUTABLE \
  --cap-add MAC_ADMIN \
  --cap-add MAC_OVERRIDE \
  --cap-add MKNOD \
  --cap-add NET_ADMIN \
  --cap-add NET_BIND_SERVICE \
  --cap-add NET_BROADCAST \
  --cap-add NET_RAW \
  --cap-add SETGID \
  --cap-add SETFCAP \
  --cap-add SETPCAP \
  --cap-add SETUID \
  --cap-add SYS_ADMIN \
  --cap-add SYS_BOOT \
  --cap-add SYS_CHROOT \
  --cap-add SYS_MODULE \
  --cap-add SYS_NICE \
  --cap-add SYS_PACCT \
  --cap-add SYS_PTRACE \
  --cap-add SYS_RAWIO \
  --cap-add SYS_RESOURCE \
  --cap-add SYS_TIME \
  --cap-add SYS_TTY_CONFIG \
  --cap-add SYSLOG \
  --detach \
  --device /dev/dri \
  --device /dev/fuse \
  --device /dev/input \
  --device /dev/snd \
  --device /dev/tty1 \
  --device /dev/video0 \
  --env DESKTOP_ENVIRONMENT_USER \
  --env DISPLAY=:0 \
  --group-add audio \
  --group-add docker \
  --group-add input \
  --group-add plugdev \
  --group-add tty \
  --group-add video \
  --hostname $DESKTOP_ENVIRONMENT_REGISTRY-$DESKTOP_ENVIRONMENT_CONTAINER_NAME-$(hostname) \
  --interactive \
  --name $DESKTOP_ENVIRONMENT_CONTAINER_NAME \
  --network host \
  --rm \
  --security-opt seccomp:$REPO_ROOT/docker/config/chrome/chrome.json \
  --user $DESKTOP_ENVIRONMENT_USER \
  --volume /dev/shm:/dev/shm \
  --volume /run/udev:/run/udev \
  --volume /var/lib/docker:/var/lib/docker \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume DESKTOP_ENVIRONMENT_CACHE_CERTIFICATES:$DESKTOP_ENVIRONMENT_CACHE_CERTIFICATES \
  --volume DESKTOP_ENVIRONMENT_CACHE_CHROME:$DESKTOP_ENVIRONMENT_CACHE_CHROME \
  --volume DESKTOP_ENVIRONMENT_CACHE_CODE:$DESKTOP_ENVIRONMENT_CACHE_CODE \
  --volume DESKTOP_ENVIRONMENT_CACHE_GDRIVE:$DESKTOP_ENVIRONMENT_CACHE_GDRIVE \
  --volume DESKTOP_ENVIRONMENT_CACHE_SECRETS:$DESKTOP_ENVIRONMENT_CACHE_SECRETS \
  --volume DESKTOP_ENVIRONMENT_CACHE_SSH:$DESKTOP_ENVIRONMENT_CACHE_SSH \
  --volume DESKTOP_ENVIRONMENT_CACHE_STEMN:$DESKTOP_ENVIRONMENT_CACHE_STEMN \
  --volume DESKTOP_ENVIRONMENT_CACHE_TMUX:$DESKTOP_ENVIRONMENT_CACHE_TMUX \
  --volume DESKTOP_ENVIRONMENT_CACHE_YARN:$DESKTOP_ENVIRONMENT_CACHE_YARN \
  --volume DESKTOP_ENVIRONMENT_CACHE_ZOOM:$DESKTOP_ENVIRONMENT_CACHE_ZOOM \
  --volume DESKTOP_ENVIRONMENT_CACHE_ZSH:$DESKTOP_ENVIRONMENT_CACHE_ZSH \
  --volume DESKTOP_ENVIRONMENT_STATE_CHROME:$DESKTOP_ENVIRONMENT_STATE_CHROME \
  --volume DESKTOP_ENVIRONMENT_STATE_CODE:$DESKTOP_ENVIRONMENT_STATE_CODE \
  --volume DESKTOP_ENVIRONMENT_STATE_GITHUB:$DESKTOP_ENVIRONMENT_STATE_GITHUB \
  --volume DESKTOP_ENVIRONMENT_STATE_JUMP:$DESKTOP_ENVIRONMENT_STATE_JUMP \
  --volume DESKTOP_ENVIRONMENT_STATE_MUSIKCUBE:$DESKTOP_ENVIRONMENT_STATE_MUSIKCUBE \
  --volume DESKTOP_ENVIRONMENT_STATE_RESCUETIME:$DESKTOP_ENVIRONMENT_STATE_RESCUETIME \
  --volume DESKTOP_ENVIRONMENT_STATE_SIGNAL:$DESKTOP_ENVIRONMENT_STATE_SIGNAL \
  --volume DESKTOP_ENVIRONMENT_STATE_SLACK:$DESKTOP_ENVIRONMENT_STATE_SLACK \
  --volume DESKTOP_ENVIRONMENT_STATE_ZOOM:$DESKTOP_ENVIRONMENT_STATE_ZOOM \
  --volume DESKTOP_ENVIRONMENT_USER_DOCUMENTS:$DESKTOP_ENVIRONMENT_USER_DOCUMENTS \
  --volume DESKTOP_ENVIRONMENT_USER_DOWNLOADS:$DESKTOP_ENVIRONMENT_USER_DOWNLOADS \
  --volume DESKTOP_ENVIRONMENT_USER_GO:$DESKTOP_ENVIRONMENT_USER_GO \
  --volume DESKTOP_ENVIRONMENT_USER_MUSIC:$DESKTOP_ENVIRONMENT_USER_MUSIC \
  --volume DESKTOP_ENVIRONMENT_USER_PICTURES:$DESKTOP_ENVIRONMENT_USER_PICTURES \
  --volume DESKTOP_ENVIRONMENT_USER_REPOSITORIES:$DESKTOP_ENVIRONMENT_USER_REPOSITORIES \
  --volume DESKTOP_ENVIRONMENT_USER_TORRENTS:$DESKTOP_ENVIRONMENT_USER_TORRENTS \
  --volume DESKTOP_ENVIRONMENT_USER_VIDEOS:$DESKTOP_ENVIRONMENT_USER_VIDEOS \
  --workdir $DESKTOP_ENVIRONMENT_USER_HOME \
  $DESKTOP_ENVIRONMENT_REGISTRY/$DESKTOP_ENVIRONMENT_CONTAINER_NAME:$DESKTOP_ENVIRONMENT_CONTAINER_TAG \
  sleep infinity

# Wait until the desktop environment container is running before proceeding
until docker inspect $DESKTOP_ENVIRONMENT_CONTAINER_NAME | grep Status | grep -m 1 running >/dev/null; do sleep 1; done

# Start the desktop environment inside the container
$REPO_ROOT/docker/scripts/exec.sh /home/$DESKTOP_ENVIRONMENT_USER/.config/scripts/startup.sh

REPO_ROOT=$(dirname $(realpath $0))/..

# Export desktop environment shell configuration
export $(sh $REPO_ROOT/scripts/environment.sh)

# Ensure the container user has ownership of the volumes before starting
sh $REPO_ROOT/scripts/bootstrap-volumes.sh

docker run \
  --cap-add=SYS_PTRACE \
  --detach \
  --device /dev/snd \
  --device /dev/dri \
  --device /dev/usb \
  --device /dev/bus/usb \
  --env DISPLAY \
  --env SSH_AUTH_SOCK=$DESKTOP_ENVIRONMENT_HOME/.ssh/auth.sock \
  --env STEMN_GIT_EMAIL="jackson@stemn.com" \
  --env STEMN_GIT_NAME="Jackson Delahunt" \
  --group-add audio \
  --group-add video \
  --interactive \
  --name $DESKTOP_ENVIRONMENT_CONTAINER \
  --net host \
  --rm \
  --security-opt seccomp:$REPO_ROOT/config/chrome/chrome.json \
  --tty \
  --volume /dev/shm:/dev/shm \
  --volume /etc/localtime:/etc/localtime:ro \
  --volume /run/systemd:/run/systemd \
  --volume /tmp/.X11-unix:/tmp/.X11-unix \
  --volume /var/run/dbus:/var/run/dbus \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume $HOME/.config/alacritty:$DESKTOP_ENVIRONMENT_HOME/.config/alacritty \
  --volume $HOME/.pki:$DESKTOP_ENVIRONMENT_HOME/.pki \
  --volume $HOME/.ssh:$DESKTOP_ENVIRONMENT_HOME/.ssh \
  --volume $HOME/notes:$DESKTOP_ENVIRONMENT_HOME/notes \
  --volume $HOME/repositories:$DESKTOP_ENVIRONMENT_HOME/repositories \
  --volume $HOME/Documents:$DESKTOP_ENVIRONMENT_HOME/Documents \
  --volume $HOME/Downloads:$DESKTOP_ENVIRONMENT_HOME/Downloads \
  --volume $HOME/Music:$DESKTOP_ENVIRONMENT_HOME/Music \
  --volume $HOME/Pictures:$DESKTOP_ENVIRONMENT_HOME/Pictures \
  --volume $HOME/Videos:$DESKTOP_ENVIRONMENT_HOME/Videos \
  --volume ${SSH_AUTH_SOCK-$HOME/.ssh/auth.sock}:$DESKTOP_ENVIRONMENT_HOME/.ssh/auth.sock \
  --volume DESKTOP_ENVIRONMENT_CACHE_CHROME:$DESKTOP_ENVIRONMENT_CACHE_CHROME \
  --volume DESKTOP_ENVIRONMENT_CACHE_CODE:$DESKTOP_ENVIRONMENT_CACHE_CODE \
  --volume DESKTOP_ENVIRONMENT_CACHE_JUMP:$DESKTOP_ENVIRONMENT_CACHE_JUMP \
  --volume DESKTOP_ENVIRONMENT_CACHE_YARN:$DESKTOP_ENVIRONMENT_CACHE_YARN \
  --volume DESKTOP_ENVIRONMENT_CACHE_ZSH:$DESKTOP_ENVIRONMENT_CACHE_ZSH \
  --volume DESKTOP_ENVIRONMENT_CONFIG_CHROME:$DESKTOP_ENVIRONMENT_CONFIG_CHROME \
  --volume DESKTOP_ENVIRONMENT_CONFIG_CODE:$DESKTOP_ENVIRONMENT_CONFIG_CODE \
  --volume DESKTOP_ENVIRONMENT_CONFIG_GITHUB:$DESKTOP_ENVIRONMENT_CONFIG_GITHUB \
  --volume DESKTOP_ENVIRONMENT_CONFIG_MUSIKCUBE:$DESKTOP_ENVIRONMENT_CONFIG_MUSIKCUBE \
  --volume DESKTOP_ENVIRONMENT_HOME:$DESKTOP_ENVIRONMENT_HOME \
  --workdir $DESKTOP_ENVIRONMENT_HOME \
  $DESKTOP_ENVIRONMENT_REGISTRY/$DESKTOP_ENVIRONMENT_CONTAINER:latest

# Wait until the container is running before proceeding
until docker inspect $DESKTOP_ENVIRONMENT_CONTAINER | grep Status | grep -m 1 running >/dev/null; do sleep 1; done

REPO_ROOT=$(dirname $(readlink -f $0))/../../..
IMAGE=$(basename $(dirname $(readlink -f $0)))

# Export desktop environment shell configuration
eval "$($REPO_ROOT/docker/scripts/environment.sh)"

# Start the skype container
docker run \
  --detach \
  --env DISPLAY \
  --interactive \
  --name $DESKTOP_ENVIRONMENT_CONTAINER_NAME-$IMAGE \
  --network $DESKTOP_ENVIRONMENT_DOCKER_NETWORK \
  --rm \
  --volume DESKTOP_ENVIRONMENT_STATE_X11:$DESKTOP_ENVIRONMENT_STATE_X11 \
  --volume DESKTOP_ENVIRONMENT_USER_DOCUMENTS:$DESKTOP_ENVIRONMENT_USER_DOCUMENTS \
  --volume DESKTOP_ENVIRONMENT_USER_DOWNLOADS:$DESKTOP_ENVIRONMENT_USER_DOWNLOADS \
  --volume DESKTOP_ENVIRONMENT_USER_PICTURES:$DESKTOP_ENVIRONMENT_USER_PICTURES \
  --volume DESKTOP_ENVIRONMENT_USER_REPOSITORIES:$DESKTOP_ENVIRONMENT_USER_REPOSITORIES \
  $DESKTOP_ENVIRONMENT_REGISTRY/$DESKTOP_ENVIRONMENT_CONTAINER_IMAGE-$IMAGE:$DESKTOP_ENVIRONMENT_CONTAINER_TAG

AUTH_SERVER_NAME="auth.wattaint.net"
AUTH_SERVER_PORT="3001"
SERVICE_SIGNATURE="e10a898a4c2e63b2a4b3c2b7ad029fff835a22f65fe8c2f6aea24631132c22b8"

docker run --rm -it \
--hostname=docker_angs_aboss_report \
-p 3005:3000 \
-e JRUBY_OPTS="-J-Xmx2g -J-Xms1g -Xcompile.invokedynamics=false" \
-e AUTH_SERVER_NAME="$AUTH_SERVER_NAME" \
-e AUTH_SERVER_PORT="$AUTH_SERVER_PORT" \
-e SERVICE_SIGNATURE="$SERVICE_SIGNATURE" \
-v $(pwd)/appserver:/appserver \
--link aboss_auth_dev:$AUTH_SERVER_NAME \
--link angs_aboss_report_postgresql:pg_server \
--privileged \
docker.io/angstroms/angs_aboss_report:latest \
bash

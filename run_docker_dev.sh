WEB_CLIENT_ID="e10a898a4c2e63b2a4b3c2b7ad029fff835a22f65fe8c2f6aea24631132c22b8"
WEB_CLIENT_SECRET="59b3c7ff07cdf26d75b8a5528e98c301794ad112f906fdda3fc3193a0e51c82b"

AUTHORIZE_SERVER_NAME="auth.wattaint.net"
AUTHORIZE_SERVER="http://$AUTHORIZE_SERVER_NAME:3001"
SERVICE_SIGNATURE="e10a898a4c2e63b2a4b3c2b7ad029fff835a22f65fe8c2f6aea24631132c22b8"

docker run --rm -it \
--hostname=docker_angs_aboss_report \
-p 3005:3000 \
-e JRUBY_OPTS="-J-Xmx2g -J-Xms1g -Xcompile.invokedynamics=false" \
-e WEB_CLIENT_ID="$WEB_CLIENT_ID" \
-e WEB_CLIENT_SECRET="$WEB_CLIENT_SECRET" \
-e AUTHORIZE_SERVER="$AUTHORIZE_SERVER" \
-e SERVICE_SIGNATURE="$SERVICE_SIGNATURE" \
-v $(pwd)/appserver:/appserver \
--link aboss_auth_dev:$AUTHORIZE_SERVER_NAME \
--link angs_aboss_report_postgresql:pg_server \
--privileged \
docker.io/angstroms/angs_aboss_report:latest \
bash

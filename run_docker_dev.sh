docker run --rm -it \
--hostname=docker_angs_aboss_report \
-p 3005:3000 \
-e JRUBY_OPTS="-J-Xmx2g -J-Xms1g -J-Xss8192k" \
-v $(pwd)/appserver:/appserver \
--link angs_aboss_report_postgresql:pg_server \
--privileged \
docker.io/angstroms/angs_aboss_report:latest \
bash

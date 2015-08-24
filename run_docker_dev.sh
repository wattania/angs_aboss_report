docker run --rm -it \
-p 3000:3000 \
-v $(pwd)/appserver:/appserver \
--link angs_aboss_report_postgresql:pg_server \
--privileged \
docker.io/angstroms/angs_aboss_report:latest \
bash

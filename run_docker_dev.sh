docker run --rm -it \
-p 8080:8080 \
-v $(pwd)/appserver:/appserver \
--link angs_aboss_report_postgresql:pg_server \
docker.io/angstroms/angs_aboss_report:appserver \
bash

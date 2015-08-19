docker run --rm -it \
-p 54322:5432 \
--volumes-from angs_aboss_report_pg_data \
docker.io/angstroms/angs_aboss_report:pg \
bash

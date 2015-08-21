docker run --rm \
-p 54322:5432 \
-v $(pwd)/scripts/entrypoint.rb:/entry:ro \
--volumes-from angs_aboss_report_pg_data \
--privileged \
docker.io/angstroms/angs_aboss_report:pg \
/entry --initdb
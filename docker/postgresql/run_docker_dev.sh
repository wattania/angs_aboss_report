docker run --rm -it \
-p 54322:5432 \
-v $(pwd)/scripts/entrypoint.rb:/entry \
--volumes-from angs_aboss_report_pg_data \
docker.io/angstroms/angs_aboss_report:pg
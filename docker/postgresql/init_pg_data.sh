docker run --rm -it \
-v $(pwd)/passwd:/passwd \
-v $(pwd)/scripts/init_pg_data.rb:/init_pg_data.rb \
--volumes-from angs_aboss_report_pg_data \
docker.io/angstroms/angs_aboss_report:pg \
ruby /init_pg_data.rb

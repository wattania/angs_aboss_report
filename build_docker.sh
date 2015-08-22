cd docker/appserver \
&& sh build_docker.sh \
&& cd ../.. \
&& docker build -t docker.io/angstroms/angs_aboss_report .

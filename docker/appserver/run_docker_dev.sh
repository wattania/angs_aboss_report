docker run --rm -it \
-p 8080:8080 \
-v $(pwd)/../..:/backup \
docker.io/angstroms/angs_aboss_report:appserver \
bash

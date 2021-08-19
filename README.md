$ docker build . -t container_image:latest

$ docker run  -d --env-file ./.env -p ${EXPOSED_PORT}:80 -v ${PWD}/drupal-data/modules:/var/www/html/modules -v ${PWD}/drupal-data/themes:/var/www/html/themes -v ${PWD}/drupal-data/files:/opt/drupal/web/sites/default/files  --restart=always --name ${CONTAINER_NAME} ${CONTAINER_IMAGE}

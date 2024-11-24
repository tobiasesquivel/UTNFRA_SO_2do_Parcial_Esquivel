#Crear dockerfile
cat << EOF > Dockerfile
 FROM nginx
 COPY index.html /usr/share/nginx/html/index.html
EOF

#Contruir la imagen
docker build -t web1-esquivel .

#Subir la imagen
docker push tobiasesquivel/web1-esquivel

#Crear archivo run.sh
cat << EOF > run.sh
 #!/bin/bash

 #corro la imagen generada anteriormente
 docker run -d -p 8080:80 tobiasesquivel/web1-esquivel
EOF

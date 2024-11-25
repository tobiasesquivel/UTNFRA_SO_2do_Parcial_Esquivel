cat << EOF > Dockerfile
 FROM nginx
 COPY index.html /usr/share/nginx/html/index.html
EOF

docker login -u tobiasesquivel

docker build -t web1-esquivel .

docker push tobiasesquivel/web1-esquivel

cat << EOF > run.sh
 #!/bin/bash

 docker run -d -p 8080:80 tobiasesquivel/web1-esquivel
EOF

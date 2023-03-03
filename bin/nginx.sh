#!/bin/bash
#nginx 웹 서버 설정
#   (ㄱ) 패키지 설치    (yum -y install nginx)
#   (ㄴ) 서버 설정      (echo "<h1>nginx WebServer<h1>" > /usr/share/nginx/html/index.html)
#   (ㄷ) 서비스 기동    (systemctl enable --now nginx.service)
#   (ㄹ) 방화벽 등록
yum -y install nginx \
&& echo "<h1>nginx WebServer</h1>" > /usr/share/nginx/html/index.html \
&& service nginx restart \
&& echo "[ OK ] Nginx Web Server started."

curl localhost


#!/usr/bin/env bash
# automated configuration of web server for web static

# check if nginx is installed
printf "checking if nginx is installed..."
if ! command -v nginx &> /dev/null
then
	printf "nginx not installed\nTrying to install nginx...\n"
	sudo apt-get update;
	sudo apt-get install -y nginx;
fi
printf "nginx is installed\n"
printf "starting nginx...\n"
sudo service start nginx
printf "nginx started!.\n"

if [[ ! -d "/data" ]]
then
	printf "path /data does not exists, creating /data\n"
	sudo mkdir /data/
	printf "path /data created\n"
else
	printf "path /data already exists\n"
fi

if [[ ! -d "/data/web_static/" ]]
then
        printf "path /data/web_static/ does not exists, creating /data/web_static\n"
        sudo mkdir -p /data/web_static/
        printf "path /data/web_static/ created\n"
else
        printf "path /data/web_static/ already exists\n"
fi

if [[ ! -d "/data/web_static/releases/" ]]
then
        printf "path /data/web_static/releases/ does not exists, creating /data/web_static/releases\n"
        sudo mkdir -p /data/web_static/releases/
        printf "path /data/web_static/releases/ created\n"
else
        printf "path /data/web_static/releases/ already exists\n"
fi

if [[ ! -d "/data/web_static/shared" ]]
then
        printf "path /data/web_static/shared does not exists, creating /data/web_static/shared\n"
        sudo mkdir -p /data/web_static/shared
        printf "path /data/web_static/shared created\n"
else
        printf "path /data/web_static/shared already exists\n"
fi

if [[ ! -d "/data/web_static/releases/test" ]]
then
        printf "path /data/web_static/releases/ does not exists, creating /data/web_static/releases/test\n"
        sudo mkdir -p /data/web_static/releases/test
        printf "path /data/web_static/releases/test created\n"
else
        printf "path /data/web_static/releases/test already exists\n"
fi

printf "creating test file, index.html\n"
printf "Hello world" | sudo tee /data/web_static/releases/test/index.html
printf "created /data/web_static/releases/test/index.html\n"

printf "creating symlink /data/web_static/current\n"
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current
printf "created symlink /data/web_static/current\n"

printf "changing ownership of /data to ubuntu:ubuntu\n"
sudo chown -R ubuntu:ubuntu /data
sudo chown -R ubuntu:ubuntu /data/*
printf "user and group of /data changed to ubuntu:ubuntu\n"

sudo sed -i '53i\\tlocation /hbnb_static {\n\t\talias /data/web_static/current;\n\t}' /etc/nginx/sites-available/default

sudo service nginx restart

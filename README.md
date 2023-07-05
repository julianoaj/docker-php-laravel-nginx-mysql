<div align="center">
      <a href="https://alisonjuliano.com">
        <img src="https://imgur.com/13kinqs.jpg">
    </a>
  <p>
    <p style="font-style: italic;">"I decided to follow the path of rabbit hole, let's see how far this can take us" - <a href="https://alisonjuliano.com">AJ</a>
    </p>
    <p style="font-weight: bold;">Sharing, learning and knowing people all around the world. Let's code!</p>
    <a href="https://alisonjuliano.com"> 
    <img src="https://img.shields.io/static/v1?label=Fullstack&message=AJ&color=64ffda&style=for-the-badge&logo=dungeonsanddragons">
    </a>
    <img src="https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white">
    <img src="https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white">
    <img src="https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white">
    <img src="https://img.shields.io/badge/MySQL-00000F?style=for-the-badge&logo=mysql&logoColor=white">
  </p>
</div><br>

<h1> Docker: Nginx, PHP (Laravel) and MySql. </h1>

<p>With Docker Compose I'm running three containers, each one with: Nginx, PHP (with composer, xdebug and configs) and MySql.</p>

<p>
The purpose of this guide is to give some reference and help, don't feel tied to the same configs.
</p>

<section style="padding: 10px;">
<h2>Overview</h2>
<ol>
    <li value="1">
      <p><a href="#prerequisites">Install prerequisites</a></p>
    </li>
    <p>Before doing anything install all prerequisites.</p>
    <li>
      <p><a href="#clone">Clone the project</a> [<code style="color: red">optional</code>]</p>
    </li>
    <p>A simple and a fast way to get this environment.</p>
    <li>
      <p><a href="#docker-commands">Docker used commands.</a></p>
    </li>
    <p>Commands that maybe you will need use to build this environment.</p>
    <li>
      <p><a href="#dic-tree">Directories Tree</a></p>
    </li>
    <p>Where your projects, backup and configs will be.</p>
    <li>
      <p><a href="#makefile">Makefile </a>[<code style="color: red;">optional</code>]</p>
    </li>
    <p>Automating your environment with a makefile.</p>
    <li>
      <p><a href="#setting-php">Setting</a> <code style="color: green;">php.dockerfile</code></p>
    </li>
    <p>Installing xdebug, compose, libs and setting configs.</p>
    <li>
      <p><a href="#conf-nginx">Setting Nginx With SSL Certificates. [<code style="color: red">optional</code>]</a></p>
    </li>
    <p>Setting PHP-FPM for Nginx, generating our SSL certificate and setting it on our server.</p>
    <li>
      <p><a href="#docker-compose">docker-compose.yml</a></p>
    </li>
    <p>Building our images in containers.</p>
    <li>
      <p><a href="#test-db">Running and testing our project.</a></p>
    </li>
</ol>
</section>
<hr>

<section id="prerequisites" style="padding: 10px;">
<h2> Install prerequisites </h2>
<p>This environment was created on windows but all docker things will work on any SO. Just follow install instructions on documentation:</p>
<ul>
  <li><a href="https://docs.docker.com/engine/install/">Docker</a></li>
  <li><a href="https://docs.docker.com/compose/install/">Docker Compose</a></li>
</ul>
<p>Check if all dependencies is installed by entering the following command's in your terminal:</p>
<pre>
docker-compose 
docker -v
</pre>
<blockquote>
[<code>docker-compose</code>] will print all docker-compose commands and [<code>docker -v</code>] will print docker version.
</blockquote><br>
<p>Optional tools:</p>
<ul>
  <li><a href="https://git-scm.com/downloads">Git</a></li>
  <li><a href="https://chocolatey.org/install">Make</a> (via chocolatey)</li>
</ul>
</section>
<hr>

<section id="clone" style="padding: 10px;">
<h2>Clone the project</h2>
<p>A simple and a fast way to you get this environment is to clone my project into a directory, open your terminal, navigate into project cloned directory and write some commands:</p>
<pre>
docker-compose build
docker-compose up -d
</pre>
<p>Check <a href="http://localhost:80">localhost</a> in your browser and voilá</p>
<h3>Ports used on the project:</h3>
<ul>
<li>http ->  80</li>
<li>https -> 443</li>
<li>php ->   9000</li>
<li>mysql -> 3306</li>
</ul><br>
</section>
<hr>

<section id="docker-commands" style="padding: 10px;">
<h2>Docker commands</h2>
<p>
  Docker have a nice documentation (in my opinion) with all their commands, if what you want is not here, check the <a href="https://docs.docker.com/engine/reference/run/">link.</a>
</p>
<h3>Nginx restart server:</h3>
<pre>
  docker exec [CONTAINER] nginx -s reload
</pre>
<h3>Installing a package with composer:</h3>
<pre>
  docker run --rm -v $(pwd)/web/app:/app composer create-project laravel/laravel example-app
</pre>
<h3>Updating PHP dependencies with composer :</h3>
<pre>
  docker run --rm -v $(pwd)/web/app:/app composer update
</pre>
<h3>Checking installed PHP extensions :</h3>
<pre>
  docker-compose exec php php -m
</pre>
<h3>Get in of PHP interactive terminal :</h3>
<pre>
  docker-compose exec php php -a
</pre>
<h3>MySQL shell access :</h3>
<pre>
  docker exec -it mysql bash
  mysql -u"$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD"
</pre>
</section>
<hr>

<section id="dic-tree" style="padding: 10px;">
<h2>Directories Tree</h2>
<p>Before we start to configure our environment we need a directories tree. Here you can choose where your projects, backup's, servers and configs will be.</p>
<h3>My project tree:</h3>
<pre>
\---environmentProject
    |   docker-compose.yml
    |   Makefile
    |   nginx.dockerfile
    |   php.dockerfile
    |   README.md
    |
    +---confs
    |   +---Mysql_db
    |   |       backup.ibd
    |   |
    |   +---servers
    |   |       server.conf
    |   |
    |   \---ssl
    |           localhost.crt
    |           localhost.key
    |
    \---projects
        \---www
                index.php
</pre>
</section>
<hr>

<section id="makefile" style="padding: 10px;">
<h2>Makefile</h2>
<p>Instead of typing complexes commands in your terminal, you can use a Makefile to simplifying.</p>
<p>Prerequisite to use a Makefile is to install [<code>make</code>] command.</p>
<p>
  With [<code>make</code>] installed, I don't recommend, but you can clone my repository and use my Makefile with some already defined shortcut commands. If you're going to use it, make sure that your containers are named with the same name as mine and remember, I'm using windows and some commands maybe will not work on another SO.
</p>
<table>
  <thead>
    <tr>
      <th>Command</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>reload-nginx</td>
      <td>Restart Nginx web server</td>
    </tr>
    <tr>
      <td>it-php</td>
      <td>Interactive mode on php image</td>
    </tr>
    <tr>
      <td>start-ubuntu</td>
      <td>Start a ubuntu:latest image and remove when works done</td>
    </tr>
    <tr>
      <td>gen-ssl</td>
      <td>Gen Certificate authority (CA) for your browser and webserver</td>
    </tr>
    <tr>
      <td>start-laravel</td>
      <td>Install laravel project via composer</td>
    </tr>
  </tbody>
</table>
<h3>Show help:</h3>
<pre>
make help
</pre>
<blockquote>
Pre requisite of this section: make, clone my project and Windows 10 user.
</blockquote>
</section>
<hr>

<section id="setting-php" style="padding: 10px;">
<h2>Setting <code>php.dockerfile</code></h2>
<p>Its time to we build our PHP container with xdebug, composer and configs inside a Dockerfile. Create the file inside follow path: <code>/environmentProject/php.dockerfile</code></p>
<p>Inside the file we'll set our PHP 8.2 FPM version. To use it we need a tag that we can find on dockerhub. With tag in hands, our first line should be:</p>
<pre>
FROM php:8.2-fpm
</pre>
<blockquote>
Versions tag list <a href="https://hub.docker.com/_/php?tab=tags&page=1&ordering=last_updated">here</a>.
</blockquote>
<br>
<h3>Core Extensions:</h3>
<p>Following the version we need to install our core extensions: </p>
<pre>
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql
</pre>
<blockquote>
Some extensions come by default. It depends on the PHP version you are using. Run <code>docker run --rm php:8.2-fpm php -m</code> in the your terminar to see full extension list.
</blockquote>
<br>
<h3><a href="https://pecl.php.net/">PECL</a> extensions:</h3>
<p>Its time to bring some extensions for performance and utility, to it we'll use PECL, a PHP extension repository.<br>
Here we'll install <code>xdebug</code>, <code>libmencached</code> and <code>zlib1g</code>. Lets add some more lines in our dockerfile:</p>
<pre>
RUN pecl install xdebug-3.0.4 \
    && docker-php-ext-enable xdebug
RUN apt-get install -y libmemcached-dev zlib1g-dev \
    && pecl install memcached-3.1.5 \
    && docker-php-ext-enable memcached
</pre>
<blockquote>
 PECL extensions should be installed in series to fail properly if something went wrong. Otherwise errors are just skipped by PECL.
</blockquote>
<br>
<h3>Packages:</h3>
<p>For packages we'll use composer with zip and unzip:</p>
<pre>
RUN apt-get install zip unzip \
    && curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && unlink composer-setup.php
</pre>
<h3>Configs (utils):</h3>
<p>Setting our timezone and activating opcache for performance of PHP:</p>
<pre>
RUN echo 'date.timezone="America/Sao_Paulo"' >> /usr/local/etc/php/conf.d/date.ini \
    && echo 'opcache.enable=1' >> /usr/local/etc/php/conf.d/opcache.conf \
    && echo 'opcache.validate_timestamps=1' >> /usr/local/etc/php/conf.d/opcache.conf \
    && echo 'opcache.fast_shutdown=1' >> /usr/local/etc/php/conf.d/opcache
</pre>
<blockquote>
You can check the list of timezone supported by PHP <a href="https://www.php.net/manual/en/timezones.america.php">here</a>.
</blockquote>
</section>
<hr>

<section id="conf-nginx" style="padding: 10px;">
<h2>Setting Nginx FastCGI with SSL Certificates for PHP and Laravel</h2>
<p>If you want to use PHP and Laravel with Nginx you need to configure <a href="https://en.wikipedia.org/wiki/FastCGI">FastCGI</a> and a few other things. Let's break it into steps:</p>
<ol>
  <li>
    Gen SSL (<code style="color: red;">optional</code>)
    <p>
      You can use my Makefile to gen a SSL with just <code>make gen-ssl</code> in terminal (in case of you are a windows user), or follow the steps of this 
      <a href="https://gist.github.com/cecilemuller/9492b848eb8fe46d462abeb26656c4f8">GUIDE</a>.
    </p>
  </li>
  <li>
    Server <code>server.conf</code>
    <p>
      Create <code>/environmentProject/confs/servers/server.conf</code> file.
    </p>
  </li>
</ol>
<p>Edit <code>server.conf</code>, set a config that listen container port 80 and 443 (ssl port), set <code>ssl_certificate</code> and <code>ssl_certificate_key</code> with your SSL certificates location and pass all FastCGI configs for PHP-FPM. Example:</p>
<pre>
  server {
    ############# Ports #################
    listen 80;
    listen 443 ssl;
    #####################################
    root /var/www/projects/;
    ########## SSL CERTIFICATE ##########
    ssl_certificate /var/www/ssl/localhost.crt;
    ssl_certificate_key /var/www/ssl/localhost.key; <br>
    #####################################
    autoindex on; <br>
    ########## FAST CGI CONFIG ##########
    location ~ \.php$ {
      fastcgi_index index.php;
      fastcgi_pass php:9000;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      include fastcgi_params;
    }
  }
</pre>
  <p>This should be enough to run your native PHP app. With Laravel your <code>server.conf</code> should be like:</p>
<pre>
server {
    listen 80;
    server_name example.com;
    root /var/www/projects/example-app/public; <br>
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff"; <br>
    index index.php; <br>
    charset utf-8; <br>
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    } <br>
    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; } <br>
    error_page 404 /index.php; <br>
    location ~ \.php$ {
        fastcgi_index index.php;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    } <br>
    location ~ /\.(?!well-known).* {
        deny all;
    }
}
</pre>
<blockquote>
Check <a href="https://laravel.com/docs/8.x/deployment#nginx">Laravel documentation</a> for more details.
</blockquote>
</section>
<hr>

<section id="docker-compose" style="padding: 10px;">
<h2>docker-compose.yml</h2>
<p>It's time to bring all together using docker-compose.</p>
<p>I'll not get in details in this guide about versions, services, volumes, etc... but you can learn more in <a href="https://docs.docker.com/compose/">Docker Documentation</a>.</p>
<p>Create <code>/environmentProject/docker-compose.yml</code> file, edit it and lets start!</p>
<h3 style="font-weight: bold;">Version:</h3>
<p>The first line of our <code>docker-compose.yml</code> should be the version of docker-compose. Here we'll use the latest:</p>
<pre>
version: "3.9"
</pre>
<h3 style="font-weight: bold;">Services:</h3>
<p>Following <code>version</code> line let's build our containers. We'll set 3 (or 4) containers: Nginx, PHP, MySql and Node(NPM) (<code style="color: red">optional</code>). Let's break it into steps:</p>
<ol>
  <li>
  <h3>Nginx</h3>
  <p>With this <code>volumes</code> setup, all principal configs can be made within your environment without the need of get in the container.</p>
    <pre>
    services: 
      web-server:
        image: nginx:1.21.1
        container_name: webdev-nginx
        ports:
          - "80:80"
          - "443:443"
        networks:
          - web-dev
        volumes:
          - ./confs/servers/:/etc/nginx/conf.d/
          - ./projects:/var/www/projects
          - ./confs/ssl/:/var/www/ssl
    </pre>
  </li>
  <li>
  <h3>PHP</h3>
  <p><code>volumes</code> of PHP image need to be in the same directory of your <code>web-server</code> projects.</p>
    <pre>
    php:
      build:
        dockerfile: ./php.dockerfile
        context: .
      image: php:8.2-fpm
      container_name: webdev-php
      volumes: 
        - "./projects:/var/www/projects"
      ports: 
        - "9000:9000"
      networks: 
        - web-dev
    </pre>
  </li>
  <li>
  <h3>MySql</h3>
  <p>Here I'm creating a database on start for tests in the end. You can change MYSQL_USER and MYSQL_PASSWORD if you want.
  </p>
    <pre>
    db:
      image: mysql:8.0.26
      container_name: webdev-mysql
      volumes: 
        - ./confs/mysql_db:/var/lib/mysql
      command: --default-authentication-plugin=mysql_native_password
      environment:
        MYSQL_ROOT_PASSWORD: root
        MYSQL_DATABASE: test_db
        MYSQL_USER: devuser
        MYSQL_PASSWORD: devpass
      ports:
        - "3306:3306"
      networks: 
        - web-dev
    </pre>
  </li>
  <li>
  <h3>Node</h3>
  <p>If you want a live container for just NPM you can follow this step.</p> 
  <p>My recommendation is to use a Makefile for packages instead of making a live container for it. Using a Makefile you can create a command (like <code>make npm</code>) that will instance a container, let you use the interactive mode and when you done all your interaction with NPM on your project, you can leave and the container created will not exist anymore, this can provide you performance (taking into account that a container with Node has 900MB~1GB), but this will take a little bit more time than create a live container.</p>
  <pre>
    node:
    image: node:lts
    container_name: webdev-node-npm
    volumes: 
      - "./projects:/var/www"
    ports: 
      - "9002:9002"
    networks: 
      - web-dev
    tty: true
    
  </pre>
  </li>
  <li>
  <h3>Network</h3>
  <p><code>web-dev</code> bring all containers together in a network.</p>
    <pre>
      networks: 
        web-dev:
          driver: bridge
    </pre>
  </li>
</ol>
</section>
<hr>

<section id="test-db" style="padding: 10px;">
<h2>Running and testing our project.</h2>
<p>With all set up let's bring our environment to life.</p>
<p>In <code>/environmentProject/</code> directory, build all images with:</p>
<pre>
docker-compose build
</pre>
<p>When its over, let's run all containers with:</p>
<pre>
docker-composer up -d
</pre>
<p>Get in your <a href="https://localhost">localhost</a> and voilá!</p>
<p>With all running, you can test your MySql connection navigating to <a href="http://localhost/index.php">localhost/index.php</a>. If all is okay you will receive a successfully message.</p>
<p>For laravel test, you will need to edit <code>/example-app/.env</code> and set your connection with mysql. Example:</p>
<pre>
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=test_db
DB_USERNAME=devuser
DB_PASSWORD=devpass
</pre>
<p>Save and exec follow commands:</p>
<pre>
docker exec (container_id) composer dump-autoload
docker exec (container_id) php artisan migrate
</pre>
<p>If you don't receive any error message your connection is fine and you are ready to codding.</p>
</section>

<div align="center">
<h2>Contact-me</h2>
<p>
If you want help or send a feedback, get in my website and send me a e-mail:
</p>
    <a href="https://alisonjuliano.com">
        <img src="https://i.imgur.com/0aMXtBq.png" width="239" height="100">
    </a>
</div>


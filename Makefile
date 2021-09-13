help:
	@echo ""
	@echo "usage: make COMMAND"
	@echo ""
	@echo "Commands:"
	@echo "  reaload-nginx                  Restart Nginx web server"
	@echo "  it-php                         Interactive mode on php image"
	@echo "  start-ubuntu                   Start a ubuntu:latest image and remove when works done"
	@echo "  gen-ssl                        Gen Certificate authority (CA) for your browser and webserver"
	@echo "  start-laravel                  Install laravel project via composer"

reload-nginx:
	@docker exec webdev-nginx nginx -s reload

it-php:
	@docker exec -it webdev-php /bin/bash

start-ubuntu:
	@docker run --rm -ti -v "C:\webdev\GithubRepos\environmentProject:/var/www" ubuntu:latest

# [set MSYS_NO_PATHCONV=1 git blame -L/pathconv/ msys2_path_conv.cc] Disable path convertion from windows
gen-ssl:
	@mkdir ssl
	@touch domains.ext
	@echo -e "authorityKeyIdentifier=keyid,issuer\nbasicConstraints=CA:FALSE\nkeyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment\nsubjectAltName = @alt_names\n[alt_names]\nDNS.1 = localhost\nDNS.2 = fake1.local\nDNS.3 = fake2.local" > domains.ext
	@mv domains.ext ssl
	@docker run -d --name gen-ssl-container -v "C:\webdev\devPHP\:/var/www" -w //var/www/ssl ubuntu:latest
	@docker exec gen-ssl-container apt-get update
	@docker exec gen-ssl-container apt-get install -y openssl
	@docker exec gen-ssl-container openssl req -x509 -nodes -new -sha256 -days 1024 -newkey rsa:2048 -keyout localdockerCA.key -out localdockerCA.pem -subj "//C=BR/CN=localdockerCA"
	@docker exec gen-ssl-container openssl x509 -outform pem -in localdockerCA.pem -out localdockerCA.crt
	@docker exec gen-ssl-container openssl req -new -nodes -newkey rsa:2048 -keyout localhost.key -out localhost.csr -subj "//C=BR/ST=sao-paulo/L=sao-paulo/O=localdockerCA/CN=FQDN"
	@docker exec gen-ssl-container openssl x509 -req -sha256 -days 1024 -in localhost.csr -CA localdockerCA.pem -CAkey localdockerCA.key -CAcreateserial -extfile domains.ext -out localhost.crt
	@docker rm -f gen-ssl-container

start-laravel:
	@docker run --rm -v "C:\webdev\GithubRepos\environmentProject\projects:/var/www" -w //var/www composer composer create-project laravel/laravel $(name)-app

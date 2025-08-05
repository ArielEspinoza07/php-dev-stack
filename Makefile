include .env

all: up-db

clean: down

test:
	@echo "No test suite defined yet"

up:
	docker compose -f docker-compose.yml up -d --build

up-mysql:
	docker compose -f docker-compose.yml -f docker-compose.mysql.yml up -d --build

up-pgsql:
	docker compose -f docker-compose.yml -f docker-compose.pgsql.yml up -d --build

up-db:
ifeq ($(strip $(DB_CONNECTION)),mysql)
	make up-mysql
else ifeq ($(strip $(DB_CONNECTION)),pgsql)
	make up-pgsql
else
	$(error Unsupported DB_CONNECTION=$(DB_CONNECTION))
endif

down:
	docker compose down

restart: down up

restart-mysql: down up-mysql

restart-pgsql: down up-pgsql

info:
	@echo "🧾 Environment Info: $(PROJECT_NAME)"
	@echo "-------------------"
	@echo "DB_CONNECTION: $(DB_CONNECTION)"
	@echo "PHP_VERSION: $(PHP_VERSION)"
	@echo "-------------------"

switch-php:
ifeq ($(strip $(version)),)
	$(error Missing version. Usage: make switch-php version=8.3)
endif
	@echo "Switching to PHP $(version)"
	sed -i 's/^PHP_VERSION=.*/PHP_VERSION=$(version)/' .env
	make restart

logs:
	docker compose logs -f --tail=100

bash:
	docker exec -it $$(docker ps -qf "name=${PROJECT_NAME}_php") bash

composer-install:
ifeq ($(strip $(path)),)
	$(error Missing path. Usage: make composer-install path=src/myapp)
endif
	docker exec -it $$(docker ps -qf "name=${PROJECT_NAME}_php")  sh -c "cd $(path) && composer install"

composer-update:
ifeq ($(strip $(path)),)
	$(error Missing path. Usage: make composer-update path=src/myapp)
endif
	docker exec -it $$(docker ps -qf "name=${PROJECT_NAME}_php")  sh -c "cd $(path) && composer update"

composer-require:
ifeq ($(strip $(package)),)
	$(error Missing package. Usage: make composer-require path=src/myapp package=vendor/package)
endif
ifeq ($(strip $(path)),)
	$(error Missing path. Usage: make composer-require path=src/myapp package=vendor/package)
endif
	docker exec -it $$(docker ps -qf "name=${PROJECT_NAME}_php")  sh -c "cd $(path) && composer require $(command)"

run-php-command:
ifeq ($(strip $(command)),)
	$(error Missing command. Usage: make run-php-command path=src/myapp command="artisan migrate")
endif
ifeq ($(strip $(path)),)
	$(error Missing path. Usage: make run-php-command path=src/myapp command="artisan migrate")
endif
	docker exec -it $$(docker ps -qf "name=${PROJECT_NAME}_php") sh -c "cd $(path) && php $(command)"

run-npm-command:
ifeq ($(strip $(command)),)
	$(error Missing command. Usage: make run-npm-command path=src/myapp command="run dev")
endif
ifeq ($(strip $(path)),)
	$(error Missing path. Usage: make run-npm-command path=src/myapp command="run dev")
endif
	docker exec -it $$(docker ps -qf "name=${PROJECT_NAME}_node") sh -c "cd $(path) && npm $(command)"

enable-site:
	ln -sf docker/nginx/sites-available/$(site) docker/nginx/sites-enabled/$(site)
	docker compose restart nginx

new-site:
	@cp docker/nginx/sites-available/default.conf docker/nginx/sites-available/$(site).conf
	make enable-site site=$(site)
	@echo "✅ Created and enabled site: $(site)"

.PHONY: up up-mysql up-pgsql up-db down restart restart-mysql restart-pgsql switch-php logs bash composer-install composer-update composer-require run-php-command run-npm-command enable-site new-site

# —— Inspired by ———————————————————————————————————————————————————————————————
# https://www.strangebuzz.com/fr/snippets/le-makefile-parfait-pour-symfony

# Executables: local
DOCKER        	= docker
DOCKER_COMP   	= docker-compose

# Containers names
CONTAINER_FRONTAL = images

# Alias
RUN_IN_CONTAINER_FRONTAL = $(DOCKER) exec -it $(CONTAINER_FRONTAL)

# Executables: in containers
NGINX = $(RUN_IN_CONTAINER_FRONTAL) nginx

# Versions variables
CURRENT_VERSION_GIT = $(shell $(GIT) --version | sed 's/git version//' | sed 's/ //g')

NGINX_VERSION = $(shell $(NGINX) -version | sed 's/.*\///g')

DOCKER_CURRENT_VERSION = $(shell $(DOCKER) --version | sed "s/Docker version//" | sed "s/,.*//" | sed 's/ //g')

DOCKER_COMPOSE_CURRENT_VERSION = $(shell $(DOCKER_COMP) --version | sed "s/Docker Compose version v//")

LATEST_VERSION = $(shell git ls-remote --tags --sort=v:refname $(1) | grep -v beta | grep -v xdoc | grep -v rc  | cut -d/ -f3- | tail -n1 | tr -d '^{}' | sed 's/release-//g' | sed s/v//;)

PRINT_VERSIONS = $(shell if [ "$(2)" = "$(3)" ]; then printf "\033[33m$(1)\033[0m \033[32m$(3)\033[0m"; else printf " \033[33m$(1)\033[0m \033[31m$(2)\033[0m Latest$(3)"; fi;)

# Misc
.DEFAULT_GOAL = help

## —— Lougaou Symfony Makefile ———————————————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Project ———————————————————————————————————————————————————————————————
start: ## Start the project
	@make -s docker-up
.PHONY: start

stop: ## Stop the project
	@make -s docker-stop
.PHONY: stop

clean: stop ## Remove all build data
.PHONY: clean

## —— Checks versions and ——————————————————————————————————————————————————————————————————
check: check-versions ## Check everything
.PHONY: check

check-versions: ## Check composent versions
	@echo ""; echo "Versions"; echo "================"; 

	@echo $(call PRINT_VERSIONS, 'Git              ', $(call CURRENT_VERSION_GIT), $(call LATEST_VERSION, https://github.com/git/git))

	@echo $(call PRINT_VERSIONS, 'Nginx            ', $(call NGINX_VERSION), $(call LATEST_VERSION, https://github.com/nginx/nginx))

	@echo $(call PRINT_VERSIONS, 'Docker           ', $(call DOCKER_CURRENT_VERSION), $(call LATEST_VERSION, https://github.com/moby/moby))
	
	@echo $(call PRINT_VERSIONS, 'Docker Compose   ', $(call DOCKER_COMPOSE_CURRENT_VERSION), $(call LATEST_VERSION, https://github.com/docker/compose))

.PHONY: check-versions

## —— Docker ————————————————————————————————————————————————————————————————
docker-up: ## Start the docker hub
	@$(DOCKER_COMP) up -d
.PHONY: docker-up

docker-stop: ## Stop the docker hub
	@$(DOCKER_COMP) stop ; $(DOCKER_COMP) rm -f
.PHONY: docker-stop

bash: ## Bash into nginx docker container
	@$(RUN_IN_CONTAINER_FRONTAL) bash
.PHONY: bash

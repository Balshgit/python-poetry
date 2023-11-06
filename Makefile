# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

.DEFAULT_GOAL := help
.PHONY: help lint-deps install lock requirements-dev requirements-prod

## Проверить зависимостей
lint-deps:
	poetry run poetry check
	poetry run pip check
	poetry run safety check --full-report
	poetry run pip-audit

## Сгенерировать poetry.lock файл
lock:
	poetry lock

## Установить все зависимости
install:
	poetry install --sync --no-interaction --no-ansi --no-root

## Сгенерировать requirements.txt файл с dev зависимостями
requirements-dev:
	poetry export -f requirements.txt --with dev --without-hashes --output requirements.txt

## Сгенерировать requirements.txt с only main зависимостями
requirements-prod:
	poetry export -f requirements.txt --without-hashes --output requirements.txt

## Show help
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = $$1; sub(/:$$/, "", helpCommand); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)25s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@echo ''

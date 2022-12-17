#
# Gringrots
#
BUCKET_HOSTNAME?=http://minio:9000
BUCKET_ACCESS_KEY?=minioadmin
BUCKET_SECRET_KEY?=minioadmin
BUCKET_NAME?=my-bucket

ifeq ($(OS),Windows_NT)
	uname_S := Windows
else
	uname_S := $(shell uname -s)
endif

.PHONY: app

all: services

services:
	docker-compose -f docker-compose.yml up --build --force-recreate


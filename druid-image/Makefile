VERSION=0.10.1-0.33
PROJECT_ID=intentaware-1253
PROJECT=gcr.io/${PROJECT_ID}

all: build

build:
	gcloud container builds submit --timeout 24h0m0s --tag ${PROJECT}/ia-druid-base:${VERSION} .

.PHONY: all build

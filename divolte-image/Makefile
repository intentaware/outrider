VERSION=0.6.0-0.2.3
PROJECT_ID=intentaware-1253
PROJECT=gcr.io/${PROJECT_ID}

all: build

build:
	gcloud container builds submit --timeout 24h0m0s --tag ${PROJECT}/ia-divolte:${VERSION} .

.PHONY: all build

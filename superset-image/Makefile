VERSION=0.20.1-0.1.1
PROJECT_ID=intentaware-1253
PROJECT=gcr.io/${PROJECT_ID}

all: build

build:
	gcloud container builds submit --timeout 24h0m0s --tag ${PROJECT}/ia-superset:${VERSION} .

.PHONY: all build

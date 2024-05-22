ORG					= kubernetes
PROJECT			=	kcompose
VERSION			=	1.28.0
BUILD_IMAGE	= ${PROJECT}-build:${VERSION}

REPO				=	https://github.com/kubernetes/kcompose

all: ci

env: lib
	docker build \
		-f Dockerfile.build \
		-t ${BUILD_IMAGE} \
		.

src/${PROJECT}:
	git clone -b v1.28.0 --depth=1 https://github.com/kubernetes/kompose src/kcompose

ci: src/${PROJECT}
	docker run --rm \
		-v `pwd`:/build \
		-e https_proxy=${https_proxy} \
		-e http_proxy=${http_proxy} \
		-e TAG=${ORG}/${PROJECT} \
 		-e VERSION=${VERSION} \
		${BUILD_IMAGE} \
		/bin/bash -c 'cd /build/src/'${PROJECT}'; /build/ci.sh'

.PHONY: lib
lib:
	rm -rf lib
	cp -R ../../../lib lib

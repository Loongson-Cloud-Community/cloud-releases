ORG					= Microsoft
PROJECT			=	cpprestsdk
VERSION			=	2.10.18
BUILD_IMAGE	= ${PROJECT}-build:${VERSION}

REPO				=	https://github.com/Microsoft/cpprestsdk

all: ci

env: lib
	docker build \
                -f Dockerfile.build \
                -t ${BUILD_IMAGE} \
                .

src/${PROJECT}: clean
	git clone -b v$(VERSION) --depth 1 $(REPO)

ci: src/${PROJECT}
	docker run --rm -v `pwd`:/build \
		-e https_proxy=${https_proxy} \
		-e http_proxy=${http_proxy} \
		${BUILD_IMAGE} /bin/bash -c 'cd /build/'$(PROJECT)'; /build/ci.sh'
lib:
	rm -rf lib
	cp -r ../../../lib ./

clean:
	rm -rf $(REPO)

ORG          = kubevirt
PROJECT      = cdi-uploadproxy
VERSION      = 1.45.0
BUILD_IMAGE  = ${PROJECT}-build:${VERSION}
REGISTRY     = lcr.loongnix.cn/cache
REPO         = https://github.com/kubevirt/containerized-data-importer

all: ci

env: lib
	@if docker pull ${REGISTRY}/${BUILD_IMAGE}; then \
		echo "Image ${REGISTRY}/${BUILD_IMAGE} exists. Pulled successfully."; \
	else \
		echo "Image ${REGISTRY}/${BUILD_IMAGE} not found. Building and pushing..."; \
		docker build \
			-f Dockerfile.build \
			-t ${REGISTRY}/${BUILD_IMAGE} \
			. && \
		docker push ${REGISTRY}/${BUILD_IMAGE}; \
	fi

src/${PROJECT}: clean
	wget https://github.com/kubevirt/containerized-data-importer/archive/refs/tags/v$(VERSION).tar.gz && tar xf v$(VERSION).tar.gz

ci: src/${PROJECT}
	echo $(PWD)
	docker run --rm -v $(PWD):/build \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e https_proxy=${https_proxy} \
		-e http_proxy=${http_proxy} \
		${REGISTRY}/${BUILD_IMAGE} /bin/bash -c 'cd /build/containerized-data-importer-$(VERSION); /build/ci.sh'

.PHONY: lib
lib:
	rm -rf lib
	cp -r ../../../lib lib

clean:
	rm -rf v*.tar.gz containerized-data-importer*

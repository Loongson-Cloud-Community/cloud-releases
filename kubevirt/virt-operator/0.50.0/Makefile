ORG          = kubevirt
PROJECT      = virt-operator
VERSION      = 0.50.0
BUILD_IMAGE  = ${PROJECT}-build:${VERSION}
REGISTRY     = lcr.loongnix.cn/cache
REPO         = https://github.com/kubevirt/kubevirt

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
	wget https://github.com/kubevirt/kubevirt/archive/refs/tags/v$(VERSION).tar.gz && tar xf v$(VERSION).tar.gz

ci: src/${PROJECT}
	echo $(PWD)
	docker run --rm -v $(PWD):/build \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e https_proxy=${https_proxy} \
		-e http_proxy=${http_proxy} \
		${REGISTRY}/${BUILD_IMAGE} /bin/bash -c 'cd /build/kubevirt-$(VERSION); /build/ci.sh'

.PHONY: lib
lib:
	rm -rf lib
	cp -r ../../../lib lib

clean:
	rm -rf v* containerized-data-importer* kube*

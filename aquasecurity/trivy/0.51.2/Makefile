ORG          = aquasecurity
PROJECT      = trivy
VERSION      = 0.51.2
BUILD_IMAGE  = ${PROJECT}-build:${VERSION}
REGISTRY     = lcr.loongnix.cn/cache
REPO         = https://github.com/aquasecurity/trivy

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
#	git clone --single-branch -b v$(VERSION) --depth 1 $(REPO) src/${PROJECT}
	mkdir src && wget https://github.com/aquasecurity/trivy/archive/refs/tags/v$(VERSION).tar.gz && tar xf v$(VERSION).tar.gz && rm -rf v$(VERSION).tar.gz && mv $(PROJECT)-$(VERSION) src/${PROJECT}

ci: src/${PROJECT}
	docker run --rm -v $(PWD):/build \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e https_proxy=${https_proxy} \
		-e http_proxy=${http_proxy} \
		${REGISTRY}/${BUILD_IMAGE} /bin/bash -c 'cd /build/$(PROJECT); /build/ci.sh'

.PHONY: lib
lib:
	rm -rf lib
	cp -r ../../../lib lib

clean:
	rm -rf src

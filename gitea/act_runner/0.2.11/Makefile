ORG          = gitea
PROJECT      = act_runner
VERSION      = 0.2.11
BUILD_IMAGE  = ${PROJECT}-build:${VERSION}
REGISTRY     = lcr.loongnix.cn/cache
REPO         = https://gitea.com/gitea/act_runner

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
	wget https://gitea.com/gitea/act_runner/archive/v0.2.11.tar.gz && tar xf v0.2.11.tar.gz && \
	cd act_runner &&  patch -p1 < ../0001.patch

ci: src/${PROJECT}
	echo $(PWD)
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
	rm -rf v* $(PROJECT)

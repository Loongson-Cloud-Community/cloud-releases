all: ci

REGISTRY			=	lcr.loongnix.cn
DEBIAN				=	${REGISTRY}/library/debian:sid
ANOLIS				=	${REGISTRY}/openanolis/anolisos:23

BUILD_IMAGE 	=	${DEBIAN}

ci:
	docker run --rm \
		-v `pwd`:/build \
		-e https_proxy=${https_proxy} \
		-e http_proxy=${http_proxy} \
		${BUILD_IMAGE} \
		/bin/bash -c 'cd /build; /build/ci.sh'

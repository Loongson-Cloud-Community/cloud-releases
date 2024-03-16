VERSION:=

default: new

# 创建指定版本版本
# make new VERSION=v0.0.1
new:
	./scripts/new_version.sh ${VERSION}

# 检测最新版本并创建
# make latest
latest:
	@ver=$(shell ./scripts/latest_version.sh); \
	./scripts/new_version.sh $${ver}

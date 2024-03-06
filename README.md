# cloud-releases

云项目二进制构建归档

## 使用

1. `./new.sh $org $project` 建立新项目

2. 完善项目构建脚本

- Makefile - 配置构建环境
  - BASE_IMAGE - 选择构建镜像
- ci.sh
  - prepare
    - 下载源码，下载的源码地址应位于 `BUILDDIR` 目录下，且源码目录名称为 `SOURCEDIR`
    - 打补丁
  - install_deps - 编译环境
  - build - 构建步骤

3. 生成项目版本 `./new_version.sh $version`

4. 运行构建 `make`

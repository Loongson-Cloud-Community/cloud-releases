# cloud-releases

## 目的
1. 记录云项目的编译环境
2. 记录云项目的编译步骤
3. 可通过脚本定制编译步骤
4. 为多版本编译提供参考
5. 为自动化提供支持

## 使用

1. 和 dockerfiles 类似，使用 `./new.sh $org $project $version` 建立新项目

2. 完善项目构建脚本

- Dockerfile.build - 安装 ci.sh 所需的环境
- ci.sh - 自定义运行步骤
- Makefile - 可选修改

3. 构建运行环境
```
make env
```

4. 运行自定义脚本
```
make ci
```

## 通用工具包 lib
用于 Dcokerfile.build 的实用脚本，可以安装 java，maven，golang(abi1.0 abi2.0) 等。
install-maven 和 install-golang.sh 自动检测环境 
其中install-maven 使用自动检测环境脚本确定配置文件

install-maven.sh (版本号)
example: install-maven.sh 3.6.3

install-golang.sh （版本号）
example:install-golang.sh 19

## 避免 jar 包重复下载耗时

由于整个构建在容器中进行，对于 java 项目为了避免
重复下载 jar 包的耗时。可以使用挂载宿主机仓库的方式。

```
docker run --rm \
  ...
  -v ${HOME}/.m2/repository:/root/.m2/repository:rw
  ...
```


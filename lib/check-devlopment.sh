#!/bin/bash
# 服务器环境检测脚本
# 检测新旧世界
# 检测系统 red-hat debian
#

check_abi(){
	local kernel_version=$(uname -r)
	local major_version=$(echo $kernel_version | cut -d.-f1)
	local minor_version=$(echo $kernel_version | cut -d.-f2)

	if (( $(echo "$major_version > 5 || ($major_version == 5 && $minor_version >= 10)" | bc -l) )); then
		echo "Kernel version is higher than 5.10. return 0"
		return 0
	else
		echo "Kernel version is lower than or equal to 5.10. rturn 1"
		return 1
	fi
}

check_system_type(){
	if grep -qs "Debian" /etc/os-release;then
		echo "Debian System."
		return 0
	elif grep -qs "Alpine" /etc/os-release ;then
                echo "Alpine System or Using apk."
                return 1
	elif grep -qs "Anolis" /etc/os-release || grep -qs "openEuler" /etc/os-release || command -v yum &> /dev/null;then
		echo "Red hat System or Using yum."
		return 1
	else
		echo "Unsupported system type."
		return -1
	fi
}

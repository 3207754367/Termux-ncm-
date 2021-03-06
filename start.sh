#!/bin/bash

#字体颜色
Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" &&  Blue_font_prefix="\033[36m" && White="\033[47;30m" && Green_font_perfix="\033[32m" &&reset="\033[0m"

#解密ncm
rundump(){
echo -e "${Green_font_perfix}注意:${reset}我们需要知道ncm文件的详细路径"

read -p "请输入ncm文件路径:" file
case $file in
'')
echo "感谢使用，脚本已结束"
exit                                                                                ;;                                                                  esac
while true
do
	find $file -name "*.ncm" -exec mv {} . \; && python3 ncmdump.py $1 | sed -e '/please input file path!/d' && sleep 5 && rm -rf *.ncm
#移动加密文件进行解密
outfile 2>/dev/null #输出解密后的文件
done

}

#判断重定向的目录是否存在
if [ -d "/sdcard/Music/netease/" ] ;then
	mpath=/sdcard/Music/netease/
else
	mkdir /sdcard/Music/netease/
	mpath=/sdcard/Music/netease/
fi

#输出解密后的文件
outfile(){
	mv -f *.mp3 $mpath && echo "已解密,mp3文件已输出到目录：/sdcard/Music/netease" 
	mv -f *.flac $mpath && echo "已解密,flac文件已输出到目录：/sdcard/Music/netease"
 }

#主界面
 start-menu(){
 clear
 a="爱的供养，再问自杀"
 echo -e "
${Green_font_perfix}
***************************************************
一键部署NCM解密脚本
ncmdump.py来自github@https://github.com/nondanee
作者：隔壁泰山
***************************************************

1.开始安装依赖包(如果是第一次运行)
2.启动解密脚本
3.退出脚本

依赖包状态：${a}
${reset}"

read -p "请输入数字:" zero
 case $zero in
0)
	echo 你怎么回事？小老弟？??
	sleep 2
	start-menu
 	;;
1)
	dependency
        ;;
2)
	rundump
	;;
3)
	echo -e ${reset}
	echo 感谢使用，再见.
	exit
	;;
*)
	echo -e "${Red_font_prefix}请重新输入正确数字[(ㅎ.ㅎ)]${reset}"
	sleep 1 && start-menu
	;;
esac

}

#安装依赖包
dependency(){

if [[ "${release}" == "termux" ]]; then
	echo "设备环境:${release}  安装依赖中，请稍后..." && pkg install wget python  clang -y && pip install --upgrade pip && pip install pycryptodome mutagen pycryptodomex
elif [[ "${release}" == "ubuntu" ]]; then
	echo "设备环境:${release}  安装依赖中，请稍后..." && apt install wget python3 clang python3-pip -y && pip3 install --upgrade pip && pip install pycryptodome mutagen pycryptodomex pycrypto && apt remove python3-pip -y > /dev/null
fi

 if [ -e ncmdump.py ]; then
	 rundump
else
 wget -N https://raw.githubusercontent.com/3207754367/Termux-ncm/master/ncmdump.py && chmod +x ncmdump.py && rundump

 fi
}


#检查系统
#代码借鉴自github：https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh
check_sys(){

	if cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
        elif [  -d "/data/data/com.termux" ] ; then
       	release="termux"
else
	release=""
    fi
}

check_sys
[[ ${release} != "termux" ]] && [[ ${release} != "ubuntu" ]]  && echo  "sorry,本脚本不支持当前系统!" && exit 1
start-menu

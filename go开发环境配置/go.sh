#!/bin/bash
# 配置 $HOME/.bashrc 文件
tee -a $HOME/.bashrc <<'EOF'
# User specific environment
# Basic envs
export LANG="en_US.UTF-8" # 设置系统语言为 en_US.UTF-8，避免终端出现中文乱码
export PS1='[\u@dev \W]\$ ' # 默认的 PS1 设置会展示全部的路径，为了防止过长，这里只展示："用户名@dev 最后的目录名"
export WORKSPACE="$HOME/workspace" # 设置工作目录
export PATH=$HOME/bin:$PATH # 将 $HOME/bin 目录加入到 PATH 变量中
 
# Default entry folder
cd $WORKSPACE # 登录系统，默认进入 workspace 目录
EOF
source ~/.bashrc
# 依赖安装
mkdir -p ~/workspace/golang
yum -y install make autoconf automake cmake perl-CPAN libcurl-devel libtool gcc gcc-c++ glibc-headers zlib-devel git-lfs telnet ctags lrzsz jq expat-devel openssl-devel wget tcl-devel gettext python3 python2 lua   
# 安装git,配置git
cd /tmp 
wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.30.2.tar.gz 
tar -xvzf git-2.30.2.tar.gz 
cd git-2.30.2/ 
./configure 
make 
make install 
git config --global user.name "xxx" 
git config --global user.email "xxx@gmail.com" 
git config --global credential.helper store 
git config --global core.longpaths true 
git config --global core.quotepath off 
git config --global url."https://github.com.cnpmjs.org/".insteadOf "https://github.com/" 
git lfs install --skip-repo  
# Go 编译环境安装和配置
wget https://golang.google.cn/dl/go1.17.2.linux-amd64.tar.gz -O /tmp/go1.17.2.linux-amd64.tar.gz 
mkdir -p $HOME/go 
tar -xvzf /tmp/go1.17.2.linux-amd64.tar.gz -C $HOME/go 
mv $HOME/go/go $HOME/go/go1.17.2 
tee -a $HOME/.bashrc <<'EOF'
# Go envs
export GOVERSION=go1.17.2 # Go 版本设置
export GO_INSTALL_DIR=$HOME/go # Go 安装目录
export GOROOT=$GO_INSTALL_DIR/$GOVERSION # GOROOT 设置
export GOPATH=$WORKSPACE/golang # GOPATH 设置
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH # 将 Go 语言自带的和通过 go install 安装的二进制文件加入到 PATH 路径中
export GO111MODULE="on" # 开启 Go moudles 特性
export GOPROXY=https://goproxy.cn,direct # 安装 Go 模块时，代理服务器设置
export GOPRIVATE=
export GOSUMDB=off # 关闭校验 Go 依赖包的哈希值
EOF
source ~/.bashrc
# ProtoBuf 编译环境安装
cd /tmp/ 
git clone --depth=1 https://github.com/protocolbuffers/protobuf 
cd protobuf 
./autogen.sh 
./configure 
make 
make install 
go get -u github.com/golang/protobuf/protoc-gen-go 
# Go 开发 IDE 安装和配置
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm 
yum install -y neovim python3-neovim 
tee -a $HOME/.bashrc <<'EOF'
# Configure for nvim
export EDITOR=nvim # 默认的编辑器（git 会用到）
alias vi="nvim"
EOF
source ~/.bashrc
cd /tmp 
wget https://marmotedu-1254073058.cos.ap-beijing.myqcloud.com/tools/marmotVim.tar.gz 
tar -xvzf marmotVim.tar.gz 
cd marmotVim 
./marmotVimCtl install 
# Go 工具安装
cd /tmp 
wget https://marmotedu-1254073058.cos.ap-beijing.myqcloud.com/tools/gotools-for-spacevim.tgz 
mkdir -p $GOPATH/bin 
tar -xvzf gotools-for-spacevim.tgz -C $GOPATH/bin 
# 删除清理
source ~/.bashrc
rm -rf /tmp/*
yum clean packages
yum clean headers
yum clean oldheaders

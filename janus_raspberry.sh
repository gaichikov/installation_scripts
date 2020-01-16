#!/bin/bash


cd /opt
mkdir janus
cd janus

apt-get update
sudo apt-get install libmicrohttpd-dev libjansson-dev libssl-dev libsofia-sip-ua-dev libglib2.0-dev gtk-doc-tools  libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev libconfig-dev pkg-config gengetopt libtool automake gtk-doc-tools


sed -i s/"mdns4_minimal \[NOTFOUND=return\]"/""/g /etc/nsswitch.conf
/etc/init.d/avahi-daemon restart 

git clone https://gitlab.freedesktop.org/libnice/libnice
cd libnice
git checkout 0.1.15
./autogen.sh --prefix=/usr --disable-gtk-doc
sed -i -e s/'NICE_ADD_FLAG(\[-Wcast-align\])'/'# NICE_ADD_FLAG(\[-Wcast-align\])'/g configure.ac
sed -i -e s/'NICE_ADD_FLAG(\[-Wno-cast-function-type\])'/'# NICE_ADD_FLAG(\[-Wno-cast-function-type\])'/g configure.ac
./configure --prefix=/usr
make && sudo make install

cd /opt/janus

wget https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz
tar xfv v2.2.0.tar.gz
cd libsrtp-2.2.0
./configure --prefix=/usr --enable-openssl
make shared_library && sudo make install

cd /opt/janus

git clone https://libwebsockets.org/repo/libwebsockets
cd libwebsockets
mkdir build
cd build
cmake -DLWS_MAX_SMP=1 -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" ..
make && sudo make install

cd /opt/janus

git clone https://github.com/meetecho/janus-gateway.git
cd janus-gateway
sh autogen.sh
./configure --disable-all-plugins --enable-plugin-streaming --disable-all-transports --enable-websockets --enable-rest --disable-docs --prefix=/opt/janus
make
make install
make configs



FROM  buildpack-deps:jessie
MAINTAINER Daozhao chen "http://daozhao.goflytoday.com"

RUN apt-get update
RUN apt-get install -y unzip
RUN apt-get install -y gettext

ENV WORKPATH=/home/data

RUN mkdir -p $WORKPATH

RUN wget -P $WORKPATH/ https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz
RUN wget -P $WORKPATH/ https://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.8.tar.xz
RUN wget -P $WORKPATH/ https://nchc.dl.sourceforge.net/project/pcre/pcre/8.40/pcre-8.40.tar.gz
RUN wget -P $WORKPATH/ ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz
RUN wget -P $WORKPATH/ https://ftp.gnome.org/pub/gnome/sources/glib/2.44/glib-2.44.1.tar.xz

COPY gettext-fix-msginit.c $WORKPATH/gettext-fix-msginit.c
COPY glib-android.cache $WORKPATH/glib-android.cache
COPY glib-fix-gthreadedresolver.c $WORKPATH/glib-fix-gthreadedresolver.c

RUN wget -P $WORKPATH/ https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip
RUN unzip -o -d $WORKPATH/  $WORKPATH/android-ndk-r13b-linux-x86_64.zip

ENV NDK=$WORKPATH/android-ndk-r13b

RUN $NDK/build/tools/make-standalone-toolchain.sh --platform=android-21 --toolchain=arm-linux-androideabi-4.9 --stl=gnustl --install-dir=$WORKPATH/standalone_toolchain

ENV PATH=$WORKPATH/standalone_toolchain/bin:$PATH
ENV SYSROOT=$WORKPATH/standalone_toolchain/sysroot
ENV TOOL_CHAIN_BIN=$WORKPATH/standalone_toolchain/bin

RUN ln -s $TOOL_CHAIN_BIN/arm-linux-androideabi-ar  $TOOL_CHAIN_BIN/arm-linux-eabi-ar
RUN ln -s $TOOL_CHAIN_BIN/arm-linux-androideabi-as  $TOOL_CHAIN_BIN/arm-linux-eabi-as
RUN ln -s $TOOL_CHAIN_BIN/arm-linux-androideabi-c++ $TOOL_CHAIN_BIN/arm-linux-eabi-c++
RUN ln -s $TOOL_CHAIN_BIN/arm-linux-androideabi-cpp $TOOL_CHAIN_BIN/arm-linux-eabi-cpp
RUN ln -s $TOOL_CHAIN_BIN/arm-linux-androideabi-g++ $TOOL_CHAIN_BIN/arm-linux-eabi-g++
RUN ln -s $TOOL_CHAIN_BIN/arm-linux-androideabi-gcc $TOOL_CHAIN_BIN/arm-linux-eabi-gcc
RUN ln -s $TOOL_CHAIN_BIN/arm-linux-androideabi-ld  $TOOL_CHAIN_BIN/arm-linux-eabi-ld
RUN ln -s $TOOL_CHAIN_BIN/arm-linux-androideabi-nm  $TOOL_CHAIN_BIN/arm-linux-eabi-nm

COPY make-glib.sh $WORKPATH/make-glib.sh
RUN chmod +x $WORKPATH/make-glib.sh
RUN $WORKPATH/make-glib.sh

VOLUME ["/home/data"]

CMD ["bash"]



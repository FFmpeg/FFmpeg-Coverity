FROM ubuntu:17.04

ENV DEBIAN_FRONTEND noninteractive

RUN \
	apt-get -y update && \
	apt-get -y install build-essential yasm nasm pkg-config git curl wget cmake unzip subversion autoconf automake libtool && \
	apt-get -y install --no-install-recommends \
		flite1-dev \
		frei0r-plugins-dev \
		ladspa-sdk \
		libass-dev \
		libavc1394-dev \
		libbluray-dev \
		libbs2b-dev \
		libcaca-dev \
		libcdio-cdda-dev \
		libcdio-dev \
		libcdio-paranoia-dev \
		libcdparanoia-dev \
		libchromaprint-dev \
		libcrystalhd-dev \
		libdc1394-22-dev \
		libfdk-aac-dev \
		libfontconfig1-dev \
		libfreetype6-dev \
		libfribidi-dev \
		libgl1-mesa-dev \
		libgcrypt20-dev \
		libgme-dev \
		libgnutls28-dev \
		libgsm1-dev \
		libiec61883-dev \
		libleptonica-dev \
		liblzma-dev \
		libmodplug-dev \
		libmp3lame-dev \
		libnetcdf-dev \
		libomxil-bellagio-dev \
		libopenal-dev \
		libopencore-amrnb-dev \
		libopencore-amrwb-dev \
		libopencv-dev \
		libopenjp2-7-dev \
		libopenmpt-dev \
		libopus-dev \
		liborc-0.4-dev \
		libpulse-dev \
		librtmp-dev \
		librubberband-dev \
		libsctp-dev \
		libsdl2-dev \
		libshine-dev \
		libsmbclient-dev \
		libsnappy-dev \
		libsoxr-dev \
		libspeex-dev \
		libssh-dev \
		libssl-dev \
		libtesseract-dev \
		libtheora-dev \
		libtwolame-dev \
		libv4l-dev \
		libva-dev \
		libvdpau-dev \
		libvo-amrwbenc-dev \
		libvorbis-dev \
		libvpx-dev \
		libwavpack-dev \
		libwebp-dev \
		libx11-dev \
		libx11-xcb-dev \
		libx264-dev \
		libx265-dev \
		libxcb-shape0-dev \
		libxcb-shm0-dev \
		libxcb-xfixes0-dev \
		libxv-dev \
		libxvidcore-dev \
		libxvmc-dev \
		libzmq3-dev \
		libzvbi-dev \
		nvidia-cuda-dev \
		nvidia-opencl-dev \
		zlib1g-dev && \
	apt-get -y clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/TimothyGu/libilbc.git libilbc && \
	cd libilbc && \
	mkdir build && cd build && \
	cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
	make && \
	make install && \
	cd /root && \
	rm -rf libilbc

RUN \
	cd /root && \
	svn co https://svn.code.sf.net/p/xavs/code/trunk xavs && \
	cd xavs && \
	./configure --prefix=/usr && \
	make && \
	make install && \
	cd /root && \
	rm -rf xavs

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/sekrit-twc/zimg.git zimg && \
	cd zimg && \
	./autogen.sh && \
	./configure --prefix=/usr && \
	make && \
	make install && \
	cd /root && \
	rm -rf zimg

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/cisco/openh264.git openh264 && \
	cd openh264 && \
	make PREFIX=/usr && \
	make install PREFIX=/usr && \
	cd /root && \
	rm -rf openh264

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/ultravideo/kvazaar.git kvazaar && \
	cd kvazaar && \
	./autogen.sh && \
	./configure --prefix=/usr && \
	make && \
	make install && \
	cd /root && \
	rm -rf kvazaar

RUN \
	cd /root && \
	git clone --depth=1 git://git.xiph.org/celt.git celt && \
	cd celt && \
	./autogen.sh && \
	./configure --prefix=/usr && \
	make && \
	make install && \
	cd /root && \
	rm -rf celt

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/georgmartius/vid.stab.git libvidstab && \
	cd libvidstab && \
	cmake -DCMAKE_INSTALL_PREFIX=/usr . && \
	make && \
	make install && \
	cd /root && \
	rm -rf libvidstab

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/lu-zero/mfx_dispatch.git mfx_dispatch && \
	cd mfx_dispatch && \
	autoreconf -fi && \
	./configure --prefix=/usr && \
	make && \
	make install && \
	cd /root && \
	rm -rf mfx_dispatch

RUN \
	cd /root && \
	git clone https://git.ffmpeg.org/nut.git libnut && \
	cd libnut/src/trunk && \
	sed -i 's#/usr/local#/usr#g' config.mak && \
	make && \
	make install && \
	cd /root && \
	rm -rf libnut

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/kdienes/decklink-sdk.git decklink-sdk && \
	cd decklink-sdk && \
	cp -v Linux/include/* /usr/include/ && \
	cd /root && \
	rm -rf decklink-sdk

RUN \
	cd /root && \
	wget http://archive.ubuntu.com/ubuntu/pool/universe/s/schroedinger/schroedinger_1.0.11.orig.tar.gz && \
	tar -xf schroedinger_1.0.11.orig.tar.gz && \
	cd schroedinger-1.0.11 && \
	autoreconf -fi && \
	./configure --prefix=/usr && \
	make && \
	make install && \
	cd /root && \
	rm -rf schroedinger-1.0.11 schroedinger_1.0.11.orig.tar.gz

ADD build_script.sh /root/build_script.sh

CMD ["/root/build_script.sh"]

FROM ubuntu:16.10

ENV DEBIAN_FRONTEND noninteractive

RUN \
	apt-get -y update && \
	apt-get -y install build-essential yasm nasm pkg-config git curl wget cmake unzip subversion autoconf automake libtool && \
	apt-get -y install --no-install-recommends \
		flite1-dev \
		frei0r-plugins-dev \
		libass-dev \
		libavc1394-dev \
		libbluray-dev \
		libbs2b-dev \
		libc6-dev \
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
		libgcrypt20-dev \
		libgme-dev \
		libgsm1-dev \
		libiec61883-dev \
		libleptonica-dev \
		libmodplug-dev \
		libmp3lame-dev \
		libopenal-dev \
		libopencore-amrnb-dev \
		libopencore-amrwb-dev \
		libopencv-dev \
		libopenjpeg-dev \
		libopus-dev \
		libpulse-dev \
		librtmp-dev \
		librubberband-dev \
		libschroedinger-dev \
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
		libxvidcore-dev \
		libzvbi-dev \
		nvidia-cuda-dev && \
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

ADD build_script.sh /root/build_script.sh

CMD ["/root/build_script.sh"]

FROM ubuntu:16.10

ENV DEBIAN_FRONTEND noninteractive

RUN \
	apt-get -y update && \
	apt-get -y install build-essential yasm nasm pkg-config git wget cmake unzip subversion autoconf automake libtool && \
	apt-get -y install --no-install-recommends \
		libspeex-dev libvpx-dev libopenjpeg-dev libvorbis-dev libssh-dev libtesseract-dev \
		libx264-dev libx265-dev libdc1394-22-dev libxvidcore-dev libfreetype6-dev libchromaprint-dev libleptonica-dev libavc1394-dev \
		libmodplug-dev libpulse-dev libmp3lame-dev libbluray-dev libx11-dev libxcb-shm0-dev libxcb-xfixes0-dev libxcb-shape0-dev libx11-xcb-dev \
		libtheora-dev libssl-dev libschroedinger-dev libcaca-dev libopus-dev librtmp-dev libshine-dev \
		libcdio-dev libcdio-cdda-dev libcdio-paranoia-dev libcdparanoia-dev libopenal-dev libopencore-amrnb-dev libopencore-amrwb-dev libvo-amrwbenc-dev libgsm1-dev \
		libvdpau-dev libva-dev libc6-dev libgme-dev libwebp-dev libopencv-dev libv4l-dev libwavpack-dev  \
		libass-dev frei0r-plugins-dev libsoxr-dev libfdk-aac-dev libfribidi-dev librubberband-dev libiec61883-dev \
		libfontconfig1-dev libbs2b-dev libzvbi-dev libtwolame-dev libsmbclient-dev flite1-dev \
		nvidia-cuda-dev libcrystalhd-dev libgcrypt20-dev libsnappy-dev && \
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

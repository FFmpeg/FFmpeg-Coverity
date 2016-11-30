FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN \
	sed -i 's/universe/universe multiverse/' /etc/apt/sources.list && \
	apt-get -y update && \
	apt-get -y install build-essential yasm pkg-config git wget cmake unzip subversion && \
	apt-get -y install --no-install-recommends \
		libspeex-dev libvpx-dev libopenjpeg-dev libvorbis-dev \
		libx264-dev libx265-dev libdc1394-22-dev libxvidcore-dev libfreetype6-dev \
		libmodplug-dev libpulse-dev libmp3lame-dev libbluray-dev libx11-dev libxcb-shm0-dev libxcb-xfixes0-dev libxcb-shape0-dev libx11-xcb-dev \
		libtheora-dev libssl-dev libschroedinger-dev libcaca-dev libopus-dev \
		libcdio-dev libcdio-cdda-dev libcdio-paranoia-dev libcdparanoia-dev libopenal-dev libopencore-amrnb-dev libopencore-amrwb-dev libvo-amrwbenc-dev libgsm1-dev \
		libvdpau-dev libva-dev libc6-dev libgme-dev libwebp-dev libopencv-dev \
		libass-dev frei0r-plugins-dev libsoxr-dev libfdk-aac-dev \
		libfontconfig1-dev libbs2b-dev libzvbi-dev libtwolame-dev libsmbclient-dev \
		nvidia-cuda-dev libnppi7.5 libnppc7.5 && \
	apt-get -y clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# TODO: libilbc(https://github.com/TimothyGu/libilbc) libxavs 

RUN \
	cd /root && \
	git clone https://github.com/TimothyGu/libilbc.git libilbc && \
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

ADD build_script.sh /root/build_script.sh

CMD ["/root/build_script.sh"]

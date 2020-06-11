FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN \
	sed -i 's/main/main contrib non-free/' /etc/apt/sources.list && \
	apt-get -y update && \
	apt-get -y install build-essential yasm nasm pkg-config git curl wget cmake unzip subversion autoconf automake libtool && \
	apt-get -y install --no-install-recommends \
		clang \
		nproc \
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
		libomxil-bellagio-dev \
		libopenal-dev \
		libopencore-amrnb-dev \
		libopencore-amrwb-dev \
		libopencv-dev \
		libopenjp2-7-dev \
		libopenmpt-dev \
		libopus-dev \
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
		libdrm-dev \
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
		ocl-icd-opencl-dev \
		zlib1g-dev && \
	apt-get -y clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/TimothyGu/libilbc.git libilbc && \
	cd libilbc && \
	mkdir build && cd build && \
	cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
	make -j"$(nproc)" && \
	make install && \
	cd /root && \
	rm -rf libilbc

RUN \
	cd /root && \
	svn co https://svn.code.sf.net/p/xavs/code/trunk xavs && \
	cd xavs && \
	./configure --prefix=/usr && \
	make -j"$(nproc)" && \
	make install && \
	cd /root && \
	rm -rf xavs

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/sekrit-twc/zimg.git zimg && \
	cd zimg && \
	./autogen.sh && \
	./configure --prefix=/usr && \
	make -j"$(nproc)" && \
	make install && \
	cd /root && \
	rm -rf zimg

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/cisco/openh264.git openh264 && \
	cd openh264 && \
	make -j"$(nproc)" PREFIX=/usr && \
	make install PREFIX=/usr && \
	cd /root && \
	rm -rf openh264

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/ultravideo/kvazaar.git kvazaar && \
	cd kvazaar && \
	./autogen.sh && \
	./configure --prefix=/usr && \
	make -j"$(nproc)" && \
	make install && \
	cd /root && \
	rm -rf kvazaar

RUN \
	cd /root && \
	git clone --depth=1 https://gitlab.xiph.org/xiph/celt.git celt && \
	cd celt && \
	./autogen.sh && \
	./configure --prefix=/usr && \
	make -j"$(nproc)" && \
	make install && \
	cd /root && \
	rm -rf celt

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/georgmartius/vid.stab.git libvidstab && \
	cd libvidstab && \
	cmake -DCMAKE_INSTALL_PREFIX=/usr . && \
	make -j"$(nproc)" && \
	make install && \
	cd /root && \
	rm -rf libvidstab

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/Intel-Media-SDK/MediaSDK msdk && \
	cd msdk && \
	mkdir build && cd build && \
	cmake -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_SAMPLES=OFF .. && \
	make -j"$(nproc)" && \
	make install && \
	cd /root && \
	rm -rf msdk

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/BtbN/decklink-sdk.git decklink-sdk && \
	cd decklink-sdk && \
	cp -v Linux/include/* /usr/include/ && \
	cd /root && \
	rm -rf decklink-sdk

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/hoene/libmysofa.git libmysofa && \
	cd libmysofa && \
	mkdir -p build && cd build && \
	cmake -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_TESTS=Off .. && \
	make -j"$(nproc)" mysofa-static && \
	make -j"$(nproc)" && \
	make install && \
	cd /root && \
	rm -rf libmysofa

RUN \
	cd /root && \
	git clone --depth=1 https://git.videolan.org/git/ffmpeg/nv-codec-headers.git nv-codec-headers && \
	cd nv-codec-headers && \
	make install PREFIX=/usr && \
	cd /root && \
	rm -rf nv-codec-headers

RUN \
	cd /root && \
	git clone --depth=1 https://github.com/AviSynth/AviSynthPlus.git avisynth && \
	cd avisynth && \
	mkdir avisynth-build && cd avisynth-build && \
	cmake -DHEADERS_ONLY:bool=on -DCMAKE_INSTALL_PREFIX=/usr .. && \
	make install && \
	cd /root && \
	rm -rf avisynth

ADD build_script.sh /root/build_script.sh
ADD fake_ld.sh /root/fake_ld.sh

CMD ["/root/build_script.sh"]

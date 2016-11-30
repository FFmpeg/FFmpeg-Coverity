#!/bin/bash
set -e

git clone --depth=1 https://git.videolan.org/git/ffmpeg.git /root/ffmpeg
cd /root/ffmpeg

echo "Configuring..."
./configure --enable-gpl --enable-nonfree --enable-version3 --enable-debug=3 --assert-level=2 --cpu=core2 \
	--enable-libspeex --enable-libvpx --enable-libopenjpeg --enable-pthreads --enable-libvorbis \
	--enable-libx264 --enable-libdc1394 --enable-libxvid --enable-libfreetype \
	--enable-libmodplug --enable-libpulse --enable-libmp3lame --enable-libbluray --enable-x11grab \
	--enable-libtheora --enable-openssl --enable-libschroedinger --enable-libcaca --enable-libopus \
	--enable-libcdio --enable-openal --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libvo-amrwbenc --enable-libgsm \
	--enable-vdpau --enable-vaapi --enable-iconv --enable-libgme --enable-libwebp \
	--enable-libass --enable-frei0r --enable-libsoxr --enable-libfdk-aac --enable-avisynth --enable-libilbc \
	--enable-libxavs --enable-fontconfig --enable-libbs2b --enable-libzvbi --enable-libtwolame --enable-libsmbclient \
	--enable-cuda --enable-cuvid --enable-libnpp
cov-build --dir cov-int make -j4 all alltools examples testprogs
tar czvf project.tgz README cov-int

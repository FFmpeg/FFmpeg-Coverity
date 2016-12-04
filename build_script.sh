#!/bin/bash
set -e

cd /root

wget -q https://scan.coverity.com/download/linux64 --post-data "token=${COVERITY_SCAN_TOKEN}&project=FFmpeg%2FFFmpeg" -O coverity_tool.tgz
tar xaf coverity_tool.tgz
rm coverity_tool.tgz
mv cov-analysis-linux64-* cov-analysis-linux64
export PATH="${PATH}:${PWD}/cov-analysis-linux64/bin"

git clone --depth=1 https://git.videolan.org/git/ffmpeg.git ffmpeg
cd ffmpeg

echo "Configuring..."
./configure --enable-gpl --enable-nonfree --enable-version3 --enable-debug=3 --assert-level=2 --cpu=core2 \
	--enable-avisynth \
	--enable-cuda \
	--enable-cuvid \
	--enable-fontconfig \
	--enable-frei0r \
	--enable-iconv \
	--enable-libass \
	--enable-libbluray \
	--enable-libbs2b \
	--enable-libcaca \
	--enable-libcdio \
	--enable-libdc1394 \
	--enable-libfdk-aac \
	--enable-libflite \
	--enable-libfreetype \
	--enable-libgme \
	--enable-libgsm \
	--enable-libiec61883 \
	--enable-libilbc \
	--enable-libkvazaar \
	--enable-libmodplug \
	--enable-libmp3lame \
	--enable-libnpp \
	--enable-libopencore-amrnb \
	--enable-libopencore-amrwb \
	--enable-libopencv \
	--enable-libopenh264 \
	--enable-libopenjpeg \
	--enable-libopus \
	--enable-libpulse \
	--enable-librubberband \
	--enable-libschroedinger \
	--enable-libshine \
	--enable-libsmbclient \
	--enable-libsnappy \
	--enable-libsoxr \
	--enable-libspeex \
	--enable-libssh \
	--enable-libtesseract \
	--enable-libtheora \
	--enable-libtwolame \
	--enable-libv4l2 \
	--enable-libvo-amrwbenc \
	--enable-libvorbis \
	--enable-libvpx \
	--enable-libwavpack \
	--enable-libwebp \
	--enable-libx264 \
	--enable-libx265 \
	--enable-libxavs \
	--enable-libxvid \
	--enable-libzimg \
	--enable-libzvbi \
	--enable-openal \
	--enable-openssl \
	--enable-pthreads \
	--enable-vaapi \
	--enable-vdpau \
	--enable-x11grab
cov-build --dir cov-int make -j4 all alltools examples testprogs
tar czvf cov-int.tgz cov-int

[ -n "$COVERITY_DRY_RUN" ] && exit 0

SCM_TAG="$(./version.sh)"

curl --form token="${COVERITY_SCAN_TOKEN}" \
	--form file=@cov-int.tgz \
	--form email="${COVERITY_SCAN_NOTIFICATION_EMAIL}" \
	--form version="${SCM_TAG}" \
	--form description="Automatic Coverity Scan build for ${SCM_TAG}" \
	"https://scan.coverity.com/builds?project=FFmpeg%2FFFmpeg"

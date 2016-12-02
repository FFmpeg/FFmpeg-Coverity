#!/bin/bash
set -e

cd /root

wget https://scan.coverity.com/download/linux64 --post-data "token=${COVERITY_SCAN_TOKEN}&project=FFmpeg%2FFFmpeg" -O coverity_tool.tgz
tar xaf coverity_tool.tgz
rm coverity_tool.tgz
mv cov-analysis-linux64-* cov-analysis-linux64
export PATH="${PATH}:${PWD}/cov-analysis-linux64/bin"

git clone --depth=1 https://git.videolan.org/git/ffmpeg.git ffmpeg
cd ffmpeg

echo "Configuring..."
./configure --enable-gpl --enable-nonfree --enable-version3 --enable-debug=3 --assert-level=2 --cpu=core2 \
	--enable-libspeex --enable-libvpx --enable-libopenjpeg --enable-pthreads --enable-libvorbis \
	--enable-libx264 --enable-libx265 --enable-libdc1394 --enable-libxvid --enable-libfreetype \
	--enable-libmodplug --enable-libpulse --enable-libmp3lame --enable-libbluray --enable-x11grab \
	--enable-libtheora --enable-openssl --enable-libschroedinger --enable-libcaca --enable-libopus \
	--enable-libcdio --enable-openal --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libvo-amrwbenc --enable-libgsm \
	--enable-vdpau --enable-vaapi --enable-iconv --enable-libgme --enable-libwebp --enable-libopencv \
	--enable-libass --enable-frei0r --enable-libsoxr --enable-libfdk-aac --enable-avisynth --enable-libilbc \
	--enable-libxavs --enable-fontconfig --enable-libbs2b --enable-libzvbi --enable-libtwolame --enable-libsmbclient \
	--enable-cuda --enable-cuvid --enable-libnpp --enable-libzimg --enable-libflite --enable-libiec61883 --enable-libkvazaar \
	--enable-librubberband --enable-libsnappy --enable-libshine --enable-libssh --enable-libtesseract --enable-libv4l2 \
	--enable-libwavpack --enable-libopenh264
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

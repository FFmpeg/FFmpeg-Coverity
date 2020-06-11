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

# Not yet enabled:
# 	--enable-jni \
# 	--enable-mediacodec \
# 	--enable-mmal \
# 	--enable-omx-rpi \
# Cannot be enabled at the same time as openssl:
#	--enable-gnutls \
# Library in Debian too new for ffmpeg:
#	--enable-libopencv \
# https://lists.samba.org/archive/samba-technical/2018-October/130668.html
#	--enable-libsmbclient \

./configure --enable-gpl --enable-nonfree --enable-version3 --enable-debug=3 --assert-level=2 --cpu=core2 \
	--disable-stripping --disable-doc \
	--enable-avisynth \
	--enable-chromaprint \
	--enable-cuda-llvm \
	--enable-cuvid \
	--enable-decklink \
	--enable-ffnvcodec \
	--enable-fontconfig \
	--enable-frei0r \
	--enable-gcrypt \
	--enable-gmp \
	--enable-ladspa \
	--enable-iconv \
	--enable-libass \
	--enable-libbluray \
	--enable-libbs2b \
	--enable-libcaca \
	--enable-libcdio \
	--enable-libcelt \
	--enable-libdc1394 \
	--enable-libfdk-aac \
	--enable-libflite \
	--enable-libfontconfig \
	--enable-libfreetype \
	--enable-libfribidi \
	--enable-libgme \
	--enable-libgsm \
	--enable-libiec61883 \
	--enable-libilbc \
	--enable-libkvazaar \
	--enable-libmfx \
	--enable-libmodplug \
	--enable-libmp3lame \
	--enable-libopencore-amrnb \
	--enable-libopencore-amrwb \
	--enable-libopenh264 \
	--enable-libopenjpeg \
	--enable-libopenmpt \
	--enable-libopus \
	--enable-libpulse \
	--enable-librtmp \
	--enable-librubberband \
	--enable-libshine \
	--enable-libsnappy \
	--enable-libsoxr \
	--enable-libspeex \
	--enable-libssh \
	--enable-libtesseract \
	--enable-libtheora \
	--enable-libtwolame \
	--enable-libv4l2 \
	--enable-libvidstab \
	--enable-libvo-amrwbenc \
	--enable-libvorbis \
	--enable-libvpx \
	--enable-libwavpack \
	--enable-libwebp \
	--enable-libx264 \
	--enable-libx265 \
	--enable-libxavs \
	--enable-libxcb \
	--enable-libxcb-shape \
	--enable-libxcb-shm \
	--enable-libxcb-xfixes \
	--enable-libxvid \
	--enable-libzimg \
	--enable-libzmq \
	--enable-libzvbi \
	--enable-libmysofa \
	--enable-omx \
	--enable-openal \
	--enable-opencl \
	--enable-opengl \
	--enable-openssl \
	--enable-pthreads \
	--enable-vaapi \
	--enable-vdpau

# Skip linking, it's slow and not needed.
sed -i 's|^LD=.*|LD=/root/fake_ld.sh|' ./ffbuild/config.mak

cov-build --dir cov-int make -j4 all alltools examples testprogs
tar czvf cov-int.tgz cov-int

if [[ $COVERITY_DRY_RUN == true ]]; then
    echo "Dryrunning, skipping coverity upload."
    exit
fi

echo "Uploading results to coverity..."

SCM_TAG="$(./ffbuild/version.sh)"

curl --form token="${COVERITY_SCAN_TOKEN}" \
	--form file=@cov-int.tgz \
	--form email="${COVERITY_SCAN_NOTIFICATION_EMAIL}" \
	--form version="${SCM_TAG}" \
	--form description="Automatic Coverity Scan build for ${SCM_TAG}" \
	"https://scan.coverity.com/builds?project=FFmpeg%2FFFmpeg"

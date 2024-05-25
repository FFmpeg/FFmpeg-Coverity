#!/bin/bash
set -e

cd /root

echo "Downloading coverity tools..."

wget -q https://scan.coverity.com/download/linux64 --post-data "token=${COVERITY_SCAN_TOKEN}&project=FFmpeg%2FFFmpeg" -O coverity_tool.tgz
tar xaf coverity_tool.tgz
rm coverity_tool.tgz
mv cov-analysis-linux64-* cov-analysis-linux64
export PATH="${PATH}:${PWD}/cov-analysis-linux64/bin"

git clone --depth=1 https://git.videolan.org/git/ffmpeg.git ffmpeg
cd ffmpeg

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
LINUX_OPTIONS=(
    --cpu=core2
	--enable-avisynth
	--enable-chromaprint
	--enable-cuda-llvm
	--enable-cuvid
	--enable-decklink
	--enable-ffnvcodec
	--enable-fontconfig
	--enable-frei0r
	--enable-gcrypt
	--enable-gmp
	--enable-ladspa
	--enable-iconv
	--enable-libass
	--enable-libbluray
	--enable-libbs2b
	--enable-libcaca
	--enable-libcdio
	--enable-libcelt
	--enable-libdc1394
	--enable-libfdk-aac
	--enable-libflite
	--enable-libfontconfig
	--enable-libfreetype
	--enable-libfribidi
	--enable-libgme
	--enable-libgsm
	--enable-libiec61883
	--enable-libilbc
	--enable-libkvazaar
	--enable-libvpl
	--enable-libmodplug
	--enable-libmp3lame
	--enable-libopencore-amrnb
	--enable-libopencore-amrwb
	--enable-libopenh264
	--enable-libopenjpeg
	--enable-libopenmpt
	--enable-libopus
	--enable-libpulse
	--enable-librtmp
	--enable-librubberband
	--enable-libshine
	--enable-libsnappy
	--enable-libsoxr
	--enable-libspeex
	--enable-libssh
	--enable-libtesseract
	--enable-libtheora
	--enable-libtwolame
	--enable-libv4l2
	--enable-libvidstab
	--enable-libvo-amrwbenc
	--enable-libvorbis
	--enable-libvpx
	--enable-libwebp
	--enable-libx264
	--enable-libx265
	--enable-libxavs
	--enable-libxcb
	--enable-libxcb-shape
	--enable-libxcb-shm
	--enable-libxcb-xfixes
	--enable-libxml2
	--enable-libxvid
	--enable-libzimg
	--enable-libzmq
	--enable-libzvbi
	--enable-libmysofa
	--enable-omx
	--enable-openal
	--enable-opencl
	--enable-opengl
	--enable-openssl
	--enable-pthreads
	--enable-vaapi
	--enable-vdpau
)

WINDOWS_OPTIONS=(
    --cpu=core2
    --arch=x86_64
    --target-os=mingw64
    --cross-prefix=x86_64-w64-mingw32-
)
cov-configure --template --compiler x86_64-w64-mingw32-gcc --comptype gcc

for CONFIG in LINUX WINDOWS; do
    echo "Configuring ${CONFIG}..."

    CURRENT_OPTIONS_NAME="${CONFIG}_OPTIONS[@]"

    ./configure --enable-gpl --enable-nonfree --enable-version3 \
        --enable-debug=3 --assert-level=2 \
        --disable-stripping --disable-doc \
        "${!CURRENT_OPTIONS_NAME}"

    # Skip linking, it's slow and not needed.
    sed -i 's|^LD=.*|LD=/root/fake_ld.sh|' ./ffbuild/config.mak

    cov-build --dir ../cov-int make -j"$(nproc)" all alltools examples testprogs

    git clean -fxd
    git reset --hard
done

cd ..
tar czvf cov-int.tgz cov-int

if [[ $COVERITY_DRY_RUN == true ]]; then
    echo "Dryrunning, skipping coverity upload."
    exit
fi

echo "Uploading results to coverity..."

SCM_TAG="$(cd ffmpeg && ./ffbuild/version.sh)"

curl --form token="${COVERITY_SCAN_TOKEN}" \
	--form file=@cov-int.tgz \
	--form email="${COVERITY_SCAN_NOTIFICATION_EMAIL}" \
	--form version="${SCM_TAG}" \
	--form description="Automatic Coverity Scan build for ${SCM_TAG}" \
	"https://scan.coverity.com/builds?project=FFmpeg%2FFFmpeg"

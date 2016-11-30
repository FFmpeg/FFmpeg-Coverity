#!/bin/bash
set -e
git clone https://git.videolan.org/git/ffmpeg.git /root/ffmpeg
cd /root/ffmpeg
./configure --enable-gpl --enable-nonfree --enable-version3 --enable-debug=3 --assert-level=2
cov-build --dir cov-int make -j4 all alltools examples testprogs
tar czvf project.tgz README cov-int

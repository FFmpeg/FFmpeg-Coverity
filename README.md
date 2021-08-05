# FFmpeg-Coverity
Dockerfile for an ffmpeg coverity testing environment.

Usage:

```
export COVERITY_SCAN_NOTIFICATION_EMAIL=...
export COVERITY_SCAN_TOKEN=...
docker pull ffmpeg/coverity
docker run --env COVERITY_SCAN_NOTIFICATION_EMAIL --env COVERITY_SCAN_TOKEN ffmpeg/coverity
```


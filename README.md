# FFmpeg-Coverity
Dockerfile for an ffmpeg coverity testing environment

Usage:

```
export COV_EMAIL=...
export COV_TOKEN=...
docker pull ffmpeg/coverity
docker run --env COV_EMAIL --env COV_TOKEN ffmpeg/coverity
```


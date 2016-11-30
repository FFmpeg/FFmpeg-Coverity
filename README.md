# ffmpeg-build-docker
Dockerfile for an ffmpeg build environment

Usage:

```
export COV_EMAIL=...
export COV_TOKEN=...
docker pull btbn/ffmpeg-coverity
docker run --env COV_EMAIL --env COV_TOKEN btbn/ffmpeg-coverity
```


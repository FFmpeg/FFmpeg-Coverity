FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN \
	apt-get -y update && \
	apt-get -y install build-essential yasm pkg-config

ADD build_script.sh /root/build_script.sh

CMD ["/root/build_script.sh"]

FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN \
	apt-get -y update && \
	apt-get -y install build-essential yasm pkg-config git && \
	apt-get -y clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get -y update
RUN apt-get -y install frei0r-plugins-dev

ADD build_script.sh /root/build_script.sh

CMD ["/root/build_script.sh"]

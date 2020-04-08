FROM ubuntu:19.10

ADD .vimrc /root/.vimrc

RUN apt update && \
	apt install -y make lsb-release sudo software-properties-common

ENTRYPOINT ["/bin/bash"]

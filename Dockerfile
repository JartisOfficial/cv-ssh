FROM ubuntu:22.04

ARG my_user="cv" 
ARG my_password="cv"
WORKDIR "/"

ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin"

RUN apt-get update && apt-get install -y git openssh-server tmux minicom sudo vim bmon htop mc supervisor

# user
RUN useradd --create-home --shell /bin/bash "$my_user"
RUN echo "$my_user:$my_password" | chpasswd
RUN usermod -aG dialout "$my_user"
RUN usermod -aG sudo "$my_user"

## ssh
## genkey @entrypoint
COPY sshd_config /etc/ssh/sshd_config
RUN mkdir /run/sshd

# ssh:2222
EXPOSE 2222

#install opencv
RUN apt-get update && apt-get install -y \
	build-essential \
	git \
	pkg-config \
	cmake \
	libgtk2.0-dev \
	libavcodec-dev \
	libavformat-dev \
	libswscale-dev \
	python3-dev \
	python3-numpy \
	libtbb2 \
	libtbb-dev \
	libjpeg-dev \
	libpng-dev \
	libtiff-dev \
	qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
	qtcreator \
	llvm \
	clang \
	libclang-dev \
	libdc1394-dev

RUN mkdir -p /git
RUN cd /git && git clone --single-branch  --branch 4.8.1 https://github.com/opencv/opencv.git
RUN mkdir -p /git/opencv/build
WORKDIR /git/opencv/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D INSTALL_C_EXAMPLES=OFF \
	-D INSTALL_PYTHON_EXAMPLES=OFF \
	-D WITH_TBB=ON \
	-D WITH_QT=ON \
	-D WITH_OPENGL=ON \
	-D BUILD_EXAMPLES=OFF \
	-D BUILD_TIFF=ON \
	-D OPENCV_GENERATE_PKGCONFIG=ON \
	..

RUN make -j12
RUN make install
RUN ldconfig

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /

CMD ["/entrypoint.sh"]

FROM ubuntu:focal

ENV GAP_VERSION 4.12.1

MAINTAINER James D. Mitchell <jdm3@st-andrews.ac.uk>

ARG DEBIAN_FRONTEND=noninteractive

RUN    apt-get update -qq \
    && apt-get -qq install -y autoconf build-essential m4 libreadline6-dev libncurses5-dev curl \
                              unzip libgmp3-dev cmake gcc g++ sudo libtool

RUN    adduser --quiet --shell /bin/bash --gecos "GAP user,101,," --disabled-password gap \
    && adduser gap sudo \
    && chown -R gap:gap /home/gap/ \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && cd /home/gap \
    && touch .sudo_as_admin_successful

RUN    mkdir -p /home/gap/inst \
    && cd /home/gap/inst \
    && curl -L -O https://github.com/gap-system/gap/releases/download/v${GAP_VERSION}/gap-${GAP_VERSION}-core.zip \
    && unzip gap-${GAP_VERSION}-core.zip \
    && rm gap-${GAP_VERSION}-core.zip \
    && cd gap-${GAP_VERSION} \
    && ./configure --with-gmp=system \
    && make \
    && cp bin/gap.sh bin/gap \
    && mkdir -p /home/gap/inst/gap-${GAP_VERSION}/pkg \
    && curl -L -O https://github.com/gap-packages/PackageManager/archive/v1.3.tar.gz \
    && tar xvzf v1.3.tar.gz \
    && rm v1.3.tar.gz \
    && mv PackageManager-1.3 /home/gap/inst/gap-${GAP_VERSION}/pkg \
    && echo "LoadPackage(\"PackageManager\"); UpdatePackage(\"PackageManager\", false); if not InstallRequiredPackages(); then QuitGap(1); fi; QuitGap(0);" | bin/gap --bare || exit 1 \
    && mv /root/.gap/ /home/gap/ \
    && mv /home/gap/.gap/pkg/* /home/gap/inst/gap-${GAP_VERSION}/pkg \ 
    && chown -R gap:gap /home/gap/inst \
    && chown -R gap:gap /home/gap/.gap 

# Line 36 can be deleted when we have GAP 4.12.2 or 4.13.0

# Set up new user and home directory in environment.
# Note that WORKDIR will not expand environment variables in docker versions < 1.3.1.
# See docker issue 2637: https://github.com/docker/docker/issues/2637
USER gap
ENV HOME /home/gap
ENV GAP_HOME /home/gap/inst/gap-${GAP_VERSION}
ENV PATH ${GAP_HOME}/bin:${PATH}

# Start at $HOME.
WORKDIR /home/gap

# Start from a BASH shell.
CMD ["bash"]

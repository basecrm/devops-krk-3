FROM ubuntu:12.04
MAINTAINER Mirosław Nagaś <mirek@getbase.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq

# install basic software
RUN apt-get install -y curl git

# Ruby/Rails
RUN \curl -L https://get.rvm.io | bash -s stable
RUN echo 'source /usr/local/rvm/scripts/rvm' >> /etc/bash.bashrc
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.1.0"
RUN /bin/bash -l -c "rvm use 2.1.0 --default"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

# Python/Django
RUN apt-get install -y python-pip

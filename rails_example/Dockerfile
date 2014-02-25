FROM basebox:latest

ENV DEBIAN_FRONTEND noninteractive

# install libmysqlclient library as our application uses MySQL
RUN apt-get install -y libmysqlclient-dev

RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
RUN /bin/bash -l -c "bundle install"
ADD . /myapp

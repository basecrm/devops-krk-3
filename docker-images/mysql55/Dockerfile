FROM ubuntu:12.04
MAINTAINER Mirosław Nagaś <mirek@getbase.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq
RUN apt-get -y install mysql-server-5.5

RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

ADD set-access-rights.sh /tmp/set-access-rights.sh
RUN /bin/sh /tmp/set-access-rights.sh

expose 3306

CMD ["/usr/sbin/mysqld"]

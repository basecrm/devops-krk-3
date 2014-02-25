FROM ubuntu:12.04
MAINTAINER Mirosław Nagaś <mirek@getbase.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq
RUN apt-get install -y python-yaml python-jinja2 python-pycurl python-pip python-apt git
RUN apt-get clean

RUN git clone http://github.com/ansible/ansible.git /tmp/ansible
WORKDIR /tmp/ansible
ENV PATH /tmp/ansible/bin:/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin
ENV ANSIBLE_LIBRARY /tmp/ansible/library
ENV PYTHONPATH /tmp/ansible/lib:$PYTHON_PATH
RUN git clone https://github.com/basecrm/devops-krk-3 /tmp/basecrm-devops-krk
RUN mkdir /etc/ansible
RUN echo "[local]\nlocalhost" > /etc/ansible/hosts
WORKDIR /tmp/basecrm-devops-krk/ansible
RUN pip install -r requirements.txt
RUN ansible-playbook rabbitmq.yml -c local

CMD /usr/sbin/rabbitmq-server

EXPOSE 5672 15672

FROM docker.io/angstroms/angs_aboss_report:appserver
MAINTAINER Wattana Inthaphong <wattaint@gmail.com>

ADD appserver/Gemfile /tmp/Gemfile
ADD appserver/Gemfile.lock /tmp/Gemfile.lock

RUN cd /tmp \ 
&& bundle install

FROM centos:7.1.1503
MAINTAINER Wattana Inthaphong <wattaint@gmail.com>
# enable centos plus repo and install epel repo
RUN yum update -y \
&& rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm \
&& yum install -y git wget tar mlocate vim which bzip2 zip unzip \
&& yum clean all

# wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.rpm

#COPY jdk-8u51-linux-x64.rpm /tmp/jdk-8u51-linux-x64.rpm
#RUN rpm -Uvh /tmp/jdk-8u51-linux-x64.rpm && rm -rf /tmp/jdk-8u51-linux-x64.rpm

RUN wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.rpm \
&& rpm -Uvh /jdk-8u51-linux-x64.rpm && rm -rf /jdk-8u51-linux-x64.rpm


COPY UnlimitedJCEPolicy/local_policy.jar /usr/java/latest/lib/security/local_policy.jar
COPY UnlimitedJCEPolicy/US_export_policy.jar /usr/java/latest/lib/security/US_export_policy.jar

RUN wget https://s3.amazonaws.com/jruby.org/downloads/9.0.0.0/jruby-bin-9.0.0.0.tar.gz \
&& tar -xf /jruby-bin-9.0.0.0.tar.gz \
&& rm -rf /jruby-bin-9.0.0.0.tar.gz

RUN ln -s /jruby-9.0.0.0/bin/jruby /jruby-9.0.0.0/bin/ruby

ENV PATH /jruby-9.0.0.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN gem install bundler \
&& gem install --no-rdoc --no-ri rails -v '4.2.3' \
&& gem install --no-rdoc --no-ri torquebox -v '4.0.0.beta1'

ENV JRUBY_HOME /jruby-9.0.0.0

RUN cd /tmp \
&& rails new jreport --database=postgresql \
&& cd / \
&& rm -rf /tmp/jreport
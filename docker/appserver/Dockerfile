FROM centos:7.1.1503
MAINTAINER Wattana Inthaphong <wattaint@gmail.com>
# enable centos plus repo and install epel repo
RUN yum update -y \
&& yum install -y epel-release \
&& yum install -y git wget tar mlocate vim which bzip2 zip unzip \
&& yum clean all

# wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.rpm

#COPY jdk-8u51-linux-x64.rpm /tmp/jdk-8u51-linux-x64.rpm
#RUN rpm -Uvh /tmp/jdk-8u51-linux-x64.rpm && rm -rf /tmp/jdk-8u51-linux-x64.rpm

RUN wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.rpm \
&& rpm -Uvh /jdk-8u51-linux-x64.rpm && rm -rf /jdk-8u51-linux-x64.rpm


COPY UnlimitedJCEPolicy/local_policy.jar /usr/java/latest/lib/security/local_policy.jar
COPY UnlimitedJCEPolicy/US_export_policy.jar /usr/java/latest/lib/security/US_export_policy.jar

COPY UnlimitedJCEPolicy/local_policy.jar /usr/java/jdk1.8.0_51/jre/lib/security/local_policy.jar
COPY UnlimitedJCEPolicy/US_export_policy.jar /usr/java/jdk1.8.0_51/jre/lib/security/US_export_policy.jar

RUN wget https://s3.amazonaws.com/jruby.org/downloads/1.7.22/jruby-bin-1.7.22.tar.gz \
&& tar -xf /jruby-bin-1.7.22.tar.gz \
&& rm -rf /jruby-bin-1.7.22.tar.gz

#RUN ln -s /jruby-1.7.19/bin/jruby /jruby-1.7.19/bin/ruby

ENV PATH /jruby-1.7.22/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN gem install bundler \
&& gem install --no-rdoc --no-ri rails -v '3.2.22' --platform jruby \
&& gem install --no-rdoc --no-ri torquebox -v '3.1.2' --platform jruby \
&& gem install --no-rdoc --no-ri torquebox-server -v '3.1.2' --platform jruby

ENV JRUBY_HOME /jruby-1.7.22

RUN cd /tmp \
&& rails new jreport --database=postgresql \
&& cd / \
&& rm -rf /tmp/jreport

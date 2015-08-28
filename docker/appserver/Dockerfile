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

#RUN wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.rpm \
#&& rpm -Uvh /jdk-8u51-linux-x64.rpm && rm -rf /jdk-8u51-linux-x64.rpm

#COPY UnlimitedJCEPolicy/local_policy.jar /usr/java/latest/lib/security/local_policy.jar
#COPY UnlimitedJCEPolicy/US_export_policy.jar /usr/java/latest/lib/security/US_export_policy.jar

#COPY UnlimitedJCEPolicy/local_policy.jar /usr/java/jdk1.8.0_51/jre/lib/security/local_policy.jar
#COPY UnlimitedJCEPolicy/US_export_policy.jar /usr/java/jdk1.8.0_51/jre/lib/security/US_export_policy.jar

ENV JRUBY_VERSION 1.7.22
ENV TORQUEBOX_VERSION 3.1.2
#ENV JDK_VERSION 7u79
#ENV JDK_RELEASE $JDK_VERSION-b15
ENV JDK_VERSION 8u51
ENV JDK_RELEASE $JDK_VERSION-b16
ENV JRUBY_OPTS "-J-Xmx2g -J-Xms1g -Xcompile.invokedynamics=false"
ENV PATH $PATH:/jruby-$JRUBY_VERSION/bin
ENV JRUBY_HOME /jruby-$JRUBY_VERSION
ENV TORQUEBOX_HOME /jruby-$JRUBY_VERSION/lib/ruby/gems/shared/gems/torquebox-server-$TORQUEBOX_VERSION-java
ENV JBOSS_HOME /jruby-$JRUBY_VERSION/lib/ruby/gems/shared/gems/torquebox-server-$TORQUEBOX_VERSION-java/jboss
ENV JRUBY_HOME /jruby-$JRUBY_VERSION

RUN wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/$JDK_RELEASE/jdk-$JDK_VERSION-linux-x64.rpm \
&& rpm -Uvh /jdk-$JDK_VERSION-linux-x64.rpm && rm -rf /jdk-$JDK_VERSION-linux-x64.rpm

RUN wget https://s3.amazonaws.com/jruby.org/downloads/$JRUBY_VERSION/jruby-bin-$JRUBY_VERSION.tar.gz \
&& tar -xf /jruby-bin-$JRUBY_VERSION.tar.gz \
&& rm -rf /jruby-bin-$JRUBY_VERSION.tar.gz \
&& gem install bundler \
&& gem install --no-rdoc --no-ri rails -v '3.2.22' \
&& gem install --no-rdoc --no-ri torquebox -v '3.1.2', --platform jruby \
&& gem install --no-rdoc --no-ri torquebox-server -v '3.1.2', --platform jruby \
&& cd /tmp \
&& rails new jreport --database=postgresql \
&& cd / \
&& rm -rf /tmp/jreport
FROM centos:7.1.1503
MAINTAINER Wattana Inthaphong <wattaint@gmail.com>

# enable centos plus repo and install epel repo
RUN yum update -y \
&& rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm \
&& rpm -iUvh http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-1.noarch.rpm \
&& yum install -y postgresql94 postgresql94-devel postgresql94-libs postgresql94-server \
&& yum install -y wget vim mlocate which tar bzip2 zip unzip \
&& yum install -y ruby ruby-devel make gcc \
|| yum clean all

ENV PATH /usr/pgsql-9.4/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN gem install --no-rdoc --no-ri popen4 \
&& gem install --no-rdoc --no-ri pg

ENTRYPOINT ["/usr/bin/ruby"]
CMD ["/entry"]

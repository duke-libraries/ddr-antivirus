FROM centos:7

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
	yum clean all && \
	yum -y update && \
	yum -y install clamd clamav-data

RUN echo "TCPSocket 3310" > /etc/clamd.d/docker.conf
COPY docker-entrypoint.sh /usr/bin/
RUN chmod u+x /usr/bin/docker-entrypoint.sh
EXPOSE 3310

ENTRYPOINT ["docker-entrypoint.sh"]

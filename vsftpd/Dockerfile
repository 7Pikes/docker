FROM debian:jessie

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -yqq --no-install-recommends vsftpd libpam-mysql libpam-pgsql runit && rm -rf /var/lib/apt/lists/*
ADD https://github.com/peterbourgon/runsvinit/releases/download/v2.0.0/runsvinit-linux-amd64.tgz /tmp
ADD https://github.com/timonier/syslog-stdout/releases/download/v1.1.1/syslog-stdout.tar.gz /tmp
RUN tar zxf /tmp/runsvinit-linux-amd64.tgz -C / \
 && tar zxf /tmp/syslog-stdout.tar.gz -C /usr/sbin \
 && rm /tmp/* \
 && sed -i 's/pam_service_name=vsftpd/pam_service_name=vsftpd.virtual/' /etc/vsftpd.conf \
 && echo >> /etc/vsftpd.conf \
 && echo 'write_enable=YES' >> /etc/vsftpd.conf \
 && echo 'guest_enable=YES' >> /etc/vsftpd.conf \
 && echo 'chroot_local_user=YES' >> /etc/vsftpd.conf \
 && echo 'allow_writeable_chroot=YES' >> /etc/vsftpd.conf \
 && echo 'virtual_use_local_privs=YES' >> /etc/vsftpd.conf \
 && echo 'syslog_enable=YES' >> /etc/vsftpd.conf \
 && echo 'seccomp_sandbox=NO' >> /etc/vsftpd.conf \
 && echo 'isolate_network=NO' >> /etc/vsftpd.conf \
 && echo 'local_umask=022' >> /etc/vsftpd.conf \
 && echo 'guest_username=ftp' >> /etc/vsftpd.conf \
 && echo 'local_root=/srv/ftp/$USER' >> /etc/vsftpd.conf \
 && echo 'user_sub_token=$USER' >> /etc/vsftpd.conf \
 && echo 'user_config_dir=/etc/vsftpd.conf.d' >> /etc/vsftpd.conf \
 && mkdir /etc/vsftpd.conf.d \
 && mkdir -p /var/run/vsftpd/empty

COPY service /etc/service
COPY entrypoint.sh /

VOLUME /srv/ftp
EXPOSE 21

ENTRYPOINT [ "/entrypoint.sh" ]

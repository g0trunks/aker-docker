FROM docker.io/centos:7
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y python2-paramiko python-configparser python-urwid git
RUN cd /root && git clone https://github.com/aker-gateway/Aker.git
RUN cd /root/Aker && git checkout phase0
RUN mkdir -p /bin/aker && cp /root/Aker/*py /bin/aker
RUN cp /root/Aker/aker.ini /etc
RUN chmod 755 /bin/aker/aker.py
RUN yum -y install openssh-server passwd
RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 
RUN echo "Match Group *,!root" >> /etc/ssh/sshd_config
RUN echo "    ForceCommand /bin/aker/aker.py" >> /etc/ssh/sshd_config
ENTRYPOINT ["/usr/sbin/sshd", "-D"]

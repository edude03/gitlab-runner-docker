FROM ubuntu:13.10
MAINTAINER Michael Francis "edude03@gmail.com"

#Update Apt
RUN apt-get update -y 

#Install all the deps
RUN apt-get install -y wget curl gcc libxml2-dev libxslt-dev libcurl4-openssl-dev libreadline6-dev libc6-dev libssl-dev make build-essential zlib1g-dev openssh-server git-core libyaml-dev postfix libpq-dev libicu-dev

#Download and Build Ruby
RUN mkdir /tmp/ruby && cd /tmp/ruby && curl --progress ftp://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p353.tar.gz | tar xz

#Automatically determine the number of processors for the build
RUN export NUMCPUS=`grep -c '^processor' /proc/cpuinfo`
RUN cd /tmp/ruby/ruby-2.0.0-p353 && ./configure --disable-install-rdoc && make -j$NUMCPUS && make install

#Download and build the runner
RUN gem install bundler
RUN adduser --disabled-login --gecos 'GitLab CI Runner' gitlab_ci_runner
RUN su gitlab_ci_runner
RUN cd ~/ && git clone https://gitlab.com/gitlab-org/gitlab-ci-runner.git && cd gitlab-ci-runner && bundle install 

#Setup SSH
RUN mkdir -p /root/.ssh
RUN touch /root/.ssh/known_hosts

#Add the deploy key
ADD ./id_rsa /root/.ssh/id_rsa
ADD ./id_rsa.pub /root/.ssh/id_rsa.pub
ADD ./ssh_config /root/.ssh/config

# Set the correct permissions on the key
RUN chown root:root /root/.ssh/* && chmod 0600 /root/.ssh/id_rsa

#Add $DEPLOY_HOST to the know hosts
RUN ssh-keyscan -H $DEPLOY_HOST >> /root/.ssh/known_hosts

#Setup NodeJS
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:chris-lea/node.js && apt-get update && apt-get install nodejs -y 


#Setup the image at startup
WORKDIR /gitlab-ci-runner
CMD export HOME=/root && eval $(ssh-agent)  && ssh-keyscan -H $GITLAB_URL >> /root/.ssh/known_hosts && bundle exec ./bin/setup_and_run

FROM centos:6.8
MAINTAINER tolivares@gmail.com
ARG GIT_SECRET=local

# Set Pasenger Version
ENV PASSENGER_VERSION="4.0.23" \
    PATH="/opt/passenger/bin:$PATH" \
    RAILS_ROOT="/home/yfl_app" \
    GIT_SECRET=${GIT_SECRET}

# Update repo & release as well as install needed packages
RUN yum install -y epel-release \
&& yum update -y \
&& yum -y install git rubygems ruby-devel gcc httpd httpd-devel gcc-c++ curl-devel openssl-devel zlib-devel mod_ssl mysql mysql-devel \
# Install needed gems for the application
&& gem update --system --no-ri --no-rdoc \
&& gem update --system 1.4.2 --no-ri --no-rdoc \
&& gem install rack -v 1.0.1 --no-ri --no-rdoc \
&& gem install rake -v 10.1.0 --no-ri --no-rdoc \
&& gem install rdoc -v 4.0.1 --no-ri --no-rdoc \
&& gem install mime-types -v 1.16 --no-ri --no-rdoc \
&& gem install xml-simple -v 1.1.5 --no-ri --no-rdoc \
&& gem install builder -v 3.2.2 --no-ri --no-rdoc \
&& gem install json -v 1.8.3 --no-ri --no-rdoc \
&& gem install mysql -v 2.9.1 --no-ri --no-rdoc \
&& gem install aws-s3 -v 0.6.3 --ignore-dependencies --no-ri --no-rdoc \
# Install Phusion Passenger
&& mkdir -p /opt \
&& curl -L https://s3.amazonaws.com/phusion-passenger/releases/passenger-$PASSENGER_VERSION.tar.gz | tar -xzf - -C /opt \
&& mv /opt/passenger-$PASSENGER_VERSION /opt/passenger \
&& /opt/passenger/bin/passenger-install-apache2-module --auto \
# Clone git repo
&& git clone -b yfl_app https://${GIT_SECRET}:x-oauth-basic@github.com/choclo/yfl_app.git $RAILS_ROOT
# Copy needed files such as ssl certs and apache conf
COPY files/app.yourflightlog.com.key /etc/pki/tls/private/
COPY files/app.yourflightlog.com.crt /etc/pki/tls/certs/
COPY files/ca.pem /etc/pki/tls/certs/
COPY files/passenger.conf /etc/httpd/conf.d/

EXPOSE 80 443

WORKDIR $RAILS_ROOT
RUN RAILS_ENV=production rake gems:install
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

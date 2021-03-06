# Dockerfile to Owncloud
FROM patrckbrs/nginx-php5-fpm-resin

LABEL maintainer "Patrick Brunias <patrick@brunias.org>"

# Update sources && install packages
RUN DEBIAN_FRONTEND=noninteractive ;\
apt-get update && \
apt-get install --assume-yes \
  vim \
  curl \
  libcurl3-dev \
  php5-mysql \
  bzip2 \
  wget && \
  rm -rf /var/lib/apt/lists/* 
  
# Change upload-limits and -sizes
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 2048M/g" /etc/php5/fpm/php.ini && \
sed -i "s/post_max_size = 8M/post_max_size = 2048M/g" /etc/php5/fpm/php.ini && \
echo 'default_charset = "UTF-8"' >> /etc/php5/fpm/php.ini

COPY ./default /etc/nginx/sites-available/

# New version 9.1.1
RUN cd /var/www && wget https://download.owncloud.org/community/owncloud-9.1.2.tar.bz2 && tar jxvf owncloud-9.1.2.tar.bz2 && rm owncloud-9.1.2.tar.bz2 
RUN chown -R www-data:www-data /var/www/owncloud

# Set the current working directory
WORKDIR /var/www/owncloud

# Start container
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh

# Ports 
EXPOSE 80 443

# Boot up Nginx, and PHP5-FPM when container is started
CMD ["docker-entrypoint.sh"]

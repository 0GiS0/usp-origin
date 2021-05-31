FROM ubuntu:18.04

# Install wget
RUN apt-get update && apt-get install -y wget gnupg

# Add repository
RUN echo "deb [arch=amd64] https://stable.apt.unified-streaming.com bionic multiverse" > /etc/apt/sources.list.d/unified-streaming.list

# Add the Unified Streaming public key
RUN wget https://stable.apt.unified-streaming.com/unifiedstreaming.pub && apt-key add unifiedstreaming.pub

# Install Origin
RUN apt-get update \
    && apt-get install -y \
    python3 \
    apache2 \
    # apache2-proxy \
    # apache2-ssl \
    mp4split \
    libapache2-mod-smooth-streaming \
    libapache2-mod-unified-s3-auth 
    # mod_smooth_streaming \
    # mod_unified_s3_auth \
    # manifest-edit \
    # python3 \
    # py3-pip \
    # &&  pip3 install \
    # pyyaml==5.3.1 \
    # schema==0.7.3 

    # Set up directories and log file redirection
    RUN mkdir -p /run/apache2 \
    # && ln -s /dev/stderr /var/log/apache2/error.log \
    # && ln -s /dev/stdout /var/log/apache2/access.log \
    && mkdir -p /var/www/unified-origin


# COPY httpd.conf /etc/apache2/httpd.conf
# COPY unified-origin.conf.in /etc/apache2/conf.d/unified-origin.conf.in
# COPY s3_auth.conf.in /etc/apache2/conf.d/s3_auth.conf.in
# COPY remote_storage.conf.in /etc/apache2/conf.d/remote_storage.conf.in
# COPY transcode.conf.in /etc/apache2/conf.d/transcode.conf.in
# COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# COPY index.html /var/www/unified-origin/index.html
# COPY clientaccesspolicy.xml /var/www/unified-origin/clientaccesspolicy.xml
# COPY crossdomain.xml /var/www/unified-origin/crossdomain.xml

COPY httpd.conf /etc/apache2/httpd.conf
COPY unified-origin.conf.in /etc/apache2/sites-enabled/unified-origin.conf
COPY s3_auth.conf.in /etc/apache2/sites-enabled/s3_auth.conf
COPY remote_storage.conf.in /etc/apache2/sites-enabled/remote_storage.conf
COPY transcode.conf.in /etc/apache2/sites-enabled/transcode.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY index.html /var/www/unified-origin/index.html
COPY clientaccesspolicy.xml /var/www/unified-origin/clientaccesspolicy.xml
COPY crossdomain.xml /var/www/unified-origin/crossdomain.xml


RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["-D", "FOREGROUND"]

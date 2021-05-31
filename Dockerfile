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
    mp4split \
    libapache2-mod-smooth-streaming



# Set up directories and log file redirection
RUN mkdir -p /run/apache2 \
    && ln -sf /dev/stderr /var/log/apache2/error.log \
    && ln -sf /dev/stdout /var/log/apache2/access.log \
    && mkdir -p /var/www/unified-origin


COPY httpd.conf /etc/apache2/httpd.conf
COPY unified-origin.conf.in /etc/apache2/sites-enabled/unified-origin.conf
# COPY transcode.conf.in /etc/apache2/sites-enabled/transcode.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY index.html /var/www/unified-origin/index.html
COPY clientaccesspolicy.xml /var/www/unified-origin/clientaccesspolicy.xml
COPY crossdomain.xml /var/www/unified-origin/crossdomain.xml


RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["-D", "FOREGROUND"]

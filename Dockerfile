FROM debian:bullseye

LABEL maintainer="Fred <Fred@CreativeProjects.Tech>" \
      version="webgrind-1.9.2"

# expose default directory where we look for cachegrind files
VOLUME /tmp/xdebug

# expose only nginx HTTP port
EXPOSE 80

RUN apt-get update && apt-get install -y \
    nginx supervisor php-fpm php-cli \
    graphviz python git build-essential zlib1g-dev \
    # install webgrind from git and configure the default folder to be /tmp/xdebug
    && git clone --branch v1.9.2 --depth 1 https://github.com/jokkedk/webgrind.git /var/www/webgrind \
    && cd /var/www/webgrind && make && chown -R www-data.www-data /var/www/webgrind \
    && sed -ie "s|'/tmp'|'/tmp/xdebug'|g" config.php \
    && mkdir -p /tmp/xdebug && chown -R www-data.www-data /tmp/xdebug \
    && apt-get purge -y build-essential git \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/nginx/sites-enabled/default

# add webgrind as the only nginx site
COPY webgrind.nginx.conf /etc/nginx/sites-enabled/webgrind

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf

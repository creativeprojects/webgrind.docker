FROM debian:jessie

LABEL maintainer="Fred <Fred@CreativeProjects.Tech>" \
      version="webgrind-1.4.0"

# expose default directory where we look for cachegrind files
VOLUME /tmp/xdebug

# expose only nginx HTTP port
EXPOSE 80

RUN apt-get update && apt-get install -y \
    nginx supervisor php5-fpm php5-cli \
    graphviz python git build-essential \
    # install webgrind from git and configure the default folder to be /tmp/xdebug
    && git clone --branch v1.4.0 --depth 1 https://github.com/jokkedk/webgrind /var/www/webgrind \
    && cd /var/www/webgrind && make && chown -R www-data.www-data /var/www/webgrind \
    && sed -ie "s|'/tmp'|'/tmp/xdebug'|g" config.php \
    && chown -R www-data.www-data /tmp/xdebug \
    && apt-get purge -y build-essential git \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/nginx/sites-enabled/default

# add webgrind as the only nginx site
COPY webgrind.nginx.conf /etc/nginx/sites-enabled/webgrind

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf

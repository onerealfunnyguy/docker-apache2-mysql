FROM java:8
MAINTAINER Pierre FAY (@pfay)

# Config vars
ENV BAMBOO_HOME /var/atlassian/bamboo
ENV BAMBOO_INSTALL /opt/atlassian/bamboo
ENV BAMBOO_VERSION 5.9.7

# Install Atlassian Bamboo and helper tools and setup initial home
# directory structure.
RUN set -x \
    && apt-get update --quiet \
    && apt-get install --quiet --yes --no-install-recommends libtcnative-1 xmlstarlet php5 php5-curl vim wget \
    && apt-get clean \
    && mkdir -p                "${BAMBOO_HOME}" \
    && mkdir -p                "${BAMBOO_HOME}/caches/indexes" \
    && chmod -R 700            "${BAMBOO_HOME}" \
    && chown -R daemon:daemon  "${BAMBOO_HOME}" \
    && mkdir -p                "${BAMBOO_INSTALL}/conf/Catalina" \
    && curl -SL https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-$BAMBOO_VERSION.tar.gz -o /tmp/atlassian-bamboo-$BAMBOO_VERSION.tar.gz \
    && tar zxvf /tmp/atlassian-bamboo-$BAMBOO_VERSION.tar.gz -C $BAMBOO_INSTALL --strip=1 --no-same-owner \
    && rm /tmp/atlassian-bamboo-$BAMBOO_VERSION.tar.gz \
    && chmod -R 700            "${BAMBOO_INSTALL}" \
    && chown -R daemon:daemon  "${BAMBOO_INSTALL}"

RUN set -x \
    && wget http://codeception.com/codecept.phar \                       
    && mv codecept.phar /usr/local/bin/codecept \
    && chmod a+x /usr/local/bin/codecept 

RUN mkdir /var/atlassian/bamboo/phantomjs
RUN cd /var/atlassian/bamboo/phantomjs \
    && wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && ln -sf /var/atlassian/bamboo/phantomjs/phantomjs-2.1.1-linux-x86_64/ /usr/local/share/phamtomjs \
    && ln -sf /usr/local/share/phamtomjs/bin/phantomjs /usr/local/bin/phantomjs \
    && rm -rf /var/atlassian/bamboo/phantomjs/phantomjs-2.1.1-linux-x86_64.tar.bz2 

ADD ./startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Expose web and agent ports
EXPOSE 8085
EXPOSE 54663
EXPOSE 4444
EXPOSE 80

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory due to eg. logs.
VOLUME ["/var/atlassian/bamboo"]

# Set the default working directory as the installation directory.
WORKDIR ${BAMBOO_HOME}

# Run Atlassian JIRA as a foreground process by default.
CMD ["/usr/local/bin/startup.sh"]

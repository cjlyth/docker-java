FROM debian:wheezy
MAINTAINER Christopher J Lyth <cjlyth@gmail.com>

ENV PRODUCT_VERSION 8u31
ENV PRODUCT_NAME oracle-java
ENV PRODUCT_HOME /opt/$PRODUCT_NAME-$PRODUCT_VERSION

ENV PRODUCT_MIRROR http://download.oracle.com/otn-pub/java/jdk
ENV PRODUCT_BIN_URL $PRODUCT_MIRROR/$PRODUCT_VERSION-b13/jdk-$PRODUCT_VERSION-linux-x64.tar.gz
ENV PRODUCT_SIG_URL https://www.oracle.com/webfolder/s/digest/${PRODUCT_VERSION}checksum.html

COPY entrypoint.sh /
WORKDIR /tmp
ENV DEBCONF_NOWARNINGS yes
ENV DEBIAN_FRONTEND noninteractive;
RUN apt-get update   -qqy  \
 && apt-get install  -qqy \
         -o APT::Install-Recommends="0" \
         -o APT::Install-Suggests="0"	\
         -o APT::Get::Fix-Broken="true"	\
         -o APT::Get::Show-Upgraded="0" \
         wget \
 && apt-get -qqy clean

RUN wget  --header "Cookie: oraclelicense=accept-securebackup-cookie"       \
          -nc -q --no-check-certificate --no-cookies $PRODUCT_BIN_URL       \
 && wget  -O- -q --no-check-certificate --no-cookies $PRODUCT_SIG_URL       \
        | grep -E '[a-zA-Z0-9]{32}'                                         \
        | sed -r 's/<[^<]+>/\t/g'                                           \
        | awk '{printf "%s  %s\n",$2,$1}'                                   \
        | md5sum -c - 2>/dev/null                                           \
        | grep -E ' OK'                                                     \
        | cut -d':' -f1                                                     \
        | xargs -n1 -i{} tar -xf {} --no-same-owner --strip-components=1    \
                        -C $(mkdir -p $PRODUCT_HOME &>/dev/null;echo $_)    \
        chmod +x /entrypoint.sh

ENV DERBY_HOME $PRODUCT_HOME/db
ENV JAVA_HOME $PRODUCT_HOME
ENV JDK_HOME $PRODUCT_HOME
ENV JRE_HOME $PRODUCT_HOME/jre

ENV PATH $PATH:$PRODUCT_HOME/bin:$DERBY_HOME/bin

ENTRYPOINT ["/entrypoint.sh"]
CMD ["activemq", "console"]

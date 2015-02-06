FROM debian:wheezy
#FROM dockerfile/ubuntu
MAINTAINER Christopher J Lyth <cjlyth@gmail.com>

ENV PRODUCT_VERSION 7u75
ENV PRODUCT_NAME oracle-java
ENV PRODUCT_HOME /opt/$PRODUCT_NAME-$PRODUCT_VERSION
ENV PRODUCT_WORK /tmp/$PRODUCT_NAME/$PRODUCT_VERSION

ENV PRODUCT_MIRROR http://download.oracle.com/otn-pub/java/jdk
ENV PRODUCT_BIN_URL $PRODUCT_MIRROR/$PRODUCT_VERSION-b13/jdk-$PRODUCT_VERSION-linux-x64.tar.gz
ENV PRODUCT_SIG_URL https://www.oracle.com/webfolder/s/digest/${PRODUCT_VERSION}checksum.html

ENV DEBCONF_NOWARNINGS yes
ENV DEBIAN_FRONTEND noninteractive;
RUN apt-get update   \
 && apt-get install  -y \
         -o APT::Install-Recommends="0" \
         -o APT::Install-Suggests="0"	\
         -o APT::Get::Show-Upgraded="0" \
         wget

#ENV WGETRC ${PRODUCT_WORK}/wgetrc
#COPY wgetrc ${WGETRC}
CMD ["update"]
ENTRYPOINT ["/entrypoint.sh"]
WORKDIR [$PRODUCT_WORK]
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh \
 && mkdir -p $PRODUCT_HOME/bin \
 && mkdir -p $PRODUCT_HOME/jre/bin \
 && mkdir -p $PRODUCT_HOME/db/bin

ENV DERBY_HOME $PRODUCT_HOME/db
ENV JAVA_HOME $PRODUCT_HOME
ENV JDK_HOME $PRODUCT_HOME
ENV JRE_HOME $PRODUCT_HOME/jre

ENV PATH $PRODUCT_HOME/jre/bin:$PRODUCT_HOME/bin:$DERBY_HOME/bin:$PATH

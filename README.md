# docker-java

### Versions

- [ `8`, `8u31`, `jdk-8`, `1.8`, `jdk-1.8`, `oracle-jdk-8`, `oracle-jdk-8u31`, `latest` (*Dockerfile*)](https://raw.githubusercontent.com/cjlyth/docker-java/886e87757907d7728f16f641d224b82a6d0655fc/Dockerfile)
- [ `7`, `7u75`, `jdk-7`, `1.7`, `jdk-1.7`, `oracle-jdk-7`, `oracle-jdk-7u75` (*Dockerfile*)](https://raw.githubusercontent.com/cjlyth/docker-java/master/Dockerfile)

java 8: 886e87757907d7728f16f641d224b82a6d0655fc

### Local build

```
docker build --no-cache -t cjlyth/java:latest . \
&& docker tag -f cjlyth/java:8 cjlyth/java:latest \
&& docker tag -f cjlyth/java:jdk-8 cjlyth/java:latest \
&& docker tag -f cjlyth/java:1.8 cjlyth/java:latest \
&& docker tag -f cjlyth/java:jdk-1.8 cjlyth/java:latest \
&& docker tag -f cjlyth/java:oracle-jdk-8u31 cjlyth/java:latest
```

```
docker build --no-cache -t cjlyth/java:7 . \
&& docker tag -f cjlyth/java:8 cjlyth/java:latest \
&& docker tag -f cjlyth/java:jdk-8 cjlyth/java:latest \
&& docker tag -f cjlyth/java:1.8 cjlyth/java:latest \
&& docker tag -f cjlyth/java:jdk-1.8 cjlyth/java:latest \
&& docker tag -f cjlyth/java:oracle-jdk-8u31 cjlyth/java:latest
```


docker build --no-cache -t cjlyth/java:7 .

docker run -it --rm cjlyth/java:7




### Run

```
docker run -it --rm cjlyth/java bash
```

### Use the trusted build from docker

```
docker run -v $(pwd):/tmp/host-share --rm cjlyth/java
```


function install_product()
{
    [[ -z "$PRODUCT_NAME" ]] || [[ -z "$PRODUCT_NAME" ]] || [[ -z "$PRODUCT_HOME" ]] && {
        exit_err "Conatiner config is invalid"
    }
    log_action_msg "Installing $PRODUCT_NAME $PRODUCT_VERSION to $PRODUCT_HOME"

    log_daemon_msg "Downloading binary distro";
    wget  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
          --quiet  -nc --no-check-certificate --no-cookies $PRODUCT_BIN_URL &>/dev/null;
    log_end_msg $? || return $?
    log_daemon_msg "Validating checksum";
    wget  -O- -q --no-check-certificate --no-cookies $PRODUCT_SIG_URL       \
        | grep -E '[a-zA-Z0-9]{32}'                                         \
        | sed -r 's/<[^<]+>/\t/g'                                           \
        | awk '{printf "%s  %s\n",$2,$1}'                                   \
        | md5sum -c - 2>/dev/null                                           \
        | grep -E ' OK'                                                     \
        | cut -d':' -f1                                                     \
        | xargs -n1 -i{} tar -xf {} --no-same-owner --strip-components=1    \
                             -C $(mkdir -p $PRODUCT_HOME &>/dev/null;echo $_)
        log_end_msg $?
}


#cmd="${1:-java}"; shift;
#set -x; exec "${cmd}" "${@}"
#
#case "${cmd}" in
#    update)
#        log_daemon_msg "Installing $PRODUCT_NAME $PRODUCT_VERSION to $PRODUCT_HOME"
#        install_product
#        log_end_msg $?
#        exec "$@"
#    ;;
#	*)
#	    [[ -d "$PRODUCT_HOME" ]] || {
#            log_warning_msg "Required directory $PRODUCT_HOME was not found, attempting to install"
#            set -x; exec $0 update "${cmd}" "${@}"
#        }
#	set -x; exec "${cmd}" "${@}" ;;
#esac


#    java) ${JRE_HOME}/bin/java "${@}" ;;
#    javac) ${JAVA_HOME}/bin/javac "${@}" ;;
#    db) ${DERBY_HOME}/bin/ij "${@}" ;;
#RUN wget  --header "Cookie: oraclelicense=accept-securebackup-cookie"       \
#          -nc -q --no-check-certificate --no-cookies $PRODUCT_BIN_URL       \
# && wget  -O- -q --no-check-certificate --no-cookies $PRODUCT_SIG_URL       \
#        | grep -E '[a-zA-Z0-9]{32}'                                         \
#        | sed -r 's/<[^<]+>/\t/g'                                           \
#        | awk '{printf "%s  %s\n",$2,$1}'                                   \
#        | md5sum -c - 2>/dev/null                                           \
#        | grep -E ' OK'                                                     \
#        | cut -d':' -f1                                                     \
#        && xargs -n1 -i{} printf 'Tar: %s\n' "{}"
##        | xargs -n1 -i{} tar -xf {} --no-same-owner --strip-components=1    \
##                        -C $(mkdir -p $PRODUCT_HOME &>/dev/null;echo $_)    \

#export PRODUCT_BIN_URL=http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.tar.gz


wget  --header "Cookie: oraclelicense=accept-securebackup-cookie" \
          --quiet  -nc --no-check-certificate --no-cookies \
          http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.tar.gz
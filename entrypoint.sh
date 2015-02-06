#!/bin/bash

. /lib/lsb/init-functions

DERBY_HOME=${DERBY_HOME:-}
JAVA_HOME=${JAVA_HOME:-}
JDK_HOME=${JDK_HOME:-}
JRE_HOME=${JRE_HOME:-}

PRODUCT_BIN_URL=${PRODUCT_BIN_URL:-}
PRODUCT_HOME=${PRODUCT_HOME:-}
PRODUCT_MIRROR=${PRODUCT_MIRROR:-}
PRODUCT_NAME=${PRODUCT_NAME:-}
PRODUCT_SIG_URL=${PRODUCT_SIG_URL:-}
PRODUCT_VERSION=${PRODUCT_VERSION:-}
PRODUCT_WORK=${PRODUCT_WORK:-}

work_dir_is_ready() 
{
    log_begin_msg "Work directory"
    mkdir -p "$PRODUCT_WORK"
    log_end_msg $?
}
get_checkum()
{
    log_begin_msg "Archive checksum"
    test -s "$PRODUCT_WORK/MD5SUMS"                     \
    || wget -q --no-check-certificate --no-cookies  -O- $PRODUCT_SIG_URL                        \
         | grep -E '[a-zA-Z0-9]{32}'                    \
         | sed -r 's/<[^<]+>/\t/g'                      \
         | awk '{printf "%s  %s\n",$2,$1}'              \
         > $PRODUCT_WORK/MD5SUMS
    log_end_msg $?
}
get_product_archive()
{
    log_begin_msg "Archive download"
    wget --header "Cookie: oraclelicense=accept-securebackup-cookie"       \
          -nc --no-check-certificate --no-cookies $PRODUCT_BIN_URL
    log_end_msg $?
}
install_product()
{
    log_begin_msg "Installing $PRODUCT_NAME"
    md5sum -c $PRODUCT_WORK/MD5SUMS 2>/dev/null                             \
        | grep -E ' OK'                                                     \
        | cut -d':' -f1                                                     \
        | xargs -n1 -i{} tar -xvf {}                                        \
                            --no-same-owner --strip-components=1            \
                            -C $PRODUCT_HOME
    log_end_msg $?
}


cmd="${1:-bash}"; shift;

#ignore=( archive crl cfg                    )
#ignore=( "${ignore[@]/%/\" -prune}"         )
#ignore=( "${ignore[@]/#/-o -path \"\$dir/}" )
#
#echo ${ignore[@]}

declare -a endpointArgs=( "${@}" )

case "${cmd}" in
    verify)  work_dir_is_ready && get_checkum         ; endpointArgs=( ${0} "${endpointArgs[@]}" ) ;;
    fetch)   work_dir_is_ready && get_product_archive ; endpointArgs=( ${0} "${endpointArgs[@]}" ) ;;
    install) work_dir_is_ready && install_product     ; endpointArgs=( ${0} "${endpointArgs[@]}" ) ;;
    update)  endpointArgs=( ${0} verify fetch install  "${endpointArgs[@]}" ) ;;
	*)       endpointArgs=( "${cmd}" "${@}" )  ;;
esac
log_action_msg "executing ${endpointArgs[@]}"
set -x; exec "${endpointArgs[@]}"

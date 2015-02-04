#!/bin/bash

cmd="${1:-java}"; shift;
case "${cmd}" in
    java) ${JAVA_HOME}/bin/java "${@}" ;;
	*) set -x; exec "${cmd}" "${@}" ;;
esac

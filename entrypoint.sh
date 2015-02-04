#!/bin/bash

cmd="${1:-java}"; shift;
case "${cmd}" in
    java) ${JRE_HOME}/bin/java "${@}" ;;
    javac) ${JAVA_HOME}/bin/javac "${@}" ;;
    db) ${DERBY_HOME}/bin/ij "${@}" ;;
	*) set -x; exec "${cmd}" "${@}" ;;
esac

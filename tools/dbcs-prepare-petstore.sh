#!/bin/sh

# ##################################################
#
PROGNAME=$(basename $0)
VERSION="1.0.0"
#
# HISTORY:
#
# * 17/09/26 - v1.0.0  - First Creation
#
# ##################################################

function mainScript() {
  cp resources/petstore/create_user_template.sql resources/petstore/create_user.sql
  sed "s|PETSTORE_PASSWORD|${PASSWORD}|g" -i resources/petstore/create_user.sql
  scp -i ${SSHKEY} -oStrictHostKeyChecking=no resources/petstore/* oracle@${DBCSIP}:/home/oracle
  ssh -i ${SSHKEY} -oStrictHostKeyChecking=no oracle@${DBCSIP} sqlplus sys/${PASSWORD}@PDB1 as sysdba @/home/oracle/create_user.sql
  ssh -i ${SSHKEY} -oStrictHostKeyChecking=no oracle@${DBCSIP} sqlplus petstore/${PASSWORD}@PDB1 @/home/oracle/jpetstore-schema.sql
  ssh -i ${SSHKEY} -oStrictHostKeyChecking=no oracle@${DBCSIP} sqlplus petstore/${PASSWORD}@PDB1 @/home/oracle/jpetstore-dataload.sql
}

function usage() {
    cat <<EOF
$(basename ${0}) is a tool for creating JPetStore Schema
Usage:
    $(basename ${0}) -i DBCSIP -p SYS-PWD -k SSHKEY-PATH
Options:
    -v, --version     print $(basename ${0}) ${version}
    -h, --help        print help
    -i, --ip          DBCS IP Address
    -p, --password    SYS User password
    -k, --key         Secret Key Path
EOF
}

# Check Arguments
if [ $# -eq 0 ]; then
  usage
  exit 1
fi

# Handle Options
for OPT in "$@"
do
  case "$OPT" in
    '-v'|'--version' )
      echo "$(basename ${0}) ${VERSION}"
      exit 0
      ;;
    '-h'|'--help' )
      usage
      exit 0
      ;;
    '-d'|'--debug' )
      set -x
      ;;
    '-i'|'--ip' )
      if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
        echo "$PROGNAME: option requires an argument -- $1" 1>&2
        exit 1
      fi
      DBCSIP="$2"
      shift 2
      ;;
    '-p'|'--password' )
      if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
        echo "$PROGNAME: option requires an argument -- $1" 1>&2
        exit 1
      fi
      PASSWORD="$2"
      shift 2
      ;;
    '-k'|'--key' )
      if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
        echo "$PROGNAME: option requires an argument -- $1" 1>&2
        exit 1
      fi
      SSHKEY="$2"
      shift 2
      ;;
    '-k'|'--key' )
      if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
        echo "$PROGNAME: option requires an argument -- $1" 1>&2
        exit 1
      fi
      SSHKEY="$2"
      shift 2
      ;;
    -*)
      echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
      exit 1
      ;;
    *)
      if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
        param+=( "$1" )
        shift 1
      fi
      ;;
  esac
done

mainScript |tee jcs-prepare-`date '+%Y%m%d-%H%M%S'`.lst

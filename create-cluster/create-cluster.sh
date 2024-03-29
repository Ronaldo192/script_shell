#!/usr/bin/env bash
#
# nome_do_script.sh - Breve descrição
#
# Autor:      Mateus Müller
#
# ------------------------------------------------------------------------ #
#  Descrição
#
#  Exemplos:
#      $ ./nomedoscript.sh -d 1
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.1.8
# ------------------------------------------------------------------------ #
source libs/functions_deps.sh
source libs/functions_main.sh
# ------------------------------- VARIÁVEIS ----------------------------------------- #
CLUSTER_NAME="demo"
ENABLE_INGRESS=1
ENABLE_METALLB=1
# ------------------------------------------------------------------------ #

# ------------------------------- FUNÇÕES ----------------------------------------- #
function trapped () {
  echo "Erro na linha $1."
  _clean
  exit 1
}

trap 'trapped $LINENO' ERR
# ------------------------------------------------------------------------ #

# ------------------------------- TESTES ----------------------------------------- #
[ -z "`which curl`" ]    && _install_curl
[ -z "`which kind`" ]    && _install_kind
[ -z "`which kubectl`" ] && _install_kubectl
[ -z "`which docker`" ]  && _install_docker 
# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #
while [ -n "$1" ]; do
  case "$1" in
    --cluster-name) shift; CLUSTER_NAME="$1" ;;
    --no-ingress)   ENABLE_INGRESS=0         ;;
    --no-metallb)   ENABLE_METALLB=0         ;;
    -h|--help)      _help; exit              ;;
    *)              _error "$1"              ;;
  esac
  shift
done

_create_cluster
# ------------------------------------------------------------------------ #

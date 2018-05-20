#!/usr/bin/env bash

export LOG_LEVEL='standard'
export LOG_PREFIX=''

# shellcheck disable=SC2034
declare -r log_color_default=''
# shellcheck disable=SC2034
declare -r log_color_blue="\033[1;94m"
# shellcheck disable=SC2034
declare -r log_color_green="\033[1;92m"
# shellcheck disable=SC2034
declare -r log_color_red="\033[0;91m"
# shellcheck disable=SC2034
declare -r log_color_yellow="\033[0;93m"
# shellcheck disable=SC2034
declare -r log_color_gray="\033[0;90m"
# shellcheck disable=SC2034
declare -r log_color_reset="\033[0m"

declare -r log_levels=('trace' 'debug' 'standard' 'info' 'success' 'warn' 'error')

logger_write () {
  local readonly level="${1:?}"
  local readonly color="log_color_${2:?}";
  local readonly message="${3}"
  local readonly timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  local log_level=''

  if [[ $(logger_index_of "${level:?}" "${log_levels[*]}") -ge $(logger_index_of "${LOG_LEVEL:?}" "${log_levels[*]}") ]]; then
    [ "${level:?}" != 'standard' ] && log_level=" [$(echo ${level:?} | tr '[:lower:]' '[:upper:]')]"
    echo -e "${log_color_reset}${!color}${LOG_PREFIX}[${timestamp:?}]${log_level}: ${*:3}${log_color_reset}";
  fi
}

logger_index_of () {
  value="${1}"
  arr=(${2:?})
  for i in "${!arr[@]}"; do
    if [[ "${arr[$i]}" == "${value}" ]]; then
      echo "${i}";
    fi
  done
}

logger_configure () {
  local level="${1:-standard}"
  local prefix="${2}"
  [[ "${level}" == "null" ]] && level='standard'
  [[ "${prefix}" == "null" ]] && prefix=''
  LOG_LEVEL="${level}"
  LOG_PREFIX="${prefix}"
}

log () {
  logger_write standard default "$@"
}

log_trace () {
  logger_write trace gray "$@"
}

log_debug () {
  logger_write debug default "$@"
}

log_info () {
  logger_write info blue "$@"
}

log_warn () {
  logger_write warn yellow "$@"
}

log_error () {
  logger_write error red "$@"
}

log_success () {
  logger_write success green "$@"
}

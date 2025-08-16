#!/usr/bin/env bash
normalize_vars() {
  local vars=(TITLE AUTHOR ADVISOR INSTIT CITY DATE)
  local v val
  for v in "${vars[@]}"; do
    val="$(eval "printf '%s' \"\${$v:-}\"")"
    val="${val//$'\u2011'/-}"
    val="${val//$'\u2013'/-}"
    val="${val//$'\u2014'/-}"
    val="${val//$'\u00A0'/ }"
    eval "$v=\"\$val\""
  done
}

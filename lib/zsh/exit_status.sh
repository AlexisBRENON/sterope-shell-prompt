#! /bin/sh

f_sterope_zsh_exit_status() {
  if [ -n "${ColorFontCode:-}" ]; then
    _yellow="${ColorFontCode}226${ColorEndCode:-}"
    _brown="${ColorFontCode}94${ColorEndCode}"
  fi
  sparkles='\u2728'
  poo='💩'
  export v_sterope_last_exit_status="%{%(?.${_yellow}${sparkles}.${_brown}${poo})%G%} %{%f%} "
  unset sparkles poo _yellow _brown
}


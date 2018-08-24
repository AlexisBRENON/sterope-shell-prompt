#! /bin/sh

lf_sterope_get_virtualenv_symbol() {
    lf_sterope_posix_get_symbol \
        "${v_sterope_virtualenv_symbols:-}" \
        "$1"
}

f_sterope_posix_virtualenv() {
    v_sterope_virtualenv=""
    if [ -n "${VIRTUAL_ENV:-}" ]; then
        # We are currently in a virtual environment

        # Extract virtualenv prompt name
        # shellcheck disable=SC2016
        l_virtualenv_prompt="$(\
            grep -A1 \
                -F '_OLD_VIRTUAL_PS1="$PS1"' \
                "${VIRTUAL_ENV}/bin/activate" | \
            tail -n1 | \
            sed -E 's/^ *if \[ "x([^"]*)" !=.*$/\1/' \
            )"
        # Get the version of the virtualenv python
        l_virtualenv_py_version="$(\
            python --version 2>&1 | \
            cut -d' ' -f2 \
            )"

        # Build the stripe
        v_sterope_virtualenv="$(\
            printf '%s%s' \
            "${v_sterope_virtualenv}" \
            "${ColorReset:-}${Black:-}${On_Green:-}" \
            )"
        v_sterope_virtualenv="$(\
            printf '%s%s' \
            "${v_sterope_virtualenv}" \
            "${l_virtualenv_prompt}" \
            )"
        v_sterope_virtualenv="$(\
            printf '%s %s' \
            "${v_sterope_virtualenv}" \
            "$(\
                lf_sterope_get_virtualenv_symbol \
                    "is_a_virtualenv" \
                )" \
            )"
        v_sterope_virtualenv="$(\
            printf '%s %s' \
            "${v_sterope_virtualenv}" \
            "${l_virtualenv_py_version} " \
            )"
        v_sterope_virtualenv="$(\
            printf '%s %s' \
            "${v_sterope_virtualenv}" \
            "${ColorReset}${Green:-}" \
            )"
        v_sterope_virtualenv="$(\
            printf '%s%s' \
            "${v_sterope_virtualenv}" \
            "$(\
                lf_sterope_get_virtualenv_symbol \
                    "separator" \
                )" \
            )"
        v_sterope_virtualenv="$(\
            printf '%s%s\\n' \
            "${v_sterope_virtualenv}" \
            "${ColorReset}" \
            )"
    fi
    export v_sterope_virtualenv
}


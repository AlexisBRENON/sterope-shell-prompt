#! /usr/bin/env zsh

# ###################################################################
# Use an async process to fetch git infos
# ###################################################################

if [ "${v_sterope_no_async:-false}" = "false" ]; then

    f_sterope_zsh_kill_async_job() {
        l_sterope_async_git_pid="$(\
            cat "${STEROPE_CACHE}/git_pid"
        )" 2> /dev/null
        if [ "${l_sterope_async_git_pid}" -gt 0 ]; then
            kill -SIGKILL "${l_sterope_async_git_pid}" > /dev/null 2>&1
            echo "0" > "${STEROPE_CACHE}/git_pid"
        fi
        unset l_sterope_async_git_pid
    }

    f_sterope_zsh_git() {
        # Kill the old git_info process if it is still running.
        f_sterope_zsh_kill_async_job
        # Call the formatter function when info will be retrieved
        trap f_sterope_zsh_async_format_git_line USR1
        # Retrieve info asynchronously
        f_sterope_zsh_async_get_git_info &! 
        # Keep track of the asynchronous process
        echo "$!" > "${STEROPE_CACHE}/git_pid"
        # Kill the async process if it's too long
        f_sterope_zsh_async_timeout &!
    }

    f_sterope_zsh_async_get_git_info() {
        # Get Git repository information.
        if [ -n "${GBG_VERSION}" ]; then
            # Save all GBG variables in a file to load them back in another job
            ${GBG_DIR}/god_bless_git.sh > "${v_sterope_async_git_data}"
        fi

        # Signal completion to parent process.
        kill -SIGUSR1 $$
    }

    f_sterope_zsh_async_timeout () {
        # TODO: What happen if another jobs has been launched later?
        sleep 5
        f_sterope_zsh_kill_async_job
    }

    f_sterope_zsh_async_format_git_line() {
        v_sterope_async_git_pid="$(\
            cat "${STEROPE_CACHE}/git_pid"
        )" 2> /dev/null
        if [ "${v_sterope_async_git_pid:-0}" -gt 0 ] && \
            [ -e "${v_sterope_async_git_data}" ]; then
            # Load GBG variables
            . "${v_sterope_async_git_data}"
            # Generate the pretty line
            v_sterope_git_line="$(\
                lf_sterope_build_git
            )"
            # Refresh the prompt
            zle && zle reset-prompt && print ''

            # Reset async states.
            echo "0" > "${STEROPE_CACHE}/git_pid"
            rm -f "${v_sterope_async_git_data}"
        fi
    }
fi

#! /bin/sh

f_sterope_posix_git() {
    v_sterope_git=""
    if [ -n "${GBG_VERSION:-}" ]; then
        god_bless_git
        v_sterope_git="$(lf_sterope_build_git)"
    fi
    export v_sterope_git
}

lf_sterope_enrich_append() {
    l_sterope_flag=$1
    l_sterope_text=$2
    if [ "${l_sterope_flag}" != "true" ]; then
        l_sterope_text="$(\
            echo "${l_sterope_text}" | \
            sed 's/./ /g'\
            )"
    fi

    echo "${l_sterope_text}"
}

lf_sterope_get_git_symbol() {
    lf_sterope_posix_get_symbol \
        "${v_sterope_git_symbols:-}" \
        "$1"
}

# TODO: refactor building:
#   * printf concat
#   * enrich with fallback
#   * zerowidth space at end
lf_sterope_build_git() {
    if [ "${gbg_is_a_git_repo:-}" = "true" ]; then
        # git repo infos
        l_sterope_git="${Black:-}${On_White:-}"
        l_sterope_git="${l_sterope_git}$(\
            basename "${gbg_repo_top_level:-}"\
            )"
        l_sterope_git="${l_sterope_git}$(\
            lf_sterope_get_git_symbol \
            is_a_git_repo \
            )"

        l_sterope_git="${l_sterope_git}$(\
            lf_sterope_enrich_append \
            "${gbg_repo_has_stashes:-}" "$(\
                lf_sterope_get_git_symbol \
                has_stashes)"\
            )"

        # on filesystem
        l_sterope_git="${l_sterope_git}${Red:-""}"
        l_sterope_git="${l_sterope_git}$(\
            lf_sterope_enrich_append \
            "${gbg_workspace_has_untracked:-}" "$(\
                lf_sterope_get_git_symbol \
                has_untracked)"\
            )"
        l_sterope_git="${l_sterope_git}$(\
            lf_sterope_enrich_append \
            "${gbg_workspace_has_modifications:-}" "$(\
                lf_sterope_get_git_symbol \
                has_workspace_mods)"\
            )"
        l_sterope_git="${l_sterope_git}$(\
            lf_sterope_enrich_append \
            "${gbg_workspace_has_deletions:-}" "$(\
                lf_sterope_get_git_symbol \
                has_workspace_dels)"\
            )"
        l_sterope_git="${l_sterope_git} ${White:-}${On_Yellow:-}$(\
                lf_sterope_get_git_symbol \
                separator\
                )${Black} "

        # TODO
        # Pending operation
        # Conflicts

        # in index
        l_sterope_git="${l_sterope_git}$(\
            lf_sterope_enrich_append \
            "${gbg_index_has_modifications:-}" "$(\
                lf_sterope_get_git_symbol \
                has_index_mods)"\
            )"
        l_sterope_git="${l_sterope_git}$(\
            lf_sterope_enrich_append \
            "${gbg_index_has_moves:-}" "$(\
                lf_sterope_get_git_symbol \
                has_index_moves)"\
            )"
        l_sterope_git="${l_sterope_git}$(\
            lf_sterope_enrich_append \
            "${gbg_index_has_additions:-}" "$(\
                lf_sterope_get_git_symbol \
                has_index_adds)"\
            )"
        l_sterope_git="${l_sterope_git}$(\
            lf_sterope_enrich_append \
            "${gbg_index_has_deletions:-}" "$(\
                lf_sterope_get_git_symbol \
                has_index_dels)"\
            )"
        l_sterope_git="${l_sterope_git} ${Yellow:-}${On_Red:-}$(\
            lf_sterope_get_git_symbol \
            separator)${White} "

        # Remote
        if [ "${gbg_head_is_detached:-}" = "true" ]; then
            # Detached state
            l_sterope_git="${l_sterope_git}$(\
                lf_sterope_get_git_symbol \
                detached)"
            l_sterope_git="${l_sterope_git} ${gbg_head_hash:-:0:7}"
        elif [ "${gbg_upstream_has_upstream:-}" = "false" ]; then
            # No upstream set
            l_sterope_git="${l_sterope_git}-- "
            l_sterope_git="${l_sterope_git}$(\
                lf_sterope_get_git_symbol \
                not_tracked)"
            l_sterope_git="${l_sterope_git} --"
            l_sterope_git="${l_sterope_git} (${gbg_head_branch:-"???"}) "
        else
            # Standard branch
            if [ "${gbg_upstream_commits_behind_num:-0}" -gt 0 ]; then
                l_sterope_git="$(\
                    printf '%s %s ' \
                    "${l_sterope_git}" \
                    "-${gbg_upstream_commits_behind_num}")"
            else
                l_sterope_git="${l_sterope_git} -- "
            fi

            if [ "${gbg_upstream_has_diverged:-}" = "true" ]; then
                l_sterope_upstream_diff="$(\
                    lf_sterope_get_git_symbol \
                    has_diverged)"
            elif [ "${gbg_upstream_commits_behind_num:-0}" -gt 0 ]; then
                l_sterope_upstream_diff="$(\
                    lf_sterope_get_git_symbol \
                    can_ff)"
            elif [ "${gbg_upstream_commits_ahead_num:-0}" -gt 0 ]; then
                l_sterope_upstream_diff="$(\
                    lf_sterope_get_git_symbol \
                    should_push)"
            elif [ "${gbg_upstream_commits_ahead_num:-0}" -eq 0 ] && \
                [ "${gbg_upstream_commits_behind_num:-0}" -eq 0 ]; then
                l_sterope_upstream_diff=" "
            fi
            l_sterope_git="${l_sterope_git}${l_sterope_upstream_diff}"
            unset l_sterope_upstream_diff

            if [ "${gbg_upstream_commits_ahead_num:-0}" -gt 0 ]; then
                l_sterope_git="$(\
                    printf '%s %s ' \
                    "${l_sterope_git}" \
                    "+${gbg_upstream_commits_ahead_num}")"
            else
                l_sterope_git="${l_sterope_git} ++ "
            fi

            l_sterope_git="$(\
                printf '%s (%s %s %s) ' \
                "${l_sterope_git}" \
                "${gbg_head_branch}" \
                "$(\
                    lf_sterope_get_git_symbol \
                    "${gbg_upstream_merge_type:-merge}_tracking")" \
                "$(\
                    echo "${gbg_upstream_name:-""}" | \
                    sed "s#$gbg_head_branch#...#")" \
                )"
        fi

        # Tag
        l_sterope_git="${l_sterope_git}$(\
            lf_sterope_enrich_append \
            "${gbg_head_is_on_tag:-}" "$(\
                lf_sterope_get_git_symbol \
                    tag) ${gbg_head_tag:-}"\
            )"
        l_sterope_git="${l_sterope_git} ${ColorReset:-}${Red}$(\
            lf_sterope_get_git_symbol \
            separator)${ColorReset}"

        # Suffix
        # Make sure any suffix (even new lines) are kept, adding a
        # zero width space at the end
        l_sterope_git="$(\
            printf '%s%s\u200b' \
            "${l_sterope_git}" \
            "\\n")"

        printf '%s' "${l_sterope_git}"
        unset l_sterope_git
        return 0
    else
        return 1
    fi
}

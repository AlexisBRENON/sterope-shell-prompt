#! /bin/sh

f_sterope_git() {
    v_sterope_git=""
    if [ "$(set | grep -c "god_bless_git")" -ge 1 ]; then
        god_bless_git
        v_sterope_git="$(lf_sterope_build_git)"

        # Add newline suffix
        # https://stackoverflow.com/a/44800947/4373898
        # TODO: use a customizable suffix
        if [ -n "${v_sterope_git}" ]; then
            v_sterope_git="${v_sterope_git}\\n"
        fi
    fi
    export v_sterope_git
}

lf_sterope_enrich_append() {
    flag=$1
    text=$2
    if [ "${flag}" != "true" ]; then
        text="$(echo "${text}" | sed 's/./ /g')"
    fi

    echo "${text}"
}

# TODO: refactor building (concat, enrich fallback)
f_sterope_build_git() {
    if [ "${gbg_is_a_git_repo:-}" = "true" ]; then
        # git repo infos
        l_sterope_git="${Black:-}${On_White:-}"
        l_sterope_git="${l_sterope_git}$(\
            basename "${gbg_repo_top_level:-}"\
            )"
        l_sterope_git="${l_sterope_git}$(\
            lf_sterope_get_symbol \
                "${v_sterope_git_symbols:-}" \
                is_a_git_repo \
            )"

        # on filesystem
        l_sterope_git="${l_sterope_git}$(\
            lf_sterope_enrich_append \
                "${gbg_repo_has_stashes:-}"\
                "$(lf_sterope_get_symbol \
                    "${v_sterope_git_symbols}" \
                    has_stashes)"\
            )"

    l_sterope_git="${l_sterope_git}${Red:-""}"
    l_sterope_git="${l_sterope_git}$(\
        lf_sterope_enrich_append \
        "${gbg_workspace_has_untracked:-}"\
        "$(lf_sterope_get_symbol has_untracked)"\
        )"

    l_sterope_git="${l_sterope_git}$(\
        lf_sterope_enrich_append \
        "${gbg_workspace_has_modifications:-}" \
        "$(lf_sterope_get_symbol has_workspace_mods)"
            )"
            l_sterope_git="${l_sterope_git}$(\
                lf_sterope_enrich_append \
                "${gbg_workspace_has_deletions:-}" \
                "$(lf_sterope_get_symbol has_workspace_dels)"\
                )"

            l_sterope_git="${l_sterope_git} ${White:-}${On_Yellow:-}$(\
                lf_sterope_get_symbol separator\
                )${Black} "

    # in index
    l_sterope_git="${l_sterope_git}$(\
        lf_sterope_enrich_append \
        "${gbg_index_has_modifications:-}" \
        "$(lf_sterope_get_symbol has_index_mods)"\
        )"
            l_sterope_git="${l_sterope_git}$(\
                lf_sterope_enrich_append \
                "${gbg_index_has_moves:-}" \
                "$(lf_sterope_get_symbol has_index_moves)"\
                )"
                            l_sterope_git="${l_sterope_git}$(\
                                lf_sterope_enrich_append \
                                "${gbg_index_has_additions:-}" \
                                "$(lf_sterope_get_symbol has_index_adds)"\
                                )"
                                                            l_sterope_git="${l_sterope_git}$(\
                                                                lf_sterope_enrich_append \
                                                                "${gbg_index_has_deletions:-}" \
                                                                "$(lf_sterope_get_symbol has_index_dels)"\
                                                                )"

    # Operation
    # TODO

    l_sterope_git="${l_sterope_git} ${Yellow:-}${On_Red:-}$(
    lf_sterope_get_symbol separator
    )${White} "

    # Remote
    if [ "${gbg_head_is_detached:-}" = "true" ] # Detached state
    then
        l_sterope_git="${l_sterope_git}$(lf_sterope_get_symbol detached)"
        l_sterope_git="${l_sterope_git} ${gbg_head_hash:-:0:7}"
    elif [ "${gbg_upstream_has_upstream:-}" = "false" ] # No upstream set
    then
        l_sterope_git="${l_sterope_git}-- "
        l_sterope_git="${l_sterope_git}$(lf_sterope_get_symbol not_tracked)"
        l_sterope_git="${l_sterope_git} --"
        l_sterope_git="${l_sterope_git} (${gbg_head_branch:-"???"}) "
    else # Standard branch
        if [ "${gbg_upstream_commits_behind_num:-0}" -gt 0 ]; then
            l_sterope_git="${l_sterope_git} -${gbg_upstream_commits_behind_num} "
        else
            l_sterope_git="${l_sterope_git} -- "
        fi

        if [ "${gbg_upstream_has_diverged:-}" = "true" ]
        then
            upstream_diff="$(lf_sterope_get_symbol has_diverged)"
        elif [ "${gbg_upstream_commits_behind_num:-0}" -gt 0 ]; then
            upstream_diff="$(lf_sterope_get_symbol can_ff)"
        elif [ "${gbg_upstream_commits_ahead_num:-0}" -gt 0 ]; then
            upstream_diff="$(lf_sterope_get_symbol should_push)"
        elif [ "${gbg_upstream_commits_ahead_num:-0}" -eq 0 ] && [ "${gbg_upstream_commits_behind_num:-0}" -eq 0 ]; then
            upstream_diff=" "
        fi
        l_sterope_git="${l_sterope_git}${upstream_diff}"
        unset upstream_diff

        if [ "${gbg_upstream_commits_ahead_num:-0}" -gt 0 ]; then
            l_sterope_git="${l_sterope_git} +${gbg_upstream_commits_ahead_num} "
        else
            l_sterope_git="${l_sterope_git} -- "
        fi

        l_sterope_git="${l_sterope_git} (${gbg_head_branch} $(\
            lf_sterope_get_symbol "${gbg_upstream_merge_type:-merge}_tracking"\
            ) $(echo "${gbg_upstream_name:-""}" | sed "s#$gbg_head_branch#...#")) "
                fi

                l_sterope_git="${l_sterope_git}$(\
                    lf_sterope_enrich_append \
                    "${gbg_head_is_on_tag:-}"\
                    "$(lf_sterope_get_symbol tag) ${gbg_head_tag:-}"\
                    )"

                l_sterope_git="${l_sterope_git} ${ColorReset:-}${Red}$(\
                    lf_sterope_get_symbol separator\
                    )${ColorReset}"

                echo "${l_sterope_git}"
                unset l_sterope_git
                return 0
            else
                return 1
            fi
        }

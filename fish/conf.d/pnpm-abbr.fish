if status is-interactive
    function p
        pnpm $argv
    end

    # Dependencies
    function pa
        pnpm add $argv
    end
    function pad
        pnpm add --save-dev $argv
    end
    function pap
        pnpm add --save-peer $argv
    end
    function prm
        pnpm remove $argv
    end
    function pin
        pnpm install $argv
    end
    function pinf
        pnpm install --frozen-lockfile $argv
    end
    function pls
        pnpm list $argv
    end
    function pu
        pnpm update $argv
    end
    function pui
        pnpm update --interactive $argv
    end
    function puil
        pnpm update --interactive --latest $argv
    end

    # Global dependencies
    function pga
        pnpm add --global $argv
    end
    function pgls
        pnpm list --global $argv
    end
    function pgrm
        pnpm remove --global $argv
    end
    function pgu
        pnpm update --global $argv
    end

    # Run scripts
    function pr
        pnpm run $argv
    end
    function prun
        pnpm run $argv
    end
    function pd
        pnpm run dev $argv
    end
    function pb
        pnpm run build $argv
    end
    function psv
        pnpm run serve $argv
    end
    function pst
        pnpm start $argv
    end
    function pt
        pnpm test $argv
    end
    function ptc
        pnpm test --coverage $argv
    end
    function pln
        pnpm run lint $argv
    end
    function pdocs
        pnpm run docs $argv
    end
    function pfmt
        pnpm run format $argv
    end
    function pex
        pnpm exec $argv
    end
    function pdx
        pnpm dlx $argv
    end

    # Misc
    function pi
        pnpm init $argv
    end
    function ppub
        pnpm publish $argv
    end
    function pc
        pnpm create $argv
    end
    function pab
        pnpm approve-builds $argv
    end

    # Monorepo
    function pf
        pnpm -r --filter $argv
    end
end

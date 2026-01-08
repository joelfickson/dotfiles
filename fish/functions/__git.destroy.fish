function __git.destroy
  for ab in $__git_plugin_abbreviations
    abbr -e $ab 2>/dev/null
    functions -e $ab 2>/dev/null
  end
  set -Ue __git_plugin_abbreviations
  set -Ue __git_plugin_initialized
end

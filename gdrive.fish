# Fish completions for gdrive
# Delegates to restish gdrive completions

function __gdrive_complete
    set -l tokens (commandline -opc)
    set -l current (commandline -ct)
    
    # Use dedicated restish config and cache in Library/Caches
    set -l cache_dir "$HOME/Library/Caches/gdrive-cli"
    set -lx RESTISH_CONFIG_DIR "$cache_dir"
    set -lx RESTISH_CACHE_DIR "$cache_dir/cache"
    
    # Ask fish to complete "restish gdrive ..." instead
    complete -C "restish gdrive $tokens[2..-1] $current"
end

complete -c gdrive -f -a '(__gdrive_complete)'

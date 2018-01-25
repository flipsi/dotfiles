#!/usr/bin/env fish

## add workspace assignment rule to i3 config file for currently opened chrome desktop app



## oneliner
## (does work)
## (does not work when executed with exec from i3, because xprop can't grab the mouse)
# sed --follow-symlinks -i '/# windows always on specific workspace/a '(xprop | grep 'CLASS.*crx_' | sed 's/.*\(crx_\w\+\).*/assign [class="(?i)chrom" instance="\1"]  WORKSPACE/') ~/.i3/config


# properties of current window
set xprop_out (xprop -id (xprop -root _NET_ACTIVE_WINDOW | sed -E 's/.*(0x.+)/\1/'))
for line in $xprop_out
    if string match 'WM_NAME*' "$line"
        set name (echo $line | sed -E 's/^WM_NAME.*"(.*)"/\1/')
    else if string match 'WM_CLASS*' "$line"
        set class (echo $line | sed -E 's/^WM_CLASS.*"(crx_[a-z]+)".*/\1/')
    end
end

# add line to config file
set config_line 'assign [class="(?i)chrom" instance="'$class'"]  '$name
sed --follow-symlinks -i '/# windows always on specific workspace/a '$config_line ~/.i3/config


function fish_my_colors

    set -l theme $argv[1]

    switch $theme

    case 'gruvbox'

        set dark0_hard     "#1D2021"
        set dark0          "#282828"
        set dark0_soft     "#32302F"
        set dark1          "#3c3836"
        set dark2          "#504945"
        set dark3          "#665c54"
        set dark4          "#7C6F64"

        set gray_245       "#928374"
        set gray_244       "#928374"

        set light0_hard    "#F9F5D7"
        set light0         "#FBF1C7"
        set light0_soft    "#F2E5BC"
        set light1         "#EBDBB2"
        set light2         "#D5C4A1"
        set light3         "#BDAE93"
        set light4         "#A89984"

        set bright_red     "#FB4934"
        set bright_green   "#B8BB26"
        set bright_yellow  "#FABD2F"
        set bright_blue    "#83A598"
        set bright_purple  "#D3869B"
        set bright_aqua    "#8EC07C"
        set bright_orange  "#FE8019"

        set neutral_red    "#CC241D"
        set neutral_green  "#98971A"
        set neutral_yellow "#D79921"
        set neutral_blue   "#458588"
        set neutral_purple "#B16286"
        set neutral_aqua   "#689D6A"
        set neutral_orange "#D65D0E"

        set faded_red      "#9D0006"
        set faded_green    "#79740E"
        set faded_yellow   "#B57614"
        set faded_blue     "#076678"
        set faded_purple   "#8F3F71"
        set faded_aqua     "#427B58"
        set faded_orange   "#AF3A03"

    end


    # SET COLORS FOR OTHER SCRIPTS
    set -g fish_my_color_gray_dark       $dark2
    set -g fish_my_color_gray_middle     $dark3
    set -g fish_my_color_gray_bright     $gray_244
    set -g fish_my_color_red             $neutral_red
    set -g fish_my_color_green           $neutral_green
    set -g fish_my_color_blue            $neutral_blue
    set -g fish_my_color_accent          $bright_yellow
    set -g fish_my_color_accent_dark     $neutral_yellow

    # SET COLORS OF FISH
    set -g fish_color_normal $dark1 # the default color
    set -g fish_color_command $dark2 # the color for commands
    set -g fish_color_quote $neutral_green # the color for quoted blocks of text
    set -g fish_color_redirection $neutral_orange # the color for IO redirections
    set -g fish_color_end $neutral_orange # the color for process separators like ';' and '&'
    set -g fish_color_error $neutral_red # the color used to highlight potential errors
    set -g fish_color_param $dark3 # the color for regular command parameters
    set -g fish_color_comment $dark4 # the color used for code comments
    set -g fish_color_match $neutral_orange # the color used to highlight matching parenthesis
    # set -g fish_color_search_match $light2 --background $neutral_aqua # the color used to highlight history search matches
    set -g fish_color_operator $neutral_aqua # the color for parameter expansion operators like '*' and '~'
    # set -g fish_color_escape # the color used to highlight character escapes like '\n' and '\x70'
    # set -g fish_color_cwd # the color used for the current working directory in the default prompt
    set -g fish_color_autosuggestion $dark3 # the color used for autosuggestions
    # set -g fish_color_user # the color used to print the current username in some of fish default prompts
    # set -g fish_color_host # the color used to print the current host system in some of fish default prompts
    # set -g fish_color_cancel # the color for the '^C' indicator on a canceled command

    # SET COLORS OF FISH GIT PROMPT
    set -g __fish_git_prompt_color $light3
    # set -g __fish_git_prompt_color_prefix $light3
    # set -g __fish_git_prompt_color_suffix $light3
    # set -g __fish_git_prompt_color_bare $light3
    set -g __fish_git_prompt_color_merging $neutral_red
    set -g __fish_git_prompt_color_branch $neutral_orange
    set -g __fish_git_prompt_color_flags $neutral_aqua
    # set -g __fish_git_prompt_color_upstream $light3

end

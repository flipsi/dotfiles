function set_tty_colors --description 'Set colors for virtual console'

  set -l colorscheme $argv[1]
  set -l default_colorscheme "gruvbox"

  if test -z "$colorscheme"
    set colorscheme "$default_colorscheme"
  end

  function __set_tty_colors
    set -l colorscheme $argv[1]
    switch "$colorscheme"
      case "gruvbox"
        echo -en "\e]P01D2021" #black
        echo -en "\e]P83C3836" #darkgrey
        echo -en "\e]P1CC241D" #darkred
        echo -en "\e]P9FB4934" #red
        echo -en "\e]P298971A" #darkgreen
        echo -en "\e]PAB8BB26" #green
        echo -en "\e]P3D79921" #brown
        echo -en "\e]PBFABD2F" #yellow
        echo -en "\e]P4458588" #darkblue
        echo -en "\e]PC83A598" #blue
        echo -en "\e]P5B16286" #darkmagenta
        echo -en "\e]PDD3869B" #magenta
        echo -en "\e]P6689D6A" #darkcyan
        echo -en "\e]PE8EC07C" #cyan
        echo -en "\e]P7A89984" #lightgrey
        echo -en "\e]PFFBF1C7" #white
        clear # for background artifacting
      case '*'
        echo "Unknown colorscheme: $colorscheme"
    end
  end

  if test "$TERM" = "linux"
    __set_tty_colors "$colorscheme"
  end

end

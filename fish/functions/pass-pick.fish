function pass-pick --description 'pick a value by key from password store'
    pass $argv[1] | grep $argv[2] | cut -d' ' -f2 | tr -d '\n'
end

function pass-pick --description 'pick a value by key from password store'
    pass $argv[2] | grep $argv[1] | cut -d' ' -f2 | tr -d '\n'
end

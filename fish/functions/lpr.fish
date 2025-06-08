function lpr --description 'print with printer, supporting additional file types'
    if test (count $argv) -eq 0
        echo "Usage: lpr <file...>"
        return 1
    end

    set -l success_count 0

    for file in $argv
        if not test -f "$file"
            echo "Error: File '$file' does not exist" >&2
            continue
        end

        set -l extension (string match -r '\.[^.]+$' "$file")
        set -l tempfile

        switch "$extension"
            case '.odt' '.doc' '.docx' '.rtf'
                set tempfile /tmp/(string replace -r '\.[^.]+$' '.pdf' (basename "$file"))
                libreoffice --headless --convert-to pdf --outdir (dirname $tempfile) "$file" >/dev/null 2>&1
                command lpr "$tempfile"
                rm -f "$tempfile"
            case '*'
                command lpr "$file"
        end

        set success_count (math $success_count + 1)
    end

    if test $success_count -eq 0
        return 1
    end
end

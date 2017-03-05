from subprocess import PIPE
from ranger.api.commands import *

class fzf(Command):
    def execute(self):
        mode=self.arg(1)
        pattern=self.arg(2)
        if not mode:
            self.fm.notify('First argument must be either "find" or "locate"!', bad=True)
            return
        if (mode == "locate") and not pattern:
            self.fm.notify('Second argument must be a pattern!', bad=True)
            return
        if (mode == "find"):
            #  command="find -L \( -path '*.wine-pipelight' -o -path '*.ivy2*' -o -path '*.texlive*' -o -path '*.git' -o -path '*.metadata' -o -path '*_notes' \) -prune -o -type d -print 2>/dev/null"
            command="ag -l --silent -g ''"
        elif (mode == "locate"):
            command="locate -i " + pattern
        else:
            return
        if False:
            # only directories
            fzf = self.fm.execute_command(command + " | sed -e 's:/[^/]*$::' | uniq | fzf", stdout=PIPE)
        else:
            fzf = self.fm.execute_command(command + " | fzf", stdout=PIPE)
        stdout, stderr = fzf.communicate()
        file = stdout.decode('utf-8').rstrip('\n')
        if (os.path.isdir(file)):
            self.fm.cd(file)
        else:
            file = os.path.abspath(file) # somehow, otherwise wrong file selected
            self.fm.select_file(file)








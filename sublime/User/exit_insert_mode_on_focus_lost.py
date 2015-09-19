import sublime, sublime_plugin
import os.path

class StopInsertOnFocusLost(sublime_plugin.EventListener):
    def on_deactivated(self, view):
        if view.file_name() and not view.settings().get('command_mode'):
            view.run_command('exit_insert_mode')
# Author: Philipp Moers <soziflip@gmail.com>
# colorscheme for ranger: sflea


# This file is part of ranger, the console file manager.
# License: GNU GPL version 3, see the file "AUTHORS" for details.

import curses
from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class Default(ColorScheme):
    progress_bar_color = blue

    ACCENT         = 30
    ACCENT_DARK    = 23
    GRAY_BRIGHTEST = 252
    GRAY_BRIGHT    = 245
    GRAY_MIDDLE    = 242
    GRAY_DARK      = 239
    GRAY_DARKEST   = 237


    def use(self, context):
        fg, bg, attr = default_colors

        red = 210 # more decent red

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                bg = red
            if context.border:
                #  fg = default
                fg = self.ACCENT_DARK
            if context.media:
                if context.image:
                    fg = yellow
                else:
                    fg = self.ACCENT
            if context.document:
                fg = 192
            if context.container:
                fg = red
            if context.directory:
                attr |= bold
                fg = self.GRAY_BRIGHT
            elif context.executable and not \
                    any((context.media, context.container,
                        context.fifo, context.socket)):
                attr |= bold
                #fg = magenta
            if context.socket:
                fg = magenta
                attr |= bold
            if context.fifo or context.device:
                fg = yellow
                if context.device:
                    attr |= bold
            if context.link:
                fg = context.good and self.ACCENT or magenta
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (red, magenta):
                    fg = white
                else:
                    fg = red
            if not context.selected and (context.cut or context.copied):
                bg = self.GRAY_DARKEST
                fg = self.GRAY_BRIGHTEST
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    bg = yellow
                    fg = self.GRAY_DARKEST
            if context.badinfo:
                if attr & reverse:
                    bg = magenta
                else:
                    fg = magenta

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = context.bad and red or self.ACCENT_DARK
            elif context.directory:
                fg = self.GRAY_BRIGHT
            elif context.tab:
                if context.good:
                    bg = self.ACCENT_DARK
            elif context.link:
                fg = cyan

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = self.GRAY_BRIGHT
                elif context.bad:
                    fg = magenta
            if context.marked:
                attr |= bold | reverse
                fg = yellow
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = red
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = blue
                attr &= ~bold
            if context.vcscommit:
                fg = yellow
                attr &= ~bold


        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = self.ACCENT

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color


        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = magenta
            elif context.vcschanged:
                fg = red
            elif context.vcsunknown:
                fg = red
            elif context.vcsstaged:
                fg = self.ACCENT
            elif context.vcssync:
                fg = self.ACCENT
            elif context.vcsignored:
                fg = default

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync:
                fg = self.ACCENT
            elif context.vcsbehind:
                fg = red
            elif context.vcsahead:
                fg = blue
            elif context.vcsdiverged:
                fg = magenta
            elif context.vcsunknown:
                fg = red

        return fg, bg, attr

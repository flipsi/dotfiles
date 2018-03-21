# Author: Philipp Moers <soziflip@gmail.com>
# colorscheme for ranger: sflea


# This file is part of ranger, the console file manager.
# License: GNU GPL version 3, see the file "AUTHORS" for details.

import curses
from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class Default(ColorScheme):
    progress_bar_color = blue

    GRUVBOX_DARK0_HARD      = 234
    GRUVBOX_DARK0           = 235
    GRUVBOX_DARK0_SOFT      = 236
    GRUVBOX_DARK1           = 237
    GRUVBOX_DARK2           = 239
    GRUVBOX_DARK3           = 241
    GRUVBOX_DARK4           = 243
    GRUVBOX_GRAY_245        = 245
    GRUVBOX_GRAY_244        = 244
    GRUVBOX_LIGHT0_HARD     = 230
    GRUVBOX_LIGHT0          = 229
    GRUVBOX_LIGHT0_SOFT     = 228
    GRUVBOX_LIGHT1          = 223
    GRUVBOX_LIGHT2          = 250
    GRUVBOX_LIGHT3          = 248
    GRUVBOX_LIGHT4          = 246
    GRUVBOX_LIGHT4          = 246
    GRUVBOX_BRIGHT_RED      = 167
    GRUVBOX_BRIGHT_GREEN    = 142
    GRUVBOX_BRIGHT_YELLOW   = 214
    GRUVBOX_BRIGHT_BLUE     = 109
    GRUVBOX_BRIGHT_PURPLE   = 175
    GRUVBOX_BRIGHT_AQUA     = 108
    GRUVBOX_BRIGHT_ORANGE   = 208
    GRUVBOX_NEUTRAL_RED     = 124
    GRUVBOX_NEUTRAL_GREEN   = 106
    GRUVBOX_NEUTRAL_YELLOW  = 172
    GRUVBOX_NEUTRAL_BLUE    = 66
    GRUVBOX_NEUTRAL_PURPLE  = 132
    GRUVBOX_NEUTRAL_AQUA    = 72
    GRUVBOX_NEUTRAL_ORANGE  = 166

    ACCENT         = GRUVBOX_BRIGHT_YELLOW
    ACCENT_DARK    = GRUVBOX_NEUTRAL_YELLOW
    GRAY_BRIGHTEST = GRUVBOX_LIGHT4
    GRAY_BRIGHT    = GRUVBOX_LIGHT1
    GRAY_MIDDLE    = GRUVBOX_GRAY_245
    GRAY_DARK      = GRUVBOX_DARK2
    GRAY_DARKEST   = GRUVBOX_DARK1

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                bg = self.GRUVBOX_BRIGHT_RED
            if context.border:
                fg = self.GRUVBOX_NEUTRAL_GREEN
            if context.media:
                if context.image:
                    fg = self.GRUVBOX_BRIGHT_YELLOW
                else:
                    fg = self.GRUVBOX_BRIGHT_ORANGE
            if context.document:
                fg = self.GRUVBOX_BRIGHT_BLUE
            if context.container:
                fg = self.GRUVBOX_BRIGHT_RED
            if context.directory:
                attr |= bold
                fg = self.GRAY_MIDDLE
            elif context.executable and not \
                    any((context.media, context.container,
                        context.fifo, context.socket)):
                attr |= bold
                #fg = self.GRUVBOX_BRIGHT_PURPLE
            if context.socket:
                fg = self.GRUVBOX_BRIGHT_PURPLE
                attr |= bold
            if context.fifo or context.device:
                fg = self.GRUVBOX_BRIGHT_YELLOW
                if context.device:
                    attr |= bold
            if context.link:
                fg = context.good and self.GRUVBOX_LIGHT1 or self.GRUVBOX_NEUTRAL_PURPLE
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (self.GRUVBOX_BRIGHT_RED, self.GRUVBOX_BRIGHT_PURPLE):
                    fg = self.GRUVBOX_LIGHT0
                else:
                    fg = self.GRUVBOX_BRIGHT_RED
            if not context.selected and (context.cut or context.copied):
                bg = self.GRAY_DARKEST
                fg = self.GRAY_BRIGHTEST
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    bg = self.GRUVBOX_BRIGHT_YELLOW
                    fg = self.GRAY_DARKEST
            if context.badinfo:
                if attr & reverse:
                    bg = self.GRUVBOX_BRIGHT_PURPLE
                else:
                    fg = self.GRUVBOX_BRIGHT_PURPLE

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = context.bad and self.GRUVBOX_BRIGHT_RED or self.ACCENT_DARK
            elif context.directory:
                fg = self.GRAY_MIDDLE
            elif context.tab:
                if context.good:
                    bg = self.ACCENT_DARK
            elif context.link:
                fg = self.GRUVBOX_BRIGHT_AQUA

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = self.GRUVBOX_GRAY_244
                elif context.bad:
                    fg = self.GRUVBOX_BRIGHT_PURPLE
            if context.marked:
                attr |= bold | reverse
                fg = self.GRUVBOX_BRIGHT_YELLOW
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = self.GRUVBOX_BRIGHT_RED
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = self.GRUVBOX_NEUTRAL_ORANGE
                attr &= ~bold
            if context.vcscommit:
                fg = self.GRUVBOX_GRAY_244
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
                fg = self.GRUVBOX_BRIGHT_PURPLE
            elif context.vcschanged:
                fg = self.GRUVBOX_BRIGHT_RED
            elif context.vcsunknown:
                fg = self.GRUVBOX_BRIGHT_RED
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
                fg = self.GRUVBOX_BRIGHT_RED
            elif context.vcsahead:
                fg = blue
            elif context.vcsdiverged:
                fg = self.GRUVBOX_BRIGHT_PURPLE
            elif context.vcsunknown:
                fg = self.GRUVBOX_BRIGHT_RED

        return fg, bg, attr

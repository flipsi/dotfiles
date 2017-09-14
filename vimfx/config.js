// vimfx configuration file (firefox vim plugin)
// author: "Philipp Moers" <soziflip@gmail.com>


////////////////////////////////////////////////////////////////////////////////



// vimfx.set('prevent_autofocus', true)




// add a mapping (keybinding) for a command
let map = (shortcut, command, custom=false) => {
    unmap(shortcut);
    shortcut.length > 1 ? unmap(shortcut[0]) : null;
    const setting = `${custom ? 'custom.' : ''}mode.normal.${command}`;
    const shortcuts = vimfx.get(setting).split(' ');
    if (!shortcuts.includes(shortcut)) {
        shortcuts.push(shortcut);
        vimfx.set(setting, shortcuts.join(' '));
    }
};

// remove a mapping
let unmap = (shortcut) => {
    for (var i = 0, len = unmap_commands.length; i < len; i++) {
        var command = unmap_commands[i];
        var setting = `mode.normal.${command}`;
        var shortcuts = vimfx.get(setting).split(' ');
        if (shortcuts.includes(shortcut)) {
            shortcuts = shortcuts.filter(s => s != shortcut);
            vimfx.set(setting, shortcuts.join(' '));
            break;
        }
    }
};

// commands to check for unmappings
const unmap_commands = [
    'scroll_half_page_down',
    'scroll_half_page_up',
    'scroll_right',
    'tab_new',
    'tab_new_after_current',
    'tab_select_next',
    'window_new'
];




// let categories = vimfx.get('categories');
// categories.insert = {
//     name: 'Editing',
//     order: categories.misc.order - 1,
// };
// let lineEditingBinding = (opts) => {
//     opts.category = 'insert';
//     vimfx.addCommand(
//         opts,
//         ({vim}) => {
//             let cb = lineEditingCallbacks[opts.name];
//             let data_cb = lineEditingDataCallbacks[opts.name];
//             let data = data_cb ? data_cb(vim) : null;
//             let active = vim.window.document.activeElement;
//             if (active && isEditableInput(active)) {
//                 cb(active, data);
//             }
//             else {
//                 vimfx.send(vim, opts.name, data, null);
//             }
//         }
//     );
// };



let {commands} = vimfx.modes.normal;




////////////////////////////////////////////////////////////////////////////////
// where not to use vimfx bindings

vimfx.addKeyOverrides(
    [
        location => location.hostname === 'mail.google.com',
        [
            'A', 'i', 'c', 'j', 'k', 'm', 'N', 'U', 'x', '?'
        ]
    ]
);


////////////////////////////////////////////////////////////////////////////////
// searching

map('ö', 'find');

// TODO: implement duckduckgo search -> google search
// map('gs', )


////////////////////////////////////////////////////////////////////////////////
// scrolling

map('<a-j>', 'scroll_half_page_down');
map('<a-k>', 'scroll_half_page_up');
map('<c-d>', 'scroll_half_page_down');
map('<c-u>', 'scroll_half_page_up');

map('<c-f>', 'scroll_page_down');
map('<c-b>', 'scroll_page_up');

map('Ä', 'scroll_to_mark');


////////////////////////////////////////////////////////////////////////////////
// tab (buffer) management


map('qq', 'tab_close');
map('dd', 'tab_close');
map('u',  'tab_restore');
map('qo', 'tab_close_other');

map('<a-n>', 'tab_select_next');
map('<a-p>', 'tab_select_previous');

// remember 'eb'!

vimfx.addCommand({
    name: 'goto_tab',
    description: 'Goto tab',
    category: 'tabs',
}, (args) => {
    commands.focus_location_bar.run(args);
    args.vim.window.gURLBar.value = '% ';
});
map('#', 'goto_tab', true);

map('<a-N>', 'tab_move_forward');
map('<a-P>', 'tab_move_backward');


map('T', 'tab_duplicate');

map('gt', 'tab_new_after_current');


////////////////////////////////////////////////////////////////////////////////
// follow links

map('f', 'follow');
map('l', 'follow_in_focused_tab');
map('gF', 'follow_multiple');

// keys to follow links
vimfx.set('hints.chars', 'abcdefghijklmnoprstu');
// remember to search for link text by writing uppercase! nice!



////////////////////////////////////////////////////////////////////////////////
// history

map('<c-o>', 'history_back');
map('<c-i>', 'history_forward');



////////////////////////////////////////////////////////////////////////////////
// zooming

// let {
//   commands
// } = vimfx.modes.normal;

// vimfx.addCommand({
//   name: 'zoom_in',
//   description: 'Zoom in',
// }, ({
//   vim
// }) => {
//   vim.window.FullZoom.enlarge();
// });
// map('d', 'mode.normal.zoom_in', true);

// vimfx.addCommand({
//   name: 'zoom_out',
//   description: 'Zoom out',
// }, ({
//   vim
// }) => {
//   vim.window.FullZoom.reduce();
// });
// map('-', 'mode.normal.zoom_out', true);



////////////////////////////////////////////////////////////////////////////////
// quickmarks

let quickmarks = [
    ['a',  'https://www.fromatob.com/'],
    ['b',  'https://www.banking-rb-mnord.de/banking-private/entry'],
    ['c',  'http://catchinside.de/index.php?option=com_users&view=login'],
    ['d',  'http://drive.google.com/drive/'],
    ['e',  'http://www.heise.de/'],
    ['f',  'https://de-de.facebook.com/groups/901248313307453/'],
    ['g',  'https://github.com/'],
    ['h',  'https://www.heute.de/'],
    ['wg', 'https://github.com/onpage-org/'],
    ['wj', 'https://onpage.atlassian.net/secure/RapidBoard.jspa?rapidView=7'],
    ['wc', 'https://onpage.atlassian.net/wiki/discover/all-updates'],
    ['wq', 'https://docs.google.com/spreadsheets/d/17QbADpr9nn7VAdhotSqMic64NTFAM3o-qTYI3qDPdvw/edit#gid=0'],
    ['l',  'http://localhost/~sflip/projects/'],
    ['m',  'https://mail.google.com/mail/u/0/#inbox'],
    ['n',  'https://www.zdf.de/sendung-verpasst#abends'],
    ['o',  'https://stackoverflow.com/questions/tagged/vim'],
    ['p',  'http://sflip.bplaced.de/'],
    ['s',  'https://scholar.google.com/'],
    ['t',  'https://twitter.com/'],
    ['v',  'http://www.hoerzu.de/tv-programm/'],
    ['y',  'https://accounts.google.com/ServiceLogin?uilel=3&service=youtube&passive=true&continue=http%3A%2F%2Fwww.youtube.com%2Fsignin%3Faction_handle_signin%3Dtrue%26nomobiletemp%3D1%26hl%3Dde_DE%26next%3D%252F&hl=de_DE&ltmpl=sso'],
    ['zf', 'http://fishshell.com/docs/current/index.html'],
    ['zi', 'http://i3wm.org/docs/userguide.html']
];

let mapQuickmark = function(quickmark, url) {

  const goCommand = `quickmark_go_${quickmark}`;
  vimfx.addCommand({
    name: goCommand,
    description: `Open quickmark ${url}`,
  }, ({
    vim
  }) => {
    vim.window.gBrowser.loadURI(url);
  });
  map(`go${quickmark}`, goCommand, true);

  const gnCommand = `quickmark_gn_${quickmark}`;
  vimfx.addCommand({
    name: gnCommand,
    description: `Open quickmark ${url}`,
  }, ({
    vim
  }) => {
    vim.window.gBrowser.loadTabs([url])
  });
  map(`gn${quickmark}`, gnCommand, true);
};

quickmarks.forEach(q => {
  mapQuickmark(q[0], q[1]);
});



////////////////////////////////////////////////////////////////////////////////
// windows

vimfx.addCommand({
    name: 'goto_downloads',
    description: 'Downloads',
}, ({vim}) => {
    // vim.window.switchToTabHavingURI('about:downloads', true)
    vim.window.DownloadsPanel.showDownloadsHistory();
});
map('wd', 'goto_downloads', true);

vimfx.addCommand({
    name: 'goto_addons',
    description: 'Addons',
}, ({vim}) => {
    vim.window.BrowserOpenAddonsMgr();
});
map('wa', 'goto_addons', true);

vimfx.addCommand({
    name: 'goto_preferences',
    description: 'Preferences',
}, ({vim}) => {
    vim.window.openPreferences();
});
map('wp', 'goto_preferences', true);

vimfx.addCommand({
    name: 'goto_config',
    description: 'Config',
}, ({vim}) => {
    vim.window.switchToTabHavingURI('about:config', true);
});
map('wc', 'goto_config', true);


////////////////////////////////////////////////////////////////////////////////

vimfx.addCommand({
    name: 'toggle_https',
    description: 'Toggle HTTPS',
    category: 'location',
}, ({vim}) => {
    let url = vim.window.gBrowser.selectedBrowser.currentURI.spec;
    if (url.startsWith('http://')) {
        url = url.replace(/^http:\/\//, 'https://');
    } else if (url.startsWith('https://')) {
        url = url.replace(/^https:\/\//, 'http://');
    }
    vim.window.gBrowser.loadURI(url);
});
map('gS', 'toggle_https', true);




////////////////////////////////////////////////////////////////////////////////

// lineEditingBinding({
//     name: 'kill_backward',
//     description: 'delete line backward',
// });
// vimfx.set('custom.mode.normal.kill_backward', '<force><c-u>');




////////////////////////////////////////////////////////////////////////////////

map('<F5>', 'reload_config_file');

////////////////////////////////////////////////////////////////////////////////

console.log("Loaded vimfx config.");

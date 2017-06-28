// vimfx configuration file (firefox vim plugin)
// author: "Philipp Moers" <soziflip@gmail.com>


////////////////////////////////////////////////////////////////////////////////



// vimfx.set('prevent_autofocus', true)




// add a mapping (keybinding) for a command
let map = (shortcut, command, custom=false) => {
    // unmap(shortcut);
    const setting = `${custom ? 'custom.' : ''}mode.normal.${command}`;
    const shortcuts = vimfx.get(setting).split(' ');
    if (!shortcuts.includes(shortcut)) {
        shortcuts.push(shortcut);
        vimfx.set(setting, shortcuts.join(' '));
    }
};

// remove a mapping
let unmap = (shortcut, command=null) => {
    // TODO: loop through all commands and find shorcut to remove it, so that command becomes obsolete
    const setting = `mode.normal.${command}`;
    var shortcuts = vimfx.get(setting).split(' ');
    shortcuts = shortcuts.filter(s => s != shortcut);
    vimfx.set(setting, shortcuts.join(' '));
};



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



// unmap('window');

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

map('Ä', 'scroll_to_mark');


////////////////////////////////////////////////////////////////////////////////
// tab (buffer) management

unmap('d', 'scroll_half_page_down');
unmap('u', 'scroll_half_page_up');

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


unmap('T', 'tab_new_after_current');
map('T', 'tab_duplicate');

unmap('gt', 'tab_select_next');
map('gt', 'tab_new_after_current');


////////////////////////////////////////////////////////////////////////////////
// follow links

unmap('l', 'scroll_right');

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

// TODO: implement




////////////////////////////////////////////////////////////////////////////////
// windows

unmap('w', 'window_new');

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

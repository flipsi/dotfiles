/* use strict */

let isWorker = this.CONTEXT == null;
var global = this;

XML.ignoreWhitespace = XML.prettyPrinting = false;
if (!isWorker)
    var INFO =
<plugin name="fix-focus" version="0.1"
        href="http://dactyl.sf.net/pentadactyl/plugins#fix-focus-plugin"
        summary="Focus fixer"
        xmlns={NS}>
    <author email="maglione.k@gmail.com">Kris Maglione</author>
    <license href="http://opensource.org/licenses/mit-license.php">MIT</license>
    <project name="Pentadactyl" minVersion="1.0"/>
    <system feature="X11"/>
    <p>
        This plugin is what amounts to a massive hack to restore focus
        to Firefox when it's been grabbed by a plugin. This plugin,
        which only works on X11 systems, functions by grabbing a key
        via an external library, and faking a click on the Firefox
        window when that key is pressed. Prior to Firefox 4, it was
        possible to restore the focus with a relatively simple function
        call. Currently, however, it seems that focus is restored only
        when the main Firefox window is clicked. This means that, in
        order for this plugin to function properly, the bottom-right of
        the Firefox window <em>must</em> be unobscured, or the window
        that obscures it will receive a click event instead.
    </p>
    <item>
        <tags>'ffk' 'fixfocus-key'</tags>
        <spec>'fixfocus-key' 'ffk'</spec>
        <type>string</type> <default>&lt;A-bracketleft></default>
        <description>
            <p>
                A key that may be pressed to wrest focus from plugins.
                Please note that although key modifiers are specified as
                in <t>key-notation</t>, the key name itself is an X11
                keysym name, as may be gleaned from the output of the
                <tt>xev</tt> program.
            </p>
        </description>
    </item>
</plugin>;

let xcb_atom_t = ctypes.uint32_t;
let xcb_button_t = ctypes.uint8_t;
let xcb_connection_t = ctypes.voidptr_t;
let xcb_colormap_t = ctypes.uint32_t;
let xcb_key_symbols_t = ctypes.void_t;
let xcb_keycode_t = ctypes.uint8_t;
let xcb_keysym_t = ctypes.uint32_t;
let xcb_timestamp_t = ctypes.uint32_t;
let xcb_visualid_t = ctypes.uint32_t;
let xcb_window_t = ctypes.uint32_t;
let xcb_setup_t = ctypes.void_t;
let xcb_generic_error_t = ctypes.void_t;
let xcb_void_cookie_t = ctypes.voidptr_t;

for (let [k, v] in Iterator({
    xcb_generic_event_t: {
        response_type: ctypes.uint8_t,
        pad0: ctypes.uint8_t,
        sequence: ctypes.uint16_t,
        pad: ctypes.uint32_t.array(7),
        full_sequence: ctypes.uint32_t,
    },
    xcb_button_press_event_t: {
        response_type: ctypes.uint8_t,
        detail: xcb_button_t,
        sequence: ctypes.uint16_t,
        time: xcb_timestamp_t,
        root: xcb_window_t,
        event: xcb_window_t,
        child: xcb_window_t,
        root_x: ctypes.int16_t,
        root_y: ctypes.int16_t,
        event_x: ctypes.int16_t,
        event_y: ctypes.int16_t,
        state: ctypes.uint16_t,
        same_screen: ctypes.uint8_t,
        pad0: ctypes.uint8_t,
    },
    xcb_key_press_event_t: {
        response_type: ctypes.uint8_t,
        detail: xcb_keycode_t,
        sequence: ctypes.uint16_t,
        time: xcb_timestamp_t,
        root: xcb_window_t,
        event: xcb_window_t,
        child: xcb_window_t,
        root_x: ctypes.int16_t,
        root_y: ctypes.int16_t,
        event_x: ctypes.int16_t,
        event_y: ctypes.int16_t,
        state: ctypes.uint16_t,
        same_screen: ctypes.uint8_t,
        pad0: ctypes.uint8_t
    },
    xcb_get_property_reply_t: {
        response_type: ctypes.uint8_t,
        format: ctypes.uint8_t,
        sequence: ctypes.uint16_t,
        length: ctypes.uint32_t,
        type: xcb_atom_t,
        bytes_after: ctypes.uint32_t,
        value_len: ctypes.uint32_t,
        pad0: ctypes.uint8_t.array(12)
    },
    xcb_intern_atom_reply_t: {
        response_type: ctypes.uint8_t,
        pad0: ctypes.uint8_t,
        sequence: ctypes.uint16_t,
        length: ctypes.uint32_t,
        atom: xcb_atom_t
    },
    xcb_screen_t: {
        root: xcb_window_t,
        default_colormap: xcb_colormap_t,
        white_pixel: ctypes.uint32_t,
        black_pixel: ctypes.uint32_t,
        current_input_masks: ctypes.uint32_t,
        width_in_pixels: ctypes.uint16_t,
        height_in_pixels: ctypes.uint16_t,
        width_in_millimeters: ctypes.uint16_t,
        height_in_millimeters: ctypes.uint16_t,
        min_installed_maps: ctypes.uint16_t,
        max_installed_maps: ctypes.uint16_t,
        root_visual: xcb_visualid_t,
        backing_stores: ctypes.uint8_t,
        save_unders: ctypes.uint8_t,
        root_depth: ctypes.uint8_t,
        allowed_depths_len: ctypes.uint8_t
    },
    xcb_screen_iterator_t: {
        get data() xcb_screen_t.ptr,
        rem: ctypes.int,
        index: ctypes.int,
    }
}))
    global[k] = ctypes.StructType(k, [toObject([[prop, type]]) for ([prop, type] in Iterator(v))]);

function toArray(iter) {
    let res = [];
    for (let i in iter)
        res.push(i);
    return res;
}
function toObject(ary) {
    let res = {};
    for each (let [k, v] in ary)
        res[k] = v;
    return res;
}

let XAttributes = {
    BACK_PIXMAP: 1<<0,
    BACK_PIXEL: 1<<1,
    BORDER_PIXMAP: 1<<2,
    BORDER_PIXEL: 1<<3,
    BIT_GRAVITY: 1<<4,
    WIN_GRAVITY: 1<<5,
    BACKING_STORE: 1<<6,
    BACKING_PLANES: 1<<7,
    BACKING_PIXEL: 1<<8,
    OVERRIDE_REDIRECT: 1<<9,
    SAVE_UNDER: 1<<10,
    EVENT_MASK: 1<<11,
    DONT_PROPAGATE: 1<<12,
    COLORMAP: 1<<13,
    CURSOR: 1<<14,
};
let XGrabMode = {
    SYNC: 0,
    ASYNC: 1
};
let XEvent = {
    KEY_PRESS: 2,
    KEY_RELEASE: 3,
    BUTTON_PRESS: 4,
    BUTTON_RELEASE: 5,
    MOTION_NOTIFY: 6,

    MASK_NO_EVENT: 1<<-1,
    MASK_KEY_PRESS: 1<<0,
    MASK_KEY_RELEASE: 1<<1,
    MASK_BUTTON_PRESS: 1<<2,
    MASK_BUTTON_RELEASE: 1<<3,
    MASK_ENTER_WINDOW: 1<<4,
    MASK_LEAVE_WINDOW: 1<<5,
    MASK_POINTER_MOTION: 1<<6,
    MASK_POINTER_MOTION_HINT: 1<<7,
    MASK_BUTTON_1_MOTION: 1<<8,
    MASK_BUTTON_2_MOTION: 1<<9,
    MASK_BUTTON_3_MOTION: 1<<10,
    MASK_BUTTON_4_MOTION: 1<<11,
    MASK_BUTTON_5_MOTION: 1<<12,
    MASK_BUTTON_MOTION: 1<<13,
    MASK_KEYMAP_STATE: 1<<14,
    MASK_EXPOSURE: 1<<15,
    MASK_VISIBILITY_CHANGE: 1<<16,
    MASK_STRUCTURE_NOTIFY: 1<<17,
    MASK_RESIZE_REDIRECT: 1<<18,
    MASK_SUBSTRUCTURE_NOTIFY: 1<<19,
    MASK_SUBSTRUCTURE_REDIRECT: 1<<20,
    MASK_FOCUS_CHANGE: 1<<21,
    MASK_PROPERTY_CHANGE: 1<<22,
    MASK_COLOR_MAP_CHANGE: 1<<23,
    MASK_OWNER_GRAB_BUTTON: 1<<24,
};
let XModMask = {
    SHIFT: 1<<0,
    LOCK: 1<<1,
    CONTROL: 1<<2,
    MOD_1: 1<<3,
    MOD_2: 1<<4,
    MOD_3: 1<<5,
    MOD_4: 1<<6,
    MOD_5: 1<<7,
    ANY: 1<<15
};

function declare(lib, obj) {
    for (let [name, proto] in Iterator(obj))
        global[name] = lib.declare.apply(lib, [name, ctypes.default_abi].concat(proto));
}
let xcb = ctypes.open("libxcb.so");
declare(xcb, {
    xcb_connect: [xcb_connection_t, ctypes.char.ptr, ctypes.int.ptr],
    xcb_disconnect: [ctypes.void_t, xcb_connection_t],
    xcb_flush: [ctypes.void_t, xcb_connection_t],
    xcb_generate_id: [ctypes.int32_t, xcb_connection_t],
    xcb_poll_for_event: [xcb_generic_event_t.ptr, xcb_connection_t],
    xcb_wait_for_event: [xcb_generic_event_t.ptr, xcb_connection_t],
    xcb_change_window_attributes: [xcb_void_cookie_t, xcb_connection_t, xcb_window_t, ctypes.uint32_t, ctypes.uint32_t.array().ptr],
    xcb_get_property: [xcb_void_cookie_t, xcb_connection_t, ctypes.uint8_t, xcb_window_t, xcb_atom_t, xcb_atom_t, ctypes.uint32_t, ctypes.uint32_t],
    xcb_get_property_reply: [xcb_get_property_reply_t.ptr, xcb_connection_t, xcb_void_cookie_t, xcb_generic_error_t.ptr.ptr],
    xcb_get_property_value: [ctypes.voidptr_t, xcb_get_property_reply_t.ptr],
    xcb_get_property_value_length: [ctypes.int, xcb_get_property_reply_t.ptr],
    xcb_grab_key: [xcb_void_cookie_t, xcb_connection_t, ctypes.uint8_t, xcb_window_t, ctypes.uint16_t, xcb_keycode_t, ctypes.uint8_t, ctypes.uint8_t],
    xcb_ungrab_key: [xcb_void_cookie_t, xcb_connection_t, xcb_keycode_t, xcb_window_t, ctypes.uint16_t],
    xcb_intern_atom: [xcb_void_cookie_t, xcb_connection_t, ctypes.uint8_t, ctypes.uint16_t, ctypes.char.ptr],
    xcb_intern_atom_reply: [xcb_intern_atom_reply_t.ptr, xcb_connection_t, xcb_void_cookie_t, xcb_generic_error_t.ptr.ptr],
    xcb_screen_next: [ctypes.void_t, xcb_screen_iterator_t.ptr],
    xcb_setup_roots_iterator: [xcb_screen_iterator_t, xcb_setup_t.ptr],
    xcb_get_setup: [xcb_setup_t.ptr, xcb_connection_t]
});

let xcb_keysyms = ctypes.open("libxcb-keysyms.so");
declare(xcb_keysyms, {
    xcb_key_symbols_alloc: [xcb_key_symbols_t.ptr, xcb_connection_t],
    xcb_key_symbols_free: [ctypes.void_t, xcb_key_symbols_t.ptr],
    xcb_key_symbols_get_keycode: [xcb_keycode_t.ptr, xcb_key_symbols_t.ptr, xcb_keysym_t],
    xcb_key_symbols_get_keysym: [xcb_keysym_t, xcb_key_symbols_t.ptr, xcb_keysym_t, ctypes.int],
});

let xcb_xtest = ctypes.open("libxcb-xtest.so");
declare(xcb_xtest, {
    xcb_test_fake_input: [xcb_void_cookie_t, xcb_connection_t, ctypes.uint8_t, ctypes.uint8_t, ctypes.uint32_t, xcb_window_t, ctypes.uint16_t, ctypes.uint16_t, ctypes.uint8_t],
    xcb_test_get_version: [xcb_void_cookie_t, xcb_connection_t, ctypes.uint8_t, ctypes.uint16_t],
    xcb_test_get_version_reply: [ctypes.voidptr_t, xcb_connection_t, xcb_void_cookie_t, xcb_generic_error_t.ptr]
});

try {
    var libc = ctypes.open("libc.so");
} catch (e) {
    libc = ctypes.open("libc.so.6");
}
declare(libc, {
    free: [ctypes.void_t, ctypes.voidptr_t]
});

function atom(name) {
    let reply = xcb_intern_atom_reply(connection,
        xcb_intern_atom(connection, false, name.length, name),
        null);
    let res = reply.contents.atom;
    free(reply);
    return res;
}
function getProperty(window, property, type, offset, length) {
    let reply = xcb_get_property_reply(connection,
        xcb_get_property(connection, false, window, property, type, offset, length),
        null);
    if (reply.isNull())
        return null;
    let type = ctypes["uint" + reply.contents.format + "_t"].array(reply.contents.value_len);
    let res = {
        type: reply.contents.type,
        value: type(ctypes.cast(xcb_get_property_value(reply), type.ptr).contents)
    }
    free(reply);
    return res;
}
function fake_button(type, button) {
    xcb_test_fake_input(connection, type, button, 0, scrn.root, 0, 0, 0);
}
function fake_motion(relative, x, y) {
    xcb_test_fake_input(connection, XEvent.MOTION_NOTIFY, relative, 0, scrn.root, x, y, 0);
}

let win;
let scrn = ctypes.int();
let connection, setup, screens, done;
function init(conn) {
    connection = conn;

    setup = xcb_get_setup(connection);
    screens = xcb_setup_roots_iterator(setup);
    while (scrn.value--)
        xcb_screen_next(screens.address())
    scrn = screens.data.contents;
}

if (isWorker) {
    global.dump = function dump(obj) {
        libc.declare("printf", ctypes.default_abi, ctypes.int, ctypes.char.ptr, ctypes.char.ptr)(
            "%s\n", String(obj));
    }

    global.iter = function iter(obj) {
        if (obj instanceof ctypes.CData) {
            while (obj.constructor instanceof ctypes.PointerType)
                obj = obj.contents;
            if (obj.constructor instanceof ctypes.ArrayType)
                return (function () {
                    for (let i = 0; i < obj.length; i++)
                        yield [i, obj[i]];
                })();
            if (obj.constructor instanceof ctypes.StructType)
                return (function () {
                    for (let [, prop] in Iterator(obj.constructor.fields))
                        let ([name, type] = Iterator(prop).next()) {
                            yield [name, obj[name]];
                        }
                })();
            obj = {};
        }
        return Iterator(obj);
    }

    global.onmessage = function onmessage(event) {
        function unptr(val, type) ctypes.cast(ctypes.int64_t(val), type);
        done = ctypes.int(0);

        init(unptr(event.data.connection, xcb_connection_t));
        done = unptr(event.data.done, ctypes.int.ptr);

        let ev;
        while(!done.contents && (ev = xcb_wait_for_event(connection)) && !ev.isNull()) {
            try {
                if (!ev.isNull()) {
                    // dump(ev.contents);
                    if ([-XEvent.KEY_PRESS, XEvent.KEY_RELEASE].indexOf(ev.contents.response_type) > -1)
                        postMessage(toObject(iter(ctypes.cast(ev, xcb_key_press_event_t.ptr).contents)));
                    if (false && [XEvent.BUTTON_PRESS, XEvent.BUTTON_RELEASE].indexOf(ev.contents.response_type) > -1)
                        postMessage(toObject(iter(ctypes.cast(ev, xcb_button_press_event_t.ptr).contents)));
                }
                free(ev);
            } catch (e) {
                dump(e);
            }
        }
        dump("done");
    }
}
else {
    var onUnload = function onUnload() {
        if (done)
            done.value = 1;
        if (connection)
            xcb_disconnect(connection);
        if (keysymTable)
            xcb_key_symbols_free(keysymTable);
        [xcb, xcb_keysyms, xcb_xtest, libc].forEach(function (lib) lib && lib.close);
        connection = libc = xcb = null;
    }

    var box = document.getElementById("dactyl-fixfocus-box");
    if (!box) {
        box = util.xmlToDom(<vbox xmlns={XUL} flex="1" id="dactyl-fixfocus-box"
                                  highlight="FixFocus"/>, document);
        box.show = function show() {
            this.parentNode.firstChild.collapsed = true;
            this.parentNode.selectedPanel = this;
            util.computedStyle(this).innerHeight; // Force update
        }
        box.addEventListener("click", function (event) {
            box.parentNode.firstChild.collapsed = false;
            box.parentNode.selectedIndex = 0;
            fake_motion(false,
                        window.mozInnerScreenX + window.innerWidth,
                        window.mozInnerScreenY + window.innerHeight);
            xcb_flush(connection);
        }, true);
        document.getElementById("tab-view-deck").appendChild(box);
    }

    init(xcb_connect(null, scrn.address()));
    var keysymTable = xcb_key_symbols_alloc(connection);

    var win;
    util.yieldable(function () {
    outer:
        while (!win) {
            let _NET_WM_NAME = atom("_NET_WM_NAME");
            let UTF8_STRING = atom("UTF8_STRING");

            let title = window.document.title, mytitle = "{dactyl-window:" + Date.now() + "}";;
            try {
                for (let i in util.range(1, 1000)) {
                    window.document.title = mytitle;
                    yield 5
                    let list = getProperty(scrn.root, atom("_NET_CLIENT_LIST"), atom("WINDOW"), 0, 1024).value;
                    for (let [i, xid] in iter(list)) {
                        let prop = getProperty(xid, _NET_WM_NAME, UTF8_STRING, 0, 1024);
                        try {
                            if (prop && prop.value.readString() === mytitle) {
                                win = xid;
                                break outer;
                            }
                        }
                        catch (e) {}
                    }
                }
            }
            finally {
                window.document.title = title;
            }
            yield 100;
        }

        ready();
    })();

    var keysyms = array(io.system("xmodmap -pke", true)
                          .split("\n")
                          .map(function (l) let (m=/^keycode\s+(\d+)\s+=\s+(.*)/.exec(l))
                               m && m[2].split(/\s+/)
                                        .map(function (k) [k.toLowerCase(), parseInt(m[1])])))
        .compact().flatten().toObject();

    var grabbed;
    var modMap = [
        ["altKey", XModMask.MOD_1],
        ["ctrlKey", XModMask.CONTROL],
        ["metaKey", XModMask.MOD_4],
        ["shiftKey", XModMask.SHIFT],
    ];

    group.options.add(["fixfocus-key", "ffk"],
        "A key that may be pressed to wrest focus from plugins",
        "string", "<A-bracketleft>",
        {
            completer: function (context) {
                let p = "<" + context.filter.match(/^([CSMA]-)*/)[0];
                return Object.keys(keysyms).map(function (k) [p + k + ">", p + k + ">"])
            },
            setter: function (value) {
                if (!win)
                    return;

                if (grabbed)
                    xcb_ungrab_key(connection, grabbed[0], win, grabbed[1]);

                let event = events.fromString(value, true)[0];
                grabbed = [
                    keysyms[event.dactylKeyname],
                    modMap.map(function ([prop, mask]) event[prop] && mask)
                          .reduce(function (a, b) a|b)
                ];

                xcb_grab_key(connection, false, win, grabbed[1], grabbed[0],
                             XGrabMode.ASYNC, XGrabMode.ASYNC);
                xcb_flush(connection);
            },
            validator: function (value) 
                let (keys = events.fromString(value, true))
                    Option.validIf(keys.length == 1,
                                   "Only one key may be specified") &&
                    Option.validIf(Set.has(keysyms, keys[0].dactylKeyname),
                                   "Invalid keysym name")
        });
}

function ready() {
    options["fixfocus-key"] = options["fixfocus-key"];

    var ary = ctypes.uint32_t.array()([XEvent.MASK_KEY_PRESS | XEvent.MASK_KEY_RELEASE]);
    xcb_change_window_attributes(connection, win, XAttributes.EVENT_MASK,
                                 ctypes.cast(ary.address(), ctypes.uint32_t.array().ptr));
    xcb_flush(connection);

    var ptr = function ptr(val) String(ctypes.cast(val, ctypes.int64_t).value);
    done = ctypes.int(0);

    let resProtocol = Cc["@mozilla.org/network/protocol;1?name=resource"]
                            .getService(Ci.nsIResProtocolHandler)
    resProtocol.setSubstitution("dactyl-files", util.newURI("file:///"))

    var worker = ChromeWorker("resource://dactyl-files" + PATH);
    worker.onmessage = function onmessage(event) {
        let ev = event.data;
        if (ev.response_type === XEvent.KEY_RELEASE && ev.detail === grabbed[0] && (ev.state & grabbed[1]) === grabbed[1]) {
            box.show();
            xcb_flush(connection);

            fake_motion(false,
                        window.mozInnerScreenX + window.innerWidth - 1,
                        window.mozInnerScreenY + window.innerHeight - 1);
            fake_button(XEvent.BUTTON_PRESS, 3);
            fake_button(XEvent.BUTTON_RELEASE, 3);
            xcb_flush(connection);
        }
    }
    worker.onerror = function onerror(event) { util.dump(event); }
    worker.postMessage({ connection: ptr(connection), done: ptr(done.address()) });
}

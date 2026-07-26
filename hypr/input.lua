local vars = require("variables")

hl.config({
    input = {
        kb_layout          = "hu",
        kb_variant         = "102_qwertz_comma_dead_mac_full",
        kb_model           = "applealu_iso",
        kb_options         = "lv3:alt_switch",
        numlock_by_default = false,
        repeat_delay       = 250,
        repeat_rate        = 35,
        focus_on_close     = 1,

        touchpad           = {
            natural_scroll       = true,
            disable_while_typing = vars.touchpadDisableTyping,
            scroll_factor        = vars.touchpadScrollFactor,
        },
    },

    binds = {
        scroll_event_delay = 0,
    },

    cursor = {
        hotspot_padding = 1,
    },
})

from libqtile.backend.wayland.inputs import InputConfig
from libqtile.config import Click, Drag
from libqtile.lazy import lazy

def get_mouse_config() -> list:
    """
    Function that returns mouse related settings.
    """

    from config import MOD
    
    return [
        Drag([MOD], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
        Drag([MOD], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
        Click([MOD], "Button2", lazy.window.bring_to_front()),
    ]

def get_wl_input_rules() -> dict:
    """
    Function that configures wayland input devices.
    """
    return {
        "type:pointer": InputConfig(accel_profile="flat"),
        "type:touchpad": InputConfig(tap=True, natural_scroll=True, dwt=True),
        "type:keyboard": InputConfig(
            kb_repeat_delay=250,
            kb_repeat_rate=50,
            kb_layout="us",
            kb_variant="dvp",
            kb_options="caps:escape",
        ),
    }

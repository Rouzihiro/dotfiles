# ~/.config/qtile/inputs.py
from libqtile.backend.wayland.inputs import InputConfig

wl_input_rules = {
    # Touchpad configuration
    "type:pointer": InputConfig(
        accel_profile="flat",
        tap=True,             # Enable tap-to-click
        natural_scroll=True,  # Natural scrolling
        disable_while_typing=True  # Disable touchpad while typing
    ),
    
    # Keyboard configuration
    "type:keyboard": InputConfig(
        xkb_layout="de",       # German keyboard layout
        xkb_options="caps:escape,compose:rctrl",  # Common useful options
        numlock=True,          # Enable numlock on startup
        repeat_rate=30,       # Key repeat rate (characters per second)
        repeat_delay=250       # Delay before key repeat starts (ms)
    ),
    
    # Optional: Mouse configuration (if using external mouse)
    "type:mouse": InputConfig(
        accel_profile="flat",
        natural_scroll=False   # Regular scroll for external mouse
    )
}

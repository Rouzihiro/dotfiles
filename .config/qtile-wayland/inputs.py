# ~/.config/qtile/inputs.py
from libqtile.backend.wayland.inputs import InputConfig

wl_input_rules = {
    # Touchpad configuration (now with proper libinput settings)
    "type:touchpad": InputConfig(
        tap=True,                   # Enable tap-to-click
        natural_scroll=True,        # Natural scrolling
        disable_while_typing=True,  # Disable during typing
        click_method="clickfinger",  # Alternative: "button_areas"
        scroll_method="two_finger",  # Scroll method
        accel_profile="flat",       # Disable acceleration
        middle_emulation=True       # Helps with some touchpads
    ),
    
    # Keyboard configuration
    "type:keyboard": InputConfig(
        xkb_layout="us",
        xkb_variant="",
        xkb_options="caps:escape",
        numlock=True,
        repeat_rate=30,
        repeat_delay=250
    ),
    
    # Mouse configuration (external mice)
    "type:pointer": InputConfig(
        accel_profile="flat",
        natural_scroll=False
    )
}

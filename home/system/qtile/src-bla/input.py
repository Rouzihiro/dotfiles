from libqtile.backend.wayland.inputs import InputConfig

def get_input_rules():
    """Configure touchpad and keyboard input settings"""
    return {
        # Touchpad configuration
        "type:touchpad": InputConfig(
            tap=True,
            natural_scroll=True,
            dwt=True,                 
            scroll_method="two_finger",
            click_method="clickfinger",
        ),
        
        # Keyboard configuration
        "type:keyboard": InputConfig(
            kb_layout="de", 
            kb_options="caps:escape",
            repeat_rate=30,
            repeat_delay=300,
        ),
        
        "type:pointer": InputConfig(
            accel_profile="flat",
            left_handed=False,
        )
    }

# For X11 users (uncomment if needed)
# def set_xkbmap():
#     os.system("setxkbmap -layout 'us,ge,us' -variant 'dvorak,' -option 'caps:escape'")

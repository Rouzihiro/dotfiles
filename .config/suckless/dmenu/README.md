Please ignore. This is just my personal build of what was once dmenu.

Refer to [https://tools.suckless.org/dmenu/](https://tools.suckless.org/dmenu/) for details on
dmenu, how to install it and how it works. Alternatively you may want to refer to the
[wiki](https://github.com/bakkeby/dmenu/wiki) for more information about this build and the
various options.

---

### Patches included:

   - [alpha](https://github.com/bakkeby/patches/blob/master/dmenu/dmenu-alpha-5.0_20210725_523aa08.diff)
      - adds transparency for the dmenu window

   - [barpadding](https://github.com/bakkeby/patches/wiki/barpadding)
      - adds padding between the dmenu window and the edge of the screen
      - intended to be used in combination with the barpadding patch for dwm

   - [border](http://tools.suckless.org/dmenu/patches/border/)
      - adds a border around the dmenu window

   - [case-insensitive](http://tools.suckless.org/dmenu/patches/case-insensitive/)
      - adds option to make dmenu case-insensitive by default

   - [center](https://tools.suckless.org/dmenu/patches/center/)
      - this patch centers dmenu in the middle of the screen

   - color_emoji
      - enables color emoji in dmenu by removing a workaround for a BadLength error in the Xft
        library when color glyphs are used
      - enabling this will crash dmenu on encountering such glyphs unless you also have an updated
        Xft library that can handle them

   - [dynamic_options](https://tools.suckless.org/dmenu/patches/dynamicoptions/)
      - adds an option which makes dmenu run the command given to it whenever input is changed
        with the current input as the last argument and update the option list according to the
        output of that command

   - [fuzzyhighlight](https://tools.suckless.org/dmenu/patches/fuzzyhighlight/)
      - intended to be combined with the fuzzymatch patch, this makes it so that fuzzy matches are
        highlighted

   - [fuzzymatch](https://tools.suckless.org/dmenu/patches/fuzzymatch/)
      - adds support for fuzzy-matching to dmenu, allowing users to type non-consecutive portions
        of the string to be matched

   - [grid](https://tools.suckless.org/dmenu/patches/grid/)
      - allows dmenu's entries to be rendered in a grid by adding a option to specify the
        number of grid columns

   - [gridnav](https://tools.suckless.org/dmenu/patches/gridnav/)
      - adds the ability to move left and right through a grid (when using the grid patch)

   - [highpriority](https://tools.suckless.org/dmenu/patches/highpriority/)
      - this patch will automatically sort the search result so that high priority items are shown
        first

   - [incremental](https://tools.suckless.org/dmenu/patches/incremental/)
      - this patch causes dmenu to print out the current text each time a key is pressed

   - [initialtext](https://tools.suckless.org/dmenu/patches/initialtext/)
      - adds an option to provide preselected text

   - [instant](https://tools.suckless.org/dmenu/patches/instant/)
      - adds a flag that will cause dmenu to select an item immediately if there is only one
        matching option left

   - [line-height](http://tools.suckless.org/dmenu/patches/line-height/)
      - adds an option which sets the minimum height of a dmenu line
      - this helps integrate dmenu with other UI elements that require a particular vertical size

   - [managed](https://tools.suckless.org/dmenu/patches/managed/)
      - adds an option which sets override_redirect to false; thus letting your window manager
        manage the dmenu window
      - this may be helpful in contexts where you don't want to exclusively bind dmenu or want to
        treat dmenu more as a "window" rather than as an overlay

   - [morecolor](https://tools.suckless.org/dmenu/patches/morecolor/)
      - adds an additional color scheme for highlighting entries adjacent to the current selection

   - [mouse-support](https://tools.suckless.org/dmenu/patches/mouse-support/)
      - adds basic mouse support for dmenu

   - [multi-selection](https://tools.suckless.org/dmenu/patches/multi-selection/)
      - without this patch when you press `Ctrl+Enter` dmenu just outputs current item and it is
        not possible to undo that
      - with this patch dmenu will output all selected items only on exit
      - it is also possible to deselect any selected item

   - [navhistory](https://tools.suckless.org/dmenu/patches/navhistory/)
      - provides dmenu the ability for history navigation similar to that of bash

   - [no-sort](https://tools.suckless.org/dmenu/patches/no-sort/)
      - adds an option option to disable sorting menu items after matching
      - useful, for example, when menu items are sorted by their frequency of use (using an
        external cache) and the most frequently selected items should always appear first regardless
        of how they were exact, prefix, or substring matches

   - [numbers](https://tools.suckless.org/dmenu/patches/numbers/)
      - adds text which displays the number of matched and total items in the top right corner of
        dmenu

   - [password](https://tools.suckless.org/dmenu/patches/password/)
      - with this patch dmenu will not directly display the keyboard input, but instead replace it
        with dots
      - all data from stdin will be ignored

   - [plain-prompt](https://tools.suckless.org/dmenu/patches/listfullwidth/)
      - simple change that avoids colors for the prompt by making it use the same style as the
        rest of the input field

   - [preselect](https://tools.suckless.org/dmenu/patches/preselect/)
      - adds an option to preselect an item by providing the index that should be pre-selected

   - [printindex](https://tools.suckless.org/dmenu/patches/printindex/)
      - allows dmenu to print out the 0-based index of matched text instead of the matched text
        itself
      - this can be useful in cases where you would like to select entries from one array of text
        but index into another, or when you are selecting from an ordered list of non-unique items

   - [printinputtext](https://tools.suckless.org/dmenu/patches/printinputtext/)
      - adds an option which makes Return key ignore selection and print the input text to stdout
      - the flag basically swaps the functions of Return and Shift+Return hotkeys

   - [rejectnomatch](https://tools.suckless.org/dmenu/patches/reject-no-match/)
      - adds an option where text input will be rejected if it would result in no matching item

   - [restrict-return](https://tools.suckless.org/dmenu/patches/restrict-return/)
      - adds an option that disables Shift-Return and Ctrl-Return
      - this guarantees that dmenu will only output one item, and that item was read from stdin

   - [separator](https://tools.suckless.org/dmenu/patches/separator/)
      - separates the input in two halves based on a delimiter where one half is displayed in dmenu
        while the other is returned / printed to standard out when selected

   - [symbols](https://tools.suckless.org/dmenu/patches/symbols/)
      - allows the symbols, which are printed in dmenu to indicate that either the input is too
        long or there are too many options to be shown in dmenu in one line, to be defined

   - [~tsv~](https://tools.suckless.org/dmenu/patches/tsv/)
      - ~makes dmenu split input lines at first tab character and only display first part, but it~
        ~will perform matching on and output full lines as usual~
      - ~can be useful if you want to separate data and representation~

   - [vertfull](https://tools.suckless.org/dmenu/patches/vertfull/)
      - prevents dmenu from indenting items at the same level as the prompt length

   - [wmtype](https://github.com/Baitinq/dmenu/blob/master/patches/dmenu-wm_type.diff)
      - adds extended window manager hints such as \_NET_WM_WINDOW_TYPE and \_NET_WM_WINDOW_TYPE_DOCK

   - [xresources](https://tools.suckless.org/dmenu/patches/xresources/)
      - allows dmenu to read font and colors from Xresources

   - [xyw](https://tools.suckless.org/dmenu/patches/xyw/)
      - adds options for specifying dmenu window position and width

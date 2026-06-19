## What is it?

noice is a small curses-based file browser that tries to get out of your way as much as possible.


This started out as some small customizations and keybind changes but I've continued adding to it and now it has most
of the functionality you'd expect from a file manager. I try to maintain the original philosophy of keeping
things small and simple, the ui has not been drastically changed, and the code base has not grown out of proportion.

The external file opener used in recent versions of noice *(nopen)* has been dropped in favour of the old style matching.


## Additions & Keybindings

- `S` to toggle display of entry sizes.

- `<Space>` toggle entry between marked and unmarked state.

- `DD` delete marked entries or the current if none are marked *(Warning!! `DD` is a destructive command, deleted files are not retrievable)*.

- `y` and `u` yank marked entries or the current and un-yank entries respectively.

- `p` copy yanked entries to the current directory*, like `cp`.

- `m` move yanked entries to the current directory, like `mv`. *(Warning!! `m` is a destructive command, source files will be deleted after a successful copy)*.

- `L` link yanked entries to the current directory*, like `ln`.

- `r` rename marked entries or the current if none are marked, like `mv old new`. When multiple entries are marked they're opened with `EDITOR` for bulk renaming.

- `gg` and `G` go to the first or last entry respectively.

- `g'` and `''` jump to the last directory before using a jump or cd.

- `g<key>` or `'<key>` jump to directory matching `<key>` in the config header, for faster access to common directories.

- `nf` and `nd` create new file or directory respectively, leading directories are created as needed, making the following possible `nf newdir/subdir/newfile`.

- `M` to open the current entry with `NOICEMP` environment variable or `mpv --shuffle` if unset.

Change to the last active directory when exiting noice
```
f()
{
	noice "$@" && cd "$(< /tmp/noicedir)"
}
```

## Building

To build noice you need a curses implementation, then run *(as root if needed)*

```
make clean install
```

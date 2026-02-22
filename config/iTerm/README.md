## How to use iTerm Config
* This is my custom iTerm Setup Configs about color Theme, mouse option, key options and many others.
* Only **MacOS** support (becuase iTerm2 support macos only).
* `dotfiles update` (or `python install.py`) will try to symlink this file automatically on macOS.

### Conflict policy
If `~/Library/Preferences/com.googlecode.iterm2.plist` already exists as a regular file
(not a symlink), installer **does not overwrite** it.

You will see a warning like:

```bash
exists, but is not a symbolic link. iTerm2 settings were NOT modified.
Remove the existing file and run `dotfiles update` again:
`rm ~/Library/Preferences/com.googlecode.iterm2.plist`
```

## How to use iTerm Config
* This is my custom iTerm Setup Configs about color Theme, mouse option, key options and many others.
* Only **MacOS** support (becuase iTerm2 support macos only).
* `dotfiles update` (`python install.py`) on macOS applies this plist automatically.

### Install/Update behavior
When `dotfiles update` runs on macOS:
1. Existing `~/Library/Preferences/com.googlecode.iterm2.plist` is moved to a backup:
   - `~/Library/Preferences/com.googlecode.iterm2.plist.bak.YYYYmmddHHMMSS`
2. Repo plist is copied to:
   - `~/Library/Preferences/com.googlecode.iterm2.plist`

No symlink is used for iTerm plist.

### Sync current local settings into repo source
If you changed iTerm locally and want future `dotfiles update` to apply it:

```bash
cp ~/Library/Preferences/com.googlecode.iterm2.plist ~/.dotfiles/config/iTerm/com.googlecode.iterm2.plist
```

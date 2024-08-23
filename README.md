# StickMUDMudletGUI
The official graphical user interface for Mudlet (https://mudlet.org) for StickMUD.

# DeMuddler
The original StickMUD.mpackage was run through [DeMuddler](https://github.com/Edru2/DeMuddler) to generate Lua files for this repository.
```
de-muddler -f StickMUD.mpackage
```
# Muddler
Self-hosted GitHub Actions use [Muddler](https://github.com/demonnic/muddler) to build a release upon each pull request.

# Remember
* Update the version in the [mfile](https://github.com/StickMUD/StickMUDMudletGUI/blob/master/mfile) configuration.
* On [StickMUD](https://www.stickmud.com), update the `GMCP_VALUE_CLIENT_GUI_VERSION` in `/include/gmcp_defs.h` to pickup the new version.

See also [this guidance](https://mud.gesslar.dev/muddler.html) from [@gesslar](https://github.com/gesslar).

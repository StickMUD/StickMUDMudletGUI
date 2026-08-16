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

# License
The code in this repository is released under the MIT License — see [LICENSE](LICENSE).

The icons in [src/resources](src/resources) are not covered by the MIT License. They are
[Flaticon](https://www.flaticon.com) icons used under the Flaticon Free License, which requires
attribution. See [CREDITS.md](CREDITS.md) for the full attribution and license records.

-- Rex configuration for the Mac. ~/.config/rex/init.lua is a symlink to this
-- file; plugins are cloned beside the link, in ~/.config/rex/.

-- Cmd+Shift+V pastes the clipboard's image as a file path, copying it to the
-- remote host first when the focused pane runs there.
-- https://github.com/pablasso/rex-image-paste
require("rex-image-paste").setup()
rex.bind("cmd+shift+v", "image_paste")

-- Shift+Cmd+R toggles rexdiff beside the focused agent. `rexdiff install`
-- added this line; its settings are in ~/.config/rex/rexdiff.lua.
-- https://github.com/rednafi/rexdiff
require("rexdiff")

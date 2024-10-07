local palletes = require("catppuccin.palettes")
local palette = palletes.get_palette("mocha")

palette.text = palette.text
palette.background = palette.base
palette.error = palette.red
palette.warn = palette.peach
palette.info = palette.blue
palette.hint = palette.green

-- indnet rainbow colors
palette.red = palette.red
palette.orange = palette.peach
palette.yellow = palette.yellow
palette.green = palette.green
palette.sky = palette.sky
palette.blue = palette.blue
palette.purple = palette.mauve

return palette

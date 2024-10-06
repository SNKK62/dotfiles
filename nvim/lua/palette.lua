local colorscheme = require("colorscheme")

local palletes = require(colorscheme.name .. ".palettes")
local palette = palletes.get_palette(colorscheme.theme)

return palette

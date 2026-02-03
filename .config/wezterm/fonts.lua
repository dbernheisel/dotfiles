local wezterm = require("wezterm")  --[[@as Wezterm]]

local M = {}

M.jetbrains_features = {
  -- "calt=1", -- Contains all ligatures. Substitution for : between digits.
  -- "zero=1", -- Changes 0 to slashed variant.
  -- "frac=1", -- Substitute digits in fraction sequences to look more like fractions.
  -- "ss01=1", -- Classic construction. JetBrains Mono but even more neutral. Performs better in big paragraph of text.
  -- "ss02=1", -- Closed construction. Change the rhythm to a more lively one.
  -- "ss19=1", -- Adds gaps in ≠ ≠= == === ligatures.
  -- "ss20=1", -- Shift horizontal stroke in f to match x-height.
  -- "cv01=1", -- l with symmetrical lower stroke. (ss01)
  -- "cv02=1", -- t with curly tail. (ss02)
  -- "cv03=1", -- g with more complex construction.
  -- "cv04=1", -- j with curly descender.
  -- "cv05=1", -- l with curly tail. (ss02)
  "cv06=1", -- m with shorter leg. (ss02)
  "cv07=1", -- W w with lover middle connection. (ss02)
  -- "cv08=1", -- K k with sharp connection. (ss01)
  -- "cv09=1", -- f with additional horizontal stroke. (ss01)
  -- "cv10=1", -- r with more open construction. (ss01)
  -- "cv11=1", -- y with different ascender construction. (ss01)
  "cv11=1", -- y with different ascender construction. (ss01)
  "cv12=1", -- u with traditional construction. (ss01)
  -- "cv14=1", -- $ with broken bar.
  -- "cv15=1", -- alternate &.
  -- "cv16=1", -- Q with bent tail.
  -- "cv17=1", -- f with curly ascender. (ss02)
  -- "cv18=1", -- alternate 2 6 9 .
  -- "cv19=1", -- old construction of 8.
  -- "cv20=1", -- old construction of 5.
  -- "cv99=1", -- Highlights Cyrillic C c for debugging purposes.
}

M.fira_features = {
  "zero=1", -- 0 with a dot
  "cv01=1", -- Normalize special symbols @ $ & % Q => ->
  "cv02=1", -- Alternative a with top arm
  "ss06=1", -- Break connected strokes between italic letters al, il, ull
}

M.maple_features = {
  "zero=1", -- 0 with a dot
  "cv01=1", -- Remove gaps in @$&
  "cv02=1", -- a with top arm
  "cv06=1", -- i without platform
  "cv07=1", -- J without hat
  "cv09=1", -- 7 with strike
  -- "cv10=1", -- Zz with strike
  "cv61=1", -- straight puncuation ,;
  "cv64=1", -- less-than straight bar <=
  "cv65=1", -- straighter ampersand
  "cv66=1", -- pipe arrow |>
  "cv31=1", -- italic with arm
  "cv32=1", -- italic f without curls
  "cv33=1", -- italic i without curls
  "cv34=1", -- italic k without curls
  "cv35=1", -- italic l without curls
  "cv36=1", -- italic x without curls
  "cv37=1", -- italic y straight
  "cv39=1", -- italic i without curls
  "cv40=1", -- italic J without hat
  "cv42=1", -- italic 7 with strike
  -- "cv43=1", -- italic z with strike
  "ss03=1", -- Add tags [info]
  "ss07=1", -- >>> > > > connect multi-greaters
  "ss10=1", -- =~ = ~ fuzzy equal 
}

function M.setup(config)
  -- Font
  config.font_size = 16
  config.font = wezterm.font_with_fallback({
    {
      family = "Maple Mono",
      weight = "Regular",
      harfbuzz_features = M.maple_features
    },
    {
      family = "FiraCode Nerd Font Mono",
      weight = "Regular",
      harfbuzz_features = M.fira_features
    },
    { 
      family = "JetBrains Mono", 
      harfbuzz_features = M.jetbrains_features 
    },
  })

  config.font_rules = {
    {
      italic = true,
      font = wezterm.font_with_fallback({
        { 
          family = "Maple Mono", 
          style = "Italic",
          harfbuzz_features = M.maple_features
        },
        { 
          family = "JetBrains Mono", 
          style = "Italic", 
          harfbuzz_features = M.jetbrains_features 
        },
      }),
    },
    {
      intensity = "Bold",
      italic = true,
      font = wezterm.font_with_fallback({
        { 
          family = "Maple Mono", 
          weight = "Bold", 
          style = "Italic",
          harfbuzz_features = M.maple_features,
        },
        { 
          family = "JetBrains Mono", 
          weight = "Bold", 
          style = "Italic", 
          harfbuzz_features = M.jetbrains_features 
        },
      }),
    },
  }
end

return M

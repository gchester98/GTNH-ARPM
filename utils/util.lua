------------------------------------------------------------
-- util.lua
--
-- Misc. Helper Functions for ARPM
------------------------------------------------------------

local util = {}

util.format = {}

------------------------------------------------------------
-- Constants
------------------------------------------------------------

local SUFFIXES = {
--    Scientific,   "Engineering",  "SS Abv.",  "SS Full"
  {   1e33,         "XXX",          "Dc",       "Decillion"   },
  {   1e30,         "Q",            "N",        "Nonillion"   },
  {   1e27,         "R",            "O",        "Octillion"   },
  {   1e24,         "Y",            "Sp",       "Septillion"  },
  {   1e21,         "Z",            "Sx",       "Sextillion"  },
  {   1e18,         "E",            "Qi",       "Quintillion" },
  {   1e15,         "P",            "Qa",       "Quadrillion" },
  {   1e12,         "T",            "T",        "Trillion"    },
  {   1e9,          "G",            "B",        "Billion"     },
  {   1e6,          "M",            "M",        "Million"     }
}

util.format.MODE = {
  AUTO            = "auto",
  RAW             = "raw",
  ENGINEERING     = "engineering",
  SHORT_SCALE     = "short_scale",
  SHORT_SCALE_ABV = "short_scale_abv",
  SCIENTIFIC      = "scientific"
}

------------------------------------------------------------
-- Rounding to Nth decimal
------------------------------------------------------------

function util.format.round(value, decimals)
  decimals = decimals or 0

  local power = 10 ^ decimals
  if value >= 0 then
    return math.floor(value * power + 0.5) / power
  else
    return math.ceil(value * power - 0.5) / power
  end

end

------------------------------------------------------------
-- Comma Separate Values
------------------------------------------------------------

function util.format.commas(value)
  local negative = value < 0
  value = math.abs(value)

  local formatted = tostring(math.floor(value))

  while true do
    formatted, count = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

    if count == 0 then
      break
    end
  end

  if negative then
    formatted = "-" .. formatted
  end

  return formatted

end

------------------------------------------------------------
-- Format Engineering Notation
------------------------------------------------------------

function util.format.engineering(value, decimals)
  decimals = decimals or 2
  local sign = value < 0 and "-" or ""
  value = math.abs(value)

  for _, entry in ipairs(SUFFIXES) do
    if value >= entry[1] then
      local number = util.format.round(value / entry[1], decimals)

      return string.format(
        "%s%." .. decimals .. "f %s",
        sign,
        number,
        entry[2]
      )

    end
  end

  return sign .. tostring(value)

end

------------------------------------------------------------
-- Format Short Scale Notation
------------------------------------------------------------

function util.format.short_scale(value, decimals)
  decimals = decimals or 2
  local sign = value < 0 and "-" or ""
  value = math.abs(value)

  for _, entry in ipairs(SUFFIXES) do
    if value >= entry[1] then
      local number = util.format.round(value / entry[1], decimals)

      return string.format(
        "%s%." .. decimals .. "f %s",
        sign,
        number,
        entry[4]
      )

    end
  end

  return sign .. tostring(value)

end

------------------------------------------------------------
-- Format Short Scale Notation (Abrreviated)
------------------------------------------------------------

function util.format.short_scale_abv(value, decimals)
  decimals = decimals or 2
  local sign = value < 0 and "-" or ""
  value = math.abs(value)

  for _, entry in ipairs(SUFFIXES) do
    if value >= entry[1] then
      local number = util.format.round(value / entry[1], decimals)

      return string.format(
        "%s%." .. decimals .. "f %s",
        sign,
        number,
        entry[3]
      )

    end
  end

  return sign .. tostring(value)

end

------------------------------------------------------------
-- General Number Formatter
--
-- Modes
--    raw               ->  1,234,567,890
--    engineering       ->  1.23 G
--    short_scale       ->  1.23 Billion
--    short_scale_abv   ->  1.23 B
--    scientific        ->  1.23 E9
------------------------------------------------------------

function util.format.number(value, options)
  options = options or {}

  local mode = options.mode or "engineering"
  local decimals = options.decimals or 2
  local separator = options.separator

  if mode == "raw" then
    if separator then
      return util.format.commas(value)
    end

    return tostring(util.format.round(value, decimals))
  end

  if mode == "engineering" then
    return util.format.engineering(value, decimals)
  end

  if mode == "short_scale" then
    return util.format.short_scale(value, decimals)
  end

  if mode == "short_scale_abv" then
    return util.format.short_scale_abv(value, decimals)
  end

  if mode == "scientific" then
    if value == 0 then
      return "0"
    end

    return string.format(
      "%." .. decimals .. "E",
      value
    )
  end

  error("Unknown formatting mode: " .. tostring(mode))

end

------------------------------------------------------------
-- Auto-Number Formatter
--
-- Logic for formatting numerics
-- EU < $Threshold -> Raw Number
-- EU > $Threshold -> Defined Preference
------------------------------------------------------------


------------------------------------------------------------
-- Percentage
------------------------------------------------------------

function util.format.percent(value, decimals)
  decimals = decimals or 2

  return string.format(
    "%." .. decimals .. "f%%",
    value
  )

end

------------------------------------------------------------
-- Rate - is this needed?
------------------------------------------------------------

function util.format.rate(value, unit, decimals)
  unit = unit or "EU/t"

  return util.format.engineering(value, decimals) .. "/" .. unit:match("^.-/(.*)$") or unit

end

------------------------------------------------------------
-- Time
------------------------------------------------------------

function util.format.time(seconds)
  if not seconds then
    return "Unknown"
  end

  if seconds == math.huge then
    return "∞"
  end

  if seconds < 0 then
    return "Unknown"
  end

  local days = math.floor(seconds / 86400)
  local hours = math.floor(seconds / 3600)
  local minutes = math.floor(seconds / 60)
  local ticks = math.floor(seconds * 20)

  if days > 0 then
    return string.format("%dd %dh", days, hours)
  end

  if hours > 0 then
    return string.format("%dh %dm", hours, minutes)
  end
  
  if minutes > 0 then
    return string.format("%dm %ds", minutes, seconds)
  end

  if seconds < 0 then
    return string.format("%dt", ticks)
  end

  return string.format("%ds", seconds)

end




------------------------------------------------------------
-- END OF UTIL
------------------------------------------------------------

return util
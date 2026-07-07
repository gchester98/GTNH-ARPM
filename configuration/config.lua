------------------------------------------------------------
-- config.lua
--
-- Augmented-Reality Power Manager (ARPM) Configuration
-- User-editable settings only
------------------------------------------------------------

local config = {}

------------------------------------------------------------------------------
-- Provider
------------------------------------------------------------------------------

config.provider = {
  type = "lsc",
  component = nil,
  address = nil,
  updateOnStartup = true
}


------------------------------------------------------------------------------
-- Data Refresh
------------------------------------------------------------------------------

config.update = {
  dataInterval = 1
}


------------------------------------------------------------------------------
-- History
------------------------------------------------------------------------------

config.history = {
  -- Length of history to retain (seconds)
  retention = 3600,
  sampleRate = 1,
  smoothing = 3,

  -- Rolling statistics capture rate (seconds)
  windows = {
    current = 5,
    short = 60,
    medium = 300,
    long = 3600
  }
}


------------------------------------------------------------------------------
-- Thresholds
------------------------------------------------------------------------------

config.thresholds = {
  battery = {
    warning = 20,
    critical = 10
  },

  flow = {
    idle = 1,
    low = 1000,
    high = 100000
  }
}


------------------------------------------------------------------------------
-- Formatting
------------------------------------------------------------------------------

config.format = {
  mode = util.format.MODE.AUTO,
  decimals = 2,
  separator = true,
  unit = "EU",
  perTick = true
}


------------------------------------------------------------------------------
-- Formatting Toggles
------------------------------------------------------------------------------

config.widgets = {

    title = {
        enabled = true,
        order = 10
    },

    battery = {
        enabled = true,
        showStored = true,
        showCapacity = true,
        showPercent = true,
        order = 20,
    },

    eta = {
        enabled = true,
        order = 30
    },

    flow = {
        enabled = true,
        order = 40
    },

    graph = {
        enabled = false,
        order = 50
    }

}


------------------------------------------------------------------------------
-- Themes & Color Overrides
------------------------------------------------------------------------------

config.theme = "gtnh"
config.profile = "compact"

config.colorOverrides = {
  -- Leave empty to use the theme defaults
}


------------------------------------------------------------------------------
-- HUD Positioning
------------------------------------------------------------------------------

-- Upper-Left Corner of HUD 
config.position = {
    anchor = "topLeft",
    x = 15,
    y = 15,
    z = 5
}


------------------------------------------------------------------------------
-- Layout || Enhancement - Allow drag / drop via OC Glasses
------------------------------------------------------------------------------

config.layout = {
  width = 240,
  lineHeight = 16,
  margin = 8,
  showBorder = true,
  showBackground = true,
  backgroundAlpha = 0.35
}


------------------------------------------------------------------------------
-- User Interface Scale
------------------------------------------------------------------------------

config.scale = {
  ui = 1.0,
  title = 1.5,
  text = 1.0,
  icons = 1.0
}


------------------------------------------------------------------------------
-- User Interface Animation
------------------------------------------------------------------------------

config.animation = {
    enabled = true,
    fps = 10,
    smooth = true,
    interpolate = true,
    easing = "linear"
}


------------------------------------------------------------------------------
-- EU Progress Bar
------------------------------------------------------------------------------

config.progressBar = {
  style = "segments",
  width = 220,
  height = 12,
  segments = 20,
  spacing = 1,
  rounded = false,
  showText = false,
  animate = true
}


------------------------------------------------------------------------------
-- Net EU Flow Bar
------------------------------------------------------------------------------

config.flowBar = {
  style = "packets",
  directionMode = "auto",
  packetWidth = 12,
  packetSpacing = 18,
  packetSpeed = 24,
  fadeLength = 4,
  pulse = true,
  bounce = false,
  animateWhenIdle = false
}


------------------------------------------------------------------------------
-- EU Graph
------------------------------------------------------------------------------

config.graph = {
  style = "",
  height = 64,
  samples = 300,
  autoscale = true,
  grid = true
} 


------------------------------------------------------------------------------
-- Debug Options
------------------------------------------------------------------------------

config.debug = {
  enabled = false,
  showFPS = false,
  showPollTime = false,
  showHistorySize = false
}


------------------------------------------------------------------------------
-- Feature Toggles
------------------------------------------------------------------------------


return config
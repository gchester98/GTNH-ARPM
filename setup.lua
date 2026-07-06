--- Import Libraries ---
local internet = require("internet")
local filesystem = require("filesystem")
local shell = require("shell")

--- Helper Functions ---
local function cmdMap(cmdArgs) -- Credit u/soundslogical
    cmdArgs = cmdArgs or _G.arg
    local result, map = {}, {}

    for idx, text in ipairs(cmdArgs) do
        if text:find("=") then
            local name, value = text:match("([^=]+)=(.+)")
            value = value:match("[%s'\"]*([^'\"]*)") or value
            map[name] = {idx = idx, value = value}
        else
            map[text] = {idx = idx, value = cmdArgs[idx + 1]}
        end
    end

    function result.empty()
        return cmdArgs[1] == nil
    end

    function result.find(arg, argAlt)
        return map[arg] or map[argAlt or -1]
    end

    function result.value(arg, argAlt)
        return (result.find(arg, argAlt) or {}).value
    end

    return result
end

local function split(fullString, separator)
  if separator == nil then
    separator = "%s"
  end

  local tokens = {}
  for str in string.gmatch(fullString, "([^" .. separator .. "]+)") do
    table.insert(tokens, str)
  end

  return tokens
end

--- Default Repository Information ---
local ghContent = "https://raw.githubusercontent.com"
local ghUser = "gchester98"
local ghRepo = "GTNH-ARPM"
local ghBranch = "main"

--- Argument Processing ---
local args = {...}
local argMap = cmdMap(args)

if argMap.find("--help", "-h") then
    print("---------------------------------------------------------")
    print("setup: setup [option] [value]")
    print("---------------------------------------------------------")
    print("Options:")
    print("-u (--user)                  Target GitHub User")
    print("-r (--repo | --repository)   Target GitHub Repository")
    print("-b (--branch)                Target GitHub Branch")
    print("-fp (--full-path)            Target GitHub Codebase")
    print("-d (--debug)                 Enable Debug Printout")
    print("---------------------------------------------------------")
    print("Example Usage:")
    print("setup -u gchester98 -r GTNH-ARPM -b main")
    print("setup --full-path=gchester98/GTNH-ARPM/main")

    print("\n\n")
    os.exit(0)
else
  if argMap.find("--full-path", "-fp") then
    local fullPath = argMap.value("--full-path", "-fp")
    local result = split(fullPath, "/")

    ghUser = result[1]
    ghRepo = result[2]
    ghBranch = result[3]
  else
    if argMap.find("--user", "-u") then
      ghUser = argMap.value("--user", "-u")
    end

    if argMap.find("--repo", "-r") then
      ghRepo = argMap.value("--repo", "-r")
    end

    if argMap.find("--branch", "-b") then
      ghBranch = argMap.value("--branch", "-b")
    end
  end
end


--- OpenComputer Installation ---
local ghBaseURL = string.format("%s/%s/%s/%s", ghContent, ghUser, ghRepo, ghBranch)
local destination = string.format("/home/%s", ghRepo)

if argMap.value("--debug", "-d") then
  print("--- DEBUG DATA ---")
  print(string.format("ghUser:    %s", ghUser))
  print(string.format("ghRepo:    %s", ghRepo))
  print(string.format("ghBranch:  %s", ghBranch))
  print(string.format("ghBaseURL: %s", ghBaseURL))
  print()
end

local syncFiles = {
  'README.md',
  'uninstall.lua',
  'configuration/config.lua',
  'lib/event_handling/events.lua',
  'lib/display/hud.lua',
  'lib/display/graphics/graphics.lua'
}

for _, filename in ipairs(syncFiles) do
  local dir = filename:match("(.+)/[^/]+$")
  if dir then
    filesystem.makeDirectory(string.format("%s/%s", destination, dir))
  end

  shell.execute(string.format("wget -f %s/%s %s/%s", ghBaseURL, filename, destination, filename))

end

print("\nGitHub file sync complete!")
--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

--// Modules
local dataManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Evan95461/Islands-Cheats-Menu/main/Modules/dataManager.lua"))()

--// Variables
local CONFIG_FILENAME = "config_data"
local client = Players.LocalPlayer
local waypointsFolder = Workspace:WaitForChild("Waypoints")
_G.configs = dataManager.loadData(CONFIG_FILENAME)[1] or loadstring(game:HttpGet("https://raw.githubusercontent.com/Evan95461/Islands-Cheats-Menu/main/Data/configTemplate.lua"))()

local buildConfigSection = function(islandsMenu, Flux)

    -- Create Section
    local configSection = islandsMenu.Tab("Settings", "rbxassetid://127970919293860")

    -- Config fast travel
    configSection.Label("Fast travel", 0)
    configSection.Line(0)

    -- Show/Hide waypoints
    local function updateWaypointsVisibility(toggled)
        for _, waypoint in waypointsFolder:GetChildren() do
            waypoint.waypointGUI.Enabled = toggled
        end
    end

    configSection.Toggle("◀️ 〃 Auto close menu", "Close the menu automatically when you choose a destination to teleport to", _G.configs["fastTravelConfig"].autoCloseMenu, 0, function(toggled)
        _G.configs["fastTravelConfig"].autoCloseMenu = toggled
    end)
    configSection.Toggle("📍 〃 Show waypoints", "Show the created waypoints on the HUD", _G.configs["fastTravelConfig"].showWaypoints, 0, function (toggled)
        _G.configs["fastTravelConfig"].showWaypoints = toggled
        updateWaypointsVisibility(toggled)
    end)
    updateWaypointsVisibility(_G.configs["fastTravelConfig"].showWaypoints)

    -- Events
    Players.PlayerRemoving:Connect(function(player)
        if player == client then
            dataManager.saveData(CONFIG_FILENAME, _G.configs, true)
        end
    end)

    waypointsFolder.ChildAdded:Connect(function(waypoint)
        waypoint:WaitForChild("waypointGUI").Enabled = _G.configs["fastTravelConfig"].showWaypoints
    end)
end

return buildConfigSection
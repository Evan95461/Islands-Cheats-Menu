--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

--// Modules
local teleportLocation = loadstring(game:HttpGet("https://raw.githubusercontent.com/Evan95461/Islands-Cheats-Menu/main/Data/teleportLocation.lua"))()
local dataManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Evan95461/Islands-Cheats-Menu/main/Modules/dataManager.lua"))()

--// Variables
local WAYPOINTS_FILENAME = "waypoints_data"
local MAX_WAYPOINTS = 25

local localPlayer = Players.LocalPlayer
local waypointsFolder = Workspace:FindFirstChild("Waypoints")
local islandTeleportButtons = {}
local createdWaypointsButtons = {}
local waypointTemplate = {
    name = "Untitled waypoint 1",
    desc = "There is no description for this waypoint.",
    rgbColor = {
        r = 255,
        g = 255,
        b = 255
    },
    position = {CFrame.new():GetComponents()}
}

-- Utils
function checkIfWaypointExist(targetName)
    local createdWaypoints = dataManager.loadData(WAYPOINTS_FILENAME)
    if createdWaypoints == nil then return false end
    for _, waypoint: typeof(waypointTemplate) in createdWaypoints do
        if waypoint.name == targetName then
            return true
        end
    end
    return false
end

function countWaypoints()
    local createdWaypoints = dataManager.loadData(WAYPOINTS_FILENAME)
    if createdWaypoints == nil then return 0 end
    local count = 0
    for _,_ in createdWaypoints do
        count += 1
    end
    return count
end

-- Build the fast travel section
local buildLocationSection = function(islandsMenu, Flux)

    -- Create section
    local locationSection = islandsMenu.Tab("Fast travel", "rbxassetid://80160769792985")

    -- Setup the default location
    locationSection.Label("Default Location", 0)
    locationSection.Line(0)

    -- Hub market teleport button
    locationSection.Button("🏘️ 〃 Hub (Market)", "Teleport to the Hub market", 0,function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.PrimaryPart.CFrame = teleportLocation.hubMarket
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the Hub market. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)

    -- Hub mine teleport button
    locationSection.Button("⛏️ 〃 Hub (Mine)", "Teleport to the Hub mine", 0, function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.PrimaryPart.CFrame = teleportLocation.hubMine
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the Hub mine. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)

    -- Slime island teleport button
    locationSection.Button("🟩 〃 Slime island", "Teleport to the Slime island", 0, function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.PrimaryPart.CFrame = teleportLocation.slimeIsland
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the Slime island. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)

    -- Setup the merchants location
    locationSection.Line(1)
    locationSection.Label("Merchants Location", 1)
    locationSection.Line(1)

    -- seeds/crops merchant teleport button
    locationSection.Button("🌱 🌾 〃 Seeds / Crops merchants", "Teleport to the seeds and crops merchants", 1, function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.PrimaryPart.CFrame = teleportLocation.cropsMerchant
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the seeds and crops merchants. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)

    -- blocks/banker merchant teleport button
    locationSection.Button("🏗️ 🏦 〃 Blocks / Banker merchants", "Teleport to the blocks and banker merchants", 1, function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.PrimaryPart.CFrame = teleportLocation.blockMerchant
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the blocks and banker merchants. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)

    -- totems merchant teleport button
    locationSection.Button("🔮 〃 Totems merchant", "Teleport to the totems merchant", 1, function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.PrimaryPart.CFrame = teleportLocation.totemsMerchant
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the totems merchant. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)

    -- adventurer merchant teleport button
    locationSection.Button("🤺 〃 Adventurer merchant", "Teleport to the adventurer merchant", 1, function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.PrimaryPart.CFrame = teleportLocation.adventurerMerchant
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the adventurer merchant. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)

    -- Setup player's island 
    locationSection.Line(2)
    locationSection.Label("Players' Island", 2)
    locationSection.Line(2)

    -- Create teleport buttons for the players' island
    local function setupIslandButton()
        
        -- Destroy all buttons (update)
        for _, button in islandTeleportButtons do
            button.Destroy()
        end

        -- Get all connected players 
        for _, player in Players:GetPlayers() do

            -- If player is the client then create button for his island
            if player.UserId == localPlayer.UserId then
                local home = locationSection.Button(`🏝️ 〃 My Island`, `Teleport to your Island`, 2, function ()        
                    local success, errorMessage = pcall(function()
                        local playerIsland = Workspace.Islands:WaitForChild(`{player.UserId}-island`)
                        localPlayer.Character.PrimaryPart.CFrame = playerIsland.PrimaryPart.CFrame
                    end)
            
                    if not success then
                        Flux.Notification(`An error occured ! Impossible to teleport you to your Island. Error: {errorMessage}. Please try again.`, "OK !")
                    end
                end)
                table.insert(islandTeleportButtons, home)
            else
                -- Create button for other players
                local button = locationSection.Button(`👤 〃 {player.Name}'s Island`, `Teleport to {player.Name}'s Island. The player must be on his island. It may takes several attempts in order to load the player's island`, 3, function ()        
                    local success, errorMessage = pcall(function()

                        -- Try load player island
                        local playerIsland = Workspace.Islands:WaitForChild(`{player.UserId}-island`)
                        if playerIsland.PrimaryPart == nil then
                            task.spawn(function()
                                local initialPosition = localPlayer.Character.PrimaryPart.CFrame
                                local targetPlayerCharacter = player.Character
                                if targetPlayerCharacter.PrimaryPart == nil then
                                    error("The target player has not charged", 6)
                                end
                                localPlayer.Character.PrimaryPart.CFrame = targetPlayerCharacter.PrimaryPart.CFrame
                                task.wait(0.25)
                                localPlayer.Character.PrimaryPart.CFrame = initialPosition
                            end)
                        end

                        if playerIsland.PrimaryPart == nil then
                            error("The island has not charged fast enough or the target player is not on his island", 6)
                        end
                        localPlayer.Character.PrimaryPart.CFrame = playerIsland.PrimaryPart.CFrame
                    end)
                    if not success then
                        Flux.Notification(`An error occured ! Impossible to teleport you to {player.Name}'s Island. Error: {errorMessage}. Please try again.`, "OK !")
                    end
                end)
                table.insert(islandTeleportButtons, button)
            end
        end
    end
    setupIslandButton()

    -- Setup the waypoints
    locationSection.Line(4)
    local waypointsCountLabel = locationSection.Label(`Custom location (Waypoints) {countWaypoints()}/{MAX_WAYPOINTS}`, 4)
    locationSection.Line(4)

    -- Create and update waypoints
    local noWaypointsMessage
    local function createWaypoint()

        -- Destroy all waypoints teleport buttons
        for _, waypointButton in createdWaypointsButtons do
            waypointButton.Destroy()
        end

        -- Destroy all waypoints teleport points
        for _, waypointPart in waypointsFolder:GetChildren() do
            waypointPart:Destroy()
        end

        local createdWaypoints = dataManager.loadData(WAYPOINTS_FILENAME)
        waypointsCountLabel.Set(`Custom location (Waypoints) {countWaypoints()}/{MAX_WAYPOINTS}`)
        if countWaypoints() == 0 then
            noWaypointsMessage = locationSection.Label("There are not created waypoints yet !", 4)
            return
        end
        noWaypointsMessage.Destroy()

        -- Create waypoint part, Gui and button
        for _, waypoint: typeof(waypointTemplate) in createdWaypoints do

            local part = Instance.new("Part")
            local billboard = Instance.new("BillboardGui")
            local textLabel = Instance.new("TextLabel")
            local distanceLabel = Instance.new("TextLabel")

            part.Name = waypoint.name
            part.Parent = waypointsFolder
            part.Anchored = true
            part.CFrame = CFrame.new(table.unpack(waypoint.position))
            part.CanCollide = false
            part.Transparency = 1

            billboard.Name = "waypointGUI"
            billboard.Parent = part
            billboard.Adornee = part
            billboard.AlwaysOnTop = true
            billboard.Size = UDim2.new(0, 200, 0, 100)

            textLabel.Name = "waypointName"
            textLabel.Parent = billboard
            textLabel.BackgroundTransparency = 1
            textLabel.TextSize = 20
            textLabel.TextColor3 = Color3.new(waypoint.rgbColor.r, waypoint.rgbColor.g, waypoint.rgbColor.b)
            textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            textLabel.Size = UDim2.new(0, 700, 0.7, 0)
            textLabel.Position = UDim2.new(0.5, 0, 0.3, 0)
            textLabel.Text = waypoint.name

            distanceLabel.Name = "waypointDistance"
            distanceLabel.Parent = billboard
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.TextScaled = true
            distanceLabel.TextColor3 = Color3.new(waypoint.rgbColor.r, waypoint.rgbColor.g, waypoint.rgbColor.b)
            distanceLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            distanceLabel.Size = UDim2.new(0.25, 0, 0.25, 0)
            distanceLabel.Position = UDim2.new(0.5, 0, 0.7, 0)

            task.spawn(function()
                local lastDistance
                while true do
                    local distance = math.round(localPlayer:DistanceFromCharacter(part.Position))
                    if distance ~= lastDistance then
                        distanceLabel.Text = `{tostring(distance)}m`
                        lastDistance = distance
                    end
                    task.wait(0.1)
                end
            end)

            local waypointButton = locationSection.Button(`{waypoint.name}`, `{waypoint.desc}`, 4, function()
                local success, errorMessage = pcall(function()
                    localPlayer.Character.PrimaryPart.CFrame = part.CFrame
                end)
        
                if not success then
                    Flux.Notification(`An error occured ! Impossible to teleport you to the waypoint: {waypoint.name}. Error: {errorMessage}. Please try again.`, "OK !")
                end
            end)
            table.insert(createdWaypointsButtons, waypointButton)
        end
    end
    createWaypoint()

    -- Setup the create waypoint
    locationSection.Line(5)
    locationSection.Label("Create a waypoint", 5)

    -- Choose a name for the waypoint
    locationSection.Textbox("🏷️ 〃 Waypoint name", "Give a name for your waypoint (3 min characters and 50 max characters)", false, 5, function (givenName)
        local success, errorMessage = pcall(function()
            if givenName == "" then
                givenName = `Untitled waypoint {countWaypoints() + 1}`
            end
            waypointTemplate.name = givenName
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to set the name for the waypoint. Error: {errorMessage}.`, "Alright !")
        end
    end)

    -- Choose a description for the waypoint
    locationSection.Textbox("📜 〃 Waypoint description", "Give a description for your waypoint (3 min characters and 125 max characters)", false, 5, function (givenDesc)
        local success, errorMessage = pcall(function()
            if givenDesc == "" then
                givenDesc = "There is no description for this waypoint."
            end
            waypointTemplate.desc = givenDesc
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to set the description for the waypoint. Error: {errorMessage}.`, "Alright !")
        end
    end)

    -- Choose a color for the waypoint
    locationSection.Colorpicker("🎨 〃 Waypoint color", Color3.fromRGB(255, 255, 255), 5, function (givenColor)
        local success, errorMessage = pcall(function()
            waypointTemplate.rgbColor.r = givenColor.R
            waypointTemplate.rgbColor.g = givenColor.G
            waypointTemplate.rgbColor.b = givenColor.B
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to set the color for the waypoint. Error: {errorMessage}.`, "Alright !")
        end
    end)

    -- Create a waypoint with the given informations (name, description, color)
    locationSection.Button("✨ 〃 Create waypoint", "Create the waypoint with the given informations. The rainbow color for your waypoint doesn't work yet", 5, function ()
        local success, errorMessage = pcall(function()
            waypointTemplate.position = {localPlayer.Character.PrimaryPart.CFrame:GetComponents()}
            if string.len(waypointTemplate.name) < 3 or string.len(waypointTemplate.name) > 50 then
                error("The waypoint name must be a minimum of 3 characters and a maximum of 50 characters long", 6)
            end
            if string.len(waypointTemplate.desc) < 3 or string.len(waypointTemplate.desc) > 125 then
                error("The waypoint description must be a minimum of 3 characters and a maximum of 125 characters long", 6)
            end
            if countWaypoints() >= MAX_WAYPOINTS then
                error(`Impossible to create an another waypoint ! You reach the limit of {MAX_WAYPOINTS} waypoints.`, 6)
            end
            if checkIfWaypointExist(waypointTemplate.name) then
                error(`There is already a waypoint with the provided name: {waypointTemplate.name} !`, 6)
            end
            dataManager.saveData(WAYPOINTS_FILENAME, waypointTemplate)
            createWaypoint()
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to create the waypoint. Error: {errorMessage} Please try again.`, "OK !")
        end
    end)

    -- Delete a waypoint with the given name
    locationSection.Textbox("🗑️ 〃 Delete waypoint", "Delete a waypoint with the given name", true, 5, function (givenName)
        local success, errorMessage = pcall(function()
            if checkIfWaypointExist(givenName) then
                dataManager.deleteData(WAYPOINTS_FILENAME, givenName)
                createWaypoint()
            else
                error("The given name doesn't match with your waypoint(s) !", 6)
            end
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to delete the waypoint. Error: {errorMessage} Please try again.`, "OK !")
        end
    end)

    -- Events
    Players.PlayerAdded:Connect(function()
        setupIslandButton()
    end)

    Players.PlayerRemoving:Connect(function()
        setupIslandButton()
    end)
end

return buildLocationSection
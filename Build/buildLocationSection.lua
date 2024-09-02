--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

--// Modules
local Flux = loadstring(game:HttpGet("https://raw.githubusercontent.com/Evan95461/Islands-Cheats-Menu/main/Modules/Flux-UI-Lib.lua"))()
local teleportLocation = loadstring(game:HttpGet("https://raw.githubusercontent.com/Evan95461/Islands-Cheats-Menu/main/Data/teleportLocation.lua"))()

--// Variables
local localPlayer = Players.LocalPlayer
local islandTeleportButtons = {}

-- Build the fast travel section
local buildLocationSection = function(islandsMenu)

    -- Create section
    local locationSection = islandsMenu.Tab("Fast travel", "rbxassetid://80160769792985")

    -- Setup the default location
    locationSection.Label("Default Location")
    locationSection.Line()

    -- Hub market teleport button
    locationSection.Button("🏘️ 〃 Hub (Market)", "Teleport to the Hub market", function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.PrimaryPart.CFrame = teleportLocation.hubMarket
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the Hub market. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)

    -- Hub mine teleport button
    locationSection.Button("⛏️ 〃 Hub (Mine)", "Teleport to the Hub mine", function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.PrimaryPart.CFrame = teleportLocation.hubMine
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the Hub mine. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)

    -- Slime island teleport button
    locationSection.Button("🟩 〃 Slime island", "Teleport to the Slime island", function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.PrimaryPart.CFrame = teleportLocation.slimeIsland
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the Slime island. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)

    -- Setup the merchants location
    locationSection.Line()
    locationSection.Label("Merchants Location")
    locationSection.Line()

    -- seeds/crops merchant teleport button
    locationSection.Button("🌱 🌾 〃 Seeds / Crops merchants", "Teleport to the seeds and crops merchants", function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.PrimaryPart.CFrame = teleportLocation.cropsMerchant
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the seeds and crops merchants. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)

    -- blocks/banker merchant teleport button
    locationSection.Button("🏗️ 🏦 〃 Blocks / Banker merchant", "Teleport to the blocks and banker merchants", function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.PrimaryPart.CFrame = teleportLocation.blockMerchant
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the blocks and banker merchants. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)

    -- totems merchant teleport button
    locationSection.Button("🔮 〃 Totems merchant", "Teleport to the totems merchant", function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.PrimaryPart.CFrame = teleportLocation.totemsMerchant
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the totems merchant. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)

    -- adventurer merchant teleport button
    locationSection.Button("🤺 〃 Adventurer merchant", "Teleport to the adventurer merchant", function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.PrimaryPart.CFrame = teleportLocation.adventurerMerchant
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the adventurer merchant. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)

    -- Setup player's island 
    locationSection.Line()
    locationSection.Label("Players' Island")
    locationSection.Line()

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
                local home = locationSection.Button(`🏝️ 〃 My Island`, `Teleport to your Island`, function ()        
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
                local button = locationSection.Button(`👤 〃 {player.Name}'s Island`, `Teleport to {player.Name}'s Island. The player must be on his island. If he is not, you will just be teleported to him.`, function ()        
                    local success, errorMessage = pcall(function()

                        -- Try load player island
                        local playerIsland = Workspace.Islands:WaitForChild(`{player.UserId}-island`)
                        if playerIsland.PrimaryPart == nil then
                            task.spawn(function()
                                local initialPosition = localPlayer.Character.PrimaryPart.CFrame
                                localPlayer.Character.PrimaryPart.CFrame = player.Character.PrimaryPart.CFrame
                                task.wait(0.25)
                                localPlayer.Character.PrimaryPart.CFrame = initialPosition
                            end)
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

    -- Events
    Players.PlayerAdded:Connect(function()
        setupIslandButton()
    end)

    Players.PlayerRemoving:Connect(function()
        setupIslandButton()
    end)
end

return buildLocationSection
--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

--// Modules
local Flux = loadstring(game:HttpGet("https://raw.githubusercontent.com/Evan95461/Islands-Cheats-Menu/main/Modules/Flux-UI-Lib.lua"))()
local teleportLocation = loadstring(game:HttpGet("https://raw.githubusercontent.com/Evan95461/Islands-Cheats-Menu/main/Data/teleportLocation.lua"))()

--// Variables
local localPlayer = Players.LocalPlayer

local buildLocationSection = function(islandsMenu)
    local locationSection = islandsMenu.Tab("Fast travel", "rbxassetid://80160769792985")
    locationSection.Label("Default Location")
    locationSection.Line()
    locationSection.Button("🏘️ 〃 Hub (Market)", "Teleport to the Hub market", function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.HumanoidRootPart.CFrame = teleportLocation.hubMarket
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the Hub market. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)
    locationSection.Button("⛏️ 〃 Hub (Mine)", "Teleport to the Hub mine", function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.HumanoidRootPart.CFrame = teleportLocation.hubMine
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the Hub mine. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)
    locationSection.Button("🟩 〃 Slime island", "Teleport to the Slime Island", function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.HumanoidRootPart.CFrame = teleportLocation.slimeIsland
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to the Slime island. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)
    locationSection.Line()
    locationSection.Label("Merchants Location")
    locationSection.Line()
    locationSection.Button("🌱 🌾 〃 Seeds / Crops merchant", "Teleport to the seeds and crops merchant", function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.HumanoidRootPart.CFrame = teleportLocation.cropsMerchant
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to seeds and crops merchant. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)
    locationSection.Button("🏗️ 🏦 〃 Blocks / Banker merchant", "Teleport to the blocks and banker merchant", function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.HumanoidRootPart.CFrame = teleportLocation.blockMerchant
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to blocks and banker merchant. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)
    locationSection.Button("🔮 〃 totems merchant", "Teleport to totems merchant", function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.HumanoidRootPart.CFrame = teleportLocation.totemsMerchant
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to totems merchant. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)
    locationSection.Button("🤺 〃 adventurer merchant", "Teleport to adventurer merchant", function()
        local success, errorMessage = pcall(function()
            localPlayer.Character.HumanoidRootPart.CFrame = teleportLocation.adventurerMerchant
        end)

        if not success then
            Flux.Notification(`An error occured ! Impossible to teleport you to adventurer merchant. Error: {errorMessage}. Please try again.`, "OK !")
        end
    end)
    locationSection.Line()
    locationSection.Label("Players' Island")
    locationSection.Line()

    local islandTeleportButtons = {}

    local function setupIslandButton()
        for _, button in islandTeleportButtons do
            button.Destroy()
        end
        for _, player in Players:GetPlayers() do
            if player.UserId == localPlayer.UserId then
                local home = locationSection.Button(`🏝️ 〃 My Island`, `Teleport to your Island`, function ()        
                    local success, errorMessage = pcall(function()
                        local playerIsland = Workspace.Islands:WaitForChild(`{localPlayer.UserId}-island`)
                        localPlayer.Character.PrimaryPart.CFrame = playerIsland.PrimaryPart.CFrame
                    end)
            
                    if not success then
                        Flux.Notification(`An error occured ! Impossible to teleport you to your Island. Error: {errorMessage}. Please try again.`, "OK !")
                    end
                end)
                table.insert(islandTeleportButtons, home)
            else
                local button = locationSection.Button(`👤 〃 {player.Name}'s Island`, `Teleport to {player.Name}'s Island. The player must be on his island. If he is not, you will just be teleported to him.`, function ()        
                    local success, errorMessage = pcall(function()
                        local playerCharacter = player.Character
                        if playerCharacter.PrimaryPart == nil then
                            error("Impossible to get the player's character")
                        end
                        localPlayer.Character.PrimaryPart.CFrame = player.Character.PrimaryPart.CFrame
                        task.wait(2)
                        local playerIsland = Workspace.Islands:WaitForChild(`{player.UserId}-island`)
                        if playerIsland.PrimaryPart == nil then
                            error("The island has not charged fast enough or the player is not on his island", 6)
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
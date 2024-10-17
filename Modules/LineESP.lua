local espObject = {}

--// Services
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

--// Modules
local mobsName = loadstring(game:HttpGet("https://raw.githubusercontent.com/Evan95461/Islands-Cheats-Menu/main/Data/mobsName.lua"))()

--// Variables
local client = Players.LocalPlayer
local camera = Workspace.CurrentCamera

function new(color, thickness, transparency, visible)
    
    local self = setmetatable(
        {
            tracer = Drawing.new("Line"),
            visible = visible,
            target = nil,
            color = color or Color3.fromRGB(255, 255, 255),
            thickness = thickness or 1,
            transparency = transparency or 1,
        },
        {
            __index = espObject
        }
    )

    return self

end

export type espObject = typeof(new(...))

function espObject.Create(self: espObject, chosenTarget: Instance)

    local Tracer = self.tracer
    self.target = chosenTarget

    local function lineesp()

        local hitbox = Instance.new("SelectionBox")
        hitbox.Adornee = self.target
        hitbox.Name = "hitbox"
        hitbox.Parent = self.target
        hitbox.Transparency = 0
        hitbox.SurfaceTransparency = 1
        hitbox.LineThickness = 0.1
        hitbox.Color3 = self.color

        local highlight = Instance.new("Highlight")
        highlight.Adornee = self.target
        highlight.Name = "highlight"
        highlight.Parent = self.target
        highlight.FillTransparency = 0.4
        highlight.FillColor = self.color
        highlight.OutlineTransparency = 1

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "waypointGUI"
        billboard.Parent = self.target
        billboard.Adornee = self.target
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 200, 0, 100)

        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "waypointName"
        textLabel.Parent = billboard
        textLabel.BackgroundTransparency = 1
        textLabel.TextSize = 20
        textLabel.TextColor3 = self.color
        textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        textLabel.Size = UDim2.new(0, 700, 0.7, 0)
        textLabel.Position = UDim2.new(0.5, 0, 0.3, 0)

        RunService.RenderStepped:Connect(function()
            if self.target ~= nil and typeof(self.target) == "Instance" and self.visible == true then

                Tracer.Color = self.color
                Tracer.Thickness = self.thickness
                Tracer.Transparency = self.transparency

                local targetVector, targetOnScreen
                local playerVector, playerOnScreen = camera:WorldToViewportPoint(client.Character.PrimaryPart.Position)

                if self.target.IsPlayer == false then
                    targetVector, targetOnScreen = camera:WorldToViewportPoint(self.target.HumanoidRootPart.Position)

                    local distance = math.round(client:DistanceFromCharacter(self.target.HumanoidRootPart.Position))
                    textLabel.Text = `💖 {self.target.CurrentHealth}/{self.target.MaxHealth} | ⚔️ {mobsName[self.target.Name]} | 📍 {distance}m`
                end

                if targetOnScreen and playerOnScreen then
                    Tracer.From = Vector2.new(playerVector.X, playerVector.Y)
                    Tracer.To = Vector2.new(targetVector.X, targetVector.Y)
                    Tracer.Visible = true
                    hitbox.Visible = true
                    billboard.Enabled = true
                    highlight.Enabled = true
                elseif not targetOnScreen or not playerOnScreen then
                    Tracer.Visible = false
                    hitbox.Visible = false
                    billboard.Enabled = false
                    highlight.Enabled = false
                end
            else
                Tracer.Visible = false
                hitbox.Visible = false
                billboard.Enabled = false
                highlight.Enabled = false
            end
        end)
    end
    coroutine.wrap(lineesp)()
end

function espObject.UpdateVisible(self: espObject, visible: boolean)
    self.visible = visible
end

function espObject.UpdateTarget(self: espObject, target: Instance)
    self.target = target
end

function espObject.UpdateColor(self: espObject, color: Color3)
    self.color = color
end

function espObject:DestroyESP()
    if self.target then
        self.target.hitbox:Destroy()
        self.target.highlight:Destroy()
    end
    self.tracer:Remove()
    table.clear(self)
    setmetatable(self, nil)
end

return {
    new = new,
}
local espObject = {}

--// Services
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

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

        RunService.RenderStepped:Connect(function()
            if self.target ~= nil and typeof(self.target) == "Instance" and self.visible == true then

                Tracer.Color = self.color
                Tracer.Thickness = self.thickness
                Tracer.Transparency = self.transparency

                local targetVector, targetOnScreen
                local playerVector, playerOnScreen = camera:WorldToViewportPoint(client.Character.PrimaryPart.Position)

                if self.target:FindFirstChild("Humanoid") and self.target:FindFirstChild("HumanoidRootPart") then
                    targetVector, targetOnScreen = camera:WorldToViewportPoint(self.target.HumanoidRootPart.Position)
                end

                if targetOnScreen and playerOnScreen then
                    Tracer.From = Vector2.new(playerVector.X, playerVector.Y)
                    Tracer.To = Vector2.new(targetVector.X, targetVector.Y)
                    Tracer.Visible = true
                    hitbox.Visible = true
                    highlight.Enabled = true
                elseif not targetOnScreen or not playerOnScreen then
                    Tracer.Visible = false
                    hitbox.Visible = false
                    highlight.Enabled = false
                end
            else
                Tracer.Visible = false
                hitbox.Visible = false
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
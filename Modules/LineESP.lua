local espObject = {}
espObject.__index = espObject

--// Services
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

--// Variables
local client = Players.LocalPlayer
local camera = Workspace.CurrentCamera

function new(color, thickness, transparency)

    local espAttributs = {
        tracer = Drawing.new("Line"),
        visible = false,
        target = nil,
        color = color or Color3.fromRGB(255, 255, 255),
        thickness = thickness or 1,
        transparency = transparency or 1,
    }
    setmetatable(espObject, espAttributs)

    return espAttributs

end

export type espObject = typeof(new(...))

function espObject.Create(self: espObject, chosenTarget: Instance)
    
    local Tracer = self.tracer
    self.target = chosenTarget

    local function lineesp()
        RunService.RenderStepped:Connect(function()
            if self.target ~= nil and typeof(self.target) == "Instance" then
                local targetVector, targetOnScreen
                local playerVector, playerOnScreen

                Tracer.Visible = self.visible
                Tracer.Color = self.color
                Tracer.Thickness = self.thickness
                Tracer.Transparency = self.transparency

                if self.target:FindFirstChild("Humanoid") and self.target:FindFirstChild("HumanoidRootPart") then
                    targetVector, targetOnScreen = camera:WorldToViewportPoint(self.target.HumanoidRootPart.Position)
                    playerVector, playerOnScreen = camera:WorldToViewportPoint(client.Character.PrimaryPart.Position)
                end

                if targetOnScreen and playerOnScreen then
                    Tracer.From = Vector2.new(playerVector.X, playerVector.Y)
                    Tracer.To = Vector2.new(targetVector.X, targetVector.Y)
                    self.Visible = true
                elseif not targetOnScreen or not playerOnScreen then
                    self.Visible = false
                end
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

return {
    new = new,
}
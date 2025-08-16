-- DeltaModMenu Server Edition
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- FOLDER PER CLONI
local ClonesFolder = ReplicatedStorage:FindFirstChild("Clones") or Instance.new("Folder", ReplicatedStorage)
ClonesFolder.Name = "Clones"

-- FUNZIONE RIPARA HUMANOID
RunService.Heartbeat:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            local hum = plr.Character.Humanoid
            if hum.Health == 0 then
                hum.Health = 100
            end
        end
    end
end)

-- FUNZIONE BRING PLAYER
function BringPlayer(targetName, destinationPlayer)
    local target = Players:FindFirstChild(targetName)
    if target and target.Character and destinationPlayer.Character and destinationPlayer.Character:FindFirstChild("HumanoidRootPart") then
        target.Character:SetPrimaryPartCFrame(destinationPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,5))
    end
end

-- FUNZIONE CLONA PLAYER
function ClonePlayer(targetName)
    local target = Players:FindFirstChild(targetName)
    if target and target.Character then
        local clone = target.Character:Clone()
        clone.Parent = ClonesFolder
        clone:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame + Vector3.new(5,0,0))
    end
end

-- FUNZIONE INSEGUI CLONE
function FollowPlayer(clone, player)
    RunService.Heartbeat:Connect(function()
        if clone.PrimaryPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            clone:SetPrimaryPartCFrame(CFrame.new(clone.PrimaryPart.Position, player.Character.HumanoidRootPart.Position))
            clone.PrimaryPart.CFrame = clone.PrimaryPart.CFrame + (player.Character.HumanoidRootPart.Position - clone.PrimaryPart.Position).Unit * 0.5
        end
    end)
end

-- FUNZIONE TRAIL
function AddTrail(player)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local trail = Instance.new("Trail")
        trail.Attachment0 = Instance.new("Attachment", hrp)
        trail.Attachment1 = Instance.new("Attachment", hrp)
        trail.Lifetime = 1
        trail.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
        trail.Parent = hrp
    end
end

-- FUNZIONE ESPLODI TUTTI
function ExplodeAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local explode = Instance.new("Explosion")
            explode.Position = plr.Character.HumanoidRootPart.Position
            explode.BlastRadius = 10
            explode.BlastPressure = 500000
            explode.Parent = workspace
        end
    end
end

-- Esempi di uso:
-- BringPlayer("NomeTarget", Players.LocalPlayer)
-- ClonePlayer("NomeTarget")
-- FollowPlayer(ClonesFolder.CloneName, Players.LocalPlayer)
-- AddTrail(Players.LocalPlayer)
-- ExplodeAll()

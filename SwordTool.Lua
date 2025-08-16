-- SwordTool.lua
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Controllo se il personaggio esiste
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Crea il Tool
local sword = Instance.new("Tool")
sword.Name = "DeltaSword"
sword.RequiresHandle = true
sword.CanBeDropped = true

-- Crea l'Handle
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1,4,1)
handle.Color = Color3.fromRGB(255,0,0)
handle.Material = Enum.Material.Neon
handle.Anchored = false
handle.CanCollide = false
handle.Parent = sword

sword.Parent = LocalPlayer.Backpack

-- Danno della spada
local damage = 25

handle.Touched:Connect(function(hit)
    local hum = hit.Parent:FindFirstChildOfClass("Humanoid")
    if hum and hit.Parent ~= char then
        hum:TakeDamage(damage)
        print("Hit! Danno:", damage)
    end
end)

print("DeltaSword aggiunta al backpack!")

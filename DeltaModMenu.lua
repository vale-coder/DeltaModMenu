-- Delta Mod Menu Completo (Client + Server Ready)
-- =========================
-- Servizi
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Folder per cloni
local ClonesFolder = ReplicatedStorage:FindFirstChild("Clones") or Instance.new("Folder", ReplicatedStorage)
ClonesFolder.Name = "Clones"

-- =========================
-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DeltaModMenu"

-- Bottone ☰
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0,50,0,50)
OpenBtn.AnchorPoint = Vector2.new(1,1)
OpenBtn.Position = UDim2.new(1,-10,1,-10)
OpenBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
OpenBtn.Text = "☰"
OpenBtn.TextColor3 = Color3.fromRGB(255,255,255)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 28

-- Menu Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,300,0,300)
Frame.Position = UDim2.new(0.3,0,0.3,0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true
Frame.Visible = false

-- Titolo
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundColor3 = Color3.fromRGB(50,50,50)
Title.Text = "Delta Mod Menu"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- X con conferma
local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-35,0,5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 18

local ConfirmFrame = Instance.new("Frame", ScreenGui)
ConfirmFrame.Size = UDim2.new(0,200,0,100)
ConfirmFrame.Position = UDim2.new(0.5,-100,0.5,-50)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
ConfirmFrame.Visible = false

local ConfirmText = Instance.new("TextLabel", ConfirmFrame)
ConfirmText.Size = UDim2.new(1,0,0,40)
ConfirmText.BackgroundColor3 = Color3.fromRGB(60,60,60)
ConfirmText.Text = "Chiudere lo script?"
ConfirmText.TextColor3 = Color3.fromRGB(255,255,255)
ConfirmText.Font = Enum.Font.SourceSansBold
ConfirmText.TextSize = 18

local YesBtn = Instance.new("TextButton", ConfirmFrame)
YesBtn.Size = UDim2.new(0.5,-5,0,40)
YesBtn.Position = UDim2.new(0,5,0,50)
YesBtn.BackgroundColor3 = Color3.fromRGB(100,30,30)
YesBtn.Text = "Sì"
YesBtn.TextColor3 = Color3.fromRGB(255,255,255)
YesBtn.Font = Enum.Font.SourceSansBold
YesBtn.TextSize = 18

local NoBtn = Instance.new("TextButton", ConfirmFrame)
NoBtn.Size = UDim2.new(0.5,-5,0,40)
NoBtn.Position = UDim2.new(0.5,0,0,50)
NoBtn.BackgroundColor3 = Color3.fromRGB(30,100,30)
NoBtn.Text = "No"
NoBtn.TextColor3 = Color3.fromRGB(255,255,255)
NoBtn.Font = Enum.Font.SourceSansBold
NoBtn.TextSize = 18

-- Eventi X
CloseBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = true
end)
YesBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
NoBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = false
end)

-- Funzione per creare bottoni
local function makeButton(name, posY, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1,-20,0,30)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.MouseButton1Click:Connect(callback)
end

-- =========================
-- Fly
local flying = false
local speed = 70
local bv, bg

local function startFly()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Velocity = Vector3.new(0,0,0)

    bg = Instance.new("BodyGyro", hrp)
    bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bg.CFrame = hrp.CFrame

    flying = true
    RunService.RenderStepped:Connect(function()
        if flying and hrp then
            local camCF = workspace.CurrentCamera.CFrame
            local move = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + camCF.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - camCF.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - camCF.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + camCF.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
            bv.Velocity = move * speed
            bg.CFrame = camCF
        end
    end)
end

local function stopFly()
    flying = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

makeButton("Toggle Fly", 50, function()
    if flying then stopFly() else startFly() end
end)

-- =========================
-- Bring Player
makeButton("Bring Player", 90, function()
    local target = Players:GetPlayers()[2] -- esempio: prende secondo giocatore
    if target and target.Character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        target.Character:SetPrimaryPartCFrame(LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,5))
    end
end)

-- Ripara Humanoid
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

-- Clone player
makeButton("Clone Player", 130, function()
    local target = Players:GetPlayers()[2] -- esempio secondo player
    if target and target.Character then
        local clone = target.Character:Clone()
        clone.Parent = ClonesFolder
        clone:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame + Vector3.new(5,0,0))
    end
end)

-- Trail
makeButton("Add Trail", 170, function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local trail = Instance.new("Trail", hrp)
        local att0 = Instance.new("Attachment", hrp)
        local att1 = Instance.new("Attachment", hrp)
        trail.Attachment0 = att0
        trail.Attachment1 = att1
        trail.Lifetime = 1
        trail.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
    end
end)

-- Explode All
makeButton("Explode All", 210, function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local explode = Instance.new("Explosion")
            explode.Position = plr.Character.HumanoidRootPart.Position
            explode.BlastRadius = 10
            explode.BlastPressure = 500000
            explode.Parent = workspace
        end
    end
end)

-- =========================
-- Apertura menu con ☰ e M
OpenBtn.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        Frame.Visible = not Frame.Visible
    end
end)

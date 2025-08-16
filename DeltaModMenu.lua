--[[ Delta Mod Menu Completo
     Fly, WalkSpeed, Trail server-side, Linked Sword con script, Conferma chiusura
     Menu trascinabile e toggle 3 linee
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Crea RemoteEvent per il trail (server-side)
local createTrailEvent = ReplicatedStorage:FindFirstChild("CreateTrail")
if not createTrailEvent then
    createTrailEvent = Instance.new("RemoteEvent")
    createTrailEvent.Name = "CreateTrail"
    createTrailEvent.Parent = ReplicatedStorage
end

-- Server-side handler per la trail
if not RunService:IsClient() then
    createTrailEvent.OnServerEvent:Connect(function(player)
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- Rimuove trail precedente
        for _, c in pairs(hrp:GetChildren()) do
            if c:IsA("Trail") or c:IsA("Attachment") then c:Destroy() end
        end

        local attach0 = Instance.new("Attachment", hrp)
        attach0.Position = Vector3.new(0,0,0)
        local attach1 = Instance.new("Attachment", hrp)
        attach1.Position = Vector3.new(0,2,0)

        local trail = Instance.new("Trail")
        trail.Attachment0 = attach0
        trail.Attachment1 = attach1
        trail.Lifetime = 0.5
        trail.Color = ColorSequence.new(Color3.fromRGB(255,0,0), Color3.fromRGB(255,255,0))
        trail.Transparency = NumberSequence.new(0,1)
        trail.MinLength = 0.2
        trail.Parent = hrp
    end)
end

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DeltaModMenu"

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0,40,0,40)
OpenBtn.Position = UDim2.new(1,-50,1,-50)
OpenBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
OpenBtn.Text = "☰"
OpenBtn.TextColor3 = Color3.fromRGB(255,255,255)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 28

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,200,0,330)
Frame.Position = UDim2.new(0.5,-100,0.5,-165)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true
Frame.Visible = false

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundColor3 = Color3.fromRGB(50,50,50)
Title.Text = "Delta Mod Menu"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-35,0,5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 18

-- Fly
local flying = false
local flySpeed = 70
local bv, bg, flyConnection

local FlyBtn = Instance.new("TextButton", Frame)
FlyBtn.Size = UDim2.new(1,-20,0,30)
FlyBtn.Position = UDim2.new(0,10,0,40)
FlyBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
FlyBtn.Text = "Fly"
FlyBtn.TextColor3 = Color3.fromRGB(255,255,255)
FlyBtn.Font = Enum.Font.SourceSans
FlyBtn.TextSize = 18

local function startFly()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Velocity = Vector3.new(0,0,0)
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    flying = true

    flyConnection = RunService.RenderStepped:Connect(function()
        if flying and hrp then
            local camCF = workspace.CurrentCamera.CFrame
            local move = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + camCF.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - camCF.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - camCF.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + camCF.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
            bv.Velocity = move * flySpeed
            bg.CFrame = camCF
        end
    end)
end

local function stopFly()
    flying = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    if flyConnection then flyConnection:Disconnect() end
end

FlyBtn.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

-- WalkSpeed
local SpeedBtn = Instance.new("TextButton", Frame)
SpeedBtn.Size = UDim2.new(1,-20,0,30)
SpeedBtn.Position = UDim2.new(0,10,0,80)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
SpeedBtn.Text = "Set WalkSpeed"
SpeedBtn.TextColor3 = Color3.fromRGB(255,255,255)
SpeedBtn.Font = Enum.Font.SourceSans
SpeedBtn.TextSize = 18

local SpeedBox = Instance.new("TextBox", Frame)
SpeedBox.Size = UDim2.new(1,-20,0,30)
SpeedBox.Position = UDim2.new(0,10,0,115)
SpeedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
SpeedBox.TextColor3 = Color3.fromRGB(255,255,255)
SpeedBox.Font = Enum.Font.SourceSans
SpeedBox.PlaceholderText = "Inserisci WalkSpeed"
SpeedBox.ClearTextOnFocus = false
SpeedBox.Visible = false

SpeedBtn.MouseButton1Click:Connect(function()
    SpeedBox.Visible = not SpeedBox.Visible
end)

SpeedBox.FocusLost:Connect(function(enter)
    if enter then
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local val = tonumber(SpeedBox.Text)
        if humanoid and val then
            humanoid.WalkSpeed = val
            print("WalkSpeed impostata a:", val)
        else
            warn("Valore WalkSpeed non valido o humanoid non trovato")
        end
        SpeedBox.Visible = false
    end
end)

-- Trail toggle
local TrailBtn = Instance.new("TextButton", Frame)
TrailBtn.Size = UDim2.new(1,-20,0,30)
TrailBtn.Position = UDim2.new(0,10,0,150)
TrailBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
TrailBtn.Text = "Toggle Trail"
TrailBtn.TextColor3 = Color3.fromRGB(255,255,255)
TrailBtn.Font = Enum.Font.SourceSans
TrailBtn.TextSize = 18

TrailBtn.MouseButton1Click:Connect(function()
    createTrailEvent:FireServer()
end)

-- Linked Sword toggle con script interno funzionante
local swordGiven = false
local SwordBtn = Instance.new("TextButton", Frame)
SwordBtn.Size = UDim2.new(1,-20,0,30)
SwordBtn.Position = UDim2.new(0,10,0,190)
SwordBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
SwordBtn.Text = "Toggle Linked Sword"
SwordBtn.TextColor3 = Color3.fromRGB(255,255,255)
SwordBtn.Font = Enum.Font.SourceSans
SwordBtn.TextSize = 18

SwordBtn.MouseButton1Click:Connect(function()
    if swordGiven then
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == "Linked Sword" then
                tool:Destroy()
            end
        end
        swordGiven = false
        print("Linked Sword rimossa!")
    else
        local swords = game:GetObjects("rbxassetid://125013769") -- ID spada completa con script
        for _, sword in pairs(swords) do
            if sword:IsA("Tool") then
                sword.Parent = LocalPlayer.Backpack
                swordGiven = true
                print("Linked Sword aggiunta con script funzionante!")
            end
        end
    end
end)

-- Conferma chiusura
CloseBtn.MouseButton1Click:Connect(function()
    local confirmFrame = Instance.new("Frame", ScreenGui)
    confirmFrame.Size = UDim2.new(0,220,0,120)
    confirmFrame.Position = UDim2.new(0.5,-110,0.5,-60)
    confirmFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)

    local confirmTitle = Instance.new("TextLabel", confirmFrame)
    confirmTitle.Size = UDim2.new(1,0,0,40)
    confirmTitle.BackgroundColor3 = Color3.fromRGB(70,70,70)
    confirmTitle.Text = "Conferma Chiusura"
    confirmTitle.TextColor3 = Color3.fromRGB(255,255,255)
    confirmTitle.Font = Enum.Font.SourceSansBold
    confirmTitle.TextSize = 20

    local YesBtn = Instance.new("TextButton", confirmFrame)
    YesBtn.Size = UDim2.new(0,80,0,40)
    YesBtn.Position = UDim2.new(0.1,0,0.6,0)
    YesBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
    YesBtn.Text = "Si"
    YesBtn.TextColor3 = Color3.fromRGB(255,255,255)
    YesBtn.Font = Enum.Font.SourceSansBold
    YesBtn.TextSize = 18
    YesBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local NoBtn = Instance.new("TextButton", confirmFrame)
    NoBtn.Size = UDim2.new(0,80,0,40)
    NoBtn.Position = UDim2.new(0.55,0,0.6,0)
    NoBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
    NoBtn.Text = "No"
    NoBtn.TextColor3 = Color3.fromRGB(255,255,255)
    NoBtn.Font = Enum.Font.SourceSansBold
    NoBtn.TextSize = 18
    NoBtn.MouseButton1Click:Connect(function()
        confirmFrame:Destroy()
    end)
end)

-- Toggle frame con 3 linee
OpenBtn.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

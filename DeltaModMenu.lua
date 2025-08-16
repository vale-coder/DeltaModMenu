-- Delta Mod Menu Fly + WalkSpeed + Confirm Close completo
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI principale
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DeltaModMenuFull"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,300,0,200) -- grande quanto un mod menu normale
Frame.Position = UDim2.new(0.5,-150,0.5,-100)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundColor3 = Color3.fromRGB(50,50,50)
Title.Text = "Delta Mod Menu"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22

-- Bottone Chiudi
local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0,40,0,40)
CloseBtn.Position = UDim2.new(1,-50,0,0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20

-- Fly
local flying = false
local flySpeed = 70
local bv, bg, flyConnection

local FlyBtn = Instance.new("TextButton", Frame)
FlyBtn.Size = UDim2.new(1,-40,0,40)
FlyBtn.Position = UDim2.new(0,20,0,60)
FlyBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
FlyBtn.Text = "Fly"
FlyBtn.TextColor3 = Color3.fromRGB(255,255,255)
FlyBtn.Font = Enum.Font.SourceSans
FlyBtn.TextSize = 20

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
    if flying then
        stopFly()
    else
        startFly()
    end
end)

-- WalkSpeed
local defaultSpeed = 16
local SpeedBtn = Instance.new("TextButton", Frame)
SpeedBtn.Size = UDim2.new(1,-40,0,40)
SpeedBtn.Position = UDim2.new(0,20,0,120)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
SpeedBtn.Text = "WalkSpeed +20"
SpeedBtn.TextColor3 = Color3.fromRGB(255,255,255)
SpeedBtn.Font = Enum.Font.SourceSans
SpeedBtn.TextSize = 20

SpeedBtn.MouseButton1Click:Connect(function()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = defaultSpeed + 20
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

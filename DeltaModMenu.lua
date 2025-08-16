-- Delta Mod Menu semplice: Fly + WalkSpeed
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DeltaModSimpleMenu"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,180,0,120)
Frame.Position = UDim2.new(1,-200,1,-150)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundColor3 = Color3.fromRGB(50,50,50)
Title.Text = "Delta Menu"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- ======================
-- Fly button
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
    if flying then
        stopFly()
    else
        startFly()
    end
end)

-- ======================
-- WalkSpeed button
local defaultSpeed = 16
local SpeedBtn = Instance.new("TextButton", Frame)
SpeedBtn.Size = UDim2.new(1,-20,0,30)
SpeedBtn.Position = UDim2.new(0,10,0,80)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
SpeedBtn.Text = "WalkSpeed +20"
SpeedBtn.TextColor3 = Color3.fromRGB(255,255,255)
SpeedBtn.Font = Enum.Font.SourceSans
SpeedBtn.TextSize = 18

SpeedBtn.MouseButton1Click:Connect(function()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 36 -- default 16 + 20
    end
end)

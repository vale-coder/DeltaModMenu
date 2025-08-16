-- Delta Mod Menu Fly + WalkSpeed Toggle (LocalScript)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DeltaModFlyMenu"

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0,50,0,50)
OpenBtn.AnchorPoint = Vector2.new(1,1)
OpenBtn.Position = UDim2.new(1,-10,1,-10)
OpenBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
OpenBtn.Text = "☰"
OpenBtn.TextColor3 = Color3.fromRGB(255,255,255)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 28

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,200,0,160)
Frame.Position = UDim2.new(0.5,-100,0.5,-80)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true
Frame.Visible = false

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundColor3 = Color3.fromRGB(50,50,50)
Title.Text = "Delta Fly Menu"
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
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

OpenBtn.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        Frame.Visible = not Frame.Visible
    end
end)

-- ======================
-- Fly toggle (solo Fly)
local flying = false
local flySpeed = 70
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
            bv.Velocity = move * flySpeed
            bg.CFrame = camCF
        end
    end)
end

local function stopFly()
    flying = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

local FlyBtn = Instance.new("TextButton", Frame)
FlyBtn.Size = UDim2.new(1,-20,0,30)
FlyBtn.Position = UDim2.new(0,10,0,40)
FlyBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
FlyBtn.Text = "Toggle Fly"
FlyBtn.TextColor3 = Color3.fromRGB(255,255,255)
FlyBtn.Font = Enum.Font.SourceSans
FlyBtn.TextSize = 18
FlyBtn.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

-- ======================
-- WalkSpeed button + TextBox (solo camminata)
local defaultSpeed = 16
local speedStep = 1 -- 1 = mostra textbox, 2 = velocità normale, 3 = mostra textbox di nuovo
local SpeedBtn = Instance.new("TextButton", Frame)
SpeedBtn.Size = UDim2.new(1,-20,0,30)
SpeedBtn.Position = UDim2.new(0,10,0,80)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
SpeedBtn.Text = "Speed"
SpeedBtn.TextColor3 = Color3.fromRGB(255,255,255)
SpeedBtn.Font = Enum.Font.SourceSans
SpeedBtn.TextSize = 18

local SpeedBox = Instance.new("TextBox", Frame)
SpeedBox.Size = UDim2.new(1,-40,0,30)
SpeedBox.Position = UDim2.new(0,10,0,120)
SpeedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
SpeedBox.TextColor3 = Color3.fromRGB(255,255,255)
SpeedBox.Font = Enum.Font.SourceSans
SpeedBox.TextSize = 18
SpeedBox.PlaceholderText = "Scrivi WalkSpeed e premi Invio"
SpeedBox.Visible = false

SpeedBtn.MouseButton1Click:Connect(function()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if speedStep == 1 or speedStep == 3 then
        SpeedBox.Visible = true
        SpeedBox.Text = tostring(humanoid.WalkSpeed)
    elseif speedStep == 2 then
        humanoid.WalkSpeed = defaultSpeed
        SpeedBox.Visible = false
    end
    speedStep = speedStep % 3 + 1
end)

SpeedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local newSpeed = tonumber(SpeedBox.Text)
            if newSpeed then
                humanoid.WalkSpeed = newSpeed
            end
        end
        SpeedBox.Visible = false
    end
end)

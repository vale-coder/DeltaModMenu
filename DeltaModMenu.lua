-- LocalScript per Delta Mod Menu completo
-- Tutto in uno, Fly migliorato + menu con apertura ☰ e conferma X

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Crea ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaModMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Pulsante apri/chiudi menu (☰) in basso a destra
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0,50,0,50)
OpenBtn.AnchorPoint = Vector2.new(1,1)
OpenBtn.Position = UDim2.new(1,-10,1,-10)
OpenBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
OpenBtn.Text = "☰"
OpenBtn.TextColor3 = Color3.fromRGB(255,255,255)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 28
OpenBtn.Parent = ScreenGui

-- Crea Frame principale del menu
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true
Frame.Visible = false
Frame.Parent = ScreenGui

-- Titolo menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundColor3 = Color3.fromRGB(50,50,50)
Title.Text = "Delta Mod Menu"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = Frame

-- Bottone X per chiusura con conferma
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,30,0,30)
CloseBtn.Position = UDim2.new(1,-35,0,5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 18
CloseBtn.Parent = Frame

-- Finestra conferma chiusura
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(0,200,0,100)
ConfirmFrame.Position = UDim2.new(0.5,-100,0.5,-50)
ConfirmFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
ConfirmFrame.Visible = false
ConfirmFrame.Parent = ScreenGui

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1,0,0,40)
ConfirmText.BackgroundColor3 = Color3.fromRGB(60,60,60)
ConfirmText.Text = "Chiudere lo script?"
ConfirmText.TextColor3 = Color3.fromRGB(255,255,255)
ConfirmText.Font = Enum.Font.SourceSansBold
ConfirmText.TextSize = 18
ConfirmText.Parent = ConfirmFrame

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0.5,-5,0,40)
YesBtn.Position = UDim2.new(0,5,0,50)
YesBtn.BackgroundColor3 = Color3.fromRGB(100,30,30)
YesBtn.Text = "Sì"
YesBtn.TextColor3 = Color3.fromRGB(255,255,255)
YesBtn.Font = Enum.Font.SourceSansBold
YesBtn.TextSize = 18
YesBtn.Parent = ConfirmFrame

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0.5,-5,0,40)
NoBtn.Position = UDim2.new(0.5,0,0,50)
NoBtn.BackgroundColor3 = Color3.fromRGB(30,100,30)
NoBtn.Text = "No"
NoBtn.TextColor3 = Color3.fromRGB(255,255,255)
NoBtn.Font = Enum.Font.SourceSansBold
NoBtn.TextSize = 18
NoBtn.Parent = ConfirmFrame

-- Eventi X e conferma
CloseBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = true
end)
YesBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
NoBtn.MouseButton1Click:Connect(function()
    ConfirmFrame.Visible = false
end)

-- Funzione per creare bottoni nel menu
local function makeButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,30)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.Parent = Frame
    btn.MouseButton1Click:Connect(callback)
end

-- Fly system migliorato
local flying = false
local speed = 70
local bv, bg

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

-- Bottone Fly
makeButton("Toggle Fly", 50, function()
    if flying then stopFly() else startFly() end
end)

-- Apertura menu con ☰ e M
OpenBtn.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        Frame.Visible = not Frame.Visible
    end
end)

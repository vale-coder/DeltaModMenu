-- Delta Mod Menu - Workspace Edition (GUI Solo)
local UIS = game:GetService("UserInputService")

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "DeltaModMenu"

-- Bottone ☰ in basso a destra
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
Frame.Size = UDim2.new(0,200,0,100)
Frame.Position = UDim2.new(0.5,-100,0.5,-50)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true
Frame.Visible = false

-- Titolo
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundColor3 = Color3.fromRGB(50,50,50)
Title.Text = "Delta Menu"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- Bottone X con conferma
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

-- Apertura menu con ☰ e M
OpenBtn.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        Frame.Visible = not Frame.Visible
    end
end)

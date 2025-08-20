-- Delta Admin Panel definitivo con colori random, WalkSpeed e Goto Player dinamico
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local flying = false
local flySpeed = 70
local bv, bg, flyConnection

-- Funzione colore random
local function randomColor()
	return Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255))
end

-- Genera tre colori diversi
local flyColor, speedColor, gotoColor
flyColor = randomColor()
repeat speedColor = randomColor() until speedColor ~= flyColor
repeat gotoColor = randomColor() until gotoColor ~= flyColor and gotoColor ~= speedColor

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaAdminWindow"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 240) -- altezza aumentata per textbox
frame.Position = UDim2.new(0, 0, 0, 230)
frame.BackgroundColor3 = Color3.fromRGB(0,170,0)
frame.Active = true
frame.Visible = false
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,15)
corner.Parent = frame

-- Barra titolo
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,30)
titleBar.BackgroundColor3 = Color3.fromRGB(0,120,0)
titleBar.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "Admin Panel"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-30,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- Fly button con colore random
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.8,0,0,40)
flyBtn.Position = UDim2.new(0.1,0,0,50)
flyBtn.BackgroundColor3 = flyColor
flyBtn.TextColor3 = Color3.fromRGB(255,255,255)
flyBtn.Font = Enum.Font.SourceSansBold
flyBtn.TextSize = 20
flyBtn.Text = "Toggle Fly"
flyBtn.Parent = frame

-- WalkSpeed Button con colore random diverso
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(0.8,0,0,40)
speedBtn.Position = UDim2.new(0.1,0,0,100)
speedBtn.BackgroundColor3 = speedColor
speedBtn.TextColor3 = Color3.fromRGB(255,255,255)
speedBtn.Font = Enum.Font.SourceSansBold
speedBtn.TextSize = 20
speedBtn.Text = "Set WalkSpeed"
speedBtn.Parent = frame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.8,0,0,30)
speedBox.Position = UDim2.new(0.1,0,0,145)
speedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
speedBox.TextColor3 = Color3.fromRGB(255,255,255)
speedBox.Font = Enum.Font.SourceSans
speedBox.PlaceholderText = "Inserisci WalkSpeed"
speedBox.ClearTextOnFocus = false
speedBox.Visible = false
speedBox.Parent = frame

speedBtn.MouseButton1Click:Connect(function()
	speedBox.Visible = not speedBox.Visible
end)

speedBox.FocusLost:Connect(function(enter)
	if enter then
		local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		local val = tonumber(speedBox.Text)
		if humanoid and val then
			humanoid.WalkSpeed = val
			print("[Debug] WalkSpeed impostata a:", val)
		else
			warn("[Debug] Valore WalkSpeed non valido o humanoid non trovato")
		end
		speedBox.Visible = false
	end
end)

-- Funzioni Fly
local function startFly()
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

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
		if not flying then return end
		local camCF = workspace.CurrentCamera.CFrame
		local move = Vector3.new()
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + camCF.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - camCF.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - camCF.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + camCF.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
		bv.Velocity = move.Magnitude > 0 and move.Unit * flySpeed or Vector3.new(0,0,0)
		bg.CFrame = camCF
	end)
	print("[Debug] Fly attivato!")
end

local function stopFly()
	flying = false
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
	if flyConnection then flyConnection:Disconnect() end
	print("[Debug] Fly disattivato!")
end

flyBtn.MouseButton1Click:Connect(function()
	if flying then stopFly() else startFly() end
end)

-- Goto Player dinamico
local gotoBox = Instance.new("TextBox")
gotoBox.Size = UDim2.new(0.8,0,0,30)
gotoBox.Position = UDim2.new(0.1,0,0,190)
gotoBox.BackgroundColor3 = Color3.fromRGB(80,80,255)
gotoBox.TextColor3 = Color3.fromRGB(255,255,255)
gotoBox.Font = Enum.Font.SourceSans
gotoBox.PlaceholderText = "Scrivi il nome del player"
gotoBox.ClearTextOnFocus = false
gotoBox.Parent = frame

local gotoBtn = Instance.new("TextButton")
gotoBtn.Size = UDim2.new(0.8,0,0,30)
gotoBtn.Position = UDim2.new(0.1,0,0,225)
gotoBtn.BackgroundColor3 = gotoColor
gotoBtn.TextColor3 = Color3.fromRGB(255,255,255)
gotoBtn.Font = Enum.Font.SourceSansBold
gotoBtn.TextSize = 18
gotoBtn.Text = "Goto Player"
gotoBtn.Parent = frame

gotoBtn.MouseButton1Click:Connect(function()
	local targetName = gotoBox.Text
	local target = Players:FindFirstChild(targetName)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
		print("[Debug] Teletrasportato da:", targetName)
	else
		warn("[Debug] Giocatore non trovato o non ha Character/HumanoidRootPart")
	end
end)

-- Toggle GUI con M
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.M then
		frame.Visible = not frame.Visible
		print("[Debug] Pannello visibile:", frame.Visible)
	end
end)

-- Drag dalla barra titolo
local dragging = false
local dragStart = Vector2.new()
local startPos = Vector2.new()

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = UserInputService:GetMouseLocation()
		startPos = Vector2.new(frame.Position.X.Offset, frame.Position.Y.Offset)
	end
end)

titleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = UserInputService:GetMouseLocation() - dragStart
		local newX = math.clamp(startPos.X + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - frame.AbsoluteSize.X)
		local newY = math.clamp(startPos.Y + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - frame.AbsoluteSize.Y)
		frame.Position = UDim2.new(0, newX, 0, newY)
	end
end)

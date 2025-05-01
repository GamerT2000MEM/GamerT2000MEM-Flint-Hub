local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

if CoreGui:FindFirstChild("GamerT2000MEM_FlingHub") then
    CoreGui.GamerT2000MEM_FlingHub:Destroy()
end

local Settings = {
    FlingForce = 10000,
    SpinSpeed = 50,
    ReturnToOriginalPosition = true,
    SelectedPlayer = nil,
    OriginalPosition = nil,
    OriginalOrientation = nil
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GamerT2000MEM_FlingHub"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 60)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -30)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 215, 0)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 60)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local Logo = Instance.new("ImageLabel")
Logo.Image = "rbxassetid://6031075931"
Logo.Size = UDim2.new(0, 40, 0, 40)
Logo.Position = UDim2.new(0, 10, 0, 10)
Logo.BackgroundTransparency = 1
Logo.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Text = "GamerT2000MEM Fling Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.Size = UDim2.new(0, 250, 0, 40)
Title.Position = UDim2.new(0, 60, 0, 10)
Title.BackgroundTransparency = 1
Title.Parent = TitleBar

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(1, -50, 0, 10)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Text = "▼"
ToggleButton.TextColor3 = Color3.fromRGB(255, 215, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 24
ToggleButton.Parent = TitleBar

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 0, 0)
ScrollFrame.Position = UDim2.new(0, 10, 0, 70)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.Visible = false
ScrollFrame.Parent = MainFrame

local ContactsFrame = Instance.new("Frame")
ContactsFrame.Size = UDim2.new(1, -20, 0, 60)
ContactsFrame.Position = UDim2.new(0, 10, 0, 380)
ContactsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ContactsFrame.BackgroundTransparency = 1
ContactsFrame.Visible = false
ContactsFrame.Parent = MainFrame

local ContactsCorner = Instance.new("UICorner")
ContactsCorner.CornerRadius = UDim.new(0, 8)
ContactsCorner.Parent = ContactsFrame

local DiscordLabel = Instance.new("TextLabel")
DiscordLabel.Text = "DISCORD: gamert2000mem"
DiscordLabel.Font = Enum.Font.GothamMedium
DiscordLabel.TextSize = 16
DiscordLabel.TextColor3 = Color3.fromRGB(88, 101, 242)
DiscordLabel.Size = UDim2.new(1, -20, 0, 25)
DiscordLabel.Position = UDim2.new(0, 10, 0, 5)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Parent = ContactsFrame

local YouTubeLabel = Instance.new("TextLabel")
YouTubeLabel.Text = "YOUTUBE: youtube.com/@GamerT2000MEM"
YouTubeLabel.Font = Enum.Font.GothamMedium
YouTubeLabel.TextSize = 16
YouTubeLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
YouTubeLabel.Size = UDim2.new(1, -20, 0, 25)
YouTubeLabel.Position = UDim2.new(0, 10, 0, 30)
YouTubeLabel.BackgroundTransparency = 1
YouTubeLabel.Parent = ContactsFrame

local isExpanded = false
local ActiveThrust = nil
local SpinConn = nil

local function UpdatePlayerList()
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextButton") and child.Name ~= "ControlButton" then
            child:Destroy()
        end
    end

    local playerButtons = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Name = player.Name
            btn.Parent = ScrollFrame
            btn.Size = UDim2.new(1, -20, 0, 40)
            btn.Position = UDim2.new(0, 10, 0, #playerButtons * 45)
            btn.Text = player.Name
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 16
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.BackgroundColor3 = player == Settings.SelectedPlayer and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(60, 60, 80)
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                Settings.SelectedPlayer = player
                UpdatePlayerList()
            end)
            
            table.insert(playerButtons, btn)
        end
    end
    
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #playerButtons * 45 + 220)
end

local function StartSpin()
    if SpinConn then SpinConn:Disconnect() end
    
    SpinConn = RunService.Heartbeat:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, Settings.SpinSpeed, 0)
        end
    end)
end

local function StopSpin()
    if SpinConn then
        SpinConn:Disconnect()
        SpinConn = nil
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.RotVelocity = Vector3.zero
    end
end

local function SaveOriginalPosition()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Settings.OriginalPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
        Settings.OriginalOrientation = LocalPlayer.Character.HumanoidRootPart.Orientation
    end
end

local function FreezeCharacter()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
end

local function ReturnToOriginalPosition()
    if Settings.ReturnToOriginalPosition and Settings.OriginalPosition then
        FreezeCharacter()
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            root.CFrame = Settings.OriginalPosition
            root.Orientation = Settings.OriginalOrientation
            
            task.delay(0.1, FreezeCharacter)
        end
    end
end

local function FlingPlayer()
    if not Settings.SelectedPlayer or not Settings.SelectedPlayer.Character then
        warn("Не выбрана цель!")
        return
    end

    SaveOriginalPosition()
    
    if ActiveThrust then ActiveThrust:Destroy() end
    
    StartSpin()
    
    ActiveThrust = Instance.new('BodyThrust', LocalPlayer.Character.HumanoidRootPart)
    ActiveThrust.Force = Vector3.new(Settings.FlingForce, Settings.FlingForce, Settings.FlingForce)
    ActiveThrust.Name = "FlingForce"
    
    local target = Settings.SelectedPlayer
    local startTime = tick()
    
    while target.Character and target.Character:FindFirstChild("HumanoidRootPart") and tick() - startTime < 3 do
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        ActiveThrust.Location = target.Character.HumanoidRootPart.Position
        RunService.Heartbeat:Wait()
    end
    
    if ActiveThrust then ActiveThrust:Destroy() end
    StopSpin()
    ReturnToOriginalPosition()
end

local function CreateControls()
    local playerCount = #Players:GetPlayers() - 1
    local baseY = playerCount * 45
    
    local startBtn = Instance.new("TextButton")
    startBtn.Name = "ControlButton"
    startBtn.Parent = ScrollFrame
    startBtn.Size = UDim2.new(1, -20, 0, 40)
    startBtn.Position = UDim2.new(0, 10, 0, baseY + 10)
    startBtn.Text = "ЗАПУСТИТЬ FLING"
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 16
    startBtn.TextColor3 = Color3.new(1, 1, 1)
    startBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    
    local startCorner = Instance.new("UICorner")
    startCorner.CornerRadius = UDim.new(0, 8)
    startCorner.Parent = startBtn
    
    startBtn.MouseButton1Click:Connect(FlingPlayer)
    
    local stopBtn = Instance.new("TextButton")
    stopBtn.Name = "ControlButton"
    stopBtn.Parent = ScrollFrame
    stopBtn.Size = UDim2.new(1, -20, 0, 40)
    stopBtn.Position = UDim2.new(0, 10, 0, baseY + 60)
    stopBtn.Text = "ОСТАНОВИТЬ"
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextSize = 16
    stopBtn.TextColor3 = Color3.new(1, 1, 1)
    stopBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    
    local stopCorner = Instance.new("UICorner")
    stopCorner.CornerRadius = UDim.new(0, 8)
    stopCorner.Parent = stopBtn
    
    stopBtn.MouseButton1Click:Connect(function()
        if ActiveThrust then ActiveThrust:Destroy() end
        StopSpin()
        ReturnToOriginalPosition()
    end)
    
    local forceBox = Instance.new("TextBox")
    forceBox.Parent = ScrollFrame
    forceBox.Size = UDim2.new(0.45, -10, 0, 30)
    forceBox.Position = UDim2.new(0, 10, 0, baseY + 120)
    forceBox.Text = tostring(Settings.FlingForce)
    forceBox.PlaceholderText = "Сила выброса"
    forceBox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    forceBox.TextColor3 = Color3.new(1, 1, 1)
    forceBox.Font = Enum.Font.GothamMedium
    forceBox.TextSize = 14
    
    local forceBoxCorner = Instance.new("UICorner")
    forceBoxCorner.CornerRadius = UDim.new(0, 8)
    forceBoxCorner.Parent = forceBox
    
    local spinBox = Instance.new("TextBox")
    spinBox.Parent = ScrollFrame
    spinBox.Size = UDim2.new(0.45, -10, 0, 30)
    spinBox.Position = UDim2.new(0.55, 5, 0, baseY + 120)
    spinBox.Text = tostring(Settings.SpinSpeed)
    spinBox.PlaceholderText = "Скорость вращения"
    spinBox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    spinBox.TextColor3 = Color3.new(1, 1, 1)
    spinBox.Font = Enum.Font.GothamMedium
    spinBox.TextSize = 14
    
    local spinBoxCorner = Instance.new("UICorner")
    spinBoxCorner.CornerRadius = UDim.new(0, 8)
    spinBoxCorner.Parent = spinBox
    
    local returnToggle = Instance.new("TextButton")
    returnToggle.Name = "ControlButton"
    returnToggle.Parent = ScrollFrame
    returnToggle.Size = UDim2.new(1, -20, 0, 40)
    returnToggle.Position = UDim2.new(0, 10, 0, baseY + 160)
    returnToggle.Text = Settings.ReturnToOriginalPosition and "ВОЗВРАТ: ВКЛ" or "ВОЗВРАТ: ВЫКЛ"
    returnToggle.Font = Enum.Font.GothamBold
    returnToggle.TextSize = 16
    returnToggle.TextColor3 = Color3.new(1, 1, 1)
    returnToggle.BackgroundColor3 = Settings.ReturnToOriginalPosition and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
    
    local returnCorner = Instance.new("UICorner")
    returnCorner.CornerRadius = UDim.new(0, 8)
    returnCorner.Parent = returnToggle
    
    returnToggle.MouseButton1Click:Connect(function()
        Settings.ReturnToOriginalPosition = not Settings.ReturnToOriginalPosition
        returnToggle.Text = Settings.ReturnToOriginalPosition and "ВОЗВРАТ: ВКЛ" or "ВОЗВРАТ: ВЫКЛ"
        returnToggle.BackgroundColor3 = Settings.ReturnToOriginalPosition and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
    end)
    
    forceBox.FocusLost:Connect(function()
        local num = tonumber(forceBox.Text)
        if num and num > 0 then
            Settings.FlingForce = num
        else
            forceBox.Text = Settings.FlingForce
        end
    end)
    
    spinBox.FocusLost:Connect(function()
        local num = tonumber(spinBox.Text)
        if num and num > 0 then
            Settings.SpinSpeed = num
        else
            spinBox.Text = Settings.SpinSpeed
        end
    end)
end

local function OpenMenu()
    ScrollFrame.Visible = true
    ContactsFrame.Visible = true
    
    local mainTween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad),
        {Size = UDim2.new(0, 400, 0, 450)}
    )
    
    local scrollTween = TweenService:Create(
        ScrollFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad),
        {Size = UDim2.new(1, -20, 0, 300)}
    )
    
    local contactsTween = TweenService:Create(
        ContactsFrame,
        TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0.2),
        {BackgroundTransparency = 0.2}
    )
    
    mainTween:Play()
    scrollTween:Play()
    contactsTween:Play()
    
    UpdatePlayerList()
    CreateControls()
    
    ToggleButton.Text = "▲"
    isExpanded = true
end

local function CloseMenu()
    local contactsTween = TweenService:Create(
        ContactsFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad),
        {BackgroundTransparency = 1}
    )
    
    local scrollTween = TweenService:Create(
        ScrollFrame,
        TweenInfo.new(0.4, Enum.EasingStyle.Quad),
        {Size = UDim2.new(1, -20, 0, 0)}
    )
    
    local mainTween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0.1),
        {Size = UDim2.new(0, 400, 0, 60)}
    )
    
    contactsTween:Play()
    scrollTween:Play()
    mainTween:Play()
    
    contactsTween.Completed:Connect(function()
        ContactsFrame.Visible = false
    end)
    
    scrollTween.Completed:Connect(function()
        ScrollFrame.Visible = false
    end)
    
    ToggleButton.Text = "▼"
    isExpanded = false
end

local function toggleMenu()
    if isExpanded then
        CloseMenu()
    else
        OpenMenu()
    end
end

ToggleButton.MouseButton1Click:Connect(toggleMenu)

local dragging = false
local dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

RunService.Heartbeat:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

print("GamerT2000MEM Fling Hub loaded with smooth animations!")

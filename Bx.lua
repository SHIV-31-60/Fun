-- ZeeHub VIP Modified - Galaxy Purple Theme & Activation System
-- Modified by AI Assistant
-- Features: Galaxy Purple UI Theme + 24-hour activation key system

-- Activation System Variables
local ACTIVATION_KEY = "ownerxshiv"
local ACTIVATION_FILE = "zeehub_activation.txt"
local ACTIVATION_DURATION = 24 * 60 * 60 -- 24 hours in seconds

-- Galaxy Purple Color Scheme
local GalaxyPurple = {
    Primary = Color3.fromRGB(88, 24, 168),      -- Deep galaxy purple
    Secondary = Color3.fromRGB(138, 43, 226),   -- Blue violet
    Accent = Color3.fromRGB(186, 85, 211),      -- Medium orchid
    Background = Color3.fromRGB(25, 0, 51),     -- Very dark purple
    Surface = Color3.fromRGB(46, 16, 101),      -- Dark slate blue
    Text = Color3.fromRGB(255, 255, 255),       -- White text
    TextSecondary = Color3.fromRGB(200, 180, 255), -- Light purple text
    Success = Color3.fromRGB(138, 255, 138),    -- Light green
    Warning = Color3.fromRGB(255, 215, 0),      -- Gold
    Error = Color3.fromRGB(255, 99, 99)         -- Light red
}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- Utility Functions
local function createTween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out
    )
    return TweenService:Create(object, tweenInfo, properties)
end

local function saveActivationTime()
    local currentTime = os.time()
    writefile(ACTIVATION_FILE, tostring(currentTime))
end

local function getLastActivationTime()
    if isfile(ACTIVATION_FILE) then
        local timeStr = readfile(ACTIVATION_FILE)
        return tonumber(timeStr) or 0
    end
    return 0
end

local function isActivationValid()
    local lastActivation = getLastActivationTime()
    local currentTime = os.time()
    return (currentTime - lastActivation) < ACTIVATION_DURATION
end

local function getRemainingTime()
    local lastActivation = getLastActivationTime()
    local currentTime = os.time()
    local elapsed = currentTime - lastActivation
    local remaining = ACTIVATION_DURATION - elapsed
    return math.max(0, remaining)
end

local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- Activation GUI
local function createActivationGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZeeHubActivation"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.BackgroundColor3 = GalaxyPurple.Background
    MainFrame.BorderSizePixel = 0
    
    -- Frame Gradient
    local Gradient = Instance.new("UIGradient")
    Gradient.Parent = MainFrame
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, GalaxyPurple.Background),
        ColorSequenceKeypoint.new(1, GalaxyPurple.Surface)
    })
    Gradient.Rotation = 45
    
    -- Corner Radius
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = MainFrame
    
    -- Border Effect
    local Border = Instance.new("UIStroke")
    Border.Parent = MainFrame
    Border.Color = GalaxyPurple.Primary
    Border.Thickness = 2
    Border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = "🌌 ZeeHub VIP - Galaxy Edition"
    Title.TextColor3 = GalaxyPurple.Text
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    
    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Parent = MainFrame
    Subtitle.Position = UDim2.new(0, 0, 0, 60)
    Subtitle.Size = UDim2.new(1, 0, 0, 30)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Enter activation key to continue"
    Subtitle.TextColor3 = GalaxyPurple.TextSecondary
    Subtitle.TextScaled = true
    Subtitle.Font = Enum.Font.Gotham
    
    -- Key Input
    local KeyInput = Instance.new("TextBox")
    KeyInput.Name = "KeyInput"
    KeyInput.Parent = MainFrame
    KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
    KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
    KeyInput.BackgroundColor3 = GalaxyPurple.Surface
    KeyInput.BorderSizePixel = 0
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Enter activation key..."
    KeyInput.TextColor3 = GalaxyPurple.Text
    KeyInput.PlaceholderColor3 = GalaxyPurple.TextSecondary
    KeyInput.TextScaled = true
    KeyInput.Font = Enum.Font.Gotham
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 8)
    InputCorner.Parent = KeyInput
    
    local InputBorder = Instance.new("UIStroke")
    InputBorder.Parent = KeyInput
    InputBorder.Color = GalaxyPurple.Primary
    InputBorder.Thickness = 1
    
    -- Activate Button
    local ActivateButton = Instance.new("TextButton")
    ActivateButton.Name = "ActivateButton"
    ActivateButton.Parent = MainFrame
    ActivateButton.Position = UDim2.new(0.1, 0, 0.6, 0)
    ActivateButton.Size = UDim2.new(0.8, 0, 0, 50)
    ActivateButton.BackgroundColor3 = GalaxyPurple.Primary
    ActivateButton.BorderSizePixel = 0
    ActivateButton.Text = "🚀 ACTIVATE"
    ActivateButton.TextColor3 = GalaxyPurple.Text
    ActivateButton.TextScaled = true
    ActivateButton.Font = Enum.Font.GothamBold
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = ActivateButton
    
    -- Status Label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Parent = MainFrame
    StatusLabel.Position = UDim2.new(0, 0, 0.8, 0)
    StatusLabel.Size = UDim2.new(1, 0, 0, 30)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = GalaxyPurple.TextSecondary
    StatusLabel.TextScaled = true
    StatusLabel.Font = Enum.Font.Gotham
    
    -- Button Animations
    ActivateButton.MouseEnter:Connect(function()
        createTween(ActivateButton, {BackgroundColor3 = GalaxyPurple.Secondary}):Play()
    end)
    
    ActivateButton.MouseLeave:Connect(function()
        createTween(ActivateButton, {BackgroundColor3 = GalaxyPurple.Primary}):Play()
    end)
    
    -- Activation Logic
    ActivateButton.MouseButton1Click:Connect(function()
        local inputKey = KeyInput.Text
        
        if inputKey == ACTIVATION_KEY then
            saveActivationTime()
            StatusLabel.Text = "✅ Activation Successful! Loading ZeeHub..."
            StatusLabel.TextColor3 = GalaxyPurple.Success
            
            -- Animate success
            createTween(MainFrame, {BackgroundColor3 = GalaxyPurple.Success}, 0.5):Play()
            
            wait(2)
            ScreenGui:Destroy()
            loadMainHub()
        else
            StatusLabel.Text = "❌ Invalid activation key!"
            StatusLabel.TextColor3 = GalaxyPurple.Error
            
            -- Shake animation for error
            local shakeAmount = 10
            for i = 1, 5 do
                createTween(MainFrame, {Position = UDim2.new(0.5, shakeAmount, 0.5, 0)}, 0.05):Play()
                wait(0.05)
                createTween(MainFrame, {Position = UDim2.new(0.5, -shakeAmount, 0.5, 0)}, 0.05):Play()
                wait(0.05)
            end
            createTween(MainFrame, {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.1):Play()
        end
    end)
    
    -- Enter Key Support
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            ActivateButton.MouseButton1Click:fire()
        end
    end)
    
    -- Entrance Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    createTween(MainFrame, {Size = UDim2.new(0, 400, 0, 300)}, 0.8, Enum.EasingStyle.Back):Play()
end

-- Main Hub GUI with Galaxy Purple Theme
function loadMainHub()
    -- This would load the main ZeeHub interface with galaxy purple theme
    -- For demonstration, creating a simple notification
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZeeHubVIP"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    -- Status Frame
    local StatusFrame = Instance.new("Frame")
    StatusFrame.Name = "StatusFrame"
    StatusFrame.Parent = ScreenGui
    StatusFrame.Position = UDim2.new(1, -320, 0, 20)
    StatusFrame.Size = UDim2.new(0, 300, 0, 100)
    StatusFrame.BackgroundColor3 = GalaxyPurple.Background
    StatusFrame.BorderSizePixel = 0
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 10)
    StatusCorner.Parent = StatusFrame
    
    local StatusBorder = Instance.new("UIStroke")
    StatusBorder.Parent = StatusFrame
    StatusBorder.Color = GalaxyPurple.Primary
    StatusBorder.Thickness = 2
    
    -- Status Title
    local StatusTitle = Instance.new("TextLabel")
    StatusTitle.Parent = StatusFrame
    StatusTitle.Position = UDim2.new(0, 10, 0, 5)
    StatusTitle.Size = UDim2.new(1, -20, 0, 30)
    StatusTitle.BackgroundTransparency = 1
    StatusTitle.Text = "🌌 ZeeHub VIP Active"
    StatusTitle.TextColor3 = GalaxyPurple.Text
    StatusTitle.TextScaled = true
    StatusTitle.Font = Enum.Font.GothamBold
    StatusTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Time Remaining
    local TimeLabel = Instance.new("TextLabel")
    TimeLabel.Parent = StatusFrame
    TimeLabel.Position = UDim2.new(0, 10, 0, 35)
    TimeLabel.Size = UDim2.new(1, -20, 0, 25)
    TimeLabel.BackgroundTransparency = 1
    TimeLabel.TextColor3 = GalaxyPurple.TextSecondary
    TimeLabel.TextScaled = true
    TimeLabel.Font = Enum.Font.Gotham
    TimeLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Update time remaining
    spawn(function()
        while StatusFrame.Parent do
            local remaining = getRemainingTime()
            if remaining > 0 then
                TimeLabel.Text = "⏰ Time remaining: " .. formatTime(remaining)
            else
                TimeLabel.Text = "⚠️ Activation expired!"
                TimeLabel.TextColor3 = GalaxyPurple.Warning
            end
            wait(1)
        end
    end)
    
    -- Version Info
    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Parent = StatusFrame
    VersionLabel.Position = UDim2.new(0, 10, 0, 65)
    VersionLabel.Size = UDim2.new(1, -20, 0, 25)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Text = "🎨 Galaxy Purple Theme v1.0"
    VersionLabel.TextColor3 = GalaxyPurple.Accent
    VersionLabel.TextScaled = true
    VersionLabel.Font = Enum.Font.Gotham
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Slide in animation
    StatusFrame.Position = UDim2.new(1, 0, 0, 20)
    createTween(StatusFrame, {Position = UDim2.new(1, -320, 0, 20)}, 0.5):Play()
    
    -- Here you would load the original ZeeHub functionality
    -- with the galaxy purple color scheme applied throughout
    
    print("🌌 ZeeHub VIP loaded with Galaxy Purple theme!")
    print("⏰ Activation valid for:", formatTime(getRemainingTime()))

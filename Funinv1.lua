u-- Shiv X Admin Panel Script
-- Galaxy Star Black Neon Theme
-- Created for advanced admin controls

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Create Main GUI
local ShivXGui = Instance.new("ScreenGui")
ShivXGui.Name = "ShivXAdminPanel"
ShivXGui.Parent = PlayerGui
ShivXGui.ResetOnSpawn = false

-- Main Frame (Galaxy Theme)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainPanel"
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ShivXGui

-- Add gradient background
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 0, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 20))
}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- Corner rounding
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 15)
Corner.Parent = MainFrame

-- Neon border effect
local BorderFrame = Instance.new("Frame")
BorderFrame.Size = UDim2.new(1, 4, 1, 4)
BorderFrame.Position = UDim2.new(0, -2, 0, -2)
BorderFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
BorderFrame.BorderSizePixel = 0
BorderFrame.ZIndex = MainFrame.ZIndex - 1
BorderFrame.Parent = MainFrame

local BorderCorner = Instance.new("UICorner")
BorderCorner.CornerRadius = UDim.new(0, 17)
BorderCorner.Parent = BorderFrame

-- Animate border glow
local function animateBorder()
    local tween = TweenService:Create(BorderFrame, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        BackgroundColor3 = Color3.fromRGB(255, 0, 255)
    })
    tween:Play()
end
animateBorder()

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✨ SHIV X ADMIN PANEL ✨"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 24
Title.TextStrokeTransparency = 0
Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 15)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ShivXGui:Destroy()
end)

-- Scroll Frame for buttons
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -70)
ScrollFrame.Position = UDim2.new(0, 10, 0, 60)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 5)
Layout.Parent = ScrollFrame

-- Button creation function
local function createButton(text, color, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.BackgroundColor3 = color
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 16
    Button.Font = Enum.Font.Gotham
    Button.TextStrokeTransparency = 0
    Button.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    Button.Parent = ScrollFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    -- Button hover effect
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(color.R + 0.2, color.G + 0.2, color.B + 0.2)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
    end)
    
    Button.MouseButton1Click:Connect(callback)
    
    -- Update canvas size
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    end)
    
    return Button
end

-- Admin Functions
local AdminFunctions = {}

-- Flying
AdminFunctions.Flying = false
function AdminFunctions.ToggleFly()
    AdminFunctions.Flying = not AdminFunctions.Flying
    local character = Player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if AdminFunctions.Flying then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
        bodyAngularVelocity.Parent = rootPart
        
        -- Flying controls
        spawn(function()
            while AdminFunctions.Flying and rootPart.Parent do
                local camera = workspace.CurrentCamera
                local moveVector = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveVector = moveVector + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveVector = moveVector - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveVector = moveVector - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveVector = moveVector + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                    moveVector = moveVector + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                    moveVector = moveVector - Vector3.new(0, 1, 0)
                end
                
                bodyVelocity.Velocity = moveVector * 50
                wait()
            end
        end)
    else
        for _, obj in pairs(rootPart:GetChildren()) do
            if obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity") then
                obj:Destroy()
            end
        end
    end
end

-- NoClip
AdminFunctions.NoClip = false
function AdminFunctions.ToggleNoClip()
    AdminFunctions.NoClip = not AdminFunctions.NoClip
    local character = Player.Character
    if not character then return end
    
    spawn(function()
        while AdminFunctions.NoClip and character.Parent do
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            wait()
        end
        -- Re-enable collision when turned off
        if character.Parent then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end)
end

-- Teleport to player
function AdminFunctions.TeleportToPlayer()
    local targetName = game:GetService("UserInputService"):GetStringForKeyCode(Enum.KeyCode.Unknown)
    -- Create input dialog
    local inputDialog = Instance.new("Frame")
    inputDialog.Size = UDim2.new(0, 300, 0, 150)
    inputDialog.Position = UDim2.new(0.5, -150, 0.5, -75)
    inputDialog.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    inputDialog.Parent = ShivXGui
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = inputDialog
    
    local inputTitle = Instance.new("TextLabel")
    inputTitle.Size = UDim2.new(1, 0, 0, 40)
    inputTitle.BackgroundTransparency = 1
    inputTitle.Text = "Enter Player Name:"
    inputTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputTitle.TextSize = 16
    inputTitle.Font = Enum.Font.Gotham
    inputTitle.Parent = inputDialog
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -20, 0, 30)
    inputBox.Position = UDim2.new(0, 10, 0, 50)
    inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextSize = 14
    inputBox.Font = Enum.Font.Gotham
    inputBox.PlaceholderText = "Player name..."
    inputBox.Parent = inputDialog
    
    local inputBoxCorner = Instance.new("UICorner")
    inputBoxCorner.CornerRadius = UDim.new(0, 5)
    inputBoxCorner.Parent = inputBox
    
    local confirmButton = Instance.new("TextButton")
    confirmButton.Size = UDim2.new(0, 80, 0, 30)
    confirmButton.Position = UDim2.new(0, 10, 1, -40)
    confirmButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    confirmButton.Text = "Teleport"
    confirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmButton.TextSize = 14
    confirmButton.Font = Enum.Font.Gotham
    confirmButton.Parent = inputDialog
    
    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = UDim.new(0, 5)
    confirmCorner.Parent = confirmButton
    
    local cancelButton = Instance.new("TextButton")
    cancelButton.Size = UDim2.new(0, 80, 0, 30)
    cancelButton.Position = UDim2.new(1, -90, 1, -40)
    cancelButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    cancelButton.Text = "Cancel"
    cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelButton.TextSize = 14
    cancelButton.Font = Enum.Font.Gotham
    cancelButton.Parent = inputDialog
    
    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 5)
    cancelCorner.Parent = cancelButton
    
    confirmButton.MouseButton1Click:Connect(function()
        local targetPlayer = nil
        for _, player in pairs(Players:GetPlayers()) do
            if string.lower(player.Name):find(string.lower(inputBox.Text)) or string.lower(player.DisplayName):find(string.lower(inputBox.Text)) then
                targetPlayer = player
                break
            end
        end
        
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(5, 0, 0)
            end
        end
        inputDialog:Destroy()
    end)
    
    cancelButton.MouseButton1Click:Connect(function()
        inputDialog:Destroy()
    end)
end

-- Teleport player to me
function AdminFunctions.TeleportPlayerToMe()
    -- Similar input dialog for teleporting others to you
    local inputDialog = Instance.new("Frame")
    inputDialog.Size = UDim2.new(0, 300, 0, 150)
    inputDialog.Position = UDim2.new(0.5, -150, 0.5, -75)
    inputDialog.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    inputDialog.Parent = ShivXGui
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = inputDialog
    
    local inputTitle = Instance.new("TextLabel")
    inputTitle.Size = UDim2.new(1, 0, 0, 40)
    inputTitle.BackgroundTransparency = 1
    inputTitle.Text = "Teleport Player To Me:"
    inputTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputTitle.TextSize = 16
    inputTitle.Font = Enum.Font.Gotham
    inputTitle.Parent = inputDialog
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -20, 0, 30)
    inputBox.Position = UDim2.new(0, 10, 0, 50)
    inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextSize = 14
    inputBox.Font = Enum.Font.Gotham
    inputBox.PlaceholderText = "Player name..."
    inputBox.Parent = inputDialog
    
    local inputBoxCorner = Instance.new("UICorner")
    inputBoxCorner.CornerRadius = UDim.new(0, 5)
    inputBoxCorner.Parent = inputBox
    
    local confirmButton = Instance.new("TextButton")
    confirmButton.Size = UDim2.new(0, 80, 0, 30)
    confirmButton.Position = UDim2.new(0, 10, 1, -40)
    confirmButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    confirmButton.Text = "Teleport"
    confirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmButton.TextSize = 14
    confirmButton.Font = Enum.Font.Gotham
    confirmButton.Parent = inputDialog
    
    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = UDim.new(0, 5)
    confirmCorner.Parent = confirmButton
    
    local cancelButton = Instance.new("TextButton")
    cancelButton.Size = UDim2.new(0, 80, 0, 30)
    cancelButton.Position = UDim2.new(1, -90, 1, -40)
    cancelButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    cancelButton.Text = "Cancel"
    cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelButton.TextSize = 14
    cancelButton.Font = Enum.Font.Gotham
    cancelButton.Parent = inputDialog
    
    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 5)
    cancelCorner.Parent = cancelButton
    
    confirmButton.MouseButton1Click:Connect(function()
        local targetPlayer = nil
        for _, player in pairs(Players:GetPlayers()) do
            if string.lower(player.Name):find(string.lower(inputBox.Text)) or string.lower(player.DisplayName):find(string.lower(inputBox.Text)) then
                targetPlayer = player
                break
            end
        end
        
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                -- Note: This only works if you have server access or the game allows it
                targetPlayer.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame + Vector3.new(5, 0, 0)
            end
        end
        inputDialog:Destroy()
    end)
    
    cancelButton.MouseButton1Click:Connect(function()
        inputDialog:Destroy()
    end)
end

-- Change Display Name
function AdminFunctions.ChangeDisplayName()
    local inputDialog = Instance.new("Frame")
    inputDialog.Size = UDim2.new(0, 300, 0, 150)
    inputDialog.Position = UDim2.new(0.5, -150, 0.5, -75)
    inputDialog.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    inputDialog.Parent = ShivXGui
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = inputDialog
    
    local inputTitle = Instance.new("TextLabel")
    inputTitle.Size = UDim2.new(1, 0, 0, 40)
    inputTitle.BackgroundTransparency = 1
    inputTitle.Text = "New Display Name:"
    inputTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputTitle.TextSize = 16
    inputTitle.Font = Enum.Font.Gotham
    inputTitle.Parent = inputDialog
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -20, 0, 30)
    inputBox.Position = UDim2.new(0, 10, 0, 50)
    inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextSize = 14
    inputBox.Font = Enum.Font.Gotham
    inputBox.PlaceholderText = "Enter new name..."
    inputBox.Parent = inputDialog
    
    local inputBoxCorner = Instance.new("UICorner")
    inputBoxCorner.CornerRadius = UDim.new(0, 5)
    inputBoxCorner.Parent = inputBox
    
    local confirmButton = Instance.new("TextButton")
    confirmButton.Size = UDim2.new(0, 80, 0, 30)
    confirmButton.Position = UDim2.new(0, 10, 1, -40)
    confirmButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    confirmButton.Text = "Change"
    confirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmButton.TextSize = 14
    confirmButton.Font = Enum.Font.Gotham
    confirmButton.Parent = inputDialog
    
    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = UDim.new(0, 5)
    confirmCorner.Parent = confirmButton
    
    local cancelButton = Instance.new("TextButton")
    cancelButton.Size = UDim2.new(0, 80, 0, 30)
    cancelButton.Position = UDim2.new(1, -90, 1, -40)
    cancelButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    cancelButton.Text = "Cancel"
    cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelButton.TextSize = 14
    cancelButton.Font = Enum.Font.Gotham
    cancelButton.Parent = inputDialog
    
    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 5)
    cancelCorner.Parent = cancelButton
    
    confirmButton.MouseButton1Click:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.DisplayName = inputBox.Text
        end
        inputDialog:Destroy()
    end)
    
    cancelButton.MouseButton1Click:Connect(function()
        inputDialog:Destroy()
    end)
end

-- Jumpscare function
function AdminFunctions.Jumpscare()
    -- Create jumpscare effect for all players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            spawn(function()
                local jumpscareGui = Instance.new("ScreenGui")
                jumpscareGui.Name = "JumpscareEffect"
                jumpscareGui.Parent = player.PlayerGui
                
                local redScreen = Instance.new("Frame")
                redScreen.Size = UDim2.new(1, 0, 1, 0)
                redScreen.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                redScreen.BackgroundTransparency = 0.3
                redScreen.Parent = jumpscareGui
                
                local scareText = Instance.new("TextLabel")
                scareText.Size = UDim2.new(1, 0, 1, 0)
                scareText.BackgroundTransparency = 1
                scareText.Text = "👹 SHIV X JUMPSCARE! 👹"
                scareText.TextColor3 = Color3.fromRGB(255, 255, 255)
                scareText.TextSize = 50
                scareText.Font = Enum.Font.GothamBold
                scareText.TextStrokeTransparency = 0
                scareText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                scareText.Parent = redScreen
                
                -- Flashing effect
                for i = 1, 10 do
                    redScreen.BackgroundTransparency = 0.1
                    wait(0.1)
                    redScreen.BackgroundTransparency = 0.8
                    wait(0.1)
                end
                
                jumpscareGui:Destroy()
            end)
        end
    end
end

-- Kill Player function
function AdminFunctions.KillPlayer()
    local inputDialog = Instance.new("Frame")
    inputDialog.Size = UDim2.new(0, 300, 0, 150)
    inputDialog.Position = UDim2.new(0.5, -150, 0.5, -75)
    inputDialog.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    inputDialog.Parent = ShivXGui
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = inputDialog
    
    local inputTitle = Instance.new("TextLabel")
    inputTitle.Size = UDim2.new(1, 0, 0, 40)
    inputTitle.BackgroundTransparency = 1
    inputTitle.Text = "Kill Player:"
    inputTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputTitle.TextSize = 16
    inputTitle.Font = Enum.Font.Gotham
    inputTitle.Parent = inputDialog
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -20, 0, 30)
    inputBox.Position = UDim2.new(0, 10, 0, 50)
    inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextSize = 14
    inputBox.Font = Enum.Font.Gotham
    inputBox.PlaceholderText = "Player name..."
    inputBox.Parent = inputDialog
    
    local inputBoxCorner = Instance.new("UICorner")
    inputBoxCorner.CornerRadius = UDim.new(0, 5)
    inputBoxCorner.Parent = inputBox
    
    local confirmButton = Instance.new("TextButton")
    confirmButton.Size = UDim2.new(0, 80, 0, 30)
    confirmButton.Position = UDim2.new(0, 10, 1, -40)
    confirmButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    confirmButton.Text = "Kill"
    confirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmButton.TextSize = 14
    confirmButton.Font = Enum.Font.Gotham
    confirmButton.Parent = inputDialog
    
    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = UDim.new(0, 5)
    confirmCorner.Parent = confirmButton
    
    local cancelButton = Instance.new("TextButton")
    cancelButton.Size = UDim2.new(0, 80, 0, 30)
    cancelButton.Position = UDim2.new(1, -90, 1, -40)
    cancelButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    cancelButton.Text = "Cancel"
    cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelButton.TextSize = 14
    cancelButton.Font = Enum.Font.Gotham
    cancelButton.Parent = inputDialog
    
    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 5)
    cancelCorner.Parent = cancelButton
    
    confirmButton.MouseButton1Click:Connect(function()
        local targetPlayer = nil
        for _, player in pairs(Players:GetPlayers()) do
            if string.lower(player.Name):find(string.lower(inputBox.Text)) or string.lower(player.DisplayName):find(string.lower(inputBox.Text)) then
                targetPlayer = player
                break
            end
        end
        
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
            targetPlayer.Character.Humanoid.Health = 0
        end
        inputDialog:Destroy()
    end)
    
    cancelButton.MouseButton1Click:Connect(function()
        inputDialog:Destroy()
    end)
end

-- Outfit Change function
function AdminFunctions.ChangeOutfit()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local humanoid = Player.Character.Humanoid
        local description = humanoid:GetAppliedDescription()
        
        -- Random outfit change
        description.Shirt = math.random(1, 1000000000)
        description.Pants = math.random(1, 1000000000)
        description.TShirt = math.random(1, 1000000000)
        
        humanoid:ApplyDescription(description)
    end
end

-- Free Game Items function
function AdminFunctions.FreeGameItems()
    -- This function would need to be customized based on the specific game
    -- General approach for common games:
    local backpack = Player:FindFirstChild("Backpack")
    if backpack then
        -- Create some common tools
        local tool1 = Instance.new("Tool")
        tool1.Name = "Admin Sword"
        tool1.Parent = backpack
        
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1, 4, 0.2)
        handle.Material = Enum.Material.Neon
        handle.BrickColor = BrickColor.new("Cyan")
        handle.Parent = tool1
        
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxasset://fonts/sword.mesh"
        mesh.TextureId = "rbxasset://textures/SwordTexture.png"
        mesh.Parent = handle
    end
end

-- Create all buttons
createButton("🚀 Toggle Flight", Color3.fromRGB(0, 150, 255), AdminFunctions.ToggleFly)
createButton("👻 Toggle NoClip", Color3.fromRGB(150, 0, 255), AdminFunctions.ToggleNoClip)
createButton("📍 Teleport To Player", Color3.fromRGB(0, 255, 150), AdminFunctions.TeleportToPlayer)
createButton("📍 Teleport Player To Me", Color3.fromRGB(255, 150, 0), AdminFunctions.TeleportPlayerToMe)
createButton("✏️ Change Display Name", Color3.fromRGB(255, 255, 0), AdminFunctions.ChangeDisplayName)
createButton("👕 Change Outfit", Color3.fromRGB(255, 0, 150), AdminFunctions.ChangeOutfit)
createButton("🎁 Free Game Items", Color3.fromRGB(0, 255, 0), AdminFunctions.FreeGameItems)
createButton("💀 Kill Player", Color3.fromRGB(200, 0, 0), AdminFunctions.KillPlayer)
createButton("👹 Jumpscare All", Color3.fromRGB(150, 0, 0), AdminFunctions.Jumpscare)

-- Notification system
local function showNotification(text, color)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 60)
    notification.Position = UDim2.new(1, -320, 0, 20)
    notification.BackgroundColor3 = color or Color3.fromRGB(50, 50, 70)
    notification.Parent = ShivXGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notification
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -10, 1, 0)
    notifText.Position = UDim2.new(0, 5, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextSize = 14
    notifText.Font = Enum.Font.Gotham
    notifText.TextWrapped = true
    notifText.Parent = notification
    
    -- Animate in
    notification:TweenPosition(UDim2.new(1, -320, 0, 20), "Out", "Quad", 0.5, true)
    
    -- Auto remove after 3 seconds
    game:GetService("Debris"):AddItem(notification, 3)
end

-- Show startup notification
showNotification("✨ Shiv X Admin Panel Loaded Successfully! ✨", Color3.fromRGB(0, 255, 100))

-- Keybind to toggle GUI (Right Ctrl)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("Shiv X Admin Panel loaded successfully!")
print("Press Right Ctrl to toggle the admin panel")
print("Script created by Shiv X - Galaxy Admin Panel")
Response

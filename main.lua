local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local old = CoreGui:FindFirstChild("KDM_Menu")
if old then old:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KDM_Menu"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999999
screenGui.Parent = CoreGui

local function createGlowStroke(parent)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Parent = parent
    local strokeGrad = Instance.new("UIGradient")
    strokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.1, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(80, 80, 80)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(80, 80, 80)),
        ColorSequenceKeypoint.new(0.9, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    strokeGrad.Parent = stroke
    return strokeGrad
end

-- ==========================================
-- MAIN FRAME
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 360)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 1
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local mainGradient = createGlowStroke(mainFrame)
RunService.RenderStepped:Connect(function(dt)
    mainGradient.Rotation = (mainGradient.Rotation + dt * 150) % 360
end)

-- ==========================================
-- TOP BAR
-- ==========================================
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
topBar.BorderSizePixel = 0
topBar.ZIndex = 10
topBar.Parent = mainFrame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)

local topBarMask = Instance.new("Frame")
topBarMask.Size = UDim2.new(1, 0, 0, 12)
topBarMask.Position = UDim2.new(0, 0, 1, -12)
topBarMask.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
topBarMask.BorderSizePixel = 0
topBarMask.ZIndex = 10
topBarMask.Parent = topBar

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 28, 0, 28)
logo.Position = UDim2.new(0, 10, 0, 6)
logo.BackgroundTransparency = 1
logo.ZIndex = 11
logo.Image = "rbxassetid://79349549315565"
logo.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 45, 0, 0)
title.BackgroundTransparency = 1
title.Text = "KDM TEAM"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.ZIndex = 11
title.Parent = topBar

local function addHover(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
    end)
end

local minBtn = Instance.new("TextButton")
minBtn.Name = "MinBtn"
minBtn.Size = UDim2.new(0, 32, 0, 26)
minBtn.Position = UDim2.new(1, -80, 0, 7)
minBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minBtn.Text = "—"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.AutoButtonColor = false
minBtn.ZIndex = 15
minBtn.Parent = topBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
addHover(minBtn, Color3.fromRGB(70, 70, 70), Color3.fromRGB(100, 100, 100))

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 32, 0, 26)
closeBtn.Position = UDim2.new(1, -42, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 15
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
addHover(closeBtn, Color3.fromRGB(70, 70, 70), Color3.fromRGB(200, 60, 60))

-- ==========================================
-- KÉO THẢ MENU
-- ==========================================
local dragging = false
local dragInput, mousePos, framePos

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.Position.X >= minBtn.AbsolutePosition.X - 10 then return end
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- ==========================================
-- TAB BAR
-- ==========================================
local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(0, 120, 1, -40)
tabBar.Position = UDim2.new(0, 0, 0, 40)
tabBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 2
tabBar.Parent = mainFrame

local tabList = Instance.new("UIListLayout")
tabList.Padding = UDim.new(0, 6)
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Parent = tabBar

local tabPad = Instance.new("UIPadding")
tabPad.PaddingTop = UDim.new(0, 10)
tabPad.PaddingLeft = UDim.new(0, 10)
tabPad.PaddingRight = UDim.new(0, 10)
tabPad.Parent = tabBar

-- ==========================================
-- CONTENT
-- ==========================================
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -120, 1, -40)
content.Position = UDim2.new(0, 120, 0, 40)
content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
content.BorderSizePixel = 0
content.ZIndex = 2
content.Parent = mainFrame

local tabs = {}
local tabButtons = {}
local order = { "intro", "main", "more", "settings" }
local displayNames = { intro = "Intro", main = "Main", more = "More", settings = "Settings" }

local function createTab(name)
    local f = Instance.new("ScrollingFrame")
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.ScrollBarThickness = 4
    f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.AutomaticCanvasSize = Enum.AutomaticSize.Y
    f.Visible = false
    f.ZIndex = 3
    f.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = f

    local pad = Instance.new("UIPadding")
    pad.PaddingAll = UDim.new(0, 12)
    pad.Parent = f

    tabs[name] = f
end

for _, name in ipairs(order) do createTab(name) end

local function switchTab(name)
    for _, t in pairs(tabs) do t.Visible = false end
    for _, b in pairs(tabButtons) do
        b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        b.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    tabs[name].Visible = true
    tabButtons[name].BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    tabButtons[name].TextColor3 = Color3.fromRGB(255, 255, 255)
end

for i, name in ipairs(order) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = displayNames[name]
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.LayoutOrder = i
    btn.AutoButtonColor = false
    btn.ZIndex = 4
    btn.Parent = tabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    addHover(btn, Color3.fromRGB(50, 50, 50), Color3.fromRGB(80, 80, 80))
    tabButtons[name] = btn
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

-- NỘI DUNG TAB INTRO
local intro = tabs.intro

local bigImg = Instance.new("ImageLabel")
bigImg.Size = UDim2.new(1, -24, 0, 160)
bigImg.Position = UDim2.new(0, 12, 0, 8)
bigImg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
bigImg.Image = "rbxassetid://79349549315565"
bigImg.ScaleType = Enum.ScaleType.Fit
bigImg.ZIndex = 4
bigImg.Parent = intro
Instance.new("UICorner", bigImg).CornerRadius = UDim.new(0, 6)

local copyLbl = Instance.new("TextLabel")
copyLbl.Size = UDim2.new(1, -24, 0, 20)
copyLbl.Position = UDim2.new(0, 12, 0, 175)
copyLbl.BackgroundTransparency = 1
copyLbl.Text = "This script is copyrighted by DEV KDM TEAM"
copyLbl.TextColor3 = Color3.fromRGB(200, 150, 255)
copyLbl.Font = Enum.Font.Gotham
copyLbl.TextSize = 13
copyLbl.TextXAlignment = Enum.TextXAlignment.Left
copyLbl.ZIndex = 4
copyLbl.Parent = intro

local mapLbl = Instance.new("TextLabel")
mapLbl.Size = UDim2.new(1, -24, 0, 20)
mapLbl.Position = UDim2.new(0, 12, 0, 200)
mapLbl.BackgroundTransparency = 1
mapLbl.Text = "Script to serve map: evade"
mapLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
mapLbl.Font = Enum.Font.Gotham
mapLbl.TextSize = 13
mapLbl.TextXAlignment = Enum.TextXAlignment.Left
mapLbl.ZIndex = 4
mapLbl.Parent = intro

local verLbl = Instance.new("TextLabel")
verLbl.Size = UDim2.new(1, -24, 0, 20)
verLbl.Position = UDim2.new(0, 12, 0, 225)
verLbl.BackgroundTransparency = 1
verLbl.Text = "Version: 1.00"
verLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
verLbl.Font = Enum.Font.Gotham
verLbl.TextSize = 13
verLbl.TextXAlignment = Enum.TextXAlignment.Left
verLbl.ZIndex = 4
verLbl.Parent = intro

switchTab("intro")

-- ==========================================
-- CIRCLE BUTTON (NÚT THU NHỎ)
-- ==========================================
local circleBtn = Instance.new("TextButton")
circleBtn.Name = "CircleBtn"
circleBtn.Size = UDim2.new(0, 50, 0, 50)
circleBtn.Position = UDim2.new(0, 100, 0, 100)
circleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
circleBtn.Text = "KDM"
circleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
circleBtn.Font = Enum.Font.GothamBold
circleBtn.TextSize = 14
circleBtn.Visible = false
circleBtn.Active = true
circleBtn.AutoButtonColor = false
circleBtn.ZIndex = 100
circleBtn.Parent = screenGui
Instance.new("UICorner", circleBtn).CornerRadius = UDim.new(1, 0)
addHover(circleBtn, Color3.fromRGB(50, 50, 50), Color3.fromRGB(80, 80, 80))

local cDragging = false
local cDragStart, cStartPos
local cMoved = false

circleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        cDragging = true
        cMoved = false
        cDragStart = input.Position
        cStartPos = circleBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if cDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - cDragStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            cMoved = true
        end
        circleBtn.Position = UDim2.new(cStartPos.X.Scale, cStartPos.X.Offset + delta.X, cStartPos.Y.Scale, cStartPos.Y.Offset + delta.Y)
    end
end)

circleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if cDragging and not cMoved then
            mainFrame.Visible = true
            circleBtn.Visible = false
        end
        cDragging = false
    end
end)

minBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    circleBtn.Visible = true
    circleBtn.Position = mainFrame.Position
end)

-- ==========================================
-- CONFIRM XÓA
-- ==========================================
local confirm = Instance.new("Frame")
confirm.Name = "ConfirmFrame"
confirm.Size = UDim2.new(0, 320, 0, 150)
confirm.Position = UDim2.new(0.5, -160, 0.5, -75)
confirm.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
confirm.BorderSizePixel = 0
confirm.Visible = false
confirm.ZIndex = 200
confirm.Parent = screenGui
Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 12)

local confirmGradient = createGlowStroke(confirm)
RunService.RenderStepped:Connect(function(dt)
    confirmGradient.Rotation = (confirmGradient.Rotation + dt * 150) % 360
end)

local confirmText = Instance.new("TextLabel")
confirmText.Size = UDim2.new(1, -20, 0, 60)
confirmText.Position = UDim2.new(0, 10, 0, 20)
confirmText.BackgroundTransparency = 1
confirmText.Text = "Are you sure you want to delete the menu?"
confirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmText.Font = Enum.Font.Gotham
confirmText.TextSize = 15
confirmText.TextWrapped = true
confirmText.ZIndex = 201
confirmText.Parent = confirm

local yesBtn = Instance.new("TextButton")
yesBtn.Size = UDim2.new(0, 110, 0, 35)
yesBtn.Position = UDim2.new(0, 30, 1, -55)
yesBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
yesBtn.Text = "Yes"
yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
yesBtn.Font = Enum.Font.GothamBold
yesBtn.TextSize = 14
yesBtn.AutoButtonColor = false
yesBtn.ZIndex = 201
yesBtn.Parent = confirm
Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 6)
addHover(yesBtn, Color3.fromRGB(60, 60, 60), Color3.fromRGB(200, 60, 60))

local noBtn = Instance.new("TextButton")
noBtn.Size = UDim2.new(0, 110, 0, 35)
noBtn.Position = UDim2.new(1, -140, 1, -55)
noBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
noBtn.Text = "No"
noBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noBtn.Font = Enum.Font.GothamBold
noBtn.TextSize = 14
noBtn.AutoButtonColor = false
noBtn.ZIndex = 201
noBtn.Parent = confirm
Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 6)
addHover(noBtn, Color3.fromRGB(60, 60, 60), Color3.fromRGB(100, 100, 100))

closeBtn.MouseButton1Click:Connect(function()
    confirm.Visible = true
end)

yesBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

noBtn.MouseButton1Click:Connect(function()
    confirm.Visible = false
end)

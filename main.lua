local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local LOGO_ID = "rbxassetid://79349549315565"

local oldMenu = playerGui:FindFirstChild("KDM_Menu")
if oldMenu then
    oldMenu:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KDM_Menu"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 100
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local connections = {}

local function track(connection)
    table.insert(connections, connection)
    return connection
end

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

local function createGlowStroke(parent)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Parent = parent

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(80, 80, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(80, 80, 80)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
    })
    gradient.Parent = stroke
    return gradient
end

local function addHover(button, normalColor, hoverColor)
    track(button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.18), {
            BackgroundColor3 = hoverColor
        }):Play()
    end))

    track(button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.18), {
            BackgroundColor3 = normalColor
        }):Play()
    end))
end

local function createLabel(parent, text, size, position, textSize)
    local label = Instance.new("TextLabel")
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = textSize or 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.ZIndex = 5
    label.Parent = parent
    return label
end

-- MAIN FRAME

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Size = UDim2.fromOffset(500, 360)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ZIndex = 1
mainFrame.Parent = screenGui

addCorner(mainFrame, 10)

local mainGradient = createGlowStroke(mainFrame)

-- TOP BAR

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
topBar.BorderSizePixel = 0
topBar.ZIndex = 10
topBar.Parent = mainFrame

addCorner(topBar, 10)

local topBarMask = Instance.new("Frame")
topBarMask.Size = UDim2.new(1, 0, 0, 10)
topBarMask.Position = UDim2.new(0, 0, 1, -10)
topBarMask.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
topBarMask.BorderSizePixel = 0
topBarMask.ZIndex = 10
topBarMask.Parent = topBar

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.fromOffset(28, 28)
logo.Position = UDim2.fromOffset(10, 6)
logo.BackgroundTransparency = 1
logo.Image = LOGO_ID
logo.ZIndex = 11
logo.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -135, 1, 0)
title.Position = UDim2.fromOffset(45, 0)
title.BackgroundTransparency = 1
title.Text = "KDM TEAM"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.ZIndex = 11
title.Parent = topBar

-- MINIMIZE BUTTON

local minBtn = Instance.new("TextButton")
minBtn.Name = "MinimizeButton"
minBtn.Size = UDim2.fromOffset(32, 26)
minBtn.Position = UDim2.new(1, -80, 0, 7)
minBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minBtn.Text = "—"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.AutoButtonColor = false
minBtn.ZIndex = 15
minBtn.Parent = topBar

addCorner(minBtn, 6)
addHover(minBtn, Color3.fromRGB(70, 70, 70), Color3.fromRGB(100, 100, 100))

-- CLOSE BUTTON

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.fromOffset(32, 26)
closeBtn.Position = UDim2.new(1, -42, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 15
closeBtn.Parent = topBar

addCorner(closeBtn, 6)
addHover(closeBtn, Color3.fromRGB(70, 70, 70), Color3.fromRGB(200, 60, 60))

-- DRAG MAIN MENU

local dragArea = Instance.new("TextButton")
dragArea.Name = "DragArea"
dragArea.Size = UDim2.new(1, -120, 1, 0)
dragArea.BackgroundTransparency = 1
dragArea.Text = ""
dragArea.Active = true
dragArea.ZIndex = 9
dragArea.Parent = topBar

local dragging = false
local dragStart = nil
local startPosition = nil
local dragInput = nil

track(dragArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = mainFrame.Position

        track(input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end))
    end
end))

track(dragArea.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end))

track(UserInputService.InputChanged:Connect(function(input)
    if dragging and dragInput and input == dragInput then
        local delta = input.Position - dragStart

        mainFrame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end))

-- TAB BAR

local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(0, 120, 1, -40)
tabBar.Position = UDim2.fromOffset(0, 40)
tabBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 2
tabBar.Parent = mainFrame

local tabList = Instance.new("UIListLayout")
tabList.Padding = UDim.new(0, 6)
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Parent = tabBar

local tabPadding = Instance.new("UIPadding")
tabPadding.PaddingTop = UDim.new(0, 10)
tabPadding.PaddingLeft = UDim.new(0, 8)
tabPadding.PaddingRight = UDim.new(0, 8)
tabPadding.Parent = tabBar

-- CONTENT

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -120, 1, -40)
content.Position = UDim2.fromOffset(120, 40)
content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
content.BorderSizePixel = 0
content.ZIndex = 1
content.ClipsDescendants = true
content.Parent = mainFrame

local tabs = {}
local tabButtons = {}

local order = {"intro", "main", "more", "settings"}

local displayNames = {
    intro = "Intro",
    main = "Main",
    more = "More",
    settings = "Settings"
}

local function createTab(name)
    local frame = Instance.new("ScrollingFrame")
    frame.Name = name .. "Tab"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 4
    frame.CanvasSize = UDim2.new(0, 0, 0, 280)
    frame.AutomaticCanvasSize = Enum.AutomaticSize.None
    frame.ScrollingDirection = Enum.ScrollingDirection.Y
    frame.Visible = false
    frame.ZIndex = 4
    frame.Parent = content

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 12)
    padding.PaddingBottom = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = frame

    tabs[name] = frame
end

for _, name in ipairs(order) do
    createTab(name)
end

-- SWITCH TAB

local function switchTab(name)
    if not tabs[name] or not tabButtons[name] then
        return
    end

    for _, frame in pairs(tabs) do
        frame.Visible = false
    end

    for _, button in pairs(tabButtons) do
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        button.TextColor3 = Color3.fromRGB(200, 200, 200)
    end

    tabs[name].Visible = true
    tabButtons[name].BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    tabButtons[name].TextColor3 = Color3.new(1, 1, 1)
end

for index, name in ipairs(order) do
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(1, 0, 0, 34)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = displayNames[name]
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.LayoutOrder = index
    button.AutoButtonColor = false
    button.ZIndex = 4
    button.Parent = tabBar

    addCorner(button, 6)
    addHover(button, Color3.fromRGB(50, 50, 50), Color3.fromRGB(80, 80, 80))

    tabButtons[name] = button

    track(button.Activated:Connect(function()
        switchTab(name)
    end))
end

-- INTRO TAB

local intro = tabs.intro

local bigImg = Instance.new("ImageLabel")
bigImg.Name = "IntroLogo"
bigImg.Size = UDim2.new(1, -24, 0, 150)
bigImg.Position = UDim2.fromOffset(12, 8)
bigImg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
bigImg.Image = LOGO_ID
bigImg.ScaleType = Enum.ScaleType.Fit
bigImg.ZIndex = 5
bigImg.Parent = intro

addCorner(bigImg, 6)

createLabel(
    intro,
    "This script is copyrighted by DEV KDM TEAM",
    UDim2.new(1, -24, 0, 24),
    UDim2.fromOffset(12, 168),
    12
).TextColor3 = Color3.fromRGB(255, 255, 255)

createLabel(
    intro,
    "Script to serve map: evade",
    UDim2.new(1, -24, 0, 24),
    UDim2.fromOffset(12, 198),
    13
)

createLabel(
    intro,
    "Version: 1.00",
    UDim2.new(1, -24, 0, 24),
    UDim2.fromOffset(12, 228),
    13
)

-- OTHER TABS

createLabel(
    tabs.main,
    "Main",
    UDim2.new(1, -24, 0, 30),
    UDim2.fromOffset(12, 8),
    18
).Font = Enum.Font.GothamBold

createLabel(
    tabs.main,
    "Khu vuc chuc nang Main.",
    UDim2.new(1, -24, 0, 30),
    UDim2.fromOffset(12, 45),
    13
)

createLabel(
    tabs.more,
    "More",
    UDim2.new(1, -24, 0, 30),
    UDim2.fromOffset(12, 8),
    18
).Font = Enum.Font.GothamBold

createLabel(
    tabs.more,
    "Khu vuc chuc nang mo rong.",
    UDim2.new(1, -24, 0, 30),
    UDim2.fromOffset(12, 45),
    13
)

createLabel(
    tabs.settings,
    "Settings",
    UDim2.new(1, -24, 0, 30),
    UDim2.fromOffset(12, 8),
    18
).Font = Enum.Font.GothamBold

createLabel(
    tabs.settings,
    "Khu vuc cai dat menu.",
    UDim2.new(1, -24, 0, 30),
    UDim2.fromOffset(12, 45),
    13
)

switchTab("intro")

-- LOGO OPEN MENU BUTTON (ĐÃ SỬA)

local circleBtn = Instance.new("ImageButton")
circleBtn.Name = "CircleBtn"
circleBtn.Size = UDim2.fromOffset(50, 50)
circleBtn.Position = UDim2.fromOffset(20, 100)
circleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
circleBtn.Image = LOGO_ID
circleBtn.ScaleType = Enum.ScaleType.Fit
circleBtn.Visible = false
circleBtn.Active = true
circleBtn.AutoButtonColor = false
circleBtn.ZIndex = 100
circleBtn.Parent = screenGui

addCorner(circleBtn, 25)

addHover(
    circleBtn,
    Color3.fromRGB(25, 25, 25),
    Color3.fromRGB(65, 65, 65)
)

local circleStroke = Instance.new("UIStroke")
circleStroke.Thickness = 1.5
circleStroke.Color = Color3.fromRGB(255, 255, 255)
circleStroke.Transparency = 0.15
circleStroke.Parent = circleBtn

-- DRAG LOGO BUTTON

local circleDragging = false
local circleMoved = false
local circleDragStart
local circleStartPosition
local circleDragInput

track(circleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        circleDragging = true
        circleMoved = false
        circleDragStart = input.Position
        circleStartPosition = circleBtn.Position
    end
end))

track(circleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        circleDragInput = input
    end
end))

track(UserInputService.InputChanged:Connect(function(input)
    if circleDragging and circleDragInput and input == circleDragInput then
        local delta = input.Position - circleDragStart

        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            circleMoved = true
        end

        circleBtn.Position = UDim2.new(
            circleStartPosition.X.Scale,
            circleStartPosition.X.Offset + delta.X,
            circleStartPosition.Y.Scale,
            circleStartPosition.Y.Offset + delta.Y
        )
    end
end))

track(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        if circleDragging and not circleMoved then
            mainFrame.Visible = true
            circleBtn.Visible = false
        end

        circleDragging = false
        circleDragInput = nil
    end
end))

-- MINIMIZE MENU

track(minBtn.Activated:Connect(function()
    local absolutePosition = mainFrame.AbsolutePosition

    circleBtn.Position = UDim2.fromOffset(
        math.clamp(
            absolutePosition.X,
            0,
            math.max(0, screenGui.AbsoluteSize.X - 50)
        ),
        math.clamp(
            absolutePosition.Y,
            0,
            math.max(0, screenGui.AbsoluteSize.Y - 50)
        )
    )

    mainFrame.Visible = false
    circleBtn.Visible = true
end))

-- CONFIRM FRAME

local confirm = Instance.new("Frame")
confirm.Name = "ConfirmFrame"
confirm.AnchorPoint = Vector2.new(0.5, 0.5)
confirm.Size = UDim2.fromOffset(320, 150)
confirm.Position = UDim2.new(0.5, 0, 0.5, 0)
confirm.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
confirm.BorderSizePixel = 0
confirm.Visible = false
confirm.ZIndex = 200
confirm.Parent = screenGui

addCorner(confirm, 8)
createGlowStroke(confirm)

local confirmText = Instance.new("TextLabel")
confirmText.Size = UDim2.new(1, -20, 0, 60)
confirmText.Position = UDim2.fromOffset(10, 15)
confirmText.BackgroundTransparency = 1
confirmText.Text = "Are you sure you want to close the menu?"
confirmText.TextColor3 = Color3.new(1, 1, 1)
confirmText.Font = Enum.Font.Gotham
confirmText.TextSize = 14
confirmText.TextWrapped = true
confirmText.ZIndex = 201
confirmText.Parent = confirm

-- YES BUTTON

local yesBtn = Instance.new("TextButton")
yesBtn.Size = UDim2.fromOffset(110, 35)
yesBtn.Position = UDim2.new(0, 30, 1, -50)
yesBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
yesBtn.Text = "Yes"
yesBtn.TextColor3 = Color3.new(1, 1, 1)
yesBtn.Font = Enum.Font.GothamBold
yesBtn.TextSize = 14
yesBtn.AutoButtonColor = false
yesBtn.ZIndex = 201
yesBtn.Parent = confirm

addCorner(yesBtn, 6)
addHover(yesBtn, Color3.fromRGB(60, 60, 60), Color3.fromRGB(200, 60, 60))

-- NO BUTTON

local noBtn = Instance.new("TextButton")
noBtn.Size = UDim2.fromOffset(110, 35)
noBtn.Position = UDim2.new(1, -140, 1, -50)
noBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
noBtn.Text = "No"
noBtn.TextColor3 = Color3.new(1, 1, 1)
noBtn.Font = Enum.Font.GothamBold
noBtn.TextSize = 14
noBtn.AutoButtonColor = false
noBtn.ZIndex = 201
noBtn.Parent = confirm

addCorner(noBtn, 6)
addHover(noBtn, Color3.fromRGB(60, 60, 60), Color3.fromRGB(100, 100, 100))

-- CLOSE CONFIRMATION

track(closeBtn.Activated:Connect(function()
    confirm.Visible = true
end))

track(yesBtn.Activated:Connect(function()
    screenGui:Destroy()
end))

track(noBtn.Activated:Connect(function()
    confirm.Visible = false
end))

-- RESPONSIVE MENU

local function fitMenu()
    local camera = workspace.CurrentCamera
    if not camera then
        return
    end

    local viewport = camera.ViewportSize

    local width = math.max(1, math.min(500, viewport.X - 24))
    local height = math.max(1, math.min(360, viewport.Y - 40))

    mainFrame.Size = UDim2.fromOffset(width, height)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
end

fitMenu()

if workspace.CurrentCamera then
    track(
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitMenu)
    )
end

-- ANIMATED BORDER

track(RunService.RenderStepped:Connect(function(dt)
    if screenGui.Parent then
        mainGradient.Rotation =
            (mainGradient.Rotation + dt * 150) % 360
    end
end))

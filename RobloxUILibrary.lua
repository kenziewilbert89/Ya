--[[
    CapybaraUI - Premium Roblox UI Library
    Inspired by the reference design with glass/frosted effect,
    dark blue theme, rounded corners, UIStroke, and smooth TweenService animations.

    API:
        local Library = CapybaraUI.new({...})
        local Window  = Library:CreateWindow({...})
        local Tab     = Window:CreateTab({...})
        local Section = Tab:CreateSection({...})
        Section:CreateLabel(...)
        Section:CreateParagraph(...)
        Section:CreateButton(...)
        Section:CreateToggle(...)
        Section:CreateSlider(...)
        Section:CreateTextbox(...)
        Section:CreateDropdown(...)
        Section:CreateKeybind(...)
        Section:CreateColorPicker(...)
        Section:CreateProgressBar(...)
        Section:CreateBadge(...)
        Section:CreateDivider(...)
        Library:Notify({...})
        Library:KeySystem({...})
--]]

-- ============================================================
-- SERVICES
-- ============================================================
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local CoreGui          = game:GetService("CoreGui")
local TextService      = game:GetService("TextService")

-- ============================================================
-- VARIABLES
-- ============================================================
local LocalPlayer  = Players.LocalPlayer
local Mouse        = LocalPlayer:GetMouse()
local ScreenGui    = Instance.new("ScreenGui")
local Camera       = workspace.CurrentCamera

ScreenGui.Name            = "CapybaraUI"
ScreenGui.ResetOnSpawn    = false
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder    = 999
ScreenGui.IgnoreGuiInset  = true

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ============================================================
-- THEME
-- ============================================================
local Theme = {
    -- Window
    WindowBG           = Color3.fromRGB(18, 24, 52),
    WindowBGTransp     = 0.08,
    WindowBorder       = Color3.fromRGB(80, 110, 200),
    WindowBorderTransp = 0.4,

    -- Top Bar
    TopBarBG           = Color3.fromRGB(22, 30, 68),
    TopBarText         = Color3.fromRGB(230, 235, 255),
    TopBarBorder       = Color3.fromRGB(70, 100, 190),

    -- Sidebar / Tab Panel
    SidebarBG          = Color3.fromRGB(25, 35, 78),
    SidebarBorder      = Color3.fromRGB(60, 90, 180),
    TabBG              = Color3.fromRGB(30, 42, 95),
    TabHoverBG         = Color3.fromRGB(45, 62, 130),
    TabActiveBG        = Color3.fromRGB(55, 80, 170),
    TabText            = Color3.fromRGB(180, 195, 240),
    TabActiveText      = Color3.fromRGB(255, 255, 255),
    TabBorder          = Color3.fromRGB(70, 100, 200),
    TabActiveBorder    = Color3.fromRGB(100, 150, 255),

    -- Sections
    SectionBG          = Color3.fromRGB(22, 32, 72),
    SectionBorder      = Color3.fromRGB(55, 80, 170),
    SectionHeader      = Color3.fromRGB(150, 175, 240),

    -- Components
    ComponentBG        = Color3.fromRGB(28, 40, 90),
    ComponentBorder    = Color3.fromRGB(60, 90, 190),
    ComponentHoverBG   = Color3.fromRGB(38, 55, 115),

    -- Button
    ButtonBG           = Color3.fromRGB(40, 65, 160),
    ButtonHoverBG      = Color3.fromRGB(55, 85, 190),
    ButtonPressedBG    = Color3.fromRGB(30, 50, 130),
    ButtonText         = Color3.fromRGB(230, 235, 255),
    ButtonBorder       = Color3.fromRGB(80, 120, 220),
    ButtonGlow         = Color3.fromRGB(100, 150, 255),

    -- Toggle
    ToggleOff          = Color3.fromRGB(40, 50, 100),
    ToggleOn           = Color3.fromRGB(80, 140, 255),
    ToggleKnob         = Color3.fromRGB(255, 255, 255),
    ToggleBorder       = Color3.fromRGB(70, 100, 200),

    -- Slider
    SliderTrack        = Color3.fromRGB(30, 40, 90),
    SliderFill         = Color3.fromRGB(80, 130, 255),
    SliderThumb        = Color3.fromRGB(255, 255, 255),
    SliderBorder       = Color3.fromRGB(60, 90, 180),

    -- Textbox
    TextboxBG          = Color3.fromRGB(20, 28, 65),
    TextboxFocusBG     = Color3.fromRGB(28, 40, 90),
    TextboxBorder      = Color3.fromRGB(60, 90, 180),
    TextboxFocusBorder = Color3.fromRGB(100, 150, 255),
    TextboxText        = Color3.fromRGB(210, 220, 255),
    TextboxPlaceholder = Color3.fromRGB(100, 120, 180),

    -- Dropdown
    DropdownBG         = Color3.fromRGB(20, 28, 65),
    DropdownOpenBG     = Color3.fromRGB(25, 35, 80),
    DropdownItemHover  = Color3.fromRGB(38, 55, 115),
    DropdownBorder     = Color3.fromRGB(60, 90, 180),
    DropdownText       = Color3.fromRGB(200, 215, 255),

    -- Text
    TextPrimary        = Color3.fromRGB(230, 235, 255),
    TextSecondary      = Color3.fromRGB(160, 180, 230),
    TextMuted          = Color3.fromRGB(100, 120, 180),
    TextAccent         = Color3.fromRGB(120, 180, 255),
    TextWarning        = Color3.fromRGB(255, 200, 80),
    TextError          = Color3.fromRGB(255, 90, 90),
    TextSuccess        = Color3.fromRGB(80, 220, 140),
    TextOwner          = Color3.fromRGB(255, 160, 60),

    -- Notification
    NotifBG            = Color3.fromRGB(20, 28, 65),
    NotifBorder        = Color3.fromRGB(60, 90, 180),
    NotifSuccess       = Color3.fromRGB(60, 200, 120),
    NotifWarning       = Color3.fromRGB(230, 180, 50),
    NotifError         = Color3.fromRGB(220, 70, 70),
    NotifInfo          = Color3.fromRGB(80, 140, 255),

    -- Keybind
    KeybindBG          = Color3.fromRGB(28, 40, 90),
    KeybindBorder      = Color3.fromRGB(60, 90, 190),
    KeybindText        = Color3.fromRGB(180, 200, 255),

    -- Progress Bar
    ProgressBG         = Color3.fromRGB(25, 35, 80),
    ProgressFill       = Color3.fromRGB(80, 140, 255),
    ProgressBorder     = Color3.fromRGB(55, 80, 170),

    -- Color Picker
    ColorPickerBorder  = Color3.fromRGB(60, 90, 180),

    -- Scrollbar
    ScrollbarBG        = Color3.fromRGB(25, 35, 80),
    ScrollbarThumb     = Color3.fromRGB(70, 100, 200),

    -- Ripple
    RippleColor        = Color3.fromRGB(255, 255, 255),
    RippleTransp       = 0.85,

    -- Fonts
    FontTitle          = Enum.Font.GothamBold,
    FontBody           = Enum.Font.Gotham,
    FontMono           = Enum.Font.Code,
    FontLight          = Enum.Font.GothamLight,

    -- Sizes
    CornerRadius       = UDim.new(0, 10),
    CornerRadiusSmall  = UDim.new(0, 6),
    CornerRadiusLarge  = UDim.new(0, 14),
    StrokeThickness    = 1.5,
    StrokeThicknessBold= 2,

    -- Animation
    TweenSpeed         = 0.22,
    TweenSpeedFast     = 0.12,
    TweenSpeedSlow     = 0.38,
    EaseInfo           = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    EaseInfoFast       = TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    EaseInfoSlow       = TweenInfo.new(0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    EaseInfoBounce     = TweenInfo.new(0.30, Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
    EaseInfoSine       = TweenInfo.new(0.22, Enum.EasingStyle.Sine,  Enum.EasingDirection.Out),
}

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================
local Utility = {}

function Utility.Create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

function Utility.AddCorner(parent, radius)
    return Utility.Create("UICorner", {
        CornerRadius = radius or Theme.CornerRadius,
        Parent = parent
    })
end

function Utility.AddStroke(parent, color, thickness, transparency)
    return Utility.Create("UIStroke", {
        Color       = color or Theme.WindowBorder,
        Thickness   = thickness or Theme.StrokeThickness,
        Transparency= transparency or Theme.WindowBorderTransp,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent      = parent
    })
end

function Utility.AddPadding(parent, top, right, bottom, left)
    return Utility.Create("UIPadding", {
        PaddingTop    = UDim.new(0, top    or 8),
        PaddingRight  = UDim.new(0, right  or 8),
        PaddingBottom = UDim.new(0, bottom or 8),
        PaddingLeft   = UDim.new(0, left   or 8),
        Parent        = parent
    })
end

function Utility.AddListLayout(parent, dir, align, padding, fillDir)
    return Utility.Create("UIListLayout", {
        FillDirection       = fillDir or Enum.FillDirection.Vertical,
        HorizontalAlignment = align   or Enum.HorizontalAlignment.Left,
        SortOrder           = Enum.SortOrder.LayoutOrder,
        Padding             = UDim.new(0, padding or 6),
        Parent              = parent
    })
end

function Utility.Tween(inst, props, tweenInfo)
    local tween = TweenService:Create(inst, tweenInfo or Theme.EaseInfo, props)
    tween:Play()
    return tween
end

function Utility.TweenFast(inst, props)
    return Utility.Tween(inst, props, Theme.EaseInfoFast)
end

function Utility.TweenSlow(inst, props)
    return Utility.Tween(inst, props, Theme.EaseInfoSlow)
end

function Utility.TweenBounce(inst, props)
    return Utility.Tween(inst, props, Theme.EaseInfoBounce)
end

function Utility.MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            frame.Position = newPos
        end
    end)
end

function Utility.Ripple(parent, x, y)
    local ripple = Utility.Create("Frame", {
        Size            = UDim2.new(0, 0, 0, 0),
        Position        = UDim2.new(0, x, 0, y),
        AnchorPoint     = Vector2.new(0.5, 0.5),
        BackgroundColor3= Theme.RippleColor,
        BackgroundTransparency = Theme.RippleTransp,
        ZIndex          = parent.ZIndex + 10,
        Parent          = parent
    })
    Utility.AddCorner(ripple, UDim.new(1, 0))
    local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.5
    Utility.Tween(ripple, {
        Size = UDim2.new(0, size, 0, size),
        BackgroundTransparency = 1
    }, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out))
    task.delay(0.6, function() ripple:Destroy() end)
end

function Utility.GetTextSize(text, size, font, bounds)
    bounds = bounds or Vector2.new(math.huge, math.huge)
    return TextService:GetTextSize(text, size, font, bounds)
end

function Utility.AutoScale(gui)
    local function update()
        local vp = Camera.ViewportSize
        local scale = math.clamp(math.min(vp.X / 1366, vp.Y / 768), 0.55, 1.2)
        local uiScale = gui:FindFirstChild("UIScale") or Instance.new("UIScale", gui)
        uiScale.Scale = scale
    end
    update()
    Camera:GetPropertyChangedSignal("ViewportSize"):Connect(update)
end

-- ============================================================
-- NOTIFICATION SYSTEM (global queue)
-- ============================================================
local NotificationQueue = {}
local NotificationHolder = Utility.Create("Frame", {
    Size            = UDim2.new(0, 320, 1, 0),
    Position        = UDim2.new(1, -330, 0, 0),
    BackgroundTransparency = 1,
    AnchorPoint     = Vector2.new(1, 0),
    Parent          = ScreenGui
})
Utility.AddListLayout(NotificationHolder, nil, Enum.HorizontalAlignment.Right, 10)
Utility.AddPadding(NotificationHolder, 12, 8, 12, 8)

local function ShowNotification(options)
    options = options or {}
    local title   = options.Title   or "Notification"
    local message = options.Message or ""
    local ntype   = options.Type    or "Info"
    local duration= options.Duration or 4

    local accentColor = Theme.NotifInfo
    if ntype == "Success" then accentColor = Theme.NotifSuccess
    elseif ntype == "Warning" then accentColor = Theme.NotifWarning
    elseif ntype == "Error" then accentColor = Theme.NotifError end

    local notifFrame = Utility.Create("Frame", {
        Size                  = UDim2.new(1, 0, 0, 0),
        BackgroundColor3      = Theme.NotifBG,
        BackgroundTransparency= 0.15,
        ClipsDescendants      = true,
        Parent                = NotificationHolder
    })
    Utility.AddCorner(notifFrame, Theme.CornerRadius)
    Utility.AddStroke(notifFrame, Theme.NotifBorder, 1.5, 0.4)

    -- Accent bar
    local accentBar = Utility.Create("Frame", {
        Size             = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = accentColor,
        BackgroundTransparency = 0,
        Parent           = notifFrame
    })
    Utility.AddCorner(accentBar, UDim.new(0, 2))

    local content = Utility.Create("Frame", {
        Size             = UDim2.new(1, -14, 1, 0),
        Position         = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Parent           = notifFrame
    })
    Utility.AddPadding(content, 10, 10, 10, 4)
    Utility.AddListLayout(content, nil, Enum.HorizontalAlignment.Left, 4)

    Utility.Create("TextLabel", {
        Size             = UDim2.new(1, 0, 0, 16),
        Text             = title,
        Font             = Theme.FontTitle,
        TextSize         = 13,
        TextColor3       = Theme.TextPrimary,
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = content
    })
    Utility.Create("TextLabel", {
        Size             = UDim2.new(1, 0, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        Text             = message,
        Font             = Theme.FontBody,
        TextSize         = 11,
        TextColor3       = Theme.TextSecondary,
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextWrapped      = true,
        Parent           = content
    })

    -- Progress bar
    local progressBG = Utility.Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 2),
        Position         = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = Theme.ProgressBG,
        Parent           = notifFrame
    })
    local progressFill = Utility.Create("Frame", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = accentColor,
        Parent           = progressBG
    })

    -- Animate in
    notifFrame.Size = UDim2.new(1, 0, 0, 0)
    notifFrame.BackgroundTransparency = 1
    Utility.Tween(notifFrame, { Size = UDim2.new(1, 0, 0, 72), BackgroundTransparency = 0.15 })

    -- Progress shrink
    task.delay(0.3, function()
        Utility.Tween(progressFill, { Size = UDim2.new(0, 0, 1, 0) },
            TweenInfo.new(duration - 0.3, Enum.EasingStyle.Linear))
    end)

    task.delay(duration, function()
        Utility.Tween(notifFrame, { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 })
        task.delay(0.3, function() notifFrame:Destroy() end)
    end)
end

-- ============================================================
-- LIBRARY CLASS
-- ============================================================
local CapybaraUI = {}
CapybaraUI.__index = CapybaraUI

function CapybaraUI.new(options)
    local self = setmetatable({}, CapybaraUI)
    options = options or {}
    self.Options = options
    self.Windows = {}
    self._saveData = {}
    Utility.AutoScale(ScreenGui)
    return self
end

function CapybaraUI:Notify(options)
    ShowNotification(options)
end

-- ============================================================
-- WINDOW
-- ============================================================
local Window = {}
Window.__index = Window

function CapybaraUI:CreateWindow(options)
    options = options or {}
    local self = setmetatable({}, Window)
    self.Options  = options
    self.Tabs     = {}
    self.ActiveTab= nil
    self._minimized = false
    self._maximized = false
    self._savedPos  = nil

    local title      = options.Title      or "CapybaraUI"
    local subtitle   = options.Subtitle   or ""
    local size       = options.Size       or UDim2.new(0, 620, 0, 420)
    local position   = options.Position   or UDim2.new(0.5, -310, 0.5, -210)
    local tabWidth   = options.TabWidth   or 145

    -- ---- Main Window Frame ----
    local mainFrame = Utility.Create("Frame", {
        Name                  = "Window",
        Size                  = UDim2.new(0, 0, 0, 0),
        Position              = position,
        BackgroundColor3      = Theme.WindowBG,
        BackgroundTransparency= Theme.WindowBGTransp,
        ClipsDescendants      = false,
        Parent                = ScreenGui
    })
    Utility.AddCorner(mainFrame, Theme.CornerRadiusLarge)
    Utility.AddStroke(mainFrame, Theme.WindowBorder, Theme.StrokeThicknessBold, Theme.WindowBorderTransp)
    self.MainFrame = mainFrame

    -- Blur / Glass Effect via ImageLabel
    local blurOverlay = Utility.Create("ImageLabel", {
        Size  = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.WindowBG,
        BackgroundTransparency = 0.55,
        Image = "",
        ZIndex = 0,
        Parent = mainFrame
    })
    Utility.AddCorner(blurOverlay, Theme.CornerRadiusLarge)

    -- ---- Top Bar ----
    local topBar = Utility.Create("Frame", {
        Name             = "TopBar",
        Size             = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.TopBarBG,
        BackgroundTransparency = 0.1,
        ZIndex           = 5,
        Parent           = mainFrame
    })
    Utility.AddCorner(topBar, Theme.CornerRadiusLarge)
    Utility.AddStroke(topBar, Theme.TopBarBorder, 1, 0.55)

    -- Fix bottom corners of topbar
    Utility.Create("Frame", {
        Size             = UDim2.new(1, 0, 0.5, 0),
        Position         = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = Theme.TopBarBG,
        BackgroundTransparency = 0.1,
        BorderSizePixel  = 0,
        ZIndex           = 4,
        Parent           = topBar
    })

    -- Title
    Utility.Create("TextLabel", {
        Name             = "Title",
        Size             = UDim2.new(1, -100, 1, 0),
        Position         = UDim2.new(0, 12, 0, 0),
        Text             = title .. (subtitle ~= "" and ("  ·  " .. subtitle) or ""),
        Font             = Theme.FontTitle,
        TextSize         = 14,
        TextColor3       = Theme.TopBarText,
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 6,
        Parent           = topBar
    })

    -- Window Controls
    local controlsFrame = Utility.Create("Frame", {
        Size             = UDim2.new(0, 84, 0, 24),
        Position         = UDim2.new(1, -92, 0.5, -12),
        BackgroundTransparency = 1,
        ZIndex           = 6,
        Parent           = topBar
    })
    Utility.AddListLayout(controlsFrame, Enum.FillDirection.Horizontal,
        Enum.HorizontalAlignment.Right, 4)

    local function makeCtrlBtn(color, symbol, zIdx)
        local btn = Utility.Create("TextButton", {
            Size             = UDim2.new(0, 22, 0, 22),
            BackgroundColor3 = color,
            BackgroundTransparency = 0.25,
            Text             = symbol,
            Font             = Theme.FontTitle,
            TextSize         = 11,
            TextColor3       = Color3.fromRGB(255,255,255),
            ZIndex           = zIdx or 7,
            Parent           = controlsFrame
        })
        Utility.AddCorner(btn, UDim.new(1, 0))
        return btn
    end

    local closeBtn    = makeCtrlBtn(Color3.fromRGB(220, 70,  70),  "×")
    local maxBtn      = makeCtrlBtn(Color3.fromRGB(50,  190, 100), "□")
    local minBtn      = makeCtrlBtn(Color3.fromRGB(230, 175, 45),  "–")

    -- ---- Body ----
    local bodyFrame = Utility.Create("Frame", {
        Name             = "Body",
        Size             = UDim2.new(1, 0, 1, -36),
        Position         = UDim2.new(0, 0, 0, 36),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex           = 3,
        Parent           = mainFrame
    })

    -- ---- Tab Sidebar ----
    local sidebar = Utility.Create("Frame", {
        Name             = "Sidebar",
        Size             = UDim2.new(0, tabWidth, 1, 0),
        Position         = UDim2.new(1, -tabWidth, 0, 0),
        BackgroundColor3 = Theme.SidebarBG,
        BackgroundTransparency = 0.12,
        ZIndex           = 4,
        Parent           = bodyFrame
    })
    Utility.AddCorner(sidebar, UDim.new(0, 10))
    Utility.AddStroke(sidebar, Theme.SidebarBorder, 1, 0.5)

    local sidebarList = Utility.Create("ScrollingFrame", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.ScrollbarThumb,
        ZIndex           = 5,
        Parent           = sidebar
    })
    Utility.AddPadding(sidebarList, 8, 6, 8, 6)
    local sidebarLayout = Utility.AddListLayout(sidebarList, nil, Enum.HorizontalAlignment.Center, 5)

    -- ---- Content Area ----
    local contentFrame = Utility.Create("Frame", {
        Name             = "Content",
        Size             = UDim2.new(1, -tabWidth - 4, 1, -4),
        Position         = UDim2.new(0, 4, 0, 2),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex           = 3,
        Parent           = bodyFrame
    })

    -- ---- Info Panel (left of content, optional) ----
    -- Will be populated by tabs

    self.Sidebar       = sidebar
    self.SidebarList   = sidebarList
    self.ContentFrame  = contentFrame
    self.TabWidth      = tabWidth

    -- ---- Draggable ----
    Utility.MakeDraggable(mainFrame, topBar)

    -- ---- Resizable ----
    local resizeHandle = Utility.Create("TextButton", {
        Size             = UDim2.new(0, 16, 0, 16),
        Position         = UDim2.new(1, -16, 1, -16),
        BackgroundColor3 = Theme.WindowBorder,
        BackgroundTransparency = 0.7,
        Text             = "",
        ZIndex           = 10,
        Parent           = mainFrame
    })
    Utility.AddCorner(resizeHandle, UDim.new(0, 3))

    do
        local resizing, startPos, startSize = false, nil, nil
        resizeHandle.MouseButton1Down:Connect(function()
            resizing  = true
            startPos  = UserInputService:GetMouseLocation()
            startSize = mainFrame.AbsoluteSize
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = UserInputService:GetMouseLocation() - startPos
                local newW  = math.clamp(startSize.X + delta.X, 420, 900)
                local newH  = math.clamp(startSize.Y + delta.Y, 280, 700)
                mainFrame.Size = UDim2.new(0, newW, 0, newH)
            end
        end)
    end

    -- ---- Controls ----
    closeBtn.MouseButton1Click:Connect(function()
        Utility.Ripple(closeBtn, closeBtn.AbsoluteSize.X/2, closeBtn.AbsoluteSize.Y/2)
        Utility.TweenFast(mainFrame, { Size = UDim2.new(0, 0, 0, 0) })
        task.delay(0.15, function() mainFrame:Destroy() end)
    end)

    minBtn.MouseButton1Click:Connect(function()
        Utility.Ripple(minBtn, minBtn.AbsoluteSize.X/2, minBtn.AbsoluteSize.Y/2)
        if self._minimized then
            Utility.Tween(mainFrame, { Size = size })
            Utility.Tween(bodyFrame, { Size = UDim2.new(1, 0, 1, -36) })
            self._minimized = false
        else
            Utility.Tween(mainFrame, { Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 36) })
            self._minimized = true
        end
    end)

    maxBtn.MouseButton1Click:Connect(function()
        Utility.Ripple(maxBtn, maxBtn.AbsoluteSize.X/2, maxBtn.AbsoluteSize.Y/2)
        if self._maximized then
            Utility.Tween(mainFrame, { Size = size, Position = position })
            self._maximized = false
        else
            self._savedPos = mainFrame.Position
            local vp = Camera.ViewportSize
            Utility.Tween(mainFrame, {
                Size     = UDim2.new(0, vp.X - 20, 0, vp.Y - 20),
                Position = UDim2.new(0, 10, 0, 10)
            })
            self._maximized = true
        end
    end)

    -- Hover effects for controls
    for _, btn in ipairs({closeBtn, minBtn, maxBtn}) do
        btn.MouseEnter:Connect(function()
            Utility.TweenFast(btn, { BackgroundTransparency = 0 })
        end)
        btn.MouseLeave:Connect(function()
            Utility.TweenFast(btn, { BackgroundTransparency = 0.25 })
        end)
    end

    -- ---- Open Animation ----
    Utility.TweenBounce(mainFrame, { Size = size })

    return self
end

function Window:CreateTab(options)
    options = options or {}
    local self_win = self
    local tabLabel = options.Label or ("Tab " .. #self_win.Tabs + 1)
    local tabIcon  = options.Icon  or ""

    -- Tab button in sidebar
    local tabBtn = Utility.Create("TextButton", {
        Name             = tabLabel,
        Size             = UDim2.new(1, -4, 0, 48),
        BackgroundColor3 = Theme.TabBG,
        BackgroundTransparency = 0.15,
        Text             = "",
        ZIndex           = 6,
        Parent           = self_win.SidebarList
    })
    Utility.AddCorner(tabBtn, Theme.CornerRadius)
    local tabStroke = Utility.AddStroke(tabBtn, Theme.TabBorder, 1, 0.6)

    local tabContent = Utility.Create("Frame", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex           = 7,
        Parent           = tabBtn
    })
    Utility.AddPadding(tabContent, 6, 8, 6, 10)
    Utility.AddListLayout(tabContent, Enum.FillDirection.Horizontal,
        Enum.HorizontalAlignment.Left, 8)

    -- Icon
    local iconLabel = Utility.Create("TextLabel", {
        Size             = UDim2.new(0, 22, 1, 0),
        Text             = tabIcon,
        Font             = Theme.FontTitle,
        TextSize         = 18,
        TextColor3       = Theme.TabText,
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Center,
        ZIndex           = 7,
        Parent           = tabContent
    })

    local nameLabel = Utility.Create("TextLabel", {
        Size             = UDim2.new(1, -30, 1, 0),
        Text             = tabLabel,
        Font             = Theme.FontBody,
        TextSize         = 13,
        TextColor3       = Theme.TabText,
        BackgroundTransparency = 1,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 7,
        Parent           = tabContent
    })

    -- Tab content scroll frame
    local tabPage = Utility.Create("ScrollingFrame", {
        Name             = tabLabel .. "_Page",
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.ScrollbarThumb,
        Visible          = false,
        ZIndex           = 3,
        Parent           = self_win.ContentFrame
    })
    Utility.AddPadding(tabPage, 8, 8, 8, 8)
    local pageLayout = Utility.AddListLayout(tabPage, nil, Enum.HorizontalAlignment.Left, 8)
    tabPage:GetPropertyChangedSignal("AbsoluteContentSize") and nil
    pageLayout.Changed:Connect(function()
        tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 16)
    end)

    -- Activate tab
    local function activate()
        -- Deactivate all
        for _, t in ipairs(self_win.Tabs) do
            Utility.Tween(t.Button, { BackgroundColor3 = Theme.TabBG, BackgroundTransparency = 0.15 })
            Utility.Tween(t.Stroke, { Transparency = 0.6 })
            Utility.Tween(t.IconLabel,  { TextColor3 = Theme.TabText })
            Utility.Tween(t.NameLabel,  { TextColor3 = Theme.TabText })
            t.Page.Visible = false
        end
        -- Activate this
        Utility.Tween(tabBtn, { BackgroundColor3 = Theme.TabActiveBG, BackgroundTransparency = 0.05 })
        Utility.Tween(tabStroke, { Color = Theme.TabActiveBorder, Transparency = 0.2 })
        Utility.Tween(iconLabel, { TextColor3 = Theme.TabActiveText })
        Utility.Tween(nameLabel, { TextColor3 = Theme.TabActiveText })
        tabPage.Visible = true
        tabPage.Position = UDim2.new(0.05, 0, 0, 0)
        tabPage.BackgroundTransparency = 1
        Utility.Tween(tabPage, { Position = UDim2.new(0, 0, 0, 0) })
        self_win.ActiveTab = #self_win.Tabs
    end

    tabBtn.MouseEnter:Connect(function()
        if self_win.Tabs[self_win.ActiveTab] and self_win.Tabs[self_win.ActiveTab].Button ~= tabBtn then
            Utility.TweenFast(tabBtn, { BackgroundColor3 = Theme.TabHoverBG, BackgroundTransparency = 0.1 })
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if self_win.Tabs[self_win.ActiveTab] and self_win.Tabs[self_win.ActiveTab].Button ~= tabBtn then
            Utility.TweenFast(tabBtn, { BackgroundColor3 = Theme.TabBG, BackgroundTransparency = 0.15 })
        end
    end)
    tabBtn.MouseButton1Click:Connect(function()
        Utility.Ripple(tabBtn,
            Mouse.X - tabBtn.AbsolutePosition.X,
            Mouse.Y - tabBtn.AbsolutePosition.Y)
        activate()
    end)

    local tabObj = {
        Button    = tabBtn,
        Page      = tabPage,
        Stroke    = tabStroke,
        IconLabel = iconLabel,
        NameLabel = nameLabel,
        Sections  = {},
        Activate  = activate,
    }
    table.insert(self_win.Tabs, tabObj)

    -- Auto-activate first tab
    if #self_win.Tabs == 1 then
        task.defer(activate)
    end

    -- Update sidebar canvas
    task.defer(function()
        local layout = self_win.SidebarList:FindFirstChildOfClass("UIListLayout")
        if layout then
            self_win.SidebarList.CanvasSize = UDim2.new(0, 0, 0,
                layout.AbsoluteContentSize.Y + 16)
        end
    end)

    -- Section API
    local Tab = {}
    Tab.__index = Tab
    local tabMeta = setmetatable({}, Tab)

    function tabMeta:CreateSection(options2)
        options2 = options2 or {}
        local sectionLabel = options2.Label    or "Section"
        local collapsed    = options2.Collapsed or false

        local sectionFrame = Utility.Create("Frame", {
            Name             = sectionLabel,
            Size             = UDim2.new(1, 0, 0, 0),
            AutomaticSize    = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme.SectionBG,
            BackgroundTransparency = 0.18,
            ZIndex           = 4,
            Parent           = tabPage
        })
        Utility.AddCorner(sectionFrame, Theme.CornerRadius)
        Utility.AddStroke(sectionFrame, Theme.SectionBorder, 1, 0.5)

        local sectionInner = Utility.Create("Frame", {
            Size             = UDim2.new(1, 0, 0, 0),
            AutomaticSize    = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            ZIndex           = 4,
            Parent           = sectionFrame
        })

        -- Header
        local headerBtn = Utility.Create("TextButton", {
            Size             = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1,
            Text             = "",
            ZIndex           = 5,
            Parent           = sectionInner
        })

        Utility.Create("TextLabel", {
            Size             = UDim2.new(1, -40, 1, 0),
            Position         = UDim2.new(0, 12, 0, 0),
            Text             = sectionLabel,
            Font             = Theme.FontTitle,
            TextSize         = 12,
            TextColor3       = Theme.SectionHeader,
            BackgroundTransparency = 1,
            TextXAlignment   = Enum.TextXAlignment.Left,
            ZIndex           = 5,
            Parent           = headerBtn
        })

        local chevron = Utility.Create("TextLabel", {
            Size             = UDim2.new(0, 20, 1, 0),
            Position         = UDim2.new(1, -28, 0, 0),
            Text             = "▾",
            Font             = Theme.FontTitle,
            TextSize         = 14,
            TextColor3       = Theme.SectionHeader,
            BackgroundTransparency = 1,
            TextXAlignment   = Enum.TextXAlignment.Center,
            ZIndex           = 5,
            Parent           = headerBtn
        })

        -- Divider under header
        Utility.Create("Frame", {
            Size             = UDim2.new(1, -16, 0, 1),
            Position         = UDim2.new(0, 8, 0, 32),
            BackgroundColor3 = Theme.SectionBorder,
            BackgroundTransparency = 0.6,
            ZIndex           = 5,
            Parent           = sectionInner
        })

        -- Components container
        local compContainer = Utility.Create("Frame", {
            Size             = UDim2.new(1, 0, 0, 0),
            Position         = UDim2.new(0, 0, 0, 33),
            AutomaticSize    = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            ZIndex           = 4,
            ClipsDescendants = false,
            Parent           = sectionInner
        })
        Utility.AddPadding(compContainer, 6, 10, 8, 10)
        Utility.AddListLayout(compContainer, nil, Enum.HorizontalAlignment.Left, 6)

        -- Collapse toggle
        local isCollapsed = collapsed
        local function setCollapsed(c)
            isCollapsed = c
            if c then
                Utility.Tween(chevron, { Rotation = -90 })
                compContainer.Visible = false
            else
                Utility.Tween(chevron, { Rotation = 0 })
                compContainer.Visible = true
            end
        end
        setCollapsed(isCollapsed)

        headerBtn.MouseButton1Click:Connect(function()
            setCollapsed(not isCollapsed)
        end)

        -- Section object (component creators)
        local Section = {}
        Section.__index = Section
        local sectionObj = setmetatable({}, Section)

        -- ---- Helper: Component Row ----
        local function makeRow(labelText, height)
            height = height or 34
            local row = Utility.Create("Frame", {
                Size             = UDim2.new(1, 0, 0, height),
                BackgroundTransparency = 1,
                ZIndex           = 5,
                Parent           = compContainer
            })
            if labelText and labelText ~= "" then
                Utility.Create("TextLabel", {
                    Size             = UDim2.new(0.5, 0, 1, 0),
                    Text             = labelText,
                    Font             = Theme.FontBody,
                    TextSize         = 12,
                    TextColor3       = Theme.TextSecondary,
                    BackgroundTransparency = 1,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    ZIndex           = 5,
                    Parent           = row
                })
            end
            return row
        end

        -- ---- DIVIDER ----
        function sectionObj:CreateDivider()
            Utility.Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = Theme.SectionBorder,
                BackgroundTransparency = 0.5,
                ZIndex           = 5,
                Parent           = compContainer
            })
        end

        -- ---- LABEL ----
        function sectionObj:CreateLabel(text, color)
            Utility.Create("TextLabel", {
                Size             = UDim2.new(1, 0, 0, 20),
                Text             = text or "Label",
                Font             = Theme.FontBody,
                TextSize         = 12,
                TextColor3       = color or Theme.TextSecondary,
                BackgroundTransparency = 1,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 5,
                Parent           = compContainer
            })
        end

        -- ---- PARAGRAPH ----
        function sectionObj:CreateParagraph(options3)
            options3 = options3 or {}
            local container = Utility.Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.ComponentBG,
                BackgroundTransparency = 0.2,
                ZIndex           = 5,
                Parent           = compContainer
            })
            Utility.AddCorner(container, Theme.CornerRadiusSmall)
            Utility.AddPadding(container, 8, 10, 8, 10)
            Utility.AddListLayout(container, nil, Enum.HorizontalAlignment.Left, 4)
            Utility.Create("TextLabel", {
                Size             = UDim2.new(1, 0, 0, 16),
                Text             = options3.Title or "Paragraph",
                Font             = Theme.FontTitle,
                TextSize         = 12,
                TextColor3       = Theme.TextPrimary,
                BackgroundTransparency = 1,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 5,
                Parent           = container
            })
            Utility.Create("TextLabel", {
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                Text             = options3.Content or "",
                Font             = Theme.FontBody,
                TextSize         = 11,
                TextColor3       = Theme.TextSecondary,
                BackgroundTransparency = 1,
                TextXAlignment   = Enum.TextXAlignment.Left,
                TextWrapped      = true,
                ZIndex           = 5,
                Parent           = container
            })
        end

        -- ---- BADGE ----
        function sectionObj:CreateBadge(options3)
            options3 = options3 or {}
            local btext = options3.Text  or "Badge"
            local bcolor= options3.Color or Theme.ButtonBG
            local badge = Utility.Create("Frame", {
                Size             = UDim2.new(0, 0, 0, 20),
                AutomaticSize    = Enum.AutomaticSize.X,
                BackgroundColor3 = bcolor,
                BackgroundTransparency = 0.2,
                ZIndex           = 5,
                Parent           = compContainer
            })
            Utility.AddCorner(badge, UDim.new(1, 0))
            Utility.AddPadding(badge, 0, 10, 0, 10)
            Utility.Create("TextLabel", {
                Size             = UDim2.new(0, 0, 1, 0),
                AutomaticSize    = Enum.AutomaticSize.X,
                Text             = btext,
                Font             = Theme.FontTitle,
                TextSize         = 10,
                TextColor3       = Color3.fromRGB(255,255,255),
                BackgroundTransparency = 1,
                ZIndex           = 5,
                Parent           = badge
            })
        end

        -- ---- BUTTON ----
        function sectionObj:CreateButton(options3)
            options3 = options3 or {}
            local btnLabel    = options3.Label    or "Button"
            local btnCallback = options3.Callback or function() end

            local btn = Utility.Create("TextButton", {
                Size             = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Theme.ButtonBG,
                BackgroundTransparency = 0.05,
                Text             = btnLabel,
                Font             = Theme.FontTitle,
                TextSize         = 13,
                TextColor3       = Theme.ButtonText,
                ZIndex           = 5,
                Parent           = compContainer
            })
            Utility.AddCorner(btn, Theme.CornerRadiusSmall)
            Utility.AddStroke(btn, Theme.ButtonBorder, 1, 0.5)

            btn.MouseEnter:Connect(function()
                Utility.TweenFast(btn, { BackgroundColor3 = Theme.ButtonHoverBG, BackgroundTransparency = 0 })
            end)
            btn.MouseLeave:Connect(function()
                Utility.TweenFast(btn, { BackgroundColor3 = Theme.ButtonBG, BackgroundTransparency = 0.05 })
            end)
            btn.MouseButton1Down:Connect(function()
                Utility.TweenFast(btn, { BackgroundColor3 = Theme.ButtonPressedBG })
                Utility.Ripple(btn,
                    Mouse.X - btn.AbsolutePosition.X,
                    Mouse.Y - btn.AbsolutePosition.Y)
            end)
            btn.MouseButton1Up:Connect(function()
                Utility.TweenFast(btn, { BackgroundColor3 = Theme.ButtonHoverBG })
            end)
            btn.MouseButton1Click:Connect(function()
                pcall(btnCallback)
            end)

            local btnObj = {}
            function btnObj:SetLabel(t) btn.Text = t end
            return btnObj
        end

        -- ---- TOGGLE ----
        function sectionObj:CreateToggle(options3)
            options3 = options3 or {}
            local togLabel    = options3.Label    or "Toggle"
            local togDefault  = options3.Default  or false
            local togCallback = options3.Callback or function() end
            local togValue    = togDefault

            local row = makeRow(togLabel, 34)

            local trackFrame = Utility.Create("Frame", {
                Size             = UDim2.new(0, 46, 0, 24),
                Position         = UDim2.new(1, -50, 0.5, -12),
                BackgroundColor3 = togValue and Theme.ToggleOn or Theme.ToggleOff,
                ZIndex           = 6,
                Parent           = row
            })
            Utility.AddCorner(trackFrame, UDim.new(1, 0))
            Utility.AddStroke(trackFrame, Theme.ToggleBorder, 1, 0.4)

            local knob = Utility.Create("Frame", {
                Size             = UDim2.new(0, 18, 0, 18),
                Position         = togValue
                    and UDim2.new(1, -21, 0.5, -9)
                    or  UDim2.new(0, 3,   0.5, -9),
                BackgroundColor3 = Theme.ToggleKnob,
                ZIndex           = 7,
                Parent           = trackFrame
            })
            Utility.AddCorner(knob, UDim.new(1, 0))

            local toggleBtn = Utility.Create("TextButton", {
                Size             = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text             = "",
                ZIndex           = 8,
                Parent           = trackFrame
            })

            local function setToggle(val)
                togValue = val
                Utility.Tween(trackFrame, {
                    BackgroundColor3 = val and Theme.ToggleOn or Theme.ToggleOff
                })
                Utility.Tween(knob, {
                    Position = val and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                })
                pcall(togCallback, val)
            end

            toggleBtn.MouseButton1Click:Connect(function()
                setToggle(not togValue)
            end)

            local togObj = {}
            function togObj:SetValue(val) setToggle(val) end
            function togObj:GetValue() return togValue end
            return togObj
        end

        -- ---- SLIDER ----
        function sectionObj:CreateSlider(options3)
            options3 = options3 or {}
            local sldLabel    = options3.Label    or "Slider"
            local sldMin      = options3.Min      or 0
            local sldMax      = options3.Max      or 100
            local sldDefault  = options3.Default  or sldMin
            local sldStep     = options3.Step     or 1
            local sldSuffix   = options3.Suffix   or ""
            local sldCallback = options3.Callback or function() end
            local sldValue    = sldDefault

            local container = Utility.Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 50),
                BackgroundTransparency = 1,
                ZIndex           = 5,
                Parent           = compContainer
            })

            Utility.Create("TextLabel", {
                Size             = UDim2.new(1, -60, 0, 18),
                Text             = sldLabel,
                Font             = Theme.FontBody,
                TextSize         = 12,
                TextColor3       = Theme.TextSecondary,
                BackgroundTransparency = 1,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 5,
                Parent           = container
            })

            local valueLabel = Utility.Create("TextLabel", {
                Size             = UDim2.new(0, 60, 0, 18),
                Position         = UDim2.new(1, -60, 0, 0),
                Text             = tostring(sldValue) .. sldSuffix,
                Font             = Theme.FontTitle,
                TextSize         = 12,
                TextColor3       = Theme.TextAccent,
                BackgroundTransparency = 1,
                TextXAlignment   = Enum.TextXAlignment.Right,
                ZIndex           = 5,
                Parent           = container
            })

            local track = Utility.Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 8),
                Position         = UDim2.new(0, 0, 0, 24),
                BackgroundColor3 = Theme.SliderTrack,
                ZIndex           = 5,
                Parent           = container
            })
            Utility.AddCorner(track, UDim.new(1, 0))
            Utility.AddStroke(track, Theme.SliderBorder, 1, 0.5)

            local fill = Utility.Create("Frame", {
                Size             = UDim2.new(
                    (sldValue - sldMin) / (sldMax - sldMin), 0, 1, 0),
                BackgroundColor3 = Theme.SliderFill,
                ZIndex           = 6,
                Parent           = track
            })
            Utility.AddCorner(fill, UDim.new(1, 0))

            local thumb = Utility.Create("Frame", {
                Size             = UDim2.new(0, 14, 0, 14),
                Position         = UDim2.new(
                    (sldValue - sldMin) / (sldMax - sldMin), -7, 0.5, -7),
                BackgroundColor3 = Theme.SliderThumb,
                ZIndex           = 7,
                Parent           = track
            })
            Utility.AddCorner(thumb, UDim.new(1, 0))
            Utility.AddStroke(thumb, Theme.SliderFill, 2, 0)

            local dragging = false
            local function updateSlider(x)
                local rel   = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local raw   = sldMin + rel * (sldMax - sldMin)
                local stepped = math.round(raw / sldStep) * sldStep
                stepped = math.clamp(stepped, sldMin, sldMax)
                sldValue = stepped
                local fillScale = (sldValue - sldMin) / (sldMax - sldMin)
                Utility.TweenFast(fill,  { Size = UDim2.new(fillScale, 0, 1, 0) })
                Utility.TweenFast(thumb, { Position = UDim2.new(fillScale, -7, 0.5, -7) })
                valueLabel.Text = tostring(sldValue) .. sldSuffix
                pcall(sldCallback, sldValue)
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (
                    input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch
                ) then
                    updateSlider(input.Position.X)
                end
            end)

            local sldObj = {}
            function sldObj:SetValue(v)
                sldValue = math.clamp(v, sldMin, sldMax)
                local fillScale = (sldValue - sldMin) / (sldMax - sldMin)
                Utility.TweenFast(fill,  { Size = UDim2.new(fillScale, 0, 1, 0) })
                Utility.TweenFast(thumb, { Position = UDim2.new(fillScale, -7, 0.5, -7) })
                valueLabel.Text = tostring(sldValue) .. sldSuffix
            end
            function sldObj:GetValue() return sldValue end
            return sldObj
        end

        -- ---- TEXTBOX ----
        function sectionObj:CreateTextbox(options3)
            options3 = options3 or {}
            local tbLabel       = options3.Label       or "Textbox"
            local tbPlaceholder = options3.Placeholder or "Type here..."
            local tbDefault     = options3.Default     or ""
            local tbCallback    = options3.Callback    or function() end
            local tbClearOnFocus= options3.ClearOnFocus ~= false

            local container = Utility.Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 52),
                BackgroundTransparency = 1,
                ZIndex           = 5,
                Parent           = compContainer
            })

            Utility.Create("TextLabel", {
                Size             = UDim2.new(1, 0, 0, 16),
                Text             = tbLabel,
                Font             = Theme.FontBody,
                TextSize         = 12,
                TextColor3       = Theme.TextSecondary,
                BackgroundTransparency = 1,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 5,
                Parent           = container
            })

            local inputFrame = Utility.Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 30),
                Position         = UDim2.new(0, 0, 0, 18),
                BackgroundColor3 = Theme.TextboxBG,
                BackgroundTransparency = 0.1,
                ZIndex           = 5,
                Parent           = container
            })
            Utility.AddCorner(inputFrame, Theme.CornerRadiusSmall)
            local inputStroke = Utility.AddStroke(inputFrame, Theme.TextboxBorder, 1, 0.4)

            local textbox = Utility.Create("TextBox", {
                Size             = UDim2.new(1, -32, 1, 0),
                Position         = UDim2.new(0, 8, 0, 0),
                Text             = tbDefault,
                PlaceholderText  = tbPlaceholder,
                PlaceholderColor3= Theme.TextboxPlaceholder,
                Font             = Theme.FontBody,
                TextSize         = 12,
                TextColor3       = Theme.TextboxText,
                BackgroundTransparency = 1,
                ClearTextOnFocus = tbClearOnFocus,
                ZIndex           = 6,
                Parent           = inputFrame
            })

            -- Clear button
            local clearBtn = Utility.Create("TextButton", {
                Size             = UDim2.new(0, 24, 0, 24),
                Position         = UDim2.new(1, -28, 0.5, -12),
                Text             = "×",
                Font             = Theme.FontTitle,
                TextSize         = 16,
                TextColor3       = Theme.TextMuted,
                BackgroundTransparency = 1,
                ZIndex           = 6,
                Parent           = inputFrame
            })
            clearBtn.MouseButton1Click:Connect(function()
                textbox.Text = ""
            end)

            textbox.Focused:Connect(function()
                Utility.TweenFast(inputFrame, { BackgroundColor3 = Theme.TextboxFocusBG })
                Utility.TweenFast(inputStroke, { Color = Theme.TextboxFocusBorder, Transparency = 0.1 })
            end)
            textbox.FocusLost:Connect(function(enter)
                Utility.TweenFast(inputFrame, { BackgroundColor3 = Theme.TextboxBG })
                Utility.TweenFast(inputStroke, { Color = Theme.TextboxBorder, Transparency = 0.4 })
                pcall(tbCallback, textbox.Text, enter)
            end)

            local tbObj = {}
            function tbObj:SetValue(t) textbox.Text = t end
            function tbObj:GetValue()  return textbox.Text end
            return tbObj
        end

        -- ---- DROPDOWN ----
        function sectionObj:CreateDropdown(options3)
            options3 = options3 or {}
            local ddLabel    = options3.Label    or "Dropdown"
            local ddItems    = options3.Items    or {}
            local ddDefault  = options3.Default  or nil
            local ddMulti    = options3.Multi    or false
            local ddCallback = options3.Callback or function() end
            local ddSelected = ddDefault and {ddDefault} or {}
            local ddOpen     = false

            local outerFrame = Utility.Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 52),
                BackgroundTransparency = 1,
                ZIndex           = 5,
                ClipsDescendants = false,
                Parent           = compContainer
            })

            Utility.Create("TextLabel", {
                Size             = UDim2.new(1, 0, 0, 16),
                Text             = ddLabel,
                Font             = Theme.FontBody,
                TextSize         = 12,
                TextColor3       = Theme.TextSecondary,
                BackgroundTransparency = 1,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 5,
                Parent           = outerFrame
            })

            local ddFrame = Utility.Create("TextButton", {
                Size             = UDim2.new(1, 0, 0, 30),
                Position         = UDim2.new(0, 0, 0, 18),
                BackgroundColor3 = Theme.DropdownBG,
                BackgroundTransparency = 0.1,
                Text             = "",
                ZIndex           = 10,
                Parent           = outerFrame
            })
            Utility.AddCorner(ddFrame, Theme.CornerRadiusSmall)
            local ddStroke = Utility.AddStroke(ddFrame, Theme.DropdownBorder, 1, 0.4)

            local ddTextLabel = Utility.Create("TextLabel", {
                Size             = UDim2.new(1, -28, 1, 0),
                Position         = UDim2.new(0, 8, 0, 0),
                Text             = ddSelected[1] or "Select...",
                Font             = Theme.FontBody,
                TextSize         = 12,
                TextColor3       = #ddSelected > 0 and Theme.DropdownText or Theme.TextMuted,
                BackgroundTransparency = 1,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 11,
                Parent           = ddFrame
            })

            local ddChevron = Utility.Create("TextLabel", {
                Size             = UDim2.new(0, 20, 1, 0),
                Position         = UDim2.new(1, -24, 0, 0),
                Text             = "▾",
                Font             = Theme.FontTitle,
                TextSize         = 14,
                TextColor3       = Theme.TextMuted,
                BackgroundTransparency = 1,
                ZIndex           = 11,
                Parent           = ddFrame
            })

            -- Dropdown list
            local ddList = Utility.Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 0),
                Position         = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = Theme.DropdownOpenBG,
                BackgroundTransparency = 0.05,
                ZIndex           = 20,
                ClipsDescendants = true,
                Visible          = false,
                Parent           = ddFrame
            })
            Utility.AddCorner(ddList, Theme.CornerRadiusSmall)
            Utility.AddStroke(ddList, Theme.DropdownBorder, 1, 0.35)
            Utility.AddPadding(ddList, 4, 4, 4, 4)

            -- Search box inside dropdown
            local searchBox = Utility.Create("TextBox", {
                Size             = UDim2.new(1, 0, 0, 26),
                Text             = "",
                PlaceholderText  = "Search...",
                PlaceholderColor3= Theme.TextboxPlaceholder,
                Font             = Theme.FontBody,
                TextSize         = 11,
                TextColor3       = Theme.TextboxText,
                BackgroundColor3 = Theme.TextboxBG,
                BackgroundTransparency = 0.2,
                ZIndex           = 21,
                Parent           = ddList
            })
            Utility.AddCorner(searchBox, UDim.new(0, 4))
            Utility.AddPadding(searchBox, 0, 6, 0, 6)

            local itemContainer = Utility.Create("ScrollingFrame", {
                Size             = UDim2.new(1, 0, 0, 0),
                Position         = UDim2.new(0, 0, 0, 30),
                BackgroundTransparency = 1,
                BorderSizePixel  = 0,
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = Theme.ScrollbarThumb,
                ZIndex           = 21,
                Parent           = ddList
            })
            Utility.AddListLayout(itemContainer, nil, Enum.HorizontalAlignment.Left, 2)

            local function updateDisplay()
                if #ddSelected == 0 then
                    ddTextLabel.Text  = "Select..."
                    ddTextLabel.TextColor3 = Theme.TextMuted
                elseif #ddSelected == 1 then
                    ddTextLabel.Text  = ddSelected[1]
                    ddTextLabel.TextColor3 = Theme.DropdownText
                else
                    ddTextLabel.Text  = #ddSelected .. " selected"
                    ddTextLabel.TextColor3 = Theme.DropdownText
                end
            end

            local itemButtons = {}
            local function buildItems(filter)
                for _, btn in ipairs(itemButtons) do btn:Destroy() end
                itemButtons = {}
                local count = 0
                for _, item in ipairs(ddItems) do
                    if filter == "" or item:lower():find(filter:lower(), 1, true) then
                        count += 1
                        local isSelected = table.find(ddSelected, item) ~= nil
                        local itemBtn = Utility.Create("TextButton", {
                            Size             = UDim2.new(1, 0, 0, 26),
                            BackgroundColor3 = isSelected
                                and Theme.TabActiveBG or Theme.DropdownItemHover,
                            BackgroundTransparency = isSelected and 0.15 or 1,
                            Text             = item,
                            Font             = Theme.FontBody,
                            TextSize         = 11,
                            TextColor3       = isSelected and Theme.TextPrimary or Theme.DropdownText,
                            TextXAlignment   = Enum.TextXAlignment.Left,
                            ZIndex           = 22,
                            Parent           = itemContainer
                        })
                        Utility.AddCorner(itemBtn, UDim.new(0, 4))
                        Utility.AddPadding(itemBtn, 0, 8, 0, 8)
                        table.insert(itemButtons, itemBtn)

                        itemBtn.MouseEnter:Connect(function()
                            if not table.find(ddSelected, item) then
                                Utility.TweenFast(itemBtn, { BackgroundTransparency = 0.6 })
                            end
                        end)
                        itemBtn.MouseLeave:Connect(function()
                            if not table.find(ddSelected, item) then
                                Utility.TweenFast(itemBtn, { BackgroundTransparency = 1 })
                            end
                        end)
                        itemBtn.MouseButton1Click:Connect(function()
                            if ddMulti then
                                local idx = table.find(ddSelected, item)
                                if idx then
                                    table.remove(ddSelected, idx)
                                    Utility.TweenFast(itemBtn, { BackgroundTransparency = 1 })
                                    itemBtn.TextColor3 = Theme.DropdownText
                                else
                                    table.insert(ddSelected, item)
                                    Utility.TweenFast(itemBtn, { BackgroundTransparency = 0.15 })
                                    itemBtn.TextColor3 = Theme.TextPrimary
                                end
                                updateDisplay()
                                pcall(ddCallback, ddSelected)
                            else
                                ddSelected = {item}
                                updateDisplay()
                                pcall(ddCallback, item)
                                -- Close
                                ddOpen = false
                                Utility.Tween(ddList, { Size = UDim2.new(1, 0, 0, 0) })
                                Utility.Tween(ddChevron, { Rotation = 0 })
                                task.delay(0.25, function() ddList.Visible = false end)
                            end
                        end)
                    end
                end
                itemContainer.CanvasSize = UDim2.new(0, 0, 0, count * 28)
                local listH = math.min(count * 28, 120)
                ddList.Size = UDim2.new(1, 0, 0, listH + 38)
                itemContainer.Size = UDim2.new(1, 0, 0, listH)
            end

            buildItems("")
            searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                buildItems(searchBox.Text)
            end)

            ddFrame.MouseButton1Click:Connect(function()
                ddOpen = not ddOpen
                if ddOpen then
                    ddList.Visible = true
                    local totalH = math.min(#ddItems * 28, 120) + 38
                    Utility.Tween(ddList, { Size = UDim2.new(1, 0, 0, totalH) })
                    Utility.Tween(ddChevron, { Rotation = 180 })
                else
                    Utility.Tween(ddList, { Size = UDim2.new(1, 0, 0, 0) })
                    Utility.Tween(ddChevron, { Rotation = 0 })
                    task.delay(0.25, function() ddList.Visible = false end)
                end
            end)

            local ddObj = {}
            function ddObj:SetItems(items)
                ddItems = items
                buildItems(searchBox.Text)
            end
            function ddObj:GetValue() return ddMulti and ddSelected or ddSelected[1] end
            function ddObj:SetValue(v)
                ddSelected = type(v) == "table" and v or {v}
                updateDisplay()
            end
            return ddObj
        end

        -- ---- KEYBIND ----
        function sectionObj:CreateKeybind(options3)
            options3 = options3 or {}
            local kbLabel    = options3.Label    or "Keybind"
            local kbDefault  = options3.Default  or Enum.KeyCode.Unknown
            local kbCallback = options3.Callback or function() end
            local kbKey      = kbDefault
            local kbListening= false

            local row = makeRow(kbLabel, 34)
            local kbBtn = Utility.Create("TextButton", {
                Size             = UDim2.new(0, 90, 0, 24),
                Position         = UDim2.new(1, -94, 0.5, -12),
                BackgroundColor3 = Theme.KeybindBG,
                BackgroundTransparency = 0.1,
                Text             = kbKey == Enum.KeyCode.Unknown and "None" or kbKey.Name,
                Font             = Theme.FontMono,
                TextSize         = 11,
                TextColor3       = Theme.KeybindText,
                ZIndex           = 6,
                Parent           = row
            })
            Utility.AddCorner(kbBtn, Theme.CornerRadiusSmall)
            Utility.AddStroke(kbBtn, Theme.KeybindBorder, 1, 0.4)

            kbBtn.MouseButton1Click:Connect(function()
                kbListening = true
                kbBtn.Text = "..."
                Utility.TweenFast(kbBtn, { BackgroundColor3 = Theme.TabActiveBG })
            end)

            UserInputService.InputBegan:Connect(function(input, processed)
                if kbListening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        kbKey = input.KeyCode
                        kbBtn.Text = kbKey.Name
                        kbListening = false
                        Utility.TweenFast(kbBtn, { BackgroundColor3 = Theme.KeybindBG })
                        pcall(kbCallback, kbKey)
                    end
                elseif not processed then
                    if input.KeyCode == kbKey then
                        pcall(kbCallback, kbKey)
                    end
                end
            end)

            -- Right click to clear
            kbBtn.MouseButton2Click:Connect(function()
                kbKey = Enum.KeyCode.Unknown
                kbBtn.Text = "None"
                pcall(kbCallback, nil)
            end)

            local kbObj = {}
            function kbObj:GetValue() return kbKey end
            function kbObj:SetValue(k) kbKey = k; kbBtn.Text = k.Name end
            return kbObj
        end

        -- ---- COLOR PICKER ----
        function sectionObj:CreateColorPicker(options3)
            options3 = options3 or {}
            local cpLabel    = options3.Label    or "Color"
            local cpDefault  = options3.Default  or Color3.fromRGB(80, 140, 255)
            local cpCallback = options3.Callback or function() end
            local cpColor    = cpDefault
            local cpOpen     = false

            local row = makeRow(cpLabel, 34)
            local cpPreview = Utility.Create("TextButton", {
                Size             = UDim2.new(0, 54, 0, 24),
                Position         = UDim2.new(1, -58, 0.5, -12),
                BackgroundColor3 = cpColor,
                Text             = "",
                ZIndex           = 6,
                Parent           = row
            })
            Utility.AddCorner(cpPreview, Theme.CornerRadiusSmall)
            Utility.AddStroke(cpPreview, Theme.ColorPickerBorder, 1, 0.3)

            -- Simple HSV picker panel
            local cpPanel = Utility.Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 0),
                Position         = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = Theme.DropdownOpenBG,
                BackgroundTransparency = 0.05,
                ZIndex           = 15,
                ClipsDescendants = true,
                Visible          = false,
                Parent           = row
            })
            Utility.AddCorner(cpPanel, Theme.CornerRadiusSmall)
            Utility.AddStroke(cpPanel, Theme.ColorPickerBorder, 1, 0.35)
            Utility.AddPadding(cpPanel, 8, 8, 8, 8)
            Utility.AddListLayout(cpPanel, nil, Enum.HorizontalAlignment.Left, 6)

            local function makeSliderCP(lbl, default, callback)
                local f = Utility.Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 24),
                    BackgroundTransparency = 1,
                    ZIndex = 16,
                    Parent = cpPanel
                })
                Utility.Create("TextLabel", {
                    Size = UDim2.new(0, 14, 1, 0),
                    Text = lbl,
                    Font = Theme.FontBody,
                    TextSize = 10,
                    TextColor3 = Theme.TextMuted,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 16,
                    Parent = f
                })
                local tr = Utility.Create("Frame", {
                    Size = UDim2.new(1, -22, 0, 8),
                    Position = UDim2.new(0, 18, 0.5, -4),
                    BackgroundColor3 = Theme.SliderTrack,
                    ZIndex = 16,
                    Parent = f
                })
                Utility.AddCorner(tr, UDim.new(1, 0))
                local fl = Utility.Create("Frame", {
                    Size = UDim2.new(default, 0, 1, 0),
                    BackgroundColor3 = Theme.SliderFill,
                    ZIndex = 17,
                    Parent = tr
                })
                Utility.AddCorner(fl, UDim.new(1, 0))
                local th = Utility.Create("Frame", {
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(default, -6, 0.5, -6),
                    BackgroundColor3 = Color3.fromRGB(255,255,255),
                    ZIndex = 18,
                    Parent = tr
                })
                Utility.AddCorner(th, UDim.new(1, 0))
                local val = default
                local drag = false
                local function upd(x)
                    val = math.clamp((x - tr.AbsolutePosition.X) / tr.AbsoluteSize.X, 0, 1)
                    fl.Size = UDim2.new(val, 0, 1, 0)
                    th.Position = UDim2.new(val, -6, 0.5, -6)
                    callback(val)
                end
                tr.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        drag = true; upd(inp.Position.X)
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if drag and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        upd(inp.Position.X)
                    end
                end)
                return function(v) val = v; fl.Size = UDim2.new(v,0,1,0); th.Position = UDim2.new(v,-6,0.5,-6) end,
                       function() return val end
            end

            local h, s, v = Color3.toHSV(cpColor)
            local setH, getH = makeSliderCP("H", h, function(val) h = val; cpColor = Color3.fromHSV(h,s,v); cpPreview.BackgroundColor3 = cpColor; pcall(cpCallback, cpColor) end)
            local setS, getS = makeSliderCP("S", s, function(val) s = val; cpColor = Color3.fromHSV(h,s,v); cpPreview.BackgroundColor3 = cpColor; pcall(cpCallback, cpColor) end)
            local setV, getV = makeSliderCP("V", v, function(val) v = val; cpColor = Color3.fromHSV(h,s,v); cpPreview.BackgroundColor3 = cpColor; pcall(cpCallback, cpColor) end)

            cpPreview.MouseButton1Click:Connect(function()
                cpOpen = not cpOpen
                if cpOpen then
                    cpPanel.Visible = true
                    Utility.Tween(cpPanel, { Size = UDim2.new(1, 0, 0, 100) })
                else
                    Utility.Tween(cpPanel, { Size = UDim2.new(1, 0, 0, 0) })
                    task.delay(0.25, function() cpPanel.Visible = false end)
                end
            end)

            local cpObj = {}
            function cpObj:GetValue() return cpColor end
            function cpObj:SetValue(c)
                cpColor = c
                cpPreview.BackgroundColor3 = c
                local nh, ns, nv = Color3.toHSV(c)
                setH(nh); setS(ns); setV(nv)
            end
            return cpObj
        end

        -- ---- PROGRESS BAR ----
        function sectionObj:CreateProgressBar(options3)
            options3 = options3 or {}
            local pbLabel    = options3.Label   or "Progress"
            local pbDefault  = options3.Value   or 0
            local pbMax      = options3.Max     or 100
            local pbSuffix   = options3.Suffix  or "%"
            local pbValue    = pbDefault

            local container = Utility.Create("Frame", {
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundTransparency = 1,
                ZIndex = 5,
                Parent = compContainer
            })
            local headerRow = Utility.Create("Frame", {
                Size = UDim2.new(1, 0, 0, 16),
                BackgroundTransparency = 1,
                ZIndex = 5,
                Parent = container
            })
            Utility.Create("TextLabel", {
                Size = UDim2.new(0.7, 0, 1, 0),
                Text = pbLabel,
                Font = Theme.FontBody,
                TextSize = 12,
                TextColor3 = Theme.TextSecondary,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 5,
                Parent = headerRow
            })
            local pbValueLabel = Utility.Create("TextLabel", {
                Size = UDim2.new(0.3, 0, 1, 0),
                Position = UDim2.new(0.7, 0, 0, 0),
                Text = tostring(pbValue) .. pbSuffix,
                Font = Theme.FontTitle,
                TextSize = 12,
                TextColor3 = Theme.TextAccent,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 5,
                Parent = headerRow
            })
            local pbTrack = Utility.Create("Frame", {
                Size = UDim2.new(1, 0, 0, 10),
                Position = UDim2.new(0, 0, 0, 22),
                BackgroundColor3 = Theme.ProgressBG,
                ZIndex = 5,
                Parent = container
            })
            Utility.AddCorner(pbTrack, UDim.new(1, 0))
            Utility.AddStroke(pbTrack, Theme.ProgressBorder, 1, 0.5)
            local pbFill = Utility.Create("Frame", {
                Size = UDim2.new(pbValue / pbMax, 0, 1, 0),
                BackgroundColor3 = Theme.ProgressFill,
                ZIndex = 6,
                Parent = pbTrack
            })
            Utility.AddCorner(pbFill, UDim.new(1, 0))

            local pbObj = {}
            function pbObj:SetValue(val)
                pbValue = math.clamp(val, 0, pbMax)
                Utility.Tween(pbFill, { Size = UDim2.new(pbValue / pbMax, 0, 1, 0) })
                pbValueLabel.Text = tostring(pbValue) .. pbSuffix
            end
            function pbObj:GetValue() return pbValue end
            return pbObj
        end

        -- ---- IMAGE ----
        function sectionObj:CreateImage(options3)
            options3 = options3 or {}
            local imgId     = options3.Image  or ""
            local imgHeight = options3.Height or 80
            local imgFrame  = Utility.Create("Frame", {
                Size = UDim2.new(1, 0, 0, imgHeight),
                BackgroundColor3 = Theme.ComponentBG,
                BackgroundTransparency = 0.2,
                ZIndex = 5,
                Parent = compContainer
            })
            Utility.AddCorner(imgFrame, Theme.CornerRadiusSmall)
            Utility.Create("ImageLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                Image = imgId,
                BackgroundTransparency = 1,
                ScaleType = Enum.ScaleType.Fit,
                ZIndex = 6,
                Parent = imgFrame
            })
        end

        -- ---- AVATAR ----
        function sectionObj:CreateAvatar(options3)
            options3 = options3 or {}
            local userId   = options3.UserId or (LocalPlayer and LocalPlayer.UserId or 0)
            local size     = options3.Size   or 60
            local imgFrame = Utility.Create("Frame", {
                Size = UDim2.new(0, size, 0, size),
                BackgroundColor3 = Theme.ComponentBG,
                BackgroundTransparency = 0.2,
                ZIndex = 5,
                Parent = compContainer
            })
            Utility.AddCorner(imgFrame, UDim.new(0, 8))
            Utility.AddStroke(imgFrame, Theme.ComponentBorder, 1, 0.4)
            Utility.Create("ImageLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                Image = "https://www.roblox.com/headshot-thumbnail/image?userId="
                    .. userId .. "&width=150&height=150&format=png",
                BackgroundTransparency = 1,
                ZIndex = 6,
                Parent = imgFrame
            })
        end

        -- ---- TOOLTIP helper ----
        function sectionObj:CreateTooltip(target, text)
            local tip = Utility.Create("Frame", {
                Size = UDim2.new(0, 0, 0, 24),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = Theme.ComponentBG,
                BackgroundTransparency = 0.1,
                ZIndex = 50,
                Visible = false,
                Parent = ScreenGui
            })
            Utility.AddCorner(tip, UDim.new(0, 4))
            Utility.AddStroke(tip, Theme.ComponentBorder, 1, 0.4)
            Utility.AddPadding(tip, 0, 8, 0, 8)
            Utility.Create("TextLabel", {
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                Text = text,
                Font = Theme.FontBody,
                TextSize = 11,
                TextColor3 = Theme.TextSecondary,
                BackgroundTransparency = 1,
                ZIndex = 51,
                Parent = tip
            })
            target.MouseEnter:Connect(function()
                local pos = UserInputService:GetMouseLocation()
                tip.Position = UDim2.new(0, pos.X + 8, 0, pos.Y - 28)
                tip.Visible = true
            end)
            target.MouseLeave:Connect(function()
                tip.Visible = false
            end)
            UserInputService.InputChanged:Connect(function(inp)
                if tip.Visible and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    tip.Position = UDim2.new(0, inp.Position.X + 8, 0, inp.Position.Y - 28)
                end
            end)
        end

        -- ---- SEARCH BAR ----
        function sectionObj:CreateSearchBar(options3)
            options3 = options3 or {}
            local sbPlaceholder = options3.Placeholder or "Search..."
            local sbCallback    = options3.Callback    or function() end

            local searchFrame = Utility.Create("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Theme.TextboxBG,
                BackgroundTransparency = 0.1,
                ZIndex = 5,
                Parent = compContainer
            })
            Utility.AddCorner(searchFrame, Theme.CornerRadiusSmall)
            local sbStroke = Utility.AddStroke(searchFrame, Theme.TextboxBorder, 1, 0.4)

            Utility.Create("TextLabel", {
                Size = UDim2.new(0, 18, 1, 0),
                Position = UDim2.new(0, 6, 0, 0),
                Text = "🔍",
                Font = Theme.FontBody,
                TextSize = 11,
                TextColor3 = Theme.TextMuted,
                BackgroundTransparency = 1,
                ZIndex = 6,
                Parent = searchFrame
            })

            local sb = Utility.Create("TextBox", {
                Size = UDim2.new(1, -28, 1, 0),
                Position = UDim2.new(0, 26, 0, 0),
                Text = "",
                PlaceholderText = sbPlaceholder,
                PlaceholderColor3 = Theme.TextboxPlaceholder,
                Font = Theme.FontBody,
                TextSize = 12,
                TextColor3 = Theme.TextboxText,
                BackgroundTransparency = 1,
                ZIndex = 6,
                Parent = searchFrame
            })
            sb.Focused:Connect(function()
                Utility.TweenFast(sbStroke, { Color = Theme.TextboxFocusBorder, Transparency = 0.1 })
            end)
            sb.FocusLost:Connect(function()
                Utility.TweenFast(sbStroke, { Color = Theme.TextboxBorder, Transparency = 0.4 })
            end)
            sb:GetPropertyChangedSignal("Text"):Connect(function()
                pcall(sbCallback, sb.Text)
            end)

            local sbObj = {}
            function sbObj:GetValue() return sb.Text end
            function sbObj:SetValue(t) sb.Text = t end
            return sbObj
        end

        -- ---- BINDABLE BUTTON ----
        function sectionObj:CreateBindableButton(options3)
            options3 = options3 or {}
            local bbLabel    = options3.Label    or "Bindable Button"
            local bbCallback = options3.Callback or function() end
            local bbObj = self:CreateButton({ Label = bbLabel, Callback = bbCallback })
            return bbObj
        end

        -- ---- BINDABLE TOGGLE ----
        function sectionObj:CreateBindableToggle(options3)
            options3 = options3 or {}
            return self:CreateToggle(options3)
        end

        table.insert(tabObj.Sections, sectionObj)
        return sectionObj
    end

    return tabMeta
end

-- ============================================================
-- KEY SYSTEM
-- ============================================================
function CapybaraUI:KeySystem(options)
    options = options or {}
    local title       = options.Title      or "Key System"
    local subtitle    = options.Subtitle   or "Enter your key to continue"
    local validKeys   = options.Keys       or {}
    local discordUrl  = options.Discord    or ""
    local getKeyUrl   = options.GetKey     or ""
    local onSuccess   = options.Callback   or function() end
    local onFail      = options.OnFail     or function() end

    local ksFrame = Utility.Create("Frame", {
        Name = "KeySystem",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.WindowBG,
        BackgroundTransparency = 0.08,
        ZIndex = 100,
        Parent = ScreenGui
    })
    Utility.AddCorner(ksFrame, Theme.CornerRadiusLarge)
    Utility.AddStroke(ksFrame, Theme.WindowBorder, Theme.StrokeThicknessBold, Theme.WindowBorderTransp)

    -- Open animation
    Utility.TweenBounce(ksFrame, { Size = UDim2.new(0, 340, 0, 240), Position = UDim2.new(0.5, -170, 0.5, -120) })
    Utility.MakeDraggable(ksFrame, ksFrame)

    local inner = Utility.Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 101,
        Parent = ksFrame
    })
    Utility.AddPadding(inner, 22, 18, 18, 18)
    Utility.AddListLayout(inner, nil, Enum.HorizontalAlignment.Center, 10)

    Utility.Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        Text = title,
        Font = Theme.FontTitle,
        TextSize = 16,
        TextColor3 = Theme.TextPrimary,
        BackgroundTransparency = 1,
        ZIndex = 101,
        Parent = inner
    })
    Utility.Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        Text = subtitle,
        Font = Theme.FontBody,
        TextSize = 11,
        TextColor3 = Theme.TextSecondary,
        BackgroundTransparency = 1,
        ZIndex = 101,
        Parent = inner
    })

    -- Key input
    local keyInputFrame = Utility.Create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Theme.TextboxBG,
        BackgroundTransparency = 0.1,
        ZIndex = 101,
        Parent = inner
    })
    Utility.AddCorner(keyInputFrame, Theme.CornerRadiusSmall)
    local keyStroke = Utility.AddStroke(keyInputFrame, Theme.TextboxBorder, 1, 0.4)

    local keyInput = Utility.Create("TextBox", {
        Size = UDim2.new(1, -36, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        Text = "",
        PlaceholderText = "Enter Key...",
        PlaceholderColor3 = Theme.TextboxPlaceholder,
        Font = Theme.FontMono,
        TextSize = 12,
        TextColor3 = Theme.TextboxText,
        BackgroundTransparency = 1,
        ZIndex = 102,
        Parent = keyInputFrame
    })

    -- Paste button
    local pasteBtn = Utility.Create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -32, 0.5, -14),
        Text = "📋",
        Font = Theme.FontBody,
        TextSize = 13,
        TextColor3 = Theme.TextMuted,
        BackgroundTransparency = 1,
        ZIndex = 102,
        Parent = keyInputFrame
    })
    pasteBtn.MouseButton1Click:Connect(function()
        -- In Roblox this needs executor clipboard support
        pcall(function()
            keyInput.Text = game:GetService("Clipboard") or keyInput.Text
        end)
    end)

    keyInput.Focused:Connect(function()
        Utility.TweenFast(keyStroke, { Color = Theme.TextboxFocusBorder, Transparency = 0.1 })
    end)
    keyInput.FocusLost:Connect(function()
        Utility.TweenFast(keyStroke, { Color = Theme.TextboxBorder, Transparency = 0.4 })
    end)

    -- Status label
    local statusLabel = Utility.Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 14),
        Text = "",
        Font = Theme.FontBody,
        TextSize = 11,
        TextColor3 = Theme.TextError,
        BackgroundTransparency = 1,
        ZIndex = 101,
        Parent = inner
    })

    -- Buttons row
    local btnRow = Utility.Create("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        ZIndex = 101,
        Parent = inner
    })
    Utility.AddListLayout(btnRow, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, 8)

    local function makeKSBtn(lbl, color)
        local b = Utility.Create("TextButton", {
            Size = UDim2.new(0, 90, 0, 30),
            BackgroundColor3 = color,
            BackgroundTransparency = 0.1,
            Text = lbl,
            Font = Theme.FontTitle,
            TextSize = 12,
            TextColor3 = Color3.fromRGB(255,255,255),
            ZIndex = 102,
            Parent = btnRow
        })
        Utility.AddCorner(b, Theme.CornerRadiusSmall)
        b.MouseEnter:Connect(function() Utility.TweenFast(b, { BackgroundTransparency = 0 }) end)
        b.MouseLeave:Connect(function() Utility.TweenFast(b, { BackgroundTransparency = 0.1 }) end)
        b.MouseButton1Down:Connect(function()
            Utility.Ripple(b, Mouse.X - b.AbsolutePosition.X, Mouse.Y - b.AbsolutePosition.Y)
        end)
        return b
    end

    local verifyBtn = makeKSBtn("Verify", Theme.ButtonBG)
    local discordBtn= makeKSBtn("Discord", Color3.fromRGB(88, 101, 242))
    local getKeyBtn = makeKSBtn("Get Key", Color3.fromRGB(60, 150, 90))

    -- Loading spinner
    local spinnerLabel = Utility.Create("TextLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0.5, -10, 0, 10),
        Text = "◌",
        Font = Theme.FontTitle,
        TextSize = 18,
        TextColor3 = Theme.TextAccent,
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 103,
        Parent = ksFrame
    })

    local spinConn
    local function startSpin()
        spinnerLabel.Visible = true
        local angle = 0
        spinConn = RunService.RenderStepped:Connect(function(dt)
            angle = (angle + 180 * dt) % 360
            spinnerLabel.Rotation = angle
        end)
    end
    local function stopSpin()
        spinnerLabel.Visible = false
        if spinConn then spinConn:Disconnect() end
    end

    verifyBtn.MouseButton1Click:Connect(function()
        local key = keyInput.Text
        startSpin()
        statusLabel.Text = ""
        task.wait(0.8)  -- simulate verification
        stopSpin()

        local valid = false
        for _, k in ipairs(validKeys) do
            if k == key then valid = true; break end
        end

        if valid then
            statusLabel.TextColor3 = Theme.TextSuccess
            statusLabel.Text = "✓ Key accepted!"
            Utility.Tween(keyStroke, { Color = Theme.NotifSuccess, Transparency = 0.1 })
            task.delay(0.8, function()
                Utility.Tween(ksFrame, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) })
                task.delay(0.4, function()
                    ksFrame:Destroy()
                    pcall(onSuccess)
                end)
            end)
        else
            statusLabel.TextColor3 = Theme.TextError
            statusLabel.Text = "✗ Invalid key. Try again."
            Utility.Tween(keyStroke, { Color = Theme.NotifError, Transparency = 0.1 })
            Utility.Tween(ksFrame, { Position = UDim2.new(0.5, -178, 0.5, -120) })
            task.wait(0.07)
            Utility.Tween(ksFrame, { Position = UDim2.new(0.5, -162, 0.5, -120) })
            task.wait(0.07)
            Utility.Tween(ksFrame, { Position = UDim2.new(0.5, -170, 0.5, -120) })
            pcall(onFail)
        end
    end)

    discordBtn.MouseButton1Click:Connect(function()
        -- setclipboard(discordUrl) -- uncomment if executor supports
        ShowNotification({ Title = "Discord", Message = "Link copied to clipboard!", Type = "Info" })
    end)

    getKeyBtn.MouseButton1Click:Connect(function()
        ShowNotification({ Title = "Get Key", Message = "Opening key link...", Type = "Info" })
    end)
end

-- ============================================================
-- PUBLIC API - Return Library
-- ============================================================
return CapybaraUI

--[[
===========================================================
  USAGE EXAMPLE
===========================================================

local CapybaraUI = loadstring(game:HttpGet("-- your script url --"))()
-- OR if running directly:
-- local CapybaraUI = require(script) -- if in a ModuleScript context

local Library = CapybaraUI.new({})

-- Key System (optional, call before window)
Library:KeySystem({
    Title    = "CapybaraScripts Hub",
    Subtitle = "Enter your key to continue",
    Keys     = { "CAPYBARA-FREE-2025", "OWNER-KEY-XYZ" },
    Discord  = "discord.gg/capybara",
    GetKey   = "linkvertise.com/getkey",
    Callback = function()
        print("Key accepted! Loading hub...")
    end,
})

local Window = Library:CreateWindow({
    Title    = "CapybaraScripts Hub",
    Subtitle = "v690",
    Size     = UDim2.new(0, 620, 0, 420),
    Position = UDim2.new(0.5, -310, 0.5, -210),
    TabWidth = 148,
})

-- TAB: Combat
local CombatTab = Window:CreateTab({
    Label = "Combat",
    Icon  = "⚔",
})
local CombatSection = CombatTab:CreateSection({ Label = "Knife Settings" })

CombatSection:CreateToggle({
    Label    = "Silent Aim",
    Default  = false,
    Callback = function(value)
        print("Silent Aim:", value)
    end,
})

CombatSection:CreateSlider({
    Label    = "FOV",
    Min      = 1,
    Max      = 500,
    Default  = 100,
    Step     = 1,
    Suffix   = "px",
    Callback = function(value)
        print("FOV:", value)
    end,
})

CombatSection:CreateDropdown({
    Label    = "Aim Part",
    Items    = { "Head", "Torso", "HumanoidRootPart", "LeftArm", "RightArm" },
    Default  = "Head",
    Callback = function(value)
        print("Aim Part:", value)
    end,
})

CombatSection:CreateButton({
    Label    = "--== Knife Silent Aim ==--",
    Callback = function()
        Library:Notify({
            Title   = "Combat",
            Message = "Silent Aim toggled!",
            Type    = "Success",
        })
    end,
})

-- TAB: Hitbox Expander
local HitboxTab = Window:CreateTab({
    Label = "Hitbox Expander",
    Icon  = "⬡",
})
local HitboxSection = HitboxTab:CreateSection({ Label = "Hitbox Settings" })

HitboxSection:CreateSlider({
    Label   = "Hitbox Size",
    Min     = 1,
    Max     = 20,
    Default = 5,
    Step    = 0.5,
    Suffix  = "x",
})

HitboxSection:CreateToggle({ Label = "Visualize Hitbox", Default = false })
HitboxSection:CreateToggle({ Label = "Team Check",       Default = true  })

-- TAB: Optimization
local OptTab = Window:CreateTab({ Label = "Optimization", Icon = "⚙" })
local OptSection = OptTab:CreateSection({ Label = "Performance" })

OptSection:CreateSlider({
    Label   = "FPS Cap",
    Min     = 15,
    Max     = 240,
    Default = 60,
    Step    = 5,
    Suffix  = " fps",
})
OptSection:CreateToggle({ Label = "Disable Shadows",   Default = true  })
OptSection:CreateToggle({ Label = "Disable Particles",  Default = false })
OptSection:CreateProgressBar({ Label = "Memory Usage", Value = 42, Max = 100, Suffix = "%" })

-- TAB: Visual
local VisTab = Window:CreateTab({ Label = "Visual", Icon = "👁" })
local VisSection = VisTab:CreateSection({ Label = "ESP Settings" })

VisSection:CreateToggle({ Label = "Player ESP",    Default = false })
VisSection:CreateToggle({ Label = "Name Tags",     Default = false })
VisSection:CreateColorPicker({
    Label    = "ESP Color",
    Default  = Color3.fromRGB(80, 140, 255),
    Callback = function(color)
        print("ESP Color:", color)
    end,
})
VisSection:CreateKeybind({
    Label    = "Toggle ESP",
    Default  = Enum.KeyCode.X,
    Callback = function(key)
        print("Keybind pressed:", key)
    end,
})

-- Notification demo
Library:Notify({
    Title   = "CapybaraScripts Hub",
    Message = "Successfully loaded! Version 690",
    Type    = "Success",
    Duration = 5,
})
]]

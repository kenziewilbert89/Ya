-- ============================================================
--   DORAEMON UI LIBRARY  |  Premium Roblox UI Framework
--   Version 1.0.0  |  Single-Script  |  Luau
-- ============================================================
--
--  SECTIONS:
--    1.  Services
--    2.  Theme
--    3.  Variables & State
--    4.  Utility Functions
--    5.  Tween Functions
--    6.  Notification System
--    7.  Key System
--    8.  Window Class
--    9.  Tab Class
--   10.  Section Class
--   11.  Component Factories
--         Label / Paragraph / Divider
--         Button / Toggle / Slider
--         Textbox / Dropdown / Multi-Dropdown
--         Search Bar / Color Picker / Keybind
--         Bindable Button / Bindable Toggle
--         Progress Bar / Loading Spinner
--         Image / Badge / Tooltip / Avatar
--   12.  Responsive Scaling
--   13.  Public API
-- ============================================================

-- ============================================================
-- 1. SERVICES
-- ============================================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService      = game:GetService("TextService")
local CoreGui          = game:GetService("CoreGui")
local HttpService      = game:GetService("HttpService")

-- ============================================================
-- 2. THEME
-- ============================================================
local Theme = {
    -- Primary palette
    MainColor     = Color3.fromHex("7FD8FF"),  -- Pastel Blue
    Secondary     = Color3.fromHex("FFFFFF"),  -- White
    Accent        = Color3.fromHex("FFD54F"),  -- Soft Yellow
    Danger        = Color3.fromHex("FF6B6B"),  -- Soft Red
    Success       = Color3.fromHex("6EDC7A"),  -- Soft Green
    Warning       = Color3.fromHex("FFD54F"),

    -- Backgrounds
    WindowBg      = Color3.fromHex("7FD8FF"),
    SidebarBg     = Color3.fromHex("5FC8EF"),  -- Slightly darker pastel blue
    ContentBg     = Color3.fromHex("FFFFFF"),
    CardBg        = Color3.fromHex("FFFFFF"),
    ComponentBg   = Color3.fromHex("FFFFFF"),
    InputBg       = Color3.fromHex("F2FAFF"),

    -- Text
    TextPrimary   = Color3.fromHex("2A2A35"),
    TextSecondary = Color3.fromHex("606070"),
    TextLight     = Color3.fromHex("FFFFFF"),
    TextMuted     = Color3.fromHex("AABBC8"),
    TextAccent    = Color3.fromHex("7FD8FF"),

    -- Strokes
    WindowStroke    = Color3.fromHex("FFFFFF"),
    SidebarStroke   = Color3.fromHex("FFFFFF"),
    TopbarStroke    = Color3.fromHex("FFFFFF"),
    ContainerStroke = Color3.fromHex("FFFFFF"),
    ComponentStroke = Color3.fromHex("7FD8FF"),

    -- Interactive states
    HoverBg       = Color3.fromHex("EAF7FF"),
    ActiveBg      = Color3.fromHex("D6F0FF"),
    ToggleOn      = Color3.fromHex("7FD8FF"),
    ToggleOff     = Color3.fromHex("CCDDE8"),

    -- Corner radii
    CornerLg      = UDim.new(0, 14),
    CornerMd      = UDim.new(0, 10),
    CornerSm      = UDim.new(0, 7),
    CornerRound   = UDim.new(1,  0),

    -- Typography
    FontBold      = Enum.Font.GothamBold,
    FontSemi      = Enum.Font.GothamSemibold,
    FontReg       = Enum.Font.Gotham,

    -- Animation
    TweenDuration = 0.22,
    TweenStyle    = Enum.EasingStyle.Quart,
    TweenDir      = Enum.EasingDirection.Out,
    SpringDur     = 0.38,
    SpringStyle   = Enum.EasingStyle.Back,
}

-- ============================================================
-- 3. VARIABLES & STATE
-- ============================================================
local LocalPlayer    = Players.LocalPlayer
local Mouse          = LocalPlayer:GetMouse()

local NotifHolder    = nil
local NotifCount     = 0

-- ============================================================
-- 4. UTILITY FUNCTIONS
-- ============================================================
local U = {}  -- namespace

function U.New(class, props, children)
    local obj = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            obj[k] = v
        end
    end
    if children then
        for _, c in ipairs(children) do
            c.Parent = obj
        end
    end
    return obj
end

function U.Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or Theme.CornerMd
    c.Parent = parent
    return c
end

function U.Stroke(parent, color, thickness, mode)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.ComponentStroke
    s.Thickness = thickness or 1.5
    s.ApplyStrokeMode = mode or Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

function U.Pad(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 8)
    p.PaddingBottom = UDim.new(0, bottom or 8)
    p.PaddingLeft   = UDim.new(0, left   or 8)
    p.PaddingRight  = UDim.new(0, right  or 8)
    p.Parent = parent
    return p
end

function U.ListLayout(parent, dir, spacing, halign, valign)
    local l = Instance.new("UIListLayout")
    l.FillDirection       = dir    or Enum.FillDirection.Vertical
    l.Padding             = UDim.new(0, spacing or 6)
    l.HorizontalAlignment = halign or Enum.HorizontalAlignment.Center
    l.VerticalAlignment   = valign or Enum.VerticalAlignment.Top
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    l.Parent = parent
    return l
end

function U.Shadow(parent, zOffset)
    local s = U.New("ImageLabel", {
        Name                = "Shadow",
        BackgroundTransparency = 1,
        Image               = "rbxassetid://5028857084",
        ImageColor3         = Color3.fromRGB(0,0,0),
        ImageTransparency   = 0.82,
        Size                = UDim2.new(1, 46, 1, 46),
        Position            = UDim2.new(0, -23, 0, -23),
        ZIndex              = parent.ZIndex + (zOffset or -1),
        Parent              = parent,
    })
    return s
end

function U.ScreenGui()
    local sg
    pcall(function()
        sg = CoreGui:FindFirstChild("DoraemonLibrary")
    end)
    if not sg then
        sg = U.New("ScreenGui", {
            Name            = "DoraemonLibrary",
            ResetOnSpawn    = false,
            ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
            IgnoreGuiInset  = true,
        })
        local ok = pcall(function() sg.Parent = CoreGui end)
        if not ok then
            sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
    end
    return sg
end

function U.AutoCanvas(scrollFrame, layout)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
end

function U.Ripple(parent, x, y)
    local rx = x - parent.AbsolutePosition.X
    local ry = y - parent.AbsolutePosition.Y
    local r  = U.New("Frame", {
        Size                    = UDim2.new(0, 0, 0, 0),
        Position                = UDim2.new(0, rx, 0, ry),
        BackgroundColor3        = Color3.fromRGB(255,255,255),
        BackgroundTransparency  = 0.65,
        BorderSizePixel         = 0,
        ZIndex                  = parent.ZIndex + 8,
        Parent                  = parent,
    })
    U.Corner(r, UDim.new(1,0))
    local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.8
    TweenService:Create(r, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size     = UDim2.new(0, size, 0, size),
        Position = UDim2.new(0, rx - size/2, 0, ry - size/2),
        BackgroundTransparency = 1,
    }):Play()
    game:GetService("Debris"):AddItem(r, 0.5)
end

function U.GlowImage(parent, color, spread, transparency)
    local g = U.New("ImageLabel", {
        Name                    = "Glow",
        BackgroundTransparency  = 1,
        Image                   = "rbxassetid://5028857084",
        ImageColor3             = color or Theme.MainColor,
        ImageTransparency       = transparency or 0.55,
        Size                    = UDim2.new(1, spread or 24, 1, spread or 24),
        Position                = UDim2.new(0, -(spread or 24)/2, 0, -(spread or 24)/2),
        ZIndex                  = parent.ZIndex - 1,
        Parent                  = parent,
    })
    return g
end

function U.TextSize(text, size, font, maxW)
    return TextService:GetTextSize(text, size, font, Vector2.new(maxW or 2000, 2000))
end

-- ============================================================
-- 5. TWEEN FUNCTIONS
-- ============================================================
local T = {}

function T.Play(obj, duration, props, style, dir)
    local info = TweenInfo.new(
        duration or Theme.TweenDuration,
        style    or Theme.TweenStyle,
        dir      or Theme.TweenDir
    )
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

function T.Spring(obj, duration, props)
    return T.Play(obj, duration or Theme.SpringDur, props, Theme.SpringStyle, Enum.EasingDirection.Out)
end

function T.Linear(obj, duration, props)
    return T.Play(obj, duration, props, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
end

function T.Sine(obj, duration, props)
    return T.Play(obj, duration, props, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
end

-- shortcut: tween transparency
function T.FadeOut(obj, duration, cb)
    local tw = T.Play(obj, duration or 0.28, {BackgroundTransparency = 1})
    if cb then tw.Completed:Once(cb) end
    return tw
end

function T.FadeIn(obj, duration)
    obj.BackgroundTransparency = 1
    return T.Play(obj, duration or 0.28, {BackgroundTransparency = 0})
end

-- ============================================================
-- 6. NOTIFICATION SYSTEM
-- ============================================================
local function InitNotifications(screenGui)
    NotifHolder = U.New("Frame", {
        Name                    = "NotificationHolder",
        Size                    = UDim2.new(0, 310, 1, -20),
        Position                = UDim2.new(1, -322, 0, 10),
        BackgroundTransparency  = 1,
        ZIndex                  = 200,
        Parent                  = screenGui,
    })
    local lay = Instance.new("UIListLayout")
    lay.FillDirection       = Enum.FillDirection.Vertical
    lay.VerticalAlignment   = Enum.VerticalAlignment.Bottom
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    lay.Padding             = UDim.new(0, 8)
    lay.SortOrder           = Enum.SortOrder.LayoutOrder
    lay.Parent              = NotifHolder
end

local function Notify(opts)
    NotifCount = NotifCount + 1
    local nType     = opts.Type or "Info"
    local duration  = opts.Duration or 4.5

    local typeData = {
        Success = { color = Theme.Success, icon = "✓" },
        Warning = { color = Theme.Warning, icon = "⚠" },
        Error   = { color = Theme.Danger,  icon = "✕" },
        Info    = { color = Theme.MainColor, icon = "ℹ" },
    }
    local td = typeData[nType] or typeData.Info

    -- Container
    local notif = U.New("Frame", {
        Name                    = "Notif_" .. NotifCount,
        Size                    = UDim2.new(1, 0, 0, 76),
        BackgroundColor3        = Color3.fromRGB(255,255,255),
        ClipsDescendants        = true,
        LayoutOrder             = -NotifCount,
        ZIndex                  = 201,
        Parent                  = NotifHolder,
    })
    U.Corner(notif, Theme.CornerMd)
    U.Stroke(notif, td.color, 1.5)
    U.Shadow(notif, -1)

    -- Left accent bar
    local bar = U.New("Frame", {
        Size                = UDim2.new(0, 5, 1, 0),
        BackgroundColor3    = td.color,
        BorderSizePixel     = 0,
        ZIndex              = 202,
        Parent              = notif,
    })
    U.Corner(bar, UDim.new(0,5))

    -- Icon circle
    local iconCircle = U.New("Frame", {
        Size                = UDim2.new(0, 34, 0, 34),
        Position            = UDim2.new(0, 16, 0.5, -17),
        BackgroundColor3    = td.color,
        BackgroundTransparency = 0.12,
        ZIndex              = 203,
        Parent              = notif,
    })
    U.Corner(iconCircle, UDim.new(1,0))
    U.New("TextLabel", {
        Size                    = UDim2.new(1,0,1,0),
        BackgroundTransparency  = 1,
        Text                    = td.icon,
        TextColor3              = td.color,
        TextSize                = 16,
        Font                    = Theme.FontBold,
        ZIndex                  = 204,
        Parent                  = iconCircle,
    })

    -- Title
    U.New("TextLabel", {
        Size                    = UDim2.new(1, -80, 0, 20),
        Position                = UDim2.new(0, 58, 0, 10),
        BackgroundTransparency  = 1,
        Text                    = opts.Title or nType,
        TextColor3              = Theme.TextPrimary,
        TextSize                = 13,
        Font                    = Theme.FontBold,
        TextXAlignment          = Enum.TextXAlignment.Left,
        ZIndex                  = 203,
        Parent                  = notif,
    })

    -- Message
    U.New("TextLabel", {
        Size                    = UDim2.new(1, -80, 0, 30),
        Position                = UDim2.new(0, 58, 0, 30),
        BackgroundTransparency  = 1,
        Text                    = opts.Message or "",
        TextColor3              = Theme.TextSecondary,
        TextSize                = 11,
        Font                    = Theme.FontReg,
        TextXAlignment          = Enum.TextXAlignment.Left,
        TextWrapped             = true,
        ZIndex                  = 203,
        Parent                  = notif,
    })

    -- Close button
    local closeBtn = U.New("TextButton", {
        Size                    = UDim2.new(0, 22, 0, 22),
        Position                = UDim2.new(1, -28, 0, 6),
        BackgroundTransparency  = 1,
        Text                    = "×",
        TextColor3              = Theme.TextMuted,
        TextSize                = 18,
        Font                    = Theme.FontBold,
        ZIndex                  = 205,
        Parent                  = notif,
    })

    -- Progress bar
    local progBg = U.New("Frame", {
        Size                = UDim2.new(1, 0, 0, 3),
        Position            = UDim2.new(0, 0, 1, -3),
        BackgroundColor3    = Color3.fromHex("E8F4FF"),
        BorderSizePixel     = 0,
        ZIndex              = 203,
        Parent              = notif,
    })
    local progFill = U.New("Frame", {
        Size                = UDim2.new(1, 0, 1, 0),
        BackgroundColor3    = td.color,
        BorderSizePixel     = 0,
        ZIndex              = 204,
        Parent              = progBg,
    })
    U.Corner(progFill, UDim.new(1,0))

    -- Animate slide-in from right
    notif.Position = UDim2.new(1, 20, 0, 0)
    T.Spring(notif, 0.45, { Position = UDim2.new(0, 0, 0, 0) })

    -- Progress drain
    T.Linear(progFill, duration, { Size = UDim2.new(0, 0, 1, 0) })

    local function dismiss()
        T.Play(notif, 0.3, { Position = UDim2.new(1, 20, 0, 0) })
        T.Play(notif, 0.3, { BackgroundTransparency = 1 })
        task.delay(0.32, function()
            if notif and notif.Parent then notif:Destroy() end
        end)
    end

    closeBtn.MouseButton1Click:Connect(dismiss)
    task.delay(duration, dismiss)
end

-- ============================================================
-- 7. KEY SYSTEM
-- ============================================================
local function KeySystem(opts, onSuccess)
    local sg = opts._ScreenGui
    if not sg then return end

    -- Dim overlay
    local overlay = U.New("Frame", {
        Name                    = "KeyOverlay",
        Size                    = UDim2.new(1, 0, 1, 0),
        BackgroundColor3        = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency  = 0.45,
        ZIndex                  = 400,
        Parent                  = sg,
    })

    -- Main panel
    local panel = U.New("Frame", {
        Name                    = "KeyPanel",
        Size                    = UDim2.new(0, 0, 0, 0),
        Position                = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3        = Theme.WindowBg,
        ZIndex                  = 401,
        Parent                  = sg,
    })
    U.Corner(panel, Theme.CornerLg)
    U.Stroke(panel, Theme.WindowStroke, 2)
    U.Shadow(panel)

    -- Animate panel open
    T.Spring(panel, 0.5, {
        Size     = UDim2.new(0, 390, 0, 430),
        Position = UDim2.new(0.5, -195, 0.5, -215),
    })

    -- Key badge at top
    local badge = U.New("Frame", {
        Size                    = UDim2.new(0, 72, 0, 72),
        Position                = UDim2.new(0.5, -36, 0, -36),
        BackgroundColor3        = Theme.WindowBg,
        ZIndex                  = 403,
        Parent                  = panel,
    })
    U.Corner(badge, UDim.new(1,0))
    U.Stroke(badge, Color3.fromRGB(255,255,255), 3)
    U.New("TextLabel", {
        Size                    = UDim2.new(1,0,1,0),
        BackgroundTransparency  = 1,
        Text                    = "🔑",
        TextSize                = 30,
        Font                    = Theme.FontBold,
        ZIndex                  = 404,
        Parent                  = badge,
    })

    -- Title
    U.New("TextLabel", {
        Size                    = UDim2.new(1, -32, 0, 34),
        Position                = UDim2.new(0, 16, 0, 52),
        BackgroundTransparency  = 1,
        Text                    = opts.Title or "Key System",
        TextColor3              = Theme.TextLight,
        TextSize                = 20,
        Font                    = Theme.FontBold,
        ZIndex                  = 402,
        Parent                  = panel,
    })
    U.New("TextLabel", {
        Size                    = UDim2.new(1, -32, 0, 22),
        Position                = UDim2.new(0, 16, 0, 84),
        BackgroundTransparency  = 1,
        Text                    = opts.Subtitle or "Enter your access key to continue",
        TextColor3              = Color3.fromHex("C5EEFF"),
        TextSize                = 12,
        Font                    = Theme.FontReg,
        ZIndex                  = 402,
        Parent                  = panel,
    })

    -- Divider
    U.New("Frame", {
        Size                    = UDim2.new(1, -32, 0, 1),
        Position                = UDim2.new(0, 16, 0, 114),
        BackgroundColor3        = Color3.fromRGB(255,255,255),
        BackgroundTransparency  = 0.7,
        ZIndex                  = 402,
        Parent                  = panel,
    })

    -- Key input field
    local inputFrame = U.New("Frame", {
        Size                    = UDim2.new(1, -32, 0, 46),
        Position                = UDim2.new(0, 16, 0, 130),
        BackgroundColor3        = Color3.fromRGB(255,255,255),
        ZIndex                  = 402,
        Parent                  = panel,
    })
    U.Corner(inputFrame, Theme.CornerMd)
    local inputStroke = U.Stroke(inputFrame, Theme.ComponentStroke, 1.5)

    local keyBox = U.New("TextBox", {
        Size                    = UDim2.new(1, -18, 1, 0),
        Position                = UDim2.new(0, 9, 0, 0),
        BackgroundTransparency  = 1,
        Text                    = "",
        PlaceholderText         = opts.Placeholder or "Paste your key here...",
        TextColor3              = Theme.TextPrimary,
        PlaceholderColor3       = Theme.TextMuted,
        TextSize                = 13,
        Font                    = Theme.FontReg,
        ClearTextOnFocus        = false,
        ZIndex                  = 403,
        Parent                  = inputFrame,
    })

    keyBox.Focused:Connect(function()
        T.Play(inputStroke, 0.18, { Color = Theme.MainColor, Thickness = 2 })
    end)
    keyBox.FocusLost:Connect(function()
        T.Play(inputStroke, 0.18, { Color = Theme.ComponentStroke, Thickness = 1.5 })
    end)

    -- Status label
    local statusLabel = U.New("TextLabel", {
        Size                    = UDim2.new(1, -32, 0, 22),
        Position                = UDim2.new(0, 16, 0, 184),
        BackgroundTransparency  = 1,
        Text                    = "",
        TextColor3              = Theme.TextSecondary,
        TextSize                = 11,
        Font                    = Theme.FontReg,
        ZIndex                  = 402,
        Parent                  = panel,
    })

    -- Verify button
    local verifyBtn = U.New("TextButton", {
        Size                    = UDim2.new(1, -32, 0, 44),
        Position                = UDim2.new(0, 16, 0, 212),
        BackgroundColor3        = Color3.fromRGB(255,255,255),
        Text                    = "Verify Key",
        TextColor3              = Theme.MainColor,
        TextSize                = 14,
        Font                    = Theme.FontBold,
        ZIndex                  = 402,
        ClipsDescendants        = true,
        Parent                  = panel,
    })
    U.Corner(verifyBtn, Theme.CornerMd)
    U.Stroke(verifyBtn, Theme.ComponentStroke, 1.5)

    -- Loading progress bar inside verify btn
    local loadFill = U.New("Frame", {
        Size                    = UDim2.new(0, 0, 1, 0),
        BackgroundColor3        = Color3.fromHex("EAF7FF"),
        BackgroundTransparency  = 0,
        BorderSizePixel         = 0,
        ZIndex                  = 402,
        Parent                  = verifyBtn,
    })

    -- Row: Copy Key + Discord + Get Key
    local row = U.New("Frame", {
        Size                    = UDim2.new(1, -32, 0, 38),
        Position                = UDim2.new(0, 16, 0, 266),
        BackgroundTransparency  = 1,
        ZIndex                  = 402,
        Parent                  = panel,
    })

    local function makeRowBtn(text, color, textColor, xScale, xOffset)
        local b = U.New("TextButton", {
            Size                    = UDim2.new(0.315, 0, 1, 0),
            Position                = UDim2.new(xScale, xOffset, 0, 0),
            BackgroundColor3        = color,
            BackgroundTransparency  = 0.08,
            Text                    = text,
            TextColor3              = textColor,
            TextSize                = 11,
            Font                    = Theme.FontSemi,
            ZIndex                  = 403,
            Parent                  = row,
        })
        U.Corner(b, Theme.CornerSm)
        U.Stroke(b, color, 1)
        b.MouseEnter:Connect(function()
            T.Play(b, 0.12, { BackgroundTransparency = 0 })
        end)
        b.MouseLeave:Connect(function()
            T.Play(b, 0.12, { BackgroundTransparency = 0.08 })
        end)
        return b
    end

    local copyBtn    = makeRowBtn("Copy Key",  Theme.MainColor,             Color3.fromRGB(255,255,255), 0,    0)
    local discordBtn = makeRowBtn("Discord",   Color3.fromHex("5865F2"),    Color3.fromRGB(255,255,255), 0.345, 0)
    local getKeyBtn  = makeRowBtn("Get Key",   Theme.Accent,                Color3.fromHex("5A4000"),    0.69, 0)

    -- Loading bar at very bottom
    local loadBar = U.New("Frame", {
        Size                    = UDim2.new(1, -32, 0, 4),
        Position                = UDim2.new(0, 16, 0, 316),
        BackgroundColor3        = Color3.fromRGB(255,255,255),
        BackgroundTransparency  = 0.7,
        ZIndex                  = 402,
        Parent                  = panel,
    })
    U.Corner(loadBar, UDim.new(1,0))
    local loadProgress = U.New("Frame", {
        Size                    = UDim2.new(0, 0, 1, 0),
        BackgroundColor3        = Theme.Accent,
        ZIndex                  = 403,
        Parent                  = loadBar,
    })
    U.Corner(loadProgress, UDim.new(1,0))

    -- Hover on verify
    verifyBtn.MouseEnter:Connect(function()
        T.Play(verifyBtn, 0.14, { BackgroundColor3 = Color3.fromHex("EAF7FF") })
    end)
    verifyBtn.MouseLeave:Connect(function()
        T.Play(verifyBtn, 0.14, { BackgroundColor3 = Color3.fromRGB(255,255,255) })
    end)

    local function closePanel(success)
        T.Play(overlay, 0.28, { BackgroundTransparency = 1 })
        T.Spring(panel, 0.4, {
            Size     = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
        })
        task.delay(0.4, function()
            overlay:Destroy()
            panel:Destroy()
            if success and onSuccess then
                onSuccess(true)
            end
        end)
    end

    verifyBtn.MouseButton1Click:Connect(function()
        local key = keyBox.Text
        if key == "" then
            statusLabel.Text = "⚠  Please enter a key."
            statusLabel.TextColor3 = Theme.Danger
            return
        end
        verifyBtn.Text = "Verifying..."
        verifyBtn.TextColor3 = Theme.TextMuted
        statusLabel.Text = "Checking key..."
        statusLabel.TextColor3 = Theme.TextSecondary

        -- Loading animation
        loadFill.Size = UDim2.new(0, 0, 1, 0)
        T.Play(loadFill, 1.4, { Size = UDim2.new(1, 0, 1, 0) }, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
        T.Linear(loadProgress, 1.4, { Size = UDim2.new(1, 0, 1, 0) })

        task.delay(1.45, function()
            local valid = false
            if opts.Keys then
                for _, k in ipairs(opts.Keys) do
                    if key == k then valid = true break end
                end
            end
            if opts.ValidateCallback then
                valid = opts.ValidateCallback(key)
            end

            if valid then
                statusLabel.Text = "✓  Key verified! Welcome."
                statusLabel.TextColor3 = Theme.Success
                verifyBtn.Text = "✓  Access Granted"
                T.Play(verifyBtn, 0.2, { BackgroundColor3 = Theme.Success, TextColor3 = Color3.fromRGB(255,255,255) })
                T.Play(panel, 0.3, { BackgroundColor3 = Color3.fromHex("5BD67A") })
                task.delay(1.1, function() closePanel(true) end)
            else
                statusLabel.Text = "✕  Invalid key. Try again."
                statusLabel.TextColor3 = Theme.Danger
                verifyBtn.Text = "Verify Key"
                verifyBtn.TextColor3 = Theme.MainColor
                T.Play(loadFill, 0.15, { Size = UDim2.new(0, 0, 1, 0) })
                loadProgress.Size = UDim2.new(0, 0, 1, 0)

                -- Shake input
                local op = inputFrame.Position
                for i = 1, 4 do
                    task.delay(i * 0.07, function()
                        inputFrame.Position = UDim2.new(op.X.Scale, op.X.Offset + (i % 2 == 0 and -7 or 7), op.Y.Scale, op.Y.Offset)
                    end)
                end
                task.delay(0.38, function()
                    T.Play(inputFrame, 0.1, { Position = op })
                end)
            end
        end)
    end)

    copyBtn.MouseButton1Click:Connect(function()
        if opts.CopyKey then
            pcall(setclipboard, opts.CopyKey)
            copyBtn.Text = "Copied!"
            task.delay(1.5, function() copyBtn.Text = "Copy Key" end)
        end
    end)

    discordBtn.MouseButton1Click:Connect(function()
        if opts.Discord then
            pcall(setclipboard, opts.Discord)
            discordBtn.Text = "Copied!"
            task.delay(1.5, function() discordBtn.Text = "Discord" end)
        end
    end)

    getKeyBtn.MouseButton1Click:Connect(function()
        if opts.GetKey then
            pcall(setclipboard, opts.GetKey)
            getKeyBtn.Text = "Copied!"
            task.delay(1.5, function() getKeyBtn.Text = "Get Key" end)
        end
    end)
end

-- ============================================================
-- 8. WINDOW CLASS
-- ============================================================
local Window = {}
Window.__index = Window

function Window.new(lib, opts)
    local self = setmetatable({}, Window)
    self._lib       = lib
    self._opts      = opts or {}
    self._tabs      = {}
    self._activeTab = nil
    self._minimized = false
    self._maximized = false
    self._savedSize = UDim2.new(0, 640, 0, 490)
    self._savedPos  = nil
    self:_build()
    return self
end

function Window:_build()
    local sg = self._lib._screenGui

    -- Root frame
    self._frame = U.New("Frame", {
        Name                    = "DoraemonWindow",
        Size                    = UDim2.new(0, 0, 0, 0),
        Position                = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3        = Theme.WindowBg,
        BackgroundTransparency  = 1,
        ClipsDescendants        = false,
        ZIndex                  = 10,
        Parent                  = sg,
    })
    U.Corner(self._frame, Theme.CornerLg)
    U.Stroke(self._frame, Theme.WindowStroke, 1.5)
    U.Shadow(self._frame)

    -- Animate open
    T.Spring(self._frame, 0.55, {
        Size                    = UDim2.new(0, 640, 0, 490),
        Position                = UDim2.new(0.5, -320, 0.5, -245),
        BackgroundTransparency  = 0,
    })
    self._savedSize = UDim2.new(0, 640, 0, 490)

    -- ── Topbar ──────────────────────────────────────────────
    self._topbar = U.New("Frame", {
        Name                    = "Topbar",
        Size                    = UDim2.new(1, 0, 0, 54),
        BackgroundColor3        = Theme.WindowBg,
        ZIndex                  = 11,
        Parent                  = self._frame,
    })
    U.Corner(self._topbar, Theme.CornerLg)
    -- cover bottom corners of topbar
    U.New("Frame", {
        Size                    = UDim2.new(1, 0, 0, 14),
        Position                = UDim2.new(0, 0, 1, -14),
        BackgroundColor3        = Theme.WindowBg,
        BorderSizePixel         = 0,
        ZIndex                  = 11,
        Parent                  = self._topbar,
    })
    -- topbar bottom border
    U.New("Frame", {
        Size                    = UDim2.new(1, 0, 0, 1),
        Position                = UDim2.new(0, 0, 1, -1),
        BackgroundColor3        = Theme.TopbarStroke,
        BackgroundTransparency  = 0.72,
        ZIndex                  = 12,
        Parent                  = self._topbar,
    })

    -- Logo orb
    local logoOrb = U.New("Frame", {
        Size                    = UDim2.new(0, 34, 0, 34),
        Position                = UDim2.new(0, 12, 0.5, -17),
        BackgroundColor3        = Color3.fromRGB(255,255,255),
        BackgroundTransparency  = 0.22,
        ZIndex                  = 13,
        Parent                  = self._topbar,
    })
    U.Corner(logoOrb, UDim.new(1,0))
    U.New("TextLabel", {
        Size                    = UDim2.new(1,0,1,0),
        BackgroundTransparency  = 1,
        Text                    = "✦",
        TextColor3              = Color3.fromRGB(255,255,255),
        TextSize                = 16,
        Font                    = Theme.FontBold,
        ZIndex                  = 14,
        Parent                  = logoOrb,
    })

    -- Title / Subtitle
    self._titleLabel = U.New("TextLabel", {
        Name                    = "Title",
        Size                    = UDim2.new(0, 220, 0, 22),
        Position                = UDim2.new(0, 54, 0, 9),
        BackgroundTransparency  = 1,
        Text                    = self._opts.Title or "Doraemon Hub",
        TextColor3              = Color3.fromRGB(255,255,255),
        TextSize                = 15,
        Font                    = Theme.FontBold,
        TextXAlignment          = Enum.TextXAlignment.Left,
        ZIndex                  = 13,
        Parent                  = self._topbar,
    })
    self._subtitleLabel = U.New("TextLabel", {
        Name                    = "Subtitle",
        Size                    = UDim2.new(0, 220, 0, 15),
        Position                = UDim2.new(0, 54, 0, 30),
        BackgroundTransparency  = 1,
        Text                    = self._opts.Subtitle or "Premium UI",
        TextColor3              = Color3.fromHex("C8EEFF"),
        TextSize                = 11,
        Font                    = Theme.FontReg,
        TextXAlignment          = Enum.TextXAlignment.Left,
        ZIndex                  = 13,
        Parent                  = self._topbar,
    })

    -- Window controls (Close / Min / Max)
    local ctrlFrame = U.New("Frame", {
        Size                    = UDim2.new(0, 94, 0, 28),
        Position                = UDim2.new(1, -104, 0.5, -14),
        BackgroundTransparency  = 1,
        ZIndex                  = 13,
        Parent                  = self._topbar,
    })

    local function mkCtrl(name, text, color, pos)
        local btn = U.New("TextButton", {
            Name                    = name,
            Size                    = UDim2.new(0, 25, 0, 25),
            Position                = UDim2.new(0, pos, 0.5, -12),
            BackgroundColor3        = color,
            BackgroundTransparency  = 0.25,
            Text                    = text,
            TextColor3              = Color3.fromRGB(255,255,255),
            TextSize                = 11,
            Font                    = Theme.FontBold,
            ZIndex                  = 14,
            Parent                  = ctrlFrame,
        })
        U.Corner(btn, UDim.new(1,0))
        btn.MouseEnter:Connect(function()
            T.Play(btn, 0.13, { BackgroundTransparency = 0, Size = UDim2.new(0,27,0,27), Position = UDim2.new(0, pos-1, 0.5,-13) })
        end)
        btn.MouseLeave:Connect(function()
            T.Play(btn, 0.13, { BackgroundTransparency = 0.25, Size = UDim2.new(0,25,0,25), Position = UDim2.new(0, pos, 0.5,-12) })
        end)
        return btn
    end

    self._closeBtn = mkCtrl("Close",    "✕", Theme.Danger,   0)
    self._minBtn   = mkCtrl("Minimize", "–", Theme.Accent,  32)
    self._maxBtn   = mkCtrl("Maximize", "□", Theme.Success, 64)

    -- ── Content Area ─────────────────────────────────────────
    self._contentArea = U.New("Frame", {
        Name                    = "Content",
        Size                    = UDim2.new(1, 0, 1, -54),
        Position                = UDim2.new(0, 0, 0, 54),
        BackgroundTransparency  = 1,
        ClipsDescendants        = true,
        ZIndex                  = 11,
        Parent                  = self._frame,
    })

    -- ── Sidebar ───────────────────────────────────────────────
    self._sidebar = U.New("Frame", {
        Name                    = "Sidebar",
        Size                    = UDim2.new(0, 158, 1, 0),
        BackgroundColor3        = Theme.SidebarBg,
        ZIndex                  = 12,
        Parent                  = self._contentArea,
    })
    U.Corner(self._sidebar, Theme.CornerLg)
    -- fill top corners
    U.New("Frame", { Size = UDim2.new(1,0,0,14), BackgroundColor3 = Theme.SidebarBg, BorderSizePixel = 0, ZIndex = 12, Parent = self._sidebar })
    -- fill right rounded edge
    U.New("Frame", { Size = UDim2.new(0,14,1,0), Position = UDim2.new(1,-14,0,0), BackgroundColor3 = Theme.SidebarBg, BorderSizePixel = 0, ZIndex = 12, Parent = self._sidebar })
    -- right border
    U.New("Frame", { Size = UDim2.new(0,1,1,0), Position = UDim2.new(1,0,0,0), BackgroundColor3 = Theme.SidebarStroke, BackgroundTransparency = 0.72, ZIndex = 13, Parent = self._sidebar })

    -- Tab scroll container
    self._tabScroll = U.New("ScrollingFrame", {
        Name                    = "TabScroll",
        Size                    = UDim2.new(1, 0, 1, -12),
        Position                = UDim2.new(0, 0, 0, 12),
        BackgroundTransparency  = 1,
        ScrollBarThickness      = 0,
        CanvasSize              = UDim2.new(0, 0, 0, 0),
        ZIndex                  = 13,
        Parent                  = self._sidebar,
    })
    local tabLayout = U.ListLayout(self._tabScroll, Enum.FillDirection.Vertical, 4, Enum.HorizontalAlignment.Center)
    U.Pad(self._tabScroll, 6, 6, 0, 0)
    U.AutoCanvas(self._tabScroll, tabLayout)

    -- ── Page Area ────────────────────────────────────────────
    self._pageArea = U.New("Frame", {
        Name                    = "PageArea",
        Size                    = UDim2.new(1, -158, 1, 0),
        Position                = UDim2.new(0, 158, 0, 0),
        BackgroundColor3        = Theme.ContentBg,
        ZIndex                  = 12,
        Parent                  = self._contentArea,
    })
    U.Corner(self._pageArea, Theme.CornerLg)
    -- fill left & top to square up
    U.New("Frame", { Size = UDim2.new(0,14,1,0), BackgroundColor3 = Theme.ContentBg, BorderSizePixel = 0, ZIndex = 12, Parent = self._pageArea })
    U.New("Frame", { Size = UDim2.new(1,0,0,14), BackgroundColor3 = Theme.ContentBg, BorderSizePixel = 0, ZIndex = 12, Parent = self._pageArea })

    self._pageScroll = U.New("ScrollingFrame", {
        Name                    = "PageScroll",
        Size                    = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency  = 1,
        ScrollBarThickness      = 4,
        ScrollBarImageColor3    = Theme.MainColor,
        ScrollBarImageTransparency = 0.35,
        CanvasSize              = UDim2.new(0, 0, 0, 0),
        ZIndex                  = 13,
        ClipsDescendants        = true,
        Parent                  = self._pageArea,
    })
    U.Corner(self._pageScroll, Theme.CornerLg)

    -- ── Resize Handle ────────────────────────────────────────
    self._resizeHandle = U.New("TextButton", {
        Name                    = "ResizeHandle",
        Size                    = UDim2.new(0, 18, 0, 18),
        Position                = UDim2.new(1, -20, 1, -20),
        BackgroundColor3        = Color3.fromRGB(255,255,255),
        BackgroundTransparency  = 0.55,
        Text                    = "",
        ZIndex                  = 22,
        Parent                  = self._frame,
    })
    U.Corner(self._resizeHandle, Theme.CornerSm)
    U.New("TextLabel", {
        Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
        Text = "⤡", TextColor3 = Theme.MainColor, TextSize = 11,
        Font = Theme.FontBold, ZIndex = 23, Parent = self._resizeHandle,
    })

    self:_setupDragging()
    self:_setupResizing()
    self:_setupControls()
end

function Window:_setupDragging()
    local dragging = false
    local dragStart, startPos

    self._topbar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos  = self._frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch then
            local d = inp.Position - dragStart
            self._frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function Window:_setupResizing()
    local resizing = false
    local resizeStart, startSize

    self._resizeHandle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing    = true
            resizeStart = inp.Position
            startSize   = self._frame.Size
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if not resizing then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement then
            local d  = inp.Position - resizeStart
            local nw = math.max(520, startSize.X.Offset + d.X)
            local nh = math.max(400, startSize.Y.Offset + d.Y)
            self._frame.Size = UDim2.new(0, nw, 0, nh)
            self._savedSize  = self._frame.Size
        end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
end

function Window:_setupControls()
    -- Close
    self._closeBtn.MouseButton1Click:Connect(function()
        T.Spring(self._frame, 0.4, {
            Size     = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
        })
        T.Play(self._frame, 0.3, { BackgroundTransparency = 1 })
        task.delay(0.42, function()
            if self._frame and self._frame.Parent then
                self._frame:Destroy()
            end
        end)
    end)

    -- Minimize
    self._minBtn.MouseButton1Click:Connect(function()
        if self._minimized then
            self._minimized = false
            self._minBtn.Text = "–"
            T.Spring(self._frame, 0.4, { Size = self._savedSize })
        else
            self._minimized = true
            self._savedSize = self._frame.Size
            self._minBtn.Text = "▲"
            T.Spring(self._frame, 0.4, { Size = UDim2.new(0, self._frame.Size.X.Offset, 0, 54) })
        end
    end)

    -- Maximize
    self._maxBtn.MouseButton1Click:Connect(function()
        if self._maximized then
            self._maximized = false
            self._maxBtn.Text = "□"
            T.Spring(self._frame, 0.4, {
                Size     = self._savedSize,
                Position = self._savedPos or UDim2.new(0.5,-320,0.5,-245),
            })
        else
            self._maximized = true
            self._savedSize = self._frame.Size
            self._savedPos  = self._frame.Position
            self._maxBtn.Text = "❐"
            local vp = workspace.CurrentCamera.ViewportSize
            T.Spring(self._frame, 0.4, {
                Size     = UDim2.new(0, vp.X - 16, 0, vp.Y - 16),
                Position = UDim2.new(0, 8, 0, 8),
            })
        end
    end)
end

-- ============================================================
-- 9. TAB CLASS
-- ============================================================
local Tab = {}
Tab.__index = Tab

function Tab.new(window, opts)
    local self      = setmetatable({}, Tab)
    self._window    = window
    self._opts      = opts or {}
    self._name      = opts.Name or "Tab"
    self._icon      = opts.Icon or "◆"
    self._components = {}
    self:_build()
    return self
end

function Tab:_build()
    local win = self._window
    local idx = #win._tabs + 1

    -- Tab button
    self._btn = U.New("TextButton", {
        Name                    = "Tab_" .. self._name,
        Size                    = UDim2.new(1, -14, 0, 38),
        BackgroundColor3        = Color3.fromRGB(255,255,255),
        BackgroundTransparency  = 0.92,
        Text                    = "",
        LayoutOrder             = idx,
        ZIndex                  = 14,
        Parent                  = win._tabScroll,
    })
    U.Corner(self._btn, Theme.CornerMd)
    self._btnStroke = U.Stroke(self._btn, Theme.ComponentStroke, 1.5)
    self._btnStroke.Transparency = 1

    -- Active indicator pill
    self._activePill = U.New("Frame", {
        Name                    = "Pill",
        Size                    = UDim2.new(0, 3, 0.56, 0),
        Position                = UDim2.new(0, 0, 0.22, 0),
        BackgroundColor3        = Theme.MainColor,
        BackgroundTransparency  = 1,
        ZIndex                  = 15,
        Parent                  = self._btn,
    })
    U.Corner(self._activePill, UDim.new(1,0))

    -- Icon
    self._iconLabel = U.New("TextLabel", {
        Name                    = "Icon",
        Size                    = UDim2.new(0, 22, 0, 22),
        Position                = UDim2.new(0, 10, 0.5, -11),
        BackgroundTransparency  = 1,
        Text                    = self._icon,
        TextColor3              = Color3.fromHex("B0DCEE"),
        TextSize                = 13,
        Font                    = Theme.FontBold,
        ZIndex                  = 15,
        Parent                  = self._btn,
    })

    -- Name
    self._nameLabel = U.New("TextLabel", {
        Name                    = "TabName",
        Size                    = UDim2.new(1, -38, 1, 0),
        Position                = UDim2.new(0, 34, 0, 0),
        BackgroundTransparency  = 1,
        Text                    = self._name,
        TextColor3              = Color3.fromHex("B0DCEE"),
        TextSize                = 12,
        Font                    = Theme.FontSemi,
        TextXAlignment          = Enum.TextXAlignment.Left,
        ZIndex                  = 15,
        Parent                  = self._btn,
    })

    -- Page
    self._page = U.New("Frame", {
        Name                    = "Page_" .. self._name,
        Size                    = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency  = 1,
        Visible                 = false,
        ZIndex                  = 14,
        Parent                  = win._pageScroll,
    })

    self._pageLayout = U.ListLayout(self._page, Enum.FillDirection.Vertical, 8, Enum.HorizontalAlignment.Center)
    U.Pad(self._page, 12, 14, 12, 12)

    self._pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local h = self._pageLayout.AbsoluteContentSize.Y + 28
        self._page.Size = UDim2.new(1, 0, 0, h)
        win._pageScroll.CanvasSize = UDim2.new(0, 0, 0, h)
    end)

    -- Tab button interactions
    self._btn.MouseEnter:Connect(function()
        if win._activeTab ~= self then
            T.Play(self._btn,      0.14, { BackgroundTransparency = 0.74 })
            T.Play(self._nameLabel,0.14, { TextColor3 = Color3.fromRGB(255,255,255) })
        end
    end)
    self._btn.MouseLeave:Connect(function()
        if win._activeTab ~= self then
            T.Play(self._btn,      0.14, { BackgroundTransparency = 0.92 })
            T.Play(self._nameLabel,0.14, { TextColor3 = Color3.fromHex("B0DCEE") })
        end
    end)
    self._btn.MouseButton1Click:Connect(function()
        win:_switchTab(self)
    end)

    table.insert(win._tabs, self)

    -- Auto-activate first tab
    if #win._tabs == 1 then
        win:_switchTab(self)
    end
end

-- ── Component helper forwarding ──────────────────────────────
-- All Create* methods are added at the bottom after the factories are defined.

-- ============================================================
-- 10. SECTION CLASS
-- ============================================================
local Section = {}
Section.__index = Section

function Section.new(tab, name)
    local self        = setmetatable({}, Section)
    self._tab         = tab
    self._name        = name or "Section"
    self._collapsed   = false
    self._components  = {}
    self:_build()
    return self
end

function Section:_build()
    local idx = #self._tab._components + 1

    self._frame = U.New("Frame", {
        Name                = "Sec_" .. self._name,
        Size                = UDim2.new(1, 0, 0, 38),
        BackgroundColor3    = Theme.CardBg,
        LayoutOrder         = idx,
        ZIndex              = 14,
        Parent              = self._tab._page,
    })
    U.Corner(self._frame, Theme.CornerMd)
    U.Stroke(self._frame, Theme.ContainerStroke, 1)
    U.Shadow(self._frame)

    -- Header row
    local header = U.New("Frame", {
        Name                    = "Header",
        Size                    = UDim2.new(1, 0, 0, 38),
        BackgroundTransparency  = 1,
        ZIndex                  = 15,
        Parent                  = self._frame,
    })

    U.New("TextLabel", {
        Name                    = "Title",
        Size                    = UDim2.new(1, -46, 1, 0),
        Position                = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency  = 1,
        Text                    = self._name,
        TextColor3              = Theme.MainColor,
        TextSize                = 12,
        Font                    = Theme.FontBold,
        TextXAlignment          = Enum.TextXAlignment.Left,
        ZIndex                  = 16,
        Parent                  = header,
    })

    self._collapseBtn = U.New("TextButton", {
        Name                    = "Collapse",
        Size                    = UDim2.new(0, 24, 0, 24),
        Position                = UDim2.new(1, -32, 0.5, -12),
        BackgroundColor3        = Theme.MainColor,
        BackgroundTransparency  = 0.78,
        Text                    = "▾",
        TextColor3              = Theme.MainColor,
        TextSize                = 11,
        Font                    = Theme.FontBold,
        ZIndex                  = 16,
        Parent                  = header,
    })
    U.Corner(self._collapseBtn, UDim.new(1,0))

    -- Content container
    self._content = U.New("Frame", {
        Name                    = "Content",
        Size                    = UDim2.new(1, 0, 0, 0),
        Position                = UDim2.new(0, 0, 0, 38),
        BackgroundTransparency  = 1,
        ClipsDescendants        = true,
        ZIndex                  = 15,
        Parent                  = self._frame,
    })
    self._contentLayout = U.ListLayout(self._content, Enum.FillDirection.Vertical, 6, Enum.HorizontalAlignment.Center)
    U.Pad(self._content, 6, 10, 10, 10)

    self._contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if not self._collapsed then
            self:_refreshSize()
        end
    end)

    -- Collapse button
    self._collapseBtn.MouseButton1Click:Connect(function()
        self._collapsed = not self._collapsed
        if self._collapsed then
            T.Play(self._collapseBtn, 0.2, { Rotation = -90 })
            T.Play(self._content,    0.3, { Size = UDim2.new(1, 0, 0, 0) })
            T.Play(self._frame,      0.3, { Size = UDim2.new(1, 0, 0, 38) })
        else
            T.Play(self._collapseBtn, 0.2, { Rotation = 0 })
            local h = self._contentLayout.AbsoluteContentSize.Y + 18
            T.Spring(self._content, 0.38, { Size = UDim2.new(1, 0, 0, h) })
            T.Spring(self._frame,   0.38, { Size = UDim2.new(1, 0, 0, 38 + h) })
        end
    end)

    table.insert(self._tab._components, self._frame)
end

function Section:_refreshSize()
    if self._collapsed then return end
    local h = self._contentLayout.AbsoluteContentSize.Y + 18
    self._content.Size = UDim2.new(1, 0, 0, h)
    self._frame.Size   = UDim2.new(1, 0, 0, 38 + h)
end

-- ============================================================
-- 11. COMPONENT FACTORIES
--     Each returns an API table.
-- ============================================================

-- Shared: make a component parent reference
local function resolveParent(host)
    -- host can be Tab or Section
    if host._content then
        return host._content, host._components  -- Section
    else
        return host._page, host._components      -- Tab
    end
end

-- ── LABEL ────────────────────────────────────────────────────
local function CreateLabel(host, opts)
    local parent, comps = resolveParent(host)
    local label = U.New("TextLabel", {
        Name                    = "Label",
        Size                    = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency  = 1,
        Text                    = opts.Text or "Label",
        TextColor3              = opts.Color or Theme.TextPrimary,
        TextSize                = opts.Size or 13,
        Font                    = opts.Bold and Theme.FontBold or Theme.FontSemi,
        TextXAlignment          = opts.Align or Enum.TextXAlignment.Left,
        LayoutOrder             = #comps + 1,
        ZIndex                  = 15,
        Parent                  = parent,
    })
    table.insert(comps, label)
    if host._refreshSize then host:_refreshSize() end

    local api = {}
    function api:Set(text) label.Text = text end
    function api:SetColor(c) label.TextColor3 = c end
    return api
end

-- ── PARAGRAPH ────────────────────────────────────────────────
local function CreateParagraph(host, opts)
    local parent, comps = resolveParent(host)

    local f = U.New("Frame", {
        Name                = "Paragraph",
        Size                = UDim2.new(1, 0, 0, 52),
        BackgroundColor3    = Color3.fromHex("F5FBFF"),
        LayoutOrder         = #comps + 1,
        ZIndex              = 15,
        Parent              = parent,
    })
    U.Corner(f, Theme.CornerSm)
    U.Stroke(f, Theme.ContainerStroke, 1)
    U.Pad(f, 10, 10, 14, 14)

    local titleLbl = U.New("TextLabel", {
        Size                    = UDim2.new(1,0,0,18),
        BackgroundTransparency  = 1,
        Text                    = opts.Title or "",
        TextColor3              = Theme.TextPrimary,
        TextSize                = 12,
        Font                    = Theme.FontBold,
        TextXAlignment          = Enum.TextXAlignment.Left,
        ZIndex                  = 16,
        Parent                  = f,
    })
    local bodyLbl = U.New("TextLabel", {
        Size                    = UDim2.new(1,0,0,28),
        Position                = UDim2.new(0,0,0,20),
        BackgroundTransparency  = 1,
        Text                    = opts.Content or opts.Text or "",
        TextColor3              = Theme.TextSecondary,
        TextSize                = 11,
        Font                    = Theme.FontReg,
        TextXAlignment          = Enum.TextXAlignment.Left,
        TextWrapped             = true,
        ZIndex                  = 16,
        Parent                  = f,
    })

    task.defer(function()
        local ts = U.TextSize(bodyLbl.Text, 11, Theme.FontReg, f.AbsoluteSize.X - 28)
        bodyLbl.Size = UDim2.new(1,0,0,ts.Y)
        f.Size = UDim2.new(1,0,0, 44 + ts.Y)
        if host._refreshSize then host:_refreshSize() end
    end)

    table.insert(comps, f)
    return f
end

-- ── DIVIDER ──────────────────────────────────────────────────
local function CreateDivider(host, opts)
    local parent, comps = resolveParent(host)

    local f = U.New("Frame", {
        Name                    = "Divider",
        Size                    = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency  = 1,
        LayoutOrder             = #comps + 1,
        ZIndex                  = 15,
        Parent                  = parent,
    })
    local line = U.New("Frame", {
        Size                    = UDim2.new(1, -16, 0, 1),
        Position                = UDim2.new(0, 8, 0.5, 0),
        BackgroundColor3        = opts and opts.Color or Theme.MainColor,
        BackgroundTransparency  = 0.68,
        ZIndex                  = 16,
        Parent                  = f,
    })
    U.Corner(line, UDim.new(1,0))

    if opts and opts.Text then
        local bg = U.New("Frame", {
            Size                    = UDim2.new(0, 0, 0, 18),
            Position                = UDim2.new(0.5, 0, 0, 2),
            BackgroundColor3        = Theme.ContentBg,
            AutomaticSize           = Enum.AutomaticSize.X,
            ZIndex                  = 17,
            Parent                  = f,
        })
        local lbl = U.New("TextLabel", {
            Size                    = UDim2.new(0,0,1,0),
            AutomaticSize           = Enum.AutomaticSize.X,
            BackgroundTransparency  = 1,
            Text                    = opts.Text,
            TextColor3              = Theme.TextMuted,
            TextSize                = 10,
            Font                    = Theme.FontReg,
            ZIndex                  = 18,
            Parent                  = bg,
        })
        U.Pad(bg, 0,0,6,6)
        task.defer(function()
            bg.Position = UDim2.new(0.5, -bg.AbsoluteSize.X/2, 0, 2)
        end)
    end

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end
    return f
end

-- ── BUTTON ───────────────────────────────────────────────────
local function CreateButton(host, opts)
    local parent, comps = resolveParent(host)

    local f = U.New("TextButton", {
        Name                    = "Button_" .. (opts.Name or "Btn"),
        Size                    = UDim2.new(1, 0, 0, 40),
        BackgroundColor3        = Theme.ComponentBg,
        Text                    = "",
        LayoutOrder             = #comps + 1,
        ZIndex                  = 15,
        ClipsDescendants        = true,
        Parent                  = parent,
    })
    U.Corner(f, Theme.CornerMd)
    U.Stroke(f, Theme.ComponentStroke, 1.5)

    U.New("TextLabel", {
        Size                    = UDim2.new(1,-46,1,0),
        Position                = UDim2.new(0,12,0,0),
        BackgroundTransparency  = 1,
        Text                    = opts.Name or "Button",
        TextColor3              = Theme.TextPrimary,
        TextSize                = 13,
        Font                    = Theme.FontSemi,
        TextXAlignment          = Enum.TextXAlignment.Left,
        ZIndex                  = 16,
        Parent                  = f,
    })

    local arrow = U.New("TextLabel", {
        Size                    = UDim2.new(0,28,1,0),
        Position                = UDim2.new(1,-32,0,0),
        BackgroundTransparency  = 1,
        Text                    = "›",
        TextColor3              = Theme.MainColor,
        TextSize                = 20,
        Font                    = Theme.FontBold,
        ZIndex                  = 16,
        Parent                  = f,
    })

    f.MouseEnter:Connect(function()
        T.Play(f,     0.14, { BackgroundColor3 = Theme.HoverBg })
        T.Play(arrow, 0.14, { Position = UDim2.new(1,-26,0,0) })
    end)
    f.MouseLeave:Connect(function()
        T.Play(f,     0.14, { BackgroundColor3 = Theme.ComponentBg })
        T.Play(arrow, 0.14, { Position = UDim2.new(1,-32,0,0) })
    end)
    f.MouseButton1Down:Connect(function()
        T.Play(f, 0.08, { BackgroundColor3 = Theme.ActiveBg })
    end)
    f.MouseButton1Up:Connect(function()
        T.Play(f, 0.14, { BackgroundColor3 = Theme.HoverBg })
    end)
    f.MouseButton1Click:Connect(function()
        U.Ripple(f, Mouse.X, Mouse.Y)
        if opts.Callback then task.spawn(opts.Callback) end
    end)

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end
    return f
end

-- ── TOGGLE ───────────────────────────────────────────────────
local function CreateToggle(host, opts)
    local parent, comps = resolveParent(host)
    local value = opts.Default == true

    local f = U.New("Frame", {
        Name                = "Toggle_" .. (opts.Name or "Toggle"),
        Size                = UDim2.new(1, 0, 0, 40),
        BackgroundColor3    = Theme.ComponentBg,
        LayoutOrder         = #comps + 1,
        ZIndex              = 15,
        Parent              = parent,
    })
    U.Corner(f, Theme.CornerMd)
    U.Stroke(f, Theme.ComponentStroke, 1.5)

    U.New("TextLabel", {
        Size                    = UDim2.new(1,-72,1,0),
        Position                = UDim2.new(0,12,0,0),
        BackgroundTransparency  = 1,
        Text                    = opts.Name or "Toggle",
        TextColor3              = Theme.TextPrimary,
        TextSize                = 13,
        Font                    = Theme.FontSemi,
        TextXAlignment          = Enum.TextXAlignment.Left,
        ZIndex                  = 16,
        Parent                  = f,
    })

    -- Track
    local track = U.New("Frame", {
        Name                = "Track",
        Size                = UDim2.new(0, 44, 0, 22),
        Position            = UDim2.new(1, -54, 0.5, -11),
        BackgroundColor3    = value and Theme.ToggleOn or Theme.ToggleOff,
        ZIndex              = 16,
        Parent              = f,
    })
    U.Corner(track, UDim.new(1,0))

    -- Glow behind track
    local glow = U.GlowImage(track, Theme.MainColor, 18, value and 0.5 or 1)

    -- Knob
    local knob = U.New("Frame", {
        Name                = "Knob",
        Size                = UDim2.new(0, 18, 0, 18),
        Position            = value and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9),
        BackgroundColor3    = Color3.fromRGB(255,255,255),
        ZIndex              = 18,
        Parent              = track,
    })
    U.Corner(knob, UDim.new(1,0))

    local clickBtn = U.New("TextButton", {
        Size                    = UDim2.new(1,0,1,0),
        BackgroundTransparency  = 1,
        Text                    = "",
        ZIndex                  = 19,
        Parent                  = f,
    })

    local function refresh()
        if value then
            T.Play(track, 0.22, { BackgroundColor3 = Theme.ToggleOn })
            T.Spring(knob, 0.32, { Position = UDim2.new(1,-20,0.5,-9) })
            T.Play(glow,  0.22, { ImageTransparency = 0.5 })
        else
            T.Play(track, 0.22, { BackgroundColor3 = Theme.ToggleOff })
            T.Spring(knob, 0.32, { Position = UDim2.new(0,2,0.5,-9) })
            T.Play(glow,  0.22, { ImageTransparency = 1 })
        end
    end

    clickBtn.MouseButton1Click:Connect(function()
        value = not value
        refresh()
        if opts.Callback then task.spawn(opts.Callback, value) end
    end)

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end

    local api = { Value = value }
    function api:Set(v)
        value = v == true
        self.Value = value
        refresh()
    end
    function api:Get() return value end
    return api
end

-- ── SLIDER ───────────────────────────────────────────────────
local function CreateSlider(host, opts)
    local parent, comps = resolveParent(host)
    local min     = opts.Min     or 0
    local max     = opts.Max     or 100
    local step    = opts.Step    or 1
    local suffix  = opts.Suffix  or ""
    local value   = math.clamp(opts.Default or min, min, max)

    local f = U.New("Frame", {
        Name                = "Slider_" .. (opts.Name or "Slider"),
        Size                = UDim2.new(1, 0, 0, 58),
        BackgroundColor3    = Theme.ComponentBg,
        LayoutOrder         = #comps + 1,
        ZIndex              = 15,
        Parent              = parent,
    })
    U.Corner(f, Theme.CornerMd)
    U.Stroke(f, Theme.ComponentStroke, 1.5)

    U.New("TextLabel", {
        Size                    = UDim2.new(1,-84,0,22),
        Position                = UDim2.new(0,12,0,8),
        BackgroundTransparency  = 1,
        Text                    = opts.Name or "Slider",
        TextColor3              = Theme.TextPrimary,
        TextSize                = 13,
        Font                    = Theme.FontSemi,
        TextXAlignment          = Enum.TextXAlignment.Left,
        ZIndex                  = 16,
        Parent                  = f,
    })

    local valueLabel = U.New("TextLabel", {
        Size                    = UDim2.new(0,72,0,22),
        Position                = UDim2.new(1,-82,0,8),
        BackgroundTransparency  = 1,
        Text                    = tostring(value) .. suffix,
        TextColor3              = Theme.MainColor,
        TextSize                = 12,
        Font                    = Theme.FontBold,
        TextXAlignment          = Enum.TextXAlignment.Right,
        ZIndex                  = 16,
        Parent                  = f,
    })

    -- Track
    local trackBg = U.New("Frame", {
        Size                = UDim2.new(1,-24,0,8),
        Position            = UDim2.new(0,12,0,38),
        BackgroundColor3    = Color3.fromHex("D8EEFC"),
        ZIndex              = 16,
        Parent              = f,
    })
    U.Corner(trackBg, UDim.new(1,0))

    local fill = U.New("Frame", {
        Name                = "Fill",
        Size                = UDim2.new((value-min)/(max-min), 0, 1, 0),
        BackgroundColor3    = Theme.MainColor,
        ZIndex              = 17,
        Parent              = trackBg,
    })
    U.Corner(fill, UDim.new(1,0))

    -- Shine on fill
    U.New("Frame", {
        Size                    = UDim2.new(0, 22, 1, 0),
        BackgroundColor3        = Color3.fromRGB(255,255,255),
        BackgroundTransparency  = 0.65,
        ZIndex                  = 18,
        Parent                  = fill,
    })

    -- Knob
    local knob = U.New("Frame", {
        Name                = "Knob",
        Size                = UDim2.new(0, 16, 0, 16),
        Position            = UDim2.new((value-min)/(max-min), -8, 0.5, -8),
        BackgroundColor3    = Color3.fromRGB(255,255,255),
        ZIndex              = 19,
        Parent              = trackBg,
    })
    U.Corner(knob, UDim.new(1,0))
    U.Stroke(knob, Theme.MainColor, 2)
    U.GlowImage(knob, Theme.MainColor, 14, 0.65)

    local dragging = false

    local function applyValue(inputPos)
        local rel  = (inputPos.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X
        rel = math.clamp(rel, 0, 1)
        local raw  = min + (max - min) * rel
        local snap = math.round(raw / step) * step
        value = math.clamp(snap, min, max)
        local t = (value - min) / (max - min)
        T.Play(fill, 0.06, { Size = UDim2.new(t, 0, 1, 0) })
        T.Play(knob, 0.06, { Position = UDim2.new(t, -8, 0.5, -8) })
        local disp = math.floor(value * 1000 + 0.5) / 1000
        valueLabel.Text = tostring(disp) .. suffix
        if opts.Callback then task.spawn(opts.Callback, value) end
    end

    trackBg.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            applyValue(inp.Position)
        end
    end)
    knob.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            T.Spring(knob, 0.2, { Size = UDim2.new(0,20,0,20), Position = UDim2.new((value-min)/(max-min),-10,0.5,-10) })
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch then
            applyValue(inp.Position)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                local t = (value-min)/(max-min)
                T.Spring(knob, 0.2, { Size = UDim2.new(0,16,0,16), Position = UDim2.new(t,-8,0.5,-8) })
            end
        end
    end)

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end

    local api = { Value = value }
    function api:Set(v)
        value = math.clamp(v, min, max)
        local t = (value-min)/(max-min)
        fill.Size = UDim2.new(t, 0, 1, 0)
        knob.Position = UDim2.new(t, -8, 0.5, -8)
        valueLabel.Text = tostring(value) .. suffix
        self.Value = value
    end
    return api
end

-- ── TEXTBOX ──────────────────────────────────────────────────
local function CreateTextbox(host, opts)
    local parent, comps = resolveParent(host)

    local f = U.New("Frame", {
        Name                = "TB_" .. (opts.Name or "Textbox"),
        Size                = UDim2.new(1, 0, 0, 58),
        BackgroundColor3    = Theme.ComponentBg,
        LayoutOrder         = #comps + 1,
        ZIndex              = 15,
        Parent              = parent,
    })
    U.Corner(f, Theme.CornerMd)
    local fStroke = U.Stroke(f, Theme.ComponentStroke, 1.5)

    U.New("TextLabel", {
        Size                    = UDim2.new(1,-20,0,20),
        Position                = UDim2.new(0,12,0,8),
        BackgroundTransparency  = 1,
        Text                    = opts.Name or "Textbox",
        TextColor3              = Theme.TextPrimary,
        TextSize                = 12,
        Font                    = Theme.FontSemi,
        TextXAlignment          = Enum.TextXAlignment.Left,
        ZIndex                  = 16,
        Parent                  = f,
    })

    local ibg = U.New("Frame", {
        Size                = UDim2.new(1,-20,0,26),
        Position            = UDim2.new(0,10,0,26),
        BackgroundColor3    = Theme.InputBg,
        ZIndex              = 16,
        Parent              = f,
    })
    U.Corner(ibg, Theme.CornerSm)

    local tb = U.New("TextBox", {
        Size                    = UDim2.new(1,-16,1,0),
        Position                = UDim2.new(0,8,0,0),
        BackgroundTransparency  = 1,
        Text                    = opts.Default or "",
        PlaceholderText         = opts.Placeholder or "Type here...",
        TextColor3              = Theme.TextPrimary,
        PlaceholderColor3       = Theme.TextMuted,
        TextSize                = 12,
        Font                    = Theme.FontReg,
        ClearTextOnFocus        = opts.ClearOnFocus ~= false,
        ZIndex                  = 17,
        Parent                  = ibg,
    })

    tb.Focused:Connect(function()
        T.Play(fStroke, 0.18, { Color = Theme.MainColor, Thickness = 2 })
        T.Play(ibg,     0.18, { BackgroundColor3 = Color3.fromHex("E2F5FF") })
    end)
    tb.FocusLost:Connect(function(enter)
        T.Play(fStroke, 0.18, { Color = Theme.ComponentStroke, Thickness = 1.5 })
        T.Play(ibg,     0.18, { BackgroundColor3 = Theme.InputBg })
        if opts.Callback and (enter or not opts.EnterOnly) then
            task.spawn(opts.Callback, tb.Text)
        end
    end)

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end

    local api = {}
    function api:Set(t) tb.Text = t end
    function api:Get() return tb.Text end
    return api
end

-- ── DROPDOWN ─────────────────────────────────────────────────
local function CreateDropdown(host, opts)
    local parent, comps = resolveParent(host)
    local options  = opts.Options or {}
    local selected = opts.Default or nil
    local isOpen   = false

    local f = U.New("Frame", {
        Name                = "DD_" .. (opts.Name or "Dropdown"),
        Size                = UDim2.new(1, 0, 0, 42),
        BackgroundColor3    = Theme.ComponentBg,
        ClipsDescendants    = false,
        LayoutOrder         = #comps + 1,
        ZIndex              = 15,
        Parent              = parent,
    })
    U.Corner(f, Theme.CornerMd)
    local fStroke = U.Stroke(f, Theme.ComponentStroke, 1.5)

    U.New("TextLabel", {
        Size                    = UDim2.new(0.52,0,1,0),
        Position                = UDim2.new(0,12,0,0),
        BackgroundTransparency  = 1,
        Text                    = opts.Name or "Dropdown",
        TextColor3              = Theme.TextPrimary,
        TextSize                = 13,
        Font                    = Theme.FontSemi,
        TextXAlignment          = Enum.TextXAlignment.Left,
        ZIndex                  = 16,
        Parent                  = f,
    })

    local valLbl = U.New("TextLabel", {
        Size                    = UDim2.new(0.4,0,1,0),
        Position                = UDim2.new(0.52,0,0,0),
        BackgroundTransparency  = 1,
        Text                    = selected or "Select...",
        TextColor3              = selected and Theme.MainColor or Theme.TextMuted,
        TextSize                = 12,
        Font                    = Theme.FontSemi,
        TextXAlignment          = Enum.TextXAlignment.Right,
        ZIndex                  = 16,
        Parent                  = f,
    })

    local arrowLbl = U.New("TextLabel", {
        Size                    = UDim2.new(0,22,1,0),
        Position                = UDim2.new(1,-26,0,0),
        BackgroundTransparency  = 1,
        Text                    = "▾",
        TextColor3              = Theme.MainColor,
        TextSize                = 12,
        Font                    = Theme.FontBold,
        ZIndex                  = 16,
        Parent                  = f,
    })

    -- Dropdown list panel
    local panel = U.New("Frame", {
        Size                = UDim2.new(1,0,0,0),
        Position            = UDim2.new(0,0,1,5),
        BackgroundColor3    = Color3.fromRGB(255,255,255),
        ClipsDescendants    = true,
        Visible             = false,
        ZIndex              = 60,
        Parent              = f,
    })
    U.Corner(panel, Theme.CornerMd)
    U.Stroke(panel, Theme.ComponentStroke, 1.5)
    U.Shadow(panel)

    -- Optional search bar
    local searchBox
    local searchAreaH = 0
    if opts.Searchable ~= false then
        searchAreaH = 36
        local sbg = U.New("Frame", {
            Size                = UDim2.new(1,-12,0,28),
            Position            = UDim2.new(0,6,0,6),
            BackgroundColor3    = Theme.InputBg,
            ZIndex              = 62,
            Parent              = panel,
        })
        U.Corner(sbg, Theme.CornerSm)
        searchBox = U.New("TextBox", {
            Size                    = UDim2.new(1,-12,1,0),
            Position                = UDim2.new(0,6,0,0),
            BackgroundTransparency  = 1,
            Text                    = "",
            PlaceholderText         = "Search...",
            TextColor3              = Theme.TextPrimary,
            PlaceholderColor3       = Theme.TextMuted,
            TextSize                = 11,
            Font                    = Theme.FontReg,
            ClearTextOnFocus        = false,
            ZIndex                  = 63,
            Parent                  = sbg,
        })
    end

    local scroll = U.New("ScrollingFrame", {
        Size                    = UDim2.new(1,0,1,-searchAreaH),
        Position                = UDim2.new(0,0,0,searchAreaH),
        BackgroundTransparency  = 1,
        ScrollBarThickness      = 3,
        ScrollBarImageColor3    = Theme.MainColor,
        CanvasSize              = UDim2.new(0,0,0,0),
        ZIndex                  = 61,
        Parent                  = panel,
    })
    local lay = U.ListLayout(scroll, Enum.FillDirection.Vertical, 2, Enum.HorizontalAlignment.Center)
    U.Pad(scroll, 4, 6, 6, 6)
    U.AutoCanvas(scroll, lay)

    local optItems = {}

    local function buildList(list)
        for _, c in ipairs(scroll:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        optItems = {}
        for i, opt in ipairs(list) do
            local ob = U.New("TextButton", {
                Size                    = UDim2.new(1,0,0,30),
                BackgroundColor3        = (selected == opt) and Theme.HoverBg or Color3.fromRGB(255,255,255),
                Text                    = "",
                LayoutOrder             = i,
                ZIndex                  = 62,
                Parent                  = scroll,
            })
            U.Corner(ob, Theme.CornerSm)

            local ck = U.New("TextLabel", {
                Size                    = UDim2.new(0,20,1,0),
                Position                = UDim2.new(0,4,0,0),
                BackgroundTransparency  = 1,
                Text                    = (selected == opt) and "✓" or "",
                TextColor3              = Theme.MainColor,
                TextSize                = 11,
                Font                    = Theme.FontBold,
                ZIndex                  = 63,
                Parent                  = ob,
            })
            U.New("TextLabel", {
                Size                    = UDim2.new(1,-26,1,0),
                Position                = UDim2.new(0,22,0,0),
                BackgroundTransparency  = 1,
                Text                    = opt,
                TextColor3              = Theme.TextPrimary,
                TextSize                = 12,
                Font                    = Theme.FontReg,
                TextXAlignment          = Enum.TextXAlignment.Left,
                ZIndex                  = 63,
                Parent                  = ob,
            })

            ob.MouseEnter:Connect(function()
                if selected ~= opt then T.Play(ob, 0.11, { BackgroundColor3 = Theme.HoverBg }) end
            end)
            ob.MouseLeave:Connect(function()
                if selected ~= opt then T.Play(ob, 0.11, { BackgroundColor3 = Color3.fromRGB(255,255,255) }) end
            end)
            ob.MouseButton1Click:Connect(function()
                for _, it in ipairs(optItems) do
                    it.check.Text = ""
                    T.Play(it.btn, 0.1, { BackgroundColor3 = Color3.fromRGB(255,255,255) })
                end
                selected = opt
                ck.Text = "✓"
                T.Play(ob, 0.1, { BackgroundColor3 = Theme.HoverBg })
                valLbl.Text = opt
                T.Play(valLbl, 0.18, { TextColor3 = Theme.MainColor })
                -- close
                isOpen = false
                T.Play(arrowLbl, 0.18, { Rotation = 0 })
                T.Play(fStroke, 0.18, { Color = Theme.ComponentStroke })
                T.Play(panel, 0.22, { Size = UDim2.new(1,0,0,0) })
                task.delay(0.24, function() panel.Visible = false end)
                if opts.Callback then task.spawn(opts.Callback, selected) end
            end)

            table.insert(optItems, { btn = ob, check = ck, value = opt })
        end
    end

    buildList(options)

    if searchBox then
        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local q = searchBox.Text:lower()
            for _, it in ipairs(optItems) do
                it.btn.Visible = q == "" or it.value:lower():find(q, 1, true) ~= nil
            end
        end)
    end

    local headerBtn = U.New("TextButton", {
        Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", ZIndex = 17, Parent = f,
    })
    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            local h = math.min(#options * 32 + searchAreaH + 10, 190)
            panel.Visible = true
            panel.Size = UDim2.new(1,0,0,0)
            T.Spring(panel, 0.36, { Size = UDim2.new(1,0,0,h) })
            T.Play(arrowLbl, 0.18, { Rotation = 180 })
            T.Play(fStroke,  0.18, { Color = Theme.MainColor })
        else
            T.Play(panel, 0.22, { Size = UDim2.new(1,0,0,0) })
            T.Play(arrowLbl, 0.18, { Rotation = 0 })
            T.Play(fStroke,  0.18, { Color = Theme.ComponentStroke })
            task.delay(0.24, function() panel.Visible = false end)
        end
    end)

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end

    local api = { Value = selected }
    function api:Set(v)
        selected = v
        valLbl.Text = v or "Select..."
        valLbl.TextColor3 = v and Theme.MainColor or Theme.TextMuted
        self.Value = v
    end
    function api:UpdateOptions(newOpts)
        options = newOpts
        buildList(newOpts)
    end
    return api
end

-- ── MULTI-DROPDOWN ───────────────────────────────────────────
local function CreateMultiDropdown(host, opts)
    local parent, comps = resolveParent(host)
    local options  = opts.Options or {}
    local selected = {}
    local isOpen   = false

    if opts.Default then
        for _, v in ipairs(opts.Default) do selected[v] = true end
    end

    local function selText()
        local n = 0
        local first
        for v in pairs(selected) do n = n + 1; first = v end
        if n == 0 then return "None" end
        if n == 1 then return first end
        return n .. " selected"
    end

    local f = U.New("Frame", {
        Name                = "MDD_" .. (opts.Name or "MultiDD"),
        Size                = UDim2.new(1,0,0,42),
        BackgroundColor3    = Theme.ComponentBg,
        ClipsDescendants    = false,
        LayoutOrder         = #comps + 1,
        ZIndex              = 15,
        Parent              = parent,
    })
    U.Corner(f, Theme.CornerMd)
    local fStroke = U.Stroke(f, Theme.ComponentStroke, 1.5)

    U.New("TextLabel", {
        Size = UDim2.new(0.5,0,1,0), Position = UDim2.new(0,12,0,0),
        BackgroundTransparency = 1, Text = opts.Name or "Multi Select",
        TextColor3 = Theme.TextPrimary, TextSize = 13, Font = Theme.FontSemi,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 16, Parent = f,
    })

    local valLbl = U.New("TextLabel", {
        Size = UDim2.new(0.42,0,1,0), Position = UDim2.new(0.5,0,0,0),
        BackgroundTransparency = 1, Text = selText(),
        TextColor3 = Theme.MainColor, TextSize = 12, Font = Theme.FontSemi,
        TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 16, Parent = f,
    })

    local arrowLbl = U.New("TextLabel", {
        Size = UDim2.new(0,22,1,0), Position = UDim2.new(1,-26,0,0),
        BackgroundTransparency = 1, Text = "▾", TextColor3 = Theme.MainColor,
        TextSize = 12, Font = Theme.FontBold, ZIndex = 16, Parent = f,
    })

    local panel = U.New("Frame", {
        Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,1,5),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        ClipsDescendants = true, Visible = false, ZIndex = 60, Parent = f,
    })
    U.Corner(panel, Theme.CornerMd)
    U.Stroke(panel, Theme.ComponentStroke, 1.5)
    U.Shadow(panel)

    local scroll = U.New("ScrollingFrame", {
        Size = UDim2.new(1,0,1,-6), Position = UDim2.new(0,0,0,6),
        BackgroundTransparency = 1, ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.MainColor, CanvasSize = UDim2.new(0,0,0,0),
        ZIndex = 61, Parent = panel,
    })
    local lay = U.ListLayout(scroll, Enum.FillDirection.Vertical, 2, Enum.HorizontalAlignment.Center)
    U.Pad(scroll, 2, 6, 6, 6)
    U.AutoCanvas(scroll, lay)

    for i, opt in ipairs(options) do
        local ob = U.New("TextButton", {
            Size = UDim2.new(1,0,0,30),
            BackgroundColor3 = selected[opt] and Theme.HoverBg or Color3.fromRGB(255,255,255),
            Text = "", LayoutOrder = i, ZIndex = 62, Parent = scroll,
        })
        U.Corner(ob, Theme.CornerSm)

        local cbx = U.New("Frame", {
            Size = UDim2.new(0,16,0,16), Position = UDim2.new(0,7,0.5,-8),
            BackgroundColor3 = selected[opt] and Theme.MainColor or Color3.fromHex("CCDDE8"),
            ZIndex = 63, Parent = ob,
        })
        U.Corner(cbx, UDim.new(0,4))
        local ck = U.New("TextLabel", {
            Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
            Text = selected[opt] and "✓" or "", TextColor3 = Color3.fromRGB(255,255,255),
            TextSize = 10, Font = Theme.FontBold, ZIndex = 64, Parent = cbx,
        })
        U.New("TextLabel", {
            Size = UDim2.new(1,-32,1,0), Position = UDim2.new(0,28,0,0),
            BackgroundTransparency = 1, Text = opt, TextColor3 = Theme.TextPrimary,
            TextSize = 12, Font = Theme.FontReg, TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 63, Parent = ob,
        })

        ob.MouseButton1Click:Connect(function()
            selected[opt] = not selected[opt]
            if selected[opt] then
                T.Play(cbx, 0.15, { BackgroundColor3 = Theme.MainColor })
                ck.Text = "✓"
                T.Play(ob, 0.1, { BackgroundColor3 = Theme.HoverBg })
            else
                T.Play(cbx, 0.15, { BackgroundColor3 = Color3.fromHex("CCDDE8") })
                ck.Text = ""
                T.Play(ob, 0.1, { BackgroundColor3 = Color3.fromRGB(255,255,255) })
            end
            valLbl.Text = selText()
            local result = {}
            for v in pairs(selected) do table.insert(result, v) end
            if opts.Callback then task.spawn(opts.Callback, result) end
        end)
    end

    local hb = U.New("TextButton", {
        Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", ZIndex = 17, Parent = f,
    })
    hb.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            local h = math.min(#options * 32 + 12, 190)
            panel.Visible = true
            panel.Size = UDim2.new(1,0,0,0)
            T.Spring(panel, 0.36, { Size = UDim2.new(1,0,0,h) })
            T.Play(arrowLbl, 0.18, { Rotation = 180 })
            T.Play(fStroke,  0.18, { Color = Theme.MainColor })
        else
            T.Play(panel, 0.22, { Size = UDim2.new(1,0,0,0) })
            T.Play(arrowLbl, 0.18, { Rotation = 0 })
            T.Play(fStroke,  0.18, { Color = Theme.ComponentStroke })
            task.delay(0.24, function() panel.Visible = false end)
        end
    end)

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end
    return f
end

-- ── SEARCH BAR ───────────────────────────────────────────────
local function CreateSearchBar(host, opts)
    local parent, comps = resolveParent(host)

    local f = U.New("Frame", {
        Name                = "SearchBar",
        Size                = UDim2.new(1,0,0,42),
        BackgroundColor3    = Theme.ComponentBg,
        LayoutOrder         = #comps + 1,
        ZIndex              = 15,
        Parent              = parent,
    })
    U.Corner(f, Theme.CornerMd)
    local fStroke = U.Stroke(f, Theme.ComponentStroke, 1.5)

    U.New("TextLabel", {
        Size = UDim2.new(0,28,1,0), Position = UDim2.new(0,8,0,0),
        BackgroundTransparency = 1, Text = "🔍", TextSize = 14,
        Font = Theme.FontBold, ZIndex = 16, Parent = f,
    })

    local sb = U.New("TextBox", {
        Size                    = UDim2.new(1,-54,1,0),
        Position                = UDim2.new(0,34,0,0),
        BackgroundTransparency  = 1,
        Text                    = "",
        PlaceholderText         = opts and opts.Placeholder or "Search...",
        TextColor3              = Theme.TextPrimary,
        PlaceholderColor3       = Theme.TextMuted,
        TextSize                = 12,
        Font                    = Theme.FontReg,
        ClearTextOnFocus        = false,
        ZIndex                  = 16,
        Parent                  = f,
    })

    local clrBtn = U.New("TextButton", {
        Size = UDim2.new(0,22,0,22), Position = UDim2.new(1,-28,0.5,-11),
        BackgroundColor3 = Color3.fromHex("CCDDE8"), BackgroundTransparency = 0.4,
        Text = "×", TextColor3 = Theme.TextSecondary, TextSize = 14, Font = Theme.FontBold,
        Visible = false, ZIndex = 16, Parent = f,
    })
    U.Corner(clrBtn, UDim.new(1,0))

    sb.Focused:Connect(function()
        T.Play(fStroke, 0.18, { Color = Theme.MainColor, Thickness = 2 })
    end)
    sb.FocusLost:Connect(function()
        T.Play(fStroke, 0.18, { Color = Theme.ComponentStroke, Thickness = 1.5 })
    end)
    sb:GetPropertyChangedSignal("Text"):Connect(function()
        clrBtn.Visible = sb.Text ~= ""
        if opts and opts.Callback then task.spawn(opts.Callback, sb.Text) end
    end)
    clrBtn.MouseButton1Click:Connect(function()
        sb.Text = ""
        clrBtn.Visible = false
    end)

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end
    return f
end

-- ── COLOR PICKER ─────────────────────────────────────────────
local function CreateColorPicker(host, opts)
    local parent, comps = resolveParent(host)
    local hue, sat, val = 0.55, 0.5, 1.0
    local isOpen = false

    if opts.Default then
        hue, sat, val = opts.Default:ToHSV()
    end

    local f = U.New("Frame", {
        Name                = "CP_" .. (opts.Name or "ColorPicker"),
        Size                = UDim2.new(1,0,0,42),
        BackgroundColor3    = Theme.ComponentBg,
        ClipsDescendants    = false,
        LayoutOrder         = #comps + 1,
        ZIndex              = 15,
        Parent              = parent,
    })
    U.Corner(f, Theme.CornerMd)
    U.Stroke(f, Theme.ComponentStroke, 1.5)

    U.New("TextLabel", {
        Size = UDim2.new(1,-72,1,0), Position = UDim2.new(0,12,0,0),
        BackgroundTransparency = 1, Text = opts.Name or "Color Picker",
        TextColor3 = Theme.TextPrimary, TextSize = 13, Font = Theme.FontSemi,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 16, Parent = f,
    })

    local preview = U.New("Frame", {
        Size = UDim2.new(0,34,0,24), Position = UDim2.new(1,-44,0.5,-12),
        BackgroundColor3 = Color3.fromHSV(hue, sat, val), ZIndex = 16, Parent = f,
    })
    U.Corner(preview, Theme.CornerSm)
    U.Stroke(preview, Theme.ComponentStroke, 1)

    -- Picker panel
    local panel = U.New("Frame", {
        Size = UDim2.new(1,0,0,0), Position = UDim2.new(0,0,1,5),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        ClipsDescendants = true, Visible = false, ZIndex = 60, Parent = f,
    })
    U.Corner(panel, Theme.CornerMd)
    U.Stroke(panel, Theme.ComponentStroke, 1.5)
    U.Shadow(panel)

    -- Hue bar
    local hueBar = U.New("Frame", {
        Size = UDim2.new(1,-16,0,16), Position = UDim2.new(0,8,0,10),
        ZIndex = 62, Parent = panel,
    })
    U.Corner(hueBar, UDim.new(1,0))

    local hg = Instance.new("UIGradient")
    hg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0/6, Color3.fromHSV(0/6,1,1)),
        ColorSequenceKeypoint.new(1/6, Color3.fromHSV(1/6,1,1)),
        ColorSequenceKeypoint.new(2/6, Color3.fromHSV(2/6,1,1)),
        ColorSequenceKeypoint.new(3/6, Color3.fromHSV(3/6,1,1)),
        ColorSequenceKeypoint.new(4/6, Color3.fromHSV(4/6,1,1)),
        ColorSequenceKeypoint.new(5/6, Color3.fromHSV(5/6,1,1)),
        ColorSequenceKeypoint.new(1,   Color3.fromHSV(1,  1,1)),
    })
    hg.Parent = hueBar

    local hueKnob = U.New("Frame", {
        Size = UDim2.new(0,14,0,14), Position = UDim2.new(hue,-7,0.5,-7),
        BackgroundColor3 = Color3.fromRGB(255,255,255), ZIndex = 63, Parent = hueBar,
    })
    U.Corner(hueKnob, UDim.new(1,0))
    U.Stroke(hueKnob, Color3.fromRGB(180,180,180), 1.5)

    -- SV area
    local svArea = U.New("Frame", {
        Size = UDim2.new(1,-16,0,80), Position = UDim2.new(0,8,0,34),
        ZIndex = 62, Parent = panel,
    })
    U.Corner(svArea, Theme.CornerSm)

    local svGrad = Instance.new("UIGradient")
    svGrad.Color = ColorSequence.new(Color3.fromHSV(hue,1,1), Color3.fromRGB(255,255,255))
    svGrad.Parent = svArea

    local svBlack = U.New("Frame", {
        Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(0,0,0),
        ZIndex = 63, Parent = svArea,
    })
    U.Corner(svBlack, Theme.CornerSm)
    local svBlackGrad = Instance.new("UIGradient")
    svBlackGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0))
    svBlackGrad.Rotation = 90
    svBlackGrad.Parent = svBlack

    local svKnob = U.New("Frame", {
        Size = UDim2.new(0,12,0,12),
        Position = UDim2.new(sat,-6,1-val,-6),
        BackgroundColor3 = Color3.fromRGB(255,255,255), ZIndex = 65, Parent = svArea,
    })
    U.Corner(svKnob, UDim.new(1,0))
    U.Stroke(svKnob, Color3.fromRGB(180,180,180), 1.5)

    -- Hex input
    local hexBg = U.New("Frame", {
        Size = UDim2.new(1,-16,0,28), Position = UDim2.new(0,8,0,122),
        BackgroundColor3 = Theme.InputBg, ZIndex = 62, Parent = panel,
    })
    U.Corner(hexBg, Theme.CornerSm)
    U.New("TextLabel", {
        Size = UDim2.new(0,22,1,0), BackgroundTransparency = 1,
        Text = "#", TextColor3 = Theme.TextMuted, TextSize = 11, Font = Theme.FontBold,
        ZIndex = 63, Parent = hexBg,
    })

    panel.Size = UDim2.new(1,0,0,160)

    local function refreshColor()
        local c = Color3.fromHSV(hue, sat, val)
        preview.BackgroundColor3 = c
        svGrad.Color = ColorSequence.new(Color3.fromHSV(hue,1,1), Color3.fromRGB(255,255,255))
        if opts.Callback then task.spawn(opts.Callback, c) end
    end

    -- Hue drag
    local hueDrag = false
    hueBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDrag = true
            local rel = math.clamp((inp.Position.X - hueBar.AbsolutePosition.X)/hueBar.AbsoluteSize.X,0,1)
            hue = rel
            hueKnob.Position = UDim2.new(hue,-7,0.5,-7)
            refreshColor()
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if hueDrag and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((inp.Position.X - hueBar.AbsolutePosition.X)/hueBar.AbsoluteSize.X,0,1)
            hue = rel
            hueKnob.Position = UDim2.new(hue,-7,0.5,-7)
            refreshColor()
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then hueDrag = false end
    end)

    -- SV drag
    local svDrag = false
    svArea.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            svDrag = true
            sat = math.clamp((inp.Position.X - svArea.AbsolutePosition.X)/svArea.AbsoluteSize.X,0,1)
            val = 1 - math.clamp((inp.Position.Y - svArea.AbsolutePosition.Y)/svArea.AbsoluteSize.Y,0,1)
            svKnob.Position = UDim2.new(sat,-6,1-val,-6)
            refreshColor()
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if svDrag and inp.UserInputType == Enum.UserInputType.MouseMovement then
            sat = math.clamp((inp.Position.X - svArea.AbsolutePosition.X)/svArea.AbsoluteSize.X,0,1)
            val = 1 - math.clamp((inp.Position.Y - svArea.AbsolutePosition.Y)/svArea.AbsoluteSize.Y,0,1)
            svKnob.Position = UDim2.new(sat,-6,1-val,-6)
            refreshColor()
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then svDrag = false end
    end)

    local hb = U.New("TextButton", {
        Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", ZIndex = 17, Parent = f,
    })
    hb.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            panel.Visible = true
            panel.Size = UDim2.new(1,0,0,0)
            T.Spring(panel, 0.36, { Size = UDim2.new(1,0,0,160) })
        else
            T.Play(panel, 0.22, { Size = UDim2.new(1,0,0,0) })
            task.delay(0.24, function() panel.Visible = false end)
        end
    end)

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end

    local api = { Value = Color3.fromHSV(hue,sat,val) }
    function api:Set(c)
        local h2,s2,v2 = c:ToHSV()
        hue,sat,val = h2,s2,v2
        preview.BackgroundColor3 = c
        hueKnob.Position = UDim2.new(hue,-7,0.5,-7)
        svKnob.Position  = UDim2.new(sat,-6,1-val,-6)
        svGrad.Color = ColorSequence.new(Color3.fromHSV(hue,1,1), Color3.fromRGB(255,255,255))
        self.Value = c
    end
    return api
end

-- ── KEYBIND ──────────────────────────────────────────────────
local function CreateKeybind(host, opts)
    local parent, comps = resolveParent(host)
    local currentKey = opts.Default or Enum.KeyCode.Unknown
    local listening  = false

    local f = U.New("Frame", {
        Name                = "KB_" .. (opts.Name or "Keybind"),
        Size                = UDim2.new(1,0,0,40),
        BackgroundColor3    = Theme.ComponentBg,
        LayoutOrder         = #comps + 1,
        ZIndex              = 15,
        Parent              = parent,
    })
    U.Corner(f, Theme.CornerMd)
    U.Stroke(f, Theme.ComponentStroke, 1.5)

    U.New("TextLabel", {
        Size = UDim2.new(1,-96,1,0), Position = UDim2.new(0,12,0,0),
        BackgroundTransparency = 1, Text = opts.Name or "Keybind",
        TextColor3 = Theme.TextPrimary, TextSize = 13, Font = Theme.FontSemi,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 16, Parent = f,
    })

    local keyBtn = U.New("TextButton", {
        Size = UDim2.new(0,82,0,26), Position = UDim2.new(1,-92,0.5,-13),
        BackgroundColor3 = Theme.HoverBg,
        Text = currentKey ~= Enum.KeyCode.Unknown and currentKey.Name or "None",
        TextColor3 = Theme.MainColor, TextSize = 11, Font = Theme.FontSemi,
        ZIndex = 16, Parent = f,
    })
    U.Corner(keyBtn, Theme.CornerSm)
    U.Stroke(keyBtn, Theme.ComponentStroke, 1.5)

    keyBtn.MouseButton1Click:Connect(function()
        listening = not listening
        if listening then
            keyBtn.Text = "Press..."
            T.Play(keyBtn, 0.15, { BackgroundColor3 = Color3.fromHex("FFF8E0"), TextColor3 = Theme.Accent })
        else
            keyBtn.Text = currentKey ~= Enum.KeyCode.Unknown and currentKey.Name or "None"
            T.Play(keyBtn, 0.15, { BackgroundColor3 = Theme.HoverBg, TextColor3 = Theme.MainColor })
        end
    end)

    UserInputService.InputBegan:Connect(function(inp, gpe)
        if listening and inp.UserInputType == Enum.UserInputType.Keyboard then
            listening   = false
            currentKey  = inp.KeyCode
            keyBtn.Text = currentKey.Name
            T.Play(keyBtn, 0.15, { BackgroundColor3 = Theme.HoverBg, TextColor3 = Theme.MainColor })
            if opts.Callback then task.spawn(opts.Callback, currentKey) end
        elseif not listening and not gpe
        and inp.UserInputType == Enum.UserInputType.Keyboard
        and inp.KeyCode == currentKey then
            if opts.Callback then task.spawn(opts.Callback) end
        end
    end)

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end

    local api = { Value = currentKey }
    function api:Set(k)
        currentKey = k
        keyBtn.Text = k.Name
        self.Value = k
    end
    return api
end

-- ── BINDABLE BUTTON ──────────────────────────────────────────
local function CreateBindableButton(host, opts)
    local parent, comps = resolveParent(host)

    local f = U.New("Frame", {
        Name                = "BindBtn_" .. (opts.Name or "BindBtn"),
        Size                = UDim2.new(1,0,0,40),
        BackgroundColor3    = Theme.ComponentBg,
        ClipsDescendants    = true,
        LayoutOrder         = #comps + 1,
        ZIndex              = 15,
        Parent              = parent,
    })
    U.Corner(f, Theme.CornerMd)
    U.Stroke(f, Theme.ComponentStroke, 1.5)

    U.New("TextLabel", {
        Size = UDim2.new(1,-90,1,0), Position = UDim2.new(0,12,0,0),
        BackgroundTransparency = 1, Text = opts.Name or "Bindable Button",
        TextColor3 = Theme.TextPrimary, TextSize = 13, Font = Theme.FontSemi,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 16, Parent = f,
    })

    local bindPill = U.New("TextLabel", {
        Size = UDim2.new(0,70,0,22), Position = UDim2.new(1,-80,0.5,-11),
        BackgroundColor3 = Theme.HoverBg,
        Text = opts.Bind or "None", TextColor3 = Theme.MainColor,
        TextSize = 10, Font = Theme.FontSemi, ZIndex = 16, Parent = f,
    })
    U.Corner(bindPill, Theme.CornerSm)
    U.Stroke(bindPill, Theme.ComponentStroke, 1)

    local clickBtn = U.New("TextButton", {
        Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", ZIndex = 17, Parent = f,
    })
    clickBtn.MouseEnter:Connect(function() T.Play(f, 0.14, { BackgroundColor3 = Theme.HoverBg }) end)
    clickBtn.MouseLeave:Connect(function() T.Play(f, 0.14, { BackgroundColor3 = Theme.ComponentBg }) end)
    clickBtn.MouseButton1Click:Connect(function()
        U.Ripple(f, Mouse.X, Mouse.Y)
        T.Play(f, 0.08, { BackgroundColor3 = Theme.ActiveBg })
        task.delay(0.12, function() T.Play(f, 0.14, { BackgroundColor3 = Theme.ComponentBg }) end)
        if opts.Callback then task.spawn(opts.Callback) end
    end)

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end
    return f
end

-- ── BINDABLE TOGGLE (alias with BindKey support) ─────────────
local function CreateBindableToggle(host, opts)
    -- Same as toggle but supports a bind key display
    local api = CreateToggle(host, opts)
    return api
end

-- ── PROGRESS BAR ─────────────────────────────────────────────
local function CreateProgressBar(host, opts)
    local parent, comps = resolveParent(host)
    local value = math.clamp(opts.Default or 0, 0, 100)

    local f = U.New("Frame", {
        Name                = "PB_" .. (opts.Name or "Progress"),
        Size                = UDim2.new(1,0,0,52),
        BackgroundColor3    = Theme.ComponentBg,
        LayoutOrder         = #comps + 1,
        ZIndex              = 15,
        Parent              = parent,
    })
    U.Corner(f, Theme.CornerMd)
    U.Stroke(f, Theme.ContainerStroke, 1)

    U.New("TextLabel", {
        Size = UDim2.new(1,-64,0,22), Position = UDim2.new(0,12,0,8),
        BackgroundTransparency = 1, Text = opts.Name or "Progress",
        TextColor3 = Theme.TextPrimary, TextSize = 12, Font = Theme.FontSemi,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 16, Parent = f,
    })

    local valLbl = U.New("TextLabel", {
        Size = UDim2.new(0,50,0,22), Position = UDim2.new(1,-62,0,8),
        BackgroundTransparency = 1, Text = tostring(math.floor(value)) .. "%",
        TextColor3 = Theme.MainColor, TextSize = 12, Font = Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 16, Parent = f,
    })

    local trackBg = U.New("Frame", {
        Size = UDim2.new(1,-24,0,10), Position = UDim2.new(0,12,0,34),
        BackgroundColor3 = Color3.fromHex("D8EEFC"), ZIndex = 16, Parent = f,
    })
    U.Corner(trackBg, UDim.new(1,0))

    local fill = U.New("Frame", {
        Size = UDim2.new(value/100,0,1,0),
        BackgroundColor3 = opts.Color or Theme.MainColor, ZIndex = 17, Parent = trackBg,
    })
    U.Corner(fill, UDim.new(1,0))

    -- Shine
    U.New("Frame", {
        Size = UDim2.new(0,20,1,0), BackgroundColor3 = Color3.fromRGB(255,255,255),
        BackgroundTransparency = 0.6, ZIndex = 18, Parent = fill,
    })

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end

    local api = { Value = value }
    function api:Set(v)
        value = math.clamp(v, 0, 100)
        T.Play(fill, 0.38, { Size = UDim2.new(value/100, 0, 1, 0) }, Enum.EasingStyle.Quart)
        valLbl.Text = tostring(math.floor(value)) .. "%"
        self.Value = value
    end
    return api
end

-- ── LOADING SPINNER ──────────────────────────────────────────
local function CreateLoadingSpinner(host, opts)
    local parent, comps = resolveParent(host)

    local f = U.New("Frame", {
        Name                    = "Spinner",
        Size                    = UDim2.new(1,0,0,60),
        BackgroundTransparency  = 1,
        LayoutOrder             = #comps + 1,
        ZIndex                  = 15,
        Parent                  = parent,
    })

    local ring = U.New("ImageLabel", {
        Size                    = UDim2.new(0,36,0,36),
        Position                = UDim2.new(0.5,-18,0,2),
        BackgroundTransparency  = 1,
        Image                   = "rbxassetid://6905902309",
        ImageColor3             = Theme.MainColor,
        ZIndex                  = 16,
        Parent                  = f,
    })

    U.New("TextLabel", {
        Size                    = UDim2.new(1,0,0,18),
        Position                = UDim2.new(0,0,0,42),
        BackgroundTransparency  = 1,
        Text                    = opts and opts.Text or "Loading...",
        TextColor3              = Theme.TextMuted,
        TextSize                = 11,
        Font                    = Theme.FontReg,
        ZIndex                  = 16,
        Parent                  = f,
    })

    RunService.Heartbeat:Connect(function(dt)
        if ring and ring.Parent then
            ring.Rotation = ring.Rotation + 200 * dt
        end
    end)

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end
    return f
end

-- ── IMAGE ────────────────────────────────────────────────────
local function CreateImage(host, opts)
    local parent, comps = resolveParent(host)

    local f = U.New("Frame", {
        Name                = "Img_Frame",
        Size                = UDim2.new(1,0,0, opts and opts.Height or 100),
        BackgroundColor3    = Color3.fromHex("EAF6FF"),
        LayoutOrder         = #comps + 1,
        ZIndex              = 15,
        Parent              = parent,
    })
    U.Corner(f, Theme.CornerMd)
    U.Stroke(f, Theme.ContainerStroke, 1)

    if opts and opts.Image then
        local img = U.New("ImageLabel", {
            Size                    = UDim2.new(1,0,1,0),
            BackgroundTransparency  = 1,
            Image                   = opts.Image,
            ScaleType               = opts.ScaleType or Enum.ScaleType.Fit,
            ZIndex                  = 16,
            Parent                  = f,
        })
        U.Corner(img, Theme.CornerMd)
    end

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end
    return f
end

-- ── BADGE ────────────────────────────────────────────────────
local function CreateBadge(host, opts)
    local parent, comps = resolveParent(host)

    local f = U.New("Frame", {
        Name                    = "Badge_Row",
        Size                    = UDim2.new(1,0,0,34),
        BackgroundTransparency  = 1,
        LayoutOrder             = #comps + 1,
        ZIndex                  = 15,
        Parent                  = parent,
    })
    U.ListLayout(f, Enum.FillDirection.Horizontal, 6, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)

    local badges = opts.Badges or {{ Text = opts.Text or "Badge", Color = opts.Color or Theme.MainColor }}
    for _, b in ipairs(badges) do
        local bg = U.New("Frame", {
            Size                = UDim2.new(0,0,0,24),
            BackgroundColor3    = b.Color or Theme.MainColor,
            BackgroundTransparency = 0.15,
            AutomaticSize       = Enum.AutomaticSize.X,
            ZIndex              = 16,
            Parent              = f,
        })
        U.Corner(bg, UDim.new(1,0))
        U.Pad(bg, 0,0,10,10)
        U.New("TextLabel", {
            Size                    = UDim2.new(0,0,1,0),
            AutomaticSize           = Enum.AutomaticSize.X,
            BackgroundTransparency  = 1,
            Text                    = b.Text,
            TextColor3              = Color3.fromRGB(255,255,255),
            TextSize                = 10,
            Font                    = Theme.FontBold,
            ZIndex                  = 17,
            Parent                  = bg,
        })
    end

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end
    return f
end

-- ── TOOLTIP ──────────────────────────────────────────────────
local function CreateTooltip(host, opts)
    -- Attach to whatever frame was last added to comps
    local _, comps = resolveParent(host)
    local target   = comps[#comps]
    if not target or not target:IsA("GuiObject") then return end

    local tip = U.New("Frame", {
        Name                    = "Tooltip",
        Size                    = UDim2.new(0,0,0,26),
        AutomaticSize           = Enum.AutomaticSize.X,
        BackgroundColor3        = Color3.fromRGB(38,38,50),
        BackgroundTransparency  = 0.08,
        Visible                 = false,
        ZIndex                  = 90,
        Parent                  = target,
    })
    U.Corner(tip, Theme.CornerSm)
    U.Pad(tip, 0,0,8,8)

    U.New("TextLabel", {
        Size                    = UDim2.new(0,0,1,0),
        AutomaticSize           = Enum.AutomaticSize.X,
        BackgroundTransparency  = 1,
        Text                    = opts and opts.Text or "",
        TextColor3              = Color3.fromRGB(255,255,255),
        TextSize                = 11,
        Font                    = Theme.FontReg,
        ZIndex                  = 91,
        Parent                  = tip,
    })

    target.MouseEnter:Connect(function()
        tip.Visible = true
        tip.Position = UDim2.new(0, Mouse.X - target.AbsolutePosition.X + 12, 0, -30)
        tip.BackgroundTransparency = 1
        T.Play(tip, 0.18, { BackgroundTransparency = 0.08 })
    end)
    target.MouseLeave:Connect(function()
        tip.Visible = false
    end)
    target.MouseMoved:Connect(function()
        tip.Position = UDim2.new(0, Mouse.X - target.AbsolutePosition.X + 12, 0, -30)
    end)

    return tip
end

-- ── AVATAR ───────────────────────────────────────────────────
local function CreateAvatar(host, opts)
    local parent, comps = resolveParent(host)

    local f = U.New("Frame", {
        Name                = "Avatar",
        Size                = UDim2.new(1,0,0,68),
        BackgroundColor3    = Theme.ComponentBg,
        LayoutOrder         = #comps + 1,
        ZIndex              = 15,
        Parent              = parent,
    })
    U.Corner(f, Theme.CornerMd)
    U.Stroke(f, Theme.ContainerStroke, 1)

    local circle = U.New("Frame", {
        Size                = UDim2.new(0,48,0,48),
        Position            = UDim2.new(0,10,0.5,-24),
        BackgroundColor3    = Theme.MainColor,
        BackgroundTransparency = 0.28,
        ZIndex              = 16,
        Parent              = f,
    })
    U.Corner(circle, UDim.new(1,0))
    U.Stroke(circle, Theme.ComponentStroke, 2)

    if opts and opts.UserId then
        local img = U.New("ImageLabel", {
            Size                    = UDim2.new(1,0,1,0),
            BackgroundTransparency  = 1,
            Image                   = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(opts.UserId) .. "&w=60&h=60",
            ZIndex                  = 17,
            Parent                  = circle,
        })
        U.Corner(img, UDim.new(1,0))
    else
        U.New("TextLabel", {
            Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1,
            Text = "👤", TextSize = 22, Font = Theme.FontBold, ZIndex = 17, Parent = circle,
        })
    end

    local displayName = (opts and opts.Name) or "Player"
    if opts and opts.UserId and not opts.Name then
        pcall(function()
            displayName = Players:GetNameFromUserIdAsync(opts.UserId)
        end)
    end

    U.New("TextLabel", {
        Size = UDim2.new(1,-76,0,22), Position = UDim2.new(0,68,0,12),
        BackgroundTransparency = 1, Text = displayName,
        TextColor3 = Theme.TextPrimary, TextSize = 13, Font = Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 16, Parent = f,
    })
    U.New("TextLabel", {
        Size = UDim2.new(1,-76,0,16), Position = UDim2.new(0,68,0,34),
        BackgroundTransparency = 1, Text = (opts and opts.Sub) or "Roblox Player",
        TextColor3 = Theme.TextMuted, TextSize = 11, Font = Theme.FontReg,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 16, Parent = f,
    })

    table.insert(comps, f)
    if host._refreshSize then host:_refreshSize() end
    return f
end

-- ============================================================
-- Wire component methods onto Tab and Section
-- ============================================================
local COMP_MAP = {
    CreateLabel           = CreateLabel,
    CreateParagraph       = CreateParagraph,
    CreateDivider         = CreateDivider,
    CreateButton          = CreateButton,
    CreateToggle          = CreateToggle,
    CreateSlider          = CreateSlider,
    CreateTextbox         = CreateTextbox,
    CreateDropdown        = CreateDropdown,
    CreateMultiDropdown   = CreateMultiDropdown,
    CreateSearchBar       = CreateSearchBar,
    CreateColorPicker     = CreateColorPicker,
    CreateKeybind         = CreateKeybind,
    CreateBindableButton  = CreateBindableButton,
    CreateBindableToggle  = CreateBindableToggle,
    CreateProgressBar     = CreateProgressBar,
    CreateLoadingSpinner  = CreateLoadingSpinner,
    CreateImage           = CreateImage,
    CreateBadge           = CreateBadge,
    CreateTooltip         = CreateTooltip,
    CreateAvatar          = CreateAvatar,
}

for name, fn in pairs(COMP_MAP) do
    Tab[name] = function(self, opts)
        return fn(self, opts)
    end
    Section[name] = function(self, opts)
        return fn(self, opts)
    end
end

-- Section also gets CreateSection (nested)
function Tab:CreateSection(name)
    return Section.new(self, name)
end

-- ============================================================
-- Window:_switchTab
-- ============================================================
function Window:_switchTab(newTab)
    if self._activeTab then
        local prev = self._activeTab
        T.Play(prev._btn,       0.2, { BackgroundTransparency = 0.92 })
        T.Play(prev._nameLabel, 0.2, { TextColor3 = Color3.fromHex("B0DCEE") })
        T.Play(prev._iconLabel, 0.2, { TextColor3 = Color3.fromHex("B0DCEE") })
        T.Play(prev._activePill,0.2, { BackgroundTransparency = 1 })
        T.Play(prev._btnStroke, 0.2, { Transparency = 1 })
        prev._page.Visible = false
    end

    self._activeTab = newTab

    T.Play(newTab._btn,        0.2, { BackgroundTransparency = 0.1 })
    T.Play(newTab._nameLabel,  0.2, { TextColor3 = Color3.fromRGB(255,255,255) })
    T.Play(newTab._iconLabel,  0.2, { TextColor3 = Color3.fromRGB(255,255,255) })
    T.Play(newTab._activePill, 0.2, { BackgroundTransparency = 0 })
    T.Play(newTab._btnStroke,  0.2, { Transparency = 0 })

    newTab._page.Visible = true

    -- Glow flash on selected tab
    U.GlowImage(newTab._btn, Theme.MainColor, 10, 0.7)
    task.delay(0.4, function()
        local g = newTab._btn:FindFirstChild("Glow")
        if g then T.Play(g, 0.3, { ImageTransparency = 1 }) end
        task.delay(0.3, function()
            if g and g.Parent then g:Destroy() end
        end)
    end)

    self._pageScroll.CanvasPosition = Vector2.new(0, 0)
end

-- Window:CreateTab
function Window:CreateTab(opts)
    local tab = Tab.new(self, opts)
    return tab
end

-- ============================================================
-- 12. RESPONSIVE SCALING
-- ============================================================
local function SetupResponsive(screenGui)
    local scale = Instance.new("UIScale")
    scale.Parent = screenGui

    local function update()
        local vp = workspace.CurrentCamera.ViewportSize
        local s
        if vp.X < 540 then
            s = math.clamp(vp.X / 420, 0.48, 0.78)
        elseif vp.X < 900 then
            s = math.clamp(vp.X / 900, 0.72, 0.96)
        else
            s = math.clamp(vp.X / 1280, 0.82, 1.15)
        end
        T.Sine(scale, 0.3, { Scale = s })
    end

    update()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(update)
end

-- ============================================================
-- 13. PUBLIC API  —  Library
-- ============================================================
local LibraryClass = {}
LibraryClass.__index = LibraryClass

function LibraryClass.new()
    local self = setmetatable({}, LibraryClass)
    self._screenGui = U.ScreenGui()
    self._windows   = {}
    self.Theme      = Theme

    InitNotifications(self._screenGui)
    SetupResponsive(self._screenGui)

    return self
end

function LibraryClass:CreateWindow(opts)
    local win = Window.new(self, opts or {})
    table.insert(self._windows, win)

    -- Public window wrapper
    local api = {}

    function api:CreateTab(tabOpts)
        return win:CreateTab(tabOpts)
    end

    function api:SetTitle(t)
        win._titleLabel.Text = t
    end

    function api:SetSubtitle(s)
        win._subtitleLabel.Text = s
    end

    function api:Minimize()
        if not win._minimized then
            win._minBtn.MouseButton1Click:Fire()
        end
    end

    function api:Restore()
        if win._minimized then
            win._minBtn.MouseButton1Click:Fire()
        end
    end

    function api:Close()
        win._closeBtn.MouseButton1Click:Fire()
    end

    function api:Toggle()
        win._frame.Visible = not win._frame.Visible
    end

    return api
end

function LibraryClass:Notify(opts)
    Notify(opts)
end

-- Convenience shortcuts
function LibraryClass:NotifySuccess(title, message, duration)
    Notify({ Type = "Success", Title = title, Message = message, Duration = duration })
end
function LibraryClass:NotifyError(title, message, duration)
    Notify({ Type = "Error", Title = title, Message = message, Duration = duration })
end
function LibraryClass:NotifyWarning(title, message, duration)
    Notify({ Type = "Warning", Title = title, Message = message, Duration = duration })
end
function LibraryClass:NotifyInfo(title, message, duration)
    Notify({ Type = "Info", Title = title, Message = message, Duration = duration })
end

function LibraryClass:KeySystem(opts, onSuccess)
    opts._ScreenGui = self._screenGui
    KeySystem(opts, onSuccess)
end

function LibraryClass:Destroy()
    self._screenGui:Destroy()
end

-- ============================================================
-- RETURN
-- ============================================================
return LibraryClass

--[[
========================================================
USAGE EXAMPLE
========================================================

local Library = require(script).new()

-- Optional: Key system first
Library:KeySystem({
    Title    = "Doraemon Hub",
    Subtitle = "Enter your key to access the hub",
    Keys     = { "DORA-1234-EMON", "FREE-ACCESS-KEY" },
    CopyKey  = "DORA-1234-EMON",
    Discord  = "discord.gg/example",
    GetKey   = "https://linkvertise.com/example",
}, function(success)
    if success then
        -- continue loading
    end
end)

local Window = Library:CreateWindow({
    Title    = "Doraemon Hub",
    Subtitle = "Premium UI v1.0",
})

local Main = Window:CreateTab({
    Name = "Main",
    Icon = "⚡",
})

local Section = Main:CreateSection("Player Settings")

Section:CreateButton({
    Name     = "Fly",
    Callback = function()
        print("Fly toggled!")
    end,
})

Section:CreateToggle({
    Name     = "Auto Farm",
    Default  = false,
    Callback = function(v)
        print("Auto Farm:", v)
    end,
})

Section:CreateSlider({
    Name     = "WalkSpeed",
    Min      = 16,
    Max      = 200,
    Default  = 16,
    Step     = 1,
    Suffix   = " stud/s",
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end,
})

Section:CreateDropdown({
    Name    = "Team",
    Options = { "Blue", "Red", "Green" },
    Callback = function(v)
        print("Team:", v)
    end,
})

Section:CreateTextbox({
    Name        = "Player Name",
    Placeholder = "Type a name...",
    Callback    = function(text)
        print("Name entered:", text)
    end,
})

Section:CreateKeybind({
    Name     = "Toggle UI",
    Default  = Enum.KeyCode.RightControl,
    Callback = function()
        print("Keybind fired!")
    end,
})

-- Notifications
Library:NotifySuccess("Connected", "Successfully joined the server!")
Library:NotifyWarning("Warning", "This action may be detected.")
Library:NotifyError("Error", "Failed to load data.")
Library:NotifyInfo("Info", "Auto farm is now running.")

========================================================
]]

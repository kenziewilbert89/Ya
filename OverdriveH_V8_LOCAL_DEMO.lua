-- Overdrive H V8 LOCAL DEMO
-- Offline demo: no backend, no whitelist, no external modules.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local old = pg:FindFirstChild("OverdriveH_V8_LocalDemo")
if old then old:Destroy() end

local Library = {
    Flags = {},
    Properties = {},
    Tabs = {},
    Theme = {
        Background = Color3.fromRGB(25,25,30),
        Panel = Color3.fromRGB(35,35,45),
        Accent = Color3.fromRGB(55,75,230),
        Text = Color3.fromRGB(245,245,250),
        SubText = Color3.fromRGB(165,165,180)
    }
}

print("=== OVERDRIVE H V8 LOCAL DEMO ===")
print("Server: DISABLED")
print("Whitelist: DISABLED")

local Gui = Instance.new("ScreenGui")
Gui.Name = "OverdriveH_V8_LocalDemo"
Gui.ResetOnSpawn = false
Gui.Parent = pg

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(720,440)
Main.Position = UDim2.fromScale(.5,.5)
Main.AnchorPoint = Vector2.new(.5,.5)
Main.BackgroundColor3 = Library.Theme.Background
Main.BorderSizePixel = 0
Main.Parent = Gui
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke",Main)
stroke.Color = Library.Theme.Accent
stroke.Transparency = .35
stroke.Thickness = 2

local scale = Instance.new("UIScale",Main)

local top = Instance.new("TextButton")
top.Size = UDim2.new(1,0,0,48)
top.BackgroundColor3 = Library.Theme.Panel
top.Text = "⚡ Overdrive H  •  V8 LOCAL DEMO"
top.TextColor3 = Library.Theme.Text
top.Font = Enum.Font.GothamBold
top.TextSize = 16
top.TextXAlignment = Enum.TextXAlignment.Left
top.AutoButtonColor = false
top.Parent = Main
Instance.new("UICorner",top).CornerRadius = UDim.new(0,12)

local tabs = Instance.new("ScrollingFrame")
tabs.Position = UDim2.fromOffset(10,58)
tabs.Size = UDim2.fromOffset(145,360)
tabs.BackgroundColor3 = Library.Theme.Panel
tabs.BorderSizePixel = 0
tabs.ScrollBarThickness = 3
tabs.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabs.Parent = Main
Instance.new("UICorner",tabs).CornerRadius = UDim.new(0,8)

local tabLayout = Instance.new("UIListLayout",tabs)
tabLayout.Padding = UDim.new(0,7)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(165,58)
content.Size = UDim2.new(1,-175,1,-68)
content.BackgroundColor3 = Library.Theme.Panel
content.BorderSizePixel = 0
content.Parent = Main
Instance.new("UICorner",content).CornerRadius = UDim.new(0,8)

local function label(parent,text,size,color,bold)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Size = UDim2.new(1,-20,0,size)
    x.Text = text or ""
    x.TextColor3 = color or Library.Theme.Text
    x.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    x.TextSize = bold and 15 or 13
    x.TextXAlignment = Enum.TextXAlignment.Left
    x.Parent = parent
    return x
end

function Library:Notify(text)
    print("[V8]",text)
    local n = label(Gui,tostring(text),42,Library.Theme.Text,true)
    n.Size = UDim2.fromOffset(290,42)
    n.Position = UDim2.new(1,310,1,-15)
    n.AnchorPoint = Vector2.new(1,1)
    n.BackgroundColor3 = Library.Theme.Panel
    n.BackgroundTransparency = .05
    n.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner",n).CornerRadius = UDim.new(0,8)
    local s=Instance.new("UIStroke",n); s.Color=Library.Theme.Accent; s.Transparency=.35
    TweenService:Create(n,TweenInfo.new(.25),{Position=UDim2.new(1,-15,1,-15)}):Play()
    task.delay(2.2,function()
        if n.Parent then
            TweenService:Create(n,TweenInfo.new(.2),{Position=UDim2.new(1,310,1,-15),TextTransparency=1}):Play()
            task.delay(.25,function() if n.Parent then n:Destroy() end end)
        end
    end)
end

function Library:AddTab(name,icon)
    local tab={Name=name,Properties={}}
    local b=Instance.new("TextButton")
    b.Size=UDim2.fromOffset(130,38)
    b.BackgroundColor3=Library.Theme.Background
    b.Text=(icon and "◈ " or "")..name
    b.TextColor3=Library.Theme.Text
    b.Font=Enum.Font.GothamSemibold
    b.TextSize=12
    b.AutoButtonColor=false
    b.Parent=tabs
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)

    local page=Instance.new("ScrollingFrame")
    page.Position=UDim2.fromOffset(10,10)
    page.Size=UDim2.new(1,-20,1,-20)
    page.BackgroundTransparency=1
    page.BorderSizePixel=0
    page.ScrollBarThickness=3
    page.AutomaticCanvasSize=Enum.AutomaticSize.Y
    page.Visible=false
    page.Parent=content
    local layout=Instance.new("UIListLayout",page); layout.Padding=UDim.new(0,8)

    function tab:registerProperty(p)
        if type(p)~="table" then warn("registerProperty expects table"); return end
        local kind=p.Type or "Label"
        local flag=p.Flag
        local cb=type(p.Callback)=="function" and p.Callback or function() end

        local row=Instance.new("Frame")
        row.Size=UDim2.new(1,-5,0,45)
        row.BackgroundColor3=Library.Theme.Background
        row.BorderSizePixel=0
        row.Parent=page
        Instance.new("UICorner",row).CornerRadius=UDim.new(0,7)

        local txt=label(row,p.Text or p.Title or kind,45,Library.Theme.Text,kind=="Header")
        txt.Position=UDim2.fromOffset(12,0)

        if kind=="Header" then
            row.BackgroundTransparency=1
            row.Size=UDim2.new(1,-5,0,32)
            txt.TextColor3=Library.Theme.Accent
        elseif kind=="Paragraph" then
            row.Size=UDim2.new(1,-5,0,80)
            local d=label(row,p.Description or "",48,Library.Theme.SubText)
            d.Position=UDim2.fromOffset(12,28)
            d.Size=UDim2.new(1,-24,0,48)
            d.TextWrapped=true
        elseif kind=="Button" then
            local x=Instance.new("TextButton")
            x.Position=UDim2.new(1,-145,.5,0); x.AnchorPoint=Vector2.new(0,.5)
            x.Size=UDim2.fromOffset(130,30); x.Text="Execute"
            x.BackgroundColor3=Library.Theme.Accent; x.TextColor3=Library.Theme.Text
            x.Font=Enum.Font.GothamSemibold; x.TextSize=12; x.Parent=row
            Instance.new("UICorner",x).CornerRadius=UDim.new(0,6)
            x.MouseButton1Click:Connect(cb)
        elseif kind=="Toggle" then
            local on=false
            local x=Instance.new("TextButton")
            x.Position=UDim2.new(1,-65,.5,0); x.AnchorPoint=Vector2.new(0,.5)
            x.Size=UDim2.fromOffset(48,24); x.Text=""; x.Parent=row
            x.BackgroundColor3=Color3.fromRGB(70,70,80)
            Instance.new("UICorner",x).CornerRadius=UDim.new(1,0)
            local dot=Instance.new("Frame",x); dot.Size=UDim2.fromOffset(18,18); dot.Position=UDim2.fromOffset(3,3)
            dot.BackgroundColor3=Library.Theme.Text; Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
            local function set(v,fire)
                on=not not v; Library.Flags[flag]=on
                TweenService:Create(x,TweenInfo.new(.15),{BackgroundColor3=on and Library.Theme.Accent or Color3.fromRGB(70,70,80)}):Play()
                TweenService:Create(dot,TweenInfo.new(.15),{Position=on and UDim2.fromOffset(27,3) or UDim2.fromOffset(3,3)}):Play()
                if fire then cb(on) end
            end
            x.MouseButton1Click:Connect(function() set(not on,true) end)
            if flag then Library.Flags[flag]=false; Library.Properties[flag]=function(v)set(v,true)end end
        elseif kind=="Slider" then
            local mn=tonumber(p.Minimum) or 0; local mx=tonumber(p.Maximum) or 100
            local val=math.clamp(tonumber(p.Default) or mn,mn,mx)
            local bar=Instance.new("Frame",row); bar.Position=UDim2.new(1,-205,.5,0); bar.AnchorPoint=Vector2.new(0,.5)
            bar.Size=UDim2.fromOffset(145,6); bar.BackgroundColor3=Color3.fromRGB(65,65,75)
            Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)
            local fill=Instance.new("Frame",bar); fill.BackgroundColor3=Library.Theme.Accent
            Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
            local valueLabel=label(row,tostring(val),20,Library.Theme.SubText)
            valueLabel.Size=UDim2.fromOffset(45,20); valueLabel.Position=UDim2.new(1,-50,.5,0); valueLabel.AnchorPoint=Vector2.new(0,.5)
            valueLabel.TextXAlignment=Enum.TextXAlignment.Right
            local drag=false
            local function set(v,fire)
                val=math.clamp(tonumber(v) or val,mn,mx)
                local a=(val-mn)/(mx-mn); fill.Size=UDim2.fromScale(a,1); valueLabel.Text=tostring(math.floor(val*100)/100)
                Library.Flags[flag]=val; if fire then cb(val) end
            end
            local function mouse(x) set(mn+(mx-mn)*math.clamp((x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1),true) end
            bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true; mouse(i.Position.X) end end)
            UIS.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then mouse(i.Position.X) end end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
            set(val,false); if flag then Library.Properties[flag]=function(v)set(v,true)end end
        elseif kind=="Dropdown" then
            local list=p.Selections or {}; local current=p.Default or list[1] or "None"
            local x=Instance.new("TextButton",row); x.Position=UDim2.new(1,-205,.5,0); x.AnchorPoint=Vector2.new(0,.5)
            x.Size=UDim2.fromOffset(190,30); x.BackgroundColor3=Color3.fromRGB(45,45,55); x.TextColor3=Library.Theme.Text
            x.Font=Enum.Font.Gotham; x.TextSize=11; Instance.new("UICorner",x).CornerRadius=UDim.new(0,6)
            local idx=1; for i,v in ipairs(list)do if v==current then idx=i end end
            local function set(v,fire)
                current=v; x.Text=tostring(v).." ▼"; Library.Flags[flag]=v; if fire then cb(v) end
            end
            x.MouseButton1Click:Connect(function() if #list>0 then idx=idx%#list+1; set(list[idx],true) end end)
            set(current,false); if flag then Library.Properties[flag]=function(v)set(v,true)end end
        elseif kind=="Keybind" then
            local key=p.Default or "RightControl"; local listen=false
            local x=Instance.new("TextButton",row); x.Position=UDim2.new(1,-145,.5,0); x.AnchorPoint=Vector2.new(0,.5)
            x.Size=UDim2.fromOffset(130,30); x.BackgroundColor3=Color3.fromRGB(45,45,55); x.TextColor3=Library.Theme.Text
            x.Text=tostring(key); x.Font=Enum.Font.Gotham; x.TextSize=11; x.Parent=row
            Instance.new("UICorner",x).CornerRadius=UDim.new(0,6)
            x.MouseButton1Click:Connect(function()listen=true;x.Text="Press key..."end)
            UIS.InputBegan:Connect(function(i,g)
                if g then return end
                if listen and i.KeyCode~=Enum.KeyCode.Unknown then key=i.KeyCode.Name;listen=false;x.Text=key;return end
                if i.KeyCode.Name==tostring(key) then cb() end
            end)
            if flag then Library.Flags[flag]=key; Library.Properties[flag]=function(v)key=tostring(v);x.Text=key;Library.Flags[flag]=key end end
        end
        table.insert(tab.Properties,p)
        return row
    end

    b.MouseButton1Click:Connect(function()
        for _,t in ipairs(Library.Tabs)do t.Page.Visible=false;t.Button.BackgroundColor3=Library.Theme.Background end
        page.Visible=true;b.BackgroundColor3=Library.Theme.Accent
    end)
    tab.Button=b;tab.Page=page;table.insert(Library.Tabs,tab)
    if #Library.Tabs==1 then page.Visible=true;b.BackgroundColor3=Library.Theme.Accent end
    return tab
end

function Library:fireProperty(data)
    if type(data)~="table" then return end
    local f=data[1]; local fn=self.Properties[f]
    if fn then fn(data[2]) else warn("Unknown flag:",f) end
end

-- Demo tabs
local main=Library:AddTab("✨ Main", "rbxassetid://6031091004")
main:registerProperty({Type="Header",Text="⚡ Main Features"})
main:registerProperty({Type="Label",Text="V8 LOCAL DEMO — offline mode"})
main:registerProperty({Type="Toggle",Text="Demo Toggle",Flag="DemoToggle",Callback=function(v)print("Demo Toggle:",v);Library:Notify(v and "Toggle ON" or "Toggle OFF")end})
main:registerProperty({Type="Slider",Text="Walk Speed",Default=16,Minimum=1,Maximum=100,Flag="WalkSpeed",Callback=function(v)local c=player.Character;local h=c and c:FindFirstChildOfClass("Humanoid");if h then h.WalkSpeed=v end;print("WalkSpeed:",v)end})
main:registerProperty({Type="Dropdown",Text="Game Mode",Selections={"Classic","Fast","Extreme"},Default="Classic",Flag="GameMode",Callback=function(v)Library:Notify("Mode: "..v)end})
main:registerProperty({Type="Button",Text="Test Notification",Callback=function()Library:Notify("🎉 Local UI works!")end})
main:registerProperty({Type="Keybind",Text="Toggle GUI",Default="RightControl",Callback=function()Main.Visible=not Main.Visible end})

local visual=Library:AddTab("🎨 Visual","rbxassetid://6031091004")
visual:registerProperty({Type="Header",Text="🎨 Visual Demo"})
visual:registerProperty({Type="Toggle",Text="ESP Demo",Flag="ESP",Callback=function(v)print("ESP:",v)end})
visual:registerProperty({Type="Slider",Text="ESP Distance",Default=100,Minimum=10,Maximum=500,Flag="ESPDistance",Callback=function(v)print("ESP Distance:",v)end})
visual:registerProperty({Type="Dropdown",Text="ESP Style",Selections={"Box","Tracer","Both"},Default="Box",Flag="ESPStyle",Callback=function(v)print("ESP Style:",v)end})

local settings=Library:AddTab("⚙️ Settings","rbxassetid://6031091004")
settings:registerProperty({Type="Header",Text="⚙️ Local Settings"})
settings:registerProperty({Type="Slider",Text="UI Scale",Default=1,Minimum=.7,Maximum=1.3,Flag="UIScale",Callback=function(v)scale.Scale=v end})
settings:registerProperty({Type="Button",Text="Reset Demo",Callback=function()scale.Scale=1;Library:fireProperty({"DemoToggle",false});Library:fireProperty({"WalkSpeed",16});Library:Notify("Demo reset!")end})

local about=Library:AddTab("ℹ️ About","rbxassetid://6031091004")
about:registerProperty({Type="Header",Text="ℹ️ Overdrive H V8"})
about:registerProperty({Type="Paragraph",Title="LOCAL DEMO",Description="Offline UI demonstration. Server and whitelist communication are intentionally disabled."})
about:registerProperty({Type="Label",Text="Toggle • Slider • Dropdown • Button • Keybind"})

Library:fireProperty({"DemoToggle",true})
Library:Notify("🚀 Overdrive H V8 Local Demo loaded!")
print("V8 LOCAL DEMO READY | Tabs:",#Library.Tabs)

return Library

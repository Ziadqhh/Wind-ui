--[[
    Deus Evolution UI | Version 3.0.0 (COMPACT & MODERN)
    Created by: Deus Mode (Gemini CLI)
    Style: Minimal Compact | Clean Corners | Modern Flat Design
]]

local DeusUI = {
    Themes = {
        Dark = {
            Main = Color3.fromRGB(22, 22, 30),
            Secondary = Color3.fromRGB(32, 32, 42),
            Outline = Color3.fromRGB(50, 50, 65),
            Text = Color3.fromRGB(240, 240, 245),
            TextSecondary = Color3.fromRGB(150, 150, 165),
            Accent = Color3.fromRGB(95, 135, 255),
            StrokeColor = Color3.fromRGB(65, 65, 85)
        },
        Light = {
            Main = Color3.fromRGB(248, 248, 252),
            Secondary = Color3.fromRGB(235, 235, 245),
            Outline = Color3.fromRGB(195, 195, 210),
            Text = Color3.fromRGB(28, 28, 38),
            TextSecondary = Color3.fromRGB(100, 100, 115),
            Accent = Color3.fromRGB(70, 115, 255),
            StrokeColor = Color3.fromRGB(185, 185, 200)
        },
        Purple = {
            Main = Color3.fromRGB(28, 20, 40),
            Secondary = Color3.fromRGB(45, 32, 65),
            Outline = Color3.fromRGB(90, 60, 130),
            Text = Color3.fromRGB(245, 245, 255),
            TextSecondary = Color3.fromRGB(185, 165, 220),
            Accent = Color3.fromRGB(155, 100, 255),
            StrokeColor = Color3.fromRGB(100, 75, 140)
        },
        Blue = {
            Main = Color3.fromRGB(15, 24, 38),
            Secondary = Color3.fromRGB(25, 40, 58),
            Outline = Color3.fromRGB(50, 70, 98),
            Text = Color3.fromRGB(240, 245, 255),
            TextSecondary = Color3.fromRGB(150, 180, 215),
            Accent = Color3.fromRGB(80, 160, 255),
            StrokeColor = Color3.fromRGB(60, 85, 115)
        },
        Green = {
            Main = Color3.fromRGB(14, 28, 20),
            Secondary = Color3.fromRGB(24, 48, 35),
            Outline = Color3.fromRGB(50, 90, 70),
            Text = Color3.fromRGB(240, 255, 245),
            TextSecondary = Color3.fromRGB(150, 205, 175),
            Accent = Color3.fromRGB(80, 220, 145),
            StrokeColor = Color3.fromRGB(55, 105, 80)
        },
        Custom = {
            Main = Color3.fromRGB(22, 22, 30),
            Secondary = Color3.fromRGB(32, 32, 42),
            Outline = Color3.fromRGB(50, 50, 65),
            Text = Color3.fromRGB(240, 240, 245),
            TextSecondary = Color3.fromRGB(150, 150, 165),
            Accent = Color3.fromRGB(95, 135, 255),
            StrokeColor = Color3.fromRGB(65, 65, 85)
        }
    },
    Icons = {
        ["home"] = "rbxassetid://10734950309",
        ["settings"] = "rbxassetid://10734950056",
        ["fire"] = "rbxassetid://10723343321",
        ["eye"] = "rbxassetid://10723346959",
        ["crown"] = "rbxassetid://10734951157",
        ["swords"] = "rbxassetid://10723343321",
        ["layout"] = "rbxassetid://10734951038",
        ["money"] = "rbxassetid://10734951280",
        ["lock"] = "rbxassetid://10734950185",
        ["check"] = "rbxassetid://10734950641",
        ["copy"] = "rbxassetid://10734950832"
    },
    CurrentTheme = "Dark",
    Elements = {},
    SelectedTab = nil,
    ScreenGui = nil
}

-- Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer

-- Instance Creator
function DeusUI:Create(className, properties, children)
    local inst = Instance.new(className)
    if properties then
        for prop, value in pairs(properties) do
            local success = pcall(function() inst[prop] = value end)
            if not success then
                pcall(function() inst[prop] = value end)
            end
        end
    end
    if children then
        for _, child in pairs(children) do
            if child and typeof(child) == "Instance" then
                child.Parent = inst
            end
        end
    end
    return inst
end

-- Utilities
function DeusUI:GetIcon(name)
    if not name then return nil end
    if name:find("rbxassetid://") then return name end
    local cleanName = name:gsub(".*:", "")
    return self.Icons[cleanName] or self.Icons["home"]
end

function DeusUI:Tween(instance, info, propertyTable)
    local tween = TweenService:Create(instance, info, propertyTable)
    tween:Play()
    return tween
end

-- Stroke Helper
function DeusUI:Stroke(parent, color, thickness, transparency)
    return self:Create("UIStroke", {
        Parent = parent,
        Color = color or Color3.fromRGB(65, 65, 85),
        Thickness = thickness or 1.5,
        Transparency = transparency or 0.4
    })
end

-- Notification System
local NotifyHolder = nil
task.defer(function()
    local NotifyGui = DeusUI:Create("ScreenGui", { Name = "DeusNotify", Parent = (gethui and gethui()) or CoreGui })
    NotifyHolder = DeusUI:Create("Frame", { 
        Name = "Holder", 
        Parent = NotifyGui, 
        Size = UDim2.new(0, 220, 1, 0), 
        Position = UDim2.new(1, -235, 0, 15), 
        BackgroundTransparency = 1 
    }, { 
        DeusUI:Create("UIListLayout", {VerticalAlignment = "Top", Padding = UDim.new(0, 8), HorizontalAlignment = "Center"}) 
    })
end)

function DeusUI:Notify(config)
    if not NotifyHolder then task.wait(0.5) end
    if not NotifyHolder then return end
    local theme = self.Themes[self.CurrentTheme]
    local Toast = self:Create("Frame", { 
        Parent = NotifyHolder, 
        Size = UDim2.new(1, 0, 0, 38), 
        BackgroundColor3 = theme.Main, 
        BorderSizePixel = 0
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        self:Stroke(nil, theme.StrokeColor, 1.2, 0.4),
        self:Create("Frame", {
            Name = "Accent",
            Size = UDim2.new(0, 3, 1, -8),
            Position = UDim2.new(0, 4, 0, 4),
            BackgroundColor3 = theme.Accent,
            BorderSizePixel = 0
        }, {self:Create("UICorner", {CornerRadius = UDim.new(0, 2)})}),
        self:Create("TextLabel", { 
            Text = config.Content or "", 
            Size = UDim2.new(1, -14, 1, 0), 
            Position = UDim2.new(0, 12, 0, 0), 
            BackgroundTransparency = 1, 
            TextColor3 = theme.Text, 
            TextSize = 12, 
            Font = Enum.Font.GothamMedium, 
            TextWrapped = true,
            TextXAlignment = "Left"
        })
    })
    self:Tween(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.05})
    task.delay(config.Duration or 3, function() 
        if Toast then 
            self:Tween(Toast, TweenInfo.new(0.3), {BackgroundTransparency = 1})
            task.wait(0.3)
            Toast:Destroy() 
        end 
    end)
end

-- ColorPicker (Compact)
function DeusUI:OpenColorPicker(defaultColor, callback)
    local theme = self.Themes[self.CurrentTheme]
    local h, s, v = Color3.toHSV(defaultColor)
    local selectedColor = defaultColor
    local Picker = self:Create("Frame", { 
        Parent = self.ScreenGui, 
        Size = UDim2.new(0, 230, 0, 285), 
        Position = UDim2.new(0.5, 0, 0.5, 0), 
        AnchorPoint = Vector2.new(0.5, 0.5), 
        BackgroundColor3 = theme.Main, 
        Active = true, 
        ZIndex = 3000,
        BorderSizePixel = 0
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        self:Stroke(nil, theme.StrokeColor, 1.5, 0.35)
    })
    
    self:Create("TextLabel", {
        Parent = Picker,
        Text = "Color Picker",
        Size = UDim2.new(1, -50, 0, 28),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        TextColor3 = theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = "Left",
        ZIndex = 3001
    })
    
    local CloseBtn = self:Create("TextButton", { 
        Parent = Picker, 
        Size = UDim2.new(0, 22, 0, 22), 
        Position = UDim2.new(1, -28, 0, 10), 
        BackgroundColor3 = Color3.fromRGB(210, 50, 50), 
        Text = "×", 
        TextColor3 = Color3.new(1,1,1), 
        Font = Enum.Font.GothamBold, 
        TextSize = 16, 
        ZIndex = 3001 
    }, {self:Create("UICorner", {CornerRadius = UDim.new(0, 5)})})
    CloseBtn.MouseButton1Click:Connect(function() Picker:Destroy() end)
    
    local SatVib = self:Create("ImageLabel", { 
        Parent = Picker, 
        Size = UDim2.new(0, 160, 0, 160), 
        Position = UDim2.new(0, 14, 0, 40), 
        Image = "rbxassetid://4155801252", 
        BackgroundColor3 = Color3.fromHSV(h, 1, 1), 
        ZIndex = 3001 
    }, {self:Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
    
    local Knob = self:Create("Frame", { 
        Parent = SatVib, 
        Size = UDim2.new(0, 10, 0, 10), 
        Position = UDim2.new(s, 0, 1-v, 0), 
        AnchorPoint = Vector2.new(0.5, 0.5), 
        BackgroundColor3 = Color3.new(1,1,1), 
        ZIndex = 3002 
    }, {self:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), self:Stroke(nil, theme.Accent, 1.5, 0)})
    
    local HueBar = self:Create("Frame", { 
        Parent = Picker, 
        Size = UDim2.new(0, 16, 0, 160), 
        Position = UDim2.new(0, 186, 0, 40), 
        ZIndex = 3001 
    }, {self:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
    
    self:Create("UIGradient", { 
        Rotation = 90, 
        Parent = HueBar, 
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)), 
            ColorSequenceKeypoint.new(0.2, Color3.fromHSV(0.2,1,1)), 
            ColorSequenceKeypoint.new(0.4, Color3.fromHSV(0.4,1,1)), 
            ColorSequenceKeypoint.new(0.6, Color3.fromHSV(0.6,1,1)), 
            ColorSequenceKeypoint.new(0.8, Color3.fromHSV(0.8,1,1)), 
            ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1))
        }) 
    })
    
    local HueKnob = self:Create("Frame", { 
        Parent = HueBar, 
        Size = UDim2.new(1, 4, 0, 4), 
        Position = UDim2.new(0.5, 0, h, 0), 
        AnchorPoint = Vector2.new(0.5, 0.5), 
        BackgroundColor3 = Color3.new(1,1,1), 
        ZIndex = 3002 
    })
    
    local HexBox = self:Create("TextBox", { 
        Parent = Picker, 
        Size = UDim2.new(0, 100, 0, 26), 
        Position = UDim2.new(0, 14, 0, 212), 
        BackgroundColor3 = theme.Secondary, 
        Text = "#" .. selectedColor:ToHex(), 
        TextColor3 = theme.Text, 
        Font = Enum.Font.GothamMedium, 
        TextSize = 11, 
        ZIndex = 3001 
    }, {self:Create("UICorner", {CornerRadius = UDim.new(0, 5)})})
    
    local Apply = self:Create("TextButton", { 
        Parent = Picker, 
        Size = UDim2.new(1, -28, 0, 30), 
        Position = UDim2.new(0.5, 0, 1, -14), 
        AnchorPoint = Vector2.new(0.5, 1), 
        BackgroundColor3 = theme.Accent, 
        Text = "Apply", 
        TextColor3 = Color3.new(1,1,1), 
        Font = Enum.Font.GothamBold, 
        TextSize = 13, 
        ZIndex = 3001 
    }, {self:Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
    
    Apply.MouseButton1Click:Connect(function() callback(selectedColor); Picker:Destroy() end)
    
    local function update() 
        selectedColor = Color3.fromHSV(h, s, v)
        SatVib.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        HexBox.Text = "#" .. selectedColor:ToHex()
        Knob.Position = UDim2.new(s, 0, 1-v, 0)
        HueKnob.Position = UDim2.new(0.5, 0, h, 0)
    end
    
    local dragSV, dragH = false, false
    SatVib.InputBegan:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then dragSV = true end end)
    HueBar.InputBegan:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then dragH = true end end)
    UserInputService.InputChanged:Connect(function(i) 
        if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then 
            if dragSV then 
                local px = Vector2.new(i.Position.X - SatVib.AbsolutePosition.X, i.Position.Y - SatVib.AbsolutePosition.Y)
                s = math.clamp(px.X / SatVib.AbsoluteSize.X, 0, 1)
                v = 1 - math.clamp(px.Y / SatVib.AbsoluteSize.Y, 0, 1)
                update() 
            elseif dragH then 
                h = math.clamp((i.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                update() 
            end 
        end 
    end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then dragSV = false; dragH = false end end)
    
    update()
end

-- Main Window (COMPACT)
function DeusUI:CreateWindow(config)
    local theme = self.Themes[self.CurrentTheme]
    local ScreenGui = self:Create("ScreenGui", { Name = "DeusUI", Parent = (gethui and gethui()) or CoreGui, ResetOnSpawn = false })
    self.ScreenGui = ScreenGui
    
    local Main = self:Create("Frame", { 
        Name = "Main", 
        Parent = ScreenGui, 
        BackgroundColor3 = theme.Main, 
        Position = UDim2.new(0.5, -240, 0.5, -155), 
        Size = UDim2.new(0, 480, 0, 310), 
        ClipsDescendants = true, 
        ZIndex = 1,
        BorderSizePixel = 0
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Stroke(nil, theme.StrokeColor, 1.5, 0.3)
    })
    
    -- Topbar
    local Topbar = self:Create("Frame", { 
        Name = "Topbar", 
        Parent = Main, 
        Size = UDim2.new(1, 0, 0, 36), 
        BackgroundTransparency = 1, 
        ZIndex = 2 
    })
    
    self:Create("TextLabel", { 
        Parent = Topbar, 
        Text = config.Title or "Deus UI", 
        Size = UDim2.new(1, -80, 1, 0), 
        Position = UDim2.new(0, 12, 0, 0), 
        BackgroundTransparency = 1, 
        TextColor3 = theme.Text, 
        TextSize = 14, 
        Font = Enum.Font.GothamBold, 
        TextXAlignment = "Left", 
        ZIndex = 3 
    })
    
    local SepLine = self:Create("Frame", { 
        Parent = Topbar, 
        Size = UDim2.new(1, -20, 0, 1), 
        Position = UDim2.new(0, 10, 1, 0), 
        BackgroundColor3 = theme.Outline, 
        BackgroundTransparency = 0.85, 
        BorderSizePixel = 0 
    })

    -- Window Controls
    local WinSize = UDim2.new(0, 480, 0, 310)
    local isMin = false
    local CtrlHolder = self:Create("Frame", { 
        Parent = Topbar, 
        Size = UDim2.new(0, 60, 0, 24), 
        Position = UDim2.new(1, -8, 0, 6), 
        AnchorPoint = Vector2.new(1, 0), 
        BackgroundTransparency = 1 
    }, {
        self:Create("UIListLayout", {FillDirection = "Horizontal", Padding = UDim.new(0, 5), VerticalAlignment = "Center", HorizontalAlignment = "Right"})
    })
    
    local MinBtn = self:Create("TextButton", { 
        Size = UDim2.new(0, 22, 0, 22), 
        BackgroundColor3 = theme.Secondary, 
        Text = "−", 
        TextColor3 = theme.Text, 
        TextSize = 16, 
        Font = Enum.Font.GothamBold 
    }, {self:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
    MinBtn.Parent = CtrlHolder
    
    local CloseBtn = self:Create("TextButton", { 
        Size = UDim2.new(0, 22, 0, 22), 
        BackgroundColor3 = Color3.fromRGB(200, 45, 45), 
        Text = "×", 
        TextColor3 = Color3.new(1,1,1), 
        TextSize = 16, 
        Font = Enum.Font.GothamBold 
    }, {self:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
    CloseBtn.Parent = CtrlHolder
    
    -- Sidebar
    local Sidebar = self:Create("Frame", { 
        Name = "Sidebar", 
        Parent = Main, 
        Size = UDim2.new(0, 140, 1, -76), 
        Position = UDim2.new(0, 8, 0, 44), 
        BackgroundColor3 = theme.Secondary, 
        BorderSizePixel = 0
    }, { 
        self:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
        self:Stroke(nil, theme.StrokeColor, 1, 0.35),
        self:Create("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4)})
    })
    
    local TabScroll = self:Create("ScrollingFrame", { 
        Parent = Sidebar, 
        Size = UDim2.new(1, 0, 1, 0), 
        BackgroundTransparency = 1, 
        ScrollBarThickness = 0, 
        AutomaticCanvasSize = "Y"
    }, { 
        self:Create("UIListLayout", {Padding = UDim.new(0, 4)}) 
    })
    
    local PageCont = self:Create("Frame", { 
        Parent = Main, 
        Size = UDim2.new(1, -160, 1, -76), 
        Position = UDim2.new(0, 156, 0, 44), 
        BackgroundTransparency = 1 
    })
    
    -- Status Bar
    local Status = self:Create("Frame", { 
        Parent = Main, 
        Size = UDim2.new(1, -16, 0, 22), 
        Position = UDim2.new(0, 8, 1, -28), 
        BackgroundColor3 = theme.Secondary,
        BorderSizePixel = 0
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
        self:Stroke(nil, theme.StrokeColor, 1, 0.4),
        self:Create("TextLabel", { 
            Name = "Text", 
            Size = UDim2.new(1, 0, 1, 0), 
            BackgroundTransparency = 1, 
            Text = "FPS: 60 | Ping: 0ms", 
            TextColor3 = theme.TextSecondary, 
            TextSize = 10, 
            Font = Enum.Font.GothamMedium,
            TextXAlignment = "Center"
        })
    })
    
    MinBtn.MouseButton1Click:Connect(function()
        isMin = not isMin
        self:Tween(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = isMin and UDim2.new(0, 480, 0, 36) or WinSize})
        Sidebar.Visible = not isMin
        PageCont.Visible = not isMin
        Status.Visible = not isMin
        SepLine.Visible = not isMin
    end)
    
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    -- Dragging
    local drag, dragP, startP
    Topbar.InputBegan:Connect(function(i) 
        if (i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch")) and not isMin then 
            drag = true
            dragP = i.Position
            startP = Main.Position
            i.Changed:Connect(function() if i.UserInputState.Name:find("End") then drag = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i) 
        if drag and (i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch")) then 
            local d = i.Position - dragP
            Main.Position = UDim2.new(startP.X.Scale, startP.X.Offset + d.X, startP.Y.Scale, startP.Y.Offset + d.Y) 
        end 
    end)
    
    -- Theme updater
    local function updateTheme()
        local t = DeusUI.Themes[DeusUI.CurrentTheme]
        self:Tween(Main, TweenInfo.new(0.2), {BackgroundColor3 = t.Main})
        self:Tween(Sidebar, TweenInfo.new(0.2), {BackgroundColor3 = t.Secondary})
        SepLine.BackgroundColor3 = t.Outline
        Status.Text.TextColor3 = t.TextSecondary
        for _, el in pairs(DeusUI.Elements) do
            if el.Type == "Tab" then
                el.Instance.BackgroundColor3 = el.Sel and t.Accent or t.Main
                el.Instance.Label.TextColor3 = el.Sel and t.Text or t.TextSecondary
                if el.Instance:FindFirstChild("Icon") then el.Instance.Icon.ImageColor3 = el.Sel and t.Text or t.TextSecondary end
            elseif el.Type == "Button" then el.Instance.BackgroundColor3 = t.Secondary; el.Instance.Btn.TextColor3 = t.Text
            elseif el.Type == "Text" then el.Instance.TextColor3 = t.Text
            elseif el.Type == "Accent" then el.Instance.TextColor3 = t.Accent end
        end
    end

    local Window = {}
    function Window:Tab(tabCfg)
        local title = tabCfg.Title or "Tab"
        local icon = DeusUI:GetIcon(tabCfg.Icon)

        local Page = DeusUI:Create("ScrollingFrame", {
            Parent = PageCont,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = theme.Accent,
            AutomaticCanvasSize = "Y"
        }, {
            DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 6)})
        })

        local TabBtn = DeusUI:Create("TextButton", {
            Parent = TabScroll,
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = theme.Main,
            Text = "",
            AutoButtonColor = false,
            BorderSizePixel = 0
        }, {
            DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
            DeusUI:Stroke(nil, theme.StrokeColor, 1, 0.45),
            DeusUI:Create("UIListLayout", {FillDirection = "Horizontal", VerticalAlignment = "Center", Padding = UDim.new(0, 6), HorizontalAlignment = "Center"}),
            icon and DeusUI:Create("ImageLabel", {Size = UDim2.new(0, 15, 0, 15), BackgroundTransparency = 1, Image = icon, ImageColor3 = theme.TextSecondary}) or nil,
            DeusUI:Create("TextLabel", {Name = "Label", Text = title, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = "X", BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, TextSize = 12, Font = Enum.Font.GothamMedium})
        })
        
        local tabObj = {Type = "Tab", Instance = TabBtn, Sel = false}
        table.insert(DeusUI.Elements, tabObj)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(PageCont:GetChildren()) do p.Visible = false end
            for _, el in pairs(DeusUI.Elements) do
                if el.Type == "Tab" then
                    el.Sel = false
                    el.Instance.BackgroundColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Main
                    el.Instance.Label.TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].TextSecondary
                    if el.Instance:FindFirstChild("ImageLabel") then el.Instance.ImageLabel.ImageColor3 = DeusUI.Themes[DeusUI.CurrentTheme].TextSecondary end
                end
            end
            Page.Visible = true
            tabObj.Sel = true
            TabBtn.BackgroundColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent
            TabBtn.Label.TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Text
            if TabBtn:FindFirstChild("ImageLabel") then TabBtn.ImageLabel.ImageColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Text end
        end)
        
        if not DeusUI.SelectedTab then
            DeusUI.SelectedTab = true
            Page.Visible = true
            tabObj.Sel = true
            TabBtn.BackgroundColor3 = theme.Accent
            TabBtn.Label.TextColor3 = theme.Text
            if TabBtn:FindFirstChild("ImageLabel") then TabBtn.ImageLabel.ImageColor3 = theme.Text end
        end
        
        local Tab = {}
        local function lock(frame, locked, msg)
            if locked then
                DeusUI:Create("Frame", {
                    Parent = frame, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.55, ZIndex = 100, Active = true
                }, {
                    DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                    DeusUI:Create("TextLabel", {Text = "🔒 " .. (msg or "VIP"), Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 11})
                })
            end
        end

        function Tab:Button(cfg)
            local f = DeusUI:Create("Frame", {
                Parent = Page,
                Size = UDim2.new(0.94, 0, 0, 34),
                BackgroundColor3 = theme.Secondary,
                BorderSizePixel = 0
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                DeusUI:Stroke(nil, theme.StrokeColor, 1.2, 0.35),
                DeusUI:Create("TextButton", {Name = "Btn", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = cfg.Title or "Button", TextColor3 = theme.Text, TextSize = 12, Font = Enum.Font.GothamBold})
            })
            f.Btn.MouseButton1Click:Connect(function() cfg.Callback() end)
            table.insert(DeusUI.Elements, {Type = "Button", Instance = f})
            lock(f, cfg.Locked, cfg.LockMessage)
        end

        function Tab:Toggle(cfg)
            local on = cfg.Default or false
            local f = DeusUI:Create("Frame", {
                Parent = Page,
                Size = UDim2.new(0.94, 0, 0, 36),
                BackgroundColor3 = theme.Secondary,
                BorderSizePixel = 0
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                DeusUI:Stroke(nil, theme.StrokeColor, 1.2, 0.35),
                DeusUI:Create("TextLabel", {Text = cfg.Title or "Toggle", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 12, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -55, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = "Left"})
            })
            local sw = DeusUI:Create("TextButton", {
                Parent = f,
                Size = UDim2.new(0, 36, 0, 18),
                Position = UDim2.new(1, -6, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = on and theme.Accent or Color3.fromRGB(60, 60, 70),
                Text = ""
            }, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            local cir = DeusUI:Create("Frame", {
                Parent = sw,
                Size = UDim2.new(0, 14, 0, 14),
                Position = on and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                AnchorPoint = on and Vector2.new(1, 0.5) or Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.new(1, 1, 1)
            }, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            sw.MouseButton1Click:Connect(function()
                on = not on
                DeusUI:Tween(cir, TweenInfo.new(0.2), {Position = on and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), AnchorPoint = on and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)})
                DeusUI:Tween(sw, TweenInfo.new(0.2), {BackgroundColor3 = on and theme.Accent or Color3.fromRGB(60, 60, 70)})
                cfg.Callback(on)
            end)
            table.insert(DeusUI.Elements, {Type = "Text", Instance = f:FindFirstChild("TextLabel")})
            lock(f, cfg.Locked, cfg.LockMessage)
        end

        function Tab:Slider(cfg)
            local mn, mx, val = cfg.Min or 0, cfg.Max or 100, cfg.Default or 50
            local f = DeusUI:Create("Frame", {
                Parent = Page,
                Size = UDim2.new(0.94, 0, 0, 50),
                BackgroundColor3 = theme.Secondary,
                BorderSizePixel = 0
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                DeusUI:Stroke(nil, theme.StrokeColor, 1.2, 0.35),
                DeusUI:Create("TextLabel", {Name = "Title", Text = cfg.Title or "Slider", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 12, Font = Enum.Font.GothamMedium, Size = UDim2.new(0.65, 0, 0, 18), Position = UDim2.new(0, 10, 0, 6), TextXAlignment = "Left"}),
                DeusUI:Create("TextLabel", {Name = "Val", Text = tostring(val), BackgroundTransparency = 1, TextColor3 = theme.Accent, TextSize = 12, Font = Enum.Font.GothamBold, Size = UDim2.new(0.35, 0, 0, 18), Position = UDim2.new(0.65, 0, 0, 6), TextXAlignment = "Right"})
            })
            local bar = DeusUI:Create("Frame", {Parent = f, Size = UDim2.new(1, -16, 0, 4), Position = UDim2.new(0, 8, 0, 32), BackgroundColor3 = theme.Main, BackgroundTransparency = 0.5}, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            local fill = DeusUI:Create("Frame", {Parent = bar, Size = UDim2.new((val-mn)/(mx-mn), 0, 1, 0), BackgroundColor3 = theme.Accent}, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            local knob = DeusUI:Create("Frame", {Parent = fill, Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1,1,1)}, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), DeusUI:Stroke(nil, theme.Accent, 1.5, 0)})
            local dragging = false
            local function upd(i) local p = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1); val = math.floor(mn + (mx-mn)*p); f.Val.Text = tostring(val); fill.Size = UDim2.new(p, 0, 1, 0); cfg.Callback(val) end
            bar.InputBegan:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then dragging = true; upd(i) end end)
            UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch")) then upd(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then dragging = false end end)
            table.insert(DeusUI.Elements, {Type = "Text", Instance = f.Title})
            table.insert(DeusUI.Elements, {Type = "Accent", Instance = f.Val})
            lock(f, cfg.Locked, cfg.LockMessage)
        end

        function Tab:Dropdown(cfg)
            local vals = cfg.Values or {}
            local sel = cfg.Default or "Select"
            local open = false
            local f = DeusUI:Create("Frame", {
                Parent = Page,
                Size = UDim2.new(0.94, 0, 0, 36),
                BackgroundColor3 = theme.Secondary,
                ClipsDescendants = true,
                BorderSizePixel = 0
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                DeusUI:Stroke(nil, theme.StrokeColor, 1.2, 0.35)
            })
            local hdr = DeusUI:Create("TextButton", {Parent = f, Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Text = ""})
            DeusUI:Create("TextLabel", {Parent = hdr, Text = cfg.Title or "Dropdown", Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = "Left"})
            local cont = DeusUI:Create("TextLabel", {Parent = hdr, Text = sel, Size = UDim2.new(0.45, 0, 1, 0), Position = UDim2.new(0.3, 0, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, Font = Enum.Font.GothamMedium, TextSize = 11, TextXAlignment = "Right"})
            local arr = DeusUI:Create("TextLabel", {Parent = hdr, Text = "▼", Size = UDim2.new(0.15, 0, 1, 0), Position = UDim2.new(0.85, 0, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Accent, Font = Enum.Font.GothamBold, TextSize = 9, TextXAlignment = "Center"})
            local items = DeusUI:Create("Frame", {Parent = f, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 30), BackgroundTransparency = 1, Visible = false}, {DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 3)})})
            for _, v in pairs(vals) do
                local ib = DeusUI:Create("TextButton", {Parent = items, Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = theme.Main, BackgroundTransparency = 0.2, Text = "  " .. v, TextColor3 = theme.Text, Font = Enum.Font.GothamMedium, TextSize = 11, TextXAlignment = "Left"}, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
                ib.MouseButton1Click:Connect(function() sel = v; cont.Text = sel; open = false; f.Size = UDim2.new(0.94, 0, 0, 36); items.Visible = false; DeusUI:Tween(arr, TweenInfo.new(0.2), {Rotation = 0}); cfg.Callback(sel) end)
            end
            hdr.MouseButton1Click:Connect(function()
                open = not open
                if open then f.Size = UDim2.new(0.94, 0, 0, 36 + (#vals * 27)); items.Visible = true; DeusUI:Tween(arr, TweenInfo.new(0.2), {Rotation = 180})
                else f.Size = UDim2.new(0.94, 0, 0, 36); items.Visible = false; DeusUI:Tween(arr, TweenInfo.new(0.2), {Rotation = 0}) end
            end)
            table.insert(DeusUI.Elements, {Type = "Text", Instance = hdr:FindFirstChild("TextLabel")})
            lock(f, cfg.Locked, cfg.LockMessage)
        end

        function Tab:Keybind(cfg)
            local key = cfg.Default or Enum.KeyCode.F
            local f = DeusUI:Create("Frame", {
                Parent = Page,
                Size = UDim2.new(0.94, 0, 0, 36),
                BackgroundColor3 = theme.Secondary,
                BorderSizePixel = 0
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                DeusUI:Stroke(nil, theme.StrokeColor, 1.2, 0.35),
                DeusUI:Create("TextLabel", {Text = cfg.Title or "Keybind", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 12, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = "Left"})
            })
            local btn = DeusUI:Create("TextButton", {Parent = f, Size = UDim2.new(0, 65, 0, 24), Position = UDim2.new(1, -8, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = theme.Main, BackgroundTransparency = 0.3, Text = key.Name, TextColor3 = theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11}, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 5)})})
            btn.MouseButton1Click:Connect(function() btn.Text = "..."; local c; c = UserInputService.InputBegan:Connect(function(i) if i.UserInputType.Name:find("Keyboard") then key = i.KeyCode; btn.Text = key.Name; c:Disconnect(); cfg.Callback(key) end end) end)
            table.insert(DeusUI.Elements, {Type = "Text", Instance = f:FindFirstChild("TextLabel")})
            lock(f, cfg.Locked, cfg.LockMessage)
        end

        function Tab:Colorpicker(cfg)
            local clr = cfg.Default or Color3.fromRGB(0, 162, 255)
            local f = DeusUI:Create("Frame", {
                Parent = Page,
                Size = UDim2.new(0.94, 0, 0, 36),
                BackgroundColor3 = theme.Secondary,
                BorderSizePixel = 0
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                DeusUI:Stroke(nil, theme.StrokeColor, 1.2, 0.35),
                DeusUI:Create("TextLabel", {Text = cfg.Title or "Color", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 12, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -55, 1, 0), Position = UDim2.new(0, 10, 0, 0), TextXAlignment = "Left"})
            })
            local view = DeusUI:Create("TextButton", {Parent = f, Size = UDim2.new(0, 38, 0, 22), Position = UDim2.new(1, -8, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = clr, Text = ""}, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 5)})})
            view.MouseButton1Click:Connect(function() DeusUI:OpenColorPicker(clr, function(nc) clr = nc; view.BackgroundColor3 = nc; cfg.Callback(nc) end) end)
            table.insert(DeusUI.Elements, {Type = "Text", Instance = f:FindFirstChild("TextLabel")})
            lock(f, cfg.Locked, cfg.LockMessage)
        end

        function Tab:Paragraph(cfg)
            local f = DeusUI:Create("Frame", {
                Parent = Page,
                Size = UDim2.new(0.94, 0, 0, 0),
                AutomaticSize = "Y",
                BackgroundColor3 = theme.Secondary,
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                DeusUI:Stroke(nil, theme.StrokeColor, 1.2, 0.35),
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}),
                DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 3)}),
                DeusUI:Create("TextLabel", {Text = cfg.Title or "Info", BackgroundTransparency = 1, TextColor3 = theme.Accent, Font = Enum.Font.GothamBold, TextSize = 12, AutomaticSize = "XY"}),
                DeusUI:Create("TextLabel", {Text = cfg.Desc or "", BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, Font = Enum.Font.Gotham, TextSize = 11, AutomaticSize = "Y", Size = UDim2.new(1, 0, 0, 0), TextWrapped = true, TextXAlignment = "Left"})
            })
            table.insert(DeusUI.Elements, {Type = "Accent", Instance = f:FindFirstChild("TextLabel")})
            table.insert(DeusUI.Elements, {Type = "Text", Instance = f:FindFirstChild("TextLabel", true)})
        end

        return Tab
    end
    
    function Window:Settings()
        local s = Window:Tab({Title = "Settings"})
        s:Paragraph({Title = "⚙ Interface", Desc = "Customize UI themes and appearance."})
        s:Dropdown({Title = "Theme", Values = {"Dark", "Light", "Purple", "Blue", "Green", "Custom"}, Default = DeusUI.CurrentTheme, Callback = function(t) DeusUI.CurrentTheme = t; updateTheme(); DeusUI:Notify({Content = "Theme: " .. t}) end})
        s:Slider({Title = "Transparency", Min = 0, Max = 95, Default = 0, Callback = function(v) Main.BackgroundTransparency = v/100; Sidebar.BackgroundTransparency = (v/100)+0.2 end})
        s:Paragraph({Title = "🎨 Custom Colors", Desc = "Override colors for Custom theme."})
        s:Colorpicker({Title = "Accent", Default = DeusUI.Themes.Custom.Accent, Callback = function(c) DeusUI.Themes.Custom.Accent = c; DeusUI.CurrentTheme = "Custom"; updateTheme(); DeusUI:Notify({Content = "Accent updated"}) end})
        s:Colorpicker({Title = "Background", Default = DeusUI.Themes.Custom.Main, Callback = function(c) DeusUI.Themes.Custom.Main = c; DeusUI.CurrentTheme = "Custom"; updateTheme() end})
        s:Colorpicker({Title = "Text", Default = DeusUI.Themes.Custom.Text, Callback = function(c) DeusUI.Themes.Custom.Text = c; DeusUI.CurrentTheme = "Custom"; updateTheme() end})
        s:Button({Title = "Destroy UI", Callback = function() DeusUI:Notify({Content = "Destroying..."}); task.wait(0.3); ScreenGui:Destroy() end})
        return s
    end
    
    task.spawn(function() while Main.Parent do local fps = math.floor(workspace:GetRealPhysicsFPS()); local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000); Status.Text.Text = string.format("FPS: %d | Ping: %dms | Deus v3.0", fps, ping); task.wait(1) end end)
    return Window
end

return DeusUI

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

-- Notification Icons
local NotifyIcons = {
    ["success"] = "rbxassetid://4458901234",
    ["warning"] = "rbxassetid://4458901384",
    ["error"] = "rbxassetid://4458901560",
    ["info"] = "rbxassetid://4458901706",
    ["default"] = "rbxassetid://4458901706"
}

-- Enhanced Notification System (Bottom-Right)
local NotifyHolder = nil
task.defer(function()
    local NotifyGui = DeusUI:Create("ScreenGui", { Name = "DeusNotify", Parent = (gethui and gethui()) or CoreGui })
    NotifyHolder = DeusUI:Create("Frame", {
        Name = "Holder",
        Parent = NotifyGui,
        Size = UDim2.new(0, 300, 1, -100),
        Position = UDim2.new(1, -310, 1, -10),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1
    }, {
        DeusUI:Create("UIListLayout", {VerticalAlignment = "Bottom", Padding = UDim.new(0, 10), HorizontalAlignment = "Right", SortOrder = "LayoutOrder"})
    })
end)

function DeusUI:Notify(config)
    if not NotifyHolder then task.wait(0.5) end
    if not NotifyHolder then return end
    local theme = self.Themes[self.CurrentTheme]
    local content = config.Content or ""
    local nType = config.Type or "default"
    local iconId = NotifyIcons[nType] or NotifyIcons["default"]
    
    -- Color presets by type
    local typeColors = {
        success = {Color3.fromRGB(34, 197, 94), Color3.fromRGB(22, 163, 74)},
        warning = {Color3.fromRGB(245, 158, 11), Color3.fromRGB(217, 119, 6)},
        error = {Color3.fromRGB(239, 68, 68), Color3.fromRGB(220, 38, 38)},
        info = {theme.Accent, Color3.fromRGB(80, 120, 240)},
        default = {theme.Accent, theme.StrokeColor}
    }
    local gradient = typeColors[nType] or typeColors["default"]
    
    local Toast = self:Create("Frame", {
        Name = "Toast",
        Parent = NotifyHolder,
        Size = UDim2.new(1, 0, 0, 52),
        Position = UDim2.new(1.5, 0, 0, 0),
        BackgroundTransparency = 0.06,
        BorderSizePixel = 0,
        LayoutOrder = tick() * 1000
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        self:Stroke(nil, gradient[1], 2, 0.2),
        self:Stroke(nil, theme.StrokeColor, 1, 0.45),
        self:Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, gradient[1]),
                ColorSequenceKeypoint.new(1, gradient[2])
            }),
            Rotation = 135,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.75),
                NumberSequenceKeypoint.new(0.4, 0.88),
                NumberSequenceKeypoint.new(1, 0.82)
            })
        }),
        -- Icon container
        self:Create("Frame", {
            Name = "IconBox",
            Size = UDim2.new(0, 36, 0, 36),
            Position = UDim2.new(0, 8, 0, 8),
            BackgroundColor3 = gradient[1],
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0
        }, {
            self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            self:Create("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, 22, 0, 22),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Image = iconId,
                ImageColor3 = Color3.new(1, 1, 1),
                ScaleType = "Fit",
                ImageRectOffset = Vector2.new(0, 0),
                ImageRectSize = Vector2.new(512, 512)
            })
        }),
        -- Text
        self:Create("TextLabel", {
            Name = "Text",
            Text = content,
            Size = UDim2.new(1, -54, 1, 0),
            Position = UDim2.new(0, 50, 0, 0),
            BackgroundTransparency = 1,
            TextColor3 = theme.Text,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextWrapped = true,
            TextXAlignment = "Left",
            TextYAlignment = "Center"
        }),
        -- Progress bar (timer visual)
        self:Create("Frame", {
            Name = "Progress",
            Size = UDim2.new(0, 0, 0, 2),
            Position = UDim2.new(0, 10, 1, -6),
            BackgroundColor3 = gradient[1],
            BorderSizePixel = 0
        }, {
            self:Create("UICorner", {CornerRadius = UDim.new(0, 1)})
        })
    })
    
    -- Slide in animation
    self:Tween(Toast, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    })
    
    -- Animate progress bar
    local dur = config.Duration or 3
    local Progress = Toast:FindFirstChild("Progress")
    if Progress then
        self:Tween(Progress, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Size = UDim2.new(1, -20, 0, 2)})
    end
    
    -- Exit animation
    task.delay(dur, function()
        if Toast and Toast.Parent then
            self:Tween(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1.5, 0, 0, 0),
                BackgroundTransparency = 1
            })
            task.wait(0.4)
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
        Size = UDim2.new(0, 56, 1, -76),
        Position = UDim2.new(0, 8, 0, 44),
        BackgroundColor3 = theme.Secondary,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Stroke(nil, theme.StrokeColor, 1.5, 0.35),
        self:Create("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4)})
    })

    local TabScroll = self:Create("ScrollingFrame", {
        Parent = Sidebar,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        AutomaticCanvasSize = "Y",
        CanvasSize = UDim2.new(0, 0, 0, 0)
    }, {
        self:Create("UIListLayout", {Padding = UDim.new(0, 6), HorizontalAlignment = "Center"})
    })

    local PageCont = self:Create("Frame", {
        Parent = Main,
        Size = UDim2.new(1, -176, 1, -76),
        Position = UDim2.new(0, 72, 0, 44),
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

    -- Tab tracking
    local allTabs = {}
    local selectedTabInfo = nil

    -- Theme updater
    local function updateTheme()
        local t = DeusUI.Themes[DeusUI.CurrentTheme]
        self:Tween(Main, TweenInfo.new(0.2), {BackgroundColor3 = t.Main})
        self:Tween(Sidebar, TweenInfo.new(0.2), {BackgroundColor3 = t.Secondary})
        SepLine.BackgroundColor3 = t.Outline
        Status.Text.TextColor3 = t.TextSecondary
        for _, tab in pairs(allTabs) do
            if tab.Sel then
                DeusUI:Tween(tab.Instance, TweenInfo.new(0.2), {BackgroundColor3 = t.Accent})
                if tab.Label then tab.Label.TextColor3 = t.Text end
                if tab.Icon then tab.Icon.ImageColor3 = t.Text end
                if tab.Letter then tab.Letter.TextColor3 = t.Text end
            else
                DeusUI:Tween(tab.Instance, TweenInfo.new(0.2), {BackgroundColor3 = t.Main})
                if tab.Label then tab.Label.TextColor3 = t.TextSecondary end
                if tab.Icon then tab.Icon.ImageColor3 = t.TextSecondary end
                if tab.Letter then tab.Letter.TextColor3 = t.TextSecondary end
            end
        end
    end

    local Window = {}
    
    function Window:Tab(tabCfg)
        local title = tabCfg.Title or "Tab"
        local firstLetter = title:sub(1, 1):upper()
        local icon = DeusUI:GetIcon(tabCfg.Icon)
        local myIdx = #allTabs + 1

        -- Page
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

        -- Tab Button (compact: icon + first letter)
        local TabBtn = DeusUI:Create("TextButton", {
            Parent = TabScroll,
            Size = UDim2.new(1, 0, 0, 42),
            BackgroundColor3 = theme.Main,
            BackgroundTransparency = 0.5,
            Text = "",
            AutoButtonColor = false,
            BorderSizePixel = 0,
            ClipsDescendants = true
        }, {
            DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            DeusUI:Stroke(nil, theme.StrokeColor, 1.2, 0.5),
            -- Icon
            icon and DeusUI:Create("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0.5, 0, 0, 6),
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundTransparency = 1,
                Image = icon,
                ImageColor3 = theme.TextSecondary,
                ScaleType = "Fit"
            }) or nil,
            -- First letter badge
            DeusUI:Create("TextLabel", {
                Name = "Letter",
                Text = firstLetter,
                Size = UDim2.new(0, 20, 0, 16),
                Position = UDim2.new(0.5, 0, 0, 26),
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundTransparency = 1,
                TextColor3 = theme.TextSecondary,
                TextSize = 11,
                Font = Enum.Font.GothamBold
            }),
            -- Full label (hidden, slides down on expand)
            DeusUI:Create("TextLabel", {
                Name = "Label",
                Text = title,
                Size = UDim2.new(1, -8, 0, 16),
                Position = UDim2.new(0, 4, 0, 32),
                BackgroundTransparency = 1,
                TextColor3 = theme.TextSecondary,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = "Center",
                TextTransparency = 1
            })
        })

        local tabData = {
            Type = "Tab",
            Instance = TabBtn,
            Sel = false,
            Page = Page,
            Icon = TabBtn:FindFirstChild("Icon"),
            Letter = TabBtn:FindFirstChild("Letter"),
            Label = TabBtn:FindFirstChild("Label")
        }
        table.insert(allTabs, tabData)
        table.insert(DeusUI.Elements, tabData)

        -- Click handler with expand/collapse animation
        TabBtn.MouseButton1Click:Connect(function()
            if selectedTabInfo == tabData then return end -- Already selected

            -- Collapse ALL tabs
            for _, tab in pairs(allTabs) do
                tab.Sel = false
                tab.Page.Visible = false
                -- Animate collapse
                DeusUI:Tween(tab.Instance, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Main,
                    BackgroundTransparency = 0.5
                })
                if tab.Icon then
                    DeusUI:Tween(tab.Icon, TweenInfo.new(0.3), {
                        ImageColor3 = DeusUI.Themes[DeusUI.CurrentTheme].TextSecondary,
                        Position = UDim2.new(0.5, 0, 0, 6)
                    })
                end
                if tab.Letter then
                    DeusUI:Tween(tab.Letter, TweenInfo.new(0.3), {
                        TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].TextSecondary,
                        Position = UDim2.new(0.5, 0, 0, 26)
                    })
                end
                if tab.Label then
                    DeusUI:Tween(tab.Label, TweenInfo.new(0.25), {TextTransparency = 1})
                end
                -- Update stroke
                local stroke = tab.Instance:FindFirstChildOfClass("UIStroke")
                if stroke then DeusUI:Tween(stroke, TweenInfo.new(0.3), {Color = DeusUI.Themes[DeusUI.CurrentTheme].StrokeColor, Transparency = 0.5}) end
            end

            -- Expand SELECTED tab
            tabData.Sel = true
            tabData.Page.Visible = true
            selectedTabInfo = tabData
            
            DeusUI:Tween(TabBtn, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 58),
                BackgroundColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent,
                BackgroundTransparency = 0.1
            })
            if tabData.Icon then
                DeusUI:Tween(tabData.Icon, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    ImageColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Text,
                    Position = UDim2.new(0.5, 0, 0, 4)
                })
            end
            if tabData.Letter then
                DeusUI:Tween(tabData.Letter, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Text,
                    Position = UDim2.new(0.5, 0, 0, 24)
                })
            end
            if tabData.Label then
                DeusUI:Tween(tabData.Label, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
            end
            -- Update stroke
            local stroke = TabBtn.Instance:FindFirstChildOfClass("UIStroke")
            if stroke then DeusUI:Tween(stroke, TweenInfo.new(0.35), {Color = DeusUI.Themes[DeusUI.CurrentTheme].Accent, Transparency = 0}) end
        end)

        -- Auto-select first tab
        if not DeusUI.SelectedTab then
            DeusUI.SelectedTab = true
            selectedTabInfo = tabData
            tabData.Sel = true
            Page.Visible = true
            TabBtn.Size = UDim2.new(1, 0, 0, 58)
            TabBtn.BackgroundColor3 = theme.Accent
            TabBtn.BackgroundTransparency = 0.1
            if tabData.Icon then tabData.Icon.ImageColor3 = theme.Text end
            if tabData.Letter then tabData.Letter.TextColor3 = theme.Text end
            if tabData.Label then tabData.Label.TextTransparency = 0 end
            local stroke = TabBtn.Instance:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = theme.Accent; stroke.Transparency = 0 end
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
        s:Dropdown({Title = "Theme", Values = {"Dark", "Light", "Purple", "Blue", "Green", "Custom"}, Default = DeusUI.CurrentTheme, Callback = function(t) DeusUI.CurrentTheme = t; updateTheme(); DeusUI:Notify({Content = "Theme changed to " .. t, Type = "success"}) end})
        s:Slider({Title = "Transparency", Min = 0, Max = 95, Default = 0, Callback = function(v) Main.BackgroundTransparency = v/100; Sidebar.BackgroundTransparency = (v/100)+0.2 end})
        s:Paragraph({Title = "🎨 Custom Colors", Desc = "Override colors for Custom theme."})
        s:Colorpicker({Title = "Accent", Default = DeusUI.Themes.Custom.Accent, Callback = function(c) DeusUI.Themes.Custom.Accent = c; DeusUI.CurrentTheme = "Custom"; updateTheme(); DeusUI:Notify({Content = "Accent color updated!", Type = "success"}) end})
        s:Colorpicker({Title = "Background", Default = DeusUI.Themes.Custom.Main, Callback = function(c) DeusUI.Themes.Custom.Main = c; DeusUI.CurrentTheme = "Custom"; updateTheme() end})
        s:Colorpicker({Title = "Text", Default = DeusUI.Themes.Custom.Text, Callback = function(c) DeusUI.Themes.Custom.Text = c; DeusUI.CurrentTheme = "Custom"; updateTheme() end})
        s:Button({Title = "Destroy UI", Callback = function() DeusUI:Notify({Content = "Interface destroyed!", Type = "error"}); task.wait(0.3); ScreenGui:Destroy() end})
        return s
    end
    
    task.spawn(function() while Main.Parent do local fps = math.floor(workspace:GetRealPhysicsFPS()); local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000); Status.Text.Text = string.format("FPS: %d | Ping: %dms | Deus v3.0", fps, ping); task.wait(1) end end)
    return Window
end

return DeusUI

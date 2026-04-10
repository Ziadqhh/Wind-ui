--[[
    Deus Evolution UI | Version 2.0.0 (PROFESSIONAL REDESIGN)
    Created by: Deus Mode (Gemini CLI)
    Style: Premium Glassmorphism | Enhanced Strokes | Modern Design
]]

local DeusUI = {
    Themes = {
        Dark = {
            Main = Color3.fromRGB(18, 18, 24),
            Secondary = Color3.fromRGB(28, 28, 38),
            Outline = Color3.fromRGB(55, 55, 75),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(165, 165, 180),
            Accent = Color3.fromRGB(85, 140, 255),
            Glow = Color3.fromRGB(85, 140, 255),
            StrokeMain = Color3.fromRGB(90, 90, 120),
            StrokeAccent = Color3.fromRGB(85, 140, 255)
        },
        Light = {
            Main = Color3.fromRGB(245, 245, 250),
            Secondary = Color3.fromRGB(230, 230, 240),
            Outline = Color3.fromRGB(190, 190, 210),
            Text = Color3.fromRGB(25, 25, 35),
            TextSecondary = Color3.fromRGB(95, 95, 110),
            Accent = Color3.fromRGB(65, 110, 255),
            Glow = Color3.fromRGB(65, 110, 255),
            StrokeMain = Color3.fromRGB(180, 180, 200),
            StrokeAccent = Color3.fromRGB(65, 110, 255)
        },
        Purple = {
            Main = Color3.fromRGB(25, 18, 38),
            Secondary = Color3.fromRGB(42, 28, 65),
            Outline = Color3.fromRGB(85, 55, 125),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(195, 175, 225),
            Accent = Color3.fromRGB(165, 105, 255),
            Glow = Color3.fromRGB(165, 105, 255),
            StrokeMain = Color3.fromRGB(100, 70, 140),
            StrokeAccent = Color3.fromRGB(165, 105, 255)
        },
        Blue = {
            Main = Color3.fromRGB(12, 22, 38),
            Secondary = Color3.fromRGB(22, 38, 58),
            Outline = Color3.fromRGB(48, 68, 98),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(155, 185, 220),
            Accent = Color3.fromRGB(75, 165, 255),
            Glow = Color3.fromRGB(75, 165, 255),
            StrokeMain = Color3.fromRGB(60, 85, 115),
            StrokeAccent = Color3.fromRGB(75, 165, 255)
        },
        Green = {
            Main = Color3.fromRGB(12, 28, 18),
            Secondary = Color3.fromRGB(22, 48, 32),
            Outline = Color3.fromRGB(48, 88, 68),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(155, 205, 175),
            Accent = Color3.fromRGB(75, 225, 140),
            Glow = Color3.fromRGB(75, 225, 140),
            StrokeMain = Color3.fromRGB(55, 105, 80),
            StrokeAccent = Color3.fromRGB(75, 225, 140)
        },
        Custom = {
            Main = Color3.fromRGB(18, 18, 24),
            Secondary = Color3.fromRGB(28, 28, 38),
            Outline = Color3.fromRGB(55, 55, 75),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(165, 165, 180),
            Accent = Color3.fromRGB(85, 140, 255),
            Glow = Color3.fromRGB(85, 140, 255),
            StrokeMain = Color3.fromRGB(90, 90, 120),
            StrokeAccent = Color3.fromRGB(85, 140, 255)
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
local RunService = game:GetService("RunService")

-- Instance Creator
function DeusUI:Create(className, properties, children)
    local inst = Instance.new(className)
    if properties then
        for prop, value in pairs(properties) do
            if type(value) == "boolean" or type(value) == "number" or type(value) == "string" or typeof(value) == "EnumItem" then
                inst[prop] = value
            elseif typeof(value) == "Color3" or typeof(value) == "UDim2" or typeof(value) == "UDim" or typeof(value) == "Vector2" or typeof(value) == "Vector3" or typeof(value) == "NumberSequence" or typeof(value) == "ColorSequence" then
                inst[prop] = value
            else
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

-- Enhanced Stroke Creator
function DeusUI:CreateStroke(parent, color, thickness, transparency)
    return self:Create("UIStroke", {
        Parent = parent,
        Color = color or Color3.fromRGB(90, 90, 120),
        Thickness = thickness or 2,
        Transparency = transparency or 0.3,
        ApplyStrokeMode = "Border"
    })
end

-- Notification System
local NotifyGui = DeusUI:Create("ScreenGui", { Name = "DeusNotifications", Parent = (gethui and gethui()) or CoreGui })
local NotifyHolder = DeusUI:Create("Frame", { Name = "Holder", Parent = NotifyGui, Size = UDim2.new(0, 280, 1, 0), Position = UDim2.new(1, -290, 0, 0), BackgroundTransparency = 1 }, { DeusUI:Create("UIListLayout", {VerticalAlignment = "Bottom", Padding = UDim.new(0, 12)}) })

function DeusUI:Notify(config)
    local theme = self.Themes[self.CurrentTheme]
    local Toast = self:Create("Frame", { 
        Name = "Toast", 
        Parent = NotifyHolder, 
        Size = UDim2.new(1, 0, 0, 50), 
        BackgroundColor3 = theme.Main, 
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        self:CreateStroke(nil, theme.StrokeAccent, 2, 0.2),
        self:Create("Frame", {
            Name = "AccentBar",
            Size = UDim2.new(0, 4, 1, -16),
            Position = UDim2.new(0, 6, 0, 8),
            BackgroundColor3 = theme.Accent,
            BorderSizePixel = 0
        }, {
            self:Create("UICorner", {CornerRadius = UDim.new(0, 2)})
        }),
        self:Create("TextLabel", { 
            Text = config.Content or "Notification", 
            Size = UDim2.new(1, -30, 1, 0), 
            Position = UDim2.new(0, 18, 0, 0), 
            BackgroundTransparency = 1, 
            TextColor3 = theme.Text, 
            TextSize = 13, 
            Font = Enum.Font.GothamMedium, 
            TextWrapped = true,
            TextXAlignment = "Left"
        })
    })
    self:Tween(Toast, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
    task.delay(config.Duration or 3, function() 
        if Toast then 
            self:Tween(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1.5, 0, 0, 0), BackgroundTransparency = 1})
            task.wait(0.4)
            Toast:Destroy() 
        end 
    end)
end

-- ColorPicker (Floating) - Redesigned
function DeusUI:OpenColorPicker(defaultColor, callback)
    local theme = self.Themes[self.CurrentTheme]
    local h, s, v = Color3.toHSV(defaultColor)
    local selectedColor = defaultColor
    local PickerFrame = self:Create("Frame", { 
        Name = "PickerFrame", 
        Parent = self.ScreenGui, 
        Size = UDim2.new(0, 280, 0, 340), 
        Position = UDim2.new(0.5, 0, 0.5, 0), 
        AnchorPoint = Vector2.new(0.5, 0.5), 
        BackgroundColor3 = theme.Main, 
        BackgroundTransparency = 0.08, 
        Active = true, 
        ZIndex = 3000,
        BorderSizePixel = 0
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 14)}),
        self:CreateStroke(nil, theme.StrokeMain, 2.5, 0.25),
        self:CreateStroke(nil, theme.StrokeAccent, 1, 0.5)
    })
    
    local ClosePicker = self:Create("TextButton", { 
        Name = "Close", 
        Parent = PickerFrame, 
        Size = UDim2.new(0, 28, 0, 28), 
        Position = UDim2.new(1, -34, 0, 6), 
        BackgroundColor3 = Color3.fromRGB(220, 50, 50), 
        Text = "×", 
        TextColor3 = Color3.new(1,1,1), 
        Font = Enum.Font.GothamBold, 
        TextSize = 18, 
        ZIndex = 3001 
    }, { 
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}) 
    })
    ClosePicker.MouseButton1Click:Connect(function() PickerFrame:Destroy() end)
    
    local SatVibMap = self:Create("ImageLabel", { 
        Name = "SatVibMap", 
        Parent = PickerFrame, 
        Size = UDim2.new(0, 200, 0, 200), 
        Position = UDim2.new(0, 22, 0, 42), 
        Image = "rbxassetid://4155801252", 
        BackgroundColor3 = Color3.fromHSV(h, 1, 1), 
        ZIndex = 3001 
    }, { 
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        self:CreateStroke(nil, theme.StrokeMain, 1.5, 0.4)
    })
    
    local MapKnob = self:Create("Frame", { 
        Parent = SatVibMap, 
        Size = UDim2.new(0, 14, 0, 14), 
        Position = UDim2.new(s, 0, 1-v, 0), 
        AnchorPoint = Vector2.new(0.5, 0.5), 
        BackgroundColor3 = Color3.new(1,1,1), 
        ZIndex = 3002 
    }, { 
        self:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), 
        self:CreateStroke(nil, theme.Accent, 2, 0)
    })
    
    local HueBar = self:Create("Frame", { 
        Name = "HueBar", 
        Parent = PickerFrame, 
        Size = UDim2.new(0, 22, 0, 200), 
        Position = UDim2.new(0, 236, 0, 42), 
        ZIndex = 3001 
    }, { 
        self:Create("UICorner", {CornerRadius = UDim.new(0, 6)}) 
    })
    
    self:Create("UIGradient", { 
        Rotation = 90, 
        Parent = HueBar, 
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)), 
            ColorSequenceKeypoint.new(0.16, Color3.fromHSV(0.16,1,1)), 
            ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33,1,1)), 
            ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5,1,1)), 
            ColorSequenceKeypoint.new(0.66, Color3.fromHSV(0.66,1,1)), 
            ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83,1,1)), 
            ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1))
        }) 
    })
    
    local HueKnob = self:Create("Frame", { 
        Parent = HueBar, 
        Size = UDim2.new(1, 6, 0, 6), 
        Position = UDim2.new(0.5, 0, h, 0), 
        AnchorPoint = Vector2.new(0.5, 0.5), 
        BackgroundColor3 = Color3.new(1,1,1), 
        ZIndex = 3002 
    }, { 
        self:CreateStroke(nil, Color3.new(1,1,1), 1.5, 0)
    })
    
    local HexBox = self:Create("TextBox", { 
        Parent = PickerFrame, 
        Size = UDim2.new(0, 120, 0, 32), 
        Position = UDim2.new(0, 22, 0, 255), 
        BackgroundColor3 = theme.Secondary, 
        BackgroundTransparency = 0.3,
        Text = "#" .. selectedColor:ToHex(), 
        TextColor3 = theme.Text, 
        Font = Enum.Font.GothamMedium, 
        TextSize = 13, 
        ZIndex = 3001 
    }, { 
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:CreateStroke(nil, theme.StrokeMain, 1.5, 0.4)
    })
    
    local function update() 
        selectedColor = Color3.fromHSV(h, s, v)
        SatVibMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        HexBox.Text = "#" .. selectedColor:ToHex()
        MapKnob.Position = UDim2.new(s, 0, 1-v, 0)
        HueKnob.Position = UDim2.new(0.5, 0, h, 0)
    end
    
    local mapDragging = false
    SatVibMap.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            mapDragging = true 
        end 
    end)
    
    local hueDragging = false
    HueBar.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            hueDragging = true 
        end 
    end)
    
    UserInputService.InputChanged:Connect(function(input) 
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
            if mapDragging then 
                local pos = Vector2.new(input.Position.X - SatVibMap.AbsolutePosition.X, input.Position.Y - SatVibMap.AbsolutePosition.Y)
                s = math.clamp(pos.X / SatVibMap.AbsoluteSize.X, 0, 1)
                v = 1 - math.clamp(pos.Y / SatVibMap.AbsoluteSize.Y, 0, 1)
                update() 
            elseif hueDragging then 
                local pos = input.Position.Y - HueBar.AbsolutePosition.Y
                h = math.clamp(pos / HueBar.AbsoluteSize.Y, 0, 1)
                update() 
            end 
        end 
    end)
    
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            mapDragging = false
            hueDragging = false 
        end 
    end)
    
    local ApplyBtn = self:Create("TextButton", { 
        Parent = PickerFrame, 
        Size = UDim2.new(1, -44, 0, 38), 
        Position = UDim2.new(0.5, 0, 1, -18), 
        AnchorPoint = Vector2.new(0.5, 1), 
        BackgroundColor3 = theme.Accent, 
        BackgroundTransparency = 0.1,
        Text = "Apply", 
        TextColor3 = Color3.new(1,1,1), 
        Font = Enum.Font.GothamBold, 
        TextSize = 15, 
        ZIndex = 3001 
    }, { 
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}) 
    })
    
    ApplyBtn.MouseButton1Click:Connect(function() callback(selectedColor); PickerFrame:Destroy() end)
    update()
end

-- Main Window - Completely Redesigned
function DeusUI:CreateWindow(config)
    local theme = self.Themes[self.CurrentTheme]
    local ScreenGui = self:Create("ScreenGui", { Name = "DeusEvolutionUI", Parent = (gethui and gethui()) or CoreGui, ResetOnSpawn = false })
    self.ScreenGui = ScreenGui
    
    local MainFrame = self:Create("Frame", { 
        Name = "MainFrame", 
        Parent = ScreenGui, 
        BackgroundColor3 = theme.Main, 
        Position = UDim2.new(0.5, -300, 0.5, -195), 
        Size = UDim2.new(0, 600, 0, 390), 
        ClipsDescendants = true, 
        ZIndex = 1,
        BorderSizePixel = 0
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        self:CreateStroke(nil, theme.StrokeMain, 2.5, 0.25),
        self:CreateStroke(nil, theme.StrokeAccent, 1.5, 0.6),
        self:Create("UIPadding", {
            PaddingTop = UDim.new(0, 0),
            PaddingBottom = UDim.new(0, 0),
            PaddingLeft = UDim.new(0, 0),
            PaddingRight = UDim.new(0, 0)
        })
    })
    
    local Topbar = self:Create("Frame", { 
        Name = "Topbar", 
        Parent = MainFrame, 
        Size = UDim2.new(1, 0, 0, 50), 
        BackgroundTransparency = 1, 
        ZIndex = 2 
    })
    
    self:Create("TextLabel", { 
        Name = "Title", 
        Parent = Topbar, 
        Text = config.Title or "Deus Evolution", 
        Size = UDim2.new(1, -120, 1, 0), 
        Position = UDim2.new(0, 18, 0, 0), 
        BackgroundTransparency = 1, 
        TextColor3 = theme.Text, 
        TextSize = 17, 
        Font = Enum.Font.GothamBold, 
        TextXAlignment = "Left", 
        ZIndex = 3 
    })
    
    local Sep = self:Create("Frame", { 
        Name = "Separator", 
        Parent = Topbar, 
        Size = UDim2.new(1, -30, 0, 2), 
        Position = UDim2.new(0, 15, 1, 0), 
        BackgroundColor3 = theme.Outline, 
        BackgroundTransparency = 0.85, 
        BorderSizePixel = 0, 
        ZIndex = 3 
    }, {
        self:Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, theme.Accent),
                ColorSequenceKeypoint.new(0.5, theme.Outline),
                ColorSequenceKeypoint.new(1, theme.Accent)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.3),
                NumberSequenceKeypoint.new(0.5, 0.8),
                NumberSequenceKeypoint.new(1, 0.3)
            })
        })
    })

    local Controls = self:Create("Frame", { 
        Name = "Controls", 
        Parent = Topbar, 
        Size = UDim2.new(0, 90, 1, 0), 
        Position = UDim2.new(1, -12, 0, 0), 
        AnchorPoint = Vector2.new(1, 0), 
        BackgroundTransparency = 1, 
        ZIndex = 100 
    })
    
    self:Create("UIListLayout", { 
        Parent = Controls, 
        FillDirection = "Horizontal", 
        Padding = UDim.new(0, 10), 
        VerticalAlignment = "Center", 
        HorizontalAlignment = "Right" 
    })

    local WindowSize = UDim2.new(0, 600, 0, 390)
    local Minimized = false
    
    local MinBtn = self:Create("TextButton", { 
        Name = "Min", 
        Parent = Controls, 
        Size = UDim2.new(0, 30, 0, 30), 
        BackgroundColor3 = theme.Secondary, 
        BackgroundTransparency = 0.3,
        Text = "−", 
        TextColor3 = theme.Text, 
        TextSize = 20, 
        Font = Enum.Font.GothamBold, 
        ZIndex = 101, 
        Active = true 
    }, { 
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), 
        self:CreateStroke(nil, theme.StrokeMain, 2, 0.3)
    })
    
    local CloseBtn = self:Create("TextButton", { 
        Name = "Close", 
        Parent = Controls, 
        Size = UDim2.new(0, 30, 0, 30), 
        BackgroundColor3 = Color3.fromRGB(220, 50, 50), 
        BackgroundTransparency = 0.15,
        Text = "×", 
        TextColor3 = Color3.new(1, 1, 1), 
        TextSize = 20, 
        Font = Enum.Font.GothamBold, 
        ZIndex = 101, 
        Active = true 
    }, { 
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:CreateStroke(nil, Color3.fromRGB(255, 80, 80), 2, 0.2)
    })

    local Sidebar = self:Create("Frame", { 
        Name = "Sidebar", 
        Parent = MainFrame, 
        Size = UDim2.new(0, 180, 1, -100), 
        Position = UDim2.new(0, 12, 0, 62), 
        BackgroundColor3 = theme.Secondary, 
        BackgroundTransparency = 0.35, 
        ZIndex = 2,
        BorderSizePixel = 0
    }, { 
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)}), 
        self:CreateStroke(nil, theme.StrokeMain, 2, 0.3),
        self:Create("UIPadding", {
            PaddingTop = UDim.new(0, 6),
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6)
        })
    })
    
    local TabContainer = self:Create("ScrollingFrame", { 
        Name = "TabScroll", 
        Parent = Sidebar, 
        Size = UDim2.new(1, 0, 1, 0), 
        BackgroundTransparency = 1, 
        ScrollBarThickness = 0, 
        AutomaticCanvasSize = "Y", 
        ZIndex = 3 
    }, { 
        self:Create("UIListLayout", {Padding = UDim.new(0, 6), HorizontalAlignment = "Center"}) 
    })
    
    local PageContainer = self:Create("Frame", { 
        Name = "PageContainer", 
        Parent = MainFrame, 
        Size = UDim2.new(1, -216, 1, -100), 
        Position = UDim2.new(0, 204, 0, 62), 
        BackgroundTransparency = 1, 
        ZIndex = 2 
    })
    
    local StatusBar = self:Create("Frame", { 
        Name = "StatusBar", 
        Parent = MainFrame, 
        Size = UDim2.new(1, -24, 0, 28), 
        Position = UDim2.new(0, 12, 1, -34), 
        BackgroundColor3 = theme.Secondary,
        BackgroundTransparency = 0.5, 
        ZIndex = 2,
        BorderSizePixel = 0
    }, { 
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:CreateStroke(nil, theme.StrokeMain, 1.5, 0.35),
        self:Create("TextLabel", { 
            Name = "PerfText", 
            Size = UDim2.new(1, 0, 1, 0), 
            BackgroundTransparency = 1, 
            Text = "FPS: 60 | Ping: 0ms", 
            TextColor3 = theme.TextSecondary, 
            TextSize = 11, 
            Font = Enum.Font.GothamMedium, 
            TextXAlignment = "Center", 
            ZIndex = 3 
        }) 
    })

    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        local target = Minimized and UDim2.new(0, 600, 0, 50) or WindowSize
        DeusUI:Tween(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = target})
        Sidebar.Visible = not Minimized
        PageContainer.Visible = not Minimized
        StatusBar.Visible = not Minimized
        Sep.Visible = not Minimized
    end)
    
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local function updateGlobalStyles()
        local current = DeusUI.Themes[DeusUI.CurrentTheme]
        DeusUI:Tween(MainFrame, TweenInfo.new(0.3), {BackgroundColor3 = current.Main})
        DeusUI:Tween(Sidebar, TweenInfo.new(0.3), {BackgroundColor3 = current.Secondary})
        Sep.BackgroundColor3 = current.Outline
        StatusBar.PerfText.TextColor3 = current.TextSecondary
        MinBtn.BackgroundColor3 = current.Secondary
        MinBtn.TextColor3 = current.Text
        
        for _, el in pairs(DeusUI.Elements) do
            if el.Type == "TabBtn" then 
                el.Instance.BackgroundColor3 = el.Selected and current.Accent or current.Main
                el.Instance.Label.TextColor3 = el.Selected and current.Text or current.TextSecondary
                if el.Instance:FindFirstChild("Icon") then 
                    el.Instance.Icon.ImageColor3 = el.Selected and current.Text or current.TextSecondary 
                end
            elseif el.Type == "Button" then 
                el.Instance.BackgroundColor3 = current.Secondary
                el.Instance.Btn.TextColor3 = current.Text
            elseif el.Type == "Text" then 
                el.Instance.TextColor3 = current.Text
            elseif el.Type == "AccentText" then 
                el.Instance.TextColor3 = current.Accent 
            end
        end
    end

    local dragging, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        local pos = input.Position
        local controlX = Controls.AbsolutePosition.X
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not Minimized and pos.X < controlX then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input) 
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
        end 
    end)

    local Window = {}
    function Window:Tab(tabConfig)
        local tabTitle = tabConfig.Title or "Tab"
        local tabIcon = DeusUI:GetIcon(tabConfig.Icon)
        
        local Page = DeusUI:Create("ScrollingFrame", { 
            Name = tabTitle .. "Page", 
            Parent = PageContainer, 
            Size = UDim2.new(1, 0, 1, 0), 
            BackgroundTransparency = 1, 
            Visible = false, 
            ScrollBarThickness = 3, 
            ScrollBarImageColor3 = theme.Accent, 
            AutomaticCanvasSize = "Y", 
            ZIndex = 3 
        }, { 
            DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 10), HorizontalAlignment = "Center"}) 
        })

        local TabBtn = DeusUI:Create("TextButton", {
            Name = tabTitle .. "Btn", 
            Parent = TabContainer, 
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = theme.Main, 
            BackgroundTransparency = 0.4,
            Text = "", 
            AutoButtonColor = false, 
            ZIndex = 4,
            BorderSizePixel = 0
        }, {
            DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            DeusUI:CreateStroke(nil, theme.StrokeMain, 1.5, 0.5),
            DeusUI:Create("UIListLayout", {
                FillDirection = "Horizontal",
                VerticalAlignment = "Center",
                Padding = UDim.new(0, 10),
                HorizontalAlignment = "Center"
            }),
            tabIcon and DeusUI:Create("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, 20, 0, 20),
                BackgroundTransparency = 1,
                Image = tabIcon,
                ImageColor3 = theme.TextSecondary,
                ZIndex = 5
            }) or nil,
            DeusUI:Create("TextLabel", {
                Name = "Label",
                Text = tabTitle,
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = "X",
                BackgroundTransparency = 1,
                TextColor3 = theme.TextSecondary,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                ZIndex = 5
            })
        })

        local tabObj = {Type = "TabBtn", Instance = TabBtn, Selected = false}
        table.insert(DeusUI.Elements, tabObj)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(PageContainer:GetChildren()) do p.Visible = false end
            for _, el in pairs(DeusUI.Elements) do
                if el.Type == "TabBtn" then
                    el.Selected = false
                    el.Instance.BackgroundColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Main
                    el.Instance.BackgroundTransparency = 0.4
                    el.Instance.Label.TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].TextSecondary
                    if el.Instance:FindFirstChild("Icon") then 
                        el.Instance.Icon.ImageColor3 = DeusUI.Themes[DeusUI.CurrentTheme].TextSecondary 
                    end
                end
            end
            Page.Visible = true
            tabObj.Selected = true
            TabBtn.BackgroundColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent
            TabBtn.BackgroundTransparency = 0.1
            TabBtn.Label.TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Text
            if TabBtn:FindFirstChild("Icon") then 
                TabBtn.Icon.ImageColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Text 
            end
        end)

        if not DeusUI.SelectedTab then
            DeusUI.SelectedTab = true
            Page.Visible = true
            tabObj.Selected = true
            TabBtn.BackgroundColor3 = theme.Accent
            TabBtn.BackgroundTransparency = 0.1
            TabBtn.Label.TextColor3 = theme.Text
            if TabBtn:FindFirstChild("Icon") then 
                TabBtn.Icon.ImageColor3 = theme.Text 
            end
        end
        
        local Tab = {}
        local function applyLock(frame, locked, msg) 
            if locked then 
                local Lock = DeusUI:Create("Frame", { 
                    Name = "Lock", 
                    Parent = frame, 
                    Size = UDim2.new(1, 0, 1, 0), 
                    BackgroundColor3 = Color3.new(0,0,0), 
                    BackgroundTransparency = 0.6, 
                    ZIndex = 100, 
                    Active = true 
                }, { 
                    DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), 
                    DeusUI:Create("TextLabel", {
                        Text = "🔒 " .. (msg or "VIP"), 
                        Size = UDim2.new(1,0,1,0), 
                        BackgroundTransparency = 1, 
                        TextColor3 = Color3.new(1,1,1), 
                        Font = Enum.Font.GothamBold, 
                        TextSize = 13, 
                        ZIndex = 101
                    }) 
                }) 
            end 
        end
        
        function Tab:Button(btnConfig) 
            local ButtonFrame = DeusUI:Create("Frame", { 
                Parent = Page, 
                Size = UDim2.new(0.95, 0, 0, 45), 
                BackgroundColor3 = theme.Secondary, 
                BackgroundTransparency = 0.35, 
                ZIndex = 4,
                BorderSizePixel = 0
            }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 10)}), 
                DeusUI:CreateStroke(nil, theme.StrokeMain, 2, 0.3),
                DeusUI:Create("TextButton", {
                    Name = "Btn", 
                    Size = UDim2.new(1, 0, 1, 0), 
                    BackgroundTransparency = 1, 
                    Text = btnConfig.Title or "Button", 
                    TextColor3 = theme.Text, 
                    TextSize = 14, 
                    Font = Enum.Font.GothamBold, 
                    ZIndex = 5
                })
            })
            ButtonFrame.Btn.MouseButton1Click:Connect(function() btnConfig.Callback() end)
            table.insert(DeusUI.Elements, {Type = "Button", Instance = ButtonFrame})
            applyLock(ButtonFrame, btnConfig.Locked, btnConfig.LockMessage) 
        end
        
        function Tab:Toggle(tConfig) 
            local toggled = tConfig.Default or false
            local ToggleFrame = DeusUI:Create("Frame", { 
                Parent = Page, 
                Size = UDim2.new(0.95, 0, 0, 50), 
                BackgroundColor3 = theme.Secondary, 
                BackgroundTransparency = 0.35, 
                ZIndex = 4,
                BorderSizePixel = 0
            }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 10)}), 
                DeusUI:CreateStroke(nil, theme.StrokeMain, 2, 0.3),
                DeusUI:Create("UIPadding", {PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18)}), 
                DeusUI:Create("TextLabel", {
                    Name = "T", 
                    Text = tConfig.Title or "Toggle", 
                    BackgroundTransparency = 1, 
                    TextColor3 = theme.Text, 
                    TextSize = 14, 
                    Font = Enum.Font.GothamMedium, 
                    Size = UDim2.new(1, -70, 1, 0), 
                    TextXAlignment = "Left", 
                    ZIndex = 5
                })
            })
            
            local Switch = DeusUI:Create("TextButton", { 
                Parent = ToggleFrame, 
                Size = UDim2.new(0, 48, 0, 24), 
                Position = UDim2.new(1, 0, 0.5, 0), 
                AnchorPoint = Vector2.new(1, 0.5), 
                BackgroundColor3 = toggled and DeusUI.Themes[DeusUI.CurrentTheme].Accent or Color3.fromRGB(65, 65, 75), 
                BackgroundTransparency = toggled and 0.15 or 0.3,
                Text = "", 
                AutoButtonColor = false, 
                ZIndex = 5 
            }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), 
                DeusUI:CreateStroke(nil, toggled and theme.Accent or theme.StrokeMain, 2, 0.2)
            })
            
            local Circle = DeusUI:Create("Frame", { 
                Parent = Switch, 
                Size = UDim2.new(0, 20, 0, 20), 
                Position = toggled and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0), 
                AnchorPoint = toggled and Vector2.new(1, 0.5) or Vector2.new(0, 0.5), 
                BackgroundColor3 = Color3.new(1, 1, 1), 
                ZIndex = 6 
            }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
            
            Switch.MouseButton1Click:Connect(function() 
                toggled = not toggled
                DeusUI:Tween(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = toggled and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0), 
                    AnchorPoint = toggled and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
                })
                DeusUI:Tween(Switch, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    BackgroundColor3 = toggled and DeusUI.Themes[DeusUI.CurrentTheme].Accent or Color3.fromRGB(65, 65, 75)
                })
                tConfig.Callback(toggled) 
            end)
            
            table.insert(DeusUI.Elements, {Type = "Text", Instance = ToggleFrame.T})
            applyLock(ToggleFrame, tConfig.Locked, tConfig.LockMessage) 
        end
        
        function Tab:Slider(sConfig) 
            local min, max, val = sConfig.Min or 0, sConfig.Max or 100, sConfig.Default or 50
            local SliderFrame = DeusUI:Create("Frame", { 
                Parent = Page, 
                Size = UDim2.new(0.95, 0, 0, 70), 
                BackgroundColor3 = theme.Secondary, 
                BackgroundTransparency = 0.35, 
                ZIndex = 4,
                BorderSizePixel = 0
            }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 10)}), 
                DeusUI:CreateStroke(nil, theme.StrokeMain, 2, 0.3),
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18)}), 
                DeusUI:Create("TextLabel", {
                    Name = "T", 
                    Text = sConfig.Title or "Slider", 
                    BackgroundTransparency = 1, 
                    TextColor3 = theme.Text, 
                    TextSize = 14, 
                    Font = Enum.Font.GothamMedium, 
                    Size = UDim2.new(0.7, 0, 0, 22), 
                    TextXAlignment = "Left", 
                    ZIndex = 5
                }), 
                DeusUI:Create("TextLabel", {
                    Name = "Val", 
                    Text = tostring(val), 
                    BackgroundTransparency = 1, 
                    TextColor3 = theme.Accent, 
                    TextSize = 15, 
                    Font = Enum.Font.GothamBold, 
                    Size = UDim2.new(0.3, 0, 0, 22), 
                    Position = UDim2.new(0.7, 0, 0, 0), 
                    TextXAlignment = "Right", 
                    ZIndex = 5
                })
            })
            
            local Bar = DeusUI:Create("Frame", {
                Parent = SliderFrame, 
                Size = UDim2.new(1, 0, 0, 6), 
                Position = UDim2.new(0, 0, 0, 45), 
                BackgroundColor3 = theme.Main, 
                BackgroundTransparency = 0.5, 
                ZIndex = 5
            }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
            
            local Fill = DeusUI:Create("Frame", {
                Parent = Bar, 
                Size = UDim2.new((val-min)/(max-min), 0, 1, 0), 
                BackgroundColor3 = theme.Accent, 
                BackgroundTransparency = 0.2,
                ZIndex = 6
            }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
            
            local Knob = DeusUI:Create("Frame", {
                Parent = Fill, 
                Size = UDim2.new(0, 18, 0, 18), 
                Position = UDim2.new(1, 0, 0.5, 0), 
                AnchorPoint = Vector2.new(0.5, 0.5), 
                BackgroundColor3 = Color3.new(1, 1, 1), 
                ZIndex = 7
            }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), 
                DeusUI:CreateStroke(nil, theme.Accent, 2.5, 0)
            })
            
            local dragging = false
            local function update(input) 
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max-min)*pos)
                SliderFrame.Val.Text = tostring(val)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                sConfig.Callback(val) 
            end
            
            Bar.InputBegan:Connect(function(input) 
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
                    dragging = true
                    update(input) 
                end 
            end)
            
            UserInputService.InputChanged:Connect(function(input) 
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
                    update(input) 
                end 
            end)
            
            UserInputService.InputEnded:Connect(function(input) 
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
                    dragging = false 
                end 
            end)
            
            table.insert(DeusUI.Elements, {Type = "Text", Instance = SliderFrame.T})
            table.insert(DeusUI.Elements, {Type = "AccentText", Instance = SliderFrame.Val})
            applyLock(SliderFrame, sConfig.Locked, sConfig.LockMessage) 
        end
        
        function Tab:Dropdown(dConfig) 
            local dValues = dConfig.Values or {}
            local selected = dConfig.Default or "Select..."
            local opened = false
            
            local DropdownFrame = DeusUI:Create("Frame", { 
                Parent = Page, 
                Size = UDim2.new(0.95, 0, 0, 50), 
                BackgroundColor3 = theme.Secondary, 
                BackgroundTransparency = 0.35, 
                ClipsDescendants = true, 
                ZIndex = 4,
                BorderSizePixel = 0
            }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 10)}), 
                DeusUI:CreateStroke(nil, theme.StrokeMain, 2, 0.3),
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18)})
            })
            
            local Header = DeusUI:Create("TextButton", {
                Parent = DropdownFrame, 
                Size = UDim2.new(1, 0, 0, 28), 
                BackgroundTransparency = 1, 
                Text = "", 
                ZIndex = 5
            })
            
            local Title = DeusUI:Create("TextLabel", {
                Text = dConfig.Title or "Dropdown", 
                Parent = Header, 
                Size = UDim2.new(0.5, 0, 1, 0), 
                BackgroundTransparency = 1, 
                TextColor3 = theme.Text, 
                Font = Enum.Font.GothamMedium, 
                TextSize = 14, 
                TextXAlignment = "Left", 
                ZIndex = 5
            })
            
            local Arrow = DeusUI:Create("TextLabel", {
                Text = "▼", 
                Parent = Header, 
                Size = UDim2.new(0.3, 0, 1, 0), 
                Position = UDim2.new(0.7, 0, 0, 0), 
                BackgroundTransparency = 1, 
                TextColor3 = theme.Accent, 
                Font = Enum.Font.GothamBold, 
                TextSize = 12, 
                TextXAlignment = "Right", 
                ZIndex = 5
            })
            
            local Content = DeusUI:Create("TextLabel", {
                Text = selected, 
                Parent = Header, 
                Size = UDim2.new(0.4, 0, 1, 0), 
                Position = UDim2.new(0.6, 0, 0, 0), 
                BackgroundTransparency = 1, 
                TextColor3 = theme.TextSecondary, 
                Font = Enum.Font.GothamMedium, 
                TextSize = 13, 
                TextXAlignment = "Right", 
                ZIndex = 5
            })
            
            local ItemContainer = DeusUI:Create("Frame", {
                Name = "Items", 
                Parent = DropdownFrame, 
                Size = UDim2.new(1, 0, 0, 0), 
                Position = UDim2.new(0, 0, 0, 40), 
                BackgroundTransparency = 1, 
                Visible = false
            }, {
                DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 4)})
            })
            
            for _, item in pairs(dValues) do
                local ItemBtn = DeusUI:Create("TextButton", {
                    Parent = ItemContainer, 
                    Size = UDim2.new(1, 0, 0, 30), 
                    BackgroundColor3 = theme.Main, 
                    BackgroundTransparency = 0.4,
                    Text = "  " .. item, 
                    TextColor3 = theme.Text, 
                    Font = Enum.Font.GothamMedium, 
                    TextSize = 13, 
                    TextXAlignment = "Left", 
                    ZIndex = 6
                }, {
                    DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                    DeusUI:CreateStroke(nil, theme.StrokeMain, 1.5, 0.5)
                })
                ItemBtn.MouseButton1Click:Connect(function()
                    selected = item
                    Content.Text = selected
                    opened = false
                    DropdownFrame.Size = UDim2.new(0.95, 0, 0, 50)
                    ItemContainer.Visible = false
                    DeusUI:Tween(Arrow, TweenInfo.new(0.3), {Rotation = 0})
                    dConfig.Callback(selected)
                end)
            end
            
            Header.MouseButton1Click:Connect(function()
                opened = not opened
                if opened then
                    DropdownFrame.Size = UDim2.new(0.95, 0, 0, 50 + (#dValues * 34))
                    ItemContainer.Visible = true
                    DeusUI:Tween(Arrow, TweenInfo.new(0.3), {Rotation = 180})
                else
                    DropdownFrame.Size = UDim2.new(0.95, 0, 0, 50)
                    ItemContainer.Visible = false
                    DeusUI:Tween(Arrow, TweenInfo.new(0.3), {Rotation = 0})
                end
            end)
            
            table.insert(DeusUI.Elements, {Type = "Text", Instance = Title})
            applyLock(DropdownFrame, dConfig.Locked, dConfig.LockMessage) 
        end
        
        function Tab:Keybind(kConfig) 
            local currentKey = kConfig.Default or Enum.KeyCode.F
            local BindFrame = DeusUI:Create("Frame", { 
                Parent = Page, 
                Size = UDim2.new(0.95, 0, 0, 50), 
                BackgroundColor3 = theme.Secondary, 
                BackgroundTransparency = 0.35, 
                ZIndex = 4,
                BorderSizePixel = 0
            }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 10)}), 
                DeusUI:CreateStroke(nil, theme.StrokeMain, 2, 0.3),
                DeusUI:Create("UIPadding", {PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18)}), 
                DeusUI:Create("TextLabel", {
                    Name = "T", 
                    Text = kConfig.Title or "Keybind", 
                    BackgroundTransparency = 1, 
                    TextColor3 = theme.Text, 
                    TextSize = 14, 
                    Font = Enum.Font.GothamMedium, 
                    Size = UDim2.new(1, -110, 1, 0), 
                    TextXAlignment = "Left", 
                    ZIndex = 5
                })
            })
            
            local Btn = DeusUI:Create("TextButton", { 
                Parent = BindFrame, 
                Size = UDim2.new(0, 90, 0, 28), 
                Position = UDim2.new(1, 0, 0.5, 0), 
                AnchorPoint = Vector2.new(1, 0.5), 
                BackgroundColor3 = theme.Main, 
                BackgroundTransparency = 0.4,
                Text = currentKey.Name, 
                TextColor3 = theme.Accent, 
                Font = Enum.Font.GothamBold, 
                TextSize = 13, 
                ZIndex = 5 
            }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:CreateStroke(nil, theme.StrokeAccent, 1.5, 0.3)
            })
            
            Btn.MouseButton1Click:Connect(function() 
                Btn.Text = "..."
                local connection
                connection = UserInputService.InputBegan:Connect(function(input) 
                    if input.UserInputType == Enum.UserInputType.Keyboard then 
                        currentKey = input.KeyCode
                        Btn.Text = currentKey.Name
                        connection:Disconnect()
                        kConfig.Callback(currentKey) 
                    end 
                end) 
            end)
            
            table.insert(DeusUI.Elements, {Type = "Text", Instance = BindFrame.T})
            applyLock(BindFrame, kConfig.Locked, kConfig.LockMessage) 
        end
        
        function Tab:Colorpicker(cConfig) 
            local current = cConfig.Default or Color3.fromRGB(0, 162, 255)
            local ColorFrame = DeusUI:Create("Frame", { 
                Parent = Page, 
                Size = UDim2.new(0.95, 0, 0, 50), 
                BackgroundColor3 = theme.Secondary, 
                BackgroundTransparency = 0.35, 
                ZIndex = 4,
                BorderSizePixel = 0
            }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 10)}), 
                DeusUI:CreateStroke(nil, theme.StrokeMain, 2, 0.3),
                DeusUI:Create("UIPadding", {PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18)}), 
                DeusUI:Create("TextLabel", {
                    Name = "T", 
                    Text = cConfig.Title or "Color", 
                    BackgroundTransparency = 1, 
                    TextColor3 = theme.Text, 
                    TextSize = 14, 
                    Font = Enum.Font.GothamMedium, 
                    Size = UDim2.new(1, -70, 1, 0), 
                    TextXAlignment = "Left", 
                    ZIndex = 5
                })
            })
            
            local ColorView = DeusUI:Create("TextButton", { 
                Parent = ColorFrame, 
                Size = UDim2.new(0, 50, 0, 28), 
                Position = UDim2.new(1, 0, 0.5, 0), 
                AnchorPoint = Vector2.new(1, 0.5), 
                BackgroundColor3 = current, 
                BackgroundTransparency = 0.2,
                Text = "", 
                ZIndex = 5 
            }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:CreateStroke(nil, theme.StrokeAccent, 2, 0.2)
            })
            
            ColorView.MouseButton1Click:Connect(function() 
                DeusUI:OpenColorPicker(current, function(nc) 
                    current = nc
                    ColorView.BackgroundColor3 = nc
                    cConfig.Callback(nc) 
                end) 
            end)
            
            table.insert(DeusUI.Elements, {Type = "Text", Instance = ColorFrame.T})
            applyLock(ColorFrame, cConfig.Locked, cConfig.LockMessage) 
        end
        
        function Tab:Paragraph(pConfig) 
            local ParaFrame = DeusUI:Create("Frame", { 
                Parent = Page, 
                Size = UDim2.new(0.95, 0, 0, 0), 
                AutomaticSize = "Y", 
                BackgroundColor3 = theme.Secondary, 
                BackgroundTransparency = 0.45, 
                ZIndex = 4,
                BorderSizePixel = 0
            }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 10)}), 
                DeusUI:CreateStroke(nil, theme.StrokeMain, 2, 0.3),
                DeusUI:Create("UIPadding", {
                    PaddingTop = UDim.new(0, 14), 
                    PaddingBottom = UDim.new(0, 14), 
                    PaddingLeft = UDim.new(0, 16), 
                    PaddingRight = UDim.new(0, 16)
                }),
                DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 6)}), 
                DeusUI:Create("TextLabel", {
                    Name = "T", 
                    Text = pConfig.Title or "Info", 
                    BackgroundTransparency = 1, 
                    TextColor3 = theme.Accent, 
                    Font = Enum.Font.GothamBold, 
                    TextSize = 15, 
                    AutomaticSize = "XY", 
                    ZIndex = 5
                }), 
                DeusUI:Create("TextLabel", {
                    Name = "D", 
                    Text = pConfig.Desc or "", 
                    BackgroundTransparency = 1, 
                    TextColor3 = theme.TextSecondary, 
                    Font = Enum.Font.Gotham, 
                    TextSize = 13, 
                    AutomaticSize = "Y", 
                    Size = UDim2.new(1, 0, 0, 0), 
                    TextWrapped = true, 
                    TextXAlignment = "Left", 
                    ZIndex = 5
                })
            })
            
            table.insert(DeusUI.Elements, {Type = "AccentText", Instance = ParaFrame.T})
            table.insert(DeusUI.Elements, {Type = "Text", Instance = ParaFrame.D}) 
        end
        
        return Tab
    end
    
    function Window:Settings()
        local SettingsTab = Window:Tab({Title = "Settings"})

        SettingsTab:Paragraph({ Title = "⚙️ Interface Management", Desc = "Customize your experience and manage the UI state with premium controls." })

        SettingsTab:Dropdown({ Title = "Predefined Themes", Values = {"Dark", "Light", "Purple", "Blue", "Green", "Custom"}, Default = DeusUI.CurrentTheme, Callback = function(t) DeusUI.CurrentTheme = t; updateGlobalStyles(); DeusUI:Notify({Content = "Theme changed to " .. t}) end })

        SettingsTab:Slider({ Title = "Global Transparency", Min = 0, Max = 95, Default = 0, Callback = function(v) MainFrame.BackgroundTransparency = v/100; Sidebar.BackgroundTransparency = (v/100)+0.3 end })

        SettingsTab:Paragraph({ Title = "🎨 Deep Customization", Desc = "Manually override colors for the 'Custom' theme and make it yours." })

        SettingsTab:Colorpicker({
            Title = "Accent Glow Color",
            Default = DeusUI.Themes.Custom.Accent,
            Callback = function(nc)
                DeusUI.Themes.Custom.Accent = nc
                DeusUI.CurrentTheme = "Custom"
                updateGlobalStyles()
                DeusUI:Notify({Content = "✨ Accent color updated!"})
            end
        })

        SettingsTab:Colorpicker({
            Title = "Main Background Color",
            Default = DeusUI.Themes.Custom.Main,
            Callback = function(nc)
                DeusUI.Themes.Custom.Main = nc
                DeusUI.CurrentTheme = "Custom"
                updateGlobalStyles()
            end
        })

        SettingsTab:Colorpicker({
            Title = "Text & Label Color",
            Default = DeusUI.Themes.Custom.Text,
            Callback = function(nc)
                DeusUI.Themes.Custom.Text = nc
                DeusUI.CurrentTheme = "Custom"
                updateGlobalStyles()
            end
        })

        SettingsTab:Button({ Title = "🗑️ Destroy Interface", Callback = function() DeusUI:Notify({Content = "UI Destroyed!"}); task.wait(0.5); ScreenGui:Destroy() end })

        return SettingsTab
    end

    task.spawn(function() while MainFrame.Parent do local fps = math.floor(workspace:GetRealPhysicsFPS()); local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000); StatusBar.PerfText.Text = string.format("⚡ FPS: %d | Ping: %dms | Deus Evolution v2.0", fps, ping); task.wait(1) end end)
    return Window
end

return DeusUI

--[[
    Deus Evolution UI | Version 3.1.0 (FINAL FIX)
    Style: Minimal Compact | Clean Layout | Modern Flat Design
]]

local DeusUI = {
    Themes = {
        Dark = { Main = Color3.fromRGB(22, 22, 30), Secondary = Color3.fromRGB(32, 32, 42), Outline = Color3.fromRGB(50, 50, 65), Text = Color3.fromRGB(240, 240, 245), TextSecondary = Color3.fromRGB(150, 150, 165), Accent = Color3.fromRGB(95, 135, 255), StrokeColor = Color3.fromRGB(65, 65, 85) },
        Light = { Main = Color3.fromRGB(248, 248, 252), Secondary = Color3.fromRGB(235, 235, 245), Outline = Color3.fromRGB(195, 195, 210), Text = Color3.fromRGB(28, 28, 38), TextSecondary = Color3.fromRGB(100, 100, 115), Accent = Color3.fromRGB(70, 115, 255), StrokeColor = Color3.fromRGB(185, 185, 200) },
        Purple = { Main = Color3.fromRGB(28, 20, 40), Secondary = Color3.fromRGB(45, 32, 65), Outline = Color3.fromRGB(90, 60, 130), Text = Color3.fromRGB(245, 245, 255), TextSecondary = Color3.fromRGB(185, 165, 220), Accent = Color3.fromRGB(155, 100, 255), StrokeColor = Color3.fromRGB(100, 75, 140) },
        Blue = { Main = Color3.fromRGB(15, 24, 38), Secondary = Color3.fromRGB(25, 40, 58), Outline = Color3.fromRGB(50, 70, 98), Text = Color3.fromRGB(240, 245, 255), TextSecondary = Color3.fromRGB(150, 180, 215), Accent = Color3.fromRGB(80, 160, 255), StrokeColor = Color3.fromRGB(60, 85, 115) },
        Green = { Main = Color3.fromRGB(14, 28, 20), Secondary = Color3.fromRGB(24, 48, 35), Outline = Color3.fromRGB(50, 90, 70), Text = Color3.fromRGB(240, 255, 245), TextSecondary = Color3.fromRGB(150, 205, 175), Accent = Color3.fromRGB(80, 220, 145), StrokeColor = Color3.fromRGB(55, 105, 80) },
        Custom = { Main = Color3.fromRGB(22, 22, 30), Secondary = Color3.fromRGB(32, 32, 42), Outline = Color3.fromRGB(50, 50, 65), Text = Color3.fromRGB(240, 240, 245), TextSecondary = Color3.fromRGB(150, 150, 165), Accent = Color3.fromRGB(95, 135, 255), StrokeColor = Color3.fromRGB(65, 65, 85) }
    },
    Icons = {
        ["home"] = "rbxassetid://10734950309", ["settings"] = "rbxassetid://10734950056", ["fire"] = "rbxassetid://10723343321", ["eye"] = "rbxassetid://10723346959", ["crown"] = "rbxassetid://10734951157", ["swords"] = "rbxassetid://10723343321", ["layout"] = "rbxassetid://10734951038", ["money"] = "rbxassetid://10734951280", ["lock"] = "rbxassetid://10734950185", ["check"] = "rbxassetid://10734950641", ["copy"] = "rbxassetid://10734950832"
    },
    CurrentTheme = "Dark", Elements = {}, SelectedTab = nil, ScreenGui = nil
}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer

function DeusUI:Create(className, props, children)
    local inst = Instance.new(className)
    if props then for k, v in pairs(props) do pcall(function() inst[k] = v end) end end
    if children then for _, c in pairs(children) do if c and typeof(c) == "Instance" then c.Parent = inst end end end
    return inst
end

function DeusUI:GetIcon(name)
    if not name then return nil end
    if name:find("rbxassetid://") then return name end
    return self.Icons[name:gsub(".*:", "")] or self.Icons["home"]
end

function DeusUI:Tween(inst, info, props)
    local t = TweenService:Create(inst, info, props); t:Play(); return t
end

function DeusUI:Stroke(parent, color, thick, trans)
    return self:Create("UIStroke", {Parent = parent, Color = color or Color3.fromRGB(65,65,85), Thickness = thick or 1.5, Transparency = trans or 0.4})
end

-- ==================== NOTIFICATIONS ====================
local NotifyIcons = { success = "rbxassetid://4458901234", warning = "rbxassetid://4458901384", error = "rbxassetid://4458901560", info = "rbxassetid://4458901706", default = "rbxassetid://4458901706" }
local NotifyHolder = nil
task.defer(function()
    local g = DeusUI:Create("ScreenGui", {Name = "DeusNotify", Parent = (gethui and gethui()) or CoreGui})
    NotifyHolder = DeusUI:Create("Frame", {Name = "Holder", Parent = g, Size = UDim2.new(0, 290, 1, -80), Position = UDim2.new(1, -300, 1, -10), AnchorPoint = Vector2.new(1, 1), BackgroundTransparency = 1}, {
        DeusUI:Create("UIListLayout", {VerticalAlignment = "Bottom", Padding = UDim.new(0, 8), HorizontalAlignment = "Right", SortOrder = "LayoutOrder"})
    })
end)

function DeusUI:Notify(cfg)
    if not NotifyHolder then task.wait(0.5) end
    if not NotifyHolder then return end
    local theme = self.Themes[self.CurrentTheme]
    local tp = cfg.Type or "default"
    local colors = {success = {Color3.fromRGB(34,197,94), Color3.fromRGB(22,163,74)}, warning = {Color3.fromRGB(245,158,11), Color3.fromRGB(217,119,6)}, error = {Color3.fromRGB(239,68,68), Color3.fromRGB(220,38,38)}, info = {theme.Accent, Color3.fromRGB(80,120,240)}, default = {theme.Accent, theme.StrokeColor}}
    local gc = colors[tp] or colors["default"]
    local t = self:Create("Frame", {Name = "Toast", Parent = NotifyHolder, Size = UDim2.new(1, 0, 0, 48), Position = UDim2.new(1.5, 0, 0, 0), BackgroundTransparency = 0.06, BorderSizePixel = 0, LayoutOrder = tick() * 1000}, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        self:Stroke(nil, gc[1], 2, 0.2),
        self:Create("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, gc[1]), ColorSequenceKeypoint.new(1, gc[2])}), Rotation = 135, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.75), NumberSequenceKeypoint.new(0.5, 0.88), NumberSequenceKeypoint.new(1, 0.82)})}),
        self:Create("Frame", {Name = "IconBox", Size = UDim2.new(0, 34, 0, 34), Position = UDim2.new(0, 7, 0, 7), BackgroundColor3 = gc[1], BackgroundTransparency = 0.3, BorderSizePixel = 0}, {
            self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            self:Create("ImageLabel", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Image = NotifyIcons[tp] or NotifyIcons["default"], ImageColor3 = Color3.new(1,1,1), ScaleType = "Fit"})
        }),
        self:Create("TextLabel", {Text = cfg.Content or "", Size = UDim2.new(1, -48, 1, 0), Position = UDim2.new(0, 46, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 12, Font = Enum.Font.GothamBold, TextWrapped = true, TextXAlignment = "Left", TextYAlignment = "Center"}),
        self:Create("Frame", {Name = "Progress", Size = UDim2.new(0, 0, 0, 2), Position = UDim2.new(0, 10, 1, -5), BackgroundColor3 = gc[1], BorderSizePixel = 0}, {self:Create("UICorner", {CornerRadius = UDim.new(0, 1)})})
    })
    self:Tween(t, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
    local dur = cfg.Duration or 3
    local p = t:FindFirstChild("Progress")
    if p then self:Tween(p, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Size = UDim2.new(1, -20, 0, 2)}) end
    task.delay(dur, function()
        if t and t.Parent then
            self:Tween(t, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1.5, 0, 0, 0), BackgroundTransparency = 1})
            task.wait(0.4); t:Destroy()
        end
    end)
end

-- ==================== COLOR PICKER ====================
function DeusUI:OpenColorPicker(defaultColor, callback)
    local theme = self.Themes[self.CurrentTheme]
    local h, s, v = Color3.toHSV(defaultColor)
    local sel = defaultColor
    local P = self:Create("Frame", {Parent = self.ScreenGui, Size = UDim2.new(0, 220, 0, 275), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = theme.Main, Active = true, ZIndex = 3000, BorderSizePixel = 0}, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)}), self:Stroke(nil, theme.StrokeColor, 1.5, 0.35)
    })
    self:Create("TextLabel", {Parent = P, Text = "Color Picker", Size = UDim2.new(1, -44, 0, 24), Position = UDim2.new(0, 8, 0, 8), BackgroundTransparency = 1, TextColor3 = theme.Text, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = "Left", ZIndex = 3001})
    local CB = self:Create("TextButton", {Parent = P, Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -24, 0, 10), BackgroundColor3 = Color3.fromRGB(200,45,45), Text = "x", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 14, ZIndex = 3001}, {self:Create("UICorner", {CornerRadius = UDim.new(0, 5)})})
    CB.MouseButton1Click:Connect(function() P:Destroy() end)
    local SV = self:Create("ImageLabel", {Parent = P, Size = UDim2.new(0, 150, 0, 150), Position = UDim2.new(0, 12, 0, 36), Image = "rbxassetid://4155801252", BackgroundColor3 = Color3.fromHSV(h,1,1), ZIndex = 3001}, {self:Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
    local K = self:Create("Frame", {Parent = SV, Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(s,0,1-v,0), AnchorPoint = Vector2.new(0.5,0.5), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 3002}, {self:Create("UICorner", {CornerRadius = UDim.new(1,0)}), self:Stroke(nil, theme.Accent, 1.5, 0)})
    local HB = self:Create("Frame", {Parent = P, Size = UDim2.new(0, 14, 0, 150), Position = UDim2.new(0, 174, 0, 36), ZIndex = 3001}, {self:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
    self:Create("UIGradient", {Rotation = 90, Parent = HB, Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)), ColorSequenceKeypoint.new(0.2,Color3.fromHSV(0.2,1,1)), ColorSequenceKeypoint.new(0.4,Color3.fromHSV(0.4,1,1)), ColorSequenceKeypoint.new(0.6,Color3.fromHSV(0.6,1,1)), ColorSequenceKeypoint.new(0.8,Color3.fromHSV(0.8,1,1)), ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1))})})
    local HK = self:Create("Frame", {Parent = HB, Size = UDim2.new(1,4,0,4), Position = UDim2.new(0.5,0,h,0), AnchorPoint = Vector2.new(0.5,0.5), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 3002})
    local Hex = self:Create("TextBox", {Parent = P, Size = UDim2.new(0, 90, 0, 24), Position = UDim2.new(0, 12, 0, 198), BackgroundColor3 = theme.Secondary, Text = "#" .. sel:ToHex(), TextColor3 = theme.Text, Font = Enum.Font.GothamMedium, TextSize = 10, ZIndex = 3001}, {self:Create("UICorner", {CornerRadius = UDim.new(0, 5)})})
    local AB = self:Create("TextButton", {Parent = P, Size = UDim2.new(1, -24, 0, 28), Position = UDim2.new(0.5, 0, 1, -12), AnchorPoint = Vector2.new(0.5, 1), BackgroundColor3 = theme.Accent, Text = "Apply", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 12, ZIndex = 3001}, {self:Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
    AB.MouseButton1Click:Connect(function() callback(sel); P:Destroy() end)
    local function upd() sel = Color3.fromHSV(h,s,v); SV.BackgroundColor3 = Color3.fromHSV(h,1,1); Hex.Text = "#" .. sel:ToHex(); K.Position = UDim2.new(s,0,1-v,0); HK.Position = UDim2.new(0.5,0,h,0) end
    local d1, d2 = false, false
    SV.InputBegan:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then d1 = true end end)
    HB.InputBegan:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then d2 = true end end)
    UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then
            if d1 then local p = Vector2.new(i.Position.X-SV.AbsolutePosition.X, i.Position.Y-SV.AbsolutePosition.Y); s = math.clamp(p.X/SV.AbsoluteSize.X,0,1); v = 1-math.clamp(p.Y/SV.AbsoluteSize.Y,0,1); upd()
            elseif d2 then h = math.clamp((i.Position.Y-HB.AbsolutePosition.Y)/HB.AbsoluteSize.Y,0,1); upd() end
        end
    end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then d1=false; d2=false end end)
    upd()
end

-- ==================== MAIN WINDOW ====================
function DeusUI:CreateWindow(cfg)
    local theme = self.Themes[self.CurrentTheme]
    local ScreenGui = self:Create("ScreenGui", {Name = "DeusUI", Parent = (gethui and gethui()) or CoreGui, ResetOnSpawn = false})
    self.ScreenGui = ScreenGui

    local Main = self:Create("Frame", {Name = "Main", Parent = ScreenGui, BackgroundColor3 = theme.Main, Position = UDim2.new(0.5, -252, 0.5, -155), Size = UDim2.new(0, 504, 0, 310), ClipsDescendants = true, ZIndex = 1, BorderSizePixel = 0}, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), self:Stroke(nil, theme.StrokeColor, 1.5, 0.3)
    })

    local Topbar = self:Create("Frame", {Name = "Topbar", Parent = Main, Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, ZIndex = 2})
    self:Create("TextLabel", {Parent = Topbar, Text = cfg.Title or "Deus UI", Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = "Left", ZIndex = 3})
    local Sep = self:Create("Frame", {Parent = Topbar, Size = UDim2.new(1, -16, 0, 1), Position = UDim2.new(0, 8, 1, 0), BackgroundColor3 = theme.Outline, BackgroundTransparency = 0.85, BorderSizePixel = 0})

    local Ctrl = self:Create("Frame", {Parent = Topbar, Size = UDim2.new(0, 52, 0, 22), Position = UDim2.new(1, -6, 0, 7), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1}, {
        self:Create("UIListLayout", {FillDirection = "Horizontal", Padding = UDim.new(0, 4), VerticalAlignment = "Center", HorizontalAlignment = "Right"})
    })
    local MnB = self:Create("TextButton", {Size = UDim2.new(0, 20, 0, 20), BackgroundColor3 = theme.Secondary, Text = "-", TextColor3 = theme.Text, TextSize = 16, Font = Enum.Font.GothamBold}, {self:Create("UICorner", {CornerRadius = UDim.new(0, 4)})}); MnB.Parent = Ctrl
    local ClB = self:Create("TextButton", {Size = UDim2.new(0, 20, 0, 20), BackgroundColor3 = Color3.fromRGB(200,45,45), Text = "x", TextColor3 = Color3.new(1,1,1), TextSize = 14, Font = Enum.Font.GothamBold}, {self:Create("UICorner", {CornerRadius = UDim.new(0, 4)})}); ClB.Parent = Ctrl

    -- Sidebar: 52px wide
    local Sidebar = self:Create("Frame", {Name = "Sidebar", Parent = Main, Size = UDim2.new(0, 52, 1, -72), Position = UDim2.new(0, 6, 0, 42), BackgroundColor3 = theme.Secondary, BorderSizePixel = 0, ClipsDescendants = true}, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), self:Stroke(nil, theme.StrokeColor, 1.2, 0.35),
        self:Create("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4)})
    })

    local TabScroll = self:Create("ScrollingFrame", {Parent = Sidebar, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 0, AutomaticCanvasSize = "Y", CanvasSize = UDim2.new(0, 0, 0, 0)}, {
        self:Create("UIListLayout", {Padding = UDim.new(0, 5), HorizontalAlignment = "Center"})
    })

    -- Page Container: positioned at 52+6+6=64, width 1-70
    local PageCont = self:Create("Frame", {Parent = Main, Size = UDim2.new(1, -70, 1, -72), Position = UDim2.new(0, 64, 0, 42), BackgroundTransparency = 1}, {
        self:Create("UIPadding", {PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3), PaddingLeft = UDim.new(0, 3), PaddingRight = UDim.new(0, 3)})
    })

    local Status = self:Create("Frame", {Parent = Main, Size = UDim2.new(1, -12, 0, 20), Position = UDim2.new(0, 6, 1, -26), BackgroundColor3 = theme.Secondary, BorderSizePixel = 0}, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 5)}), self:Stroke(nil, theme.StrokeColor, 1, 0.4),
        self:Create("TextLabel", {Name = "Text", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "FPS: 60 | Ping: 0ms", TextColor3 = theme.TextSecondary, TextSize = 9, Font = Enum.Font.GothamMedium, TextXAlignment = "Center"})
    })

    local WinSize = UDim2.new(0, 504, 0, 310)
    local isMin = false
    MnB.MouseButton1Click:Connect(function()
        isMin = not isMin
        self:Tween(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = isMin and UDim2.new(0, 504, 0, 36) or WinSize})
        Sidebar.Visible = not isMin; PageCont.Visible = not isMin; Status.Visible = not isMin; Sep.Visible = not isMin
    end)
    ClB.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local drag, dragP, startP
    Topbar.InputBegan:Connect(function(i)
        if (i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch")) and not isMin then
            drag = true; dragP = i.Position; startP = Main.Position
            i.Changed:Connect(function() if i.UserInputState.Name:find("End") then drag = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch")) then
            local d = i.Position - dragP
            Main.Position = UDim2.new(startP.X.Scale, startP.X.Offset + d.X, startP.Y.Scale, startP.Y.Offset + d.Y)
        end
    end)

    local allTabs = {}
    local selTabBtn = nil

    local function updateTheme()
        local t = DeusUI.Themes[DeusUI.CurrentTheme]
        self:Tween(Main, TweenInfo.new(0.2), {BackgroundColor3 = t.Main})
        self:Tween(Sidebar, TweenInfo.new(0.2), {BackgroundColor3 = t.Secondary})
        Sep.BackgroundColor3 = t.Outline; Status.Text.TextColor3 = t.TextSecondary
        for _, btn in pairs(allTabs) do
            if btn:GetAttribute("Selected") then
                self:Tween(btn, TweenInfo.new(0.2), {BackgroundColor3 = t.Accent})
                local ic = btn:FindFirstChild("Icon"); if ic then ic.ImageColor3 = t.Text end
                local lt = btn:FindFirstChild("Letter"); if lt then lt.TextColor3 = t.Text end
                local lb = btn:FindFirstChild("Label"); if lb then lb.TextColor3 = t.Text end
            else
                self:Tween(btn, TweenInfo.new(0.2), {BackgroundColor3 = t.Main})
                local ic = btn:FindFirstChild("Icon"); if ic then ic.ImageColor3 = t.TextSecondary end
                local lt = btn:FindFirstChild("Letter"); if lt then lt.TextColor3 = t.TextSecondary end
                local lb = btn:FindFirstChild("Label"); if lb then lb.TextColor3 = t.TextSecondary end
            end
        end
    end

    local Window = {}
    function Window:Tab(tc)
        local title = tc.Title or "Tab"
        local fl = title:sub(1, 1):upper()
        local icon = DeusUI:GetIcon(tc.Icon)

        local Page = DeusUI:Create("ScrollingFrame", {Parent = PageCont, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = theme.Accent, AutomaticCanvasSize = "Y"}, {
            DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 5)})
        })

        local TabBtn = DeusUI:Create("TextButton", {Parent = TabScroll, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = theme.Main, BackgroundTransparency = 0.5, Text = "", AutoButtonColor = false, BorderSizePixel = 0, ClipsDescendants = true}, {
            DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 7)}),
            DeusUI:Stroke(nil, theme.StrokeColor, 1, 0.5),
            icon and DeusUI:Create("ImageLabel", {Name = "Icon", Size = UDim2.new(0, 17, 0, 17), Position = UDim2.new(0.5, 0, 0, 3), AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 1, Image = icon, ImageColor3 = theme.TextSecondary, ScaleType = "Fit"}) or nil,
            DeusUI:Create("TextLabel", {Name = "Letter", Text = fl, Size = UDim2.new(0, 16, 0, 13), Position = UDim2.new(0.5, 0, 0, 19), AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, TextSize = 10, Font = Enum.Font.GothamBold}),
            DeusUI:Create("TextLabel", {Name = "Label", Text = title, Size = UDim2.new(1, -6, 0, 13), Position = UDim2.new(0.5, 0, 0, 24), AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, TextSize = 10, Font = Enum.Font.GothamMedium, TextXAlignment = "Center", TextTransparency = 1})
        })

        table.insert(allTabs, TabBtn)

        TabBtn.MouseButton1Click:Connect(function()
            if selTabBtn == TabBtn then return end
            for _, btn in pairs(allTabs) do
                btn:SetAttribute("Selected", false)
                local pg = PageCont:FindFirstChild(title .. "Page")
                -- find matching page
                for _, child in pairs(PageCont:GetChildren()) do
                    if child:IsA("ScrollingFrame") and child.Name == btn:GetAttribute("PageName") then child.Visible = false end
                end
                DeusUI:Tween(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Main, BackgroundTransparency = 0.5})
                local ic = btn:FindFirstChild("Icon"); if ic then DeusUI:Tween(ic, TweenInfo.new(0.3), {ImageColor3 = DeusUI.Themes[DeusUI.CurrentTheme].TextSecondary, Position = UDim2.new(0.5,0,0,3)}) end
                local lt = btn:FindFirstChild("Letter"); if lt then DeusUI:Tween(lt, TweenInfo.new(0.3), {TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].TextSecondary, Position = UDim2.new(0.5,0,0,19)}) end
                local lb = btn:FindFirstChild("Label"); if lb then DeusUI:Tween(lb, TweenInfo.new(0.25), {TextTransparency = 1}) end
                local st = btn:FindFirstChildOfClass("UIStroke"); if st then DeusUI:Tween(st, TweenInfo.new(0.3), {Color = DeusUI.Themes[DeusUI.CurrentTheme].StrokeColor, Transparency = 0.5}) end
            end

            TabBtn:SetAttribute("Selected", true)
            Page.Visible = true
            selTabBtn = TabBtn
            DeusUI:Tween(TabBtn, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent, BackgroundTransparency = 0.1})
            local ic = TabBtn:FindFirstChild("Icon"); if ic then DeusUI:Tween(ic, TweenInfo.new(0.35, Enum.EasingStyle.Back), {ImageColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Text, Position = UDim2.new(0.5,0,0,2)}) end
            local lt = TabBtn:FindFirstChild("Letter"); if lt then DeusUI:Tween(lt, TweenInfo.new(0.35, Enum.EasingStyle.Back), {TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Text, Position = UDim2.new(0.5,0,0,16)}) end
            local lb = TabBtn:FindFirstChild("Label"); if lb then DeusUI:Tween(lb, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0}) end
            local st = TabBtn:FindFirstChildOfClass("UIStroke"); if st then DeusUI:Tween(st, TweenInfo.new(0.35), {Color = DeusUI.Themes[DeusUI.CurrentTheme].Accent, Transparency = 0}) end
        end)

        -- Store page name for lookup
        TabBtn:SetAttribute("PageName", title .. "Page")

        if not DeusUI.SelectedTab then
            DeusUI.SelectedTab = true
            TabBtn:SetAttribute("Selected", true)
            Page.Visible = true
            selTabBtn = TabBtn
            TabBtn.Size = UDim2.new(1, 0, 0, 48)
            TabBtn.BackgroundColor3 = theme.Accent
            TabBtn.BackgroundTransparency = 0.1
            local ic = TabBtn:FindFirstChild("Icon"); if ic then ic.ImageColor3 = theme.Text end
            local lt = TabBtn:FindFirstChild("Letter"); if lt then lt.TextColor3 = theme.Text end
            local lb = TabBtn:FindFirstChild("Label"); if lb then lb.TextTransparency = 0 end
            local st = TabBtn:FindFirstChildOfClass("UIStroke"); if st then st.Color = theme.Accent; st.Transparency = 0 end
        end

        local Tab = {}
        local function lock(fr, lk, msg)
            if lk then DeusUI:Create("Frame", {Parent = fr, Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.55, ZIndex = 100, Active = true}, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
                DeusUI:Create("TextLabel", {Text = "[LOCKED] " .. (msg or "VIP"), Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 10})
            }) end
        end

        function Tab:Button(c)
            local f = DeusUI:Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = theme.Secondary, BorderSizePixel = 0}, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), DeusUI:Stroke(nil, theme.StrokeColor, 1, 0.4),
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 1), PaddingBottom = UDim.new(0, 1), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}),
                DeusUI:Create("TextButton", {Name = "Btn", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = c.Title or "Button", TextColor3 = theme.Text, TextSize = 11, Font = Enum.Font.GothamBold})
            }); f.Btn.MouseButton1Click:Connect(function() c.Callback() end); lock(f, c.Locked, c.LockMessage)
        end

        function Tab:Toggle(c)
            local on = c.Default or false
            local f = DeusUI:Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = theme.Secondary, BorderSizePixel = 0}, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), DeusUI:Stroke(nil, theme.StrokeColor, 1, 0.4),
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 6)}),
                DeusUI:Create("TextLabel", {Text = c.Title or "Toggle", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 11, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -42, 1, 0), TextXAlignment = "Left"})
            })
            local sw = DeusUI:Create("TextButton", {Parent = f, Size = UDim2.new(0, 34, 0, 16), Position = UDim2.new(1, -3, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = on and theme.Accent or Color3.fromRGB(60,60,70), Text = ""}, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            local ci = DeusUI:Create("Frame", {Parent = sw, Size = UDim2.new(0, 12, 0, 12), Position = on and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), AnchorPoint = on and Vector2.new(1, 0.5) or Vector2.new(0, 0.5), BackgroundColor3 = Color3.new(1,1,1)}, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            sw.MouseButton1Click:Connect(function()
                on = not on
                DeusUI:Tween(ci, TweenInfo.new(0.2), {Position = on and UDim2.new(1,-2,0.5,0) or UDim2.new(0,2,0.5,0), AnchorPoint = on and Vector2.new(1,0.5) or Vector2.new(0,0.5)})
                DeusUI:Tween(sw, TweenInfo.new(0.2), {BackgroundColor3 = on and theme.Accent or Color3.fromRGB(60,60,70)})
                c.Callback(on)
            end); lock(f, c.Locked, c.LockMessage)
        end

        function Tab:Slider(c)
            local mn, mx, val = c.Min or 0, c.Max or 100, c.Default or 50
            local f = DeusUI:Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = theme.Secondary, BorderSizePixel = 0}, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), DeusUI:Stroke(nil, theme.StrokeColor, 1, 0.4),
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}),
                DeusUI:Create("TextLabel", {Name = "Title", Text = c.Title or "Slider", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 11, Font = Enum.Font.GothamMedium, Size = UDim2.new(0.6, 0, 0, 16), TextXAlignment = "Left"}),
                DeusUI:Create("TextLabel", {Name = "Val", Text = tostring(val), BackgroundTransparency = 1, TextColor3 = theme.Accent, TextSize = 11, Font = Enum.Font.GothamBold, Size = UDim2.new(0.4, 0, 0, 16), TextXAlignment = "Right"})
            })
            local bar = DeusUI:Create("Frame", {Parent = f, Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0, 28), BackgroundColor3 = theme.Main, BackgroundTransparency = 0.5}, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            local fill = DeusUI:Create("Frame", {Parent = bar, Size = UDim2.new((val-mn)/(mx-mn), 0, 1, 0), BackgroundColor3 = theme.Accent}, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            local knob = DeusUI:Create("Frame", {Parent = fill, Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1,1,1)}, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), DeusUI:Stroke(nil, theme.Accent, 1.5, 0)})
            local dr = false
            local function upd(i) local p = math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1); val = math.floor(mn+(mx-mn)*p); f.Val.Text = tostring(val); fill.Size = UDim2.new(p,0,1,0); c.Callback(val) end
            bar.InputBegan:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then dr=true; upd(i) end end)
            UserInputService.InputChanged:Connect(function(i) if dr and (i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch")) then upd(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then dr=false end end)
            lock(f, c.Locked, c.LockMessage)
        end

        function Tab:Dropdown(c)
            local vals = c.Values or {}; local sel = c.Default or "Select"; local open = false
            local f = DeusUI:Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = theme.Secondary, ClipsDescendants = true, BorderSizePixel = 0}, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), DeusUI:Stroke(nil, theme.StrokeColor, 1, 0.4),
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 8)})
            })
            local hdr = DeusUI:Create("TextButton", {Parent = f, Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Text = ""})
            DeusUI:Create("TextLabel", {Parent = hdr, Text = c.Title or "Dropdown", Size = UDim2.new(0.4, 0, 1, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, Font = Enum.Font.GothamMedium, TextSize = 11, TextXAlignment = "Left"})
            local cont = DeusUI:Create("TextLabel", {Parent = hdr, Text = sel, Size = UDim2.new(0.45, 0, 1, 0), Position = UDim2.new(0.55, 0, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, Font = Enum.Font.GothamMedium, TextSize = 10, TextXAlignment = "Right"})
            local arr = DeusUI:Create("TextLabel", {Parent = hdr, Text = "v", Size = UDim2.new(0.1, 0, 1, 0), Position = UDim2.new(0.9, 0, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Accent, Font = Enum.Font.GothamBold, TextSize = 9, TextXAlignment = "Center"})
            local items = DeusUI:Create("Frame", {Parent = f, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 28), BackgroundTransparency = 1, Visible = false}, {DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 3)})})
            for _, v in pairs(vals) do
                local ib = DeusUI:Create("TextButton", {Parent = items, Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = theme.Main, BackgroundTransparency = 0.2, Text = "  " .. v, TextColor3 = theme.Text, Font = Enum.Font.GothamMedium, TextSize = 10, TextXAlignment = "Left"}, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
                ib.MouseButton1Click:Connect(function() sel=v; cont.Text=sel; open=false; f.Size=UDim2.new(1,0,0,34); items.Visible=false; DeusUI:Tween(arr, TweenInfo.new(0.2), {Rotation=0}); c.Callback(sel) end)
            end
            hdr.MouseButton1Click:Connect(function()
                open = not open
                if open then f.Size=UDim2.new(1,0,0,34+(#vals*25)); items.Visible=true; DeusUI:Tween(arr, TweenInfo.new(0.2), {Rotation=180})
                else f.Size=UDim2.new(1,0,0,34); items.Visible=false; DeusUI:Tween(arr, TweenInfo.new(0.2), {Rotation=0}) end
            end); lock(f, c.Locked, c.LockMessage)
        end

        function Tab:Keybind(c)
            local key = c.Default or Enum.KeyCode.F
            local f = DeusUI:Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = theme.Secondary, BorderSizePixel = 0}, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), DeusUI:Stroke(nil, theme.StrokeColor, 1, 0.4),
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 8)}),
                DeusUI:Create("TextLabel", {Text = c.Title or "Keybind", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 11, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -60, 1, 0), TextXAlignment = "Left"})
            })
            local btn = DeusUI:Create("TextButton", {Parent = f, Size = UDim2.new(0, 55, 0, 22), Position = UDim2.new(1, -4, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = theme.Main, BackgroundTransparency = 0.3, Text = key.Name, TextColor3 = theme.Accent, Font = Enum.Font.GothamBold, TextSize = 10}, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 5)})})
            btn.MouseButton1Click:Connect(function() btn.Text="..."; local cn; cn=UserInputService.InputBegan:Connect(function(i) if i.UserInputType.Name:find("Keyboard") then key=i.KeyCode; btn.Text=key.Name; cn:Disconnect(); c.Callback(key) end end) end)
            lock(f, c.Locked, c.LockMessage)
        end

        function Tab:Colorpicker(c)
            local clr = c.Default or Color3.fromRGB(0,162,255)
            local f = DeusUI:Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = theme.Secondary, BorderSizePixel = 0}, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), DeusUI:Stroke(nil, theme.StrokeColor, 1, 0.4),
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 8)}),
                DeusUI:Create("TextLabel", {Text = c.Title or "Color", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 11, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -44, 1, 0), TextXAlignment = "Left"})
            })
            local vw = DeusUI:Create("TextButton", {Parent = f, Size = UDim2.new(0, 34, 0, 20), Position = UDim2.new(1, -4, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = clr, Text = ""}, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 5)})})
            vw.MouseButton1Click:Connect(function() DeusUI:OpenColorPicker(clr, function(nc) clr=nc; vw.BackgroundColor3=nc; c.Callback(nc) end) end)
            lock(f, c.Locked, c.LockMessage)
        end

        function Tab:Paragraph(c)
            DeusUI:Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = "Y", BackgroundColor3 = theme.Secondary, BackgroundTransparency = 0.3, BorderSizePixel = 0}, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), DeusUI:Stroke(nil, theme.StrokeColor, 1, 0.4),
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}),
                DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 3)}),
                DeusUI:Create("TextLabel", {Text = c.Title or "Info", BackgroundTransparency = 1, TextColor3 = theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, AutomaticSize = "XY"}),
                DeusUI:Create("TextLabel", {Text = c.Desc or "", BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, Font = Enum.Font.Gotham, TextSize = 10, AutomaticSize = "Y", Size = UDim2.new(1,0,0,0), TextWrapped = true, TextXAlignment = "Left"})
            })
        end

        return Tab
    end

    function Window:Settings()
        local s = Window:Tab({Title = "Settings"})
        s:Paragraph({Title = "Interface", Desc = "Customize themes and appearance."})
        s:Dropdown({Title = "Theme", Values = {"Dark", "Light", "Purple", "Blue", "Green", "Custom"}, Default = DeusUI.CurrentTheme, Callback = function(t) DeusUI.CurrentTheme=t; updateTheme(); DeusUI:Notify({Content="Theme: "..t, Type="success"}) end})
        s:Slider({Title = "Transparency", Min = 0, Max = 95, Default = 0, Callback = function(v) Main.BackgroundTransparency=v/100; Sidebar.BackgroundTransparency=(v/100)+0.2 end})
        s:Paragraph({Title = "Custom Colors", Desc = "Override colors for Custom theme."})
        s:Colorpicker({Title = "Accent", Default = DeusUI.Themes.Custom.Accent, Callback = function(c) DeusUI.Themes.Custom.Accent=c; DeusUI.CurrentTheme="Custom"; updateTheme(); DeusUI:Notify({Content="Accent updated!", Type="success"}) end})
        s:Colorpicker({Title = "Background", Default = DeusUI.Themes.Custom.Main, Callback = function(c) DeusUI.Themes.Custom.Main=c; DeusUI.CurrentTheme="Custom"; updateTheme() end})
        s:Colorpicker({Title = "Text", Default = DeusUI.Themes.Custom.Text, Callback = function(c) DeusUI.Themes.Custom.Text=c; DeusUI.CurrentTheme="Custom"; updateTheme() end})
        s:Button({Title = "Destroy UI", Callback = function() DeusUI:Notify({Content="Destroying...", Type="error"}); task.wait(0.3); ScreenGui:Destroy() end})
        return s
    end

    task.spawn(function()
        while Main.Parent do
            local fps = math.floor(workspace:GetRealPhysicsFPS())
            local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
            Status.Text.Text = string.format("FPS: %d | Ping: %dms | Deus v3.1", fps, ping)
            task.wait(1)
        end
    end)
    return Window
end

return DeusUI

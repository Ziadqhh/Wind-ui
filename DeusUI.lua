--[[
    Deus Evolution UI | Version 1.4.0 (PRO EDITION)
    Style: Sleek Slate & Neon | Compact Pro Layout
    Optimized for: Performance & Human Aesthetic
]]

local DeusUI = {
    Themes = {
        Dark = { Main = Color3.fromRGB(18, 18, 20), Secondary = Color3.fromRGB(24, 24, 28), ChannelBG = Color3.fromRGB(30, 30, 35), Outline = Color3.fromRGB(40, 40, 45), Text = Color3.fromRGB(235, 235, 240), TextSecondary = Color3.fromRGB(150, 155, 165), Accent = Color3.fromRGB(0, 170, 255), Success = Color3.fromRGB(40, 200, 110), Danger = Color3.fromRGB(255, 75, 75), Transparency = 0 },
        Midnight = { Main = Color3.fromRGB(10, 10, 12), Secondary = Color3.fromRGB(15, 15, 18), ChannelBG = Color3.fromRGB(20, 20, 25), Outline = Color3.fromRGB(35, 35, 45), Text = Color3.fromRGB(255, 255, 255), TextSecondary = Color3.fromRGB(140, 140, 160), Accent = Color3.fromRGB(180, 100, 255), Success = Color3.fromRGB(0, 255, 120), Danger = Color3.fromRGB(255, 50, 50), Transparency = 0 },
        Slate = { Main = Color3.fromRGB(35, 38, 45), Secondary = Color3.fromRGB(40, 45, 55), ChannelBG = Color3.fromRGB(30, 32, 40), Outline = Color3.fromRGB(60, 65, 80), Text = Color3.fromRGB(240, 245, 255), TextSecondary = Color3.fromRGB(170, 180, 200), Accent = Color3.fromRGB(255, 180, 0), Success = Color3.fromRGB(80, 220, 100), Danger = Color3.fromRGB(255, 100, 100), Transparency = 0 }
    },
    Icons = {},
    IconURL = "https://raw.githubusercontent.com/Ziadqhh/Wind-ui/refs/heads/main/icon%20pack.lua",
    CurrentTheme = "Dark",
    Elements = {},
    SelectedTab = nil,
    ScreenGui = nil,
    MainFrame = nil,
    UIScale = nil
}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function FetchIcons()
    if next(DeusUI.Icons) then return end
    local success, result = pcall(function() return loadstring(game:HttpGet(DeusUI.IconURL))() end)
    if success and type(result) == "table" then DeusUI.Icons = result else warn("DeusUI: Icon Load Failed.") end
end

function DeusUI:Create(className, properties, children)
    local inst = Instance.new(className)
    if properties then
        for prop, value in pairs(properties) do
            pcall(function() inst[prop] = value end)
        end
    end
    if children then for _, child in pairs(children) do if child then child.Parent = inst end end end
    return inst
end

function DeusUI:GetIcon(name)
    if not name or name == "" then return nil end
    if name:find("rbxassetid://") then return name end
    FetchIcons()
    return DeusUI.Icons[name] or "rbxassetid://10734950309"
end

function DeusUI:Tween(instance, info, propertyTable)
    if not instance then return end
    local tween = TweenService:Create(instance, info, propertyTable)
    tween:Play()
    return tween
end

function DeusUI:UpdateUI()
    local theme = self.Themes[self.CurrentTheme]
    local TI = TweenInfo.new(0.25, Enum.EasingStyle.Quart)
    for _, data in pairs(self.Elements) do
        local inst = data.Instance
        if not inst or not inst.Parent then continue end
        if data.Type == "MainFrame" then self:Tween(inst, TI, {BackgroundColor3 = theme.Main})
        elseif data.Type == "Sidebar" then self:Tween(inst, TI, {BackgroundColor3 = theme.Secondary})
        elseif data.Type == "TabBtn" then
            local targetText = data.Selected and theme.Accent or theme.TextSecondary
            self:Tween(inst.Content.Label, TI, {TextColor3 = targetText})
            if inst.Content:FindFirstChild("Icon") then self:Tween(inst.Content.Icon, TI, {ImageColor3 = targetText}) end
            if data.Selected then self:Tween(inst.Indicator, TI, {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0})
            else self:Tween(inst.Indicator, TI, {BackgroundTransparency = 1}) end
        elseif data.Type == "Button" then self:Tween(inst, TI, {BackgroundColor3 = theme.Accent})
        elseif data.Type == "ToggleSwitch" then self:Tween(inst, TI, {BackgroundColor3 = data.Toggled and theme.Success or theme.Outline})
        elseif data.Type == "SliderFill" then self:Tween(inst, TI, {BackgroundColor3 = theme.Accent})
        elseif data.Type == "SectionText" then self:Tween(inst, TI, {TextColor3 = theme.Accent})
        elseif data.Type == "TextColor" then self:Tween(inst, TI, {TextColor3 = theme.Text})
        elseif data.Type == "SecondaryBG" then self:Tween(inst, TI, {BackgroundColor3 = theme.ChannelBG}) end
    end
end

function DeusUI:Notify(config)
    local theme = self.Themes[self.CurrentTheme]
    if not self.NotifyGui then
        self.NotifyGui = self:Create("ScreenGui", { Name = "DeusNotify", Parent = (gethui and gethui()) or CoreGui })
        self.NotifyHolder = self:Create("Frame", { Name = "H", Parent = self.NotifyGui, Size = UDim2.new(0, 240, 1, -20), Position = UDim2.new(1, -250, 0, 10), BackgroundTransparency = 1 }, { self:Create("UIListLayout", {VerticalAlignment = "Bottom", Padding = UDim.new(0, 8)}) })
    end
    local Toast = self:Create("Frame", { Name = "T", Parent = self.NotifyHolder, Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = theme.Main, BackgroundTransparency = 0.1 }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), self:Create("UIStroke", {Color = theme.Accent, Thickness = 1.5, Transparency = 0.4}),
        self:Create("TextLabel", { Text = config.Title or "SYSTEM", Size = UDim2.new(1, -20, 0, 18), Position = UDim2.new(0, 10, 0, 6), BackgroundTransparency = 1, TextColor3 = theme.Accent, TextSize = 11, Font = Enum.Font.GothamBold, TextXAlignment = "Left" }),
        self:Create("TextLabel", { Text = config.Content or "...", Size = UDim2.new(1, -20, 0, 18), Position = UDim2.new(0, 10, 0, 24), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 10, Font = Enum.Font.GothamMedium, TextXAlignment = "Left" }),
        self:Create("Frame", { Name = "P", Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), BackgroundColor3 = theme.Accent }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 4)}) })
    })
    Toast.Position = UDim2.new(1.5, 0, 0, 0); self:Tween(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 0, 0, 0)})
    local dur = config.Duration or 3; self:Tween(Toast.P, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)})
    task.delay(dur, function() if Toast then self:Tween(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(1.5, 0, 0, 0)}); task.wait(0.3); Toast:Destroy() end end)
end

function DeusUI:CreateWindow(config)
    local theme = self.Themes[self.CurrentTheme]
    local ScreenGui = self:Create("ScreenGui", { Name = "DeusV14", Parent = (gethui and gethui()) or CoreGui, ResetOnSpawn = false })
    self.ScreenGui = ScreenGui; self.Elements = {}
    
    local WindowSize = UDim2.new(0, 410, 0, 265)
    local MainFrame = self:Create("CanvasGroup", { Name = "MF", Parent = ScreenGui, BackgroundColor3 = theme.Main, Position = UDim2.new(0.5, -205, 0.5, -132), Size = WindowSize, GroupTransparency = 0 }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), self:Create("UIStroke", {Color = theme.Outline, Thickness = 1.2}), self:Create("UIScale", {Scale = 1}) })
    self.MainFrame = MainFrame; self.UIScale = MainFrame.UIScale; table.insert(self.Elements, {Instance = MainFrame, Type = "MainFrame"})
    
    local Sidebar = self:Create("Frame", { Name = "SB", Parent = MainFrame, Size = UDim2.new(0, 120, 1, 0), BackgroundColor3 = theme.Secondary }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), self:Create("Frame", {Size = UDim2.new(1, 0, 0, 35)}, { self:Create("TextLabel", {Text = config.Title or "DEUS PRO", Size = UDim2.new(1, -15, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Accent, TextSize = 11, Font = Enum.Font.GothamBold, TextXAlignment = "Left"}), self:Create("Frame", {Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 1, 0), BackgroundColor3 = theme.Outline}) }) })
    table.insert(self.Elements, {Instance = Sidebar, Type = "Sidebar"})
    
    local TabContainer = self:Create("ScrollingFrame", { Parent = Sidebar, Size = UDim2.new(1, 0, 1, -45), Position = UDim2.new(0, 0, 0, 40), BackgroundTransparency = 1, ScrollBarThickness = 0, AutomaticCanvasSize = "Y" }, { self:Create("UIListLayout", {Padding = UDim.new(0, 2), HorizontalAlignment = "Center"}) })
    local PageContainer = self:Create("Frame", { Name = "PC", Parent = MainFrame, Size = UDim2.new(1, -120, 1, -30), Position = UDim2.new(0, 120, 0, 30), BackgroundTransparency = 1 })
    local Topbar = self:Create("Frame", { Name = "TB", Parent = MainFrame, Size = UDim2.new(1, -120, 0, 30), Position = UDim2.new(0, 120, 0, 0), BackgroundTransparency = 1 }, { self:Create("TextLabel", {Name = "Title", Text = "...", Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 10, Font = Enum.Font.GothamBold, TextXAlignment = "Left"}) })
    
    local Controls = self:Create("Frame", { Parent = Topbar, Size = UDim2.new(0, 50, 1, 0), Position = UDim2.new(1, -5, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1 }, { self:Create("UIListLayout", {FillDirection = "Horizontal", Padding = UDim.new(0, 2), VerticalAlignment = "Center", HorizontalAlignment = "Right"}) })
    local function Ctrl(txt, color) local b = self:Create("TextButton", {Size = UDim2.new(0, 20, 0, 20), BackgroundTransparency = 1, Text = txt, TextColor3 = theme.TextSecondary, TextSize = 14, Font = Enum.Font.GothamBold}, {self:Create("UICorner", {CornerRadius = UDim.new(0, 4)})}); b.MouseEnter:Connect(function() b.BackgroundTransparency = 0.8; b.BackgroundColor3 = color or theme.Outline end); b.MouseLeave:Connect(function() b.BackgroundTransparency = 1 end); return b end
    local MinBtn = Ctrl("—"); local CloseBtn = Ctrl("×", theme.Danger); MinBtn.Parent = Controls; CloseBtn.Parent = Controls; CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    local dragging, dragStart, startPos; Topbar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = MainFrame.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end); UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

    local Order = 0
    local WindowMethods = {}
    
    function WindowMethods:SidebarSection(title) 
        Order = Order + 1
        local Sec = DeusUI:Create("TextLabel", { Parent = TabContainer, Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = title:upper(), TextColor3 = theme.TextSecondary, TextSize = 8, Font = Enum.Font.GothamBold, TextXAlignment = "Left", LayoutOrder = Order }, { DeusUI:Create("UIPadding", {PaddingLeft = UDim.new(0, 12)}) })
        table.insert(DeusUI.Elements, {Instance = Sec, Type = "SectionText"})
    end
    
    function WindowMethods:Tab(tabConfig)
        Order = Order + 1
        local Page = DeusUI:Create("ScrollingFrame", { Parent = PageContainer, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 1, ScrollBarImageColor3 = theme.Outline, AutomaticCanvasSize = "Y" }, { DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 6), HorizontalAlignment = "Center"}), DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}) })
        local TabBtn = DeusUI:Create("TextButton", { Parent = TabContainer, Size = UDim2.new(1, -16, 0, 26), BackgroundTransparency = 1, Text = "", LayoutOrder = Order }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), DeusUI:Create("Frame", { Name = "Indicator", Size = UDim2.new(0, 2, 0, 12), Position = UDim2.new(0, -6, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = theme.Accent, BackgroundTransparency = 1 }), DeusUI:Create("Frame", { Name = "Content", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, { DeusUI:Create("UIListLayout", {FillDirection = "Horizontal", VerticalAlignment = "Center", Padding = UDim.new(0, 8)}), DeusUI:Create("UIPadding", {PaddingLeft = UDim.new(0, 6)}), tabConfig.Icon and DeusUI:Create("ImageLabel", { Name = "Icon", Size = UDim2.new(0, 14, 0, 14), BackgroundTransparency = 1, Image = DeusUI:GetIcon(tabConfig.Icon), ImageColor3 = theme.TextSecondary }) or nil, DeusUI:Create("TextLabel", { Name = "Label", Text = tabConfig.Title or "Tab", Size = UDim2.new(0, 0, 1, 0), AutomaticSize = "X", BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, TextSize = 10, Font = Enum.Font.GothamMedium }) }) })
        local tData = {Type = "TabBtn", Instance = TabBtn, Selected = false}; table.insert(DeusUI.Elements, tData)
        
        local function Open()
            for _, p in pairs(PageContainer:GetChildren()) do p.Visible = false end; Page.Visible = true
            for _, el in pairs(DeusUI.Elements) do if el.Type == "TabBtn" then el.Selected = false end end
            tData.Selected = true; Topbar.Title.Text = tabConfig.Title; DeusUI:UpdateUI()
        end
        TabBtn.MouseButton1Click:Connect(Open)
        if not DeusUI.SelectedTab then DeusUI.SelectedTab = true; Open() end
        
        local TabMethods = {}
        function TabMethods:Section(title) local Sec = DeusUI:Create("TextLabel", { Parent = Page, Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = title:upper(), TextColor3 = theme.Accent, TextSize = 9, Font = Enum.Font.GothamBold, TextXAlignment = "Left" }); table.insert(DeusUI.Elements, {Instance = Sec, Type = "SectionText"}); return Sec end
        function TabMethods:Button(c) local B = DeusUI:Create("TextButton", { Parent = Page, Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = theme.Accent, Text = c.Title or "Button", TextColor3 = Color3.new(1,1,1), TextSize = 10, Font = Enum.Font.GothamBold }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}) }); table.insert(DeusUI.Elements, {Instance = B, Type = "Button"}); B.MouseButton1Click:Connect(c.Callback) end
        function TabMethods:Toggle(c)
            local state = c.Default or false; local T = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1 }, { DeusUI:Create("TextLabel", {Text = c.Title, Size = UDim2.new(1, -40, 1, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 10, Font = Enum.Font.GothamMedium, TextXAlignment = "Left"}) }); table.insert(DeusUI.Elements, {Instance = T.TextLabel, Type = "TextColor"})
            local S = DeusUI:Create("TextButton", { Parent = T, Size = UDim2.new(0, 28, 0, 14), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = state and theme.Success or theme.Outline, Text = "" }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local Cir = DeusUI:Create("Frame", { Parent = S, Size = UDim2.new(0, 10, 0, 10), Position = state and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), AnchorPoint = state and Vector2.new(1, 0.5) or Vector2.new(0, 0.5), BackgroundColor3 = Color3.new(1,1,1) }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local d = {Instance = S, Type = "ToggleSwitch", Toggled = state}; table.insert(DeusUI.Elements, d)
            S.MouseButton1Click:Connect(function() state = not state; d.Toggled = state; DeusUI:Tween(Cir, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), AnchorPoint = state and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)}); DeusUI:Tween(S, TweenInfo.new(0.2), {BackgroundColor3 = state and DeusUI.Themes[DeusUI.CurrentTheme].Success or DeusUI.Themes[DeusUI.CurrentTheme].Outline}); c.Callback(state) end)
        end
        function TabMethods:Slider(c)
            local min, max, val = c.Min or 0, c.Max or 100, c.Default or 50; local current = DeusUI.Themes[DeusUI.CurrentTheme]
            local F = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 35), BackgroundTransparency = 1 }, { DeusUI:Create("TextLabel", {Text = c.Title, Size = UDim2.new(0.7, 0, 0, 14), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 10, Font = Enum.Font.GothamMedium, TextXAlignment = "Left"}), DeusUI:Create("TextLabel", {Name = "V", Text = tostring(val), Size = UDim2.new(0.3, 0, 0, 14), Position = UDim2.new(0.7, 0, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Accent, TextSize = 10, Font = Enum.Font.GothamBold, TextXAlignment = "Right"}) })
            local Bar = DeusUI:Create("Frame", {Parent = F, Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0, 22), BackgroundColor3 = theme.ChannelBG}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local Fill = DeusUI:Create("Frame", {Parent = Bar, Size = UDim2.new((val-min)/(max-min), 0, 1, 0), BackgroundColor3 = theme.Accent}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local dragging = false; local function update(input) local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1); val = math.floor(min + (max - min) * pos); F.V.Text = tostring(val); Fill.Size = UDim2.new(pos, 0, 1, 0); c.Callback(val) end
            Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(input) end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            table.insert(DeusUI.Elements, {Instance = F.TextLabel, Type = "TextColor"}); table.insert(DeusUI.Elements, {Instance = Bar, Type = "SecondaryBG"}); table.insert(DeusUI.Elements, {Instance = Fill, Type = "SliderFill"})
        end
        function TabMethods:Dropdown(c)
            local vals = c.Values or {}; local sel = c.Default or "Select..."; local open = false; local theme = DeusUI.Themes[DeusUI.CurrentTheme]
            local D = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = theme.ChannelBG, ClipsDescendants = true }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), DeusUI:Create("UIStroke", {Color = theme.Outline, Transparency = 0.6}) })
            local H = DeusUI:Create("TextButton", {Parent = D, Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Text = ""})
            local T = DeusUI:Create("TextLabel", {Text = c.Title or "Dropdown", Parent = H, Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 10, Font = Enum.Font.GothamMedium, TextXAlignment = "Left"})
            local S = DeusUI:Create("TextLabel", {Text = sel, Parent = H, Size = UDim2.new(0, 80, 1, 0), Position = UDim2.new(1, -25, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, TextSize = 9, Font = Enum.Font.Gotham, TextXAlignment = "Right"})
            local OH = DeusUI:Create("ScrollingFrame", {Parent = D, Size = UDim2.new(1, 0, 0, 80), Position = UDim2.new(0, 0, 0, 28), BackgroundTransparency = 1, ScrollBarThickness = 1, AutomaticCanvasSize = "Y", Visible = false}, { DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 1)}) })
            H.MouseButton1Click:Connect(function() open = not open; DeusUI:Tween(D, TweenInfo.new(0.2), {Size = open and UDim2.new(1, 0, 0, 110) or UDim2.new(1, 0, 0, 28)}); OH.Visible = open end)
            for _, v in pairs(vals) do local b = DeusUI:Create("TextButton", {Parent = OH, Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = v, TextColor3 = theme.TextSecondary, TextSize = 9, Font = Enum.Font.Gotham}) b.MouseButton1Click:Connect(function() sel = v; S.Text = v; open = false; D.Size = UDim2.new(1, 0, 0, 28); OH.Visible = false; c.Callback(v) end) end
            table.insert(DeusUI.Elements, {Instance = D, Type = "SecondaryBG"}); table.insert(DeusUI.Elements, {Instance = T, Type = "TextColor"})
        end
        function TabMethods:Paragraph(c)
            local theme = DeusUI.Themes[DeusUI.CurrentTheme]
            local P = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = "Y", BackgroundColor3 = theme.ChannelBG, BackgroundTransparency = 0.6 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}), DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 2)}), DeusUI:Create("TextLabel", {Text = c.Title, BackgroundTransparency = 1, TextColor3 = theme.Accent, TextSize = 10, Font = Enum.Font.GothamBold, AutomaticSize = "XY"}), DeusUI:Create("TextLabel", {Text = c.Desc, BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, TextSize = 9, Font = Enum.Font.Gotham, AutomaticSize = "Y", Size = UDim2.new(1, 0, 0, 0), TextWrapped = true, TextXAlignment = "Left"}) })
            table.insert(DeusUI.Elements, {Instance = P, Type = "SecondaryBG"})
        end
        function TabMethods:Keybind(c)
            local key = c.Default or Enum.KeyCode.F; local theme = DeusUI.Themes[DeusUI.CurrentTheme]
            local F = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1 }, { DeusUI:Create("TextLabel", {Text = c.Title, Size = UDim2.new(1, -60, 1, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 10, Font = Enum.Font.GothamMedium, TextXAlignment = "Left"}) })
            local B = DeusUI:Create("TextButton", { Parent = F, Size = UDim2.new(0, 50, 0, 18), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = theme.ChannelBG, Text = key.Name, TextColor3 = theme.Text, TextSize = 8, Font = Enum.Font.GothamBold }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), DeusUI:Create("UIStroke", {Color = theme.Outline, Transparency = 0.6}) })
            B.MouseButton1Click:Connect(function() B.Text = "..."; local conn; conn = UserInputService.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Keyboard then key = input.KeyCode; B.Text = key.Name; conn:Disconnect(); c.Callback(key) end end) end)
            table.insert(DeusUI.Elements, {Instance = F.TextLabel, Type = "TextColor"}); table.insert(DeusUI.Elements, {Instance = B, Type = "SecondaryBG"})
        end

        return TabMethods
    end
    
    function WindowMethods:Settings() 
        self:SidebarSection("Config")
        local S = self:Tab({Title = "Settings", Icon = "settings"})
        local TNames = {}; for n, _ in pairs(DeusUI.Themes) do table.insert(TNames, n) end
        S:Dropdown({ Title = "Themes", Values = TNames, Default = DeusUI.CurrentTheme, Callback = function(t) DeusUI.CurrentTheme = t; DeusUI:UpdateUI() end })
        S:Button({ Title = "Unload UI", Callback = function() ScreenGui:Destroy() end })
        return S 
    end
    
    function DeusUI:CreateToggle(c)
        local theme = self.Themes[self.CurrentTheme]
        local B = self:Create("TextButton", { Parent = ScreenGui, Size = c.Size or UDim2.new(0, 34, 0, 34), Position = c.Position or UDim2.new(0, 10, 0, 10), BackgroundColor3 = theme.Accent, Text = "" }, { self:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), self:Create("UIStroke", {Color = Color3.new(1,1,1), Transparency = 0.5, Thickness = 1.5}), self:Create("ImageLabel", {Size = UDim2.new(0.6, 0, 0.6, 0), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Image = self:GetIcon(c.Icon or "at-sign")}) })
        local open = true; B.MouseButton1Click:Connect(function() open = not open; MainFrame.Visible = open; if open then self:Tween(MainFrame, TweenInfo.new(0.25), {GroupTransparency = 0}) else MainFrame.GroupTransparency = 1 end end)
        local drag, dStart, sPos; B.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; dStart = i.Position; sPos = B.Position end end)
        UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - dStart; B.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y) end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
        return B
    end
    
    return WindowMethods
end

return DeusUI

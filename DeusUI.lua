--[[ 
    Deus Evolution UI | Version 1.2.0 (Ultimate Customization)
    Created by: Deus Mode (Gemini CLI)
    Style: Full Dynamic Glassmorphism
]]

local DeusUI = {
    Themes = {
        Dark = {
            Main = Color3.fromRGB(15, 15, 15),
            Secondary = Color3.fromRGB(25, 25, 25),
            Accent = Color3.fromRGB(0, 162, 255),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(160, 160, 160),
            Outline = Color3.fromRGB(255, 255, 255)
        },
        Light = {
            Main = Color3.fromRGB(245, 245, 245),
            Secondary = Color3.fromRGB(225, 225, 225),
            Accent = Color3.fromRGB(0, 120, 215),
            Text = Color3.fromRGB(20, 20, 20),
            TextSecondary = Color3.fromRGB(60, 60, 60),
            Outline = Color3.fromRGB(0, 0, 0)
        },
        Purple = {
            Main = Color3.fromRGB(25, 10, 45), Secondary = Color3.fromRGB(35, 15, 60),
            Accent = Color3.fromRGB(180, 80, 255), Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(200, 180, 220), Outline = Color3.fromRGB(255, 255, 255)
        },
        Blue = {
            Main = Color3.fromRGB(10, 25, 45), Secondary = Color3.fromRGB(15, 35, 60),
            Accent = Color3.fromRGB(80, 180, 255), Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(180, 200, 220), Outline = Color3.fromRGB(255, 255, 255)
        },
        Green = {
            Main = Color3.fromRGB(10, 35, 20), Secondary = Color3.fromRGB(15, 45, 30),
            Accent = Color3.fromRGB(80, 255, 150), Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(180, 220, 200), Outline = Color3.fromRGB(255, 255, 255)
        },
        Custom = { -- الثيم المخصص
            Main = Color3.fromRGB(30, 30, 30), Secondary = Color3.fromRGB(40, 40, 40),
            Accent = Color3.fromRGB(0, 162, 255), Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(160, 160, 160), Outline = Color3.fromRGB(255, 255, 255)
        }
    },
    CurrentTheme = "Dark",
    Elements = {} -- لتخزين كافة العناصر وتحديثها حياً
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Utilities
function DeusUI:Create(className, properties, children)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do instance[property] = value end
    if children then for _, child in pairs(children) do child.Parent = instance end end
    return instance
end

function DeusUI:Tween(instance, info, propertyTable)
    local tween = TweenService:Create(instance, info, propertyTable)
    tween:Play()
    return tween
end

-- Notification System
local NotifyGui = DeusUI:Create("ScreenGui", { Name = "DeusNotifications", Parent = (gethui and gethui()) or CoreGui })
local NotifyHolder = DeusUI:Create("Frame", { Name = "Holder", Parent = NotifyGui, Size = UDim2.new(0, 250, 1, 0), Position = UDim2.new(1, -260, 0, 0), BackgroundTransparency = 1 }, { DeusUI:Create("UIListLayout", {VerticalAlignment = "Bottom", Padding = UDim.new(0, 10)}) })

function DeusUI:Notify(config)
    local theme = self.Themes[self.CurrentTheme]
    local Toast = self:Create("Frame", { Name = "Toast", Parent = NotifyHolder, Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = theme.Main, BackgroundTransparency = 0.2, Position = UDim2.new(1, 0, 0, 0) }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Create("UIStroke", {Color = theme.Outline, Transparency = 0.8}),
        self:Create("TextLabel", { Text = config.Content or "Notification", Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 13, Font = Enum.Font.GothamMedium, TextWrapped = true })
    })
    self:Tween(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)})
    task.delay(config.Duration or 3, function()
        self:Tween(Toast, TweenInfo.new(0.4), {Position = UDim2.new(1.5, 0, 0, 0), BackgroundTransparency = 1})
        task.wait(0.4); Toast:Destroy()
    end)
end

-- Main Window
function DeusUI:CreateWindow(config)
    local theme = self.Themes[self.CurrentTheme]
    local ScreenGui = self:Create("ScreenGui", { Name = "DeusEvolutionUI", Parent = (gethui and gethui()) or CoreGui, ResetOnSpawn = false })
    local MainFrame = self:Create("Frame", { Name = "MainFrame", Parent = ScreenGui, BackgroundColor3 = theme.Main, Position = UDim2.new(0.5, -275, 0.5, -175), Size = UDim2.new(0, 550, 0, 350), ClipsDescendants = true }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        self:Create("UIStroke", {Color = theme.Outline, Transparency = 0.85, Thickness = 1.2})
    })
    
    local Topbar = self:Create("Frame", { Name = "Topbar", Parent = MainFrame, Size = UDim2.new(1, 0, 0, 45), BackgroundTransparency = 1 }, {
        self:Create("TextLabel", { Name = "Title", Text = config.Title or "Deus Evolution", Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 16, Font = Enum.Font.GothamBold, TextXAlignment = "Left" }),
        self:Create("Frame", { Name = "Separator", Size = UDim2.new(1, -30, 0, 1), Position = UDim2.new(0, 15, 1, 0), BackgroundColor3 = theme.Outline, BackgroundTransparency = 0.9, BorderSizePixel = 0 })
    })
    
    local Controls = self:Create("Frame", { Name = "Controls", Parent = Topbar, Size = UDim2.new(0, 70, 1, 0), Position = UDim2.new(1, -80, 0, 0), BackgroundTransparency = 1 }, { self:Create("UIListLayout", {FillDirection = "Horizontal", Padding = UDim.new(0, 8), VerticalAlignment = "Center", HorizontalAlignment = "Right"}) })
    local MinBtn = self:Create("TextButton", { Name = "Min", Parent = Controls, Size = UDim2.new(0, 26, 0, 26), BackgroundColor3 = theme.Secondary, Text = "-", TextColor3 = theme.Text, TextSize = 18, Font = Enum.Font.GothamBold }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), self:Create("UIStroke", {Color = theme.Outline, Transparency = 0.8}) })
    local CloseBtn = self:Create("TextButton", { Name = "Close", Parent = Controls, Size = UDim2.new(0, 26, 0, 26), BackgroundColor3 = Color3.fromRGB(180, 40, 40), Text = "×", TextColor3 = Color3.new(1, 1, 1), TextSize = 18, Font = Enum.Font.GothamBold }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 6)}) })

    local Sidebar = self:Create("Frame", { Name = "Sidebar", Parent = MainFrame, Size = UDim2.new(0, 160, 1, -95), Position = UDim2.new(0, 10, 0, 55), BackgroundColor3 = theme.Secondary, BackgroundTransparency = 0.4 }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), self:Create("UIStroke", {Color = theme.Outline, Transparency = 0.9}) })
    local TabContainer = self:Create("ScrollingFrame", { Name = "TabScroll", Parent = Sidebar, Size = UDim2.new(1, -10, 1, -10), Position = UDim2.new(0, 5, 0, 5), BackgroundTransparency = 1, ScrollBarThickness = 0, AutomaticCanvasSize = "Y" }, { self:Create("UIListLayout", {Padding = UDim.new(0, 5), HorizontalAlignment = "Center"}) })
    local PageContainer = self:Create("Frame", { Name = "PageContainer", Parent = MainFrame, Size = UDim2.new(1, -190, 1, -95), Position = UDim2.new(0, 180, 0, 55), BackgroundTransparency = 1 })
    local StatusBar = self:Create("Frame", { Name = "StatusBar", Parent = MainFrame, Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 1, -30), BackgroundTransparency = 1 }, {
        self:Create("TextLabel", { Name = "PerfText", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "FPS: 60 | Ping: 0ms", TextColor3 = theme.TextSecondary, TextSize = 11, Font = Enum.Font.GothamMedium, TextXAlignment = "Right" })
    })

    -- Live UI Updating System
    local function updateGlobalStyles()
        local current = DeusUI.Themes[DeusUI.CurrentTheme]
        DeusUI:Tween(MainFrame, TweenInfo.new(0.3), {BackgroundColor3 = current.Main})
        DeusUI:Tween(Sidebar, TweenInfo.new(0.3), {BackgroundColor3 = current.Secondary})
        Topbar.Title.TextColor3 = current.Text
        Topbar.Separator.BackgroundColor3 = current.Outline
        StatusBar.PerfText.TextColor3 = current.TextSecondary
        MinBtn.BackgroundColor3 = current.Secondary
        MinBtn.TextColor3 = current.Text
        
        for _, el in pairs(DeusUI.Elements) do
            if el.Type == "TabBtn" then
                if el.Selected then el.Instance.BackgroundColor3 = current.Accent else el.Instance.BackgroundColor3 = current.Main end
                el.Instance.TextColor3 = current.Text
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

    -- Dragging Logic
    local dragging, dragStart, startPos
    Topbar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = MainFrame.Position end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

    local Window = {}
    function Window:Tab(tabConfig)
        local tabTitle = tabConfig.Title or "Tab"
        local Page = DeusUI:Create("ScrollingFrame", { Name = tabTitle .. "Page", Parent = PageContainer, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = theme.Accent, AutomaticCanvasSize = "Y" }, { DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 8), HorizontalAlignment = "Center"}) })
        local TabBtn = DeusUI:Create("TextButton", { Name = tabTitle .. "Btn", Parent = TabContainer, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = theme.Main, Text = tabTitle, TextColor3 = theme.TextSecondary, TextSize = 14, Font = Enum.Font.GothamMedium, AutoButtonColor = false }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}) })
        
        local tabObj = {Type = "TabBtn", Instance = TabBtn, Selected = false}
        table.insert(DeusUI.Elements, tabObj)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(PageContainer:GetChildren()) do p.Visible = false end
            for _, el in pairs(DeusUI.Elements) do if el.Type == "TabBtn" then el.Selected = false; el.Instance.BackgroundColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Main; el.Instance.TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].TextSecondary end end
            Page.Visible = true; tabObj.Selected = true; TabBtn.BackgroundColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent; TabBtn.TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Text
        end)

        if not DeusUI.SelectedTab then DeusUI.SelectedTab = true; Page.Visible = true; tabObj.Selected = true; TabBtn.BackgroundColor3 = theme.Accent; TabBtn.TextColor3 = theme.Text end

        local Tab = {}
        function Tab:Button(btnConfig)
            local ButtonFrame = DeusUI:Create("Frame", { Name = "ButtonFrame", Parent = Page, Size = UDim2.new(0.95, 0, 0, 40), BackgroundColor3 = theme.Secondary, BackgroundTransparency = 0.3 }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("UIStroke", {Color = theme.Outline, Transparency = 0.85, Thickness = 1.2}),
                DeusUI:Create("TextButton", {Name = "Btn", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = btnConfig.Title or "Button", TextColor3 = theme.Text, TextSize = 14, Font = Enum.Font.GothamBold})
            })
            ButtonFrame.Btn.MouseButton1Click:Connect(function() btnConfig.Callback() end)
            table.insert(DeusUI.Elements, {Type = "Button", Instance = ButtonFrame})
        end

        function Tab:Toggle(tConfig)
            local toggled = tConfig.Default or false
            local ToggleFrame = DeusUI:Create("Frame", { Name = "ToggleFrame", Parent = Page, Size = UDim2.new(0.95, 0, 0, 45), BackgroundColor3 = theme.Secondary, BackgroundTransparency = 0.4 }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("UIStroke", {Color = theme.Outline, Transparency = 0.9}),
                DeusUI:Create("UIPadding", {PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15)}),
                DeusUI:Create("TextLabel", {Name = "T", Text = tConfig.Title or "Toggle", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 14, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -60, 1, 0), TextXAlignment = "Left"})
            })
            local Switch = DeusUI:Create("TextButton", { Parent = ToggleFrame, Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = toggled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50), Text = "" }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local Circle = DeusUI:Create("Frame", { Parent = Switch, Size = UDim2.new(0, 16, 0, 16), Position = toggled and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), AnchorPoint = toggled and Vector2.new(1, 0.5) or Vector2.new(0, 0.5), BackgroundColor3 = Color3.new(1, 1, 1) }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            Switch.MouseButton1Click:Connect(function() toggled = not toggled; DeusUI:Tween(Circle, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), AnchorPoint = toggled and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)}); DeusUI:Tween(Switch, TweenInfo.new(0.2), {BackgroundColor3 = toggled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)}); tConfig.Callback(toggled) end)
            table.insert(DeusUI.Elements, {Type = "Text", Instance = ToggleFrame.T})
        end

        function Tab:Slider(sConfig)
            local min, max, val = sConfig.Min or 0, sConfig.Max or 100, sConfig.Default or 50
            local SliderFrame = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(0.95, 0, 0, 65), BackgroundColor3 = theme.Secondary, BackgroundTransparency = 0.4 }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15)}),
                DeusUI:Create("TextLabel", {Name = "T", Text = sConfig.Title or "Slider", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 14, Font = Enum.Font.GothamMedium, Size = UDim2.new(0.7, 0, 0, 20), TextXAlignment = "Left"}),
                DeusUI:Create("TextLabel", {Name = "Val", Text = tostring(val), BackgroundTransparency = 1, TextColor3 = theme.Accent, TextSize = 14, Font = Enum.Font.GothamBold, Size = UDim2.new(0.3, 0, 0, 20), Position = UDim2.new(0.7, 0, 0, 0), TextXAlignment = "Right"})
            })
            local Bar = DeusUI:Create("Frame", {Parent = SliderFrame, Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0, 40), BackgroundColor3 = theme.Main, BackgroundTransparency = 0.6}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local Fill = DeusUI:Create("Frame", {Parent = Bar, Size = UDim2.new((val-min)/(max-min), 0, 1, 0), BackgroundColor3 = theme.Accent}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local Knob = DeusUI:Create("Frame", {Parent = Fill, Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1, 1, 1)}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), DeusUI:Create("UIStroke", {Color = theme.Accent, Thickness = 2}) })
            local dragging = false
            local function update(input) local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1); val = math.floor(min + (max-min)*pos); SliderFrame.Val.Text = tostring(val); Fill.Size = UDim2.new(pos, 0, 1, 0); sConfig.Callback(val) end
            Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; update(input) end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
            table.insert(DeusUI.Elements, {Type = "Text", Instance = SliderFrame.T}); table.insert(DeusUI.Elements, {Type = "AccentText", Instance = SliderFrame.Val})
        end

        function Tab:Paragraph(pConfig)
            local ParaFrame = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(0.95, 0, 0, 0), AutomaticSize = "Y", BackgroundColor3 = theme.Secondary, BackgroundTransparency = 0.6 }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)}),
                DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 4)}),
                DeusUI:Create("TextLabel", {Name = "T", Text = pConfig.Title or "Info", BackgroundTransparency = 1, TextColor3 = theme.Accent, Font = Enum.Font.GothamBold, TextSize = 14, AutomaticSize = "XY"}),
                DeusUI:Create("TextLabel", {Name = "D", Text = pConfig.Desc or "", BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, Font = Enum.Font.Gotham, TextSize = 13, AutomaticSize = "Y", Size = UDim2.new(1, 0, 0, 0), TextWrapped = true, TextXAlignment = "Left"})
            })
            table.insert(DeusUI.Elements, {Type = "AccentText", Instance = ParaFrame.T}); table.insert(DeusUI.Elements, {Type = "Text", Instance = ParaFrame.D})
        end

        return Tab
    end

    function Window:Settings()
        local SettingsTab = Window:Tab({Title = "Settings"})
        SettingsTab:Dropdown({ Title = "UI Theme", Values = {"Dark", "Light", "Purple", "Blue", "Green", "Custom"}, Default = "Dark", Callback = function(t) DeusUI.CurrentTheme = t; updateGlobalStyles() end })
        SettingsTab:Slider({ Title = "Transparency", Min = 0, Max = 95, Default = 0, Callback = function(v) MainFrame.BackgroundTransparency = v/100; Sidebar.BackgroundTransparency = (v/100)+0.3 end })
        
        -- Customization Section
        SettingsTab:Paragraph({ Title = "Customization", Desc = "Modify the 'Custom' theme colors below." })
        SettingsTab:Button({ Title = "Set Custom Accent Color (Random)", Callback = function() DeusUI.Themes.Custom.Accent = Color3.fromHSV(math.random(), 1, 1); updateGlobalStyles(); DeusUI:Notify({Content = "Custom Accent Updated!"}) end })
        SettingsTab:Button({ Title = "Destroy Interface", Callback = function() ScreenGui:Destroy() end })
    end

    return Window
end

return DeusUI
--[[
    Deus Evolution UI | Version 1.3.3 (NEXT-GEN CONTENT LAYOUT)
    Created by: Deus Mode (Gemini CLI)
    Style: Micro-Card Grid | Neon Interaction | Ultra-Modern
]]

local DeusUI = {
    Themes = {
        Dark = {
            Main = Color3.fromRGB(15, 15, 20),
            Secondary = Color3.fromRGB(25, 25, 35),
            Outline = Color3.fromRGB(50, 50, 70),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(160, 160, 180),
            Accent = Color3.fromRGB(0, 180, 255)
        },
        Light = {
            Main = Color3.fromRGB(245, 245, 250),
            Secondary = Color3.fromRGB(230, 230, 240),
            Outline = Color3.fromRGB(200, 200, 220),
            Text = Color3.fromRGB(40, 40, 50),
            TextSecondary = Color3.fromRGB(120, 120, 140),
            Accent = Color3.fromRGB(0, 120, 255)
        },
        Purple = {
            Main = Color3.fromRGB(25, 15, 35),
            Secondary = Color3.fromRGB(40, 25, 60),
            Outline = Color3.fromRGB(80, 50, 120),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(180, 160, 220),
            Accent = Color3.fromRGB(180, 80, 255)
        },
        Custom = {
            Main = Color3.fromRGB(15, 15, 20),
            Secondary = Color3.fromRGB(25, 25, 35),
            Outline = Color3.fromRGB(50, 50, 70),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(160, 160, 180),
            Accent = Color3.fromRGB(0, 180, 255)
        }
    },
    Icons = {
        ["home"] = "rbxassetid://10734950309",
        ["settings"] = "rbxassetid://10734950056",
        ["fire"] = "rbxassetid://10723343321",
        ["eye"] = "rbxassetid://10723346959",
        ["crown"] = "rbxassetid://10734951157",
        ["swords"] = "rbxassetid://10723343321",
        ["layout"] = "rbxassetid://10734951038"
    },
    CurrentTheme = "Dark",
    Elements = {},
    SelectedTab = nil,
    ScreenGui = nil
}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer

function DeusUI:Create(className, properties, children)
    local inst = Instance.new(className)
    if properties then
        for prop, value in pairs(properties) do
            if type(value) == "boolean" or type(value) == "number" or type(value) == "string" or typeof(value) == "EnumItem" then
                inst[prop] = value
            elseif typeof(value) == "Color3" or typeof(value) == "UDim2" or typeof(value) == "UDim" or typeof(value) == "Vector2" or typeof(value) == "Vector3" then
                inst[prop] = value
            else
                pcall(function() inst[prop] = value end)
            end
        end
    end
    if children then
        for _, child in pairs(children) do
            if child and typeof(child) == "Instance" then child.Parent = inst end
        end
    end
    return inst
end

function DeusUI:Tween(instance, info, propertyTable)
    if not instance then return end
    local tween = TweenService:Create(instance, info, propertyTable)
    tween:Play()
    return tween
end

function DeusUI:GetIcon(name)
    if not name then return nil end
    if name:find("rbxassetid://") then return name end
    local cleanName = name:gsub(".*:", "")
    return self.Icons[cleanName] or self.Icons["home"]
end

function DeusUI:Notify(config)
    local theme = self.Themes[self.CurrentTheme]
    if not self.NotifyGui then
        self.NotifyGui = self:Create("ScreenGui", { Name = "DeusNotifications", Parent = (gethui and gethui()) or CoreGui })
        self.NotifyHolder = self:Create("Frame", { Name = "Holder", Parent = self.NotifyGui, Size = UDim2.new(0, 220, 1, 0), Position = UDim2.new(1, -230, 0, 0), BackgroundTransparency = 1 }, { self:Create("UIListLayout", {VerticalAlignment = "Bottom", Padding = UDim.new(0, 8)}) })
    end
    local Toast = self:Create("Frame", { Name = "Toast", Parent = self.NotifyHolder, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = theme.Main, BackgroundTransparency = 0.1 }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        self:Create("UIStroke", {Color = theme.Accent, Transparency = 0.5, Thickness = 1.2}),
        self:Create("TextLabel", { Text = config.Content or "Notification", Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 12, Font = Enum.Font.GothamMedium, TextWrapped = true })
    })
    Toast.Position = UDim2.new(1.5, 0, 0, 0)
    self:Tween(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)})
    task.delay(config.Duration or 3, function() if Toast then self:Tween(Toast, TweenInfo.new(0.4), {Position = UDim2.new(1.5, 0, 0, 0), BackgroundTransparency = 1}); task.wait(0.4); Toast:Destroy() end end)
end

function DeusUI:CreateWindow(config)
    local theme = self.Themes[self.CurrentTheme]
    local ScreenGui = self:Create("ScreenGui", { Name = "DeusEvolutionUI", Parent = (gethui and gethui()) or CoreGui, ResetOnSpawn = false })
    self.ScreenGui = ScreenGui
    
    local WindowSize = UDim2.new(0, 420, 0, 280)
    local MainFrame = self:Create("Frame", { Name = "MainFrame", Parent = ScreenGui, BackgroundColor3 = theme.Main, Position = UDim2.new(0.5, -210, 0.5, -140), Size = WindowSize, ClipsDescendants = true, ZIndex = 1 }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 22)}),
        self:Create("UIStroke", {Color = theme.Outline, Transparency = 0.5, Thickness = 2})
    })
    
    local Topbar = self:Create("Frame", { Name = "Topbar", Parent = MainFrame, Size = UDim2.new(1, 0, 0, 45), BackgroundTransparency = 1, ZIndex = 3 })
    self:Create("TextLabel", { Name = "Title", Parent = Topbar, Text = config.Title or "DEUS EVO", Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 20, 0, 5), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 15, Font = Enum.Font.GothamBold, TextXAlignment = "Left", ZIndex = 4 })
    
    local Controls = self:Create("Frame", { Name = "Controls", Parent = Topbar, Size = UDim2.new(0, 60, 0, 30), Position = UDim2.new(1, -15, 0, 10), BackgroundTransparency = 1, ZIndex = 100 }, { self:Create("UIListLayout", {FillDirection = "Horizontal", Padding = UDim.new(0, 8), VerticalAlignment = "Center", HorizontalAlignment = "Right"}) })
    local MinBtn = self:Create("TextButton", { Name = "Min", Parent = Controls, Size = UDim2.new(0, 22, 0, 22), BackgroundColor3 = theme.Secondary, Text = "−", TextColor3 = theme.Text, TextSize = 14, Font = Enum.Font.GothamBold, ZIndex = 101 }, { self:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
    local CloseBtn = self:Create("TextButton", { Name = "Close", Parent = Controls, Size = UDim2.new(0, 22, 0, 22), BackgroundColor3 = Color3.fromRGB(220, 60, 60), Text = "×", TextColor3 = Color3.new(1, 1, 1), TextSize = 16, Font = Enum.Font.GothamBold, ZIndex = 101 }, { self:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })

    local Sidebar = self:Create("Frame", { Name = "Sidebar", Parent = MainFrame, Size = UDim2.new(0, 130, 1, -70), Position = UDim2.new(0, 12, 0, 55), BackgroundColor3 = theme.Secondary, BackgroundTransparency = 0.4, ZIndex = 2 }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 18)}), self:Create("UIStroke", {Color = theme.Outline, Transparency = 0.8}) })
    local TabContainer = self:Create("ScrollingFrame", { Name = "TabScroll", Parent = Sidebar, Size = UDim2.new(1, -10, 1, -15), Position = UDim2.new(0, 5, 0, 10), BackgroundTransparency = 1, ScrollBarThickness = 0, AutomaticCanvasSize = "Y", ZIndex = 3 }, { self:Create("UIListLayout", {Padding = UDim.new(0, 5), HorizontalAlignment = "Center"}) })
    local PageContainer = self:Create("Frame", { Name = "PageContainer", Parent = MainFrame, Size = UDim2.new(1, -165, 1, -70), Position = UDim2.new(0, 153, 0, 55), BackgroundTransparency = 1, ZIndex = 2 })

    local function updateGlobalStyles()
        local current = DeusUI.Themes[DeusUI.CurrentTheme]
        DeusUI:Tween(MainFrame, TweenInfo.new(0.3), {BackgroundColor3 = current.Main})
        DeusUI:Tween(Sidebar, TweenInfo.new(0.3), {BackgroundColor3 = current.Secondary})
        MinBtn.BackgroundColor3 = current.Secondary; MinBtn.TextColor3 = current.Text
        for _, el in pairs(DeusUI.Elements) do
            if el.Type == "TabBtn" then 
                local targetColor = el.Selected and current.Accent or current.Main
                local textTarget = el.Selected and current.Text or current.TextSecondary
                DeusUI:Tween(el.Instance, TweenInfo.new(0.3), {BackgroundColor3 = targetColor})
                DeusUI:Tween(el.Instance.Content.Label, TweenInfo.new(0.3), {TextColor3 = textTarget})
                if el.Instance.Content:FindFirstChild("Icon") then DeusUI:Tween(el.Instance.Content.Icon, TweenInfo.new(0.3), {ImageColor3 = textTarget}) end
                if el.Instance:FindFirstChild("Indicator") then DeusUI:Tween(el.Instance.Indicator, TweenInfo.new(0.3), {BackgroundTransparency = el.Selected and 0 or 1}) end
            elseif el.Type == "ElementCard" then
                el.Instance.BackgroundColor3 = current.Secondary
                if el.Instance:FindFirstChild("T") then el.Instance.T.TextColor3 = current.Text end
            end
        end
    end

    MinBtn.MouseButton1Click:Connect(function()
        local minimized = MainFrame.Size.Y.Offset < 60
        local target = minimized and WindowSize or UDim2.new(0, 420, 0, 50)
        DeusUI:Tween(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = target})
        Sidebar.Visible = target.Y.Offset > 60; PageContainer.Visible = target.Y.Offset > 60
    end)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local dragging, dragStart, startPos
    Topbar.InputBegan:Connect(function(input) 
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) 
        end 
    end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

    local Window = {}
    function Window:Tab(tabConfig)
        local tabTitle = tabConfig.Title or "Tab"; local tabIcon = DeusUI:GetIcon(tabConfig.Icon)
        local Page = DeusUI:Create("ScrollingFrame", { Name = tabTitle .. "Page", Parent = PageContainer, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 0, AutomaticCanvasSize = "Y", ZIndex = 3 }, { DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 8), HorizontalAlignment = "Center"}) })
        
        local TabBtn = DeusUI:Create("TextButton", { Name = tabTitle .. "Btn", Parent = TabContainer, Size = UDim2.new(1, -10, 0, 32), BackgroundColor3 = theme.Main, Text = "", AutoButtonColor = false, ZIndex = 4 }, { 
            DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            DeusUI:Create("Frame", { Name = "Indicator", Size = UDim2.new(0, 3, 0, 16), Position = UDim2.new(0, 4, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = theme.Accent, BackgroundTransparency = 1, ZIndex = 5 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) }),
            DeusUI:Create("Frame", { Name = "Content", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 5 }, {
                DeusUI:Create("UIListLayout", { FillDirection = "Horizontal", VerticalAlignment = "Center", Padding = UDim.new(0, 8), HorizontalAlignment = "Center" }),
                tabIcon and DeusUI:Create("ImageLabel", { Name = "Icon", Size = UDim2.new(0, 16, 0, 16), BackgroundTransparency = 1, Image = tabIcon, ImageColor3 = theme.TextSecondary, ZIndex = 6 }) or nil,
                DeusUI:Create("TextLabel", { Name = "Label", Text = tabTitle, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = "X", BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, TextSize = 13, Font = Enum.Font.GothamMedium, ZIndex = 6 })
            })
        })

        local tabObj = {Type = "TabBtn", Instance = TabBtn, Selected = false}; table.insert(DeusUI.Elements, tabObj)
        local function SetTabState(state)
            local current = DeusUI.Themes[DeusUI.CurrentTheme]
            tabObj.Selected = state
            DeusUI:Tween(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = state and current.Accent or current.Main})
            DeusUI:Tween(TabBtn.Content.Label, TweenInfo.new(0.3), {TextColor3 = state and current.Text or current.TextSecondary})
            if TabBtn.Content:FindFirstChild("Icon") then DeusUI:Tween(TabBtn.Content.Icon, TweenInfo.new(0.3), {ImageColor3 = state and current.Text or current.TextSecondary}) end
            DeusUI:Tween(TabBtn.Indicator, TweenInfo.new(0.3), {BackgroundTransparency = state and 0 or 1})
        end

        TabBtn.MouseButton1Click:Connect(function() 
            for _, p in pairs(PageContainer:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
            for _, el in pairs(DeusUI.Elements) do if el.Type == "TabBtn" then SetTabState(false); el.Selected = false end end
            Page.Visible = true; SetTabState(true)
        end)
        if not DeusUI.SelectedTab then DeusUI.SelectedTab = true; Page.Visible = true; SetTabState(true) end
        
        local Tab = {}
        
        -- Helper for Micro-Card
        local function CreateCard(title, size)
            local current = DeusUI.Themes[DeusUI.CurrentTheme]
            local Card = DeusUI:Create("Frame", { Parent = Page, Size = size or UDim2.new(0.96, 0, 0, 45), BackgroundColor3 = current.Secondary, BackgroundTransparency = 0.5, ZIndex = 4 }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
                DeusUI:Create("UIStroke", {Color = current.Outline, Transparency = 0.8, Thickness = 1.2}),
                DeusUI:Create("TextLabel", { Name = "T", Text = title, Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, TextColor3 = current.Text, TextSize = 13, Font = Enum.Font.GothamMedium, TextXAlignment = "Left", ZIndex = 5 })
            })
            Card.MouseEnter:Connect(function() DeusUI:Tween(Card, TweenInfo.new(0.3), {BackgroundTransparency = 0.2, Size = Card.Size + UDim2.new(0.02, 0, 0, 2)}) end)
            Card.MouseLeave:Connect(function() DeusUI:Tween(Card, TweenInfo.new(0.3), {BackgroundTransparency = 0.5, Size = size or UDim2.new(0.96, 0, 0, 45)}) end)
            table.insert(DeusUI.Elements, {Type = "ElementCard", Instance = Card})
            return Card
        end

        function Tab:Section(title)
            DeusUI:Create("TextLabel", { Parent = Page, Text = title:upper(), Size = UDim2.new(0.9, 0, 0, 25), BackgroundTransparency = 1, TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent, TextSize = 11, Font = Enum.Font.GothamBold, TextXAlignment = "Left", ZIndex = 5 })
        end

        function Tab:Button(bConfig)
            local Card = CreateCard(bConfig.Title or "Button")
            local Btn = DeusUI:Create("TextButton", { Parent = Card, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 6 })
            local Icon = DeusUI:Create("ImageLabel", { Parent = Card, Image = "rbxassetid://10734950832", Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -35, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, ImageColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent, ZIndex = 6 })
            Btn.MouseButton1Click:Connect(function() 
                DeusUI:Tween(Card, TweenInfo.new(0.1, Enum.EasingStyle.Back), {Size = Card.Size - UDim2.new(0.02, 0, 0, 2)})
                task.wait(0.1)
                DeusUI:Tween(Card, TweenInfo.new(0.1, Enum.EasingStyle.Back), {Size = Card.Size + UDim2.new(0.02, 0, 0, 2)})
                bConfig.Callback() 
            end)
        end

        function Tab:Toggle(tConfig)
            local toggled = tConfig.Default or false
            local Card = CreateCard(tConfig.Title or "Toggle")
            local Switch = DeusUI:Create("TextButton", { Parent = Card, Size = UDim2.new(0, 36, 0, 18), Position = UDim2.new(1, -50, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = toggled and DeusUI.Themes[DeusUI.CurrentTheme].Accent or Color3.fromRGB(80, 80, 90), Text = "", ZIndex = 6 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local Circle = DeusUI:Create("Frame", { Parent = Switch, Size = UDim2.new(0, 14, 0, 14), Position = toggled and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), AnchorPoint = toggled and Vector2.new(1, 0.5) or Vector2.new(0, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 7 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            Switch.MouseButton1Click:Connect(function()
                toggled = not toggled
                DeusUI:Tween(Switch, TweenInfo.new(0.2), {BackgroundColor3 = toggled and DeusUI.Themes[DeusUI.CurrentTheme].Accent or Color3.fromRGB(80, 80, 90)})
                DeusUI:Tween(Circle, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), AnchorPoint = toggled and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)})
                tConfig.Callback(toggled)
            end)
        end

        function Tab:Slider(sConfig)
            local min, max, val = sConfig.Min or 0, sConfig.Max or 100, sConfig.Default or 50
            local Card = CreateCard(sConfig.Title or "Slider", UDim2.new(0.96, 0, 0, 60))
            local ValLbl = DeusUI:Create("TextLabel", { Parent = Card, Text = tostring(val), Size = UDim2.new(0.3, 0, 0, 20), Position = UDim2.new(0.7, -15, 0, 12), BackgroundTransparency = 1, TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = "Right", ZIndex = 5 })
            local Bar = DeusUI:Create("Frame", { Parent = Card, Size = UDim2.new(1, -30, 0, 4), Position = UDim2.new(0, 15, 0, 42), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.6, ZIndex = 6 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local Fill = DeusUI:Create("Frame", { Parent = Bar, Size = UDim2.new((val-min)/(max-min), 0, 1, 0), BackgroundColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent, ZIndex = 7 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local Knob = DeusUI:Create("Frame", { Parent = Fill, Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 8 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), DeusUI:Create("UIStroke", {Color = DeusUI.Themes[DeusUI.CurrentTheme].Accent, Thickness = 2}) })
            local dragging = false
            local function update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max-min)*pos); ValLbl.Text = tostring(val); Fill.Size = UDim2.new(pos, 0, 1, 0); sConfig.Callback(val)
            end
            Knob.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
        end

        function Tab:Dropdown(dConfig)
            local dValues = dConfig.Values or {}; local selected = dConfig.Default or "Select..."; local opened = false
            local Card = CreateCard(dConfig.Title or "Dropdown")
            local SelText = DeusUI:Create("TextLabel", { Parent = Card, Text = selected, Size = UDim2.new(0.5, -40, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), BackgroundTransparency = 1, TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = "Right", ZIndex = 6 })
            local OptionHolder = DeusUI:Create("ScrollingFrame", { Parent = Card, Size = UDim2.new(1, 0, 0, 100), Position = UDim2.new(0, 0, 0, 45), BackgroundTransparency = 0.1, BackgroundColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Main, ScrollBarThickness = 0, AutomaticCanvasSize = "Y", Visible = false, ZIndex = 15 }, { DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 4), HorizontalAlignment = "Center"}) })
            DeusUI:Create("UICorner", { Parent = OptionHolder, CornerRadius = UDim.new(0, 10) })
            Card.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    opened = not opened
                    DeusUI:Tween(Card, TweenInfo.new(0.3), {Size = opened and UDim2.new(0.96, 0, 0, 150) or UDim2.new(0.96, 0, 0, 45)})
                    OptionHolder.Visible = opened
                end
            end)
            for _, val in pairs(dValues) do
                local Opt = DeusUI:Create("TextButton", { Parent = OptionHolder, Size = UDim2.new(0.9, 0, 0, 28), BackgroundTransparency = 1, Text = val, TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].TextSecondary, Font = Enum.Font.Gotham, TextSize = 12, ZIndex = 16 })
                Opt.MouseButton1Click:Connect(function() selected = val; SelText.Text = val; opened = false; OptionHolder.Visible = false; DeusUI:Tween(Card, TweenInfo.new(0.3), {Size = UDim2.new(0.96, 0, 0, 45)}); dConfig.Callback(val) end)
            end
        end

        return Tab
    end

    function Window:Settings()
        local SettingsTab = Window:Tab({Title = "Settings", Icon = "settings"})
        SettingsTab:Section("Interface")
        SettingsTab:Dropdown({ Title = "Themes", Values = {"Dark", "Light", "Purple", "Custom"}, Default = DeusUI.CurrentTheme, Callback = function(t) DeusUI.CurrentTheme = t; updateGlobalStyles() end })
        SettingsTab:Slider({ Title = "Opacity", Min = 0, Max = 90, Default = 0, Callback = function(v) MainFrame.BackgroundTransparency = v/100; Sidebar.BackgroundTransparency = (v/100)+0.4 end })
        SettingsTab:Section("System")
        SettingsTab:Button({ Title = "Unload UI", Callback = function() ScreenGui:Destroy() end })
        return SettingsTab
    end

    task.spawn(function() while MainFrame.Parent do local fps = math.floor(workspace:GetRealPhysicsFPS()); StatusBar = StatusBar or {PerfText = {Text = ""}}; pcall(function() MainFrame.StatusBar.PerfText.Text = string.format("FPS: %d | v1.3.3", fps) end) task.wait(1) end end)
    return Window
end

return DeusUI

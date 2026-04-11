--[[
    Deus Evolution UI | Version 1.3.2 (DISCORD EDITION)
    Created by: Deus Mode (Gemini CLI)
    Style: Discord Client Aesthetic | Professional & Clean
]]

local DeusUI = {
    Themes = {
        Dark = {
            Main = Color3.fromRGB(49, 51, 56),        -- Discord Main BG
            Secondary = Color3.fromRGB(43, 45, 49),   -- Discord Sidebar
            ChannelBG = Color3.fromRGB(30, 31, 34),   -- Discord Channel List/Darker
            Outline = Color3.fromRGB(30, 31, 34),
            Text = Color3.fromRGB(242, 243, 245),     -- Discord White Text
            TextSecondary = Color3.fromRGB(181, 186, 193), -- Discord Muted Text
            Accent = Color3.fromRGB(88, 101, 242),    -- Discord Blurple
            Success = Color3.fromRGB(35, 165, 89),    -- Discord Green
            Danger = Color3.fromRGB(242, 63, 66)      -- Discord Red
        },
        Light = {
            Main = Color3.fromRGB(255, 255, 255),
            Secondary = Color3.fromRGB(242, 243, 245),
            ChannelBG = Color3.fromRGB(227, 229, 232),
            Outline = Color3.fromRGB(227, 229, 232),
            Text = Color3.fromRGB(6, 6, 7),
            TextSecondary = Color3.fromRGB(78, 80, 88),
            Accent = Color3.fromRGB(88, 101, 242),
            Success = Color3.fromRGB(35, 165, 89),
            Danger = Color3.fromRGB(242, 63, 66)
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
            if child and typeof(child) == "Instance" then
                child.Parent = inst
            end
        end
    end
    return inst
end

function DeusUI:GetIcon(name)
    if not name then return nil end
    if name:find("rbxassetid://") then return name end
    return self.Icons[name] or self.Icons["home"]
end

function DeusUI:Tween(instance, info, propertyTable)
    if not instance then return end
    local tween = TweenService:Create(instance, info, propertyTable)
    tween:Play()
    return tween
end

function DeusUI:Notify(config)
    local theme = self.Themes[self.CurrentTheme]
    if not self.NotifyGui then
        self.NotifyGui = self:Create("ScreenGui", { Name = "DeusNotifications", Parent = (gethui and gethui()) or CoreGui })
        self.NotifyHolder = self:Create("Frame", { Name = "Holder", Parent = self.NotifyGui, Size = UDim2.new(0, 280, 1, 0), Position = UDim2.new(1, -290, 0, 0), BackgroundTransparency = 1 }, { self:Create("UIListLayout", {VerticalAlignment = "Bottom", Padding = UDim.new(0, 10)}) })
    end
    local Toast = self:Create("Frame", { Name = "Toast", Parent = self.NotifyHolder, Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = theme.ChannelBG, BackgroundTransparency = 0.1 }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Create("UIStroke", {Color = theme.Accent, Transparency = 0.5, Thickness = 1.5}),
        self:Create("TextLabel", { Text = config.Content or "Notification", Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 13, Font = Enum.Font.GothamMedium, TextWrapped = true, TextXAlignment = "Left" })
    })
    Toast.Position = UDim2.new(1.5, 0, 0, 0)
    self:Tween(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
    task.delay(config.Duration or 3, function() if Toast then self:Tween(Toast, TweenInfo.new(0.4), {Position = UDim2.new(1.5, 0, 0, 0), BackgroundTransparency = 1}); task.wait(0.4); Toast:Destroy() end end)
end

function DeusUI:OpenColorPicker(defaultColor, callback)
    local theme = self.Themes[self.CurrentTheme]
    local h, s, v = Color3.toHSV(defaultColor)
    local selectedColor = defaultColor
    local PickerFrame = self:Create("Frame", { Name = "PickerFrame", Parent = self.ScreenGui, Size = UDim2.new(0, 240, 0, 300), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = theme.ChannelBG, Active = true, ZIndex = 3000 }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Create("UIStroke", {Color = theme.Outline, Thickness = 1.5})
    })
    local ClosePicker = self:Create("TextButton", { Name = "Close", Parent = PickerFrame, Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(1, -30, 0, 5), BackgroundTransparency = 1, Text = "×", TextColor3 = theme.TextSecondary, Font = Enum.Font.GothamBold, TextSize = 20, ZIndex = 3001 })
    ClosePicker.MouseButton1Click:Connect(function() PickerFrame:Destroy() end)
    
    local SatVibMap = self:Create("ImageLabel", { Name = "SatVibMap", Parent = PickerFrame, Size = UDim2.new(0, 160, 0, 160), Position = UDim2.new(0, 15, 0, 40), Image = "rbxassetid://4155801252", BackgroundColor3 = Color3.fromHSV(h, 1, 1), ZIndex = 3001 }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 4)}) })
    local MapKnob = self:Create("Frame", { Parent = SatVibMap, Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(s, 0, 1-v, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 3002 }, { self:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), self:Create("UIStroke", {Thickness = 2, Color = Color3.new(0,0,0)}) })
    
    local HueBar = self:Create("Frame", { Name = "HueBar", Parent = PickerFrame, Size = UDim2.new(0, 20, 0, 160), Position = UDim2.new(0, 190, 0, 40), ZIndex = 3001 }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 4)}) })
    self:Create("UIGradient", { Rotation = 90, Parent = HueBar, Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1,1)), ColorSequenceKeypoint.new(0.16, Color3.fromHSV(0.16,1,1)), ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33,1,1)), ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5,1,1)), ColorSequenceKeypoint.new(0.66, Color3.fromHSV(0.66,1,1)), ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83,1,1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(1,1,1))}) })
    local HueKnob = self:Create("Frame", { Parent = HueBar, Size = UDim2.new(1, 4, 0, 4), Position = UDim2.new(0.5, 0, h, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 3002 }, { self:Create("UIStroke", {Thickness = 1.5, Color = Color3.new(0,0,0)}) })
    
    local HexBox = self:Create("TextBox", { Parent = PickerFrame, Size = UDim2.new(1, -30, 0, 30), Position = UDim2.new(0, 15, 0, 215), BackgroundColor3 = theme.Secondary, Text = "#" .. selectedColor:ToHex(), TextColor3 = theme.Text, Font = Enum.Font.GothamMedium, TextSize = 12, ZIndex = 3001 }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 4)}) })
    
    local function update() 
        selectedColor = Color3.fromHSV(h, s, v)
        SatVibMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        HexBox.Text = "#" .. selectedColor:ToHex()
        MapKnob.Position = UDim2.new(s, 0, 1-v, 0)
        HueKnob.Position = UDim2.new(0.5, 0, h, 0)
    end
    
    local mapDragging = false
    SatVibMap.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then mapDragging = true end end)
    local hueDragging = false
    HueBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then hueDragging = true end end)
    UserInputService.InputChanged:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then if mapDragging then local pos = Vector2.new(input.Position.X - SatVibMap.AbsolutePosition.X, input.Position.Y - SatVibMap.AbsolutePosition.Y); s = math.clamp(pos.X / SatVibMap.AbsoluteSize.X, 0, 1); v = 1 - math.clamp(pos.Y / SatVibMap.AbsoluteSize.Y, 0, 1); update() elseif hueDragging then local pos = input.Position.Y - HueBar.AbsolutePosition.Y; h = math.clamp(pos / HueBar.AbsoluteSize.Y, 0, 1); update() end end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then mapDragging = false; hueDragging = false end end)
    
    local ApplyBtn = self:Create("TextButton", { Parent = PickerFrame, Size = UDim2.new(1, -30, 0, 32), Position = UDim2.new(0.5, 0, 1, -12), AnchorPoint = Vector2.new(0.5, 1), BackgroundColor3 = theme.Accent, Text = "Select Color", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13, ZIndex = 3001 }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 4)}) })
    ApplyBtn.MouseButton1Click:Connect(function() callback(selectedColor); PickerFrame:Destroy() end)
    update()
end

function DeusUI:CreateWindow(config)
    local theme = self.Themes[self.CurrentTheme]
    local ScreenGui = self:Create("ScreenGui", { Name = "DeusDiscordUI", Parent = (gethui and gethui()) or CoreGui, ResetOnSpawn = false })
    self.ScreenGui = ScreenGui
    
    local WindowSize = UDim2.new(0, 520, 0, 340)
    
    local MainFrame = self:Create("Frame", { Name = "MainFrame", Parent = ScreenGui, BackgroundColor3 = theme.Main, Position = UDim2.new(0.5, -260, 0.5, -170), Size = WindowSize, ClipsDescendants = true, ZIndex = 1 }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        self:Create("UIStroke", {Color = theme.Outline, Transparency = 0.2, Thickness = 1})
    })
    
    local Sidebar = self:Create("Frame", { Name = "Sidebar", Parent = MainFrame, Size = UDim2.new(0, 160, 1, 0), BackgroundColor3 = theme.Secondary, ZIndex = 2 }, { 
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        self:Create("Frame", {Name = "Header", Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, ZIndex = 3}, {
            self:Create("TextLabel", {Text = config.Title or "DEUS CLOUD", Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = "Left", ZIndex = 4}),
            self:Create("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = theme.Outline, BackgroundTransparency = 0.5, ZIndex = 4})
        })
    })
    
    local TabContainer = self:Create("ScrollingFrame", { 
        Name = "TabScroll", Parent = Sidebar, Size = UDim2.new(1, 0, 1, -60), Position = UDim2.new(0, 0, 0, 55), BackgroundTransparency = 1, ScrollBarThickness = 0, 
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0, 0, 0, 0), ZIndex = 3 
    }, { 
        self:Create("UIListLayout", {Padding = UDim.new(0, 2), HorizontalAlignment = "Center"}),
        self:Create("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})
    })

    local PageContainer = self:Create("Frame", { Name = "PageContainer", Parent = MainFrame, Size = UDim2.new(1, -160, 1, -48), Position = UDim2.new(0, 160, 0, 48), BackgroundTransparency = 1, ZIndex = 2 })
    
    local Topbar = self:Create("Frame", { Name = "Topbar", Parent = MainFrame, Size = UDim2.new(1, -160, 0, 48), Position = UDim2.new(0, 160, 0, 0), BackgroundTransparency = 1, ZIndex = 3 }, {
        self:Create("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = theme.Outline, BackgroundTransparency = 0.5, ZIndex = 4}),
        self:Create("TextLabel", {Name = "TabTitle", Text = "Home", Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 20, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = "Left", ZIndex = 4})
    })

    local Controls = self:Create("Frame", { Name = "Controls", Parent = Topbar, Size = UDim2.new(0, 80, 0, 30), Position = UDim2.new(1, -10, 0, 9), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, ZIndex = 100 })
    self:Create("UIListLayout", { Parent = Controls, FillDirection = "Horizontal", Padding = UDim.new(0, 10), VerticalAlignment = "Center", HorizontalAlignment = "Right" })
    
    local Minimized = false
    local MinBtn = self:Create("TextButton", { Name = "Min", Parent = Controls, Size = UDim2.new(0, 24, 0, 24), BackgroundTransparency = 1, Text = "—", TextColor3 = theme.TextSecondary, TextSize = 14, Font = Enum.Font.GothamBold, ZIndex = 101 })
    local CloseBtn = self:Create("TextButton", { Name = "Close", Parent = Controls, Size = UDim2.new(0, 24, 0, 24), BackgroundTransparency = 1, Text = "×", TextColor3 = theme.TextSecondary, TextSize = 22, Font = Enum.Font.GothamBold, ZIndex = 101 })

    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        local target = Minimized and UDim2.new(0, 520, 0, 48) or WindowSize
        DeusUI:Tween(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = target})
        Sidebar.Visible = not Minimized; PageContainer.Visible = not Minimized
    end)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    CloseBtn.MouseEnter:Connect(function() CloseBtn.TextColor3 = theme.Danger end)
    CloseBtn.MouseLeave:Connect(function() CloseBtn.TextColor3 = theme.TextSecondary end)

    local dragging, dragStart, startPos
    Topbar.InputBegan:Connect(function(input) 
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
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
        local tabTitle = tabConfig.Title or "Tab"; local tabIcon = DeusUI:GetIcon(tabConfig.Icon)
        local Page = DeusUI:Create("ScrollingFrame", { 
            Name = tabTitle .. "Page", Parent = PageContainer, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 3, ScrollBarImageColor3 = theme.Outline,
            AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0, 0, 0, 0), ZIndex = 3 
        }, { 
            DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 12), HorizontalAlignment = "Center"}),
            DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 20), PaddingBottom = UDim.new(0, 20), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15)})
        })
        
        local TabBtn = DeusUI:Create("TextButton", { Name = tabTitle .. "Btn", Parent = TabContainer, Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 4 }, { 
            DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
            DeusUI:Create("Frame", { Name = "Indicator", Size = UDim2.new(0, 4, 0, 8), Position = UDim2.new(0, -10, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 5 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) }),
            DeusUI:Create("Frame", { Name = "Content", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 5 }, {
                DeusUI:Create("UIListLayout", { FillDirection = "Horizontal", VerticalAlignment = "Center", Padding = UDim.new(0, 10), HorizontalAlignment = "Left" }),
                DeusUI:Create("UIPadding", {PaddingLeft = UDim.new(0, 10)}),
                tabIcon and DeusUI:Create("ImageLabel", { Name = "Icon", Size = UDim2.new(0, 18, 0, 18), BackgroundTransparency = 1, Image = tabIcon, ImageColor3 = theme.TextSecondary, ZIndex = 6 }) or nil,
                DeusUI:Create("TextLabel", { Name = "Label", Text = tabTitle, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = "X", BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, TextSize = 13, Font = Enum.Font.GothamMedium, ZIndex = 6 })
            })
        })

        local tabObj = {Type = "TabBtn", Instance = TabBtn, Selected = false}; table.insert(DeusUI.Elements, tabObj)
        local function SetTabState(state)
            tabObj.Selected = state
            local targetBG = state and theme.Main or 1
            local targetText = state and theme.Text or theme.TextSecondary
            DeusUI:Tween(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = state and 0 or 1, BackgroundColor3 = theme.Main})
            DeusUI:Tween(TabBtn.Content.Label, TweenInfo.new(0.2), {TextColor3 = targetText})
            if TabBtn.Content:FindFirstChild("Icon") then DeusUI:Tween(TabBtn.Content.Icon, TweenInfo.new(0.2), {ImageColor3 = targetText}) end
            DeusUI:Tween(TabBtn.Indicator, TweenInfo.new(0.2), {Size = state and UDim2.new(0, 4, 0, 20) or UDim2.new(0, 4, 0, 8), BackgroundTransparency = state and 0 or 1})
        end

        TabBtn.MouseButton1Click:Connect(function() 
            for _, p in pairs(PageContainer:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
            for _, el in pairs(DeusUI.Elements) do if el.Type == "TabBtn" then el.Selected = false; SetTabState(false) end end
            Page.Visible = true; SetTabState(true); Topbar.TabTitle.Text = tabTitle
        end)
        TabBtn.MouseEnter:Connect(function() if not tabObj.Selected then DeusUI:Tween(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(53, 55, 60)}); DeusUI:Tween(TabBtn.Content.Label, TweenInfo.new(0.2), {TextColor3 = theme.Text}) end end)
        TabBtn.MouseLeave:Connect(function() if not tabObj.Selected then DeusUI:Tween(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}); DeusUI:Tween(TabBtn.Content.Label, TweenInfo.new(0.2), {TextColor3 = theme.TextSecondary}) end end)

        if not DeusUI.SelectedTab then DeusUI.SelectedTab = true; Page.Visible = true; SetTabState(true); Topbar.TabTitle.Text = tabTitle end
        
        local Tab = {}
        function Tab:Button(btnConfig) 
            local Button = DeusUI:Create("TextButton", { Parent = Page, Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = theme.Accent, Text = btnConfig.Title or "Button", TextColor3 = Color3.new(1,1,1), TextSize = 13, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 4 }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)})
            })
            Button.MouseButton1Click:Connect(function() btnConfig.Callback() end)
            Button.MouseEnter:Connect(function() DeusUI:Tween(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(71, 82, 196)}) end)
            Button.MouseLeave:Connect(function() DeusUI:Tween(Button, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent}) end)
        end

        function Tab:Toggle(tConfig) 
            local toggled = tConfig.Default or false
            local ToggleFrame = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, ZIndex = 4 }, { 
                DeusUI:Create("TextLabel", {Name = "T", Text = tConfig.Title or "Toggle", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 14, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -60, 1, 0), TextXAlignment = "Left", ZIndex = 5}) 
            })
            local Switch = DeusUI:Create("TextButton", { Parent = ToggleFrame, Size = UDim2.new(0, 40, 0, 22), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = toggled and theme.Success or Color3.fromRGB(128, 132, 142), Text = "", ZIndex = 5 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local Circle = DeusUI:Create("Frame", { Parent = Switch, Size = UDim2.new(0, 16, 0, 16), Position = toggled and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0), AnchorPoint = toggled and Vector2.new(1, 0.5) or Vector2.new(0, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 6 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            
            Switch.MouseButton1Click:Connect(function() 
                toggled = not toggled
                DeusUI:Tween(Circle, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0), AnchorPoint = toggled and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)})
                DeusUI:Tween(Switch, TweenInfo.new(0.2), {BackgroundColor3 = toggled and theme.Success or Color3.fromRGB(128, 132, 142)})
                tConfig.Callback(toggled)
            end)
        end

        function Tab:Slider(sConfig) 
            local min, max, val = sConfig.Min or 0, sConfig.Max or 100, sConfig.Default or 50
            local SliderFrame = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, ZIndex = 4 }, { 
                DeusUI:Create("TextLabel", {Name = "T", Text = sConfig.Title or "Slider", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 13, Font = Enum.Font.GothamMedium, Size = UDim2.new(0.7, 0, 0, 18), TextXAlignment = "Left", ZIndex = 5}), 
                DeusUI:Create("TextLabel", {Name = "Val", Text = tostring(val), BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, TextSize = 12, Font = Enum.Font.GothamBold, Size = UDim2.new(0.3, 0, 0, 18), Position = UDim2.new(0.7, 0, 0, 0), TextXAlignment = "Right", ZIndex = 5}) 
            })
            local Bar = DeusUI:Create("Frame", {Parent = SliderFrame, Size = UDim2.new(1, 0, 0, 6), Position = UDim2.new(0, 0, 0, 32), BackgroundColor3 = theme.ChannelBG, ZIndex = 5}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local Fill = DeusUI:Create("Frame", {Parent = Bar, Size = UDim2.new((val-min)/(max-min), 0, 1, 0), BackgroundColor3 = theme.Accent, ZIndex = 6}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local Knob = DeusUI:Create("Frame", {Parent = Fill, Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 7}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), DeusUI:Create("UIStroke", {Color = theme.Accent, Thickness = 2}) })
            
            local dragging = false
            local function update(input) 
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max-min)*pos); SliderFrame.Val.Text = tostring(val); Fill.Size = UDim2.new(pos, 0, 1, 0); sConfig.Callback(val)
            end
            Knob.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if dragging then update(input) end end)
        end

        function Tab:Dropdown(dConfig) 
            local dValues = dConfig.Values or {}; local selected = dConfig.Default or "Select..."; local opened = false
            local DropdownFrame = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = theme.ChannelBG, ClipsDescendants = true, ZIndex = 4 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), DeusUI:Create("UIStroke", {Color = theme.Outline, Transparency = 0.5}) })
            local Header = DeusUI:Create("TextButton", {Parent = DropdownFrame, Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Text = "", ZIndex = 5})
            local Title = DeusUI:Create("TextLabel", {Text = dConfig.Title or "Dropdown", Parent = Header, Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = "Left", ZIndex = 6})
            local SelText = DeusUI:Create("TextLabel", {Text = selected, Parent = Header, Size = UDim2.new(0, 100, 1, 0), Position = UDim2.new(1, -40, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = "Right", ZIndex = 6})
            local Arrow = DeusUI:Create("TextLabel", {Text = "▼", Parent = Header, Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -10, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, Font = Enum.Font.Gotham, TextSize = 10, ZIndex = 6})
            
            local OptionHolder = DeusUI:Create("ScrollingFrame", {Parent = DropdownFrame, Size = UDim2.new(1, 0, 0, 120), Position = UDim2.new(0, 0, 0, 40), BackgroundTransparency = 1, ScrollBarThickness = 2, AutomaticCanvasSize = "Y", Visible = false, ZIndex = 10}, { DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 2)}), DeusUI:Create("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}) })
            
            local function toggle(state)
                opened = state; DeusUI:Tween(DropdownFrame, TweenInfo.new(0.3), {Size = state and UDim2.new(1, 0, 0, 165) or UDim2.new(1, 0, 0, 40)}); OptionHolder.Visible = state; Arrow.Rotation = state and 180 or 0
            end
            Header.MouseButton1Click:Connect(function() toggle(not opened) end)
            for _, val in pairs(dValues) do
                local Opt = DeusUI:Create("TextButton", { Parent = OptionHolder, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = val, TextColor3 = theme.TextSecondary, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = "Left", ZIndex = 11 }, { DeusUI:Create("UIPadding", {PaddingLeft = UDim.new(0, 10)}) })
                Opt.MouseButton1Click:Connect(function() selected = val; SelText.Text = val; toggle(false); dConfig.Callback(val) end)
                Opt.MouseEnter:Connect(function() Opt.BackgroundTransparency = 0.9; Opt.BackgroundColor3 = Color3.new(1,1,1); Opt.TextColor3 = theme.Text end)
                Opt.MouseLeave:Connect(function() Opt.BackgroundTransparency = 1; Opt.TextColor3 = theme.TextSecondary end)
            end
        end

        function Tab:Keybind(kConfig) 
            local currentKey = kConfig.Default or Enum.KeyCode.F
            local BindFrame = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, ZIndex = 4 }, { DeusUI:Create("TextLabel", {Name = "T", Text = kConfig.Title or "Keybind", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 13, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -100, 1, 0), TextXAlignment = "Left", ZIndex = 5}) })
            local Btn = DeusUI:Create("TextButton", { Parent = BindFrame, Size = UDim2.new(0, 80, 0, 26), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = theme.ChannelBG, Text = currentKey.Name, TextColor3 = theme.Text, Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 5 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), DeusUI:Create("UIStroke", {Color = theme.Outline, Transparency = 0.5}) })
            Btn.MouseButton1Click:Connect(function() Btn.Text = "..."; local connection; connection = UserInputService.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Keyboard then currentKey = input.KeyCode; Btn.Text = currentKey.Name; connection:Disconnect(); kConfig.Callback(currentKey) end end) end)
        end

        function Tab:Colorpicker(cConfig) 
            local current = cConfig.Default or Color3.fromRGB(88, 101, 242)
            local ColorFrame = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, ZIndex = 4 }, { DeusUI:Create("TextLabel", {Name = "T", Text = cConfig.Title or "Color", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 13, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -60, 1, 0), TextXAlignment = "Left", ZIndex = 5}) })
            local ColorView = DeusUI:Create("TextButton", { Parent = ColorFrame, Size = UDim2.new(0, 40, 0, 24), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = current, Text = "", ZIndex = 5 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), DeusUI:Create("UIStroke", {Color = theme.Outline, Thickness = 1.5}) })
            ColorView.MouseButton1Click:Connect(function() DeusUI:OpenColorPicker(current, function(nc) current = nc; ColorView.BackgroundColor3 = nc; cConfig.Callback(nc) end) end)
        end

        function Tab:Paragraph(pConfig) 
            local ParaFrame = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = "Y", BackgroundColor3 = theme.ChannelBG, BackgroundTransparency = 0.5, ZIndex = 4 }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), 
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15)}), 
                DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 6)}), 
                DeusUI:Create("TextLabel", {Name = "T", Text = pConfig.Title or "Information", BackgroundTransparency = 1, TextColor3 = theme.Accent, Font = Enum.Font.GothamBold, TextSize = 14, AutomaticSize = "XY", ZIndex = 5}), 
                DeusUI:Create("TextLabel", {Name = "D", Text = pConfig.Desc or "", BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, Font = Enum.Font.Gotham, TextSize = 12, AutomaticSize = "Y", Size = UDim2.new(1, 0, 0, 0), TextWrapped = true, TextXAlignment = "Left", ZIndex = 5}) 
            })
        end
        return Tab
    end

    function Window:Settings()
        local SettingsTab = Window:Tab({Title = "Client Settings", Icon = "settings"})
        SettingsTab:Dropdown({ Title = "Interface Theme", Values = {"Dark", "Light"}, Default = DeusUI.CurrentTheme, Callback = function(t) DeusUI.CurrentTheme = t; ScreenGui:Destroy(); DeusUI:Notify({Content = "Theme updated, please restart script.", Duration = 3}) end })
        SettingsTab:Button({ Title = "Destroy Client UI", Callback = function() ScreenGui:Destroy() end })
        return SettingsTab
    end

    return Window
end

return DeusUI

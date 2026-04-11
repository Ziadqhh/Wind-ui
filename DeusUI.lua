--[[
    Deus Evolution UI | Version 1.3.6 (ULTIMATE STABLE - COLLAPSE UPDATE)
    Created by: Deus Mode (Gemini CLI)
    Style: Discord Client Aesthetic | Cloud Icons | Expandable Sections
]]

local DeusUI = {
    Themes = {
        Dark = { Main = Color3.fromRGB(49, 51, 56), Secondary = Color3.fromRGB(43, 45, 49), ChannelBG = Color3.fromRGB(30, 31, 34), Outline = Color3.fromRGB(30, 31, 34), Text = Color3.fromRGB(242, 243, 245), TextSecondary = Color3.fromRGB(181, 186, 193), Accent = Color3.fromRGB(88, 101, 242), Success = Color3.fromRGB(35, 165, 89), Danger = Color3.fromRGB(242, 63, 66), Transparency = 0 },
        Light = { Main = Color3.fromRGB(255, 255, 255), Secondary = Color3.fromRGB(242, 243, 245), ChannelBG = Color3.fromRGB(227, 229, 232), Outline = Color3.fromRGB(227, 229, 232), Text = Color3.fromRGB(6, 6, 7), TextSecondary = Color3.fromRGB(78, 80, 88), Accent = Color3.fromRGB(88, 101, 242), Success = Color3.fromRGB(35, 165, 89), Danger = Color3.fromRGB(242, 63, 66), Transparency = 0 },
        Midnight = { Main = Color3.fromRGB(15, 15, 20), Secondary = Color3.fromRGB(10, 10, 15), ChannelBG = Color3.fromRGB(5, 5, 10), Outline = Color3.fromRGB(30, 30, 45), Text = Color3.fromRGB(255, 255, 255), TextSecondary = Color3.fromRGB(150, 150, 180), Accent = Color3.fromRGB(100, 150, 255), Success = Color3.fromRGB(50, 200, 120), Danger = Color3.fromRGB(255, 80, 80), Transparency = 0 },
        Ocean = { Main = Color3.fromRGB(20, 35, 45), Secondary = Color3.fromRGB(15, 25, 35), ChannelBG = Color3.fromRGB(10, 20, 25), Outline = Color3.fromRGB(40, 70, 80), Text = Color3.fromRGB(230, 245, 255), TextSecondary = Color3.fromRGB(130, 170, 190), Accent = Color3.fromRGB(0, 200, 255), Success = Color3.fromRGB(0, 255, 150), Danger = Color3.fromRGB(255, 100, 100), Transparency = 0 },
        Forest = { Main = Color3.fromRGB(25, 30, 25), Secondary = Color3.fromRGB(20, 25, 20), ChannelBG = Color3.fromRGB(15, 20, 15), Outline = Color3.fromRGB(50, 65, 50), Text = Color3.fromRGB(230, 240, 230), TextSecondary = Color3.fromRGB(140, 160, 140), Accent = Color3.fromRGB(100, 220, 100), Success = Color3.fromRGB(150, 255, 150), Danger = Color3.fromRGB(255, 120, 100), Transparency = 0 },
        Amethyst = { Main = Color3.fromRGB(30, 20, 45), Secondary = Color3.fromRGB(25, 15, 35), ChannelBG = Color3.fromRGB(20, 10, 30), Outline = Color3.fromRGB(70, 50, 90), Text = Color3.fromRGB(245, 230, 255), TextSecondary = Color3.fromRGB(170, 140, 200), Accent = Color3.fromRGB(180, 100, 255), Success = Color3.fromRGB(150, 255, 150), Danger = Color3.fromRGB(255, 100, 150), Transparency = 0 },
        Rose = { Main = Color3.fromRGB(45, 20, 30), Secondary = Color3.fromRGB(35, 15, 25), ChannelBG = Color3.fromRGB(30, 10, 20), Outline = Color3.fromRGB(90, 50, 70), Text = Color3.fromRGB(255, 230, 240), TextSecondary = Color3.fromRGB(200, 140, 170), Accent = Color3.fromRGB(255, 100, 180), Success = Color3.fromRGB(150, 255, 150), Danger = Color3.fromRGB(255, 80, 80), Transparency = 0 },
        Sakura = { Main = Color3.fromRGB(255, 240, 245), Secondary = Color3.fromRGB(255, 225, 235), ChannelBG = Color3.fromRGB(255, 210, 225), Outline = Color3.fromRGB(255, 180, 200), Text = Color3.fromRGB(80, 40, 60), TextSecondary = Color3.fromRGB(150, 100, 120), Accent = Color3.fromRGB(255, 120, 180), Success = Color3.fromRGB(100, 200, 100), Danger = Color3.fromRGB(230, 60, 60), Transparency = 0 },
        Emerald = { Main = Color3.fromRGB(10, 40, 30), Secondary = Color3.fromRGB(5, 30, 20), ChannelBG = Color3.fromRGB(0, 20, 15), Outline = Color3.fromRGB(30, 80, 60), Text = Color3.fromRGB(220, 255, 240), TextSecondary = Color3.fromRGB(120, 180, 160), Accent = Color3.fromRGB(40, 255, 150), Success = Color3.fromRGB(100, 255, 100), Danger = Color3.fromRGB(255, 100, 100), Transparency = 0 },
        Void = { Main = Color3.fromRGB(0, 0, 0), Secondary = Color3.fromRGB(5, 5, 5), ChannelBG = Color3.fromRGB(10, 10, 10), Outline = Color3.fromRGB(30, 30, 30), Text = Color3.fromRGB(255, 255, 255), TextSecondary = Color3.fromRGB(120, 120, 120), Accent = Color3.fromRGB(255, 255, 255), Success = Color3.fromRGB(200, 200, 200), Danger = Color3.fromRGB(150, 0, 0), Transparency = 0 }
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
    if success and type(result) == "table" then DeusUI.Icons = result end
end

function DeusUI:Create(className, properties, children)
    local inst = Instance.new(className)
    if properties then for prop, value in pairs(properties) do pcall(function() inst[prop] = value end) end end
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
    local TI = TweenInfo.new(0.4, Enum.EasingStyle.Quart)
    for _, data in pairs(self.Elements) do
        local inst = data.Instance
        if not inst or not inst.Parent then continue end
        if data.Type == "MainFrame" then self:Tween(inst, TI, {BackgroundColor3 = theme.Main, BackgroundTransparency = theme.Transparency})
        elseif data.Type == "Sidebar" then self:Tween(inst, TI, {BackgroundColor3 = theme.Secondary, BackgroundTransparency = theme.Transparency})
        elseif data.Type == "Topbar" then if inst:FindFirstChild("TabTitle") then self:Tween(inst.TabTitle, TI, {TextColor3 = theme.Text}) end
        elseif data.Type == "TabBtn" then
            local current = self.Themes[self.CurrentTheme]
            local targetText = data.Selected and current.Text or current.TextSecondary
            self:Tween(inst.Content.Label, TI, {TextColor3 = targetText})
            if inst.Content:FindFirstChild("Icon") then self:Tween(inst.Content.Icon, TI, {ImageColor3 = targetText}) end
            if data.Selected then self:Tween(inst, TI, {BackgroundColor3 = current.Main, BackgroundTransparency = current.Transparency}); self:Tween(inst.Indicator, TI, {BackgroundColor3 = current.Accent, BackgroundTransparency = 0})
            else self:Tween(inst, TI, {BackgroundTransparency = 1}); self:Tween(inst.Indicator, TI, {BackgroundTransparency = 1}) end
        elseif data.Type == "Button" then self:Tween(inst, TI, {BackgroundColor3 = theme.Accent})
        elseif data.Type == "ToggleSwitch" then if data.Toggled then self:Tween(inst, TI, {BackgroundColor3 = theme.Success}) else self:Tween(inst, TI, {BackgroundColor3 = Color3.fromRGB(128, 132, 142)}) end
        elseif data.Type == "SliderFill" then self:Tween(inst, TI, {BackgroundColor3 = theme.Accent})
        elseif data.Type == "SectionText" then self:Tween(inst, TI, {TextColor3 = theme.Accent})
        elseif data.Type == "TextColor" then self:Tween(inst, TI, {TextColor3 = theme.Text})
        elseif data.Type == "SecondaryBG" then self:Tween(inst, TI, {BackgroundColor3 = theme.ChannelBG, BackgroundTransparency = theme.Transparency}) end
    end
end

function DeusUI:CreateWindow(config)
    local theme = self.Themes[self.CurrentTheme]
    local ScreenGui = self:Create("ScreenGui", { Name = "DeusDiscordUI", Parent = (gethui and gethui()) or CoreGui, ResetOnSpawn = false })
    self.ScreenGui = ScreenGui; self.Elements = {}
    local WindowSize = UDim2.new(0, 450, 0, 300)
    local MainFrame = self:Create("CanvasGroup", { Name = "MainFrame", Parent = ScreenGui, BackgroundColor3 = theme.Main, Position = UDim2.new(0.5, -225, 0.5, -150), Size = WindowSize, ClipsDescendants = true, ZIndex = 1, GroupTransparency = 0 }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), self:Create("UIStroke", {Color = theme.Outline, Transparency = 0.2, Thickness = 1}), self:Create("UIScale", {Scale = 1}) })
    self.MainFrame = MainFrame; self.UIScale = MainFrame.UIScale; table.insert(self.Elements, {Instance = MainFrame, Type = "MainFrame"})
    local Sidebar = self:Create("Frame", { Name = "Sidebar", Parent = MainFrame, Size = UDim2.new(0, 130, 1, 0), BackgroundColor3 = theme.Secondary, ZIndex = 2 }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), self:Create("Frame", {Name = "Header", Size = UDim2.new(1, 0, 0, 35), BackgroundTransparency = 1, ZIndex = 3}, { self:Create("TextLabel", {Text = config.Title or "DEUS", Size = UDim2.new(1, -15, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 12, Font = Enum.Font.GothamBold, TextXAlignment = "Left", ZIndex = 4}), self:Create("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = theme.Outline, BackgroundTransparency = 0.6, ZIndex = 4}) }) })
    table.insert(self.Elements, {Instance = Sidebar, Type = "Sidebar"})
    local TabContainer = self:Create("ScrollingFrame", { Name = "TabScroll", Parent = Sidebar, Size = UDim2.new(1, 0, 1, -45), Position = UDim2.new(0, 0, 0, 40), BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = theme.Outline, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0), ZIndex = 3 }, { self:Create("UIListLayout", {Padding = UDim.new(0, 2), HorizontalAlignment = "Center", SortOrder = Enum.SortOrder.LayoutOrder}), self:Create("UIPadding", {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)}) })
    local PageContainer = self:Create("Frame", { Name = "PageContainer", Parent = MainFrame, Size = UDim2.new(1, -130, 1, -35), Position = UDim2.new(0, 130, 0, 35), BackgroundTransparency = 1, ZIndex = 2 })
    local Topbar = self:Create("Frame", { Name = "Topbar", Parent = MainFrame, Size = UDim2.new(1, -130, 0, 35), Position = UDim2.new(0, 130, 0, 0), BackgroundTransparency = 1, ZIndex = 3 }, { self:Create("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = theme.Outline, BackgroundTransparency = 0.6, ZIndex = 4}), self:Create("TextLabel", {Name = "TabTitle", Text = "Home", Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 12, Font = Enum.Font.GothamBold, TextXAlignment = "Left", ZIndex = 4}) })
    table.insert(self.Elements, {Instance = Topbar, Type = "Topbar"})
    local function CreateControlButton(name, text, color) local btn = self:Create("TextButton", { Name = name, Size = UDim2.new(0, 22, 0, 22), BackgroundTransparency = 1, Text = text, TextColor3 = theme.TextSecondary, TextSize = (text == "×") and 18 or 14, Font = Enum.Font.GothamBold, ZIndex = 101, AutoButtonColor = false }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 4)}) }); btn.MouseEnter:Connect(function() self:Tween(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, BackgroundColor3 = color or Color3.fromRGB(200, 200, 200), TextColor3 = Color3.new(1,1,1)}) end); btn.MouseLeave:Connect(function() self:Tween(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = self.Themes[self.CurrentTheme].TextSecondary}) end); return btn end
    local MinBtn = CreateControlButton("Min", "—"); local CloseBtn = CreateControlButton("Close", "×", Color3.fromRGB(242, 63, 66)); local Controls = self:Create("Frame", { Name = "Controls", Parent = Topbar, Size = UDim2.new(0, 65, 1, 0), Position = UDim2.new(1, -5, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, ZIndex = 100 }, { self:Create("UIListLayout", { FillDirection = "Horizontal", Padding = UDim.new(0, 5), VerticalAlignment = "Center", HorizontalAlignment = "Right" }) }); MinBtn.Parent = Controls; CloseBtn.Parent = Controls; MinBtn.MouseButton1Click:Connect(function() local isMin = MainFrame.Size.Y.Offset < 100; self:Tween(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = isMin and WindowSize or UDim2.new(0, 450, 0, 35)}); Sidebar.Visible = isMin; PageContainer.Visible = isMin end); CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    local dragging, dragStart, startPos; Topbar.InputBegan:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then dragging = true; dragStart = input.Position; startPos = MainFrame.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end); UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

    local OrderTracker = 0
    local WindowMethods = {}
    function WindowMethods:SidebarSection(title) OrderTracker = OrderTracker + 1; local Sec = DeusUI:Create("TextLabel", { Parent = TabContainer, Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = title:upper(), TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent, TextSize = 9, Font = Enum.Font.GothamBold, TextXAlignment = "Left", ZIndex = 4, LayoutOrder = OrderTracker }, { DeusUI:Create("UIPadding", {PaddingLeft = UDim.new(0, 10)}) }); table.insert(DeusUI.Elements, {Instance = Sec, Type = "SectionText"}); return Sec end
    
    function WindowMethods:Tab(tabConfig)
        OrderTracker = OrderTracker + 1
        local Page = DeusUI:Create("ScrollingFrame", { Parent = PageContainer, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = theme.Outline, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0), ZIndex = 3 }, { DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 8), HorizontalAlignment = "Center"}), DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}) })
        local tabTitle = tabConfig.Title or "Tab"; local TabBtn = DeusUI:Create("TextButton", { Parent = TabContainer, Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 4, LayoutOrder = OrderTracker }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), DeusUI:Create("Frame", { Name = "Indicator", Size = UDim2.new(0, 3, 0, 6), Position = UDim2.new(0, -10, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = theme.Accent, BackgroundTransparency = 1, ZIndex = 5 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) }), DeusUI:Create("Frame", { Name = "Content", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 5 }, { DeusUI:Create("UIListLayout", { FillDirection = "Horizontal", VerticalAlignment = "Center", Padding = UDim.new(0, 8), HorizontalAlignment = "Left" }), DeusUI:Create("UIPadding", {PaddingLeft = UDim.new(0, 8)}), DeusUI:Create("ImageLabel", { Name = "Icon", Size = UDim2.new(0, 14, 0, 14), BackgroundTransparency = 1, Image = DeusUI:GetIcon(tabConfig.Icon), ImageColor3 = theme.TextSecondary, ZIndex = 6 }), DeusUI:Create("TextLabel", { Name = "Label", Text = tabTitle, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = "X", BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, TextSize = 11, Font = Enum.Font.GothamMedium, ZIndex = 6 }) }) })
        local tabData = {Type = "TabBtn", Instance = TabBtn, Selected = false}; table.insert(DeusUI.Elements, tabData)
        local function SetTabState(state) tabData.Selected = state; local cur = DeusUI.Themes[DeusUI.CurrentTheme]; local targetText = state and cur.Text or cur.TextSecondary; DeusUI:Tween(TabBtn.Content.Label, TweenInfo.new(0.2), {TextColor3 = targetText}); DeusUI:Tween(TabBtn.Content.Icon, TweenInfo.new(0.2), {ImageColor3 = targetText}); if state then DeusUI:Tween(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, BackgroundColor3 = cur.Main}); DeusUI:Tween(TabBtn.Indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 16), BackgroundTransparency = 0, BackgroundColor3 = cur.Accent}) else DeusUI:Tween(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}); DeusUI:Tween(TabBtn.Indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 6), BackgroundTransparency = 1}) end end
        TabBtn.MouseButton1Click:Connect(function() for _, p in pairs(PageContainer:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end; for _, el in pairs(DeusUI.Elements) do if el.Type == "TabBtn" then el.Selected = false; local eInst = el.Instance; DeusUI:Tween(eInst, TweenInfo.new(0.2), {BackgroundTransparency = 1}); DeusUI:Tween(eInst.Indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 6), BackgroundTransparency = 1}); DeusUI:Tween(eInst.Content.Label, TweenInfo.new(0.2), {TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].TextSecondary}); DeusUI:Tween(eInst.Content.Icon, TweenInfo.new(0.2), {ImageColor3 = DeusUI.Themes[DeusUI.CurrentTheme].TextSecondary}) end end; Page.Visible = true; SetTabState(true); Topbar.TabTitle.Text = tabTitle end)
        if not DeusUI.SelectedTab then DeusUI.SelectedTab = true; Page.Visible = true; SetTabState(true); Topbar.TabTitle.Text = tabTitle end
        
        local function CreateTabMethods(Container)
            local TabMethods = {}
            function TabMethods:Section(title) local Sec = DeusUI:Create("TextLabel", { Parent = Container, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = title:upper(), TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent, TextSize = 10, Font = Enum.Font.GothamBold, TextXAlignment = "Left", ZIndex = 4 }); table.insert(DeusUI.Elements, {Instance = Sec, Type = "SectionText"}); return Sec end
            function TabMethods:Button(btnConfig) local Button = DeusUI:Create("TextButton", { Parent = Container, Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent, Text = btnConfig.Title or "Button", TextColor3 = Color3.new(1,1,1), TextSize = 11, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 4 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}) }); table.insert(DeusUI.Elements, {Instance = Button, Type = "Button"}); Button.MouseButton1Click:Connect(function() btnConfig.Callback() end); return Button end
            function TabMethods:Toggle(tConfig) local toggled = tConfig.Default or false; local current = DeusUI.Themes[DeusUI.CurrentTheme]; local ToggleFrame = DeusUI:Create("Frame", { Parent = Container, Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, ZIndex = 4 }, { DeusUI:Create("TextLabel", {Name = "T", Text = tConfig.Title or "Toggle", BackgroundTransparency = 1, TextColor3 = current.Text, TextSize = 12, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -45, 1, 0), TextXAlignment = "Left", ZIndex = 5}) }); table.insert(DeusUI.Elements, {Instance = ToggleFrame.T, Type = "TextColor"}); local Switch = DeusUI:Create("TextButton", { Parent = ToggleFrame, Size = UDim2.new(0, 32, 0, 16), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = toggled and current.Success or Color3.fromRGB(128, 132, 142), Text = "", ZIndex = 5 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) }); local Circle = DeusUI:Create("Frame", { Parent = Switch, Size = UDim2.new(0, 12, 0, 12), Position = toggled and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), AnchorPoint = toggled and Vector2.new(1, 0.5) or Vector2.new(0, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 6 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) }); local tData = {Instance = Switch, Type = "ToggleSwitch", Toggled = toggled}; table.insert(DeusUI.Elements, tData); Switch.MouseButton1Click:Connect(function() toggled = not toggled; tData.Toggled = toggled; DeusUI:Tween(Circle, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), AnchorPoint = toggled and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)}); DeusUI:Tween(Switch, TweenInfo.new(0.2), {BackgroundColor3 = toggled and DeusUI.Themes[DeusUI.CurrentTheme].Success or Color3.fromRGB(128, 132, 142)}); tConfig.Callback(toggled) end); return ToggleFrame end
            function TabMethods:Slider(sConfig) local min, max, val = sConfig.Min or 0, sConfig.Max or 100, sConfig.Default or 50; local current = DeusUI.Themes[DeusUI.CurrentTheme]; local SliderFrame = DeusUI:Create("Frame", { Parent = Container, Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, ZIndex = 4 }, { DeusUI:Create("TextLabel", {Name = "T", Text = sConfig.Title or "Slider", BackgroundTransparency = 1, TextColor3 = current.Text, TextSize = 11, Font = Enum.Font.GothamMedium, Size = UDim2.new(0.7, 0, 0, 14), TextXAlignment = "Left", ZIndex = 5}), DeusUI:Create("TextLabel", {Name = "Val", Text = tostring(val), BackgroundTransparency = 1, TextColor3 = current.TextSecondary, TextSize = 10, Font = Enum.Font.GothamBold, Size = UDim2.new(0.3, 0, 0, 14), Position = UDim2.new(0.7, 0, 0, 0), TextXAlignment = "Right", ZIndex = 5}) }); table.insert(DeusUI.Elements, {Instance = SliderFrame.T, Type = "TextColor"}); local Bar = DeusUI:Create("Frame", {Parent = SliderFrame, Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0, 24), BackgroundColor3 = current.ChannelBG, ZIndex = 5}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) }); table.insert(DeusUI.Elements, {Instance = Bar, Type = "SecondaryBG"}); local Fill = DeusUI:Create("Frame", {Parent = Bar, Size = UDim2.new((val-min)/(max-min), 0, 1, 0), BackgroundColor3 = current.Accent, ZIndex = 6}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) }); table.insert(DeusUI.Elements, {Instance = Fill, Type = "SliderFill"}); local Knob = DeusUI:Create("Frame", {Parent = Fill, Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 7}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), DeusUI:Create("UIStroke", {Color = current.Accent, Thickness = 1.5}) }); local dragging = false; local function update(input) local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1); val = math.floor(min + (max-min)*pos); SliderFrame.Val.Text = tostring(val); Fill.Size = UDim2.new(pos, 0, 1, 0); sConfig.Callback(val) end; Knob.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end end); UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end); UserInputService.InputChanged:Connect(function(input) if dragging then update(input) end end); return SliderFrame end
            
            function TabMethods:Collapse(cConfig)
                local current = DeusUI.Themes[DeusUI.CurrentTheme]
                local isOpened = false
                local MainFrame = DeusUI:Create("Frame", { Parent = Container, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = current.ChannelBG, ClipsDescendants = true, ZIndex = 4 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), DeusUI:Create("UIStroke", {Color = current.Outline, Transparency = 0.5}) })
                table.insert(DeusUI.Elements, {Instance = MainFrame, Type = "SecondaryBG"})
                
                local Header = DeusUI:Create("TextButton", { Parent = MainFrame, Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Text = "", ZIndex = 5 })
                local Title = DeusUI:Create("TextLabel", { Parent = Header, Text = cConfig.Title or "Section", Size = UDim2.new(1, -40, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, TextColor3 = current.Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = "Left", ZIndex = 6 })
                table.insert(DeusUI.Elements, {Instance = Title, Type = "TextColor"})
                
                local Arrow = DeusUI:Create("ImageLabel", { Parent = Header, Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -12, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Image = DeusUI:GetIcon("chevron-down"), ImageColor3 = current.TextSecondary, ZIndex = 6 })
                
                local Content = DeusUI:Create("Frame", { Parent = MainFrame, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 32), BackgroundTransparency = 1, Visible = false, ZIndex = 5 }, { DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 6), HorizontalAlignment = "Center"}), DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}) })
                
                Header.MouseButton1Click:Connect(function()
                    isOpened = not isOpened
                    local targetSize = isOpened and UDim2.new(1, 0, 0, Content.UIListLayout.AbsoluteContentSize.Y + 40) or UDim2.new(1, 0, 0, 32)
                    DeusUI:Tween(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = targetSize})
                    DeusUI:Tween(Arrow, TweenInfo.new(0.3), {Rotation = isOpened and 180 or 0})
                    Content.Visible = isOpened
                end)
                
                return CreateTabMethods(Content)
            end
            
            return TabMethods
        end
        
        return CreateTabMethods(Page)
    end
    
    function WindowMethods:Settings() 
        self:SidebarSection("Other")
        local SettingsTab = self:Tab({Title = "Settings", Icon = "settings"})
        local ThemeNames = {}; for name, _ in pairs(DeusUI.Themes) do table.insert(ThemeNames, name) end
        SettingsTab:Dropdown({ Title = "Theme Presets", Values = ThemeNames, Default = DeusUI.CurrentTheme, Callback = function(t) DeusUI.CurrentTheme = t; DeusUI:UpdateUI() end })
        SettingsTab:Slider({ Title = "Transparency", Min = 0, Max = 100, Default = 0, Callback = function(v) local val = v/100; for _, theme in pairs(DeusUI.Themes) do theme.Transparency = val end; DeusUI:UpdateUI() end })
        SettingsTab:Colorpicker({ Title = "Background Color", Default = DeusUI.Themes[DeusUI.CurrentTheme].Main, Callback = function(c) DeusUI.Themes[DeusUI.CurrentTheme].Main = c; DeusUI:UpdateUI() end })
        SettingsTab:Colorpicker({ Title = "Text Color", Default = DeusUI.Themes[DeusUI.CurrentTheme].Text, Callback = function(c) for _, theme in pairs(DeusUI.Themes) do theme.Text = c end; DeusUI:UpdateUI() end })
        SettingsTab:Colorpicker({ Title = "Accent Color", Default = DeusUI.Themes[DeusUI.CurrentTheme].Accent, Callback = function(c) for _, theme in pairs(DeusUI.Themes) do theme.Accent = c end; DeusUI:UpdateUI() end })
        SettingsTab:Button({ Title = "Destroy UI", Callback = function() ScreenGui:Destroy() end })
        return SettingsTab 
    end
    
    return WindowMethods
end

return DeusUI

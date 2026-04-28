--[[
    Deus Evolution UI | Version 1.4.0 (ADVANCED CUSTOMIZATION)
    Created by: Deus Mode (Gemini CLI)
    Features: 
    - Fully Customizable Welcome Splash (Size, Pos, Icons, Colors, Progress)
    - Pro ESP System (Corner Box, Highlights, Names)
    - Dynamic Player Dropdown (With Headshot Thumbnails)
]]

local DeusUI = {
    Themes = {
        Dark = { Main = Color3.fromRGB(22, 22, 28), Secondary = Color3.fromRGB(18, 18, 23), ChannelBG = Color3.fromRGB(14, 14, 18), Outline = Color3.fromRGB(38, 38, 50), Text = Color3.fromRGB(245, 245, 250), TextSecondary = Color3.fromRGB(140, 142, 160), Accent = Color3.fromRGB(108, 92, 231), Success = Color3.fromRGB(0, 210, 106), Danger = Color3.fromRGB(255, 56, 56), Transparency = 0 },
        Midnight = { Main = Color3.fromRGB(10, 10, 16), Secondary = Color3.fromRGB(6, 6, 12), ChannelBG = Color3.fromRGB(3, 3, 8), Outline = Color3.fromRGB(28, 28, 48), Text = Color3.fromRGB(240, 240, 255), TextSecondary = Color3.fromRGB(120, 120, 155), Accent = Color3.fromRGB(80, 140, 255), Success = Color3.fromRGB(40, 220, 130), Danger = Color3.fromRGB(255, 70, 70), Transparency = 0 },
        Ocean = { Main = Color3.fromRGB(12, 20, 32), Secondary = Color3.fromRGB(8, 16, 28), ChannelBG = Color3.fromRGB(5, 12, 22), Outline = Color3.fromRGB(20, 50, 80), Text = Color3.fromRGB(220, 240, 255), TextSecondary = Color3.fromRGB(100, 150, 190), Accent = Color3.fromRGB(0, 170, 255), Success = Color3.fromRGB(0, 200, 150), Danger = Color3.fromRGB(255, 80, 100), Transparency = 0 },
        Rose = { Main = Color3.fromRGB(28, 16, 22), Secondary = Color3.fromRGB(22, 12, 18), ChannelBG = Color3.fromRGB(16, 8, 14), Outline = Color3.fromRGB(60, 25, 45), Text = Color3.fromRGB(255, 235, 245), TextSecondary = Color3.fromRGB(180, 130, 155), Accent = Color3.fromRGB(255, 60, 130), Success = Color3.fromRGB(60, 220, 140), Danger = Color3.fromRGB(255, 50, 50), Transparency = 0 },
        Emerald = { Main = Color3.fromRGB(12, 24, 18), Secondary = Color3.fromRGB(8, 18, 14), ChannelBG = Color3.fromRGB(5, 14, 10), Outline = Color3.fromRGB(20, 55, 40), Text = Color3.fromRGB(230, 255, 240), TextSecondary = Color3.fromRGB(120, 180, 150), Accent = Color3.fromRGB(0, 220, 130), Success = Color3.fromRGB(0, 255, 150), Danger = Color3.fromRGB(255, 80, 80), Transparency = 0 },
        Sunset = { Main = Color3.fromRGB(30, 18, 12), Secondary = Color3.fromRGB(24, 14, 8), ChannelBG = Color3.fromRGB(18, 10, 5), Outline = Color3.fromRGB(65, 35, 15), Text = Color3.fromRGB(255, 245, 235), TextSecondary = Color3.fromRGB(190, 150, 120), Accent = Color3.fromRGB(255, 140, 50), Success = Color3.fromRGB(80, 220, 120), Danger = Color3.fromRGB(255, 60, 60), Transparency = 0 }
    },
    Icons = {},
    IconURL = "https://raw.githubusercontent.com/Ziadqhh/Wind-ui/refs/heads/main/icon%20pack.lua",
    CurrentTheme = "Dark",
    Elements = {},
    SelectedTab = nil,
    ScreenGui = nil,
    MainFrame = nil,
    UIScale = nil,
    ESP = { Enabled = false, TargetPlayer = nil, CornerBoxes = true, Highlights = true, Names = true, Color = Color3.fromRGB(255, 255, 255), Objects = {} }
}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera

-- // --- INTERNAL UTILITIES --- // --
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

-- // --- COLOR PICKER SYSTEM --- // --
function DeusUI:OpenColorPicker(defaultColor, callback)
    local theme = self.Themes[self.CurrentTheme]
    local h, s, v = Color3.toHSV(defaultColor); local selectedColor = defaultColor
    local PickerFrame = self:Create("Frame", { Name = "PickerFrame", Parent = self.ScreenGui, Size = UDim2.new(0, 220, 0, 280), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = theme.ChannelBG, Active = true, ZIndex = 3000 }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), self:Create("UIStroke", {Color = theme.Outline, Thickness = 1.5}) })
    local ClosePicker = self:Create("TextButton", { Name = "Close", Parent = PickerFrame, Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(1, -30, 0, 5), BackgroundTransparency = 1, Text = "×", TextColor3 = theme.TextSecondary, Font = Enum.Font.GothamBold, TextSize = 20, ZIndex = 3001 })
    ClosePicker.MouseButton1Click:Connect(function() PickerFrame:Destroy() end)
    local SatVibMap = self:Create("ImageLabel", { Name = "SatVibMap", Parent = PickerFrame, Size = UDim2.new(0, 150, 0, 150), Position = UDim2.new(0, 15, 0, 35), Image = "rbxassetid://4155801252", BackgroundColor3 = Color3.fromHSV(h, 1, 1), ZIndex = 3001 }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 4)}) })
    local MapKnob = self:Create("Frame", { Name = "MapKnob", Parent = SatVibMap, Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(s, 0, 1-v, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 3002 }, { self:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), self:Create("UIStroke", {Thickness = 1.5, Color = Color3.new(0,0,0)}) })
    local HueBar = self:Create("Frame", { Name = "HueBar", Parent = PickerFrame, Size = UDim2.new(0, 15, 0, 150), Position = UDim2.new(0, 180, 0, 35), ZIndex = 3001 }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 4)}) })
    local HueGradient = self:Create("UIGradient", { Parent = HueBar, Rotation = 90, Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)), ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)), ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)), ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)), ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)), ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)), ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)) }) })
    local HueKnob = self:Create("Frame", { Name = "HueKnob", Parent = HueBar, Size = UDim2.new(1, 4, 0, 4), Position = UDim2.new(0.5, 0, h, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 3002 }, { self:Create("UIStroke", {Thickness = 1, Color = Color3.new(0,0,0)}) })
    local HexBox = self:Create("TextBox", { Name = "HexBox", Parent = PickerFrame, Size = UDim2.new(1, -30, 0, 28), Position = UDim2.new(0, 15, 0, 195), BackgroundColor3 = theme.Secondary, Text = "#" .. defaultColor:ToHex(), TextColor3 = theme.Text, Font = Enum.Font.GothamMedium, TextSize = 11, ZIndex = 3001 }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 4)}) })
    local function update() selectedColor = Color3.fromHSV(h, s, v); SatVibMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1); MapKnob.Position = UDim2.new(s, 0, 1-v, 0); HueKnob.Position = UDim2.new(0.5, 0, h, 0); HexBox.Text = "#" .. selectedColor:ToHex() end
    local mapDragging, hueDragging = false, false
    SatVibMap.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then mapDragging = true end end)
    HueBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then hueDragging = true end end)
    UserInputService.InputChanged:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then if mapDragging then local pos = Vector2.new(input.Position.X - SatVibMap.AbsolutePosition.X, input.Position.Y - SatVibMap.AbsolutePosition.Y); s = math.clamp(pos.X / SatVibMap.AbsoluteSize.X, 0, 1); v = 1 - math.clamp(pos.Y / SatVibMap.AbsoluteSize.Y, 0, 1); update() elseif hueDragging then local pos = input.Position.Y - HueBar.AbsolutePosition.Y; h = math.clamp(pos / HueBar.AbsoluteSize.Y, 0, 1); update() end end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then mapDragging = false; hueDragging = false end end)
    local ApplyBtn = self:Create("TextButton", { Parent = PickerFrame, Size = UDim2.new(1, -30, 0, 30), Position = UDim2.new(0.5, 0, 1, -10), AnchorPoint = Vector2.new(0.5, 1), BackgroundColor3 = theme.Accent, Text = "Apply Color", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 12, ZIndex = 3001 }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 4)}) })
    ApplyBtn.MouseButton1Click:Connect(function() callback(selectedColor); PickerFrame:Destroy() end); update()
end

-- // --- ULTIMATE WELCOME SPLASH SYSTEM --- // --
function DeusUI:Welcome(config)
    local theme = self.Themes[self.CurrentTheme]
    local SplashGui = self:Create("ScreenGui", { Name = "DeusWelcome", Parent = (gethui and gethui()) or CoreGui })
    
    local MainFrame = self:Create("CanvasGroup", {
        Name = "SplashMain",
        Parent = SplashGui,
        Size = config.Size or UDim2.new(0, 300, 0, 300),
        Position = config.Position or UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = config.Background or theme.Main,
        BackgroundTransparency = config.Transparency or 0,
        GroupTransparency = 1,
        ClipsDescendants = true
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, config.CornerRadius or 15)}),
        self:Create("UIStroke", {Color = config.StrokeColor or theme.Accent, Thickness = config.StrokeThickness or 2, Transparency = 0.5}),
        self:Create("UIScale", {Scale = 0.8})
    })

    if config.Image then
        self:Create("ImageLabel", {
            Name = "BGImage",
            Parent = MainFrame,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = config.Image,
            ScaleType = Enum.ScaleType.Crop,
            ZIndex = 0,
            ImageTransparency = config.ImageTransparency or 0.4
        })
    end

    if config.Icon ~= false then
        self:Create("ImageLabel", {
            Name = "Logo",
            Parent = MainFrame,
            Size = config.IconSize or UDim2.new(0, 80, 0, 80),
            Position = config.IconPosition or UDim2.new(0.5, 0, 0.4, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = self:GetIcon(config.Icon or "shield-check"),
            ImageColor3 = config.IconColor or theme.Accent,
            ZIndex = 2
        })
    end

    self:Create("TextLabel", {
        Name = "Title",
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 30),
        Position = config.TitlePosition or UDim2.new(0, 0, 0.65, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "DEUS EVOLUTION",
        TextColor3 = config.TitleColor or theme.Text,
        TextSize = config.TitleSize or 22,
        Font = Enum.Font.GothamBold,
        ZIndex = 2
    })

    self:Create("TextLabel", {
        Name = "Desc",
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 0, 20),
        Position = config.DescPosition or UDim2.new(0, 0, 0.75, 0),
        BackgroundTransparency = 1,
        Text = config.Desc or "Initializing system components...",
        TextColor3 = config.DescColor or theme.TextSecondary,
        TextSize = config.DescSize or 12,
        Font = Enum.Font.GothamMedium,
        ZIndex = 2
    })

    if config.ShowProgress ~= false then
        local BarBG = self:Create("Frame", {
            Name = "BarBG",
            Parent = MainFrame,
            Size = config.BarSize or UDim2.new(0.8, 0, 0, 4),
            Position = config.BarPosition or UDim2.new(0.5, 0, 0.9, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = theme.ChannelBG,
            ZIndex = 2
        }, { self:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })

        local BarFill = self:Create("Frame", {
            Name = "Fill",
            Parent = BarBG,
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = config.BarColor or theme.Accent,
            ZIndex = 3
        }, { self:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
        
        self:Tween(BarFill, TweenInfo.new(config.Duration or 3, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
    end

    self:Tween(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {GroupTransparency = 0})
    self:Tween(MainFrame.UIScale, TweenInfo.new(0.9, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})

    if MainFrame:FindFirstChild("Logo") then
        task.delay(0.4, function()
            local logo = MainFrame.Logo
            task.spawn(function()
                for i = 1, 3 do
                    self:Tween(logo, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = 8})
                    task.wait(0.6)
                    self:Tween(logo, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = -8})
                    task.wait(0.6)
                end
                self:Tween(logo, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Rotation = 0})
            end)
        end)
    end

    task.wait((config.Duration or 3) + 0.5)

    if MainFrame:FindFirstChild("Logo") then
        self:Tween(MainFrame.Logo, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    end
    task.wait(0.2)
    self:Tween(MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {GroupTransparency = 1})
    self:Tween(MainFrame.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0.6})

    task.wait(0.7)
    SplashGui:Destroy()
end

-- // --- PRO ESP SYSTEM --- // --
local function CreateESP(plr)
    if plr == Players.LocalPlayer then return end
    local Objects = { Lines = {}, Highlight = nil, NameTag = nil }
    for i = 1, 8 do local l = Drawing.new("Line"); l.Visible = false; l.Transparency = 1; l.Thickness = 1.5; l.Color = DeusUI.ESP.Color; table.insert(Objects.Lines, l) end
    local function Cleanup() for _, l in pairs(Objects.Lines) do l:Remove() end; if Objects.Highlight then Objects.Highlight:Destroy() end; if Objects.NameTag then Objects.NameTag:Destroy() end; DeusUI.ESP.Objects[plr] = nil end
    local connection; connection = RunService.RenderStepped:Connect(function()
        if not DeusUI.ESP.Enabled or not plr.Parent or (DeusUI.ESP.TargetPlayer and DeusUI.ESP.TargetPlayer ~= plr) then
            for _, l in pairs(Objects.Lines) do l.Visible = false end; if Objects.Highlight then Objects.Highlight.Enabled = false end; if Objects.NameTag then Objects.NameTag.Enabled = false end; if not plr.Parent then connection:Disconnect(); Cleanup() end; return
        end
        local char = plr.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChild("Humanoid")
        if char and hrp and hum and hum.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen and DeusUI.ESP.CornerBoxes then
                local size = (Camera.CFrame.Position - hrp.Position).Magnitude; local offset = math.clamp(1/size * 750, 2, 30); local sX, sY = 2.5, 4.5
                local TL = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(sX, sY, 0)).p); local TR = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(-sX, sY, 0)).p); local BL = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(sX, -sY, 0)).p); local BR = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(-sX, -sY, 0)).p)
                for _, line in pairs(Objects.Lines) do line.Color = DeusUI.ESP.Color; line.Visible = true end
                Objects.Lines[1].From = Vector2.new(TL.X, TL.Y); Objects.Lines[1].To = Vector2.new(TL.X + offset, TL.Y)
                Objects.Lines[2].From = Vector2.new(TL.X, TL.Y); Objects.Lines[2].To = Vector2.new(TL.X, TL.Y + offset)
                Objects.Lines[3].From = Vector2.new(TR.X, TR.Y); Objects.Lines[3].To = Vector2.new(TR.X - offset, TR.Y)
                Objects.Lines[4].From = Vector2.new(TR.X, TR.Y); Objects.Lines[4].To = Vector2.new(TR.X, TR.Y + offset)
                Objects.Lines[5].From = Vector2.new(BL.X, BL.Y); Objects.Lines[5].To = Vector2.new(BL.X + offset, BL.Y)
                Objects.Lines[6].From = Vector2.new(BL.X, BL.Y); Objects.Lines[6].To = Vector2.new(BL.X, BL.Y - offset)
                Objects.Lines[7].From = Vector2.new(BR.X, BR.Y); Objects.Lines[7].To = Vector2.new(BR.X - offset, BR.Y)
                Objects.Lines[8].From = Vector2.new(BR.X, BR.Y); Objects.Lines[8].To = Vector2.new(BR.X, BR.Y - offset)
            else for _, l in pairs(Objects.Lines) do l.Visible = false end end
            if DeusUI.ESP.Highlights then if not Objects.Highlight then Objects.Highlight = Instance.new("Highlight", (gethui and gethui()) or CoreGui); Objects.Highlight.Adornee = char end; Objects.Highlight.Enabled = true; Objects.Highlight.FillColor = DeusUI.ESP.Color; Objects.Highlight.OutlineColor = Color3.new(1,1,1)
            elseif Objects.Highlight then Objects.Highlight.Enabled = false end
            if DeusUI.ESP.Names then if not Objects.NameTag then local bg = Instance.new("BillboardGui", (gethui and gethui()) or CoreGui); bg.Size = UDim2.new(0, 200, 0, 50); bg.AlwaysOnTop = true; bg.ExtentsOffset = Vector3.new(0, 3, 0); local l = Instance.new("TextLabel", bg); l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1, 1, 1); l.TextStrokeTransparency = 0; l.Font = Enum.Font.GothamBold; l.TextSize = 14; Objects.NameTag = bg end; Objects.NameTag.Adornee = char; Objects.NameTag.Enabled = true; Objects.NameTag.TextLabel.Text = plr.DisplayName .. " [" .. math.floor(hum.Health) .. "]"; Objects.NameTag.TextLabel.TextColor3 = DeusUI.ESP.Color
            elseif Objects.NameTag then Objects.NameTag.Enabled = false end
        else for _, l in pairs(Objects.Lines) do l.Visible = false end; if Objects.Highlight then Objects.Highlight.Enabled = false end; if Objects.NameTag then Objects.NameTag.Enabled = false end end
    end)
    DeusUI.ESP.Objects[plr] = Objects
end
for _, plr in pairs(Players:GetPlayers()) do CreateESP(plr) end
Players.PlayerAdded:Connect(CreateESP)

-- // --- UI FRAMEWORK FUNCTIONS --- // --
function DeusUI:UpdateUI()
    local theme = self.Themes[self.CurrentTheme]; local TI = TweenInfo.new(0.4, Enum.EasingStyle.Quart)
    for _, data in pairs(self.Elements) do
        local inst = data.Instance; if not inst or not inst.Parent then continue end
        if data.Type == "MainFrame" then self:Tween(inst, TI, {BackgroundColor3 = theme.Main, BackgroundTransparency = theme.Transparency})
        elseif data.Type == "Sidebar" then self:Tween(inst, TI, {BackgroundColor3 = theme.Secondary, BackgroundTransparency = theme.Transparency})
        elseif data.Type == "Topbar" then if inst:FindFirstChild("TabTitle") then self:Tween(inst.TabTitle, TI, {TextColor3 = theme.Text}) end
        elseif data.Type == "TabBtn" then
            local targetText = data.Selected and theme.Text or theme.TextSecondary; self:Tween(inst.Content.Label, TI, {TextColor3 = targetText}); if inst.Content:FindFirstChild("Icon") then self:Tween(inst.Content.Icon, TI, {ImageColor3 = targetText}) end
            if data.Selected then self:Tween(inst, TI, {BackgroundColor3 = theme.Main, BackgroundTransparency = theme.Transparency}); self:Tween(inst.Indicator, TI, {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0})
            else self:Tween(inst, TI, {BackgroundTransparency = 1}); self:Tween(inst.Indicator, TI, {BackgroundTransparency = 1}) end
        elseif data.Type == "Button" then self:Tween(inst, TI, {BackgroundColor3 = theme.Accent})
        elseif data.Type == "ToggleSwitch" then self:Tween(inst, TI, {BackgroundColor3 = data.Toggled and theme.Success or Color3.fromRGB(128, 132, 142)})
        elseif data.Type == "SliderFill" then self:Tween(inst, TI, {BackgroundColor3 = theme.Accent})
        elseif data.Type == "SectionText" then self:Tween(inst, TI, {TextColor3 = theme.Accent})
        elseif data.Type == "TextColor" then self:Tween(inst, TI, {TextColor3 = theme.Text})
        elseif data.Type == "SecondaryBG" then self:Tween(inst, TI, {BackgroundColor3 = theme.ChannelBG, BackgroundTransparency = theme.Transparency}) end
    end
end

function DeusUI:Notify(config)
    local theme = self.Themes[self.CurrentTheme]
    if not self.NotifyGui then
        self.NotifyGui = self:Create("ScreenGui", { Name = "DeusNotifications", Parent = (gethui and gethui()) or CoreGui })
        self.NotifyHolder = self:Create("Frame", { Name = "Holder", Parent = self.NotifyGui, Size = UDim2.new(0, 300, 1, -20), Position = UDim2.new(1, -310, 0, 10), BackgroundTransparency = 1 }, {
            self:Create("UIListLayout", {VerticalAlignment = "Bottom", Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})
        })
    end
    local iconId = config.Icon and self:GetIcon(config.Icon) or nil
    local typeColor = config.Type == "success" and theme.Success or config.Type == "error" and theme.Danger or theme.Accent
    local Toast = self:Create("CanvasGroup", { Name = "Toast", Parent = self.NotifyHolder, Size = UDim2.new(1, 0, 0, 68), BackgroundColor3 = theme.ChannelBG, ClipsDescendants = true, GroupTransparency = 1 }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        self:Create("UIStroke", {Color = typeColor, Transparency = 0.6, Thickness = 1}),
        self:Create("Frame", { Name = "AccentLine", Size = UDim2.new(0, 3, 1, -12), Position = UDim2.new(0, 8, 0, 6), BackgroundColor3 = typeColor, ZIndex = 3 }, { self:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) }),
        iconId and self:Create("ImageLabel", { Name = "Icon", Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 20, 0, 12), BackgroundTransparency = 1, Image = iconId, ImageColor3 = typeColor, ZIndex = 3 }) or nil,
        self:Create("TextLabel", { Name = "Title", Text = config.Title or "Notification", Size = UDim2.new(1, -45, 0, 20), Position = UDim2.new(0, iconId and 44 or 20, 0, 10), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = "Left", ZIndex = 3 }),
        self:Create("TextLabel", { Name = "Content", Text = config.Content or "", Size = UDim2.new(1, -45, 0, 22), Position = UDim2.new(0, iconId and 44 or 20, 0, 30), BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, TextSize = 11, Font = Enum.Font.GothamMedium, TextWrapped = true, TextXAlignment = "Left", ZIndex = 3 }),
        self:Create("Frame", { Name = "Progress", Size = UDim2.new(1, -16, 0, 2), Position = UDim2.new(0, 8, 1, -6), BackgroundColor3 = typeColor, BackgroundTransparency = 0.3, ZIndex = 3 }, { self:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
    })
    Toast.Position = UDim2.new(1.2, 0, 0, 0)
    self:Tween(Toast, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {GroupTransparency = 0})
    self:Tween(Toast, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
    local dur = config.Duration or 4
    self:Tween(Toast.Progress, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)})
    task.delay(dur, function()
        if Toast and Toast.Parent then
            self:Tween(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {GroupTransparency = 1})
            self:Tween(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1.2, 0, 0, 0)})
            task.wait(0.45)
            Toast:Destroy()
        end
    end)
end

function DeusUI:CreateWindow(config)
    local theme = self.Themes[self.CurrentTheme]; local ScreenGui = self:Create("ScreenGui", { Name = "DeusDiscordUI", Parent = (gethui and gethui()) or CoreGui, ResetOnSpawn = false }); self.ScreenGui = ScreenGui; self.Elements = {}
    local WindowSize = UDim2.new(0, 520, 0, 380); local MainFrame = self:Create("CanvasGroup", { Name = "MainFrame", Parent = ScreenGui, BackgroundColor3 = theme.Main, Position = UDim2.new(0.5, -260, 0.5, -190), Size = WindowSize, ClipsDescendants = true, ZIndex = 1, GroupTransparency = 0 }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 12)}), self:Create("UIStroke", {Color = theme.Outline, Transparency = 0.3, Thickness = 1.2}), self:Create("UIScale", {Scale = 1}) }); self.MainFrame = MainFrame; self.UIScale = MainFrame.UIScale; table.insert(self.Elements, {Instance = MainFrame, Type = "MainFrame"})
    local Sidebar = self:Create("Frame", { Name = "Sidebar", Parent = MainFrame, Size = UDim2.new(0, 150, 1, 0), BackgroundColor3 = theme.Secondary, ZIndex = 2 }, { 
        self:Create("UICorner", {CornerRadius = UDim.new(0, 12)}), 
        self:Create("Frame", {
            Name = "Header", 
            Size = UDim2.new(1, 0, 0, 48), 
            BackgroundTransparency = 1, 
            ZIndex = 3
        }, { 
            self:Create("ImageLabel", { Name = "Logo", Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(0, 10, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = self:GetIcon("hexagon"), ImageColor3 = theme.Accent, ZIndex = 5 }),
            self:Create("TextLabel", {Text = config.Title or "DEUS", Size = UDim2.new(1, -46, 1, 0), Position = UDim2.new(0, 44, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = "Left", ZIndex = 5})
        })
    }); table.insert(self.Elements, {Instance = Sidebar, Type = "Sidebar"})
    local TabContainer = self:Create("ScrollingFrame", { 
        Name = "TabScroll", 
        Parent = Sidebar, 
        Size = UDim2.new(1, 0, 1, -48), 
        Position = UDim2.new(0, 0, 0, 48), 
        BackgroundTransparency = 1, 
        ScrollBarThickness = 0, 
        AutomaticCanvasSize = Enum.AutomaticSize.Y, 
        CanvasSize = UDim2.new(0,0,0,0), 
        ZIndex = 3 
    }, { 
        self:Create("UIListLayout", {Padding = UDim.new(0, 4), HorizontalAlignment = "Center", SortOrder = Enum.SortOrder.LayoutOrder}), 
        self:Create("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 4)}) 
    }); 
    local PageContainer = self:Create("Frame", { Name = "PageContainer", Parent = MainFrame, Size = UDim2.new(1, -160, 1, -54), Position = UDim2.new(0, 160, 0, 52), BackgroundTransparency = 1, ZIndex = 2, ClipsDescendants = true }); 
    local Topbar = self:Create("Frame", { Name = "Topbar", Parent = MainFrame, Size = UDim2.new(1, -160, 0, 36), Position = UDim2.new(0, 160, 0, 0), BackgroundColor3 = theme.Main, BackgroundTransparency = 0.5, ZIndex = 3 }, { 
        self:Create("UICorner", {CornerRadius = UDim.new(0, 0)}),
        self:Create("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = theme.Outline, BackgroundTransparency = 0.6, ZIndex = 4}), 
        self:Create("TextLabel", {Name = "TabTitle", Text = "Home", Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 12, Font = Enum.Font.GothamBold, TextXAlignment = "Left", ZIndex = 4})
    }); table.insert(self.Elements, {Instance = Topbar, Type = "Topbar"})
    local function CreateControlButton(name, text, color) local btn = self:Create("TextButton", { Name = name, Size = UDim2.new(0, 22, 0, 22), BackgroundTransparency = 1, Text = text, TextColor3 = theme.TextSecondary, TextSize = (text == "×") and 18 or 14, Font = Enum.Font.GothamBold, ZIndex = 101, AutoButtonColor = false }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 4)}) }); btn.MouseEnter:Connect(function() self:Tween(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, BackgroundColor3 = color or Color3.fromRGB(200, 200, 200), TextColor3 = Color3.new(1,1,1)}) end); btn.MouseLeave:Connect(function() self:Tween(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = self.Themes[self.CurrentTheme].TextSecondary}) end); return btn end
    local MinBtn = CreateControlButton("Min", "—"); local CloseBtn = CreateControlButton("Close", "×", Color3.fromRGB(255, 60, 60)); local Controls = self:Create("Frame", { Name = "Controls", Parent = Topbar, Size = UDim2.new(0, 65, 1, 0), Position = UDim2.new(1, -5, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, ZIndex = 100 }, { self:Create("UIListLayout", { FillDirection = "Horizontal", Padding = UDim.new(0, 5), VerticalAlignment = "Center", HorizontalAlignment = "Right" }) }); MinBtn.Parent = Controls; CloseBtn.Parent = Controls; MinBtn.MouseButton1Click:Connect(function() 
        local isMin = MainFrame.Size.Y.Offset < 100
        self:Tween(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = isMin and WindowSize or UDim2.new(0, 500, 0, 48)})
        Sidebar.Visible = isMin
        PageContainer.Visible = isMin
    end); CloseBtn.MouseButton1Click:Connect(function() self:Tween(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {GroupTransparency = 1}); self:Tween(self.UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0.7}); task.delay(0.45, function() ScreenGui:Destroy() end) end)
    local dragging, dragStart, startPos; Topbar.InputBegan:Connect(function(input) if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then dragging = true; dragStart = input.Position; startPos = MainFrame.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end); UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    local OrderTracker = 0; local WindowMethods = {}
    function WindowMethods:SidebarSection(title) 
        OrderTracker = OrderTracker + 1
        local Sec = DeusUI:Create("Frame", { Name = "Section_" .. title, Parent = TabContainer, Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = OrderTracker, ZIndex = 4 }, { 
            DeusUI:Create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingTop = UDim.new(0, 8)}),
            DeusUI:Create("TextLabel", { Name = "Title", Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1, Text = title:upper(), TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent, TextSize = 10, Font = Enum.Font.GothamBold, TextXAlignment = "Left", ZIndex = 5 }),
            DeusUI:Create("Frame", { Name = "Line", Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Outline, BackgroundTransparency = 0.7, ZIndex = 5 })
        })
        table.insert(DeusUI.Elements, {Instance = Sec, Type = "SectionText"})
        return Sec 
    end
    function WindowMethods:Tab(tabConfig)
        OrderTracker = OrderTracker + 1; local Page = DeusUI:Create("ScrollingFrame", { Parent = PageContainer, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = theme.Outline, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0,0,0,0), ZIndex = 3 }, { DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 8), HorizontalAlignment = "Center"}), DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}) }); local tabTitle = tabConfig.Title or "Tab"; local tabIcon = DeusUI:GetIcon(tabConfig.Icon)
        local TabBtn = DeusUI:Create("TextButton", { Parent = TabContainer, Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 4, LayoutOrder = OrderTracker }, { 
            DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), 
            DeusUI:Create("Frame", { 
                Name = "Indicator", 
                Size = UDim2.new(0, 3, 0, 0), 
                Position = UDim2.new(0, -4, 0.5, 0), 
                AnchorPoint = Vector2.new(0, 0.5), 
                BackgroundColor3 = theme.Accent, 
                BackgroundTransparency = 1, 
                ZIndex = 5 
            }, { 
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) 
            }), 
            DeusUI:Create("Frame", { 
                Name = "Content", 
                Size = UDim2.new(1, 0, 1, 0), 
                BackgroundTransparency = 1, 
                ZIndex = 5 
            }, { 
                DeusUI:Create("UIListLayout", { FillDirection = "Horizontal", VerticalAlignment = "Center", Padding = UDim.new(0, 8), HorizontalAlignment = "Left" }), 
                DeusUI:Create("UIPadding", {PaddingLeft = UDim.new(0, 10)}), 
                tabIcon and DeusUI:Create("ImageLabel", { Name = "Icon", Size = UDim2.new(0, 16, 0, 16), BackgroundTransparency = 1, Image = tabIcon, ImageColor3 = theme.TextSecondary, ZIndex = 6 }) or nil, 
                DeusUI:Create("TextLabel", { Name = "Label", Text = tabTitle, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = "X", BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, TextSize = 11, Font = Enum.Font.GothamMedium, ZIndex = 6 }) 
            }) 
        }) 
            }), 
            self:Create("Frame", { 
                Name = "Content", 
                Size = UDim2.new(1, 0, 1, 0), 
                BackgroundTransparency = 1, 
                ZIndex = 5 
            }, { 
                self:Create("UIListLayout", { FillDirection = "Horizontal", VerticalAlignment = "Center", Padding = UDim.new(0, 8), HorizontalAlignment = "Left" }), 
                self:Create("UIPadding", {PaddingLeft = UDim.new(0, 10)}), 
                tabIcon and self:Create("ImageLabel", { Name = "Icon", Size = UDim2.new(0, 16, 0, 16), BackgroundTransparency = 1, Image = tabIcon, ImageColor3 = theme.TextSecondary, ZIndex = 6 }) or nil, 
                self:Create("TextLabel", { Name = "Label", Text = tabTitle, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = "X", BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, TextSize = 11, Font = Enum.Font.GothamMedium, ZIndex = 6 }) 
            }) 
        })
        })
        local tabData = {Type = "TabBtn", Instance = TabBtn, Selected = false}; table.insert(DeusUI.Elements, tabData)
        local function SetTabState(state) 
            tabData.Selected = state; 
            local cur = DeusUI.Themes[DeusUI.CurrentTheme]
            local targetText = state and cur.Text or cur.TextSecondary
            local targetIcon = state and cur.Accent or cur.TextSecondary
            DeusUI:Tween(TabBtn.Content.Label, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {TextColor3 = targetText})
            if TabBtn.Content:FindFirstChild("Icon") then 
                DeusUI:Tween(TabBtn.Content.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {ImageColor3 = targetIcon}) 
            end
            if state then 
                DeusUI:Tween(TabBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 0, BackgroundColor3 = cur.Main})
                TabBtn.Indicator.BackgroundTransparency = 0
                DeusUI:Tween(TabBtn.Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 3, 0, 20)})
            else 
                DeusUI:Tween(TabBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
                TabBtn.Indicator.BackgroundTransparency = 1
                DeusUI:Tween(TabBtn.Indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 3, 0, 0)})
            end 
        end
        TabBtn.MouseEnter:Connect(function() 
            if not tabData.Selected then 
                local cur = DeusUI.Themes[DeusUI.CurrentTheme]
                DeusUI:Tween(TabBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.7, BackgroundColor3 = cur.ChannelBG})
                DeusUI:Tween(TabBtn.Content.Label, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {TextColor3 = cur.Text})
                if TabBtn.Content:FindFirstChild("Icon") then DeusUI:Tween(TabBtn.Content.Icon, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {ImageColor3 = cur.Text}) end
            end 
        end)
        TabBtn.MouseLeave:Connect(function() 
            if not tabData.Selected then 
                local cur = DeusUI.Themes[DeusUI.CurrentTheme]
                DeusUI:Tween(TabBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
                DeusUI:Tween(TabBtn.Content.Label, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {TextColor3 = cur.TextSecondary})
                if TabBtn.Content:FindFirstChild("Icon") then DeusUI:Tween(TabBtn.Content.Icon, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {ImageColor3 = cur.TextSecondary}) end
            end 
        end)
        TabBtn.MouseButton1Click:Connect(function() 
            for _, p in pairs(PageContainer:GetChildren()) do 
                if p:IsA("ScrollingFrame") then p.Visible = false end 
            end
            for _, el in pairs(DeusUI.Elements) do 
                if el.Type == "TabBtn" then 
                    el.Selected = false
                    local eInst = el.Instance
                    DeusUI:Tween(eInst, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
                    if eInst:FindFirstChild("Indicator") then
                        eInst.Indicator.BackgroundTransparency = 1
                        DeusUI:Tween(eInst.Indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 3, 0, 0)})
                    end
                    if eInst.Content and eInst.Content:FindFirstChild("Label") then
                        DeusUI:Tween(eInst.Content.Label, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].TextSecondary})
                        if eInst.Content:FindFirstChild("Icon") then DeusUI:Tween(eInst.Content.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {ImageColor3 = DeusUI.Themes[DeusUI.CurrentTheme].TextSecondary}) end
                    end
                end 
            end
            Page.Visible = true
            SetTabState(true)
            Topbar.TabTitle.Text = tabTitle
        end)
        if not DeusUI.SelectedTab then DeusUI.SelectedTab = true; Page.Visible = true; SetTabState(true); Topbar.TabTitle.Text = tabTitle end
        local TabMethods = {}
        function TabMethods:Section(title) local Sec = DeusUI:Create("TextLabel", { Parent = Page, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = title:upper(), TextColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent, TextSize = 10, Font = Enum.Font.GothamBold, TextXAlignment = "Left", ZIndex = 4 }); table.insert(DeusUI.Elements, {Instance = Sec, Type = "SectionText"}); return Sec end
        function TabMethods:Button(btnConfig) local Button = DeusUI:Create("TextButton", { Parent = Page, Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = DeusUI.Themes[DeusUI.CurrentTheme].Accent, Text = btnConfig.Title or "Button", TextColor3 = Color3.new(1,1,1), TextSize = 11, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 4 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}) }); table.insert(DeusUI.Elements, {Instance = Button, Type = "Button"}); Button.MouseButton1Click:Connect(function() btnConfig.Callback() end) end
        function TabMethods:Toggle(tConfig)
            local toggled = tConfig.Default or false; local current = DeusUI.Themes[DeusUI.CurrentTheme]; local ToggleFrame = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, ZIndex = 4 }, { DeusUI:Create("TextLabel", {Name = "T", Text = tConfig.Title or "Toggle", BackgroundTransparency = 1, TextColor3 = current.Text, TextSize = 12, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -45, 1, 0), TextXAlignment = "Left", ZIndex = 5}) }); table.insert(DeusUI.Elements, {Instance = ToggleFrame.T, Type = "TextColor"}); local Switch = DeusUI:Create("TextButton", { Parent = ToggleFrame, Size = UDim2.new(0, 32, 0, 16), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = toggled and current.Success or Color3.fromRGB(128, 132, 142), Text = "", ZIndex = 5 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) }); local Circle = DeusUI:Create("Frame", { Parent = Switch, Size = UDim2.new(0, 12, 0, 12), Position = toggled and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), AnchorPoint = toggled and Vector2.new(1, 0.5) or Vector2.new(0, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 6 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) }); local tData = {Instance = Switch, Type = "ToggleSwitch", Toggled = toggled}; table.insert(DeusUI.Elements, tData); Switch.MouseButton1Click:Connect(function() toggled = not toggled; tData.Toggled = toggled; DeusUI:Tween(Circle, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), AnchorPoint = toggled and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)}); DeusUI:Tween(Switch, TweenInfo.new(0.2), {BackgroundColor3 = toggled and DeusUI.Themes[DeusUI.CurrentTheme].Success or Color3.fromRGB(128, 132, 142)}); tConfig.Callback(toggled) end)
        end
        function TabMethods:Slider(sConfig)
            local min, max, val = sConfig.Min or 0, sConfig.Max or 100, sConfig.Default or 50; local current = DeusUI.Themes[DeusUI.CurrentTheme]; local SliderFrame = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, ZIndex = 4 }, { DeusUI:Create("TextLabel", {Name = "T", Text = sConfig.Title or "Slider", BackgroundTransparency = 1, TextColor3 = current.Text, TextSize = 11, Font = Enum.Font.GothamMedium, Size = UDim2.new(0.7, 0, 0, 14), TextXAlignment = "Left", ZIndex = 5}), DeusUI:Create("TextLabel", {Name = "Val", Text = tostring(val), BackgroundTransparency = 1, TextColor3 = current.TextSecondary, TextSize = 10, Font = Enum.Font.GothamBold, Size = UDim2.new(0.3, 0, 0, 14), Position = UDim2.new(0.7, 0, 0, 0), TextXAlignment = "Right", ZIndex = 5}) }); table.insert(DeusUI.Elements, {Instance = SliderFrame.T, Type = "TextColor"}); local Bar = DeusUI:Create("Frame", {Parent = SliderFrame, Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0, 24), BackgroundColor3 = current.ChannelBG, ZIndex = 5}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) }); table.insert(DeusUI.Elements, {Instance = Bar, Type = "SecondaryBG"}); local Fill = DeusUI:Create("Frame", {Parent = Bar, Size = UDim2.new((val-min)/(max-min), 0, 1, 0), BackgroundColor3 = current.Accent, ZIndex = 6}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) }); table.insert(DeusUI.Elements, {Instance = Fill, Type = "SliderFill"}); local Knob = DeusUI:Create("Frame", {Parent = Fill, Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 7}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), DeusUI:Create("UIStroke", {Color = current.Accent, Thickness = 1.5}) }); local dragging = false; local function update(input) local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1); val = math.floor(min + (max - min) * pos); SliderFrame.Val.Text = tostring(val); Fill.Size = UDim2.new(pos, 0, 1, 0); sConfig.Callback(val) end; Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; update(input) end end); UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end); UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
        end
        function TabMethods:Dropdown(dConfig)
            local dValues = dConfig.Values or {}; local selected = dConfig.Default or "Select..."; local opened = false; local current = DeusUI.Themes[DeusUI.CurrentTheme]; local DropdownFrame = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = current.ChannelBG, ClipsDescendants = true, ZIndex = 4 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), DeusUI:Create("UIStroke", {Color = current.Outline, Transparency = 0.5}) }); table.insert(DeusUI.Elements, {Instance = DropdownFrame, Type = "SecondaryBG"}); local Header = DeusUI:Create("TextButton", {Parent = DropdownFrame, Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Text = "", ZIndex = 5}); local Title = DeusUI:Create("TextLabel", {Text = dConfig.Title or "Dropdown", Parent = Header, Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, TextColor3 = current.Text, Font = Enum.Font.GothamMedium, TextSize = 11, TextXAlignment = "Left", ZIndex = 6}); table.insert(DeusUI.Elements, {Instance = Title, Type = "TextColor"}); local SelText = DeusUI:Create("TextLabel", {Text = selected, Parent = Header, Size = UDim2.new(0, 100, 1, 0), Position = UDim2.new(1, -25, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, TextColor3 = current.TextSecondary, Font = Enum.Font.Gotham, TextSize = 10, TextXAlignment = "Right", ZIndex = 6}); local Arrow = DeusUI:Create("TextLabel", {Text = "▼", Parent = Header, Size = UDim2.new(0, 15, 1, 0), Position = UDim2.new(1, -5, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, TextColor3 = current.TextSecondary, Font = Enum.Font.Gotham, TextSize = 8, ZIndex = 6}); local OptionHolder = DeusUI:Create("ScrollingFrame", {Parent = DropdownFrame, Size = UDim2.new(1, 0, 0, 120), Position = UDim2.new(0, 0, 0, 32), BackgroundTransparency = 1, ScrollBarThickness = 2, AutomaticCanvasSize = "Y", Visible = false, ZIndex = 10}, { DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 2)}) }); local function Refresh() for _, child in pairs(OptionHolder:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end; local list = (type(dValues) == "function") and dValues() or dValues; for _, v in pairs(list) do local isPlayer = typeof(v) == "Instance" and v:IsA("Player"); local displayName = isPlayer and v.DisplayName or tostring(v); local btn = DeusUI:Create("TextButton", { Parent = OptionHolder, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "", ZIndex = 11 }, { DeusUI:Create("TextLabel", { Text = displayName, Size = UDim2.new(1, isPlayer and -40 or -20, 1, 0), Position = UDim2.new(0, isPlayer and 35 or 10, 0, 0), BackgroundTransparency = 1, TextColor3 = current.TextSecondary, Font = Enum.Font.Gotham, TextSize = 10, TextXAlignment = "Left", ZIndex = 12 }) }); if isPlayer then local thumb = DeusUI:Create("ImageLabel", { Parent = btn, Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 8, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Image = Players:GetUserThumbnailAsync(v.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48), ZIndex = 12 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) }) end; btn.MouseButton1Click:Connect(function() selected = displayName; SelText.Text = displayName; opened = false; DeusUI:Tween(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 32)}); OptionHolder.Visible = false; dConfig.Callback(v) end) end end; Header.MouseButton1Click:Connect(function() opened = not opened; if opened then Refresh() end; DeusUI:Tween(DropdownFrame, TweenInfo.new(0.3), {Size = opened and UDim2.new(1, 0, 0, 152) or UDim2.new(1, 0, 0, 32)}); OptionHolder.Visible = opened end)
        end
        function TabMethods:Colorpicker(cConfig)
            local currentTheme = DeusUI.Themes[DeusUI.CurrentTheme]; local current = cConfig.Default or currentTheme.Accent; local ColorFrame = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, ZIndex = 4 }, { DeusUI:Create("TextLabel", {Name = "T", Text = cConfig.Title or "Color", BackgroundTransparency = 1, TextColor3 = currentTheme.Text, TextSize = 11, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -40, 1, 0), TextXAlignment = "Left", ZIndex = 5}) }); table.insert(DeusUI.Elements, {Instance = ColorFrame.T, Type = "TextColor"}); local ColorView = DeusUI:Create("TextButton", { Parent = ColorFrame, Size = UDim2.new(0, 28, 0, 16), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = current, Text = "", ZIndex = 5 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), DeusUI:Create("UIStroke", {Color = currentTheme.Outline, Thickness = 1}) }); ColorView.MouseButton1Click:Connect(function() DeusUI:OpenColorPicker(current, function(nc) current = nc; ColorView.BackgroundColor3 = nc; cConfig.Callback(nc) end) end)
        end
        function TabMethods:Keybind(kConfig)
            local current = DeusUI.Themes[DeusUI.CurrentTheme]; local currentKey = kConfig.Default or Enum.KeyCode.F; local BindFrame = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, ZIndex = 4 }, { DeusUI:Create("TextLabel", {Name = "T", Text = kConfig.Title or "Keybind", BackgroundTransparency = 1, TextColor3 = current.Text, TextSize = 11, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -70, 1, 0), TextXAlignment = "Left", ZIndex = 5}) }); table.insert(DeusUI.Elements, {Instance = BindFrame.T, Type = "TextColor"}); local Btn = DeusUI:Create("TextButton", { Parent = BindFrame, Size = UDim2.new(0, 55, 0, 20), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = current.ChannelBG, Text = currentKey.Name, TextColor3 = current.Text, Font = Enum.Font.GothamBold, TextSize = 9, ZIndex = 5 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}), DeusUI:Create("UIStroke", {Color = current.Outline, Transparency = 0.5}) }); table.insert(DeusUI.Elements, {Instance = Btn, Type = "SecondaryBG"}); Btn.MouseButton1Click:Connect(function() Btn.Text = "..."; local connection; connection = UserInputService.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Keyboard then currentKey = input.KeyCode; Btn.Text = currentKey.Name; connection:Disconnect(); kConfig.Callback(currentKey) end end) end)
        end
        function TabMethods:Paragraph(pConfig) local current = DeusUI.Themes[DeusUI.CurrentTheme]; local ParaFrame = DeusUI:Create("Frame", { Parent = Page, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = "Y", BackgroundColor3 = current.ChannelBG, BackgroundTransparency = 0.5, ZIndex = 4 }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}), DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 4)}), DeusUI:Create("TextLabel", {Name = "T", Text = pConfig.Title or "Information", BackgroundTransparency = 1, TextColor3 = current.Accent, Font = Enum.Font.GothamBold, TextSize = 12, AutomaticSize = "XY", ZIndex = 5}), DeusUI:Create("TextLabel", {Name = "D", Text = pConfig.Desc or "", BackgroundTransparency = 1, TextColor3 = current.TextSecondary, Font = Enum.Font.Gotham, TextSize = 10, AutomaticSize = "Y", Size = UDim2.new(1, 0, 0, 0), TextWrapped = true, TextXAlignment = "Left", ZIndex = 5}) }); table.insert(DeusUI.Elements, {Instance = ParaFrame, Type = "SecondaryBG"}); table.insert(DeusUI.Elements, {Instance = ParaFrame.T, Type = "ParagraphTitle"}) end
        return TabMethods
    end
    function WindowMethods:Settings() 
        self:SidebarSection("Global Settings"); local SettingsTab = self:Tab({Title = "Settings", Icon = "settings"})
        SettingsTab:Section("ESP Player"); SettingsTab:Toggle({ Title = "Enable ESP", Default = false, Callback = function(s) DeusUI.ESP.Enabled = s end }); SettingsTab:Dropdown({ Title = "Target Player", Values = function() local p = Players:GetPlayers(); table.insert(p, 1, "All Players"); return p end, Default = "Choose Player...", Callback = function(p) if p == "All Players" then DeusUI.ESP.TargetPlayer = nil else DeusUI.ESP.TargetPlayer = p end end }); SettingsTab:Toggle({ Title = "Corner Boxes", Default = true, Callback = function(s) DeusUI.ESP.CornerBoxes = s end }); SettingsTab:Toggle({ Title = "Highlights", Default = true, Callback = function(s) DeusUI.ESP.Highlights = s end }); SettingsTab:Toggle({ Title = "Player Names", Default = true, Callback = function(s) DeusUI.ESP.Names = s end }); SettingsTab:Colorpicker({ Title = "ESP Color", Default = DeusUI.ESP.Color, Callback = function(c) DeusUI.ESP.Color = c end })
        SettingsTab:Section("UI Appearance"); local ThemeNames = {}; for name, _ in pairs(DeusUI.Themes) do table.insert(ThemeNames, name) end; SettingsTab:Dropdown({ Title = "Theme Presets", Values = ThemeNames, Default = DeusUI.CurrentTheme, Callback = function(t) DeusUI.CurrentTheme = t; DeusUI:UpdateUI() end }); SettingsTab:Slider({ Title = "Transparency", Min = 0, Max = 100, Default = 0, Callback = function(v) local val = v/100; for _, theme in pairs(DeusUI.Themes) do theme.Transparency = val end; DeusUI:UpdateUI() end })
        SettingsTab:Section("Danger Zone"); SettingsTab:Button({ Title = "Destroy UI", Callback = function() self.ScreenGui:Destroy() end }); return SettingsTab 
    end
    function DeusUI:CreateToggle(config)
        local theme = self.Themes[self.CurrentTheme]; local ToggleBtn = self:Create("TextButton", { Name = "DeusToggle", Parent = self.ScreenGui, Size = config.Size or UDim2.new(0, 40, 0, 40), Position = config.Position or UDim2.new(0.1, 0, 0.1, 0), BackgroundColor3 = config.Color or theme.Accent, Text = "", AutoButtonColor = true, ZIndex = 5000 }, { self:Create("UICorner", {CornerRadius = UDim.new(1, 0)}), self:Create("UIStroke", {Thickness = 2, Color = Color3.new(1,1,1), Transparency = 0.5}), config.Icon and self:Create("ImageLabel", { Size = UDim2.new(0.6, 0, 0.6, 0), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Image = self:GetIcon(config.Icon), ZIndex = 5001 }) or self:Create("TextLabel", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = config.Text or "UI", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 12, ZIndex = 5001 }) }); local isOpen = true; ToggleBtn.MouseButton1Click:Connect(function() if self.MainFrame and self.UIScale then isOpen = not isOpen; if not isOpen then self:Tween(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {GroupTransparency = 1}); self:Tween(self.UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0.8}); task.delay(0.4, function() if not isOpen then self.MainFrame.Visible = false end end) else self.MainFrame.Visible = true; self:Tween(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 0}); self:Tween(self.UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}) end end end); local dragging, dragStart, startPos; ToggleBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = ToggleBtn.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end); UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end); return ToggleBtn
    end
    return WindowMethods
end

return DeusUI

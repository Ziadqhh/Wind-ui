--[[ 
    Deus Evolution UI | Full Library Source
    Created by: Deus Mode (Gemini CLI)
    Version: 1.1.0
    Style: Modern Glassmorphism & Performance Focus
]]

local DeusUI = {
    Themes = {
        Dark = {
            Main = Color3.fromRGB(15, 15, 15),
            Secondary = Color3.fromRGB(20, 20, 20),
            Accent = Color3.fromRGB(0, 162, 255),
            Outline = Color3.fromRGB(255, 255, 255),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(160, 160, 160),
        }
    },
    CurrentTheme = "Dark",
    SelectedTab = nil
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
    for property, value in pairs(properties) do
        instance[property] = value
    end
    if children then
        for _, child in pairs(children) do
            child.Parent = instance
        end
    end
    return instance
end

function DeusUI:Tween(instance, info, propertyTable)
    local tween = TweenService:Create(instance, info, propertyTable)
    tween:Play()
    return tween
end

-- Main Window Function
function DeusUI:CreateWindow(config)
    local config = config or {}
    local Title = config.Title or "Deus Evolution"
    local theme = self.Themes[self.CurrentTheme]
    
    local ScreenGui = self:Create("ScreenGui", {
        Name = "DeusEvolutionUI",
        Parent = (gethui and gethui()) or CoreGui,
        ResetOnSpawn = false
    })
    
    local MainFrame = self:Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = theme.Main,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -275, 0.5, -175),
        Size = UDim2.new(0, 550, 0, 350),
        ClipsDescendants = true
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        self:Create("UIStroke", {Color = theme.Outline, Transparency = 0.85, Thickness = 1.2})
    })
    
    -- Topbar
    local Topbar = self:Create("Frame", {
        Name = "Topbar", Parent = MainFrame, Size = UDim2.new(1, 0, 0, 45), BackgroundTransparency = 1
    }, {
        self:Create("TextLabel", {
            Name = "Title", Text = Title, Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 15, 0, 0),
            BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 16, Font = Enum.Font.GothamBold, TextXAlignment = "Left"
        }),
        self:Create("Frame", {
            Name = "Separator", Size = UDim2.new(1, -30, 0, 1), Position = UDim2.new(0, 15, 1, 0),
            BackgroundColor3 = theme.Outline, BackgroundTransparency = 0.9, BorderSizePixel = 0
        })
    })
    
    -- Controls
    local Controls = self:Create("Frame", {
        Name = "Controls", Parent = Topbar, Size = UDim2.new(0, 70, 1, 0), Position = UDim2.new(1, -80, 0, 0), BackgroundTransparency = 1
    }, { self:Create("UIListLayout", {FillDirection = "Horizontal", Padding = UDim.new(0, 8), VerticalAlignment = "Center", HorizontalAlignment = "Right"}) })

    local Minimized = false
    local WindowSize = UDim2.new(0, 550, 0, 350)

    local MinBtn = self:Create("TextButton", {
        Name = "Min", Parent = Controls, Size = UDim2.new(0, 26, 0, 26), BackgroundColor3 = theme.Secondary,
        Text = "-", TextColor3 = theme.Text, TextSize = 18, Font = Enum.Font.GothamBold, AutoButtonColor = true
    }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), self:Create("UIStroke", {Color = theme.Outline, Transparency = 0.8}) })

    local CloseBtn = self:Create("TextButton", {
        Name = "Close", Parent = Controls, Size = UDim2.new(0, 26, 0, 26), BackgroundColor3 = Color3.fromRGB(180, 40, 40),
        Text = "×", TextColor3 = Color3.new(1, 1, 1), TextSize = 18, Font = Enum.Font.GothamBold, AutoButtonColor = true
    }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 6)}), self:Create("UIStroke", {Color = Color3.new(1, 1, 1), Transparency = 0.8}) })

    -- Sidebar & Containers
    local Sidebar = self:Create("Frame", {
        Name = "Sidebar", Parent = MainFrame, Size = UDim2.new(0, 160, 1, -95), Position = UDim2.new(0, 10, 0, 55),
        BackgroundColor3 = theme.Secondary, BackgroundTransparency = 0.4
    }, { self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}), self:Create("UIStroke", {Color = theme.Outline, Transparency = 0.9}) })

    local TabContainer = self:Create("ScrollingFrame", {
        Name = "TabScroll", Parent = Sidebar, Size = UDim2.new(1, -10, 1, -10), Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1, ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = "Y"
    }, { self:Create("UIListLayout", {Padding = UDim.new(0, 5), HorizontalAlignment = "Center"}) })

    local PageContainer = self:Create("Frame", {
        Name = "PageContainer", Parent = MainFrame, Size = UDim2.new(1, -190, 1, -95), Position = UDim2.new(0, 180, 0, 55),
        BackgroundTransparency = 1
    })

    -- Performance Bar (StatusBar)
    local StatusBar = self:Create("Frame", {
        Name = "StatusBar", Parent = MainFrame, Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 1, -30), BackgroundTransparency = 1
    }, {
        self:Create("TextLabel", {
            Name = "PerfText", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Text = "FPS: 60 | Ping: 0ms | Deus Evolution", TextColor3 = theme.TextSecondary,
            TextSize = 11, Font = Enum.Font.GothamMedium, TextXAlignment = "Right"
        })
    })

    -- Logic: Performance Updates
    task.spawn(function()
        local lastTime = tick()
        local frameCount = 0
        while MainFrame.Parent do
            frameCount = frameCount + 1
            if tick() - lastTime >= 1 then
                local ping = tonumber(string.format("%.0f", LocalPlayer:GetNetworkPing() * 1000)) or 0
                StatusBar.PerfText.Text = string.format("FPS: %d | Ping: %dms | Deus Evolution v1.1", frameCount, ping)
                frameCount = 0
                lastTime = tick()
            end
            task.wait()
        end
    end)

    -- Logic: Minimize & Close
    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        local targetSize = Minimized and UDim2.new(0, 550, 0, 45) or WindowSize
        DeusUI:Tween(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = targetSize})
        Sidebar.Visible = not Minimized
        PageContainer.Visible = not Minimized
        StatusBar.Visible = not Minimized
        Topbar.Separator.Visible = not Minimized
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        DeusUI:Tween(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 550, 0, 0), BackgroundTransparency = 1})
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    -- Dragging Logic (Enhanced for Mouse & Touch)
    local dragging, dragStart, startPos
    local function updateInput(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateInput(input)
        end
    end)

    -- Methods
    local Window = {}

    function Window:Tab(tabConfig)
        local tabTitle = tabConfig.Title or "Tab"
        local Page = DeusUI:Create("ScrollingFrame", {
            Name = tabTitle .. "Page", Parent = PageContainer, Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1, Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = "Y"
        }, { DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 8), HorizontalAlignment = "Center"}) })

        local TabBtn = DeusUI:Create("TextButton", {
            Name = tabTitle .. "Btn", Parent = TabContainer, Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = theme.Main, BackgroundTransparency = 0.8, Text = tabTitle,
            TextColor3 = theme.TextSecondary, TextSize = 14, Font = Enum.Font.GothamMedium, AutoButtonColor = false
        }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}) })

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(PageContainer:GetChildren()) do p.Visible = false end
            for _, b in pairs(TabContainer:GetChildren()) do if b:IsA("TextButton") then DeusUI:Tween(b, TweenInfo.new(0.3), {BackgroundColor3 = theme.Main, TextColor3 = theme.TextSecondary}) end end
            Page.Visible = true
            DeusUI:Tween(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = theme.Accent, TextColor3 = theme.Text})
        end)

        if not DeusUI.SelectedTab then DeusUI.SelectedTab = true Page.Visible = true TabBtn.BackgroundColor3 = theme.Accent TabBtn.TextColor3 = theme.Text end

        local Tab = {}

        -- Helper: Element Lock
        local function applyLock(frame, locked, msg)
            if locked then
                local Lock = DeusUI:Create("Frame", {
                    Name = "Lock", Parent = frame, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 0.5, ZIndex = 10
                }, { 
                    DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                    DeusUI:Create("TextLabel", {Text = "🔒 " .. (msg or "VIP"), Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 12})
                })
            end
        end

        function Tab:Button(btnConfig)
            local ButtonFrame = DeusUI:Create("Frame", {
                Name = "ButtonFrame", Parent = Page, Size = UDim2.new(0.95, 0, 0, 40), BackgroundColor3 = theme.Secondary, BackgroundTransparency = 0.3
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("UIStroke", {Color = theme.Outline, Transparency = 0.85, Thickness = 1.2}),
                DeusUI:Create("TextButton", {Name = "Btn", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = btnConfig.Title or "Button", TextColor3 = theme.Text, TextSize = 14, Font = Enum.Font.GothamBold})
            })
            ButtonFrame.Btn.MouseButton1Click:Connect(function() btnConfig.Callback() end)
            applyLock(ButtonFrame, btnConfig.Locked, btnConfig.LockMessage)
        end

        function Tab:Toggle(tConfig)
            local toggled = tConfig.Default or false
            local ToggleFrame = DeusUI:Create("Frame", {
                Name = "ToggleFrame", Parent = Page, Size = UDim2.new(0.95, 0, 0, 45), BackgroundColor3 = theme.Secondary, BackgroundTransparency = 0.4
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("UIStroke", {Color = theme.Outline, Transparency = 0.9}),
                DeusUI:Create("UIPadding", {PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15)}),
                DeusUI:Create("TextLabel", {Text = tConfig.Title or "Toggle", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 14, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -60, 1, 0), TextXAlignment = "Left"})
            })
            local Switch = DeusUI:Create("TextButton", {
                Name = "Switch", Parent = ToggleFrame, Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = toggled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50), Text = "", AutoButtonColor = false
            }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local Circle = DeusUI:Create("Frame", {
                Name = "Circle", Parent = Switch, Size = UDim2.new(0, 16, 0, 16), Position = toggled and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), AnchorPoint = toggled and Vector2.new(1, 0.5) or Vector2.new(0, 0.5), BackgroundColor3 = Color3.new(1, 1, 1)
            }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            Switch.MouseButton1Click:Connect(function()
                toggled = not toggled
                DeusUI:Tween(Circle, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), AnchorPoint = toggled and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)})
                DeusUI:Tween(Switch, TweenInfo.new(0.2), {BackgroundColor3 = toggled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)})
                tConfig.Callback(toggled)
            end)
            applyLock(ToggleFrame, tConfig.Locked, tConfig.LockMessage)
        end

        function Tab:Dropdown(dConfig)
            local dValues = dConfig.Values or {}
            local selected = dConfig.Default or "Select..."
            local opened = false
            local DropdownFrame = DeusUI:Create("Frame", {
                Name = "DropdownFrame", Parent = Page, Size = UDim2.new(0.95, 0, 0, 45),
                BackgroundColor3 = theme.Secondary, BackgroundTransparency = 0.4, ClipsDescendants = true
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("UIStroke", {Color = theme.Outline, Transparency = 0.9}),
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15)})
            })
            local Header = DeusUI:Create("TextButton", {Name = "Header", Parent = DropdownFrame, Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1, Text = ""})
            local Title = DeusUI:Create("TextLabel", {Text = dConfig.Title or "Dropdown", Parent = Header, Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1, TextColor3 = theme.Text, Font = Enum.Font.GothamMedium, TextSize = 14, TextXAlignment = "Left"})
            local SelText = DeusUI:Create("TextLabel", {Text = selected, Parent = Header, Size = UDim2.new(0.5, -25, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), BackgroundTransparency = 1, TextColor3 = theme.Accent, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = "Right"})
            local Arrow = DeusUI:Create("ImageLabel", {Name = "Arrow", Parent = Header, Image = "rbxassetid://6034818372", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, ImageColor3 = theme.TextSecondary})
            local OptionHolder = DeusUI:Create("ScrollingFrame", {Name = "OptionHolder", Parent = DropdownFrame, Size = UDim2.new(1, 0, 0, 120), Position = UDim2.new(0, 0, 0, 40), BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = theme.Accent, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = "Y", Visible = false}, { DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 5)}) })
            
            Header.MouseButton1Click:Connect(function()
                opened = not opened
                DeusUI:Tween(DropdownFrame, TweenInfo.new(0.3), {Size = opened and UDim2.new(0.95, 0, 0, 170) or UDim2.new(0.95, 0, 0, 45)})
                DeusUI:Tween(Arrow, TweenInfo.new(0.3), {Rotation = opened and 180 or 0})
                OptionHolder.Visible = true
            end)

            for _, v in pairs(dValues) do
                local Opt = DeusUI:Create("TextButton", {Parent = OptionHolder, Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = theme.Main, BackgroundTransparency = 0.8, Text = v, TextColor3 = theme.TextSecondary, Font = Enum.Font.Gotham, TextSize = 13}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 4)}) })
                Opt.MouseButton1Click:Connect(function()
                    selected = v; SelText.Text = v; opened = false
                    DeusUI:Tween(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.95, 0, 0, 45)})
                    DeusUI:Tween(Arrow, TweenInfo.new(0.3), {Rotation = 0})
                    dConfig.Callback(v)
                end)
            end
            applyLock(DropdownFrame, dConfig.Locked, dConfig.LockMessage)
        end

        function Tab:Keybind(kConfig)
            local currentKey = kConfig.Default or Enum.KeyCode.F
            local BindFrame = DeusUI:Create("Frame", {
                Name = "BindFrame", Parent = Page, Size = UDim2.new(0.95, 0, 0, 45), BackgroundColor3 = theme.Secondary, BackgroundTransparency = 0.4
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("UIPadding", {PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15)}),
                DeusUI:Create("TextLabel", {Text = kConfig.Title or "Keybind", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 14, Font = Enum.Font.GothamMedium, Size = UDim2.new(1, -100, 1, 0), TextXAlignment = "Left"})
            })
            local Btn = DeusUI:Create("TextButton", {
                Name = "Btn", Parent = BindFrame, Size = UDim2.new(0, 80, 0, 25), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = theme.Main, Text = currentKey.Name, TextColor3 = theme.Accent, Font = Enum.Font.GothamBold, TextSize = 12
            }, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)}) })
            Btn.MouseButton1Click:Connect(function()
                Btn.Text = "..."
                local connection; connection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode; Btn.Text = currentKey.Name; connection:Disconnect(); kConfig.Callback(currentKey)
                    end
                end)
            end)
            applyLock(BindFrame, kConfig.Locked, kConfig.LockMessage)
        end

        function Tab:Slider(sConfig)
            local min, max, val = sConfig.Min or 0, sConfig.Max or 100, sConfig.Default or 50
            local SliderFrame = DeusUI:Create("Frame", {
                Name = "SliderFrame", Parent = Page, Size = UDim2.new(0.95, 0, 0, 60), BackgroundColor3 = theme.Secondary, BackgroundTransparency = 0.4
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15)}),
                DeusUI:Create("TextLabel", {Text = sConfig.Title or "Slider", BackgroundTransparency = 1, TextColor3 = theme.Text, TextSize = 14, Font = Enum.Font.GothamMedium, Size = UDim2.new(0.7, 0, 0, 20), TextXAlignment = "Left"}),
                DeusUI:Create("TextLabel", {Name = "Val", Text = tostring(val), BackgroundTransparency = 1, TextColor3 = theme.Accent, TextSize = 14, Font = Enum.Font.GothamBold, Size = UDim2.new(0.3, 0, 0, 20), Position = UDim2.new(0.7, 0, 0, 0), TextXAlignment = "Right"})
            })
            local Bar = DeusUI:Create("Frame", {Name = "Bar", Parent = SliderFrame, Size = UDim2.new(1, 0, 0, 6), Position = UDim2.new(0, 0, 0, 35), BackgroundColor3 = theme.Main}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local Fill = DeusUI:Create("Frame", {Name = "Fill", Parent = Bar, Size = UDim2.new((val-min)/(max-min), 0, 1, 0), BackgroundColor3 = theme.Accent}, { DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })
            local dragging = false
            local function update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max-min)*pos); SliderFrame.Val.Text = tostring(val); Fill.Size = UDim2.new(pos, 0, 1, 0); sConfig.Callback(val)
            end
            Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(input) end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            applyLock(SliderFrame, sConfig.Locked, sConfig.LockMessage)
        end

        function Tab:Paragraph(pConfig)
            local ParaFrame = DeusUI:Create("Frame", {
                Name = "ParaFrame", Parent = Page, Size = UDim2.new(0.95, 0, 0, 0), AutomaticSize = "Y", BackgroundColor3 = theme.Secondary, BackgroundTransparency = 0.6
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("UIPadding", {
                    PaddingTop = UDim.new(0, 12),
                    PaddingBottom = UDim.new(0, 12),
                    PaddingLeft = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12)
                }),
                DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 4)}),
                DeusUI:Create("TextLabel", {Text = pConfig.Title or "Info", BackgroundTransparency = 1, TextColor3 = theme.Accent, Font = Enum.Font.GothamBold, TextSize = 14, AutomaticSize = "XY"}),
                DeusUI:Create("TextLabel", {Text = pConfig.Desc or "", BackgroundTransparency = 1, TextColor3 = theme.TextSecondary, Font = Enum.Font.Gotham, TextSize = 13, AutomaticSize = "Y", Size = UDim2.new(1, 0, 0, 0), TextWrapped = true, TextXAlignment = "Left"})
            })
        end

        return Tab
    end

    return Window
end

return DeusUI
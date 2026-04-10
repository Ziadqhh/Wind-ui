--[[
    Deus Evolution UI | Version 2.0.0 (ULTIMATE EDITION)
    Created by: Deus Mode (Gemini CLI)
    Style: Premium Glassmorphism & Dynamic Gradients
]]

local DeusUI = {
    Themes = {
        Dark = {
            Main = Color3.fromRGB(15, 15, 20),
            Secondary = Color3.fromRGB(25, 25, 35),
            Outline = Color3.fromRGB(45, 45, 60),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(160, 160, 180),
            Accent = Color3.fromRGB(0, 150, 255),
            Gradient = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 200))})
        },
        Luxury = {
            Main = Color3.fromRGB(15, 10, 10),
            Secondary = Color3.fromRGB(25, 15, 15),
            Outline = Color3.fromRGB(60, 40, 40),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(180, 150, 150),
            Accent = Color3.fromRGB(255, 180, 0),
            Gradient = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 130, 0))})
        },
        Neon = {
            Main = Color3.fromRGB(10, 10, 15),
            Secondary = Color3.fromRGB(20, 20, 30),
            Outline = Color3.fromRGB(80, 0, 255),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(180, 150, 255),
            Accent = Color3.fromRGB(150, 0, 255),
            Gradient = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 200))})
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
        ["search"] = "rbxassetid://10723344430"
    },
    CurrentTheme = "Dark",
    Elements = {},
    SelectedTab = nil,
    ScreenGui = nil
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")

-- Helper: Create Instance
function DeusUI:Create(className, properties, children)
    local inst = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        inst[prop] = value
    end
    for _, child in pairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

-- Helper: Animation
function DeusUI:Tween(obj, time, props, style)
    local info = TweenInfo.new(time, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

-- Notification System
function DeusUI:Notify(config)
    local theme = self.Themes[self.CurrentTheme]
    if not self.NotifyGui then
        self.NotifyGui = self:Create("ScreenGui", {Name = "DeusNotify", Parent = CoreGui})
        self.NotifyHolder = self:Create("Frame", {Parent = self.NotifyGui, Size = UDim2.new(0, 300, 1, 0), Position = UDim2.new(1, -310, 0, 0), BackgroundTransparency = 1}, {
            self:Create("UIListLayout", {VerticalAlignment = "Bottom", Padding = UDim.new(0, 10)})
        })
    end

    local Toast = self:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = theme.Main,
        BackgroundTransparency = 0.1,
        Parent = self.NotifyHolder,
        Position = UDim2.new(1.5, 0, 0, 0)
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        self:Create("UIStroke", {Color = theme.Accent, Thickness = 1.5, Transparency = 0.5}),
        self:Create("UIGradient", {Color = theme.Gradient, Rotation = 45}),
        self:Create("TextLabel", {
            Text = config.Content or "Notification",
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            BackgroundTransparency = 1,
            TextColor3 = theme.Text,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = "Left"
        })
    })

    self:Tween(Toast, 0.5, {Position = UDim2.new(0, 0, 0, 0)})
    task.delay(config.Duration or 4, function()
        self:Tween(Toast, 0.5, {Position = UDim2.new(1.5, 0, 0, 0)})
        task.wait(0.5)
        Toast:Destroy()
    end)
end

-- Main Window
function DeusUI:CreateWindow(config)
    local theme = self.Themes[self.CurrentTheme]
    self.ScreenGui = self:Create("ScreenGui", {Name = "DeusEvolution_V2", Parent = CoreGui, ResetOnSpawn = false})

    local MainFrame = self:Create("Frame", {
        Name = "Main",
        Parent = self.ScreenGui,
        Size = UDim2.new(0, 480, 0, 320), -- More compact
        Position = UDim2.new(0.5, -240, 0.5, -160),
        BackgroundColor3 = theme.Main,
        ClipsDescendants = true
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        self:Create("UIStroke", {Color = theme.Outline, Thickness = 1.2, Transparency = 0.8}),
        self:Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
            }),
            Rotation = 45,
            Transparency = NumberSequence.new(0, 0.1)
        })
    })

    -- Dragging
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
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

    -- Sidebar
    local Sidebar = self:Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        Size = UDim2.new(0, 140, 1, -40),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1
    }, {
        self:Create("UIListLayout", {Padding = UDim.new(0, 5)})
    })

    local Title = self:Create("TextLabel", {
        Parent = MainFrame,
        Text = config.Title or "DEUS EVOLUTION",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 15, 0, 5),
        BackgroundTransparency = 1,
        TextColor3 = theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = "Left"
    })

    local PageContainer = self:Create("Frame", {
        Name = "Pages",
        Parent = MainFrame,
        Size = UDim2.new(1, -170, 1, -50),
        Position = UDim2.new(0, 160, 0, 40),
        BackgroundTransparency = 1
    })

    local Window = {Tabs = {}}

    function Window:Tab(tConfig)
        local tabTitle = tConfig.Title or "Tab"
        local Page = self:Create("ScrollingFrame", {
            Name = tabTitle .. "Page",
            Parent = PageContainer,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 0,
            AutomaticCanvasSize = "Y"
        }, {
            self:Create("UIListLayout", {Padding = UDim.new(0, 8), HorizontalAlignment = "Center"}),
            self:Create("UIPadding", {PaddingTop = UDim.new(0, 5)})
        })

        local TabBtn = self:Create("TextButton", {
            Name = tabTitle .. "Btn",
            Parent = Sidebar,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = theme.Secondary,
            BackgroundTransparency = 0.5,
            Text = "  " .. tabTitle,
            TextColor3 = theme.TextSecondary,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextXAlignment = "Left",
            AutoButtonColor = false
        }, {
            self:Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
            self:Create("UIStroke", {Color = theme.Outline, Thickness = 1, Transparency = 0.8})
        })

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(PageContainer:GetChildren()) do p.Visible = false end
            for _, b in pairs(Sidebar:GetChildren()) do 
                if b:IsA("TextButton") then 
                    DeusUI:Tween(b, 0.3, {BackgroundTransparency = 0.5, TextColor3 = theme.TextSecondary}) 
                    if b:FindFirstChild("UIStroke") then b.UIStroke.Color = theme.Outline end
                end 
            end
            Page.Visible = true
            DeusUI:Tween(TabBtn, 0.3, {BackgroundTransparency = 0, TextColor3 = theme.Text})
            TabBtn.UIStroke.Color = theme.Accent
        end)

        if not DeusUI.SelectedTab then
            DeusUI.SelectedTab = true
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = theme.Text
            TabBtn.UIStroke.Color = theme.Accent
        end

        local Tab = {}

        -- Section
        function Tab:Section(title)
            return DeusUI:Create("TextLabel", {
                Parent = Page,
                Size = UDim2.new(0.95, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = title:upper(),
                TextColor3 = theme.Accent,
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextXAlignment = "Left"
            })
        end

        -- Button
        function Tab:Button(bConfig)
            local BtnFrame = DeusUI:Create("Frame", {
                Parent = Page,
                Size = UDim2.new(0.95, 0, 0, 38),
                BackgroundColor3 = theme.Secondary,
                BackgroundTransparency = 0.3
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("UIStroke", {Color = theme.Outline, Thickness = 1, Transparency = 0.8}),
                DeusUI:Create("TextButton", {
                    Name = "Btn",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = bConfig.Title or "Button",
                    TextColor3 = theme.Text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 14
                })
            })

            BtnFrame.Btn.MouseEnter:Connect(function() DeusUI:Tween(BtnFrame, 0.3, {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.5}) end)
            BtnFrame.Btn.MouseLeave:Connect(function() DeusUI:Tween(BtnFrame, 0.3, {BackgroundColor3 = theme.Secondary, BackgroundTransparency = 0.3}) end)
            BtnFrame.Btn.MouseButton1Click:Connect(function() 
                local circle = DeusUI:Create("Frame", {Parent = BtnFrame, Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0), BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 0.8}, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(1,0)})})
                DeusUI:Tween(circle, 0.4, {Size = UDim2.new(1.2,0,5,0), BackgroundTransparency = 1})
                task.delay(0.4, function() circle:Destroy() end)
                bConfig.Callback() 
            end)
        end

        -- Toggle
        function Tab:Toggle(tConfig)
            local toggled = tConfig.Default or false
            local TFrame = DeusUI:Create("Frame", {
                Parent = Page,
                Size = UDim2.new(0.95, 0, 0, 42),
                BackgroundColor3 = theme.Secondary,
                BackgroundTransparency = 0.4
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("UIStroke", {Color = theme.Outline, Thickness = 1, Transparency = 0.8}),
                DeusUI:Create("TextLabel", {
                    Text = "  " .. (tConfig.Title or "Toggle"),
                    Size = UDim2.new(1, -50, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = theme.Text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 14,
                    TextXAlignment = "Left"
                })
            })

            local Switch = DeusUI:Create("Frame", {
                Parent = TFrame,
                Size = UDim2.new(0, 38, 0, 20),
                Position = UDim2.new(1, -45, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = toggled and theme.Accent or theme.Main,
                BorderSizePixel = 0
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                DeusUI:Create("Frame", {
                    Name = "Circle",
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.new(1, 1, 1)
                }, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            })

            local Btn = DeusUI:Create("TextButton", {Parent = TFrame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""})
            Btn.MouseButton1Click:Connect(function()
                toggled = not toggled
                DeusUI:Tween(Switch, 0.3, {BackgroundColor3 = toggled and theme.Accent or theme.Main})
                DeusUI:Tween(Switch.Circle, 0.3, {Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)})
                tConfig.Callback(toggled)
            end)
        end

        -- Slider
        function Tab:Slider(sConfig)
            local min, max, def = sConfig.Min or 0, sConfig.Max or 100, sConfig.Default or 50
            local SFrame = DeusUI:Create("Frame", {
                Parent = Page,
                Size = UDim2.new(0.95, 0, 0, 55),
                BackgroundColor3 = theme.Secondary,
                BackgroundTransparency = 0.4
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("TextLabel", {
                    Text = "  " .. (sConfig.Title or "Slider"),
                    Size = UDim2.new(0.5, 0, 0, 30),
                    BackgroundTransparency = 1,
                    TextColor3 = theme.Text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 13,
                    TextXAlignment = "Left"
                }),
                DeusUI:Create("TextLabel", {
                    Name = "Val",
                    Text = tostring(def),
                    Size = UDim2.new(0.5, -10, 0, 30),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = theme.Accent,
                    Font = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextXAlignment = "Right"
                })
            })

            local Bar = DeusUI:Create("Frame", {
                Parent = SFrame,
                Size = UDim2.new(1, -20, 0, 4),
                Position = UDim2.new(0, 10, 0, 40),
                BackgroundColor3 = theme.Main,
                BorderSizePixel = 0
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                DeusUI:Create("Frame", {
                    Name = "Fill",
                    Size = UDim2.new((def - min) / (max - min), 0, 1, 0),
                    BackgroundColor3 = theme.Accent,
                    BorderSizePixel = 0
                }, {
                    DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                    DeusUI:Create("UIGradient", {Color = theme.Gradient}),
                    DeusUI:Create("Frame", {
                        Name = "Knob",
                        Size = UDim2.new(0, 12, 0, 12),
                        Position = UDim2.new(1, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundColor3 = Color3.new(1, 1, 1)
                    }, {
                        DeusUI:Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                        DeusUI:Create("UIStroke", {Color = theme.Accent, Thickness = 2})
                    })
                })
            })

            local function update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                SFrame.Val.Text = tostring(val)
                Bar.Fill.Size = UDim2.new(pos, 0, 1, 0)
                sConfig.Callback(val)
            end

            local dragging = false
            SFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(input) end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
        end

        -- Dropdown
        function Tab:Dropdown(dConfig)
            local open = false
            local DFrame = DeusUI:Create("Frame", {
                Parent = Page,
                Size = UDim2.new(0.95, 0, 0, 40),
                BackgroundColor3 = theme.Secondary,
                BackgroundTransparency = 0.4,
                ClipsDescendants = true
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("UIStroke", {Color = theme.Outline, Thickness = 1, Transparency = 0.8}),
                DeusUI:Create("TextButton", {
                    Name = "Header",
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundTransparency = 1,
                    Text = "  " .. (dConfig.Title or "Dropdown"),
                    TextColor3 = theme.Text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 14,
                    TextXAlignment = "Left"
                }, {
                    DeusUI:Create("TextLabel", {
                        Name = "Selected",
                        Text = dConfig.Default or "Select...",
                        Size = UDim2.new(1, -35, 1, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = theme.Accent,
                        Font = Enum.Font.Gotham,
                        TextSize = 13,
                        TextXAlignment = "Right"
                    })
                })
            })

            local Holder = DeusUI:Create("Frame", {
                Parent = DFrame,
                Size = UDim2.new(1, -10, 0, 0),
                Position = UDim2.new(0, 5, 0, 45),
                BackgroundTransparency = 1
            }, {
                DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 5)})
            })

            DFrame.Header.MouseButton1Click:Connect(function()
                open = not open
                DeusUI:Tween(DFrame, 0.4, {Size = open and UDim2.new(0.95, 0, 0, #dConfig.Values * 35 + 50) or UDim2.new(0.95, 0, 0, 40)})
            end)

            for _, val in pairs(dConfig.Values) do
                local Opt = DeusUI:Create("TextButton", {
                    Parent = Holder,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = theme.Main,
                    BackgroundTransparency = 0.5,
                    Text = val,
                    TextColor3 = theme.TextSecondary,
                    Font = Enum.Font.Gotham,
                    TextSize = 13
                }, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)})})

                Opt.MouseButton1Click:Connect(function()
                    DFrame.Header.Selected.Text = val
                    open = false
                    DeusUI:Tween(DFrame, 0.4, {Size = UDim2.new(0.95, 0, 0, 40)})
                    dConfig.Callback(val)
                end)
            end
        end

        -- Keybind
        function Tab:Keybind(kConfig)
            local currentKey = kConfig.Default or Enum.KeyCode.F
            local KFrame = DeusUI:Create("Frame", {
                Parent = Page,
                Size = UDim2.new(0.95, 0, 0, 40),
                BackgroundColor3 = theme.Secondary,
                BackgroundTransparency = 0.4
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("UIStroke", {Color = theme.Outline, Thickness = 1, Transparency = 0.8}),
                DeusUI:Create("TextLabel", {
                    Text = "  " .. (kConfig.Title or "Keybind"),
                    Size = UDim2.new(1, -90, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = theme.Text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 14,
                    TextXAlignment = "Left"
                }),
                DeusUI:Create("TextButton", {
                    Name = "Btn",
                    Size = UDim2.new(0, 80, 0, 24),
                    Position = UDim2.new(1, -85, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = theme.Main,
                    Text = currentKey.Name,
                    TextColor3 = theme.Accent,
                    Font = Enum.Font.GothamBold,
                    TextSize = 12
                }, {DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
            })

            KFrame.Btn.MouseButton1Click:Connect(function()
                KFrame.Btn.Text = "..."
                local connection; connection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        KFrame.Btn.Text = currentKey.Name
                        connection:Disconnect()
                        kConfig.Callback(currentKey)
                    end
                end)
            end)
        end

        -- Paragraph
        function Tab:Paragraph(pConfig)
            local PFrame = DeusUI:Create("Frame", {
                Parent = Page,
                Size = UDim2.new(0.95, 0, 0, 0),
                AutomaticSize = "Y",
                BackgroundColor3 = theme.Secondary,
                BackgroundTransparency = 0.6
            }, {
                DeusUI:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
                DeusUI:Create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}),
                DeusUI:Create("UIListLayout", {Padding = UDim.new(0, 4)}),
                DeusUI:Create("TextLabel", {
                    Text = pConfig.Title or "Info",
                    Size = UDim2.new(1, 0, 0, 18),
                    BackgroundTransparency = 1,
                    TextColor3 = theme.Accent,
                    Font = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextXAlignment = "Left"
                }),
                DeusUI:Create("TextLabel", {
                    Text = pConfig.Desc or "",
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = "Y",
                    BackgroundTransparency = 1,
                    TextColor3 = theme.TextSecondary,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextWrapped = true,
                    TextXAlignment = "Left"
                })
            })
        end

        return Tab
    end

    function Window:Settings()
        local S = self:Tab({Title = "Settings"})
        S:Section("Theme")
        S:Dropdown({
            Title = "Select Theme",
            Values = {"Dark", "Luxury", "Neon"},
            Default = DeusUI.CurrentTheme,
            Callback = function(v)
                DeusUI.CurrentTheme = v
                DeusUI:Notify({Content = "Theme changed to " .. v})
                -- Here you would call a refresh function to update all elements
            end
        })
        S:Section("Interface")
        S:Button({Title = "Destroy UI", Callback = function() DeusUI.ScreenGui:Destroy() end})
    end

    return Window
end

return DeusUI

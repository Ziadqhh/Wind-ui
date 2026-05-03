local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

local OrionLib = {
	Elements = {},
	ThemeObjects = {},
	Connections = {},
	Flags = {},
	Themes = {
		Default = {
			Main = Color3.fromRGB(15, 15, 17),
			Second = Color3.fromRGB(22, 22, 25),
			Stroke = Color3.fromRGB(45, 20, 20),
			Divider = Color3.fromRGB(35, 15, 15),
			Text = Color3.fromRGB(255, 255, 255),
			TextDark = Color3.fromRGB(180, 160, 160),
			Accent = Color3.fromRGB(180, 0, 0)
		},
		BloodMoon = {
			Main = Color3.fromRGB(12, 10, 10),
			Second = Color3.fromRGB(18, 15, 15),
			Stroke = Color3.fromRGB(60, 10, 10),
			Divider = Color3.fromRGB(40, 12, 12),
			Text = Color3.fromRGB(255, 240, 240),
			TextDark = Color3.fromRGB(180, 120, 120),
			Accent = Color3.fromRGB(220, 0, 0)
		},
		Midnight = {
			Main = Color3.fromRGB(10, 10, 15),
			Second = Color3.fromRGB(15, 15, 22),
			Stroke = Color3.fromRGB(25, 25, 45),
			Divider = Color3.fromRGB(20, 20, 35),
			Text = Color3.fromRGB(255, 255, 255),
			TextDark = Color3.fromRGB(160, 160, 200),
			Accent = Color3.fromRGB(100, 100, 255)
		},
		Emerald = {
			Main = Color3.fromRGB(10, 15, 10),
			Second = Color3.fromRGB(15, 22, 15),
			Stroke = Color3.fromRGB(25, 45, 25),
			Divider = Color3.fromRGB(20, 35, 20),
			Text = Color3.fromRGB(255, 255, 255),
			TextDark = Color3.fromRGB(160, 200, 160),
			Accent = Color3.fromRGB(0, 200, 100)
		},
		Oceanic = {
			Main = Color3.fromRGB(10, 15, 20),
			Second = Color3.fromRGB(15, 22, 30),
			Stroke = Color3.fromRGB(25, 45, 60),
			Divider = Color3.fromRGB(20, 35, 50),
			Text = Color3.fromRGB(255, 255, 255),
			TextDark = Color3.fromRGB(160, 200, 230),
			Accent = Color3.fromRGB(0, 180, 255)
		},
		Amethyst = {
			Main = Color3.fromRGB(15, 10, 20),
			Second = Color3.fromRGB(22, 15, 30),
			Stroke = Color3.fromRGB(45, 25, 60),
			Divider = Color3.fromRGB(35, 20, 50),
			Text = Color3.fromRGB(255, 255, 255),
			TextDark = Color3.fromRGB(200, 160, 230),
			Accent = Color3.fromRGB(180, 100, 255)
		},
		Gold = {
			Main = Color3.fromRGB(15, 15, 10),
			Second = Color3.fromRGB(22, 22, 15),
			Stroke = Color3.fromRGB(45, 45, 25),
			Divider = Color3.fromRGB(35, 35, 20),
			Text = Color3.fromRGB(255, 255, 255),
			TextDark = Color3.fromRGB(200, 200, 160),
			Accent = Color3.fromRGB(255, 200, 0)
		}
	},
	SelectedTheme = "Default",
	Folder = nil,
	SaveCfg = false
}

local Icons = {}
pcall(function()
	Icons = HttpService:JSONDecode(game:HttpGetAsync("https://raw.githubusercontent.com/evoincorp/lucideblox/master/src/modules/util/icons.json")).icons
end)

local IconPack = {}
pcall(function()
	IconPack = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ziadqhh/Wind-ui/refs/heads/main/icon%20pack.lua"))() or {}
end)

local function GetIcon(IconName)
	if Icons[IconName] ~= nil then
		return Icons[IconName]
	elseif IconPack[IconName] ~= nil then
		return IconPack[IconName]
	else
		return nil
	end
end   

local Orion = Instance.new("ScreenGui")
Orion.Name = "Orion"
Orion.ZIndexBehavior = Enum.ZIndexBehavior.Global
if gethui then
	Orion.Parent = gethui()
elseif syn and syn.protect_gui then
	syn.protect_gui(Orion)
	Orion.Parent = game.CoreGui
else
	Orion.Parent = game.CoreGui
end

if gethui then
	for _, Interface in ipairs(gethui():GetChildren()) do
		if Interface.Name == Orion.Name and Interface ~= Orion then
			Interface:Destroy()
		end
	end
else
	for _, Interface in ipairs(game.CoreGui:GetChildren()) do
		if Interface.Name == Orion.Name and Interface ~= Orion then
			Interface:Destroy()
		end
	end
end

function OrionLib:IsRunning()
	return Orion.Parent ~= nil
end

local function AddConnection(Signal, Function)
	if (not OrionLib:IsRunning()) then
		return
	end
	local SignalConnect = Signal:Connect(Function)
	table.insert(OrionLib.Connections, SignalConnect)
	return SignalConnect
end

task.spawn(function()
	while (OrionLib:IsRunning()) do
		wait()
	end

	for _, Connection in next, OrionLib.Connections do
		Connection:Disconnect()
	end
end)

local function MakeDraggable(DragPoint, Main)
	pcall(function()
		local Dragging, DragInput, MousePos, FramePos = false
		AddConnection(DragPoint.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				MousePos = Input.Position
				FramePos = Main.Position

				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)
		AddConnection(DragPoint.InputChanged, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
				DragInput = Input
			end
		end)
		AddConnection(UserInputService.InputChanged, function(Input)
			if Input == DragInput and Dragging then
				local Delta = Input.Position - MousePos
				Main.Position  = UDim2.new(FramePos.X.Scale,FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
			end
		end)
	end)
end    

local function Create(Name, Properties, Children)
	local Object = Instance.new(Name)
	for i, v in next, Properties or {} do
		Object[i] = v
	end
	for i, v in next, Children or {} do
		v.Parent = Object
	end
	return Object
end

local function CreateElement(ElementName, ElementFunction)
	OrionLib.Elements[ElementName] = function(...)
		return ElementFunction(...)
	end
end

local function MakeElement(ElementName, ...)
	return OrionLib.Elements[ElementName](...)
end

local function SetProps(Element, Props)
	for i, v in next, Props or {} do
		Element[i] = v
	end
	return Element
end

local function SetChildren(Element, Children)
	for _, Child in next, Children or {} do
		Child.Parent = Element
	end
	return Element
end

local function Round(Number, Factor)
	local Result = math.floor(Number/Factor + (math.sign(Number) * 0.5)) * Factor
	if Result < 0 then Result = Result + Factor end
	return Result
end

local function ReturnProperty(Object)
	if Object:IsA("Frame") or Object:IsA("TextButton") then
		return "BackgroundColor3"
	end 
	if Object:IsA("ScrollingFrame") then
		return "ScrollBarImageColor3"
	end 
	if Object:IsA("UIStroke") then
		return "Color"
	end 
	if Object:IsA("TextLabel") or Object:IsA("TextBox") then
		return "TextColor3"
	end   
	if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
		return "ImageColor3"
	end   
end

local function AddThemeObject(Object, Type)
	if not OrionLib.ThemeObjects[Type] then
		OrionLib.ThemeObjects[Type] = {}
	end    
	table.insert(OrionLib.ThemeObjects[Type], Object)
	Object[ReturnProperty(Object)] = OrionLib.Themes[OrionLib.SelectedTheme][Type]
	return Object
end    

local function SetTheme()
	for Name, Type in pairs(OrionLib.ThemeObjects) do
		for _, Object in pairs(Type) do
			Object[ReturnProperty(Object)] = OrionLib.Themes[OrionLib.SelectedTheme][Name]
		end    
	end    
end

local function PackColor(Color)
	return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end    

local function UnpackColor(Color)
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end

local function LoadCfg(Config)
	local Data = HttpService:JSONDecode(Config)
	for a, b in next, Data do
		if OrionLib.Flags[a] then
			task.spawn(function() 
				if OrionLib.Flags[a].Type == "Colorpicker" then
					OrionLib.Flags[a]:Set(UnpackColor(b))
				else
					OrionLib.Flags[a]:Set(b)
				end    
			end)
		end
	end
end

local function SaveCfg(Name)
	if not OrionLib.SaveCfg then return end
	local Data = {}
	for i, v in next, OrionLib.Flags do
		if v.Save then
			if v.Type == "Colorpicker" then
				Data[i] = PackColor(v.Value)
			else
				Data[i] = v.Value
			end
		end	
	end
	if writefile then
		writefile(OrionLib.Folder .. "/" .. Name .. ".txt", HttpService:JSONEncode(Data))
	end
end

local WhitelistedMouse = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2,Enum.UserInputType.MouseButton3}
local BlacklistedKeys = {Enum.KeyCode.Unknown,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Up,Enum.KeyCode.Left,Enum.KeyCode.Down,Enum.KeyCode.Right,Enum.KeyCode.Slash,Enum.KeyCode.Tab,Enum.KeyCode.Backspace,Enum.KeyCode.Escape}

local function CheckKey(Table, Key)
	for _, v in next, Table do
		if v == Key then
			return true
		end
	end
end

CreateElement("Corner", function(Scale, Offset)
	return Create("UICorner", {
		CornerRadius = UDim.new(Scale or 0, Offset or 6)
	})
end)

CreateElement("Stroke", function(Color, Thickness)
	return Create("UIStroke", {
		Color = Color or Color3.fromRGB(255, 255, 255),
		Thickness = Thickness or 1.2,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	})
end)

CreateElement("List", function(Scale, Offset)
	return Create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(Scale or 0, Offset or 0)
	})
end)

CreateElement("Padding", function(Bottom, Left, Right, Top)
	return Create("UIPadding", {
		PaddingBottom = UDim.new(0, Bottom or 4),
		PaddingLeft = UDim.new(0, Left or 4),
		PaddingRight = UDim.new(0, Right or 4),
		PaddingTop = UDim.new(0, Top or 4)
	})
end)

CreateElement("TFrame", function()
	return Create("Frame", {
		BackgroundTransparency = 1
	})
end)

CreateElement("Frame", function(Color)
	return Create("Frame", {
		BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0
	})
end)

CreateElement("RoundFrame", function(Color, Scale, Offset)
	return Create("Frame", {
		BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0
	}, {
		Create("UICorner", {
			CornerRadius = UDim.new(Scale, Offset)
		})
	})
end)

CreateElement("Button", function()
	return Create("TextButton", {
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	})
end)

CreateElement("ScrollFrame", function(Color, Width)
	return Create("ScrollingFrame", {
		BackgroundTransparency = 1,
		MidImage = "rbxassetid://7445543667",
		BottomImage = "rbxassetid://7445543667",
		TopImage = "rbxassetid://7445543667",
		ScrollBarImageColor3 = Color,
		BorderSizePixel = 0,
		ScrollBarThickness = Width,
		CanvasSize = UDim2.new(0, 0, 0, 0)
	})
end)

CreateElement("Image", function(ImageID)
	local ImageNew = Create("ImageLabel", {
		Image = GetIcon(ImageID) or ImageID,
		BackgroundTransparency = 1
	})
	return ImageNew
end)

CreateElement("ImageButton", function(ImageID)
	return Create("ImageButton", {
		Image = GetIcon(ImageID) or ImageID,
		BackgroundTransparency = 1
	})
end)

CreateElement("Label", function(Text, TextSize, Transparency)
	return Create("TextLabel", {
		Text = Text or "",
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextTransparency = Transparency or 0,
		TextSize = TextSize or 15,
		Font = Enum.Font.Gotham,
		RichText = true,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left
	})
end)

CreateElement("Textbox", function(Text)
	return Create("TextBox", {
		Text = Text or "",
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 14,
		Font = Enum.Font.Gotham,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false
	})
end)

local NotificationHolder = SetProps(SetChildren(MakeElement("TFrame"), {
	SetProps(MakeElement("List"), {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		Padding = UDim.new(0, 5)
	})
}), {
	Position = UDim2.new(1, -25, 1, -25),
	Size = UDim2.new(0, 300, 1, -25),
	AnchorPoint = Vector2.new(1, 1),
	Parent = Orion
})

function OrionLib:MakeNotification(Config)
	task.spawn(function()
		Config.Name = Config.Name or "Notification"
		Config.Content = Config.Content or "Test"
		Config.Image = Config.Image or "rbxassetid://4384403532"
		Config.Time = Config.Time or 5

		local NotificationParent = SetProps(MakeElement("TFrame"), {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = NotificationHolder
		})

		local NotificationFrame = SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(25, 25, 25), 0, 10), {
			Parent = NotificationParent, 
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(1, 20, 0, 0),
			BackgroundTransparency = 0,
			AutomaticSize = Enum.AutomaticSize.Y
		}), {
			MakeElement("Stroke", Color3.fromRGB(93, 93, 93), 1.2),
			MakeElement("Padding", 12, 12, 12, 12),
			SetProps(MakeElement("Image", Config.Image), {
				Size = UDim2.new(0, 20, 0, 20),
				ImageColor3 = Color3.fromRGB(240, 240, 240),
				Name = "Icon"
			}),
			SetProps(MakeElement("Label", Config.Name, 15), {
				Size = UDim2.new(1, -30, 0, 20),
				Position = UDim2.new(0, 30, 0, 0),
				Font = Enum.Font.GothamBold,
				Name = "Title"
			}),
			SetProps(MakeElement("Label", Config.Content, 14), {
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 25),
				Font = Enum.Font.GothamSemibold,
				Name = "Content",
				AutomaticSize = Enum.AutomaticSize.Y,
				TextColor3 = Color3.fromRGB(200, 200, 200),
				TextWrapped = true
			})
		})

		TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)}):Play()
		task.wait(Config.Time)
		TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 20, 0, 0)}):Play()
		task.wait(0.5)
		NotificationParent:Destroy()
	end)
end

function OrionLib:Init()
	if OrionLib.SaveCfg then	
		pcall(function()
			if isfile(OrionLib.Folder .. "/" .. game.GameId .. ".txt") then
				LoadCfg(readfile(OrionLib.Folder .. "/" .. game.GameId .. ".txt"))
				OrionLib:MakeNotification({
					Name = "Configuration",
					Content = "Auto-loaded configuration for the game " .. game.GameId .. ".",
					Time = 5
				})
			end
		end)		
	end	
end	

local function GetElements(ItemParent, MainWindow, WindowStuff, SettingsOverlay, ToggleSettings)
	local ElementFunction = {}

	function ElementFunction:AddLabel(Text)
		local LabelFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
			Size = UDim2.new(1, 0, 0, 24),
			BackgroundTransparency = 0.7,
			Parent = ItemParent
		}), {
			AddThemeObject(SetProps(MakeElement("Label", Text, 14), {
				Size = UDim2.new(1, -12, 1, 0),
				Position = UDim2.new(0, 12, 0, 0),
				Font = Enum.Font.GothamBold,
				Name = "Content"
			}), "Text"),
			AddThemeObject(MakeElement("Stroke"), "Stroke")
		}), "Second")

		local Label = {}
		function Label:Set(NewText)
			LabelFrame.Content.Text = NewText
		end
		return Label
	end

	function ElementFunction:AddParagraph(Config)
		Config = type(Config) == "string" and {Title = Config, Content = ""} or Config
		Config.Title = Config.Title or "Paragraph"
		Config.Content = Config.Content or ""

		local ParagraphFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundTransparency = 0.7,
			Parent = ItemParent,
			AutomaticSize = Enum.AutomaticSize.Y
		}), {
			AddThemeObject(SetProps(MakeElement("Label", Config.Title, 14), {
				Size = UDim2.new(1, -24, 0, 20),
				Position = UDim2.new(0, 12, 0, 8),
				Font = Enum.Font.GothamBold,
				Name = "Title"
			}), "Text"),
			AddThemeObject(SetProps(MakeElement("Label", Config.Content, 12), {
				Size = UDim2.new(1, -24, 0, 0),
				Position = UDim2.new(0, 12, 0, 28),
				Font = Enum.Font.GothamSemibold,
				Name = "Content",
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.Y
			}), "TextDark"),
			AddThemeObject(MakeElement("Stroke"), "Stroke"),
			MakeElement("Padding", 8, 0, 0, 0)
		}), "Second")

		local Paragraph = {}
		function Paragraph:Set(NewTitle, NewContent)
			if NewTitle then ParagraphFrame.Title.Text = NewTitle end
			if NewContent then ParagraphFrame.Content.Text = NewContent end
		end
		return Paragraph
	end

	function ElementFunction:AddButton(Config)
		Config = Config or {}
		Config.Name = Config.Name or "Button"
		Config.Callback = Config.Callback or function() end
		Config.Icon = Config.Icon or "rbxassetid://3944703587"

		local Click = SetProps(MakeElement("Button"), {
			Size = UDim2.new(1, 0, 1, 0)
		})

		local ButtonFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
			Size = UDim2.new(1, 0, 0, 34),
			Parent = ItemParent
		}), {
			AddThemeObject(SetProps(MakeElement("Image", Config.Icon), {
				Size = UDim2.new(0, 18, 0, 18),
				Position = UDim2.new(0, 10, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				ImageTransparency = 0.2,
				Name = "Ico"
			}), "Text"),
			AddThemeObject(SetProps(MakeElement("Label", Config.Name, 14), {
				Size = UDim2.new(1, -40, 1, 0),
				Position = UDim2.new(0, 36, 0, 0),
				Font = Enum.Font.GothamSemibold,
				Name = "Content"
			}), "Text"),
			AddThemeObject(MakeElement("Stroke"), "Stroke"),
			Click
		}), "Second")

		AddConnection(Click.MouseEnter, function()
			TweenService:Create(ButtonFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 5, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 5, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 5)}):Play()
			TweenService:Create(ButtonFrame.Content, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 40, 0, 0)}):Play()
		end)

		AddConnection(Click.MouseLeave, function()
			TweenService:Create(ButtonFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Second}):Play()
			TweenService:Create(ButtonFrame.Content, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 36, 0, 0)}):Play()
		end)

		AddConnection(Click.MouseButton1Down, function()
			TweenService:Create(ButtonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 10, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 10, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 10)}):Play()
		end)

		AddConnection(Click.MouseButton1Up, function()
			TweenService:Create(ButtonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 5, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 5, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 5)}):Play()
			task.spawn(Config.Callback)
		end)

		local Button = {}
		function Button:Set(NewText)
			ButtonFrame.Content.Text = NewText
		end	
		return Button
	end

	function ElementFunction:AddToggle(Config)
		Config = Config or {}
		Config.Name = Config.Name or "Toggle"
		Config.Default = Config.Default or false
		Config.Callback = Config.Callback or function() end
		Config.Color = Config.Color or Color3.fromRGB(180, 0, 0)
		Config.Flag = Config.Flag or nil
		Config.Save = Config.Save or false

		local Toggle = {Value = Config.Default, Save = Config.Save}

		local Click = SetProps(MakeElement("Button"), {
			Size = UDim2.new(1, 0, 1, 0)
		})

		local ToggleBox = SetChildren(SetProps(MakeElement("RoundFrame", OrionLib.Themes.Default.Divider, 1, 0), {
			Size = UDim2.new(0, 36, 0, 20),
			Position = UDim2.new(1, -12, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5)
		}), {
			SetProps(MakeElement("Stroke"), {
				Color = OrionLib.Themes.Default.Stroke,
				Name = "Stroke",
				Transparency = 0.5
			}),
			SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 1, 0), {
				Size = UDim2.new(0, 14, 0, 14),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 3, 0.5, 0),
				Name = "Knob"
			}), {
				MakeElement("Corner", 1, 0)
			})
		})

		local ToggleFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
			Size = UDim2.new(1, 0, 0, 34),
			Parent = ItemParent
		}), {
			AddThemeObject(SetProps(MakeElement("Label", Config.Name, 14), {
				Size = UDim2.new(1, -12, 1, 0),
				Position = UDim2.new(0, 12, 0, 0),
				Font = Enum.Font.GothamSemibold,
				Name = "Content"
			}), "Text"),
			AddThemeObject(MakeElement("Stroke"), "Stroke"),
			ToggleBox,
			Click
		}), "Second")

		function Toggle:Set(Value)
			Toggle.Value = Value
			local ThemeAccent = OrionLib.Themes[OrionLib.SelectedTheme].Accent
			TweenService:Create(ToggleBox, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = Toggle.Value and ThemeAccent or OrionLib.Themes.Default.Divider}):Play()
			TweenService:Create(ToggleBox.Stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Color = Toggle.Value and ThemeAccent or OrionLib.Themes.Default.Stroke}):Play()
			TweenService:Create(ToggleBox.Knob, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = Toggle.Value and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)}):Play()
			task.spawn(Config.Callback, Toggle.Value)
			SaveCfg(game.GameId)
		end    

		Toggle:Set(Toggle.Value)

		AddConnection(Click.MouseEnter, function()
			TweenService:Create(ToggleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 5, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 5, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 5)}):Play()
		end)

		AddConnection(Click.MouseLeave, function()
			TweenService:Create(ToggleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Second}):Play()
		end)

		AddConnection(Click.MouseButton1Up, function()
			Toggle:Set(not Toggle.Value)
		end)

		if Config.Flag then
			OrionLib.Flags[Config.Flag] = Toggle
		end	
		return Toggle
	end

	function ElementFunction:AddSlider(Config)
		Config = Config or {}
		Config.Name = Config.Name or "Slider"
		Config.Min = Config.Min or 0
		Config.Max = Config.Max or 100
		Config.Increment = Config.Increment or 1
		Config.Default = Config.Default or 50
		Config.Callback = Config.Callback or function() end
		Config.ValueName = Config.ValueName or ""
		Config.Color = Config.Color or OrionLib.Themes[OrionLib.SelectedTheme].Accent
		Config.Flag = Config.Flag or nil
		Config.Save = Config.Save or false

		local Slider = {Value = Config.Default, Save = Config.Save}
		local Dragging = false

		local ValueBadge = SetChildren(SetProps(MakeElement("RoundFrame", OrionLib.Themes[OrionLib.SelectedTheme].Divider, 0, 4), {
			Size = UDim2.new(0, 0, 0, 18),
			Position = UDim2.new(1, -12, 0, 8),
			AnchorPoint = Vector2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 0.5
		}), {
			SetProps(MakeElement("Padding", 0, 6, 6, 0), {}),
			SetProps(MakeElement("Label", "0", 11), {
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Font = Enum.Font.GothamBold,
				TextColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Accent,
				Name = "Val"
			})
		})

		local SliderBar = SetChildren(SetProps(MakeElement("Frame", OrionLib.Themes[OrionLib.SelectedTheme].Divider), {
			Size = UDim2.new(1, -24, 0, 4),
			Position = UDim2.new(0, 12, 0, 32),
			AnchorPoint = Vector2.new(0, 0.5)
		}), {
			MakeElement("Corner", 1, 0),
			SetChildren(SetProps(MakeElement("Frame", Config.Color), {
				Size = UDim2.new(0, 0, 1, 0),
				Name = "Fill"
			}), {
				MakeElement("Corner", 1, 0)
			}),
			SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 1, 0), {
				Size = UDim2.new(0, 10, 0, 10),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Name = "Knob"
			}), {
				SetProps(MakeElement("Stroke", OrionLib.Themes[OrionLib.SelectedTheme].Stroke, 2), {
					Transparency = 0.4
				})
			})
		})

		local SliderFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
			Size = UDim2.new(1, 0, 0, 44),
			Parent = ItemParent
		}), {
			AddThemeObject(SetProps(MakeElement("Label", Config.Name, 13), {
				Size = UDim2.new(1, -100, 0, 18),
				Position = UDim2.new(0, 12, 0, 8),
				Font = Enum.Font.GothamBold,
				Name = "Title"
			}), "Text"),
			AddThemeObject(MakeElement("Stroke"), "Stroke"),
			SliderBar,
			ValueBadge
		}), "Second")

		local function UpdateSlider()
			local Percentage = math.clamp((Slider.Value - Config.Min) / (Config.Max - Config.Min), 0, 1)
			TweenService:Create(SliderBar.Fill, TweenInfo.new(0.12, Enum.EasingStyle.Quint), {Size = UDim2.fromScale(Percentage, 1)}):Play()
			TweenService:Create(SliderBar.Knob, TweenInfo.new(0.12, Enum.EasingStyle.Quint), {Position = UDim2.fromScale(Percentage, 0.5)}):Play()
			ValueBadge.Val.Text = tostring(Slider.Value) .. " " .. Config.ValueName
			task.spawn(Config.Callback, Slider.Value)
		end

		local function Move(Input)
			local SizeScale = math.clamp((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
			local RawValue = Config.Min + ((Config.Max - Config.Min) * SizeScale)
			Slider.Value = math.clamp(Round(RawValue, Config.Increment), Config.Min, Config.Max)
			UpdateSlider()
			SaveCfg(game.GameId)
		end

		AddConnection(SliderFrame.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				Move(Input)
				TweenService:Create(SliderBar.Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 14, 0, 14)}):Play()
			end
		end)

		AddConnection(UserInputService.InputChanged, function(Input)
			if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
				Move(Input)
			end
		end)

		AddConnection(UserInputService.InputEnded, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				Dragging = false
				TweenService:Create(SliderBar.Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 10, 0, 10)}):Play()
			end
		end)

		function Slider:Set(Value)
			Slider.Value = math.clamp(Round(Value, Config.Increment), Config.Min, Config.Max)
			UpdateSlider()
		end

		Slider:Set(Slider.Value)
		if Config.Flag then
			OrionLib.Flags[Config.Flag] = Slider
		end
		return Slider
	end

	function ElementFunction:AddTextbox(Config)
		Config = Config or {}
		Config.Name = Config.Name or "Textbox"
		Config.Default = Config.Default or ""
		Config.TextDisappear = Config.TextDisappear or false
		Config.Callback = Config.Callback or function() end

		local Box = SetProps(MakeElement("Textbox", Config.Default), {
			Size = UDim2.new(0, 0, 0, 24),
			Position = UDim2.new(1, -12, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			AutomaticSize = Enum.AutomaticSize.X,
			TextXAlignment = Enum.TextXAlignment.Right,
			PlaceholderText = "Type here..."
		})

		local TextboxFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
			Size = UDim2.new(1, 0, 0, 34),
			Parent = ItemParent
		}), {
			AddThemeObject(SetProps(MakeElement("Label", Config.Name, 14), {
				Size = UDim2.new(1, -12, 1, 0),
				Position = UDim2.new(0, 12, 0, 0),
				Font = Enum.Font.GothamSemibold,
				Name = "Content"
			}), "Text"),
			AddThemeObject(MakeElement("Stroke"), "Stroke"),
			Box
		}), "Second")

		AddConnection(Box.FocusLost, function()
			task.spawn(Config.Callback, Box.Text)
			if Config.TextDisappear then
				Box.Text = ""
			end
		end)

		local Textbox = {}
		function Textbox:Set(Value)
			Box.Text = Value
			task.spawn(Config.Callback, Value)
		end
		return Textbox
	end

	function ElementFunction:AddDropdown(Config)
		Config = Config or {}
		Config.Name = Config.Name or "Dropdown"
		Config.Options = Config.Options or {}
		Config.Default = Config.Default or ""
		Config.Callback = Config.Callback or function() end

		local Dropdown = {Value = Config.Default, Options = Config.Options, Toggled = false}

		local Click = SetProps(MakeElement("Button"), {
			Size = UDim2.new(1, 0, 1, 0)
		})

		local DropdownBox = SetChildren(SetProps(MakeElement("RoundFrame", OrionLib.Themes.Default.Divider, 1, 0), {
			Size = UDim2.new(0, 0, 0, 24),
			Position = UDim2.new(1, -12, 0, 5),
			AnchorPoint = Vector2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.X
		}), {
			SetProps(MakeElement("Padding", 0, 8, 8, 0), {}),
			SetProps(MakeElement("Label", Dropdown.Value ~= "" and Dropdown.Value or "...", 13), {
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Font = Enum.Font.GothamSemibold,
				Name = "Val"
			}),
			AddThemeObject(MakeElement("Stroke"), "Stroke")
		})

		local DropdownContainer = SetChildren(SetProps(MakeElement("TFrame"), {
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(0, 0, 0, 38),
			Visible = false,
			ClipsDescendants = true,
			Name = "C"
		}), {
			MakeElement("List", 0, 4),
			MakeElement("Padding", 4, 12, 12, 4)
		})

		local DropdownFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
			Size = UDim2.new(1, 0, 0, 38),
			Parent = ItemParent
		}), {
			SetProps(SetChildren(MakeElement("TFrame"), {
				AddThemeObject(SetProps(MakeElement("Label", Config.Name, 14), {
					Size = UDim2.new(1, -12, 1, 0),
					Position = UDim2.new(0, 12, 0, 0),
					Font = Enum.Font.GothamSemibold,
					Name = "Content"
				}), "Text"),
				DropdownBox,
				Click,
				AddThemeObject(SetProps(MakeElement("Frame"), {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 1, -1),
					Name = "Line",
					Visible = false
				}), "Stroke"), 
			}), {
				Size = UDim2.new(1, 0, 0, 38),
				ClipsDescendants = true,
				Name = "F"
			}),
			DropdownContainer,
			AddThemeObject(MakeElement("Stroke"), "Stroke"),
		}), "Second")

		local function UpdateDropdown()
			for _, v in next, DropdownContainer:GetChildren() do
				if v:IsA("TextButton") then v:Destroy() end
			end

			for _, v in next, Dropdown.Options do
				local Option = SetChildren(SetProps(MakeElement("Button"), {
					Size = UDim2.new(1, 0, 0, 26),
					BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Divider,
					Parent = DropdownContainer
				}), {
					MakeElement("Corner", 0, 4),
					AddThemeObject(SetProps(MakeElement("Label", v, 12), {
						Size = UDim2.new(1, 0, 1, 0),
						Font = Enum.Font.GothamSemibold,
						TextXAlignment = Enum.TextXAlignment.Center
					}), "Text")
				})

				AddConnection(Option.MouseButton1Click, function()
					Dropdown.Value = v
					DropdownBox.Val.Text = v
					task.spawn(Config.Callback, v)
					Dropdown.Toggled = false
					TweenService:Create(DropdownFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 38)}):Play()
					DropdownContainer.Visible = false
					DropdownFrame.F.Line.Visible = false
				end)
			end
		end

		AddConnection(Click.MouseButton1Click, function()
			Dropdown.Toggled = not Dropdown.Toggled
			UpdateDropdown()
			TweenService:Create(DropdownFrame, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Dropdown.Toggled and UDim2.new(1, 0, 0, DropdownContainer.UIListLayout.AbsoluteContentSize.Y + 48) or UDim2.new(1, 0, 0, 38)}):Play()
			DropdownContainer.Visible = Dropdown.Toggled
			DropdownFrame.F.Line.Visible = Dropdown.Toggled
		end)

		function Dropdown:Set(Value)
			Dropdown.Value = Value
			DropdownBox.Val.Text = Value
			task.spawn(Config.Callback, Value)
		end

		function Dropdown:Refresh(Options, KeepValue)
			Dropdown.Options = Options
			if not KeepValue then
				Dropdown:Set(Options[1] or "...")
			end
			if Dropdown.Toggled then
				UpdateDropdown()
			end
		end

		return Dropdown
	end

	function ElementFunction:AddBind(Config)
		Config = Config or {}
		Config.Name = Config.Name or "Bind"
		Config.Default = Config.Default or Enum.KeyCode.E
		Config.Hold = Config.Hold or false
		Config.Callback = Config.Callback or function() end

		local Bind = {Value = Config.Default, Binding = false, Holding = false}

		local BindBox = SetChildren(SetProps(MakeElement("RoundFrame", OrionLib.Themes.Default.Divider, 1, 0), {
			Size = UDim2.new(0, 0, 0, 24),
			Position = UDim2.new(1, -12, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			AutomaticSize = Enum.AutomaticSize.X
		}), {
			SetProps(MakeElement("Padding", 0, 8, 8, 0), {}),
			SetProps(MakeElement("Label", Bind.Value.Name, 13), {
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Font = Enum.Font.GothamSemibold,
				Name = "Val"
			}),
			AddThemeObject(MakeElement("Stroke"), "Stroke")
		})

		local BindFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
			Size = UDim2.new(1, 0, 0, 34),
			Parent = ItemParent
		}), {
			AddThemeObject(SetProps(MakeElement("Label", Config.Name, 14), {
				Size = UDim2.new(1, -12, 1, 0),
				Position = UDim2.new(0, 12, 0, 0),
				Font = Enum.Font.GothamSemibold,
				Name = "Content"
			}), "Text"),
			AddThemeObject(MakeElement("Stroke"), "Stroke"),
			BindBox
		}), "Second")

		AddConnection(UserInputService.InputBegan, function(Input, GPE)
			if not GPE then
				if Bind.Binding then
					if Input.UserInputType == Enum.UserInputType.Keyboard then
						Bind.Value = Input.KeyCode
						BindBox.Val.Text = Input.KeyCode.Name
						Bind.Binding = false
					end
				elseif Input.KeyCode == Bind.Value then
					if Config.Hold then
						Bind.Holding = true
						task.spawn(function()
							while Bind.Holding do
								task.spawn(Config.Callback, true)
								task.wait()
							end
							task.spawn(Config.Callback, false)
						end)
					else
						task.spawn(Config.Callback)
					end
				end
			end
		end)

		AddConnection(UserInputService.InputEnded, function(Input)
			if Input.KeyCode == Bind.Value then
				Bind.Holding = false
			end
		end)

		AddConnection(BindFrame.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Bind.Binding = true
				BindBox.Val.Text = "..."
			end
		end)

		return Bind
	end

	function ElementFunction:AddColorpicker(Config)
		Config = Config or {}
		Config.Name = Config.Name or "Colorpicker"
		Config.Default = Config.Default or Color3.fromRGB(255, 0, 0)
		Config.Callback = Config.Callback or function() end
		Config.Flag = Config.Flag or nil

		local Colorpicker = {Value = Config.Default, Toggled = false}
		local ColorH, ColorS, ColorV = Colorpicker.Value:ToHSV()
		local ColorInput, HueInput = nil, nil

		local ColorpickerBox = SetProps(MakeElement("RoundFrame", Colorpicker.Value, 0, 4), {
			Size = UDim2.new(0, 34, 0, 20),
			Position = UDim2.new(1, -12, 0, 9),
			AnchorPoint = Vector2.new(1, 0)
		})

		local Click = SetProps(MakeElement("Button"), {
			Size = UDim2.new(1, 0, 1, 0)
		})

		local ColorSelection = SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 1, 0), {
			Size = UDim2.new(0, 8, 0, 8),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ZIndex = 25,
			Name = "Selector"
		})

		local Color = SetChildren(SetProps(MakeElement("Image", "rbxassetid://4155801252"), {
			Size = UDim2.new(1, -26, 1, -10),
			Position = UDim2.new(0, 10, 0, 5),
			BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1),
			Visible = false,
			Name = "Color"
		}), {
			ColorSelection
		})

		local HueSelection = SetProps(MakeElement("Frame", Color3.fromRGB(255, 255, 255)), {
			Size = UDim2.new(1, 0, 0, 2),
			ZIndex = 25,
			Name = "Selector"
		})

		local Hue = SetChildren(SetProps(MakeElement("Image", "rbxassetid://3641079629"), {
			Size = UDim2.new(0, 12, 1, -10),
			Position = UDim2.new(1, -22, 0, 5),
			Visible = false,
			Name = "Hue"
		}), {
			HueSelection
		})

		local ColorpickerContainer = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
			Size = UDim2.new(1, -15, 0, 100),
			Position = UDim2.new(0, 10, 0, 42),
			AnchorPoint = Vector2.new(0, 0),
			Visible = false,
			Name = "Container"
		}), {
			Color,
			Hue,
			AddThemeObject(MakeElement("Stroke"), "Stroke")
		}), "Main")

		local ColorpickerFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
			Size = UDim2.new(1, 0, 0, 38),
			Parent = ItemParent
		}), {
			SetProps(SetChildren(MakeElement("TFrame"), {
				AddThemeObject(SetProps(MakeElement("Label", Config.Name, 14), {
					Size = UDim2.new(1, -12, 1, 0),
					Position = UDim2.new(0, 12, 0, 0),
					Font = Enum.Font.GothamSemibold,
					Name = "Content"
				}), "Text"),
				ColorpickerBox,
				Click,
				AddThemeObject(SetProps(MakeElement("Frame"), {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 1, -1),
					Name = "Line",
					Visible = false
				}), "Stroke"), 
			}), {
				Size = UDim2.new(1, 0, 0, 38),
				ClipsDescendants = true,
				Name = "F"
			}),
			ColorpickerContainer,
			AddThemeObject(MakeElement("Stroke"), "Stroke"),
		}), "Second")

		AddConnection(Click.MouseButton1Click, function()
			Colorpicker.Toggled = not Colorpicker.Toggled
			TweenService:Create(ColorpickerFrame,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = Colorpicker.Toggled and UDim2.new(1, 0, 0, 148) or UDim2.new(1, 0, 0, 38)}):Play()
			Color.Visible = Colorpicker.Toggled
			Hue.Visible = Colorpicker.Toggled
			ColorpickerContainer.Visible = Colorpicker.Toggled
			ColorpickerFrame.F.Line.Visible = Colorpicker.Toggled
		end)

		local function UpdateColorPicker()
			ColorpickerBox.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
			Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
			Colorpicker.Value = ColorpickerBox.BackgroundColor3
			task.spawn(Config.Callback, Colorpicker.Value)
			SaveCfg(game.GameId)
		end

		AddConnection(Color.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if ColorInput then ColorInput:Disconnect() end
				ColorInput = AddConnection(RunService.RenderStepped, function()
					local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
					local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
					ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
					ColorS = ColorX
					ColorV = 1 - ColorY
					UpdateColorPicker()
				end)
			end
		end)

		AddConnection(Color.InputEnded, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if ColorInput then ColorInput:Disconnect() end
			end
		end)

		AddConnection(Hue.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if HueInput then HueInput:Disconnect() end
				HueInput = AddConnection(RunService.RenderStepped, function()
					local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
					HueSelection.Position = UDim2.new(0.5, 0, HueY, 0)
					ColorH = 1 - HueY
					UpdateColorPicker()
				end)
			end
		end)

		AddConnection(Hue.InputEnded, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if HueInput then HueInput:Disconnect() end
			end
		end)

		function Colorpicker:Set(Value)
			Colorpicker.Value = Value
			ColorpickerBox.BackgroundColor3 = Colorpicker.Value
			ColorH, ColorS, ColorV = Colorpicker.Value:ToHSV()
			Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
			ColorSelection.Position = UDim2.new(ColorS, 0, 1 - ColorV, 0)
			HueSelection.Position = UDim2.new(0.5, 0, 1 - ColorH, 0)
			task.spawn(Config.Callback, Colorpicker.Value)
		end

		if Config.Flag then OrionLib.Flags[Config.Flag] = Colorpicker end
		return Colorpicker
	end

	function ElementFunction:AddSection(Config)
		Config = Config or {}
		Config.Name = Config.Name or "Section"

		local SectionFrame = SetChildren(SetProps(MakeElement("TFrame"), {
			Size = UDim2.new(1, 0, 0, 30),
			Parent = ItemParent
		}), {
			AddThemeObject(SetProps(MakeElement("Label", Config.Name:upper(), 12), {
				Size = UDim2.new(1, -12, 0, 20),
				Position = UDim2.new(0, 5, 0, 5),
				Font = Enum.Font.GothamBold,
				TextTransparency = 0.3
			}), "TextDark"),
			AddThemeObject(SetProps(MakeElement("Frame"), {
				Size = UDim2.new(0, 2, 0, 14),
				Position = UDim2.new(0, 0, 0, 8),
				BorderSizePixel = 0
			}), "Accent"),
			SetChildren(SetProps(MakeElement("TFrame"), {
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(1, 0, 1, -28),
				Position = UDim2.new(0, 0, 0, 26),
				Name = "Holder"
			}), {
				MakeElement("List", 0, 8)
			}),
		})

		AddConnection(SectionFrame.Holder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y + 35)
			SectionFrame.Holder.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y)
		end)

		return GetElements(SectionFrame.Holder, MainWindow, WindowStuff, SettingsOverlay, ToggleSettings)
	end	

	return ElementFunction
end

function OrionLib:MakeWindow(Config)
	Config = Config or {}
	Config.Name = Config.Name or "Orion Library"
	Config.ConfigFolder = Config.ConfigFolder or Config.Name
	Config.SaveConfig = Config.SaveConfig or false
	Config.HidePremium = Config.HidePremium or false
	if Config.IntroEnabled == nil then Config.IntroEnabled = true end
	Config.IntroText = Config.IntroText or "Orion Library"
	Config.CloseCallback = Config.CloseCallback or function() end
	Config.ShowIcon = Config.ShowIcon or false
	Config.Icon = Config.Icon or "rbxassetid://8834748103"
	Config.IntroIcon = Config.IntroIcon or "rbxassetid://8834748103"
	Config.Size = Config.Size or UDim2.new(0, 615, 0, 344)
	
	OrionLib.Folder = Config.ConfigFolder
	OrionLib.SaveCfg = Config.SaveConfig

	if Config.SaveConfig and makefolder then
		if not isfolder(Config.ConfigFolder) then
			makefolder(Config.ConfigFolder)
		end	
	end

	local TabHolder = AddThemeObject(SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(255, 255, 255), 0), {
		Size = UDim2.new(1, 0, 1, -42),
		Position = UDim2.new(0, 0, 0, 42),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 0
	}), {
		SetProps(MakeElement("List"), {FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0, 8)}),
		MakeElement("Padding", 10, 8, 8, 10)
	}), "Divider")

	local TabSearch = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 8), {
		Size = UDim2.new(1, -16, 0, 28),
		Position = UDim2.new(0, 8, 0, 8),
		BackgroundTransparency = 0.6
	}), {
		AddThemeObject(MakeElement("Stroke"), "Stroke"),
		AddThemeObject(SetProps(Create("TextBox", {
			Size = UDim2.new(1, -10, 1, 0),
			Position = UDim2.new(0, 5, 0, 0),
			BackgroundTransparency = 1,
			Text = "",
			PlaceholderText = "Search...",
			Font = Enum.Font.Gotham,
			TextSize = 12,
			ClearTextOnFocus = false,
			Name = "Box"
		}), {}), "Text")
	}), "Main")

	AddConnection(TabSearch.Box:GetPropertyChangedSignal("Text"), function()
		local Query = TabSearch.Box.Text:lower()
		for _, Tab in next, TabHolder:GetChildren() do
			if Tab:IsA("TextButton") and Tab:FindFirstChild("Title") then
				Tab.Visible = Tab.Title.Text:lower():find(Query) ~= nil
			end
		end
	end)

	AddConnection(TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		TabHolder.CanvasSize = UDim2.new(0, 0, 0, TabHolder.UIListLayout.AbsoluteContentSize.Y + 20)
	end)

	local CloseBtn = SetChildren(SetProps(MakeElement("Button"), {
		Size = UDim2.new(0.333, 0, 1, 0),
		Position = UDim2.new(0.666, 0, 0, 0)
	}), {
		AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072725342"), {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 18, 0, 18)
		}), "Text")
	})

	local MinimizeBtn = SetChildren(SetProps(MakeElement("Button"), {
		Size = UDim2.new(0.333, 0, 1, 0),
		Position = UDim2.new(0.333, 0, 0, 0)
	}), {
		AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://7072719338"), {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 18, 0, 18),
			Name = "Ico"
		}), "Text")
	})

	local SettingsTopBtn = SetChildren(SetProps(MakeElement("Button"), {
		Size = UDim2.new(0.333, 0, 1, 0)
	}), {
		AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://133220441796193"), {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 18, 0, 18),
			Name = "Ico"
		}), "Text")
	})

	local DragPoint = SetProps(MakeElement("TFrame"), {
		Size = UDim2.new(1, 0, 0, 50)
	})

	local WindowStuff = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
		Size = UDim2.new(0, 150, 1, -42),
		Position = UDim2.new(0, 0, 0, 42)
	}), {
		TabSearch,
		TabHolder,
		AddThemeObject(SetProps(MakeElement("Frame"), {
			Size = UDim2.new(0, 1, 1, 0),
			Position = UDim2.new(1, -1, 0, 0)
		}), "Stroke"),
	}), "Second")

	local SettingsOverlay = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 0), {
		Size = UDim2.new(1, 0, 1, -42),
		Position = UDim2.new(0, 0, 0, 42),
		Visible = false,
		ZIndex = 100,
		Name = "SettingsOverlay",
		BackgroundTransparency = 0
	}), {
		SetProps(MakeElement("ScrollFrame", Color3.fromRGB(255, 255, 255), 4), {
			Size = UDim2.new(1, 0, 1, 0),
			Name = "Container",
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ZIndex = 101
		}),
	}), "Main")
	SetChildren(SettingsOverlay.Container, {
		SetProps(MakeElement("List", 0, 10), {Name = "UIListLayout"}),
		SetProps(MakeElement("Padding", 10, 12, 12, 10), {Name = "UIPadding"})
	})

	AddConnection(SettingsOverlay.Container.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		SettingsOverlay.Container.CanvasSize = UDim2.new(0, 0, 0, SettingsOverlay.Container.UIListLayout.AbsoluteContentSize.Y + 40)
	end)

	local MainWindow -- Forward declaration
	local CurrentTabContainer = nil

	local function ToggleSettings(Value)
		if not MainWindow then return end
		if Value then
			SettingsOverlay.Visible = true
			WindowStuff.Visible = false
			for _, Child in next, MainWindow:GetChildren() do
				if Child.Name == "ItemContainer" then
					if Child.Visible then CurrentTabContainer = Child end
					Child.Visible = false
				end
			end
		else
			SettingsOverlay.Visible = false
			WindowStuff.Visible = true
			if CurrentTabContainer then CurrentTabContainer.Visible = true end
		end
	end

	AddConnection(SettingsTopBtn.MouseButton1Click, function()
		ToggleSettings(not SettingsOverlay.Visible)
	end)

	local WindowName = AddThemeObject(SetProps(MakeElement("Label", Config.Name, 14), {
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		Position = UDim2.new(0, 20, 0, 0),
		Font = Enum.Font.GothamBlack,
		TextSize = 17,
		Name = "TitleLabel"
	}), "Accent")

	MainWindow = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 6), {
		Parent = Orion,
		Position = UDim2.new(0.5, -Config.Size.X.Offset / 2, 0.5, -Config.Size.Y.Offset / 2),
		Size = Config.Size,
		ClipsDescendants = true,
		Name = "OrionMainWindow"
	}), {
		SetProps(MakeElement("Stroke", OrionLib.Themes[OrionLib.SelectedTheme].Stroke, 1.2), {
			Transparency = 0.1
		}),
		AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 6), {
			Size = UDim2.new(1, 0, 0, 42),
			Name = "TopBar"
		}), {
			AddThemeObject(SetProps(MakeElement("Frame"), {
				Size = UDim2.new(1, 0, 0, 3),
				Position = UDim2.new(0, 0, 1, -3),
				BorderSizePixel = 0
			}), "Accent"),
			WindowName,
			SetChildren(SetProps(MakeElement("TFrame"), {
				Size = UDim2.new(1, -250, 1, 0),
				Position = UDim2.new(0, 160, 0, 0),
				Name = "CustomItems"
			}), {
				SetProps(MakeElement("List"), {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 10)})
			}),
			AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
				Size = UDim2.new(0, 96, 0, 26),
				Position = UDim2.new(1, -106, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5)
			}), {
				AddThemeObject(MakeElement("Stroke"), "Stroke"),
				AddThemeObject(SetProps(MakeElement("Frame"), {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(0.333, 0, 0, 0)}), "Stroke"),
				AddThemeObject(SetProps(MakeElement("Frame"), {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(0.666, 0, 0, 0)}), "Stroke"),
				CloseBtn,
				MinimizeBtn,
				SettingsTopBtn
			}), "Main"), 
		}), "Second"),
		DragPoint,
		WindowStuff,
		SettingsOverlay
	}), "Main")

	local ResizeBtn = SetProps(MakeElement("ImageButton", "rbxassetid://98972365591536"), {
		Parent = MainWindow,
		Size = UDim2.new(0, 16, 0, 16),
		Position = UDim2.new(1, -4, 1, -4),
		AnchorPoint = Vector2.new(1, 1),
		ImageTransparency = 0.2,
		ImageColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Accent,
		ZIndex = 110,
		Name = "ResizeHandle"
	})

	local Resizing = false
	local ResizeStartPos = nil
	local StartSize = nil

	AddConnection(ResizeBtn.InputBegan, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Resizing = true
			ResizeStartPos = Input.Position
			StartSize = MainWindow.Size
		end
	end)

	AddConnection(UserInputService.InputChanged, function(Input)
		if Resizing and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			local Delta = Input.Position - ResizeStartPos
			local NewWidth = math.max(450, StartSize.X.Offset + Delta.X)
			local NewHeight = math.max(300, StartSize.Y.Offset + Delta.Y)
			MainWindow.Size = UDim2.new(0, NewWidth, 0, NewHeight)
		end
	end)

	AddConnection(UserInputService.InputEnded, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Resizing = false
		end
	end)

	if Config.ShowIcon then
		WindowName.Position = UDim2.new(0, 50, 0, 0)
		local WindowIcon = SetProps(MakeElement("Image", Config.Icon), {
			Size = UDim2.new(0, 20, 0, 20),
			Position = UDim2.new(0, 25, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = MainWindow.TopBar
		})
	end	

	MakeDraggable(DragPoint, MainWindow)

	local UIHidden = false
	AddConnection(CloseBtn.MouseButton1Up, function()
		MainWindow.Visible = false
		UIHidden = true
		OrionLib:MakeNotification({
			Name = "Interface Hidden",
			Content = "Press RightShift to reopen the interface",
			Time = 5
		})
		Config.CloseCallback()
	end)

	AddConnection(UserInputService.InputBegan, function(Input)
		if Input.KeyCode == Enum.KeyCode.RightShift and UIHidden then
			MainWindow.Visible = true
			UIHidden = false
		end
	end)

	local Minimized = false
	AddConnection(MinimizeBtn.MouseButton1Up, function()
		if Minimized then
			TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = Config.Size}):Play()
			MinimizeBtn.Ico.Image = "rbxassetid://7072719338"
			task.wait(0.5)
			MainWindow.ClipsDescendants = false
			WindowStuff.Visible = not SettingsOverlay.Visible
		else
			MainWindow.ClipsDescendants = true
			MinimizeBtn.Ico.Image = "rbxassetid://7072720870"
			WindowStuff.Visible = false
			SettingsOverlay.Visible = false
			Config.Size = MainWindow.Size
			TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, MainWindow.Size.X.Offset, 0, 42)}):Play()
		end
		Minimized = not Minimized    
	end)

	local function LoadSequence()
		MainWindow.Visible = false
		local LoadSequenceLogo = SetProps(MakeElement("Image", Config.IntroIcon), {
			Parent = Orion,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.45, 0),
			Size = UDim2.new(0, 28, 0, 28),
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			ImageTransparency = 1
		})

		local LoadSequenceText = SetProps(MakeElement("Label", Config.IntroText, 14), {
			Parent = Orion,
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.55, 0),
			TextXAlignment = Enum.TextXAlignment.Center,
			Font = Enum.Font.GothamBold,
			TextTransparency = 1
		})

		TweenService:Create(LoadSequenceLogo, TweenInfo.new(1, Enum.EasingStyle.Quint), {ImageTransparency = 0, Position = UDim2.new(0.5, 0, 0.48, 0)}):Play()
		task.wait(0.8)
		TweenService:Create(LoadSequenceText, TweenInfo.new(1, Enum.EasingStyle.Quint), {TextTransparency = 0, Position = UDim2.new(0.5, 0, 0.52, 0)}):Play()
		task.wait(2)
		TweenService:Create(LoadSequenceLogo, TweenInfo.new(1, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
		TweenService:Create(LoadSequenceText, TweenInfo.new(1, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()
		task.wait(0.5)
		MainWindow.Visible = true
		LoadSequenceLogo:Destroy()
		LoadSequenceText:Destroy()
	end 

	if Config.IntroEnabled then LoadSequence() end	

	local TabFunction = {}
	local FirstTab = true

	function TabFunction:AddTopLabel(Config)
		Config = type(Config) == "string" and {Text = Config} or Config
		Config.Text = Config.Text or "Label"
		Config.Color = Config.Color or OrionLib.Themes[OrionLib.SelectedTheme].Text
		
		local Label = SetProps(MakeElement("Label", Config.Text, 13), {
			Parent = MainWindow.TopBar.CustomItems,
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Font = Enum.Font.GothamSemibold,
			TextColor3 = Config.Color
		})
		
		local LabelFunc = {}
		function LabelFunc:Set(NewText) Label.Text = NewText end
		function LabelFunc:SetColor(NewColor) Label.TextColor3 = NewColor end
		return LabelFunc
	end

	function TabFunction:AddTopIcon(Config)
		Config = type(Config) == "string" and {Icon = Config} or Config
		Config.Icon = Config.Icon or ""
		Config.Color = Config.Color or OrionLib.Themes[OrionLib.SelectedTheme].Text
		Config.Callback = Config.Callback or function() end
		
		local Icon = SetProps(MakeElement("ImageButton", Config.Icon), {
			Parent = MainWindow.TopBar.CustomItems,
			Size = UDim2.new(0, 20, 0, 20),
			ImageColor3 = Config.Color,
			BackgroundTransparency = 1
		})

		AddConnection(Icon.MouseButton1Click, function()
			task.spawn(Config.Callback)
		end)
		
		local IconFunc = {}
		function IconFunc:Set(NewIcon) Icon.Image = GetIcon(NewIcon) or NewIcon end
		function IconFunc:SetColor(NewColor) Icon.ImageColor3 = NewColor end
		return IconFunc
	end

	function TabFunction:AddTopButton(Config)
		Config = Config or {}
		Config.Name = Config.Name or "Button"
		Config.Callback = Config.Callback or function() end
		Config.BgColor = Config.BgColor or OrionLib.Themes[OrionLib.SelectedTheme].Main
		Config.TextColor = Config.TextColor or OrionLib.Themes[OrionLib.SelectedTheme].Text
		Config.GlowColor = Config.GlowColor or OrionLib.Themes[OrionLib.SelectedTheme].Accent

		local TopBtn = SetChildren(SetProps(MakeElement("Button"), {
			Parent = MainWindow.TopBar.CustomItems,
			Size = UDim2.new(0, 0, 0, 24),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 0,
			BackgroundColor3 = Config.BgColor
		}), {
			MakeElement("Corner", 0, 4),
			SetProps(MakeElement("Stroke", Config.GlowColor, 1.2), {
				Name = "Glow",
				Transparency = 0.5
			}),
			SetProps(MakeElement("Label", Config.Name, 12), {
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Position = UDim2.new(0, 8, 0, 0),
				Font = Enum.Font.GothamBold,
				TextColor3 = Config.TextColor
			}),
			SetProps(MakeElement("Padding", 0, 0, 16, 0), {})
		})

		AddConnection(TopBtn.MouseButton1Click, function()
			task.spawn(Config.Callback)
		end)
		
		local BtnFunc = {}
		function BtnFunc:SetText(NewText) TopBtn.TextLabel.Text = NewText end
		function BtnFunc:SetColor(NewColor) TopBtn.BackgroundColor3 = NewColor end
		return BtnFunc
	end

	function TabFunction:InternalGetElements(Parent)
		return GetElements(Parent, MainWindow, WindowStuff, SettingsOverlay, ToggleSettings)
	end

	function TabFunction:AddSettingsTab()
		local TabReturn = GetElements(SettingsOverlay.Container, MainWindow, WindowStuff, SettingsOverlay, ToggleSettings)

		local Player = game:GetService("Players").LocalPlayer
		
		local function UpdateCanvasSize()
			task.wait()
			SettingsOverlay.Container.CanvasSize = UDim2.new(0, 0, 0, SettingsOverlay.Container.UIListLayout.AbsoluteContentSize.Y + 40)
		end
		
		local ProfileFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 8), {
			Size = UDim2.new(1, 0, 0, 160),
			Parent = SettingsOverlay.Container,
			BackgroundTransparency = 0,
			Name = "ProfileFrame"
		}), {
			SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 1, 0), {
				Size = UDim2.new(0, 90, 0, 90),
				Position = UDim2.new(0.5, 0, 0, 20),
				AnchorPoint = Vector2.new(0.5, 0),
				ClipsDescendants = true,
				Name = "AvatarHolder",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			}), {
				(function()
					local AvatarImage = Create("ImageLabel", {
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Name = "Avatar"
					})
					local success, result = pcall(function()
						return game:GetService("Players"):GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
					end)
					if success and result then
						AvatarImage.Image = result
					else
						AvatarImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
					end
					return AvatarImage
				end)()
			}),
			AddThemeObject(SetProps(MakeElement("Label", Player.DisplayName, 22), {
				Size = UDim2.new(1, 0, 0, 28),
				Position = UDim2.new(0.5, 0, 0, 115),
				AnchorPoint = Vector2.new(0.5, 0),
				Font = Enum.Font.GothamBlack,
				TextXAlignment = Enum.TextXAlignment.Center,
				Name = "DisplayName"
			}), "Text"),
			AddThemeObject(SetProps(MakeElement("Label", "@" .. Player.Name, 16), {
				Size = UDim2.new(1, 0, 0, 20),
				Position = UDim2.new(0.5, 0, 0, 140),
				AnchorPoint = Vector2.new(0.5, 0),
				Font = Enum.Font.GothamMedium,
				TextXAlignment = Enum.TextXAlignment.Center,
				Name = "Username"
			}), "TextDark")
		}), "Second")
		
		task.spawn(UpdateCanvasSize)

		local ThemeList = {}
		for i, v in pairs(OrionLib.Themes) do table.insert(ThemeList, i) end

		TabReturn:AddDropdown({
			Name = "Select Theme",
			Default = OrionLib.SelectedTheme,
			Options = ThemeList,
			Callback = function(Value)
				OrionLib.SelectedTheme = Value
				SetTheme()
			end
		})

		local UISettings = TabReturn:AddSection({Name = "UI Customization"})
		UISettings:AddSlider({
			Name = "Window Transparency",
			Min = 0,
			Max = 100,
			Default = 0,
			Increment = 1,
			ValueName = "%",
			Callback = function(Value)
				local T = Value / 100
				MainWindow.BackgroundTransparency = T
				MainWindow.TopBar.BackgroundTransparency = T
				WindowStuff.BackgroundTransparency = T
				SettingsOverlay.BackgroundTransparency = T
				TabHolder.BackgroundTransparency = T
				TabSearch.BackgroundTransparency = math.max(T, 0.7) -- Keep search slightly visible
				
				for _, Child in next, MainWindow:GetChildren() do
					if Child.Name == "ItemContainer" then
						Child.BackgroundTransparency = 1 -- Keep containers transparent
					end
				end
			end
		})

		local PlayerSettings = TabReturn:AddSection({Name = "Player Utilities"})
		PlayerSettings:AddSlider({Name = "WalkSpeed", Min = 16, Max = 500, Default = 16, Increment = 1, ValueName = "ws", Callback = function(v) pcall(function() game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = v end) end})
		PlayerSettings:AddSlider({Name = "JumpPower", Min = 50, Max = 500, Default = 50, Increment = 1, ValueName = "jp", Callback = function(v) pcall(function() game:GetService("Players").LocalPlayer.Character.Humanoid.UseJumpPower = true game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = v end) end})
		
		local InfiniteJumpEnabled = false
		PlayerSettings:AddToggle({Name = "Infinite Jump", Default = false, Callback = function(v) InfiniteJumpEnabled = v end})
		AddConnection(game:GetService("UserInputService").JumpRequest, function() if InfiniteJumpEnabled then pcall(function() game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end) end end)

		TabReturn:AddButton({
			Name = "Back to Menu",
			Icon = "reply",
			Callback = function()
				ToggleSettings(false)
			end
		})
		
		return TabReturn
	end

	function TabFunction:MakeTab(Config)
		Config = Config or {}
		Config.Name = Config.Name or "Tab"
		Config.Icon = Config.Icon or ""

		local TabFrame = AddThemeObject(SetChildren(SetProps(MakeElement("Button"), {
			Size = UDim2.new(1, 0, 0, 32),
			Parent = TabHolder
		}), {
			MakeElement("Corner", 0, 4),
			SetProps(MakeElement("Stroke", OrionLib.Themes[OrionLib.SelectedTheme].Accent, 1.5), {
				Name = "Glow",
				Transparency = 0.8
			}),
			AddThemeObject(SetProps(MakeElement("Frame"), {
				Size = UDim2.new(0, 3, 0, 0),
				Position = UDim2.new(0, 2, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Name = "Indicator",
				BorderSizePixel = 0
			}), "Accent"),
			AddThemeObject(SetProps(MakeElement("Image", Config.Icon), {
				AnchorPoint = Vector2.new(0, 0.5),
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(0, 10, 0.5, 0),
				ImageTransparency = 0.4,
				Name = "Ico"
			}), "Text"),
			AddThemeObject(SetProps(MakeElement("Label", Config.Name, 14), {
				Size = UDim2.new(1, -32, 1, 0),
				Position = UDim2.new(0, 32, 0, 0),
				Font = Enum.Font.GothamSemibold,
				TextTransparency = 0.4,
				Name = "Title"
			}), "Text"),
		}), "Second")

		local Container = AddThemeObject(SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(255, 255, 255), 5), {
			Size = UDim2.new(1, -150, 1, -42),
			Position = UDim2.new(0, 150, 0, 42),
			Parent = MainWindow,
			Visible = false,
			Name = "ItemContainer"
		}), {
			MakeElement("List", 0, 6),
			MakeElement("Padding", 15, 12, 12, 15)
		}), "Divider")
		
		AddConnection(Container.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			Container.CanvasSize = UDim2.new(0, 0, 0, Container.UIListLayout.AbsoluteContentSize.Y + 30)
		end)

		AddConnection(TabFrame.MouseEnter, function()
			if not Container.Visible then
				TweenService:Create(TabFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 5, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 5, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 5)}):Play()
				TweenService:Create(TabFrame.Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 3, 0, 14)}):Play()
			end
		end)

		AddConnection(TabFrame.MouseLeave, function()
			if not Container.Visible then
				TweenService:Create(TabFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Second}):Play()
				TweenService:Create(TabFrame.Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 3, 0, 0)}):Play()
			end
		end)

		AddConnection(TabFrame.MouseButton1Up, function()
			if not MainWindow or not Container then return end
			
			for _, Tab in next, TabHolder:GetChildren() do
				if Tab:IsA("TextButton") and Tab:FindFirstChild("Title") then
					TweenService:Create(Tab, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Second}):Play()
					if Tab:FindFirstChild("Indicator") then
						TweenService:Create(Tab.Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 3, 0, 0)}):Play()
					end
					if Tab:FindFirstChild("Ico") then
						TweenService:Create(Tab.Ico, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {ImageTransparency = 0.4}):Play()
					end
					TweenService:Create(Tab.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {TextTransparency = 0.4}):Play()
					Tab.Title.Font = Enum.Font.GothamSemibold
				end    
			end
			
			for _, Child in next, MainWindow:GetChildren() do
				if Child:IsA("ScrollingFrame") and Child.Name == "ItemContainer" then 
					Child.Visible = false 
				end    
			end
			
			TweenService:Create(TabFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 10, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 10, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 10)}):Play()
			if TabFrame:FindFirstChild("Indicator") then
				TweenService:Create(TabFrame.Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 3, 0, 18)}):Play()
			end
			if TabFrame:FindFirstChild("Ico") then
				TweenService:Create(TabFrame.Ico, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {ImageTransparency = 0}):Play()
			end
			if TabFrame:FindFirstChild("Title") then
				TweenService:Create(TabFrame.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
				TabFrame.Title.Font = Enum.Font.GothamBlack
			end
			
			Container.Visible = true
		end)

		if FirstTab then
			FirstTab = false
			TabFrame.BackgroundColor3 = Color3.fromRGB(OrionLib.Themes[OrionLib.SelectedTheme].Second.R * 255 + 10, OrionLib.Themes[OrionLib.SelectedTheme].Second.G * 255 + 10, OrionLib.Themes[OrionLib.SelectedTheme].Second.B * 255 + 10)
			TabFrame.Indicator.Size = UDim2.new(0, 3, 0, 18)
			TabFrame.Ico.ImageTransparency = 0
			TabFrame.Title.TextTransparency = 0
			TabFrame.Title.Font = Enum.Font.GothamBlack
			Container.Visible = true
		end    

		return GetElements(Container, MainWindow, WindowStuff, SettingsOverlay, ToggleSettings)
	end  

	return TabFunction
end   

function OrionLib:Destroy()
	Orion:Destroy()
end

return OrionLib

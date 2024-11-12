--[[
    Bundler by @next.xrer.

    Using Rojo for build rbxm (Model) and bundle with wax what madded by LatteSoftworkers
--]]

-- Will be used later for getting flattened globals
local ImportGlobals

-- Holds the actual DOM data
local ObjectTree = {
    {
        1,
        "ModuleScript",
        {
            "MainModule"
        },
        {
            {
                3,
                "ModuleScript",
                {
                    "elements"
                },
                {
                    {
                        8,
                        "ModuleScript",
                        {
                            "dropdown"
                        }
                    },
                    {
                        9,
                        "ModuleScript",
                        {
                            "colorpicker"
                        }
                    },
                    {
                        6,
                        "ModuleScript",
                        {
                            "slider"
                        }
                    },
                    {
                        10,
                        "ModuleScript",
                        {
                            "button"
                        }
                    },
                    {
                        7,
                        "ModuleScript",
                        {
                            "rangeslider"
                        }
                    },
                    {
                        5,
                        "ModuleScript",
                        {
                            "textbox"
                        }
                    },
                    {
                        4,
                        "ModuleScript",
                        {
                            "toggle"
                        }
                    }
                }
            },
            {
                2,
                "ModuleScript",
                {
                    "tools"
                }
            },
            {
                11,
                "Folder",
                {
                    "components"
                },
                {
                    {
                        13,
                        "ModuleScript",
                        {
                            "section"
                        }
                    },
                    {
                        12,
                        "ModuleScript",
                        {
                            "tab"
                        }
                    }
                }
            }
        }
    }
}

-- Holds direct closure data
local ClosureBindings = {
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(1)local ElementsTable = require(script.elements)
local Tools = require(script.tools)

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Library = {
	Connections = {},
	Flags = {},
}

pcall(function()
    shared.NapkinGUILibrary:Destroy()
end)


local Create = Tools.Create
local AddConnection = Tools.AddConnection

local GUI = Create("ScreenGui", {
	Parent = game.Players.LocalPlayer.PlayerGui,
	ResetOnSpawn = false,
})

shared.NapkinGUILibrary = GUI

function Library:IsRunning()
	return GUI.Parent == game:GetService("CoreGui") --game.Players.LocalPlayer.PlayerGui --game:GetService("CoreGui")
end

task.spawn(function()
	while Library:IsRunning() do
		task.wait()
	end
	for i, Connection in pairs(Library.Connections) do
		Connection:Disconnect()
	end
end)

local function MakeDraggable(DragPoint, Main)
	pcall(function()
		local Dragging, DragInput, MousePos, FramePos = false
		AddConnection(DragPoint.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = true
				MousePos = Input.Position
				FramePos = Main.Position

				AddConnection(Input.Changed, function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)
		AddConnection(DragPoint.InputChanged, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement then
				DragInput = Input
			end
		end)
		AddConnection(UserInputService.InputChanged, function(Input)
			if
				(
					Input.UserInputType == Enum.UserInputType.MouseMovement
					or Input.UserInputType == Enum.UserInputType.Touch
				) and Dragging
			then
				local Delta = Input.Position - MousePos
				Main.Position = UDim2.new(
					FramePos.X.Scale,
					FramePos.X.Offset + Delta.X,
					FramePos.Y.Scale,
					FramePos.Y.Offset + Delta.Y
				)
			end
		end)
	end)
end

function Library:SafeCallback(Function, ...)
	if not Function then
		return
	end

	local Success, Event = pcall(Function, ...)
	if not Success then
		local _, i = Event:find(":%d+: ")

		if not i then
			return print(`Error: {Event}`)
		end

		return print(`Error: {Event:sub(i + 1)}`)
	end
end

local Elements = {}
Elements.__index = Elements
Elements.__namecall = function(Table, Key, ...)
	return Elements[Key](...)
end

for _, ElementComponent in ipairs(ElementsTable) do
	Elements["Add" .. ElementComponent.__type] = function(self, Config)
		-- self.Container = MainFrame.Container -- Testing Shit System
		self.Library = Library
		ElementComponent.Container = self.Container
		ElementComponent.Type = self.Type
		ElementComponent.Library = self.Library

		return ElementComponent:New(Config, self)
	end
end
Library.Elements = Elements

print(Elements)

function Library.Load(Title)
	Title = Title or "Title"

	local MenuToggle = false

	local ExitBtn = Create("TextButton", {
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -34, 0, 4),
		Size = UDim2.new(1, -8, 1, -8),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		Text = "",
	}, {
		Create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.8, 0, 0.8, 0),
			Name = "Hover",
		}, {
			Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
		}),
		Create("ImageLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, -9, 0.5, -9),
			Size = UDim2.new(0, 18, 0, 18),
			Image = "rbxassetid://6235536018",
			ImageColor3 = Color3.fromRGB(180, 180, 180),
			ScaleType = Enum.ScaleType.Crop,
			Name = "Ico",
		}),
	})

	AddConnection(ExitBtn.MouseEnter, function()
		TweenService:Create(
			ExitBtn.Hover,
			TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0 }
		):Play()
		TweenService:Create(
			ExitBtn.Ico,
			TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ ImageColor3 = Color3.fromRGB(255, 0, 68) }
		):Play()
	end)

	AddConnection(ExitBtn.MouseLeave, function()
		TweenService:Create(
			ExitBtn.Hover,
			TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ Size = UDim2.new(0.8, 0, 0.8, 0), BackgroundTransparency = 1 }
		):Play()
		TweenService:Create(
			ExitBtn.Ico,
			TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ ImageColor3 = Color3.fromRGB(180, 180, 180) }
		):Play()
	end)
	AddConnection(ExitBtn.MouseButton1Click, function()
		shared.NapkinGUILibrary:Destroy()
	end)

	local MenuBtn = Create("TextButton", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 4, 0, 4),
		Size = UDim2.new(1, -8, 1, -8),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		Text = "",
	}, {
		Create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0.8, 0, 0.8, 0),
			Name = "Hover",
		}, {
			Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
		}),
		Create("ImageLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, -8, 0.5, -8),
			Size = UDim2.new(0, 16, 0, 16),
			Image = "rbxassetid://7072718840",
			ImageColor3 = Color3.fromRGB(180, 180, 180),
			ScaleType = Enum.ScaleType.Crop,
			Name = "Ico",
		}),
	})

	AddConnection(MenuBtn.MouseEnter, function()
		TweenService:Create(
			MenuBtn.Hover,
			TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0 }
		):Play()
		TweenService:Create(
			MenuBtn.Ico,
			TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ ImageColor3 = Color3.fromRGB(255, 255, 255) }
		):Play()
	end)

	AddConnection(MenuBtn.MouseLeave, function()
		TweenService:Create(
			MenuBtn.Hover,
			TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ Size = UDim2.new(0.8, 0, 0.8, 0), BackgroundTransparency = 1 }
		):Play()
		TweenService:Create(
			MenuBtn.Ico,
			TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ ImageColor3 = Color3.fromRGB(180, 180, 180) }
		):Play()
	end)

	local MenuFrame = Create("Frame", {
		BackgroundColor3 = Color3.fromRGB(27, 27, 27),
		BorderSizePixel = 0,
		Position = UDim2.new(-1, -5, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
	}, {

		Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
		Create("Frame", {
			BackgroundColor3 = Color3.fromRGB(27, 27, 27),
			BorderSizePixel = 0,
			Position = UDim2.new(1, -5, 0, 0),
			Size = UDim2.new(0, 5, 1, 0),
		}),
		Create("Frame", {
			BackgroundColor3 = Color3.fromRGB(27, 27, 27),
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 5),
		}),
		Create("Frame", {
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
			Position = UDim2.new(1, -1, 0, 0),
			Size = UDim2.new(0, 1, 1, 0),
		}),
		Create("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Name = "Container",
		}, {
			Create("UIPadding", {
				PaddingBottom = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 10),
			}),
			Create("UIListLayout"),
		}),
	})

	local MainFrame = Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 480, 0, 380),
		Parent = GUI,
	}, {
		Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
		Create("ImageLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, -15, 0, -15),
			Size = UDim2.new(1, 30, 1, 30),
			Image = "http://www.roblox.com/asset/?id=5554236805",
			ImageColor3 = Color3.fromRGB(10, 10, 10),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(23, 23, 277, 277),
		}),
		Create("Folder", { Name = "Container" }),
		Create("TextButton", {
			Size = UDim2.new(1, 0, 1, -38),
			Position = UDim2.new(0, 0, 0, 38),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			Name = "Darken",
			BorderSizePixel = 0,
			Visible = false,
		}),
		Create("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Position = UDim2.new(0, 0, 0, 36),
			Size = UDim2.new(0.4, 0, 1, -36),
		}, {
			MenuFrame,
		}),
		Create("Frame", {
			BackgroundColor3 = Color3.fromRGB(27, 27, 27),
			Size = UDim2.new(1, 0, 0, 38),
			Position = UDim2.new(0, 0, 0, -1),
			Name = "TopBar",
		}, {
			Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
			Create("Frame", {
				BackgroundColor3 = Color3.fromRGB(27, 27, 27),
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 1, -5),
				Size = UDim2.new(1, 0, 0, 5),
			}),
			Create("Frame", {
				BackgroundColor3 = Color3.fromRGB(50, 50, 50),
				BackgroundTransparency = 0.4,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, 1),
			}),
			Create("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Font = Enum.Font.Gotham,
				Text = Title,
				TextColor3 = Color3.fromRGB(180, 180, 180),
				TextSize = 14,
				RichText = true,
			}),
			ExitBtn,
			MenuBtn,
		}),
	})

	shared.NapkinLibrary = MainFrame

	AddConnection(MenuBtn.MouseButton1Click, function()
		MenuToggle = not MenuToggle
		TweenService:Create(
			MenuFrame,
			TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ Position = MenuToggle and UDim2.new(0, 0, 0, 0) or UDim2.new(-1, -5, 0, 0) }
		):Play()
		TweenService:Create(
			MainFrame.Darken,
			TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ BackgroundTransparency = MenuToggle and 0.8 or 1 }
		):Play()
		MainFrame.Darken.Visible = MenuToggle
	end)

	MakeDraggable(MainFrame.TopBar, MainFrame)

	local Tabs = {}

	local TabModule = require(script.components.tab):Init(MainFrame.Container)
	function Tabs:AddTab(title)
		return TabModule:New(title, MenuFrame.Container)
	end
	function Tabs:SelectTab(Tab)
		TabModule:SelectTab(1)
	end

	return Tabs
end

return Library
 end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(2)local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local tools = { Signals = {} }

function tools.AddConnection(Signal, Function)
	table.insert(tools.Signals, Signal:Connect(Function))
end
	
function tools.Create(Name, Properties, Children)
	local Object = Instance.new(Name)
	for i, v in next, Properties or {} do
		Object[i] = v
	end
	for i, v in next, Children or {} do
		v.Parent = Object
	end
	return Object
end

function tools.Ripple(Object)
	local Circle = tools.Create("ImageLabel", {
		Parent = Object,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Image = "rbxassetid://266543268",
		ImageColor3 = Color3.fromRGB(210,210,210),
		ImageTransparency = 0.88
	})
	Circle.Position = UDim2.new(0, Mouse.X - Circle.AbsolutePosition.X, 0, Mouse.Y - Circle.AbsolutePosition.Y)
	local Size = Object.AbsoluteSize.X / 1.5
	TweenService:Create(Circle, TweenInfo.new(0.5), {Position = UDim2.fromScale(math.clamp(Mouse.X - Object.AbsolutePosition.X, 0, Object.AbsoluteSize.X)/Object.AbsoluteSize.X,Object,math.clamp(Mouse.Y - Object.AbsolutePosition.Y, 0, Object.AbsoluteSize.Y)/Object.AbsoluteSize.Y) - UDim2.fromOffset(Size/2,Size/2), ImageTransparency = 1, Size = UDim2.fromOffset(Size,Size)}):Play()
	spawn(function()
		wait(0.5)
		Circle:Destroy()
	end)
end 

return tools
 end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(3)local Elements = {}

for _, v in next, script:GetChildren() do
	table.insert(Elements, require(v))
end

print(Elements)
return Elements end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(4)local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Tools = require(script.Parent.Parent.tools)

local Create = Tools.Create
local AddConnection = Tools.AddConnection
local Ripple = Tools.Ripple

local Element = {}
Element.__index = Element
Element.__type = "Toggle"

function Element:New(ToggleConfig)
	ToggleConfig.Name = ToggleConfig.Name or "Toggle"
	ToggleConfig.IgnoreFirst = ToggleConfig.IgnoreFirst or false
	ToggleConfig.Default = ToggleConfig.Default or false
	ToggleConfig.Callback = ToggleConfig.Callback or function() end

	local Toggle = {Value = ToggleConfig.Default, Type = "Toggle"}

	local TogglePopUp = Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 150, 100),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
		Create("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -2, 1, -2),
			Image = "http://www.roblox.com/asset/?id=6031094667",
			ImageTransparency = 1,
			Name = "Ico"
		})
	})

	local ToggleBox = Create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Color3.fromRGB(28, 28, 28),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.new(0, 20, 0, 20),
		BackgroundTransparency = 1
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
		Create("UIStroke", {Color = Color3.fromRGB(55, 55, 55)}),
		TogglePopUp
	})

	local ToggleFrame = Create("TextButton", {
		BackgroundColor3 = Color3.fromRGB(28, 28, 28),
		Size = UDim2.new(1, 0, 0, 32),
		Parent = self.Container,
		AutoButtonColor = false,
		ClipsDescendants = true,
		Text = ""
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
		Create("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(1, -10, 1, 0),
			Font = Enum.Font.Gotham,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = ToggleConfig.Name
		}),
		ToggleBox
	})

	AddConnection(ToggleFrame.MouseEnter, function()
		TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
	end)

	AddConnection(ToggleFrame.MouseLeave, function()
		TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play()
	end)

	AddConnection(ToggleFrame.MouseButton1Down, function()
		TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(33, 33, 33)}):Play()
	end)

	AddConnection(ToggleFrame.MouseButton1Up, function()
		TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
		Toggle:Set(not Toggle.Value)
	end)

	function Toggle:Set(Value,ignore)
		self.Value = Value
		TweenService:Create(TogglePopUp, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),{BackgroundTransparency = self.Value and 0 or 1, Size = self.Value and UDim2.new(1, 0, 1, 0) or UDim2.new(0.5, 0, 0.5, 0)}):Play()
		TweenService:Create(TogglePopUp.Ico, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),{ImageTransparency = self.Value and 0 or 1}):Play()
		if not ignore then return ToggleConfig.Callback(self.Value) end
	end

	function Toggle:Visible(bool)
		ToggleFrame.Visible = bool
	end

	Toggle:Set(Toggle.Value,ToggleConfig.IgnoreFirst)

	return Toggle
end

return Element
 end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(5)local TweenService = game:GetService("TweenService")

local Tools = require(script.Parent.Parent.tools)

local Create = Tools.Create
local AddConnection = Tools.AddConnection
local Ripple = Tools.Ripple

local Element = {}
Element.__index = Element
Element.__type = "Textbox"

function Element:New(TextboxConfig)
	TextboxConfig.Name = TextboxConfig.Name or "Textbox"
	TextboxConfig.Default = TextboxConfig.Default or ""
	TextboxConfig.TextDisappear = TextboxConfig.TextDisappear or false
	TextboxConfig.Callback = TextboxConfig.Callback or function() end

	local TextboxActual = Create("TextBox", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Color3.fromRGB(36, 36, 36),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.new(0, 20, 0, 20),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		PlaceholderColor3 = Color3.fromRGB(210, 210, 210),
		PlaceholderText = "Write here...",
		TextXAlignment = Enum.TextXAlignment.Right,
		Text = TextboxConfig.Default,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		ClearTextOnFocus = false,
	}, {
		Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
		Create("UIPadding", { PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) }),
	})

	local TextboxFrame = Create("TextButton", {
		BackgroundColor3 = Color3.fromRGB(28, 28, 28),
		Size = UDim2.new(1, 0, 0, 32),
		Parent = self.Container,
		AutoButtonColor = false,
		ClipsDescendants = true,
		Text = "",
	}, {
		Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
		Create("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(1, -10, 1, 0),
			Font = Enum.Font.Gotham,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = TextboxConfig.Name,
		}),
		TextboxActual,
	})

	AddConnection(TextboxFrame.MouseButton1Click, function()
		TextboxActual:CaptureFocus()
	end)

	AddConnection(TextboxActual.FocusLost, function()
		TextboxConfig.Callback(TextboxActual.Text)
		if TextboxConfig.TextDisappear then
			TextboxActual.Text = ""
		end
	end)

	AddConnection(TextboxActual:GetPropertyChangedSignal("Text"), function()
		TextboxActual.Size = UDim2.new(0, TextboxActual.TextBounds.X + 10, 0, 20)
	end)
	TextboxActual.Size = UDim2.new(0, TextboxActual.TextBounds.X + 10, 0, 20)
end

return Element
 end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(6)local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Tools = require(script.Parent.Parent.tools)

local Create = Tools.Create
local AddConnection = Tools.AddConnection
local Ripple = Tools.Ripple

local function Round(Number, Factor)
	local Result = math.floor(Number/Factor + (math.sign(Number) * 0.5)) * Factor
	if Result < 0 then Result = Result + Factor end
	return Result
end

local Element = {}
Element.__index = Element
Element.__type = "Slider"

function Element:New(SliderConfig)
	SliderConfig.Name = SliderConfig.Name or "Slider"
	SliderConfig.Min = SliderConfig.Min or 10
	SliderConfig.Max = SliderConfig.Max or 20
	SliderConfig.Increment = SliderConfig.Increment or 1
	SliderConfig.Default = SliderConfig.Default or 0
	SliderConfig.IgnoreFirst = SliderConfig.IgnoreFirst or false
	SliderConfig.TextBoxValue = SliderConfig.TextBoxValue or false
	SliderConfig.Callback = SliderConfig.Callback or function() end
	local Slider = {Value = SliderConfig.Default, Type = "Slider"}
	local Dragging = false

	local ValueText

	if SliderConfig.TextBoxValue then
		ValueText = Create("TextBox", {
			CursorPosition = -1,
			Font = Enum.Font.Gotham,
			PlaceholderColor3 = Color3.fromRGB(210,210,210),
			PlaceholderText = "Value Here!",
			Text = "",
			TextColor3 = Color3.fromRGB(255,255,255),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Right,
			AnchorPoint = Vector2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = Color3.fromRGB(36,36,36),
			Position = UDim2.new(1, -10, 0, 5),
			Size = UDim2.new(0, 50, 0, 20),
			Visible = true,
			Parent = workspace,
		}, {
			Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
			Create("UIPadding", {PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
		})
	else
		ValueText = Create("TextLabel", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -10, 0, 5),
			Size = UDim2.new(1, -20, 0, 32),
			Font = Enum.Font.Gotham,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Right,
			Text = ""
		})
	end

	local SliderProgress = Create("Frame", {
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		BorderSizePixel = 0
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 4)})
	})

	local SliderDot = Create("TextButton", {
		Position = UDim2.new(0.5, -6, 0.5, -6),
		Size = UDim2.new(0, 12, 0, 12),
		BackgroundColor3 = Color3.fromRGB(55, 55, 55),
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = ""
	}, {
		Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
		Create("UIStroke", {Color = Color3.fromRGB(65, 65, 65), ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
	})

	local SliderBar = Create("Frame", {
		Position = UDim2.new(0, 10, 0, 30),
		Size = UDim2.new(1, -20, 0, 4),
		BackgroundColor3 = Color3.fromRGB(36, 36, 36),
		BorderSizePixel = 0
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
		Create("UIStroke", {Color = Color3.fromRGB(55, 55, 55)}),
		SliderProgress,
		SliderDot
	})

	local SliderFrame = Create("TextButton", {
		BackgroundColor3 = Color3.fromRGB(28, 28, 28),
		Size = UDim2.new(1, 0, 0, 42),
		Parent = self.Container,
		AutoButtonColor = false,
		ClipsDescendants = true,
		Text = ""
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
		Create("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(1, -10, 0, 32),
			Font = Enum.Font.Gotham,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = SliderConfig.Name
		}),
		ValueText,
		SliderBar
	})

	AddConnection(SliderDot.InputBegan, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
			Dragging = true;
		end 
	end)

	AddConnection(SliderDot.InputEnded, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
			Dragging = false;
		end 
	end)

	AddConnection(UserInputService.InputChanged, function(Input)
		if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			local SizeScale = math.clamp((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
			Slider:Set(SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale)) 
		end
	end)

	AddConnection(ValueText:GetPropertyChangedSignal("Text"), function()
		ValueText.Size = UDim2.new(0,ValueText.TextBounds.X + 10,0,20)
	end)
	ValueText.Size = UDim2.new(0,ValueText.TextBounds.X + 10,0,20)

	if SliderConfig.TextBoxValue then
		AddConnection(ValueText.FocusLost, function()
			if (tonumber(ValueText.Text)) then
				Slider:Set(ValueText.Text)
			else
				warn("only int allowed")
			end
		end)
	end

	function Slider:Set(Value,ignore)
		self.Value = math.clamp(Round(Value, SliderConfig.Increment), SliderConfig.Min, SliderConfig.Max)
		ValueText.Text = tostring(self.Value)
		TweenService:Create(SliderDot,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Position = UDim2.new((self.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), -6, 0.5, -6)}):Play()
		TweenService:Create(SliderProgress,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = UDim2.fromScale((self.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 1)}):Play()
		if not ignore then return SliderConfig.Callback(self.Value) end
	end   

	function Slider:Visible(bool)
		SliderFrame.Visible = bool
	end

	Slider:Set(Slider.Value,SliderConfig.IgnoreFirst)
	return Slider
end

return Element
 end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(7)local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Tools = require(script.Parent.Parent.tools)

local Create = Tools.Create
local AddConnection = Tools.AddConnection
local Ripple = Tools.Ripple

local function Round(Number, Factor)
	local Result = math.floor(Number/Factor + (math.sign(Number) * 0.5)) * Factor
	if Result < 0 then Result = Result + Factor end
	return Result
end

local Element = {}
Element.__index = Element
Element.__type = "RangeSlider"

function Element:New(SliderConfig)
	SliderConfig.Name = SliderConfig.Name or "RangeSlider"
	SliderConfig.Min = SliderConfig.Min or 10
	SliderConfig.Max = SliderConfig.Max or 20
	SliderConfig.Increment = SliderConfig.Increment or 1
	SliderConfig.DefaultMin = SliderConfig.DefaultMin or SliderConfig.Min
	SliderConfig.DefaultMax = SliderConfig.DefaultMax or SliderConfig.Max
	SliderConfig.IgnoreFirst = SliderConfig.IgnoreFirst or false
	SliderConfig.Callback = SliderConfig.Callback or function() end

	local Slider = {MinValue = SliderConfig.DefaultMin, MaxValue = SliderConfig.DefaultMax, Type = "RangeSlider"}
	local DraggingMin = false
	local DraggingMax = false

	local SliderProgress = Create("Frame", {
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		BorderSizePixel = 0
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 4)})
	})

	local function CreateSliderDot()
		return Create("TextButton", {
			Position = UDim2.new(0.5, -6, 0.5, -6),
			Size = UDim2.new(0, 12, 0, 12),
			BackgroundColor3 = Color3.fromRGB(55, 55, 55),
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = ""
		}, {
			Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
			Create("UIStroke", {Color = Color3.fromRGB(65, 65, 65), ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
		})
	end

	local SliderDotMin = CreateSliderDot()
	local SliderDotMax = CreateSliderDot()

	local SliderBar = Create("Frame", {
		Position = UDim2.new(0, 10, 0, 30),
		Size = UDim2.new(1, -20, 0, 4),
		BackgroundColor3 = Color3.fromRGB(36, 36, 36),
		BorderSizePixel = 0
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
		Create("UIStroke", {Color = Color3.fromRGB(55, 55, 55)}),
		SliderProgress,
		SliderDotMin,
		SliderDotMax
	})

	local ValueText = Create("TextLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 0),
		Size = UDim2.new(1, -20, 0, 32),
		Font = Enum.Font.Gotham,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Right,
		Text = ""
	})

	local SliderFrame = Create("TextButton", {
		BackgroundColor3 = Color3.fromRGB(28, 28, 28),
		Size = UDim2.new(1, 0, 0, 42),
		Parent = self.Container,
		AutoButtonColor = false,
		ClipsDescendants = true,
		Text = ""
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
		Create("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(1, -10, 0, 32),
			Font = Enum.Font.Gotham,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = SliderConfig.Name
		}),
		SliderBar,
		ValueText
	})

	function Slider:Set(settings)
		if settings.MinValue then
			Slider.MinValue = math.clamp(Round(settings.MinValue, SliderConfig.Increment), SliderConfig.Min, Slider.MaxValue)
		end
		if settings.MaxValue then
			Slider.MaxValue = math.clamp(Round(settings.MaxValue, SliderConfig.Increment), Slider.MinValue, SliderConfig.Max)
		end

		local minScale = (Slider.MinValue - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
		local maxScale = (Slider.MaxValue - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)

		TweenService:Create(SliderDotMin, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(minScale, -6, 0.5, -6)}):Play()
		TweenService:Create(SliderDotMax, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(maxScale, -6, 0.5, -6)}):Play()
		TweenService:Create(SliderProgress, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(minScale, 0, 0, 0), Size = UDim2.new(maxScale - minScale, 0, 1, 0)}):Play()

		ValueText.Text = Slider.MinValue .. " - " .. Slider.MaxValue
		SliderConfig.Callback(Slider.MinValue, Slider.MaxValue)
	end

	AddConnection(SliderDotMin.InputBegan, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
			DraggingMin = true
		end 
	end)

	AddConnection(SliderDotMin.InputEnded, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
			DraggingMin = false
		end 
	end)

	AddConnection(SliderDotMax.InputBegan, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
			DraggingMax = true
		end 
	end)

	AddConnection(SliderDotMax.InputEnded, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
			DraggingMax = false
		end 
	end)

	AddConnection(UserInputService.InputChanged, function(Input)
		if (DraggingMin or DraggingMax) and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			local SizeScale = math.clamp((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
			if DraggingMin then
				Slider:Set({MinValue = SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale)})
			elseif DraggingMax then
				Slider:Set({MaxValue = SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * SizeScale)})
			end
		end
	end)

	function Slider:Visible(bool)
		SliderFrame.Visible = bool
	end

	Slider:Set({MinValue = Slider.MinValue, MaxValue = Slider.MaxValue})
	return Slider
end

return Element
 end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(8)local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Tools = require(script.Parent.Parent.tools)

local Create = Tools.Create
local AddConnection = Tools.AddConnection
local Ripple = Tools.Ripple

local function Ripple(Object)
	local Circle = Create("ImageLabel", {
		Parent = Object,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Image = "rbxassetid://266543268",
		ImageColor3 = Color3.fromRGB(210,210,210),
		ImageTransparency = 0.88
	})
	Circle.Position = UDim2.new(0, Mouse.X - Circle.AbsolutePosition.X, 0, Mouse.Y - Circle.AbsolutePosition.Y)
	local Size = Object.AbsoluteSize.X / 1.5
	TweenService:Create(Circle, TweenInfo.new(0.5), {Position = UDim2.fromScale(math.clamp(Mouse.X - Object.AbsolutePosition.X, 0, Object.AbsoluteSize.X)/Object.AbsoluteSize.X,Object,math.clamp(Mouse.Y - Object.AbsolutePosition.Y, 0, Object.AbsoluteSize.Y)/Object.AbsoluteSize.Y) - UDim2.fromOffset(Size/2,Size/2), ImageTransparency = 1, Size = UDim2.fromOffset(Size,Size)}):Play()
	spawn(function()
		wait(0.5)
		Circle:Destroy()
	end)
end 

local Element = {}
Element.__index = Element
Element.__type = "Dropdown"

function Element:New(DropdownConfig)
	DropdownConfig = DropdownConfig or {}
	DropdownConfig.Name = DropdownConfig.Name or "Dropdown"
	DropdownConfig.Options = DropdownConfig.Options or {}
	DropdownConfig.Default = DropdownConfig.Default or ""
	DropdownConfig.IgnoreFirst = DropdownConfig.IgnoreFirst or false
	DropdownConfig.Multiple = DropdownConfig.Multiple or false
	DropdownConfig.MaxOptions = DropdownConfig.MaxOptions or math.huge

	DropdownConfig.Callback = DropdownConfig.Callback or function() end

	local Dropdown = {Value = DropdownConfig.Default, Options = DropdownConfig.Options, Buttons = {}, Toggled = false, Type = "Dropdown"}
	local MaxElements = 5

	-- if not table.find(Dropdown.Options, Dropdown.Value) then
	--     Dropdown.Value = "..."
	-- end

	local DropdownLayout = Create("UIListLayout")

	local DropdownContainer = Create("ScrollingFrame", {
		Position = UDim2.new(0, 0, 0, 32),
		Size = UDim2.new(1, 0, 1, -32),
		BackgroundTransparency = 1,
		MidImage = "rbxassetid://7445543667",
		BottomImage = "rbxassetid://7445542488",
		TopImage = "rbxassetid://7445543667",
		ScrollBarImageColor3 = Color3.fromRGB(35, 35, 35),
		ScrollBarThickness = 4,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		BorderSizePixel = 0
	}, {
		DropdownLayout
	})

	local DropdownArrow = Create("ImageLabel", {
		Image = "rbxassetid://7072706745",
		BackgroundTransparency = 1,
		ImageColor3 = Color3.fromRGB(165, 165, 165),
		Size = UDim2.new(0, 16, 0, 16),
		Position = UDim2.new(1, -24, 0.5, -8)
	})

	local ValueText = Create("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 0),
		Size = UDim2.new(1, -38, 1, 0),
		Font = Enum.Font.Gotham,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 13,
		TextTransparency = 0.4,
		TextXAlignment = Enum.TextXAlignment.Right,
		Text = ""
	})

	local DropdownBtn = Create("TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 32),
		AutoButtonColor = false,
		ClipsDescendants = true,
		Text = ""
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
		Create("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(1, -10, 1, 0),
			Font = Enum.Font.Gotham,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = DropdownConfig.Name
		}),
		ValueText,
		DropdownArrow
	})

	local DropdownFrame = Create("TextButton", {
		BackgroundColor3 = Color3.fromRGB(28, 28, 28),
		Size = UDim2.new(1, 0, 0, 32),
		Parent = self.Container,
		ClipsDescendants = true,
		Text = "",
		AutoButtonColor = false
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
		DropdownBtn,
		DropdownContainer,
		Create("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 32),
			ClipsDescendants = true,
			BackgroundColor3 = Color3.fromRGB(50, 50, 50),
			BackgroundTransparency = 0.4,
			BorderSizePixel = 0
		})
	})

	AddConnection(DropdownLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		DropdownContainer.CanvasSize = UDim2.new(0, 0, 0, DropdownLayout.AbsoluteContentSize.Y)
	end)

	local function AddOptions(Options)
		for _, Option in pairs(Options) do
			local OptionBtn = Create("TextButton", {
				Parent = DropdownContainer,
				Size = UDim2.new(1, 0, 0, 26),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				AutoButtonColor = false,
				BackgroundColor3 = Color3.fromRGB(36, 36, 36),
				Text = ""
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
				Create("TextLabel", {
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 10, 0, 0),
					Size = UDim2.new(1, -10, 1, 0),
					Font = Enum.Font.Gotham,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = Option,
					Name = "Title"
				})
			})

			AddConnection(OptionBtn.MouseButton1Click, function()
				Dropdown:Set(Option)
				Ripple(OptionBtn)
			end)

			Dropdown.Buttons[Option] = OptionBtn
		end
	end	

	function Dropdown:Refresh(Options, Delete)
		if Delete then
			for _,v in pairs(Dropdown.Buttons) do
				v:Destroy()
			end    
			table.clear(Dropdown.Options)
			table.clear(Dropdown.Buttons)
		end
		Dropdown.Options = Options
		AddOptions(Dropdown.Options)
	end  

	function Dropdown:Set(Value,ignore)
		if DropdownConfig.Multiple then
			if type(Dropdown.Value) ~= "table" then Dropdown.Value = {Dropdown.Value} end
			if table.find(Dropdown.Value,Value) then
				table.remove(Dropdown.Value,table.find(Dropdown.Value,Value))
			else
				if #Dropdown.Value < (DropdownConfig.MaxOptions or math.huge) then
					table.insert(Dropdown.Value,Value)
				end
			end
		else
			Dropdown.Value = Value
		end

		local found = DropdownConfig.Multiple and true or table.find(Dropdown.Options, Value)
		if DropdownConfig.Multiple then
			for i1,v1 in pairs(Dropdown.Value) do if not table.find(Dropdown.Options, v1) then table.remove(Dropdown.Value,i1) end end
			if #Dropdown.Value < 1 then found = false end
		end
		if not found then
			Dropdown.Value = DropdownConfig.Multiple and {} or "..."
			ValueText.Text = "..."
			for _, v in pairs(Dropdown.Buttons) do
				TweenService:Create(v,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{BackgroundTransparency = 1}):Play()
				TweenService:Create(v.Title,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = 0.4}):Play()
			end
			return
		end

		ValueText.Text = DropdownConfig.Multiple and table.concat(Dropdown.Value,", ") or Dropdown.Value

		for i, v in pairs(Dropdown.Buttons) do
			if (DropdownConfig.Multiple and table.find(Dropdown.Value,i)) or (not DropdownConfig.Multiple and i == Value) then
				TweenService:Create(v,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{BackgroundTransparency = 0}):Play()
				TweenService:Create(v.Title,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = 0}):Play()
			else
				TweenService:Create(v,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{BackgroundTransparency = 1}):Play()
				TweenService:Create(v.Title,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = 0.4}):Play()
			end
		end

		if not ignore then return DropdownConfig.Callback(Dropdown.Value) end
	end

	AddConnection(DropdownBtn.MouseButton1Click, function()
		Dropdown.Toggled = not Dropdown.Toggled
		TweenService:Create(DropdownArrow,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Rotation = Dropdown.Toggled and 90 or 0}):Play()
		if #Dropdown.Options > MaxElements then
			TweenService:Create(DropdownFrame,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = Dropdown.Toggled and UDim2.new(1, 0, 0, 32 + (MaxElements * 26)) or UDim2.new(1, 0, 0, 32)}):Play()
		else
			TweenService:Create(DropdownFrame,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = Dropdown.Toggled and UDim2.new(1, 0, 0, DropdownLayout.AbsoluteContentSize.Y + 32) or UDim2.new(1, 0, 0, 32)}):Play()
		end	
	end)

	function Dropdown:Visible(bool)
		DropdownFrame.Visible = bool
	end

	Dropdown:Refresh(Dropdown.Options, false)
	Dropdown:Set(Dropdown.Value,DropdownConfig.IgnoreFirst)
	return Dropdown
end

return Element
 end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(9)local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Tools = require(script.Parent.Parent.tools)

local Create = Tools.Create
local AddConnection = Tools.AddConnection
local Ripple = Tools.Ripple

local Element = {}
Element.__index = Element
Element.__type = "Colorpicker"

function Element:New(ColorpickerConfig)
	ColorpickerConfig.Name = ColorpickerConfig.Name or "Colorpicker"
	ColorpickerConfig.Default = ColorpickerConfig.Default or Color3.fromRGB(255, 255, 255)
	ColorpickerConfig.Callback = ColorpickerConfig.Callback or function() end

	local ColorH, ColorS, ColorV = 1, 1, 1
	local Colorpicker = { Value = ColorpickerConfig.Default, Toggled = false, Type = "Colorpicker" }

	local ColorSelection = Create("ImageLabel", {
		Size = UDim2.new(0, 18, 0, 18),
		Position = UDim2.new(select(3, Color3.toHSV(Colorpicker.Value))),
		ScaleType = Enum.ScaleType.Fit,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = "http://www.roblox.com/asset/?id=4805639000",
	})

	local HueSelection = Create("ImageLabel", {
		Size = UDim2.new(0, 18, 0, 18),
		Position = UDim2.new(0.5, 0, 1 - select(1, Color3.toHSV(Colorpicker.Value))),
		ScaleType = Enum.ScaleType.Fit,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = "http://www.roblox.com/asset/?id=4805639000",
	})

	local Color = Create("ImageLabel", {
		Size = UDim2.new(1, -25, 1, 0),
		Visible = false,
		Image = "rbxassetid://4155801252",
	}, {
		Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
		ColorSelection,
	})

	local Hue = Create("Frame", {
		Size = UDim2.new(0, 20, 1, 0),
		Position = UDim2.new(1, -20, 0, 0),
		Visible = false,
	}, {
		Create(
			"UIGradient",
			{
				Rotation = 270,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)),
					ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)),
					ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)),
					ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)),
					ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)),
					ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)),
					ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4)),
				}),
			}
		),
		Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
		HueSelection,
	})

	local ColorpickerContainer = Create("Frame", {
		Position = UDim2.new(0, 0, 0, 32),
		Size = UDim2.new(1, 0, 1, -32),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	}, {
		Hue,
		Color,
		Create("UIPadding", {
			PaddingLeft = UDim.new(0, 35),
			PaddingRight = UDim.new(0, 35),
			PaddingBottom = UDim.new(0, 8),
			PaddingTop = UDim.new(0, 4),
		}),
	})

	local ColorDot = Create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.new(0, 20, 0, 20),
	}, {
		Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
		Create("UIStroke", { Color = Color3.fromRGB(55, 55, 55) }),
	})

	local ColorBtn = Create("TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 32),
		AutoButtonColor = false,
		ClipsDescendants = true,
		Text = "",
	}, {
		Create("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(1, -10, 1, 0),
			Font = Enum.Font.Gotham,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = ColorpickerConfig.Name,
		}),
		ColorDot,
	})

	local ColorFrame = Create("TextButton", {
		BackgroundColor3 = Color3.fromRGB(28, 28, 28),
		Size = UDim2.new(1, 0, 0, 32),
		Parent = self.Container,
		AutoButtonColor = false,
		ClipsDescendants = true,
		Text = "",
	}, {
		Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
		ColorBtn,
		ColorpickerContainer,
	})

	local function UpdateColorPicker()
		ColorDot.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
		Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
		Colorpicker:Set(ColorDot.BackgroundColor3)
		ColorpickerConfig.Callback(ColorDot.BackgroundColor3)
	end

	AddConnection(ColorBtn.MouseButton1Click, function()
		Colorpicker.Toggled = not Colorpicker.Toggled
		TweenService:Create(
			ColorFrame,
			TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Size = Colorpicker.Toggled and UDim2.new(1, 0, 0, 142) or UDim2.new(1, 0, 0, 32) }
		):Play()
		Color.Visible = Colorpicker.Toggled
		Hue.Visible = Colorpicker.Toggled
	end)

	ColorH = 1
		- (
			math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y)
			/ Hue.AbsoluteSize.Y
		)
	ColorS = (
		math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X)
		/ Color.AbsoluteSize.X
	)
	ColorV = 1
		- (
			math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y)
			/ Color.AbsoluteSize.Y
		)

	Colorpicker.Value = ColorpickerConfig.Default
	ColorDot.BackgroundColor3 = Colorpicker.Value
	Color.BackgroundColor3 = Colorpicker.Value
	ColorpickerConfig.Callback(Colorpicker.Value)

	AddConnection(Color.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if ColorInput then
				ColorInput:Disconnect()
			end
			ColorInput = AddConnection(RunService.RenderStepped, function()
				local ColorX = (
					math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X
				)
				local ColorY = (
					math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y
				)
				ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
				ColorS = ColorX
				ColorV = 1 - ColorY
				UpdateColorPicker()
			end)
		end
	end)

	AddConnection(Color.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if ColorInput then
				ColorInput:Disconnect()
			end
		end
	end)

	AddConnection(Hue.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if HueInput then
				HueInput:Disconnect()
			end

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
			if HueInput then
				HueInput:Disconnect()
			end
		end
	end)

	function Colorpicker:Set(Value)
		Colorpicker.Value = Value
		ColorDot.BackgroundColor3 = Colorpicker.Value
		ColorpickerConfig.Callback(Colorpicker.Value)
	end

	function Colorpicker:Visible(bool)
		ColorFrame.Visible = bool
	end

	return Colorpicker
end

return Element
 end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(10)local TweenService = game:GetService("TweenService")

local Tools = require(script.Parent.Parent.tools)

local Create = Tools.Create
local AddConnection = Tools.AddConnection
local Ripple = Tools.Ripple

local Element = {}
Element.__index = Element
Element.__type = "Button"

function Element:New(Config)
	assert(Config.Title, "Button - Missing Title")
	Config.Callback = Config.Callback or function() end
	print(Config)
	print(self)
	local Button = {}

	local ButtonFrame = Create("TextButton", {
		BackgroundColor3 = Color3.fromRGB(28, 28, 28),
		Size = UDim2.new(1, 0, 0, 32),
		Parent = self.Container,
		AutoButtonColor = false,
		ClipsDescendants = true,
		Text = ""
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 5)})
	})
	local textLabel = Create("TextLabel", {
		Parent = ButtonFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 0),
		Size = UDim2.new(1, -10, 1, 0),
		Font = Enum.Font.Gotham,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = Config.Title
	})

	

	--local AddConnection = self.Library:AddConnection()

	AddConnection(ButtonFrame.MouseEnter, function()
		TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
	end)

	AddConnection(ButtonFrame.MouseLeave, function()
		TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play()
	end)

	AddConnection(ButtonFrame.MouseButton1Down, function()
		TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(33, 33, 33)}):Play()
	end)

	AddConnection(ButtonFrame.MouseButton1Up, function()
		TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
		Ripple(ButtonFrame)
		Config.Callback()
		--self.Library:SafeCallback(Config.Callback)
	end)

	function Button:Set(text)
		Config.Name = text or "Button"
		textLabel.Text = Config.Name
	end

	function Button:Visible(bool)
		ButtonFrame.Visible = bool
	end

	
	return Button
end

return Element
 end,
    [12] = function()local maui,script,require,getfenv,setfenv=ImportGlobals(12)local Tools = require(script.Parent.Parent.tools)

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local http = game:GetService("HttpService")

local Create = Tools.Create
local AddConnection = Tools.AddConnection

local TabModule = {
    Window = nil,
    Tabs = {},
    Containers = {},
    SelectedTab = 0,
    TabCount = 0,
}

function TabModule:Init(Window)
    TabModule.Window = Window
    return TabModule
end



function TabModule:New(Title, Parent)
	local Library = require(script.Parent.Parent)
	local Window = TabModule.Window
	local Elements = Library.Elements

	TabModule.TabCount = TabModule.TabCount + 1
	local TabIndex = TabModule.TabCount

	local Tab = {
		Selected = false,
		Name = Title,
		Type = "Tab",
	}

	Tab.TabBtn = Create("TextButton", {
		Parent = Parent,
		BackgroundColor3 = Color3.fromRGB(0, 150, 100),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 35),
		Text = "",
		AutoButtonColor = false
	}, {
		Create("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(1, -10, 1, 0),
			Font = Enum.Font.Gotham,
			Text = Title,
			TextColor3 = Color3.fromRGB(165, 165, 165),
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			Name = "Title"
		})
	})

	Tab.Container = Create("ScrollingFrame", {
		Parent = TabModule.Window,
		Size = UDim2.new(1, 0, 1, -38),
		Position = UDim2.new(0, 0, 0, 38),
		BackgroundTransparency = 1,
		Visible = false,
		MidImage = "rbxassetid://7445543667",
		BottomImage = "rbxassetid://7445542488",
		TopImage = "rbxassetid://7445543667",
		ScrollBarImageColor3 = Color3.fromRGB(27, 27, 27),
		ScrollBarThickness = 6,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		BorderSizePixel = 0
	}, {
		Create("UIPadding", {
			PaddingBottom = UDim.new(0, 14),
			PaddingTop = UDim.new(0, 14),
			PaddingLeft = UDim.new(0, 16),
			PaddingRight = UDim.new(0, 16),
		}),
		Create("UIListLayout", {
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
		})
	})

	AddConnection(Tab.Container.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		Tab.Container.CanvasSize = UDim2.new(0, 0, 0, Tab.Container.UIListLayout.AbsoluteContentSize.Y + 28)
	end)

	Tab.ContainerFrame = Tab.Container

	AddConnection(Tab.TabBtn.MouseButton1Click, function()
		TabModule:SelectTab(TabIndex)
	end)

	TabModule.Containers[TabIndex] = Tab.ContainerFrame
	TabModule.Tabs[TabIndex] = Tab

	-- if Title == "Credit's" then
		
	-- end

	function Tab:GetPath()
		return Tab.ContainerFrame
	end

	function Tab:AddSection(SectionTitle)
		local Section = { Type = "Section" }

		local SectionFrame = require(script.Parent.section)(SectionTitle, Tab.Container)
		Section.Container = SectionFrame.SectionContainer

		setmetatable(Section, Elements)
		return Section
	end

	setmetatable(Tab, Elements)
	return Tab
end

function TabModule:SelectTab(Tab)
	TabModule.SelectedTab = Tab

	print(TabModule.Tabs)

	for _, v in next, TabModule.Tabs do
		TweenService:Create(v.TabBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
		TweenService:Create(v.TabBtn.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(165, 165, 165)}):Play()
		v.Selected = false
	end

	TweenService:Create(TabModule.Tabs[Tab].TabBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()    
	TweenService:Create(TabModule.Tabs[Tab].TabBtn.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()

    task.spawn(function()
        for _, Container in pairs(TabModule.Containers) do
            Container.Visible = false
        end

        TabModule.Containers[Tab].Visible = true
    end)
end

return TabModule
 end,
    [13] = function()local maui,script,require,getfenv,setfenv=ImportGlobals(13)local Tools = require(script.Parent.Parent.tools)

local Create = Tools.Create
local AddConnection = Tools.AddConnection

return function(SectionName, Parent)
	local Section = {}

	Section.SectionContainer = Create("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 16),
		Size = UDim2.new(1, 0, 0, 0),
		Name = "Container"
	}, {
		Create("UIListLayout", {Padding = UDim.new(0, 6)})
	})

	Section.SectionFrame = Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Parent = Parent
	}, {
		Create("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -10, 0, 10),
			Font = Enum.Font.GothamSemibold,
			TextColor3 = Color3.fromRGB(165, 165, 165),
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = string.upper(SectionName)
		}),
		Section.SectionContainer
	})

	AddConnection(Section.SectionContainer.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		Section.SectionContainer.Size = UDim2.new(1,0,0,Section.SectionContainer.UIListLayout.AbsoluteContentSize.Y)
		Section.SectionFrame.Size = UDim2.new(1,0,0,Section.SectionContainer.UIListLayout.AbsoluteContentSize.Y + 16)
	end)

	return Section
end end
} -- [RefId] = Closure

-- Set up from data
do
    -- Localizing certain libraries and built-ins for runtime efficiency
    local task, setmetatable, error, newproxy, getmetatable, next, table, unpack, coroutine, script, type, require, pcall, getfenv, setfenv, rawget= task, setmetatable, error, newproxy, getmetatable, next, table, unpack, coroutine, script, type, require, pcall, getfenv, setfenv, rawget

    local table_insert = table.insert
    local table_remove = table.remove

    -- lol
    local table_freeze = table.freeze or function(t) return t end

    -- If we're not running on Roblox or Lune runtime, we won't have a task library
    local Defer = task and task.defer or function(f, ...)
        local Thread = coroutine.create(f)
        coroutine.resume(Thread, ...)
        return Thread
    end

    -- `maui.Version` compat
    local Version = "0.0.0-venv"

    local RefBindings = {} -- [RefId] = RealObject

    local ScriptClosures = {}
    local StoredModuleValues = {}
    local ScriptsToRun = {}

    -- maui.Shared
    local SharedEnvironment = {}

    -- We're creating 'fake' instance refs soley for traversal of the DOM for require() compatibility
    -- It's meant to be as lazy as possible lol
    local RefChildren = {} -- [Ref] = {ChildrenRef, ...}

    -- Implemented instance methods
    local InstanceMethods = {
        GetChildren = function(self)
            local Children = RefChildren[self]
            local ReturnArray = {}
    
            for Child in next, Children do
                table_insert(ReturnArray, Child)
            end
    
            return ReturnArray
        end,

        -- Not implementing `recursive` arg, as it isn't needed for us here
        FindFirstChild = function(self, name)
            if not name then
                error("Argument 1 missing or nil", 2)
            end

            for Child in next, RefChildren[self] do
                if Child.Name == name then
                    return Child
                end
            end

            return
        end,

        GetFullName = function(self)
            local Path = self.Name
            local ObjectPointer = self.Parent

            while ObjectPointer do
                Path = ObjectPointer.Name .. "." .. Path

                -- Move up the DOM (parent will be nil at the end, and this while loop will stop)
                ObjectPointer = ObjectPointer.Parent
            end

            return "VirtualEnv." .. Path
        end,
    }

    -- "Proxies" to instance methods, with err checks etc
    local InstanceMethodProxies = {}
    for MethodName, Method in next, InstanceMethods do
        InstanceMethodProxies[MethodName] = function(self, ...)
            if not RefChildren[self] then
                error("Expected ':' not '.' calling member function " .. MethodName, 1)
            end

            return Method(self, ...)
        end
    end

    local function CreateRef(className, name, parent)
        -- `name` and `parent` can also be set later by the init script if they're absent

        -- Extras
        local StringValue_Value

        -- Will be set to RefChildren later aswell
        local Children = setmetatable({}, {__mode = "k"})

        -- Err funcs
        local function InvalidMember(member)
            error(member .. " is not a valid (virtual) member of " .. className .. " \"" .. name .. "\"", 1)
        end

        local function ReadOnlyProperty(property)
            error("Unable to assign (virtual) property " .. property .. ". Property is read only", 1)
        end

        local Ref = newproxy(true)
        local RefMetatable = getmetatable(Ref)

        RefMetatable.__index = function(_, index)
            if index == "ClassName" then -- First check "properties"
                return className
            elseif index == "Name" then
                return name
            elseif index == "Parent" then
                return parent
            elseif className == "StringValue" and index == "Value" then
                -- Supporting StringValue.Value for Rojo .txt file conv
                return StringValue_Value
            else -- Lastly, check "methods"
                local InstanceMethod = InstanceMethodProxies[index]

                if InstanceMethod then
                    return InstanceMethod
                end
            end

            -- Next we'll look thru child refs
            for Child in next, Children do
                if Child.Name == index then
                    return Child
                end
            end

            -- At this point, no member was found; this is the same err format as Roblox
            InvalidMember(index)
        end

        RefMetatable.__newindex = function(_, index, value)
            -- __newindex is only for props fyi
            if index == "ClassName" then
                ReadOnlyProperty(index)
            elseif index == "Name" then
                name = value
            elseif index == "Parent" then
                -- We'll just ignore the process if it's trying to set itself
                if value == Ref then
                    return
                end

                if parent ~= nil then
                    -- Remove this ref from the CURRENT parent
                    RefChildren[parent][Ref] = nil
                end

                parent = value

                if value ~= nil then
                    -- And NOW we're setting the new parent
                    RefChildren[value][Ref] = true
                end
            elseif className == "StringValue" and index == "Value" then
                -- Supporting StringValue.Value for Rojo .txt file conv
                StringValue_Value = value
            else
                -- Same err as __index when no member is found
                InvalidMember(index)
            end
        end

        RefMetatable.__tostring = function()
            return name
        end

        RefChildren[Ref] = Children

        if parent ~= nil then
            RefChildren[parent][Ref] = true
        end

        return Ref
    end

    -- Create real ref DOM from object tree
    local function CreateRefFromObject(object, parent)
        local RefId = object[1]
        local ClassName = object[2]
        local Properties = object[3]
        local Children = object[4] -- Optional

        local Name = table_remove(Properties, 1)

        local Ref = CreateRef(ClassName, Name, parent) -- 3rd arg may be nil if this is from root
        RefBindings[RefId] = Ref

        if Properties then
            for PropertyName, PropertyValue in next, Properties do
                Ref[PropertyName] = PropertyValue
            end
        end

        if Children then
            for _, ChildObject in next, Children do
                CreateRefFromObject(ChildObject, Ref)
            end
        end

        return Ref
    end

    local RealObjectRoot = {}
    for _, Object in next, ObjectTree do
        table_insert(RealObjectRoot, CreateRefFromObject(Object))
    end

    -- Now we'll set script closure refs and check if they should be ran as a BaseScript
    for RefId, Closure in next, ClosureBindings do
        local Ref = RefBindings[RefId]

        ScriptClosures[Ref] = Closure

        local ClassName = Ref.ClassName
        if ClassName == "LocalScript" or ClassName == "Script" then
            table_insert(ScriptsToRun, Ref)
        end
    end

    local function LoadScript(scriptRef)
        local ScriptClassName = scriptRef.ClassName

        -- First we'll check for a cached module value (packed into a tbl)
        local StoredModuleValue = StoredModuleValues[scriptRef]
        if StoredModuleValue and ScriptClassName == "ModuleScript" then
            return unpack(StoredModuleValue)
        end

        local Closure = ScriptClosures[scriptRef]
        if not Closure then
            return
        end

        -- If it's a BaseScript, we'll just run it directly!
        if ScriptClassName == "LocalScript" or ScriptClassName == "Script" then
            Closure()
            return
        else
            local ClosureReturn = {Closure()}
            StoredModuleValues[scriptRef] = ClosureReturn
            return unpack(ClosureReturn)
        end
    end

    -- We'll assign the actual func from the top of this output for flattening user globals at runtime
    -- Returns (in a tuple order): maui, script, require, getfenv, setfenv
    function ImportGlobals(refId)
        local ScriptRef = RefBindings[refId]

        local Closure = ScriptClosures[ScriptRef]
        if not Closure then
            return
        end

        -- This will be set right after the other global funcs, it's for handling proper behavior when
        -- getfenv/setfenv is called and safeenv needs to be disabled
        local EnvHasBeenSet = false
        local RealEnv
        local VirtualEnv
        local SetEnv

        local Global_maui = table_freeze({
            Version = Version,
            Script = script, -- The actual script object for the script this is running on, not a fake ref
            Shared = SharedEnvironment,

            -- For compatibility purposes..
            GetScript = function()
                return script
            end,
            GetShared = function()
                return SharedEnvironment
            end,
        })

        local Global_script = ScriptRef

        local function Global_require(module, ...)
            if RefChildren[module] and module.ClassName == "ModuleScript" and ScriptClosures[module] then
                return LoadScript(module)
            end

            return require(module, ...)
        end

        -- Calling these flattened getfenv/setfenv functions will disable safeenv for the WHOLE SCRIPT
        local function Global_getfenv(stackLevel, ...)
            -- Now we have to set the env for the other variables used here to be valid
            if not EnvHasBeenSet then
                SetEnv()
            end

            if type(stackLevel) == "number" and stackLevel >= 0 then
                if stackLevel == 0 then
                    return VirtualEnv
                else
                    -- Offset by 1 for the actual env
                    stackLevel = stackLevel + 1

                    local GetOk, FunctionEnv = pcall(getfenv, stackLevel)
                    if GetOk and FunctionEnv == RealEnv then
                        return VirtualEnv
                    end
                end
            end

            return getfenv(stackLevel, ...)
        end

        local function Global_setfenv(stackLevel, newEnv, ...)
            if not EnvHasBeenSet then
                SetEnv()
            end

            if type(stackLevel) == "number" and stackLevel >= 0 then
                if stackLevel == 0 then
                    return setfenv(VirtualEnv, newEnv)
                else
                    stackLevel = stackLevel + 1

                    local GetOk, FunctionEnv = pcall(getfenv, stackLevel)
                    if GetOk and FunctionEnv == RealEnv then
                        return setfenv(VirtualEnv, newEnv)
                    end
                end
            end

            return setfenv(stackLevel, newEnv, ...)
        end

        -- From earlier, will ONLY be set if needed
        function SetEnv()
            RealEnv = getfenv(0)

            local GlobalEnvOverride = {
                ["maui"] = Global_maui,
                ["script"] = Global_script,
                ["require"] = Global_require,
                ["getfenv"] = Global_getfenv,
                ["setfenv"] = Global_setfenv,
            }

            VirtualEnv = setmetatable({}, {
                __index = function(_, index)
                    local IndexInVirtualEnv = rawget(VirtualEnv, index)
                    if IndexInVirtualEnv ~= nil then
                        return IndexInVirtualEnv
                    end

                    local IndexInGlobalEnvOverride = GlobalEnvOverride[index]
                    if IndexInGlobalEnvOverride ~= nil then
                        return IndexInGlobalEnvOverride
                    end

                    return RealEnv[index]
                end
            })

            setfenv(Closure, VirtualEnv)
            EnvHasBeenSet = true
        end

        -- Now, return flattened globals ready for direct runtime exec
        return Global_maui, Global_script, Global_require, Global_getfenv, Global_setfenv
    end

    for _, ScriptRef in next, ScriptsToRun do
        Defer(LoadScript, ScriptRef)
    end

    -- If there's a "MainModule" top-level modulescript, we'll return it from the output's closure directly
    do
        local MainModule
        for _, Ref in next, RealObjectRoot do
            if Ref.ClassName == "ModuleScript" and Ref.Name == "MainModule" then
                MainModule = Ref
                break
            end
        end

        if MainModule then
            return LoadScript(MainModule)
        end
    end

    -- If any scripts are currently running now from task scheduler, the scope won't close until all running threads are closed
    -- (thanks for coming to my ted talk)
end


wait(1)
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

local BuyLibrary = {}

-- Helper function to create UI elements
local function Create(className, properties, children)
	local object = Instance.new(className)
	for property, value in pairs(properties) do
		object[property] = value
	end
	if children then
		for _, child in pairs(children) do
			child.Parent = object
		end
	end
	return object
end

function BuyLibrary:Init(parent)
	local ShopUI = {}

	-- Main frame for the shop UI
	ShopUI.Main = Create("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		Visible = true,
		Name = "BuyTab",
		Parent = parent,
	}, {
		Create("UIPadding", {
			PaddingBottom = UDim.new(0, 14),
			PaddingLeft = UDim.new(0, 16),
			PaddingRight = UDim.new(0, 16),
			PaddingTop = UDim.new(0, 14),
		}),
		Create("UIListLayout", {
			Padding = UDim.new(0, 18),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	})

	-- Search bar frame
	ShopUI.Search = {}
	ShopUI.Search.Main = Create("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 32),
		Visible = true,
		Name = "SearchFrame",
		Parent = ShopUI.Main,
	}, {
		Create("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	})

	-- Search input box
	ShopUI.Search.Input = Create("TextBox", {
		Font = Enum.Font.Gotham,
		PlaceholderColor3 = Color3.fromRGB(227, 227, 227),
		PlaceholderText = "Search...",
		Text = "",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
		BorderSizePixel = 0,
		Size = UDim2.new(1, -60, 0, 32),
		Name = "SearchInput",
		Parent = ShopUI.Search.Main,
	}, {
		Create("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
		}),
		Create("UICorner", { CornerRadius = UDim.new(0, 5) })
	})

	-- Search button
	ShopUI.Search.Button = Create("TextButton", {
		Font = Enum.Font.Gotham,
		Text = "Search",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 13,
		BackgroundColor3 = Color3.fromRGB(28, 28, 28),
		BorderSizePixel = 0,
		Size = UDim2.new(0, 60, 0, 32),
		Name = "SearchButton",
		Parent = ShopUI.Search.Main,
	}, {
		Create("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
		}),
		Create("UICorner", { CornerRadius = UDim.new(0, 5) })
	})

	-- Function to add sections
	function ShopUI:AddSection(name)
		local section = {}
		local sectionFrame = Create("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			Name = name .. "Frame",
			Parent = ShopUI.Main
		}, {
			Create("UIListLayout", {
				Padding = UDim.new(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			Create("TextLabel", {
				Font = Enum.Font.Gotham,
				Text = name,
				TextColor3 = Color3.fromRGB(165, 165, 165),
				TextSize = 13,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 20),
				Name = name .. "Label",
			})
		})

		function section:AddCard(cardName, price)
			local card = Create("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 38),
				Name = cardName,
				Parent = sectionFrame,
			}, {
				Create("UIListLayout", {
					Padding = UDim.new(0, 8),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
				Create("TextLabel", {
					Font = Enum.Font.Gotham,
					Text = cardName,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 200, 1, 0),
					Name = "NameLabel",
				}),
				Create("TextButton", {
					Font = Enum.Font.Gotham,
					Text = price .. "C$",
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 13,
					BackgroundColor3 = Color3.fromRGB(0, 150, 100),
					Size = UDim2.new(0, 80, 0, 32),
					Name = "BuyButton",
				}, {
					Create("UICorner", { CornerRadius = UDim.new(0, 5) })
				})
			})
		end

		return section
	end

	-- Functionality for the search button
	ShopUI.Search.Button.MouseButton1Click:Connect(function()
		local searchText = ShopUI.Search.Input.Text:lower()
		for _, section in ipairs(ShopUI.Main:GetChildren()) do
			if section:IsA("Frame") and section.Name:match("Frame$") then
				local foundMatch = false
				for _, card in ipairs(section:GetChildren()) do
					if card:IsA("Frame") and card:FindFirstChild("NameLabel") then
						local cardName = card.Name:lower()
						card.Visible = cardName:find(searchText) ~= nil
						if card.Visible then
							foundMatch = true
						end
					end
				end
				section.Visible = foundMatch
			end
		end
	end)

	return ShopUI
end


-- local ScreenGui = Create("ScreenGui", {
-- 	IgnoreGuiInset = false,
-- 	ResetOnSpawn = false,
-- 	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
-- 	Parent = game.Players.LocalPlayer.PlayerGui,
-- })
-- local Main = BuyLibrary:Init(ScreenGui)
-- local section = Main:AddSection("Fishing Rod's")
-- section:AddCard("h", 1000)

return BuyLibrary


-- local info = Create("TextButton", {
-- 	Font = Enum.Font.Gotham,
-- 	Text = "",
-- 	TextColor3 = Color3.new(255, 255, 255),
-- 	TextSize = 13,
-- 	TextWrapped = true,
-- 	BackgroundColor3 = Color3.new(28, 28, 28),
-- 	BorderColor3 = Color3.new(0, 0, 0),
-- 	BorderSizePixel = 0,
-- 	Size = UDim2.new(0, 32, 0, 32),
-- 	Visible = true,
-- 	Name = "Info",
-- 	Parent = card,
-- }, {
-- 	Create("UIPadding", {
-- 		PaddingLeft = UDim.new(0, 12),
-- 		PaddingRight = UDim.new(0, 12),
-- 	}),
-- 	Create("UICorner", {
-- 		CornerRadius = UDim.new(0, 5),
-- 	}),
-- 	Create("ImageLabel", {
-- 		Image = "rbxassetid://15269255168",
-- 		ImageColor3 = Color3.new(186, 186, 186),
-- 		ImageRectOffset = Vector2.new(257, 257),
-- 		ImageRectSize = Vector2.new(256, 256),
-- 		AnchorPoint = Vector2.new(0.5, 0.5),
-- 		BackgroundColor3 = Color3.new(255, 255, 255),
-- 		BackgroundTransparency = 1,
-- 		BorderColor3 = Color3.new(0, 0, 0),
-- 		BorderSizePixel = 0,
-- 		Position = UDim2.new(0.5, 0, 0.5, 0),
-- 		Size = UDim2.new(0, 16, 0, 16),
-- 		Visible = true,
-- 		Name = "info",
-- 	}),
-- })

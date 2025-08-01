--== 99 Noites Hub Completo ==--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- GUI base
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "NoitesHub"

local hubColor = Color3.fromRGB(180, 180, 180) -- cinza suave

-- Container principal
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 360, 0, 300)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -150)
MainFrame.BackgroundColor3 = hubColor
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- Minimizar botão
local MinimizeBtn = Instance.new("TextButton", ScreenGui)
MinimizeBtn.Text = "Abrir Hub"
MinimizeBtn.Size = UDim2.new(0, 100, 0, 30)
MinimizeBtn.Position = UDim2.new(0, 10, 1, -40)
MinimizeBtn.Visible = false
MinimizeBtn.BackgroundColor3 = hubColor
MinimizeBtn.TextColor3 = Color3.new(0,0,0)
MinimizeBtn.BorderSizePixel = 0

-- Título e abas
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "99 Noites Hub"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(0,0,0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- Abas botões
local TabsFrame = Instance.new("Frame", MainFrame)
TabsFrame.Size = UDim2.new(1, 0, 0, 30)
TabsFrame.Position = UDim2.new(0, 0, 0, 30)
TabsFrame.BackgroundTransparency = 1

local function createTab(name, pos)
	local btn = Instance.new("TextButton", TabsFrame)
	btn.Size = UDim2.new(0, 110, 1, 0)
	btn.Position = UDim2.new(0, pos, 0, 0)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(200,200,200)
	btn.TextColor3 = Color3.new(0,0,0)
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 16
	return btn
end

local TeleportTabBtn = createTab("Teleporte", 0)
local OptionsTabBtn = createTab("Opções Gerais", 110)
local PullItemsTabBtn = createTab("Puxar Itens", 220)

-- Container das páginas
local Pages = {}

local function createPage()
	local frame = Instance.new("ScrollingFrame", MainFrame)
	frame.Size = UDim2.new(1, 0, 1, -60)
	frame.Position = UDim2.new(0, 0, 0, 60)
	frame.BackgroundTransparency = 1
	frame.ScrollBarThickness = 6
	frame.Visible = false
	frame.CanvasSize = UDim2.new(0,0,5,0)
	return frame
end

Pages.Teleport = createPage()
Pages.Options = createPage()
Pages.PullItems = createPage()

-- Mostrar aba inicial
Pages.Teleport.Visible = true
TeleportTabBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)

local function switchTab(tab)
	for _, btn in pairs({TeleportTabBtn, OptionsTabBtn, PullItemsTabBtn}) do
		btn.BackgroundColor3 = Color3.fromRGB(200,200,200)
	end
	for _, page in pairs(Pages) do
		page.Visible = false
	end
	tab.BackgroundColor3 = Color3.fromRGB(150,150,150)
	if tab == TeleportTabBtn then
		Pages.Teleport.Visible = true
	elseif tab == OptionsTabBtn then
		Pages.Options.Visible = true
	elseif tab == PullItemsTabBtn then
		Pages.PullItems.Visible = true
	end
end

TeleportTabBtn.MouseButton1Click:Connect(function() switchTab(TeleportTabBtn) end)
OptionsTabBtn.MouseButton1Click:Connect(function() switchTab(OptionsTabBtn) end)
PullItemsTabBtn.MouseButton1Click:Connect(function() switchTab(PullItemsTabBtn) end)

-- Minimizar / maximizar
MinimizeBtn.MouseButton1Click:Connect(function()
	MinimizeBtn.Visible = false
	MainFrame.Visible = true
end)

local function minimize()
	MainFrame.Visible = false
	MinimizeBtn.Visible = true
end

local MinimizeToggleBtn = Instance.new("TextButton", MainFrame)
MinimizeToggleBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeToggleBtn.Position = UDim2.new(1, -35, 0, 5)
MinimizeToggleBtn.Text = "-"
MinimizeToggleBtn.BackgroundColor3 = Color3.fromRGB(150,150,150)
MinimizeToggleBtn.TextColor3 = Color3.new(0,0,0)
MinimizeToggleBtn.BorderSizePixel = 0
MinimizeToggleBtn.Font = Enum.Font.SourceSansBold
MinimizeToggleBtn.TextSize = 20

MinimizeToggleBtn.MouseButton1Click:Connect(minimize)

-- ==== TELEPORTE ====

-- Botão "Ir para a fogueira"
local TeleportToFireBtn = Instance.new("TextButton", Pages.Teleport)
TeleportToFireBtn.Size = UDim2.new(1, -20, 0, 40)
TeleportToFireBtn.Position = UDim2.new(0, 10, 0, 10)
TeleportToFireBtn.Text = "Ir para a Fogueira"
TeleportToFireBtn.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
TeleportToFireBtn.TextColor3 = Color3.new(0,0,0)
TeleportToFireBtn.Font = Enum.Font.SourceSansBold
TeleportToFireBtn.TextSize = 18
TeleportToFireBtn.BorderSizePixel = 0

-- Função para teleporte seguro
local function teleportTo(pos)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
	end
end

-- Coordenadas da fogueira (ajuste se necessário)
local firePos = Vector3.new(0, 10, 0) -- coloque a posição correta da fogueira no mapa

TeleportToFireBtn.MouseButton1Click:Connect(function()
	teleportTo(firePos)
end)

-- Marca um local, volta, limpa
local markPos = nil

local MarkBtn = Instance.new("TextButton", Pages.Teleport)
MarkBtn.Size = UDim2.new(0.45, -15, 0, 40)
MarkBtn.Position = UDim2.new(0, 10, 0, 60)
MarkBtn.Text = "Marcar Local"
MarkBtn.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
MarkBtn.TextColor3 = Color3.new(0,0,0)
MarkBtn.Font = Enum.Font.SourceSansBold
MarkBtn.TextSize = 16
MarkBtn.BorderSizePixel = 0

local TeleportBackBtn = Instance.new("TextButton", Pages.Teleport)
TeleportBackBtn.Size = UDim2.new(0.45, -15, 0, 40)
TeleportBackBtn.Position = UDim2.new(0.55, 5, 0, 60)
TeleportBackBtn.Text = "Voltar ao Local"
TeleportBackBtn.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
TeleportBackBtn.TextColor3 = Color3.new(0,0,0)
TeleportBackBtn.Font = Enum.Font.SourceSansBold
TeleportBackBtn.TextSize = 16
TeleportBackBtn.BorderSizePixel = 0

local ClearMarkBtn = Instance.new("TextButton", Pages.Teleport)
ClearMarkBtn.Size = UDim2.new(1, -20, 0, 40)
ClearMarkBtn.Position = UDim2.new(0, 10, 0, 110)
ClearMarkBtn.Text = "Limpar Local Marcado"
ClearMarkBtn.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
ClearMarkBtn.TextColor3 = Color3.new(0,0,0)
ClearMarkBtn.Font = Enum.Font.SourceSansBold
ClearMarkBtn.TextSize = 16
ClearMarkBtn.BorderSizePixel = 0

MarkBtn.MouseButton1Click:Connect(function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		markPos = LocalPlayer.Character.HumanoidRootPart.Position
		MarkBtn.Text = "Local Marcado!"
	end
end)

TeleportBackBtn.MouseButton1Click:Connect(function()
	if markPos then
		teleportTo(markPos)
	end
end)

ClearMarkBtn.MouseButton1Click:Connect(function()
	markPos = nil
	MarkBtn.Text = "Marcar Local"
end)

-- ==== OPÇÕES GERAIS ====

-- Container para organizar os elementos na página Opções
local OptionsLayout = Instance.new("UIListLayout", Pages.Options)
OptionsLayout.Padding = UDim.new(0, 10)
OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
OptionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
OptionsLayout.VerticalAlignment = Enum.VerticalAlignment.Top
OptionsLayout.Padding = UDim.new(0, 15)

-- HITBOX CONTROL

local HitboxLabel = Instance.new("TextLabel", Pages.Options)
HitboxLabel.Size = UDim2.new(1, -20, 0, 25)
HitboxLabel.Position = UDim2.new(0, 10, 0, 10)
HitboxLabel.BackgroundTransparency = 1
HitboxLabel.Text = "Ajustar Hitbox"
HitboxLabel.Font = Enum.Font.SourceSansBold
HitboxLabel.TextSize = 18
HitboxLabel.TextColor3 = Color3.new(0,0,0)
HitboxLabel.TextXAlignment = Enum.TextXAlignment.Left

local currentScale = 1
local ScaleLabel = Instance.new("TextLabel", Pages.Options)
ScaleLabel.Size = UDim2.new(1, -20, 0, 25)
ScaleLabel.Position = UDim2.new(0, 10, 0, 40)
ScaleLabel.BackgroundTransparency = 1
ScaleLabel.Text = "Tamanho da hitbox: 1.0x"
ScaleLabel.Font = Enum.Font.SourceSans
ScaleLabel.TextSize = 16
ScaleLabel.TextColor3 = Color3.new(0,0,0)
ScaleLabel.TextXAlignment = Enum.TextXAlignment.Left

local function applyHitboxScale(scale)
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	for _, part in pairs(char:GetChildren()) do
		if part:IsA("BasePart") then
			-- reset pra evitar escala acumulada errada
			part.Size = part.Size / (part:GetAttribute("HitboxScale") or 1)
			part:SetAttribute("HitboxScale", 1)
		end
	end

	-- aplicar nova escala
	for _, part in pairs(char:GetChildren()) do
		if part:IsA("BasePart") then
			part.Size = part.Size * scale
			part:SetAttribute("HitboxScale", scale)
		end
	end

	currentScale = scale
	ScaleLabel.Text = string.format("Tamanho da hitbox: %.1fx", scale)
end

local IncreaseHitboxBtn = Instance.new("TextButton", Pages.Options)
IncreaseHitboxBtn.Size = UDim2.new(0.45, -10, 0, 40)
IncreaseHitboxBtn.Position = UDim2.new(0, 10, 0, 70)
IncreaseHitboxBtn.Text = "Aumentar Hitbox"
IncreaseHitboxBtn.BackgroundColor3 = Color3.fromRGB(160,160,160)
IncreaseHitboxBtn.TextColor3 = Color3.new(0,0,0)
IncreaseHitboxBtn.Font = Enum.Font.SourceSansBold
IncreaseHitboxBtn.TextSize = 16
IncreaseHitboxBtn.BorderSizePixel = 0

local DecreaseHitboxBtn = Instance.new("TextButton", Pages.Options)
DecreaseHitboxBtn.Size = UDim2.new(0.45, -10, 0, 40)
DecreaseHitboxBtn.Position = UDim2.new(0.55, 10, 0, 70)
DecreaseHitboxBtn.Text = "Diminuir Hitbox"
DecreaseHitboxBtn.BackgroundColor3 = Color3.fromRGB(160,160,160)
DecreaseHitboxBtn.TextColor3 = Color3.new(0,0,0)
DecreaseHitboxBtn.Font = Enum.Font.SourceSansBold
DecreaseHitboxBtn.TextSize = 16
DecreaseHitboxBtn.BorderSizePixel = 0

IncreaseHitboxBtn.MouseButton1Click:Connect(function()
	local newScale = math.min(currentScale + 0.5, 4)
	applyHitboxScale(newScale)
end)

DecreaseHitboxBtn.MouseButton1Click:Connect(function()
	local newScale = math.max(currentScale - 0.5, 1)
	applyHitboxScale(newScale)
end)

-- Remover cooldown da arma (simplificado)
local CooldownRemoved = false

local CooldownBtn = Instance.new("TextButton", Pages.Options)
CooldownBtn.Size = UDim2.new(1, -20, 0, 40)
CooldownBtn.Position = UDim2.new(0, 10, 0, 120)
CooldownBtn.Text = "Remover Cooldown da Arma"
CooldownBtn.BackgroundColor3 = Color3.fromRGB(160,160,160)
CooldownBtn.TextColor3 = Color3.new(0,0,0)
CooldownBtn.Font = Enum.Font.SourceSansBold
CooldownBtn.TextSize = 16
CooldownBtn.BorderSizePixel = 0

CooldownBtn.MouseButton1Click:Connect(function()
	CooldownRemoved = not CooldownRemoved
	if CooldownRemoved then
		CooldownBtn.Text = "Cooldown Removido (ON)"
	else
		CooldownBtn.Text = "Remover Cooldown da Arma"
	end
end)

-- Aqui tenta zerar cooldowns conhecidos no jogo (exemplo genérico)
RunService.Heartbeat:Connect(function()
	if CooldownRemoved and LocalPlayer.Character then
		local char = LocalPlayer.Character
		-- Exemplo: se o cooldown estiver guardado em um valor no personagem (ajustar pro jogo)
		local cooldownValue = char:FindFirstChild("AttackCooldown")
		if cooldownValue and cooldownValue:IsA("NumberValue") then
			cooldownValue.Value = 0
		end
	end
end)

-- ==== PUXAR ITENS ====

local ItemsFolder = workspace:WaitForChild("ItensDropados", 5) -- ajuste o nome correto do container de itens dropados
if not ItemsFolder then
	ItemsFolder = workspace
end

local ItemsList = {}

local PullItemsFrame = Pages.PullItems

local function refreshItemsList()
	-- Limpar antigos
	for _, v in pairs(PullItemsFrame:GetChildren()) do
		if v:IsA("TextButton") or v:IsA("TextLabel") then
			if v ~= ItemsLabel and v ~= Title then
				v:Destroy()
			end
		end
	end
	ItemsList = {}

	-- Buscar itens dropados no workspace (exemplo genérico)
	local itemsFound = {}

	for _, item in pairs(ItemsFolder:GetChildren()) do
		if item:IsA("BasePart") or item:IsA("Model") then
			local name = item.Name
			if not itemsFound[name] then
				itemsFound[name] = {}
			end
			table.insert(itemsFound[name], item)
		end
	end

	local yPos = 10
	for name, list in pairs(itemsFound) do
		local btn = Instance.new("TextButton", PullItemsFrame)
		btn.Size = UDim2.new(1, -20, 0, 40)
		btn.Position = UDim2.new(0, 10, 0, yPos)
		btn.Text = string.format("Puxar todos: %s (%d)", name, #list)
		btn.BackgroundColor3 = Color3.fromRGB(160,160,160)
		btn.TextColor3 = Color3.new(0,0,0)
		btn.Font = Enum.Font.SourceSansBold
		btn.TextSize = 16
		btn.BorderSizePixel = 0

		btn.MouseButton1Click:Connect(function()
			for _, obj in pairs(list) do
				if obj:IsA("Model") then
					local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
					if primary then
						primary.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
					end
				elseif obj:IsA("BasePart") then
					obj.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
				end
			end
		end)

		yPos = yPos + 50
	end
end

local RefreshItemsBtn = Instance.new("TextButton", PullItemsFrame)
RefreshItemsBtn.Size = UDim2.new(1, -20, 0, 40)
RefreshItemsBtn.Position = UDim2.new(0, 10, 0, 10)
RefreshItemsBtn.Text = "Atualizar Lista de Itens"
RefreshItemsBtn.BackgroundColor3 = Color3.fromRGB(160,160,160)
RefreshItemsBtn.TextColor3 = Color3.new(0,0,0)
RefreshItemsBtn.Font = Enum.Font.SourceSansBold
RefreshItemsBtn.TextSize = 16
RefreshItemsBtn.BorderSizePixel = 0

RefreshItemsBtn.MouseButton1Click:Connect(refreshItemsList)

-- Atualiza a lista ao abrir a aba
PullItemsTabBtn.MouseButton1Click:Connect(refreshItemsList)

-- Fim do script

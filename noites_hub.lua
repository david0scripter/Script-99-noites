local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local toggleKillAura = false
local toggleHitbox = false
local storedPosition = nil
local hitboxSizeMultiplier = 4
local range = 30
local damage = 30
local attackDelay = 0.15

-- GUI Principal
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "NoitesHub"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 400)
frame.Position = UDim2.new(0.5, -130, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.BorderSizePixel = 0
title.Text = "💀 99 Noites Hub"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

local function createButton(text, y, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local killAuraBtn = createButton("Ativar Kill Aura", 40, function()
	toggleKillAura = not toggleKillAura
	killAuraBtn.Text = toggleKillAura and "Desativar Kill Aura" or "Ativar Kill Aura"
end)

local hitboxBtn = createButton("Aumentar Hitbox", 80, function()
	toggleHitbox = not toggleHitbox
	hitboxBtn.Text = toggleHitbox and "Reduzir Hitbox" or "Aumentar Hitbox"
end)

local markPosBtn = createButton("📍 Marcar Local", 120, function()
	if char and char:FindFirstChild("HumanoidRootPart") then
		storedPosition = char.HumanoidRootPart.Position
	end
end)

local tpBackBtn = createButton("🚀 Voltar p/ Local", 160, function()
	if storedPosition and char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(storedPosition)
	end
end)

local clearMarkBtn = createButton("❌ Remover Marcador", 200, function()
	storedPosition = nil
end)

local centerBtn = createButton("🔥 Ir para a Fogueira", 240, function()
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0, 50, 0)) -- ajuste se necessário
	end
end)

-- Aba de itens dropados
local itemScroll = Instance.new("ScrollingFrame", frame)
itemScroll.Position = UDim2.new(0, 10, 0, 280)
itemScroll.Size = UDim2.new(1, -20, 0, 110)
itemScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
itemScroll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
itemScroll.BorderSizePixel = 0
itemScroll.ScrollBarThickness = 6

local function refreshItemList()
	itemScroll:ClearAllChildren()
	local itemCounts = {}
	local droppedFolder = workspace:FindFirstChild("DroppedItems") or workspace:FindFirstChild("ItensDropados")
	if droppedFolder then
		for _, obj in pairs(droppedFolder:GetChildren()) do
			if obj:IsA("BasePart") then
				itemCounts[obj.Name] = (itemCounts[obj.Name] or 0) + 1
			end
		end
	end
	local y = 0
	for name, count in pairs(itemCounts) do
		local txt = Instance.new("TextLabel", itemScroll)
		txt.Size = UDim2.new(0.6, 0, 0, 24)
		txt.Position = UDim2.new(0, 0, 0, y)
		txt.BackgroundTransparency = 1
		txt.TextColor3 = Color3.new(1,1,1)
		txt.Text = name .. " x" .. count
		txt.Font = Enum.Font.SourceSans
		txt.TextSize = 16

		local pull = Instance.new("TextButton", itemScroll)
		pull.Size = UDim2.new(0.4, -10, 0, 24)
		pull.Position = UDim2.new(0.6, 0, 0, y)
		pull.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		pull.Text = "Puxar"
		pull.TextColor3 = Color3.new(1,1,1)
		pull.Font = Enum.Font.SourceSansBold
		pull.TextSize = 16

		pull.MouseButton1Click:Connect(function()
			if char and char:FindFirstChild("HumanoidRootPart") then
				for _, obj in pairs(droppedFolder:GetChildren()) do
					if obj:IsA("BasePart") and obj.Name == name then
						obj.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(math.random(-2,2), 0.5, math.random(-2,2))
					end
				end
			end
		end)

		y = y + 26
	end
	itemScroll.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- Loop atualização
task.spawn(function()
	while true do
		refreshItemList()
		task.wait(1)
	end
end)

-- Loop Kill Aura
task.spawn(function()
	while true do
		if toggleKillAura and char and char:FindFirstChild("HumanoidRootPart") then
			local root = char.HumanoidRootPart
			for _, npc in pairs(workspace:GetDescendants()) do
				if npc:IsA("Model") and npc ~= char and npc:FindFirstChildOfClass("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
					local dist = (npc.HumanoidRootPart.Position - root.Position).Magnitude
					if dist <= range then
						npc:FindFirstChildOfClass("Humanoid"):TakeDamage(damage)
					end
				end
			end
		end
		task.wait(attackDelay)
	end
end)

-- Loop Hitbox visual e expansão
task.spawn(function()
	while true do
		for _, tool in pairs(char:GetChildren()) do
			if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
				local h = tool.Handle
				if toggleHitbox then
					h.Size = Vector3.new(1,1,1) * hitboxSizeMultiplier
					if not h:FindFirstChild("Box") then
						local box = Instance.new("SelectionBox", h)
						box.Name = "Box"
						box.Adornee = h
						box.Color3 = Color3.fromRGB(255, 100, 100)
					end
				else
					h.Size = Vector3.new(1,1,1)
					if h:FindFirstChild("Box") then
						h.Box:Destroy()
					end
				end
			end
		end
		task.wait(0.2)
	end
end)

-- Remover cooldown das armas
local function removeCooldowns()
	for _, tool in pairs(char:GetChildren()) do
		if tool:IsA("Tool") then
			for _, obj in pairs(tool:GetDescendants()) do
				if obj:IsA("Script") or obj:IsA("LocalScript") then
					obj.Disabled = true
				end
			end
		end
	end
end

char.ChildAdded:Connect(removeCooldowns)
removeCooldowns()

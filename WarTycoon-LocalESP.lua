-- War Tycoon Local Player ESP
-- Visual-only client script. Does not modify server state, money, weapons, damage, or permissions.
-- Intended for local testing/visualization in experiences where client-side scripts are permitted.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local GUI_NAME = "WarTycoonLocalESP"
local old = game:GetService("CoreGui"):FindFirstChild(GUI_NAME)
if old then old:Destroy() end

local enabled = false
local highlights = {}

local function clearPlayer(player)
    local h = highlights[player]
    if h then
        h:Destroy()
        highlights[player] = nil
    end
end

local function applyPlayer(player)
    if player == LocalPlayer or not enabled then return end
    local character = player.Character
    if not character then return end

    clearPlayer(player)
    local highlight = Instance.new("Highlight")
    highlight.Name = "LocalPlayerESP"
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(220, 45, 55)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.65
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    highlights[player] = highlight
end

local function refresh()
    for _, player in ipairs(Players:GetPlayers()) do
        applyPlayer(player)
    end
end

local function setEnabled(value)
    enabled = value
    if enabled then
        refresh()
    else
        for player in pairs(highlights) do
            clearPlayer(player)
        end
    end
end

local screen = Instance.new("ScreenGui")
screen.Name = GUI_NAME
screen.ResetOnSpawn = false
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parent
pcall(function() parent = game:GetService("CoreGui") end)
if not parent then parent = LocalPlayer:WaitForChild("PlayerGui") end
screen.Parent = parent

local frame = Instance.new("Frame")
frame.Name = "Panel"
frame.Size = UDim2.fromOffset(220, 128)
frame.Position = UDim2.new(0, 18, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
frame.BorderSizePixel = 0
frame.Parent = screen
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(190, 35, 45)
stroke.Thickness = 1.5
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -16, 0, 30)
title.Position = UDim2.fromOffset(8, 6)
title.BackgroundTransparency = 1
title.Text = "WAR TYCOON • LOCAL ESP"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.Parent = frame

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 36)
toggle.Position = UDim2.fromOffset(10, 43)
toggle.BackgroundColor3 = Color3.fromRGB(115, 30, 38)
toggle.Text = "PLAYER ESP: OFF"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 13
toggle.AutoButtonColor = true
toggle.Parent = frame
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 7)

toggle.Activated:Connect(function()
    setEnabled(not enabled)
    toggle.Text = enabled and "PLAYER ESP: ON" or "PLAYER ESP: OFF"
    toggle.BackgroundColor3 = enabled and Color3.fromRGB(35, 125, 75) or Color3.fromRGB(115, 30, 38)
end)

local hide = Instance.new("TextButton")
hide.Size = UDim2.new(1, -20, 0, 25)
hide.Position = UDim2.fromOffset(10, 86)
hide.BackgroundTransparency = 1
hide.Text = "HIDE PANEL"
hide.TextColor3 = Color3.fromRGB(210, 210, 210)
hide.Font = Enum.Font.Gotham
hide.TextSize = 11
hide.Parent = frame

local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(92, 30)
reopen.Position = UDim2.new(0, 18, 0.35, 0)
reopen.BackgroundColor3 = Color3.fromRGB(115, 30, 38)
reopen.Text = "SHOW ESP"
reopen.TextColor3 = Color3.new(1, 1, 1)
reopen.Font = Enum.Font.GothamBold
reopen.TextSize = 12
reopen.Visible = false
reopen.Parent = screen
Instance.new("UICorner", reopen).CornerRadius = UDim.new(0, 8)

hide.Activated:Connect(function()
    frame.Visible = false
    reopen.Visible = true
end)
reopen.Activated:Connect(function()
    frame.Visible = true
    reopen.Visible = false
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        applyPlayer(player)
    end)
end)

Players.PlayerRemoving:Connect(clearPlayer)

for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        applyPlayer(player)
    end)
end

print("[War Tycoon Local ESP] Loaded. Toggle Player ESP from the panel.")

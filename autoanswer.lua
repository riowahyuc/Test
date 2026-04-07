--[[
    🚀 Rionism x Gemini - Sambung Kata V4 (KBBI)
    Modern, Futuristic, and Optimized.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- UI Constants
local MAIN_COLOR = Color3.fromRGB(0, 255, 150) -- Futuristic Neon Green/Cyan
local BG_COLOR = Color3.fromRGB(15, 15, 15)
local ACCENT_COLOR = Color3.fromRGB(30, 30, 30)

-- Logic Variables
local words = {}
local usedWords = {}
local maxDisplayed = 15
local wordSource = "https://raw.githubusercontent.com/ZenoScripter/Script/refs/heads/main/Sambung%20Kata%20(%20indo%20)/wordlist_kbbi.lua"
local autoEnter = true
local isMinimized = false
local lastTick = tick()

-- ScreenGui Setup
local gui = Instance.new("ScreenGui")
gui.Name = "RionismXGemini_V4"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (Modern Glassmorphism Style)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 300)
mainFrame.Position = UDim2.new(0.5, -110, 0.4, -150)
mainFrame.BackgroundColor3 = BG_COLOR
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

local uiStroke = Instance.new("UIStroke", mainFrame)
uiStroke.Thickness = 2
uiStroke.Color = MAIN_COLOR
uiStroke.Transparency = 0.5

-- Header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = ACCENT_COLOR
header.Text = "  Rionism x Gemini"
header.TextColor3 = Color3.new(1, 1, 1)
header.Font = Enum.Font.GothamBold
header.TextSize = 13
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 10)

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 30, 0, 30)
toggleBtn.Position = UDim2.new(1, -35, 0, 2)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Text = "—"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 18
toggleBtn.Parent = header

-- Container (Content)
local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(1, -20, 1, -85)
container.Position = UDim2.new(0, 10, 0, 45)
container.BackgroundTransparency = 1
container.Parent = mainFrame

-- Search Bar
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, 0, 0, 30)
searchBox.BackgroundColor3 = ACCENT_COLOR
searchBox.PlaceholderText = "Ketik awalan kata..."
searchBox.Text = ""
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.Font = Enum.Font.GothamMedium
searchBox.TextSize = 12
searchBox.Parent = container

Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)

-- Word List (Scrolling)
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -40)
scroll.Position = UDim2.new(0, 0, 0, 40)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
scroll.ScrollBarImageColor3 = MAIN_COLOR
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = container

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Footer Stats
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 1, -30)
footer.BackgroundTransparency = 1
footer.Parent = mainFrame

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0.5, 0, 1, 0)
fpsLabel.Text = "FPS: 60"
fpsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
fpsLabel.Font = Enum.Font.Code
fpsLabel.TextSize = 10
fpsLabel.BackgroundTransparency = 1
fpsLabel.Parent = footer

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(0.5, 0, 1, 0)
pingLabel.Position = UDim2.new(0.5, 0, 0, 0)
pingLabel.Text = "PING: 0ms"
pingLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
pingLabel.Font = Enum.Font.Code
pingLabel.TextSize = 10
pingLabel.BackgroundTransparency = 1
pingLabel.Parent = footer

-- Logic: Functions
local function typeWord(word)
    local prefix = searchBox.Text:lower():gsub("%s+", "")
    local suffix = word:sub(#prefix + 1)
    
    for i = 1, #suffix do
        local char = suffix:sub(i, i)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[char:upper()], false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[char:upper()], false, game)
    end
    
    if autoEnter then
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    end
end

local function updateList()
    for _, child in pairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local query = searchBox.Text:lower():gsub("%s+", "")
    if query == "" then return end
    
    local count = 0
    for _, word in ipairs(words) do
        if word:sub(1, #query) == query then
            count = count + 1
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -5, 0, 25)
            btn.BackgroundColor3 = usedWords[word] and Color3.fromRGB(50, 50, 50) or MAIN_COLOR
            btn.BackgroundTransparency = usedWords[word] and 0.5 or 0.2
            btn.Text = (usedWords[word] and "✔ " or "") .. word:upper()
            btn.TextColor3 = usedWords[word] and Color3.new(0.6, 0.6, 0.6) or Color3.new(0, 0, 0)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 11
            btn.Parent = scroll
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            
            btn.MouseButton1Click:Connect(function()
                if not usedWords[word] then
                    usedWords[word] = true
                    btn.Text = "TYPING..."
                    typeWord(word)
                    updateList()
                end
            end)
            
            if count >= maxDisplayed then break end
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, count * 30)
end

-- Data Fetching
task.spawn(function()
    local success, content = pcall(function() return game:HttpGet(wordSource) end)
    if success then
        for word in string.gmatch(content, "[^\r\n]+") do
            local cleanWord = string.match(word, "([%a%-]+)")
            if cleanWord and #cleanWord > 1 then
                table.insert(words, cleanWord:lower())
            end
        end
    end
end)

-- Event Listeners
searchBox:GetPropertyChangedSignal("Text"):Connect(updateList)

toggleBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    container.Visible = not isMinimized
    footer.Visible = not isMinimized
    mainFrame:TweenSize(isMinimized and UDim2.new(0, 220, 0, 35) or UDim2.new(0, 220, 0, 300), "Out", "Quart", 0.3, true)
    toggleBtn.Text = isMinimized and "[+]" or "—"
end)

RunService.RenderStepped:Connect(function()
    -- Rainbow Stroke Effect
    local hue = (tick() * 0.2) % 1
    uiStroke.Color = Color3.fromHSV(hue, 0.8, 1)
    
    -- Stats
    local fps = math.floor(1 / (tick() - lastTick))
    lastTick = tick()
    fpsLabel.Text = "FPS: " .. fps
    pingLabel.Text = "PING: " .. math.floor(LocalPlayer:GetNetworkPing() * 1000) .. "ms"
end)

-- Notification
print("Rionism x Gemini Loaded Successfully!")

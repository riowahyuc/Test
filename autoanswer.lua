--[[
    🚀 Rionism x Gemini - Sambung Kata V5 (Advanced)
    Fitur: Auto-Clear, Adjustable Speed, & Smart Filtering
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Global Settings
local SETTINGS = {
    MainColor = Color3.fromRGB(0, 212, 255),
    TypingDelay = 0.05, -- Default Speed
    AutoEnter = true,
    AutoClear = true,
    IsMinimized = false
}

local words = {}
local usedWords = {}

-- UI Creation
local gui = Instance.new("ScreenGui")
gui.Name = "RionismXGemini_V5"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 240, 0, 340)
main.Position = UDim2.new(0.5, -120, 0.4, -170)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Glow Effect Header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
header.Text = "  RIONISM X GEMINI V5"
header.TextColor3 = SETTINGS.MainColor
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = main
Instance.new("UICorner", header)

-- Speed Slider Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 45)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Typing Speed: " .. SETTINGS.TypingDelay .. "s"
speedLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.TextSize = 10
speedLabel.Parent = main

-- Speed Buttons (Fast / Med / Safe)
local function createSpeedBtn(name, delay, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 0, 20)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = main
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        SETTINGS.TypingDelay = delay
        speedLabel.Text = "Typing Speed: " .. delay .. "s"
        -- Visual feedback
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = SETTINGS.MainColor}):Play()
        task.wait(0.2)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
    end)
end

createSpeedBtn("FAST", 0.01, UDim2.new(0, 10, 0, 65))
createSpeedBtn("NORMAL", 0.05, UDim2.new(0, 85, 0, 65))
createSpeedBtn("SAFE", 0.15, UDim2.new(0, 160, 0, 65))

-- Search Box
local search = Instance.new("TextBox")
search.Size = UDim2.new(1, -20, 0, 35)
search.Position = UDim2.new(0, 10, 0, 95)
search.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
search.PlaceholderText = "Input Prefix..."
search.Text = ""
search.TextColor3 = Color3.new(1, 1, 1)
search.Font = Enum.Font.GothamSemibold
search.Parent = main
Instance.new("UICorner", search)

-- Scrolling Frame
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -180)
scroll.Position = UDim2.new(0, 10, 0, 140)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
scroll.Parent = main

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)

-- Logic: Typing Engine
local function sendInput(word)
    local prefix = search.Text:lower():gsub("%s+", "")
    local suffix = word:sub(#prefix + 1)
    
    -- Simulator mengetik
    for i = 1, #suffix do
        local char = suffix:sub(i, i)
        local keyCode = Enum.KeyCode[char:upper()] or Enum.KeyCode.Minus
        VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        task.wait(SETTINGS.TypingDelay)
        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
    end
    
    if SETTINGS.AutoEnter then
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    end

    if SETTINGS.AutoClear then
        search.Text = "" -- Hapus kata otomatis setelah kirim
    end
end

-- Refresh List
local function updateList()
    for _, v in pairs(scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    
    local query = search.Text:lower():gsub("%s+", "")
    if query == "" then return end
    
    local found = 0
    for _, word in ipairs(words) do
        if word:sub(1, #query) == query and not usedWords[word] then
            found = found + 1
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -5, 0, 30)
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            b.Text = "  " .. word:upper()
            b.TextColor3 = SETTINGS.MainColor
            b.Font = Enum.Font.GothamBold
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Parent = scroll
            Instance.new("UICorner", b)

            b.MouseButton1Click:Connect(function()
                usedWords[word] = true
                sendInput(word)
                updateList()
            end)
            
            if found >= 12 then break end
        end
    end
    scroll.CanvasSize = UDim2.new(0,0,0, found * 35)
end

-- Load Words
task.spawn(function()
    local ok, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/ZenoScripter/Script/refs/heads/main/Sambung%20Kata%20(%20indo%20)/wordlist_kbbi.lua") end)
    if ok then
        for w in res:gmatch("([%a%-]+)") do if #w > 1 then table.insert(words, w:lower()) end end
    end
end)

search:GetPropertyChangedSignal("Text"):Connect(updateList)

-- Rainbow Effect
RunService.RenderStepped:Connect(function()
    local h = tick() % 5 / 5
    stroke.Color = Color3.fromHSV(h, 0.8, 1)
    header.TextColor3 = Color3.fromHSV(h, 0.7, 1)
end)

print("Rionism x Gemini V5 Loaded - Mode Advanced Aktif")
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

--[[
    🚀 Rionism x Gemini - Sambung Kata V9.7 (Stealth & Flex)
    ✨ Fitur Baru: Slider Typing Speed (Anti-Detect) & Minimize UI.
    📊 Stats: Real-time FPS & Ping Tracker.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- [ CONFIG ] --
local function GetDailyKey()
    local date = os.date("!*t", os.time() + 25200)
    return string.format("RION-%02d%02d%04d", date.day, date.month, date.year)
end

local SETTINGS = {
    MainColor = Color3.fromRGB(0, 255, 255),
    CorrectKey = GetDailyKey(),
    KeyLink = "https://link-rionism-gemini.com/getkey",
    TypingDelay = 0.05, -- Default
    IsMinimized = false
}

local words = {}
local usedWords = {}

-- [ UI ROOT ] --
local gui = Instance.new("ScreenGui")
gui.Name = "RionismXGemini_V9_7"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 440)
main.Position = UDim2.new(0.5, -130, 0.4, -220)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = gui

Instance.new("UICorner", main)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 2
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- [ HEADER ] --
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
header.Parent = main
Instance.new("UICorner", header)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "RIONISM X GEMINI V9.7"
title.TextColor3 = SETTINGS.MainColor
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 35, 0, 35)
minBtn.Position = UDim2.new(1, -40, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
minBtn.Text = "−"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.Parent = header
Instance.new("UICorner", minBtn)

-- [ CONTENT FRAME ] --
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -45)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundTransparency = 1
content.Visible = false
content.Parent = main

-- [ STEALTH SETTINGS (SPEED SLIDER) ] --
local stealthFrame = Instance.new("Frame")
stealthFrame.Size = UDim2.new(1, -20, 0, 40)
stealthFrame.Position = UDim2.new(0, 10, 0, 5)
stealthFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
stealthFrame.Parent = content
Instance.new("UICorner", stealthFrame)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Typing Speed: 0.05s (Safe)"
speedLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.TextSize = 10
speedLabel.Parent = stealthFrame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(1, -20, 0, 15)
speedInput.Position = UDim2.new(0, 10, 0, 20)
speedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
speedInput.Text = "0.05"
speedInput.TextColor3 = SETTINGS.MainColor
speedInput.Font = Enum.Font.Code
speedInput.TextSize = 12
speedInput.Parent = stealthFrame
Instance.new("UICorner", speedInput)

-- [ STATS BOX ] --
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, -20, 0, 20)
statsFrame.Position = UDim2.new(0, 10, 0, 50)
statsFrame.BackgroundTransparency = 1
statsFrame.Parent = content

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0.5, 0, 1, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: --"
fpsLabel.TextColor3 = Color3.new(1, 1, 1)
fpsLabel.Font = Enum.Font.Code
fpsLabel.TextSize = 10
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = statsFrame

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(0.5, 0, 1, 0)
pingLabel.Position = UDim2.new(0.5, 0, 0, 0)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "PING: --"
pingLabel.TextColor3 = Color3.new(1, 1, 1)
pingLabel.Font = Enum.Font.Code
pingLabel.TextSize = 10
pingLabel.TextXAlignment = Enum.TextXAlignment.Right
pingLabel.Parent = statsFrame

-- [ SEARCH & LIST ] --
local searchFrame = Instance.new("Frame")
searchFrame.Size = UDim2.new(1, -20, 0, 38)
searchFrame.Position = UDim2.new(0, 10, 0, 75)
searchFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
searchFrame.Parent = content
Instance.new("UICorner", searchFrame)

local search = Instance.new("TextBox")
search.Size = UDim2.new(1, -40, 1, 0)
search.Position = UDim2.new(0, 10, 0, 0)
search.BackgroundTransparency = 1
search.PlaceholderText = "Input Awalan..."
search.Text = ""
search.TextColor3 = Color3.new(1, 1, 1)
search.Parent = searchFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -165)
scroll.Position = UDim2.new(0, 10, 0, 155)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
scroll.Parent = content
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 6)

-- [ LOGIN FRAME ] --
local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(1, 0, 1, 0)
loginFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
loginFrame.ZIndex = 10
loginFrame.Parent = main
Instance.new("UICorner", loginFrame)

local loginList = Instance.new("UIListLayout", loginFrame)
loginList.HorizontalAlignment = Enum.HorizontalAlignment.Center
loginList.VerticalAlignment = Enum.VerticalAlignment.Center
loginList.Padding = UDim.new(0, 15)

local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1, 0, 0, 50)
loginTitle.BackgroundTransparency = 1
loginTitle.Text = "RIONISM X GEMINI\nSTEALTH ACCESS"
loginTitle.TextColor3 = Color3.new(1, 1, 1)
loginTitle.Font = Enum.Font.GothamBold
loginTitle.TextSize = 16
loginTitle.Parent = loginFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0, 210, 0, 40)
keyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
keyInput.PlaceholderText = "Paste Daily Key..."
keyInput.TextColor3 = Color3.new(1, 1, 1)
keyInput.Parent = loginFrame
Instance.new("UICorner", keyInput)

local checkBtn = Instance.new("TextButton")
checkBtn.Size = UDim2.new(0, 210, 0, 40)
checkBtn.BackgroundColor3 = SETTINGS.MainColor
checkBtn.Text = "VERIFY"
checkBtn.TextColor3 = Color3.new(0, 0, 0)
checkBtn.Font = Enum.Font.GothamBold
checkBtn.Parent = loginFrame
Instance.new("UICorner", checkBtn)

-- [ FUNCTIONS ] --
speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val then
        SETTINGS.TypingDelay = math.clamp(val, 0.01, 1)
        speedLabel.Text = "Typing Speed: " .. SETTINGS.TypingDelay .. "s"
    else
        speedInput.Text = tostring(SETTINGS.TypingDelay)
    end
end)

minBtn.MouseButton1Click:Connect(function()
    SETTINGS.IsMinimized = not SETTINGS.IsMinimized
    local targetSize = SETTINGS.IsMinimized and UDim2.new(0, 260, 0, 45) or UDim2.new(0, 260, 0, 440)
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    minBtn.Text = SETTINGS.IsMinimized and "+" or "−"
end)

checkBtn.MouseButton1Click:Connect(function()
    if keyInput.Text == SETTINGS.CorrectKey then
        loginFrame.Visible = false
        content.Visible = true
    else
        checkBtn.Text = "WRONG KEY"
        task.wait(1)
        checkBtn.Text = "VERIFY"
    end
end)

local function sendInput(word)
    local prefix = search.Text:lower():gsub("%s+", "")
    local suffix = word:sub(#prefix + 1)
    for i = 1, #suffix do
        local char = suffix:sub(i, i)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[char:upper()] or Enum.KeyCode.Minus, false, game)
        task.wait(SETTINGS.TypingDelay)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[char:upper()] or Enum.KeyCode.Minus, false, game)
    end
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    search.Text = ""
end

local function updateList()
    for _, v in pairs(scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    local query = search.Text:lower():gsub("%s+", "")
    if query == "" then return end
    local found = 0
    for _, word in ipairs(words) do
        if word:sub(1, #query) == query and not usedWords[word] then
            found = found + 1
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -5, 0, 32)
            b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            b.Text = "  > " .. word:upper()
            b.TextColor3 = SETTINGS.MainColor
            b.Font = Enum.Font.GothamBold
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Parent = scroll
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function() usedWords[word] = true sendInput(word) updateList() end)
            if found >= 10 then break end
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, found * 38)
end

search:GetPropertyChangedSignal("Text"):Connect(updateList)

task.spawn(function()
    while task.wait(0.5) do
        fpsLabel.Text = "FPS: " .. math.floor(1/RunService.RenderStepped:Wait())
        pingLabel.Text = "PING: " .. math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) .. "ms"
    end
end)

RunService.RenderStepped:Connect(function()
    local h = tick() % 5 / 5
    mainStroke.Color = Color3.fromHSV(h, 0.8, 1)
    title.TextColor3 = Color3.fromHSV(h, 0.7, 1)
end)

task.spawn(function()
    local ok, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/riowahyuc/Test/refs/heads/main/wordlist_kbbi.lua") end)
    if ok then for w in res:gmatch("([%a%-]+)") do if #w > 1 then table.insert(words, w:lower()) end end end
end)

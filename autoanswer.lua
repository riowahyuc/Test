--[[
    🚀 Rionism x Gemini - Sambung Kata V9.6 (Stability Fix)
    🛠 Fix: Tombol login sekarang 100% bisa masuk ke fitur utama.
    📊 Fitur: FPS, Ping, Daily Key, Rainbow Glow, & Auto-Input.
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
    TypingDelay = 0.05,
    IsMinimized = false
}

local words = {}
local usedWords = {}

-- [ UI ROOT ] --
local gui = Instance.new("ScreenGui")
gui.Name = "RionismXGemini_V9_6"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 420)
main.Position = UDim2.new(0.5, -130, 0.4, -210)
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

-- [ CONTENT & LOGIN FRAMES ] --
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -45)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundTransparency = 1
content.Visible = false
content.Parent = main

local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(1, 0, 1, 0)
loginFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
loginFrame.ZIndex = 10
loginFrame.Parent = main
Instance.new("UICorner", loginFrame)

-- [ LOGIN ELEMENTS (FIXED LIST) ] --
local loginList = Instance.new("UIListLayout", loginFrame)
loginList.HorizontalAlignment = Enum.HorizontalAlignment.Center
loginList.VerticalAlignment = Enum.VerticalAlignment.Center
loginList.Padding = UDim.new(0, 15)

local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1, 0, 0, 50)
loginTitle.BackgroundTransparency = 1
loginTitle.Text = "RIONISM X GEMINI\nDAILY ACCESS"
loginTitle.TextColor3 = Color3.new(1, 1, 1)
loginTitle.Font = Enum.Font.GothamBold
loginTitle.TextSize = 16
loginTitle.Parent = loginFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0, 210, 0, 40)
keyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
keyInput.PlaceholderText = "Paste Key Here..."
keyInput.Text = ""
keyInput.TextColor3 = Color3.new(1, 1, 1)
keyInput.Font = Enum.Font.GothamSemibold
keyInput.Parent = loginFrame
Instance.new("UICorner", keyInput)

local checkBtn = Instance.new("TextButton")
checkBtn.Size = UDim2.new(0, 210, 0, 40)
checkBtn.BackgroundColor3 = SETTINGS.MainColor
checkBtn.Text = "VERIFY KEY"
checkBtn.TextColor3 = Color3.new(0, 0, 0)
checkBtn.Font = Enum.Font.GothamBold
checkBtn.Parent = loginFrame
Instance.new("UICorner", checkBtn)

local getBtn = Instance.new("TextButton")
getBtn.Size = UDim2.new(0, 210, 0, 35)
getBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
getBtn.Text = "GET KEY (COPY LINK)"
getBtn.TextColor3 = Color3.new(1, 1, 1)
getBtn.Font = Enum.Font.GothamBold
getBtn.TextSize = 11
getBtn.Parent = loginFrame
Instance.new("UICorner", getBtn)

-- [ HEADER CONTENT ] --
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
header.Parent = main
Instance.new("UICorner", header)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "RIONISM X GEMINI V9.6"
title.TextColor3 = SETTINGS.MainColor
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 40, 0, 35)
minBtn.Position = UDim2.new(1, -45, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
minBtn.Text = "−"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 22
minBtn.Parent = header
Instance.new("UICorner", minBtn)

-- [ STATS, SEARCH, & BUTTONS ] --
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, -20, 0, 20)
statsFrame.Position = UDim2.new(0, 10, 0, 5)
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

local searchFrame = Instance.new("Frame")
searchFrame.Size = UDim2.new(1, -20, 0, 38)
searchFrame.Position = UDim2.new(0, 10, 0, 30)
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

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 25, 0, 25)
clearBtn.Position = UDim2.new(1, -30, 0.5, -12)
clearBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
clearBtn.Text = "×"
clearBtn.TextColor3 = Color3.new(1, 0.3, 0.3)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.Parent = searchFrame
Instance.new("UICorner", clearBtn)

local actionFrame = Instance.new("Frame")
actionFrame.Size = UDim2.new(1, -20, 0, 30)
actionFrame.Position = UDim2.new(0, 10, 0, 75)
actionFrame.BackgroundTransparency = 1
actionFrame.Parent = content

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 115, 1, 0)
refreshBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 30)
refreshBtn.Text = "REFRESH"
refreshBtn.TextColor3 = Color3.fromRGB(150, 255, 150)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 10
refreshBtn.Parent = actionFrame
Instance.new("UICorner", refreshBtn)

local creditsBtn = Instance.new("TextButton")
creditsBtn.Size = UDim2.new(0, 115, 1, 0)
creditsBtn.Position = UDim2.new(1, -115, 0, 0)
creditsBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
creditsBtn.Text = "CREDITS"
creditsBtn.TextColor3 = Color3.new(1,1,1)
creditsBtn.Font = Enum.Font.GothamBold
creditsBtn.TextSize = 10
creditsBtn.Parent = actionFrame
Instance.new("UICorner", creditsBtn)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -120)
scroll.Position = UDim2.new(0, 10, 0, 115)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
scroll.Parent = content
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 6)

-- [ LOGIC: BUTTONS ] --
checkBtn.MouseButton1Click:Connect(function()
    if keyInput.Text == SETTINGS.CorrectKey then
        checkBtn.Text = "SUCCESS!"
        task.wait(0.3)
        loginFrame.Visible = false
        content.Visible = true
    else
        checkBtn.Text = "WRONG KEY"
        checkBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(1.5)
        checkBtn.Text = "VERIFY KEY"
        checkBtn.BackgroundColor3 = SETTINGS.MainColor
    end
end)

getBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(SETTINGS.KeyLink) getBtn.Text = "COPIED!" task.wait(1) getBtn.Text = "GET KEY (COPY LINK)" end
end)

refreshBtn.MouseButton1Click:Connect(function()
    usedWords = {}
    refreshBtn.Text = "RESET DONE"
    task.wait(1)
    refreshBtn.Text = "REFRESH"
end)

-- [ LOGIC: CORE ENGINE ] --
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
            if found >= 12 then break end
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, found * 38)
end

search:GetPropertyChangedSignal("Text"):Connect(updateList)
clearBtn.MouseButton1Click:Connect(function() search.Text = "" end)

-- [ REFRESH PERFORMANCE & RAINBOW ] --
task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1/RunService.RenderStepped:Wait())
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        fpsLabel.Text = "FPS: " .. fps
        pingLabel.Text = "PING: " .. ping .. "ms"
    end
end)

RunService.RenderStepped:Connect(function()
    local h = tick() % 5 / 5
    mainStroke.Color = Color3.fromHSV(h, 0.8, 1)
    title.TextColor3 = Color3.fromHSV(h, 0.7, 1)
end)

task.spawn(function()
    local ok, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/ZenoScripter/Script/refs/heads/main/Sambung%20Kata%20(%20indo%20)/wordlist_kbbi.lua") end)
    if ok then for w in res:gmatch("([%a%-]+)") do if #w > 1 then table.insert(words, w:lower()) end end end
end)

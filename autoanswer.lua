--[[
    🚀 Rionism x Gemini - Sambung Kata V9.5 (Super GG Edition)
    ✨ Visual: Super Glow, Dynamic Rainbow, & Modern Aggressive UI.
    📊 Performance: Real-time Precision FPS & Ping Tracker.
    🛠 Fix: Zero-Overlap Layout & Clean Navigation.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- [ CONFIGURATION ] --
local function GetDailyKey()
    local date = os.date("!*t", os.time() + 25200)
    return string.format("RION-%02d%02d%04d", date.day, date.month, date.year)
end

local SETTINGS = {
    MainColor = Color3.fromRGB(0, 255, 255),
    SecondaryColor = Color3.fromRGB(255, 0, 150),
    KeyLink = "https://link-rionism-gemini.com/getkey",
    CorrectKey = GetDailyKey(),
    TypingDelay = 0.04, -- Sedikit lebih cepat (Super GG)
    IsMinimized = false
}

local words = {}
local usedWords = {}

-- [ UI ROOT ] --
local gui = Instance.new("ScreenGui")
gui.Name = "RionismXGemini_V9_5_GG"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 270, 0, 440)
main.Position = UDim2.new(0.5, -135, 0.4, -220)
main.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = gui

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 2.5
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Transparency = 0.2

-- [ LOGIN LAYER (ANTI-OVERLAP) ] --
local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(1, 0, 1, 0)
loginFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
loginFrame.ZIndex = 20
loginFrame.Parent = main

Instance.new("UICorner", loginFrame).CornerRadius = UDim.new(0, 10)

local loginPadding = Instance.new("UIPadding", loginFrame)
loginPadding.PaddingTop = UDim.new(0, 40)

local loginList = Instance.new("UIListLayout", loginFrame)
loginList.HorizontalAlignment = Enum.HorizontalAlignment.Center
loginList.Padding = UDim.new(0, 15)

local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1, 0, 0, 60)
loginTitle.BackgroundTransparency = 1
loginTitle.Text = "RIONISM X GEMINI\n< SUPER GG EDITION >"
loginTitle.TextColor3 = Color3.new(1, 1, 1)
loginTitle.Font = Enum.Font.GothamBold
loginTitle.TextSize = 18
loginTitle.Parent = loginFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0, 220, 0, 45)
keyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
keyInput.PlaceholderText = "Enter Daily Key..."
keyInput.Text = ""
keyInput.TextColor3 = Color3.new(1, 1, 1)
keyInput.Font = Enum.Font.GothamSemibold
keyInput.Parent = loginFrame
Instance.new("UICorner", keyInput)

local checkBtn = Instance.new("TextButton")
checkBtn.Size = UDim2.new(0, 220, 0, 45)
checkBtn.BackgroundColor3 = SETTINGS.MainColor
checkBtn.Text = "ACCESS SYSTEM"
checkBtn.TextColor3 = Color3.new(0, 0, 0)
checkBtn.Font = Enum.Font.GothamBold
checkBtn.Parent = loginFrame
Instance.new("UICorner", checkBtn)

local getBtn = Instance.new("TextButton")
getBtn.Size = UDim2.new(0, 220, 0, 40)
getBtn.BackgroundTransparency = 0.8
getBtn.BackgroundColor3 = Color3.new(1,1,1)
getBtn.Text = "GET DAILY KEY"
getBtn.TextColor3 = Color3.new(1, 1, 1)
getBtn.Font = Enum.Font.GothamBold
getBtn.Parent = loginFrame
Instance.new("UICorner", getBtn)

-- [ HEADER CONTENT ] --
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "RIONISM X GEMINI"
title.TextColor3 = SETTINGS.MainColor
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 40, 0, 40)
minBtn.Position = UDim2.new(1, -45, 0, 5)
minBtn.BackgroundTransparency = 1
minBtn.Text = "▼"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.Parent = header

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -50)
content.Position = UDim2.new(0, 0, 0, 50)
content.BackgroundTransparency = 1
content.Visible = false
content.Parent = main

-- [ SUPER GG STATS ] --
local statsBox = Instance.new("Frame")
statsBox.Size = UDim2.new(1, -20, 0, 25)
statsBox.Position = UDim2.new(0, 10, 0, 5)
statsBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
statsBox.Parent = content
Instance.new("UICorner", statsBox).CornerRadius = UDim.new(0, 5)

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0.5, -10, 1, 0)
fpsLabel.Position = UDim2.new(0, 10, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: --"
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
fpsLabel.Font = Enum.Font.Code
fpsLabel.TextSize = 11
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = statsBox

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(0.5, -10, 1, 0)
pingLabel.Position = UDim2.new(0.5, 0, 0, 0)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "MS: --"
pingLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
pingLabel.Font = Enum.Font.Code
pingLabel.TextSize = 11
pingLabel.TextXAlignment = Enum.TextXAlignment.Right
pingLabel.Parent = statsBox

-- [ SEARCH & ACTION BAR ] --
local searchFrame = Instance.new("Frame")
searchFrame.Size = UDim2.new(1, -20, 0, 40)
searchFrame.Position = UDim2.new(0, 10, 0, 40)
searchFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
searchFrame.Parent = content
Instance.new("UICorner", searchFrame)

local search = Instance.new("TextBox")
search.Size = UDim2.new(1, -50, 1, 0)
search.Position = UDim2.new(0, 12, 0, 0)
search.BackgroundTransparency = 1
search.PlaceholderText = "Type prefix..."
search.Text = ""
search.TextColor3 = Color3.new(1, 1, 1)
search.Font = Enum.Font.GothamSemibold
search.Parent = searchFrame

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 30, 0, 30)
clearBtn.Position = UDim2.new(1, -35, 0.5, -15)
clearBtn.BackgroundTransparency = 1
clearBtn.Text = "×"
clearBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 24
clearBtn.Parent = searchFrame

local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(1, -20, 0, 35)
btnContainer.Position = UDim2.new(0, 10, 0, 90)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = content

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0.5, -5, 1, 0)
refreshBtn.BackgroundColor3 = Color3.fromRGB(30, 40, 30)
refreshBtn.Text = "REFRESH DATA"
refreshBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 10
refreshBtn.Parent = btnContainer
Instance.new("UICorner", refreshBtn)

local creditsBtn = Instance.new("TextButton")
creditsBtn.Size = UDim2.new(0.5, -5, 1, 0)
creditsBtn.Position = UDim2.new(0.5, 5, 0, 0)
creditsBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 40)
creditsBtn.Text = "SYSTEM CREDITS"
creditsBtn.TextColor3 = Color3.fromRGB(255, 100, 255)
creditsBtn.Font = Enum.Font.GothamBold
creditsBtn.TextSize = 10
creditsBtn.Parent = btnContainer
Instance.new("UICorner", creditsBtn)

-- [ WORD LIST (NEON STYLE) ] --
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -140)
scroll.Position = UDim2.new(0, 10, 0, 135)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = SETTINGS.MainColor
scroll.Parent = content
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)

-- [ SYSTEM LOGIC ] --
task.spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1/RunService.RenderStepped:Wait())
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        fpsLabel.Text = "FPS: " .. fps
        pingLabel.Text = "PING: " .. ping .. "ms"
    end
end)

checkBtn.MouseButton1Click:Connect(function()
    if keyInput.Text == SETTINGS.CorrectKey then
        TweenService:Create(loginFrame, TweenInfo.new(0.5), {Position = UDim2.new(0, 0, 1, 0)}):Play()
        task.wait(0.5)
        loginFrame.Visible = false
        content.Visible = true
    else
        checkBtn.Text = "ACCESS DENIED"
        checkBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
        task.wait(1.5)
        checkBtn.Text = "ACCESS SYSTEM"
        checkBtn.BackgroundColor3 = SETTINGS.MainColor
    end
end)

getBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(SETTINGS.KeyLink) getBtn.Text = "LINK COPIED!" task.wait(1) getBtn.Text = "GET DAILY KEY" end
end)

refreshBtn.MouseButton1Click:Connect(function()
    usedWords = {}
    refreshBtn.Text = "DB CLEANED"
    task.wait(1)
    refreshBtn.Text = "REFRESH DATA"
end)

-- [ CORE ENGINE ] --
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
    local count = 0
    for _, word in ipairs(words) do
        if word:sub(1, #query) == query and not usedWords[word] then
            count = count + 1
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -10, 0, 35)
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            b.Text = "  >  " .. word:upper()
            b.TextColor3 = Color3.new(0.9, 0.9, 0.9)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 12
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Parent = scroll
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            local s = Instance.new("UIStroke", b)
            s.Color = SETTINGS.MainColor
            s.Transparency = 0.7
            
            b.MouseButton1Click:Connect(function()
                usedWords[word] = true
                sendInput(word)
                updateList()
            end)
            if count >= 12 then break end
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, count * 43)
end

search:GetPropertyChangedSignal("Text"):Connect(updateList)
clearBtn.MouseButton1Click:Connect(function() search.Text = "" end)

-- [ RAINBOW GLOW EFFECT ] --
RunService.RenderStepped:Connect(function()
    local hue = tick() % 4 / 4
    mainStroke.Color = Color3.fromHSV(hue, 0.8, 1)
    title.TextColor3 = Color3.fromHSV(hue, 0.6, 1)
end)

-- [ LOAD DATABASE ] --
task.spawn(function()
    local ok, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/ZenoScripter/Script/refs/heads/main/Sambung%20Kata%20(%20indo%20)/wordlist_kbbi.lua") end)
    if ok then for w in res:gmatch("([%a%-]+)") do if #w > 1 then table.insert(words, w:lower()) end end end
end)

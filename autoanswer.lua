--[[
    🚀 Rionism x Gemini - Sambung Kata V9.4 (Fix Overlay Edition)
    Fitur: Daily Key, Copy Link, Refresh, Credits, dan PERBAIKAN LAYOUT LOGIN.
    Design: Desain vertikal klasik dengan FPS & Ping.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Stats = game:GetService("Stats")

-- [ LOGIC: DAILY KEY ] --
local function GetDailyKey()
    local date = os.date("!*t", os.time() + 25200) -- UTC+7 (WIB)
    return string.format("RION-%02d%02d%04d", date.day, date.month, date.year)
end

local SETTINGS = {
    MainColor = Color3.fromRGB(0, 212, 255),
    KeyLink = "https://link-rionism-gemini.com/getkey", -- Ganti dengan link kamu
    CorrectKey = GetDailyKey(),
    TypingDelay = 0.05,
    IsMinimized = false
}

local words = {}
local usedWords = {}

-- [ UI SETUP ] --
local gui = Instance.new("ScreenGui")
gui.Name = "RionismXGemini_V9_4"
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
main.ZIndex = 5
main.Parent = gui

Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- [ ===================================== ] --
-- [ LOGIN FRAME + FIX OVERLAY ] --
-- [ ===================================== ] --
local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(1, 0, 1, 0)
loginFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
loginFrame.ZIndex = 10 -- Lebih tinggi dari 'main' agar menutupi
loginFrame.Visible = true -- Tampilkan saat mulai
loginFrame.Parent = main
Instance.new("UICorner", loginFrame)

-- [ SISTEM LAYOUT UNTUK LOGIN (MENCEGAH BERTUMPUK) ] --
local loginLayout = Instance.new("UIListLayout")
loginLayout.Parent = loginFrame
loginLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center -- Tengah secara horizontal
loginLayout.VerticalAlignment = Enum.VerticalAlignment.Center -- Tengah secara vertikal
loginLayout.Padding = UDim.new(0, 12) -- Jarak antar elemen (ini kuncinya!)

-- Judul
local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1, -20, 0, 60)
loginTitle.BackgroundTransparency = 1
loginTitle.Text = "RIONISM X GEMINI\nACCESS SYSTEM"
loginTitle.TextColor3 = Color3.new(1, 1, 1)
loginTitle.Font = Enum.Font.GothamBold
loginTitle.TextSize = 16
loginTitle.TextWrapped = true
loginTitle.ZIndex = 11
loginTitle.Parent = loginFrame

-- Input Kata Kunci
local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0, 210, 0, 40)
keyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
keyInput.PlaceholderText = "Paste Daily Key Here..."
keyInput.Text = ""
keyInput.TextColor3 = Color3.new(1, 1, 1)
keyInput.Font = Enum.Font.GothamSemibold
keyInput.ZIndex = 11
keyInput.Parent = loginFrame
Instance.new("UICorner", keyInput)

-- Tombol Verifikasi
local checkBtn = Instance.new("TextButton")
checkBtn.Size = UDim2.new(0, 210, 0, 40)
checkBtn.BackgroundColor3 = SETTINGS.MainColor
checkBtn.Text = "VERIFY"
checkBtn.TextColor3 = Color3.new(0,0,0)
checkBtn.Font = Enum.Font.GothamBold
checkBtn.TextSize = 14
checkBtn.ZIndex = 11
checkBtn.Parent = loginFrame
Instance.new("UICorner", checkBtn)

-- Tombol Salin Link Key
local getBtn = Instance.new("TextButton")
getBtn.Size = UDim2.new(0, 210, 0, 40)
getBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
getBtn.Text = "GET KEY (COPY LINK)"
getBtn.TextColor3 = Color3.new(1, 1, 1)
getBtn.Font = Enum.Font.GothamBold
getBtn.TextSize = 12
getBtn.ZIndex = 11
getBtn.Parent = loginFrame
Instance.new("UICorner", getBtn)


-- [ ===================================== ] --
-- [ MAIN CONTENT FRAME ] --
-- [ ===================================== ] --
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -45)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundTransparency = 1
content.Visible = false -- Sembunyikan sampai login
content.Parent = main

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
title.Text = "RIONISM X GEMINI V9.4"
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


-- [ PERFORMANCE STATS (FPS & PING) ] --
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, -20, 0, 20)
statsFrame.Position = UDim2.new(0, 10, 0, 5)
statsFrame.BackgroundTransparency = 1
statsFrame.Parent = content

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0.5, 0, 1, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 60"
fpsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
fpsLabel.Font = Enum.Font.GothamMedium
fpsLabel.TextSize = 10
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = statsFrame

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(0.5, 0, 1, 0)
pingLabel.Position = UDim2.new(0.5, 0, 0, 0)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "PING: 0ms"
pingLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
pingLabel.Font = Enum.Font.GothamMedium
pingLabel.TextSize = 10
pingLabel.TextXAlignment = Enum.TextXAlignment.Right
pingLabel.Parent = statsFrame

-- [ SEARCH FRAME ] --
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

-- [ LIST KATA (SCROLLING) ] --
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -120)
scroll.Position = UDim2.new(0, 10, 0, 115)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
scroll.ScrollBarImageColor3 = SETTINGS.MainColor
scroll.Parent = content
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 6)

-- [ UTILS: PERFORMANCE TRACKER ] --
task.spawn(function()
    while task.wait(1) do
        local fps = math.floor(1/RunService.RenderStepped:Wait())
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        fpsLabel.Text = "FPS: " .. fps
        pingLabel.Text = "PING: " .. ping .. "ms"
        
        -- Warna indikator ping
        if ping < 100 then pingLabel.TextColor3 = Color3.new(0,1,0)
        elseif ping < 200 then pingLabel.TextColor3 = Color3.new(1,1,0)
        else pingLabel.TextColor3 = Color3.new(1,0,0) end
    end
end)

-- [ LOGIC: SECURITY & LOGIN ] --
getBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(SETTINGS.KeyLink)
        getBtn.Text = "LINK COPIED!"
        task.wait(1.5)
        getBtn.Text = "GET KEY (COPY LINK)"
    else
        getBtn.Text = "Executor Not Support"
    end
end)

checkBtn.MouseButton1Click:Connect(function()
    if keyInput.Text == SETTINGS.CorrectKey then
        loginBtn.Text = "Verifying..."
        task.wait(0.5)
        loginFrame.Visible = false -- Sembunyikan login
        content.Visible = true -- Tampilkan konten utama
    else
        checkBtn.Text = "INVALID DAILY KEY"
        checkBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah
        task.wait(1.5)
        checkBtn.Text = "VERIFY"
        checkBtn.BackgroundColor3 = SETTINGS.MainColor -- Kembalikan warna
    end
end)

refreshBtn.MouseButton1Click:Connect(function()
    usedWords = {} -- Reset database kata
    refreshBtn.Text = "DATA RESET!"
    task.wait(1)
    refreshBtn.Text = "REFRESH"
end)

creditsBtn.MouseButton1Click:Connect(function()
    creditsBtn.Text = "DEV: RIONISM & GEMINI"
    task.wait(2)
    creditsBtn.Text = "CREDITS"
end)

-- [ LOGIC: SAMBUNG KATA ENGINE ] --
local function sendInput(word)
    local prefix = search.Text:lower():gsub("%s+", "")
    local suffix = word:sub(#prefix + 1)
    for i = 1, #suffix do
        local char = suffix:sub(i, i)
        local key = Enum.KeyCode[char:upper()] or Enum.KeyCode.Minus
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(SETTINGS.TypingDelay)
        VirtualInputManager:SendKeyEvent(false, key, false, game)
    end
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    search.Text = "" -- Bersihkan input otomatis
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
            if found >= 15 then break end
        end
    end
    scroll.CanvasSize = UDim2.new(0,0,0, found * 38)
end

-- [ UTILS: MINIMIZE & EFFECTS ] --
minBtn.MouseButton1Click:Connect(function()
    if not content.Visible then return end -- Disable saat login
    SETTINGS.IsMinimized = not SETTINGS.IsMinimized
    local targetSize = SETTINGS.IsMinimized and UDim2.new(0, 260, 0, 45) or UDim2.new(0, 260, 0, 420)
    TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    minBtn.Text = SETTINGS.IsMinimized and "+" or "−"
end)

clearBtn.MouseButton1Click:Connect(function() search.Text = "" search:CaptureFocus() end)
search:GetPropertyChangedSignal("Text"):Connect(updateList)

task.spawn(function()
    local ok, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/ZenoScripter/Script/refs/heads/main/Sambung%20Kata%20(%20indo%20)/wordlist_kbbi.lua") end)
    if ok then for w in res:gmatch("([%a%-]+)") do if #w > 1 then table.insert(words, w:lower()) end end end
end)

RunService.RenderStepped:Connect(function()
    local h = tick() % 5 / 5
    stroke.Color = Color3.fromHSV(h, 0.8, 1) -- Rainbow border
    title.TextColor3 = Color3.fromHSV(h, 0.7, 1) -- Rainbow text
end)

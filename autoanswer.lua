--[[
    🚀 Rionism - Sambung Kata V9.4 (Mobile Optimized)
    Update: Ultra Slim UI, Efficient Vertical Space, & Mobile Friendly.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [ LOGIC: DAILY KEY ] --
local function GetDailyKey()
    local date = os.date("!*t", os.time() + 25200) -- UTC+7 (WIB)
    return string.format("RION-%02d%02d%04d", date.day, date.month, date.year)
end

local SETTINGS = {
    MainColor = Color3.fromRGB(0, 212, 255),
    KeyLink = "https://link-rionism-gemini.com/getkey",
    CorrectKey = GetDailyKey(),
    TypingDelay = 0.05,
    IsMinimized = false,
    DefaultSize = UDim2.new(0, 200, 0, 320), -- Diperkecil (Lebar: 200, Tinggi: 320)
    MinSize = UDim2.new(0, 200, 0, 40)      -- Sangat tipis saat minimize
}

-- Tabel database & kata terpakai
local words = {}      -- Database utama (KBBI)
local usedWords = {}  -- Kata yang sudah digunakan

-- [ FEATURE: RESET USED WORDS ] --
local function ResetUsedWords()
    table.clear(usedWords)
    print("Rionism: Used words have been reset!")
end

-- [ UI SETUP ] --
local gui = Instance.new("ScreenGui")
gui.Name = "RionismSBK_V0_1"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = SETTINGS.DefaultSize
main.Position = UDim2.new(0.5, -100, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

-- Rounded Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = main

-- Title Bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "RIONISM V9.4"
title.TextColor3 = SETTINGS.MainColor
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.Parent = main

-- [ RESET BUTTON ] --
local resetBtn = Instance.new("TextButton")
resetBtn.Name = "ResetButton"
resetBtn.Size = UDim2.new(0.9, 0, 0, 35)
resetBtn.Position = UDim2.new(0.05, 0, 0.85, 0) -- Di bagian bawah agar mobile friendly
resetBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
resetBtn.Text = "RESET USED WORDS"
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 11
resetBtn.Parent = main

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 6)
resetCorner.Parent = resetBtn

local resetStroke = Instance.new("UIStroke")
resetStroke.Color = SETTINGS.MainColor
resetStroke.Thickness = 1
resetStroke.Parent = resetBtn

resetBtn.MouseButton1Click:Connect(function()
    ResetUsedWords()
    resetBtn.Text = "SUCCESS!"
    task.wait(1)
    resetBtn.Text = "RESET USED WORDS"
end)

-- [ RESIZE GRIP ] --
local resizeGrip = Instance.new("Frame")
resizeGrip.Size = UDim2.new(0, 10, 0, 10)
resizeGrip.Position = UDim2.new(1, -10, 1, -10)
resizeGrip.BackgroundTransparency = 0.3
resizeGrip.BackgroundColor3 = SETTINGS.MainColor
resizeGrip.ZIndex = 20
resizeGrip.Parent = main
Instance.new("UICorner", resizeGrip).CornerRadius = UDim.new(1, 0)

local resizing = false
resizeGrip.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        resizing = true 
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local inputPos = input.Position
        local newWidth = math.max(160, inputPos.X - main.AbsolutePosition.X)
        local newHeight = math.max(120, inputPos.Y - main.AbsolutePosition.Y)
        if not SETTINGS.IsMinimized then
            main.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        resizing = false 
    end
end)

-- [ CONTENT HOLDER ] --
local holder = Instance.new("Frame")
holder.Size = UDim2.new(1, 0, 1, 0)
holder.BackgroundTransparency = 1
holder.Parent = main

-- [ LOGIN FRAME ] --
local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(1, 0, 1, 0)
loginFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
loginFrame.ZIndex = 10
loginFrame.Parent = main
Instance.new("UICorner", loginFrame)

local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1, 0, 0, 60)
loginTitle.BackgroundTransparency = 1
loginTitle.Text = "RIONISM SAMBUNG KATA V.01"
loginTitle.TextColor3 = Color3.new(1, 1, 1)
loginTitle.Font = Enum.Font.GothamBold
loginTitle.TextSize = 13
loginTitle.ZIndex = 11
loginTitle.Parent = loginFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0, 170, 0, 35)
keyInput.Position = UDim2.new(0.5, -85, 0.3, 0)
keyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
keyInput.PlaceholderText = "Paste Key..."
keyInput.Text = ""
keyInput.TextColor3 = Color3.new(1, 1, 1)
keyInput.ZIndex = 11
keyInput.Parent = loginFrame
Instance.new("UICorner", keyInput)

local checkBtn = Instance.new("TextButton")
checkBtn.Size = UDim2.new(0, 170, 0, 35)
checkBtn.Position = UDim2.new(0.5, -85, 0.45, 10)
checkBtn.BackgroundColor3 = SETTINGS.MainColor
checkBtn.Text = "VERIFY KEY"
checkBtn.TextColor3 = Color3.new(0,0,0)
checkBtn.Font = Enum.Font.GothamBold
checkBtn.ZIndex = 11
checkBtn.Parent = loginFrame
Instance.new("UICorner", checkBtn)

local getBtn = Instance.new("TextButton")
getBtn.Size = UDim2.new(0, 170, 0, 35)
getBtn.Position = UDim2.new(0.5, -85, 0.6, 20)
getBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
getBtn.Text = "GET KEY"
getBtn.TextColor3 = Color3.new(1, 1, 1)
getBtn.Font = Enum.Font.GothamBold
getBtn.ZIndex = 11
getBtn.Parent = loginFrame
Instance.new("UICorner", getBtn)

-- [ HEADER ] --
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
header.Parent = holder

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Rionism v0.1"
title.TextColor3 = SETTINGS.MainColor
title.Font = Enum.Font.GothamBold
title.TextSize = 11
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 25)
minBtn.Position = UDim2.new(1, -35, 0, 7)
minBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
minBtn.Text = "−"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = header
Instance.new("UICorner", minBtn)


-- [ MAIN APP CONTENT ] --
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -40)
content.Position = UDim2.new(0, 0, 0, 40)
content.BackgroundTransparency = 1
content.Visible = false
content.Parent = holder

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(1, -20, 0, 25)
speedInput.Position = UDim2.new(0, 10, 0, 5)
speedInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
speedInput.PlaceholderText = "Delay (s)"
speedInput.Text = "0.05"
speedInput.TextColor3 = SETTINGS.MainColor
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 10
speedInput.Parent = content
Instance.new("UICorner", speedInput)

local search = Instance.new("TextBox")
search.Size = UDim2.new(1, -20, 0, 30)
search.Position = UDim2.new(0, 10, 0, 35)
search.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
search.PlaceholderText = "Ketik awalan..."
search.TextColor3 = Color3.new(1, 1, 1)
search.Font = Enum.Font.Gotham
search.TextSize = 11
search.Parent = content
Instance.new("UICorner", search)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -15, 1, -75)
scroll.Position = UDim2.new(0, 7, 0, 70)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 1
scroll.Parent = content
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 4)

-- [ LOGIC FUNCTIONS ] --
minBtn.MouseButton1Click:Connect(function()
    SETTINGS.IsMinimized = not SETTINGS.IsMinimized
    local targetSize = SETTINGS.IsMinimized and SETTINGS.MinSize or SETTINGS.DefaultSize
    
    if SETTINGS.IsMinimized then
        content.Visible = false
        resizeGrip.Visible = false
        minBtn.Text = "+"
    else
        minBtn.Text = "−"
    end

    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    task.wait(0.1)
    if not SETTINGS.IsMinimized then content.Visible = true resizeGrip.Visible = true end
end)

checkBtn.MouseButton1Click:Connect(function()
    if keyInput.Text == SETTINGS.CorrectKey then
        loginFrame.Visible = false
        content.Visible = true
    else
        checkBtn.Text = "WRONG KEY!"
        task.wait(1)
        checkBtn.Text = "VERIFY"
    end
end)

getBtn.MouseButton1Click:Connect(function()
    setclipboard(SETTINGS.KeyLink)
    getBtn.Text = "LINK COPIED!"
    task.wait(1)
    getBtn.Text = "GET KEY"
end)

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
            b.Size = UDim2.new(1, -5, 0, 28)
            b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            b.Text = "  " .. word:upper()
            b.TextColor3 = SETTINGS.MainColor
            b.Font = Enum.Font.GothamBold
            b.TextSize = 10
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Parent = scroll
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function()
                usedWords[word] = true
                sendInput(word)
                updateList()
            end)
            if found >= 10 then break end
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, found * 32)
end

search:GetPropertyChangedSignal("Text"):Connect(updateList)
speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val then SETTINGS.TypingDelay = math.clamp(val, 0, 2) end
end)

task.spawn(function()
    local ok, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/riowahyuc/Test/refs/heads/main/wordlist_kbbi.lua") end)
    if ok then for w in res:gmatch("([%a%-]+)") do if #w > 1 then table.insert(words, w:lower()) end end end
end)

RunService.RenderStepped:Connect(function()
    local h = tick() % 5 / 5
    stroke.Color = Color3.fromHSV(h, 0.8, 1)
    title.TextColor3 = Color3.fromHSV(h, 0.7, 1)
    resizeGrip.BackgroundColor3 = Color3.fromHSV(h, 0.8, 1)
end)

print("Rionism x Gemini V9.4 Mobile-Slim Loaded!")

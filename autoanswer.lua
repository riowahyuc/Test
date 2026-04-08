--[[
    🚀 Rionism x Gemini - Sambung Kata V9.4 (Optimized & Responsive)
    Update: Slim UI, Ultra Responsive Minimize, & Stable Resizing.
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
    DefaultSize = UDim2.new(0, 230, 0, 420), -- Lebar diperkecil ke 230
    MinSize = UDim2.new(0, 230, 0, 45)
}

local words = {}
local usedWords = {}

-- [ UI SETUP ] --
local gui = Instance.new("ScreenGui")
gui.Name = "RionismXGemini_V9_4"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = SETTINGS.DefaultSize
main.Position = UDim2.new(0.5, -115, 0.4, -210)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = gui

local corner = Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- [ RESIZE GRIP (POJOK KANAN BAWAH) ] --
local resizeGrip = Instance.new("Frame")
resizeGrip.Size = UDim2.new(0, 12, 0, 12)
resizeGrip.Position = UDim2.new(1, -12, 1, -12)
resizeGrip.BackgroundTransparency = 0.3
resizeGrip.BackgroundColor3 = SETTINGS.MainColor
resizeGrip.ZIndex = 20
resizeGrip.Parent = main
Instance.new("UICorner", resizeGrip).CornerRadius = UDim.new(1, 0)

local resizing = false
resizeGrip.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = true end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        local newWidth = math.max(200, mousePos.X - main.AbsolutePosition.X)
        local newHeight = math.max(150, mousePos.Y - main.AbsolutePosition.Y)
        if not SETTINGS.IsMinimized then
            main.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
end)

-- [ CONTENT HOLDER ] --
local holder = Instance.new("Frame")
holder.Size = UDim2.new(1, 0, 1, 0)
holder.BackgroundTransparency = 1
holder.Parent = main

-- [ LOGIN FRAME + COPY LINK ] --
local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(1, 0, 1, 0)
loginFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
loginFrame.ZIndex = 10
loginFrame.Parent = main
Instance.new("UICorner", loginFrame)

local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1, 0, 0, 80)
loginTitle.BackgroundTransparency = 1
loginTitle.Text = "RIONISM X GEMINI\nDAILY ACCESS"
loginTitle.TextColor3 = Color3.new(1, 1, 1)
loginTitle.Font = Enum.Font.GothamBold
loginTitle.TextSize = 15
loginTitle.ZIndex = 11
loginTitle.Parent = loginFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0, 210, 0, 40)
keyInput.Position = UDim2.new(0.5, -105, 0.35, 0)
keyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
keyInput.PlaceholderText = "Paste Daily Key Here..."
keyInput.Text = ""
keyInput.TextColor3 = Color3.new(1, 1, 1)
keyInput.ZIndex = 11
keyInput.Parent = loginFrame
Instance.new("UICorner", keyInput)

local checkBtn = Instance.new("TextButton")
checkBtn.Size = UDim2.new(0, 210, 0, 40)
checkBtn.Position = UDim2.new(0.5, -105, 0.5, 0)
checkBtn.BackgroundColor3 = SETTINGS.MainColor
checkBtn.Text = "VERIFY KEY"
checkBtn.TextColor3 = Color3.new(0,0,0)
checkBtn.Font = Enum.Font.GothamBold
checkBtn.ZIndex = 11
checkBtn.Parent = loginFrame
Instance.new("UICorner", checkBtn)

local getBtn = Instance.new("TextButton")
getBtn.Size = UDim2.new(0, 210, 0, 40)
getBtn.Position = UDim2.new(0.5, -105, 0.65, 0)
getBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
getBtn.Text = "GET KEY (COPY LINK)"
getBtn.TextColor3 = Color3.new(1, 1, 1)
getBtn.Font = Enum.Font.GothamBold
getBtn.ZIndex = 11
getBtn.Parent = loginFrame
Instance.new("UICorner", getBtn)

-- [ HEADER ] --
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
header.Parent = holder

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "RION X GEMINI V9.4"
title.TextColor3 = SETTINGS.MainColor
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 35, 0, 30)
minBtn.Position = UDim2.new(1, -40, 0, 7)
minBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
minBtn.Text = "−"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = header
Instance.new("UICorner", minBtn)

-- [ MAIN APP CONTENT ] --
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -45)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundTransparency = 1
content.Visible = false
content.Parent = holder

-- Speed Setting
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 5)
speedLabel.Text = "Typing Delay: 0.05s"
speedLabel.TextColor3 = Color3.new(0.7,0.7,0.7)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 10
speedLabel.BackgroundTransparency = 1
speedLabel.Parent = content

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(1, -20, 0, 25)
speedInput.Position = UDim2.new(0, 10, 0, 25)
speedInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
speedInput.Text = "0.05"
speedInput.TextColor3 = SETTINGS.MainColor
speedInput.Parent = content
Instance.new("UICorner", speedInput)

-- Search
local search = Instance.new("TextBox")
search.Size = UDim2.new(1, -20, 0, 35)
search.Position = UDim2.new(0, 10, 0, 60)
search.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
search.PlaceholderText = "Awalan Kata..."
search.TextColor3 = Color3.new(1, 1, 1)
search.Parent = content
Instance.new("UICorner", search)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -110)
scroll.Position = UDim2.new(0, 10, 0, 105)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
scroll.Parent = content
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

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

    local tween = TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize})
    tween:Play()
    
    tween.Completed:Connect(function()
        if not SETTINGS.IsMinimized then 
            content.Visible = true 
            resizeGrip.Visible = true
        end
    end)
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

speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val then
        SETTINGS.TypingDelay = math.clamp(val, 0, 2)
        speedLabel.Text = "Typing Delay: "..SETTINGS.TypingDelay.."s"
    end
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
            b.Size = UDim2.new(1, -5, 0, 30)
            b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            b.Text = "  " .. word:upper()
            b.TextColor3 = SETTINGS.MainColor
            b.Font = Enum.Font.GothamBold
            b.TextSize = 11
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
    scroll.CanvasSize = UDim2.new(0, 0, 0, found * 35)
end

search:GetPropertyChangedSignal("Text"):Connect(updateList)

task.spawn(function()
    local ok, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/ZenoScripter/Script/refs/heads/main/Sambung%20Kata%20(%20indo%20)/wordlist_kbbi.lua") end)
    if ok then for w in res:gmatch("([%a%-]+)") do if #w > 1 then table.insert(words, w:lower()) end end end
end)

RunService.RenderStepped:Connect(function()
    local h = tick() % 5 / 5
    stroke.Color = Color3.fromHSV(h, 0.8, 1)
    title.TextColor3 = Color3.fromHSV(h, 0.7, 1)
    resizeGrip.BackgroundColor3 = Color3.fromHSV(h, 0.8, 1)
end)

print("Rionism x Gemini V9.4 Loaded!")

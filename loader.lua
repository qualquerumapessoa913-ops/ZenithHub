--[[
    ZENITH HUD - Interface Premium para Executor Roblox
    Versão: 1.0.0
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- CONFIGURAÇÕES
local HUD_CONFIG = {
    Theme = {
        Background = Color3.fromRGB(18, 22, 30),
        Primary = Color3.fromRGB(59, 123, 255),
        PrimaryDark = Color3.fromRGB(43, 106, 255),
        Text = Color3.fromRGB(238, 242, 248),
        TextDim = Color3.fromRGB(142, 164, 201),
        TextBright = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(70, 130, 255),
        Success = Color3.fromRGB(80, 200, 120),
    },
    Font = Enum.Font.Gotham,
    Size = { Width = 520, Height = 600 },
}

-- ESTADO DAS FUNÇÕES
local Features = {
    Game = {
        Aimbot = { value = "Safe", type = "select", options = {"Safe", "Rage"}, keybind = nil, label = "Aimbot" },
        SilentAim = { value = false, type = "toggle", keybind = nil, label = "Silent Aim" },
        FovChange = { value = 60, type = "slider", min = 0, max = 120, keybind = nil, label = "Fov Change" },
        TriggerBot = { value = false, type = "toggle", keybind = nil, label = "TriggerBot" },
        ESP = { value = false, type = "toggle", keybind = nil, label = "ESP" },
    },
    Misc = {
        NoRecoil = { value = false, type = "toggle", keybind = nil, label = "No Recoil" },
        InfiniteAmmo = { value = false, type = "toggle", keybind = nil, label = "Infinite Ammo" },
        AutoShoot = { value = false, type = "toggle", keybind = nil, label = "Auto Shoot" },
        Supressor = { value = false, type = "toggle", keybind = nil, label = "Supressor" },
        NoClip = { value = false, type = "toggle", keybind = nil, label = "No Clip" },
    }
}

-- CRIAÇÃO DA HUD
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local isMinimized = false
local currentTab = "Game"
local recordingKey = nil

ScreenGui.Name = "ZenithHUD"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = HUD_CONFIG.Theme.Background
MainFrame.BackgroundTransparency = 0.12
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -HUD_CONFIG.Size.Width/2, 0.5, -HUD_CONFIG.Size.Height/2)
MainFrame.Size = UDim2.new(0, HUD_CONFIG.Size.Width, 0, HUD_CONFIG.Size.Height)
MainFrame.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 32)
corner.Parent = MainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = HUD_CONFIG.Theme.Border
stroke.Thickness = 1
stroke.Transparency = 0.85
stroke.Parent = MainFrame

-- Efeito Glass
local glass = Instance.new("Frame")
glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glass.BackgroundTransparency = 0.98
glass.Size = UDim2.fromScale(1, 1)
glass.Parent = MainFrame

local blur = Instance.new("BlurEffect")
blur.Size = 18
blur.Parent = glass
-- HEADER
local header = Instance.new("Frame")
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, 0, 0, 60)
header.Parent = MainFrame

-- Logo
local logo = Instance.new("Frame")
logo.BackgroundColor3 = HUD_CONFIG.Theme.Primary
logo.BackgroundTransparency = 0
logo.Size = UDim2.new(0, 38, 0, 38)
logo.Position = UDim2.new(0, 20, 0.5, -19)
logo.Parent = header

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 12)
logoCorner.Parent = logo

local logoText = Instance.new("TextLabel")
logoText.BackgroundTransparency = 1
logoText.Font = HUD_CONFIG.Font
logoText.Text = "Z"
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.TextSize = 20
logoText.TextWeight = Enum.FontWeight.Bold
logoText.Size = UDim2.fromScale(1, 1)
logoText.Parent = logo

-- Título
local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Font = HUD_CONFIG.Font
title.Text = "Zenith"
title.TextColor3 = HUD_CONFIG.Theme.TextBright
title.TextSize = 22
title.TextWeight = Enum.FontWeight.SemiBold
title.Size = UDim2.new(0, 100, 1, 0)
title.Position = UDim2.new(0, 70, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Botão Minimizar
local minimizeBtn = Instance.new("ImageButton")
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.BackgroundTransparency = 0.9
minimizeBtn.Size = UDim2.new(0, 36, 0, 36)
minimizeBtn.Position = UDim2.new(1, -50, 0.5, -18)
minimizeBtn.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1, 0)
minCorner.Parent = minimizeBtn

local minimizeIcon = Instance.new("TextLabel")
minimizeIcon.BackgroundTransparency = 1
minimizeIcon.Font = Enum.Font.FontAwesome
minimizeIcon.Text = ""
minimizeIcon.TextColor3 = Color3.fromRGB(245, 197, 66)
minimizeIcon.TextSize = 16
minimizeIcon.Size = UDim2.fromScale(1, 1)
minimizeIcon.Parent = minimizeBtn

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 120, 0, 60) or UDim2.new(0, HUD_CONFIG.Size.Width, 0, HUD_CONFIG.Size.Height)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = targetSize,
        BackgroundTransparency = isMinimized and 0.3 or 0.12,
    }):Play()
end)

-- ABAS
local tabsContainer = Instance.new("Frame")
tabsContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
tabsContainer.BackgroundTransparency = 0.3
tabsContainer.Size = UDim2.new(0, 70, 1, -80)
tabsContainer.Position = UDim2.new(0, 10, 0, 70)
tabsContainer.Parent = MainFrame

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 24)
tabCorner.Parent = tabsContainer

local tabs = {"Game", "Misc"}
local tabIcons = {Game = "", Misc = ""}
local tabButtons = {}
local yPos = 10

for _, tabName in ipairs(tabs) do
    local btn = Instance.new("ImageButton")
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.9
    btn.Size = UDim2.new(0.8, 0, 0, 45)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.Parent = tabsContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 40)
    btnCorner.Parent = btn
    
    local icon = Instance.new("TextLabel")
    icon.BackgroundTransparency = 1
    icon.Font = Enum.Font.FontAwesome
    icon.Text = tabIcons[tabName]
    icon.TextColor3 = tabName == "Game" and HUD_CONFIG.Theme.TextBright or HUD_CONFIG.Theme.TextDim
    icon.TextSize = 18
    icon.Size = UDim2.new(0, 30, 1, 0)
    icon.Position = UDim2.new(0, 8, 0, 0)
    icon.TextXAlignment = Enum.TextXAlignment.Left
    icon.Parent = btn
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Font = HUD_CONFIG.Font
    label.Text = tabName
    label.TextColor3 = tabName == "Game" and HUD_CONFIG.Theme.TextBright or HUD_CONFIG.Theme.TextDim
    label.TextSize = 13
    label.TextWeight = Enum.FontWeight.Medium
    label.Size = UDim2.new(0, 40, 1, 0)
    label.Position = UDim2.new(0, 38, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn
    
    local indicator = Instance.new("Frame")
    indicator.BackgroundColor3 = HUD_CONFIG.Theme.Primary
    indicator.BackgroundTransparency = tabName == "Game" and 0 or 0.7
    indicator.Size = UDim2.new(0, 6, 0, 6)
    indicator.Position = UDim2.new(1, -16, 0.5, -3)
    indicator.Parent = btn
    
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = indicator
    
    tabButtons[tabName] = btn
    yPos = yPos + 55
end

-- PAINEL DE CONTEÚDO
local panel = Instance.new("ScrollingFrame")
panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
panel.BackgroundTransparency = 0.15
panel.Size = UDim2.new(1, -90, 1, -80)
panel.Position = UDim2.new(0, 80, 0, 70)
panel.Parent = MainFrame

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 24)
panelCorner.Parent = panel

panel.ScrollBarThickness = 4
panel.ScrollBarImageColor3 = HUD_CONFIG.Theme.Primary
panel.ScrollBarImageTransparency = 0.6
panel.CanvasSize = UDim2.new(0, 0, 0, 0)
panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
-- FUNÇÃO PARA CRIAR FEATURES
local function CreateFeatureRow(featureId, featureData, yPos)
    local row = Instance.new("Frame")
    row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    row.BackgroundTransparency = 0.94
    row.Size = UDim2.new(1, -20, 0, 50)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.Parent = panel
    
    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 16)
    rowCorner.Parent = row
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Font = HUD_CONFIG.Font
    label.Text = featureData.label
    label.TextColor3 = HUD_CONFIG.Theme.Text
    label.TextSize = 15
    label.TextWeight = Enum.FontWeight.Medium
    label.Size = UDim2.new(0, 120, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row
    
    local dot = Instance.new("Frame")
    dot.BackgroundColor3 = featureData.value and HUD_CONFIG.Theme.Success or HUD_CONFIG.Theme.TextDim
    dot.BackgroundTransparency = featureData.value and 0 or 0.2
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = UDim2.new(0, 130, 0.5, -5)
    dot.Parent = row
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    
    local controls = Instance.new("Frame")
    controls.BackgroundTransparency = 1
    controls.Size = UDim2.new(0.6, 0, 1, 0)
    controls.Position = UDim2.new(0.4, 0, 0, 0)
    controls.Parent = row
    
    -- TOGGLE
    if featureData.type == "toggle" then
        local switch = Instance.new("Frame")
        switch.BackgroundColor3 = featureData.value and HUD_CONFIG.Theme.Primary or Color3.fromRGB(42, 49, 64)
        switch.Size = UDim2.new(0, 44, 0, 26)
        switch.Position = UDim2.new(0, 0, 0.5, -13)
        switch.Parent = controls
        
        local switchCorner = Instance.new("UICorner")
        switchCorner.CornerRadius = UDim.new(1, 0)
        switchCorner.Parent = switch
        
        local knob = Instance.new("Frame")
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Size = UDim2.new(0, 20, 0, 20)
        knob.Position = featureData.value and UDim2.new(0, 21, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        knob.Parent = switch
        
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob
        
        local function ToggleSwitch()
            featureData.value = not featureData.value
            local targetColor = featureData.value and HUD_CONFIG.Theme.Primary or Color3.fromRGB(42, 49, 64)
            local targetPos = featureData.value and UDim2.new(0, 21, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
            
            TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = targetPos}):Play()
            
            if featureData.value then
                dot.BackgroundColor3 = HUD_CONFIG.Theme.Success
                dot.BackgroundTransparency = 0
            else
                dot.BackgroundColor3 = HUD_CONFIG.Theme.TextDim
                dot.BackgroundTransparency = 0.2
            end
        end
        
        local clicker = Instance.new("ImageButton")
        clicker.BackgroundTransparency = 1
        clicker.Size = UDim2.fromScale(1, 1)
        clicker.Parent = switch
        clicker.MouseButton1Click:Connect(ToggleSwitch)
    
    -- SLIDER
    elseif featureData.type == "slider" then
        local sliderContainer = Instance.new("Frame")
        sliderContainer.BackgroundTransparency = 1
        sliderContainer.Size = UDim2.new(0.7, 0, 1, 0)
        sliderContainer.Parent = controls
        
        local slider = Instance.new("Frame")
        slider.BackgroundColor3 = Color3.fromRGB(42, 49, 64)
        slider.Size = UDim2.new(1, -50, 0, 4)
        slider.Position = UDim2.new(0, 0, 0.5, -2)
        slider.Parent = sliderContainer
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(1, 0)
        sliderCorner.Parent = slider
        
        local fill = Instance.new("Frame")
        fill.BackgroundColor3 = HUD_CONFIG.Theme.Primary
        fill.Size = UDim2.new((featureData.value - featureData.min) / (featureData.max - featureData.min), 0, 1, 0)
        fill.Parent = slider
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill
        
        local knobSlider = Instance.new("Frame")
        knobSlider.BackgroundColor3 = HUD_CONFIG.Theme.Primary
        knobSlider.Size = UDim2.new(0, 14, 0, 14)
        knobSlider.Position = UDim2.new((featureData.value - featureData.min) / (featureData.max - featureData.min), -7, 0.5, -7)
        knobSlider.Parent = slider
        
        local knobSliderCorner = Instance.new("UICorner")
        knobSliderCorner.CornerRadius = UDim.new(1, 0)
        knobSliderCorner.Parent = knobSlider
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.BackgroundTransparency = 1
        valueLabel.Font = HUD_CONFIG.Font
        valueLabel.Text = tostring(featureData.value)
        valueLabel.TextColor3 = HUD_CONFIG.Theme.TextBright
        valueLabel.TextSize = 13
        valueLabel.TextWeight = Enum.FontWeight.Medium
        valueLabel.Size = UDim2.new(0, 40, 1, 0)
        valueLabel.Position = UDim2.new(1, -45, 0, 0)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = controls
        
        local dragging = false
        knobSlider.MouseButton1Down:Connect(function() dragging = true end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        
        RunService.RenderStepped:Connect(function()
            if dragging then
                local mousePos = UserInputService:GetMouseLocation()
                local sliderPos = slider.AbsolutePosition
                local sliderSize = slider.AbsoluteSize
                local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
                local newValue = math.round(featureData.min + (featureData.max - featureData.min) * relativeX)
                
                featureData.value = newValue
                fill.Size = UDim2.new(relativeX, 0, 1, 0)
                knobSlider.Position = UDim2.new(relativeX, -7, 0.5, -7)
                valueLabel.Text = tostring(newValue)
            end
        end)
        -- SELECT
    elseif featureData.type == "select" then
        local dropdown = Instance.new("ImageButton")
        dropdown.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        dropdown.BackgroundTransparency = 0.2
        dropdown.Size = UDim2.new(0, 100, 0, 32)
        dropdown.Position = UDim2.new(0, 0, 0.5, -16)
        dropdown.Parent = controls
        
        local dropdownCorner = Instance.new("UICorner")
        dropdownCorner.CornerRadius = UDim.new(0, 16)
        dropdownCorner.Parent = dropdown
        
        local dropdownText = Instance.new("TextLabel")
        dropdownText.BackgroundTransparency = 1
        dropdownText.Font = HUD_CONFIG.Font
        dropdownText.Text = featureData.value
        dropdownText.TextColor3 = HUD_CONFIG.Theme.TextBright
        dropdownText.TextSize = 13
        dropdownText.TextWeight = Enum.FontWeight.Medium
        dropdownText.Size = UDim2.new(1, -20, 1, 0)
        dropdownText.Position = UDim2.new(0, 10, 0, 0)
        dropdownText.TextXAlignment = Enum.TextXAlignment.Left
        dropdownText.Parent = dropdown
        
        local arrow = Instance.new("TextLabel")
        arrow.BackgroundTransparency = 1
        arrow.Font = Enum.Font.FontAwesome
        arrow.Text = ""
        arrow.TextColor3 = HUD_CONFIG.Theme.TextDim
        arrow.TextSize = 14
        arrow.Size = UDim2.new(0, 20, 1, 0)
        arrow.Position = UDim2.new(1, -25, 0, 0)
        arrow.Parent = dropdown
        
        local currentIndex = 1
        for i, opt in ipairs(featureData.options) do
            if opt == featureData.value then currentIndex = i break end
        end
        
        dropdown.MouseButton1Click:Connect(function()
            currentIndex = currentIndex % #featureData.options + 1
            featureData.value = featureData.options[currentIndex]
            dropdownText.Text = featureData.value
            dot.BackgroundColor3 = HUD_CONFIG.Theme.Success
            dot.BackgroundTransparency = 0
        end)
    end
    
    -- KEYBIND
    local keybindBtn = Instance.new("ImageButton")
    keybindBtn.BackgroundColor3 = featureData.keybind and HUD_CONFIG.Theme.Primary or Color3.fromRGB(0, 0, 0)
    keybindBtn.BackgroundTransparency = featureData.keybind and 0.15 or 0.25
    keybindBtn.Size = UDim2.new(0, 60, 0, 28)
    keybindBtn.Position = UDim2.new(1, -70, 0.5, -14)
    keybindBtn.Parent = controls
    
    local keybindCorner = Instance.new("UICorner")
    keybindCorner.CornerRadius = UDim.new(0, 40)
    keybindCorner.Parent = keybindBtn
    
    local keybindText = Instance.new("TextLabel")
    keybindText.BackgroundTransparency = 1
    keybindText.Font = HUD_CONFIG.Font
    keybindText.Text = featureData.keybind or "key"
    keybindText.TextColor3 = featureData.keybind and HUD_CONFIG.Theme.TextBright or HUD_CONFIG.Theme.TextDim
    keybindText.TextSize = 11
    keybindText.TextWeight = Enum.FontWeight.Medium
    keybindText.Size = UDim2.fromScale(1, 1)
    keybindText.Parent = keybindBtn
    
    keybindBtn.MouseButton1Click:Connect(function()
        if recordingKey then return end
        recordingKey = featureId
        keybindText.Text = "..."
        keybindBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
        keybindBtn.BackgroundTransparency = 0.15
        keybindText.TextColor3 = Color3.fromRGB(255, 180, 60)
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local key = input.KeyCode.Name
                if key == "Escape" then
                    recordingKey = nil
                    keybindText.Text = featureData.keybind or "key"
                    keybindBtn.BackgroundColor3 = featureData.keybind and HUD_CONFIG.Theme.Primary or Color3.fromRGB(0, 0, 0)
                    keybindBtn.BackgroundTransparency = featureData.keybind and 0.15 or 0.25
                    keybindText.TextColor3 = featureData.keybind and HUD_CONFIG.Theme.TextBright or HUD_CONFIG.Theme.TextDim
                    connection:Disconnect()
                    return
                end
                
                featureData.keybind = key
                keybindText.Text = key
                recordingKey = nil
                keybindBtn.BackgroundColor3 = HUD_CONFIG.Theme.Primary
                keybindBtn.BackgroundTransparency = 0.15
                keybindText.TextColor3 = HUD_CONFIG.Theme.TextBright
                connection:Disconnect()
            end
        end)
        
        task.delay(5, function()
            if recordingKey == featureId then
                recordingKey = nil
                keybindText.Text = featureData.keybind or "key"
                keybindBtn.BackgroundColor3 = featureData.keybind and HUD_CONFIG.Theme.Primary or Color3.fromRGB(0, 0, 0)
                keybindBtn.BackgroundTransparency = featureData.keybind and 0.15 or 0.25
                keybindText.TextColor3 = featureData.keybind and HUD_CONFIG.Theme.TextBright or HUD_CONFIG.Theme.TextDim
                connection:Disconnect()
            end
        end)
    end)
    
    return row
end

-- POPULAR PAINEL
local function PopulatePanel(category)
    for _, child in ipairs(panel:GetChildren()) do
        child:Destroy()
    end
    
    local yPos = 10
    local features = Features[category]
    
    for id, data in pairs(features) do
        local row = CreateFeatureRow(id, data, yPos)
        yPos = yPos + 55
    end
    
    panel.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
end

-- SISTEMA DE KEYBINDS GLOBAL
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    
    local key = input.KeyCode.Name
    
    for category, features in pairs(Features) do
        for id, data in pairs(features) do
            if data.keybind and data.keybind == key then
                if data.type == "toggle" then
                    data.value = not data.value
                elseif data.type == "select" then
                    local currentIndex = 1
                    for i, opt in ipairs(data.options) do
                        if opt == data.value then currentIndex = i break end
                    end
                    currentIndex = currentIndex % #data.options + 1
                    data.value = data.options[currentIndex]
                end
                PopulatePanel(currentTab)
            end
        end
    end
end)

-- EVENTOS DAS ABAS
for tabName, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        currentTab = tabName
        PopulatePanel(tabName)
        
        for name, button in pairs(tabButtons) do
            local indicator = button:FindFirstChildOfClass("Frame")
            if indicator then
                indicator.BackgroundTransparency = (name == tabName) and 0 or 0.7
            end
            local icon = button:FindFirstChildOfClass("TextLabel")
            local label = button:FindFirstChildOfClass("TextLabel")
            if icon and label then
                if name == tabName then
                    icon.TextColor3 = HUD_CONFIG.Theme.TextBright
                    label.TextColor3 = HUD_CONFIG.Theme.TextBright
                else
                    icon.TextColor3 = HUD_CONFIG.Theme.TextDim
                    label.TextColor3 = HUD_CONFIG.Theme.TextDim
                end
            end
        end
    end)
end

-- INICIALIZAR
PopulatePanel("Game")

-- Animação de entrada
MainFrame.Position = UDim2.new(0.5, -HUD_CONFIG.Size.Width/2, 0.5, HUD_CONFIG.Size.Height)
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -HUD_CONFIG.Size.Width/2, 0.5, -HUD_CONFIG.Size.Height/2),
}):Play()

-- FUNÇÕES EXPORTADAS
return {
    GetFeature = function(name)
        for _, category in pairs(Features) do
            if category[name] then return category[name] end
        end
        return nil
    end,
    GetFeatures = function() return Features end,
    ToggleFeature = function(name)
        for _, category in pairs(Features) do
            if category[name] and category[name].type == "toggle" then
                category[name].value = not category[name].value
                return category[name].value
            end
        end
        return nil
    end,
    SetFeatureValue = function(name, value)
        for _, category in pairs(Features) do
            if category[name] then
                category[name].value = value
                return true
            end
        end
        return false
    end,
    GetFeatureValue = function(name)
        for _, category in pairs(Features) do
            if category[name] then return category[name].value end
        end
        return nil
    end
}

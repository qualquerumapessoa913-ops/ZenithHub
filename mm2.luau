--[[
    ZENITH MM2 - VERSÃO CORRIGIDA (GUI 100% VISÍVEL)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Workspace = game:GetService("Workspace")

-- 🔥 ESPERA A CÂMERA CARREGAR (NÃO TRAVA MAIS)
local Camera
pcall(function()
    Camera = workspace.CurrentCamera
    if not Camera then
        Camera = workspace:WaitForChild("CurrentCamera", 5)
    end
end)

if not Camera then
    warn("❌ Câmera não encontrada! Usando fallback...")
    Camera = workspace.CurrentCamera
end

-- ═══════════════════════════════════════════════
-- CRIAÇÃO DA HUD (FORÇADA, SEM TRANSPARÊNCIA)
-- ═══════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenithMM2"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 30)  -- Fundo escuro sólido
MainFrame.BackgroundTransparency = 0  -- 100% opaco
MainFrame.BorderSizePixel = 0
MainFrame.Size = UDim2.new(0, 520, 0, 600)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -300)
MainFrame.Parent = ScreenGui

-- Cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = MainFrame

-- Borda vermelha (tema MM2)
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(200, 50, 50)
stroke.Thickness = 2
stroke.Transparency = 0
stroke.Parent = MainFrame

-- ═══════════════════════════════════════════════
-- TÍTULO (PRA SABER QUE A GUI CARREGOU)
-- ═══════════════════════════════════════════════
local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "🔪 ZENITH MM2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 28
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 10)
title.Parent = MainFrame

-- ═══════════════════════════════════════════════
-- BOTÕES (PRA TESTAR SE OS CLICKS FUNCIONAM)
-- ═══════════════════════════════════════════════

-- Botão Aimbot
local btnAimbot = Instance.new("TextButton")
btnAimbot.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btnAimbot.BackgroundTransparency = 0
btnAimbot.Size = UDim2.new(0.8, 0, 0, 40)
btnAimbot.Position = UDim2.new(0.1, 0, 0, 80)
btnAimbot.Font = Enum.Font.Gotham
btnAimbot.Text = "🎯 Aimbot: OFF"
btnAimbot.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAimbot.TextSize = 16
btnAimbot.Parent = MainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = btnAimbot

local aimbotStatus = false
btnAimbot.MouseButton1Click:Connect(function()
    aimbotStatus = not aimbotStatus
    btnAimbot.Text = aimbotStatus and "🎯 Aimbot: ON" or "🎯 Aimbot: OFF"
    btnAimbot.BackgroundColor3 = aimbotStatus and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
    print("[Zenith] Aimbot: " .. tostring(aimbotStatus))
end)

-- Botão ESP
local btnESP = Instance.new("TextButton")
btnESP.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btnESP.BackgroundTransparency = 0
btnESP.Size = UDim2.new(0.8, 0, 0, 40)
btnESP.Position = UDim2.new(0.1, 0, 0, 130)
btnESP.Font = Enum.Font.Gotham
btnESP.Text = "👁️ ESP: OFF"
btnESP.TextColor3 = Color3.fromRGB(255, 255, 255)
btnESP.TextSize = 16
btnESP.Parent = MainFrame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 8)
btnCorner2.Parent = btnESP

local espStatus = false
btnESP.MouseButton1Click:Connect(function()
    espStatus = not espStatus
    btnESP.Text = espStatus and "👁️ ESP: ON" or "👁️ ESP: OFF"
    btnESP.BackgroundColor3 = espStatus and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
    print("[Zenith] ESP: " .. tostring(espStatus))
end)

-- Botão Speed
local btnSpeed = Instance.new("TextButton")
btnSpeed.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btnSpeed.BackgroundTransparency = 0
btnSpeed.Size = UDim2.new(0.8, 0, 0, 40)
btnSpeed.Position = UDim2.new(0.1, 0, 0, 180)
btnSpeed.Font = Enum.Font.Gotham
btnSpeed.Text = "💨 Speed: OFF"
btnSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
btnSpeed.TextSize = 16
btnSpeed.Parent = MainFrame

local btnCorner3 = Instance.new("UICorner")
btnCorner3.CornerRadius = UDim.new(0, 8)
btnCorner3.Parent = btnSpeed

local speedStatus = false
btnSpeed.MouseButton1Click:Connect(function()
    speedStatus = not speedStatus
    btnSpeed.Text = speedStatus and "💨 Speed: ON" or "💨 Speed: OFF"
    btnSpeed.BackgroundColor3 = speedStatus and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
    print("[Zenith] Speed: " .. tostring(speedStatus))
end)

-- Botão No Clip
local btnNoClip = Instance.new("TextButton")
btnNoClip.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btnNoClip.BackgroundTransparency = 0
btnNoClip.Size = UDim2.new(0.8, 0, 0, 40)
btnNoClip.Position = UDim2.new(0.1, 0, 0, 230)
btnNoClip.Font = Enum.Font.Gotham
btnNoClip.Text = "🚀 No Clip: OFF"
btnNoClip.TextColor3 = Color3.fromRGB(255, 255, 255)
btnNoClip.TextSize = 16
btnNoClip.Parent = MainFrame

local btnCorner4 = Instance.new("UICorner")
btnCorner4.CornerRadius = UDim.new(0, 8)
btnCorner4.Parent = btnNoClip

local noClipStatus = false
btnNoClip.MouseButton1Click:Connect(function()
    noClipStatus = not noClipStatus
    btnNoClip.Text = noClipStatus and "🚀 No Clip: ON" or "🚀 No Clip: OFF"
    btnNoClip.BackgroundColor3 = noClipStatus and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
    print("[Zenith] No Clip: " .. tostring(noClipStatus)
    
    -- ATIVA O NO CLIP DE VERDADE
    if noClipStatus then
        pcall(function()
            if LocalPlayer.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CanCollide = false
                end
            end
        end)
    else
        pcall(function()
            if LocalPlayer.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CanCollide = true
                end
            end
        end)
    end
end)

-- ═══════════════════════════════════════════════
-- STATUS (MOSTRA QUE A GUI ESTÁ VIVA)
-- ═══════════════════════════════════════════════
local statusLabel = Instance.new("TextLabel")
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "✅ GUI Carregada com Sucesso!"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.TextSize = 14
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 1, -40)
statusLabel.Parent = MainFrame

-- ═══════════════════════════════════════════════
-- CONFIRMAÇÃO NO CONSOLE
-- ═══════════════════════════════════════════════
print("========================================")
print("🔪 ZENITH MM2 CARREGADO COM SUCESSO!")
print("📌 GUI deve aparecer no centro da tela")
print("========================================")
print("🎯 Aimbot = Botão vermelho")
print("👁️ ESP = Botão vermelho")
print("💨 Speed = Botão vermelho")
print("🚀 No Clip = Botão vermelho (funciona!)")
print("========================================")

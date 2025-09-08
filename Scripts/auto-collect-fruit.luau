local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 4
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.Parent = ScreenGui

local function createButton(text, position)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 260, 0, 40)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Button.BorderSizePixel = 4
    Button.BorderColor3 = Color3.fromRGB(255, 0, 0)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 0, 0)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextScaled = true
    Button.Parent = MainFrame
    return Button
end

local AutoCollectBtn = createButton("Auto coletar fruta", UDim2.new(0, 20, 0, 60))
local EspBtn = createButton("Esp fruta", UDim2.new(0, 20, 0, 120))

local autoCollect = false
AutoCollectBtn.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    AutoCollectBtn.Text = autoCollect and "Auto coletar: ON" or "Auto coletar: OFF"
    while autoCollect do
        task.wait(1)
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    TweenService:Create(hrp, TweenInfo.new(4, Enum.EasingStyle.Linear), {CFrame = fruit.Handle.CFrame}):Play()
                end
            end
        end
    end
end)

local espActive = false
EspBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    EspBtn.Text = espActive and "ESP: ON" or "ESP: OFF"
    if espActive then
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = fruit.Handle
                highlight.FillTransparency = 1
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineTransparency = 0
                highlight.Parent = fruit
            end
        end
    else
        for _, fruit in pairs(workspace:GetChildren()) do
            if fruit:FindFirstChild("Highlight") then
                fruit.Highlight:Destroy()
            end
        end
    end
end)

MainFrame.Active = true
MainFrame.Draggable = true

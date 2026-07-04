-- [[ GAG2 Ultimate Movement Menu v3.1 - Fixed Core ]] --
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- جلب مجلد واجهة اللاعب لضمان توافقية 100% وظهورها فوراً
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- إعدادات الميزات
local isFlying = false
local flySpeed = 50
local infiniteJumpEnabled = false

-- تدمير أي نسخة قديمة للسكربت لتفادي التعليق
if PlayerGui:FindFirstChild("AshesModernMenu") then
    PlayerGui["AshesModernMenu"]:Destroy()
end

-- [[ إنشاء الواجهة ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui
ScreenGui.Name = "AshesModernMenu"
ScreenGui.ResetOnSpawn = false -- يضمن عدم اختفاء الواجهة إذا مات اللاعب

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -120, 0.4, -100)
MainFrame.Size = UDim2.new(0, 240, 0, 230)
MainFrame.Active = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- شريط العنوان العلوي
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(0.75, 0, 1, 0)
TitleText.Position = UDim2.new(0.05, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Ashes Menu V3.1"
TitleText.TextColor3 = Color3.fromRGB(0, 170, 255)
TitleText.TextSize = 15
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- زر التصغير (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = TitleBar
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(0.85, 0, 0.13, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 5)

-- الأيقونة المصغرة العائمة
local MiniIcon = Instance.new("TextButton")
MiniIcon.Parent = ScreenGui
MiniIcon.Size = UDim2.new(0, 50, 0, 50)
MiniIcon.Position = UDim2.new(0.05, 0, 0.2, 0)
MiniIcon.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MiniIcon.Text = "Ashes"
MiniIcon.TextColor3 = Color3.fromRGB(0, 170, 255)
MiniIcon.TextSize = 13
MiniIcon.Font = Enum.Font.SourceSansBold
MiniIcon.Visible = false
Instance.new("UICorner", MiniIcon).CornerRadius = UDim.new(1, 0)

-- دالة إنشاء الأزرار بشكل متناسق
local function CreateButton(text, pos, color)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local InfJumpBtn = CreateButton("القفز اللانهائي: [مغلق]", UDim2.new(0.05, 0, 0.24, 0), Color3.fromRGB(35, 35, 35))
local FlyBtn = CreateButton("الطيران السلس: [مغلق]", UDim2.new(0.05, 0, 0.46, 0), Color3.fromRGB(35, 35, 35))
local FpsBtn = CreateButton("تعزيز الـ FPS (تقليل اللاق)", UDim2.new(0.05, 0, 0.68, 0), Color3.fromRGB(0, 120, 255))

-- [[ نظام التحريك بالسحب (Touch & Mouse Drag) ]] --
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- تحريك الأيقونة المصغرة عند سحبها
local dragMini, miniStart, miniStartPos
MiniIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragMini = true
        miniStart = input.Position
        miniStartPos = MiniIcon.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragMini = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragMini and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - miniStart
        MiniIcon.Position = UDim2.new(miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X, miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y)
    end
end)

-- فتح وإغلاق التصغير
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniIcon.Visible = true
end)

MiniIcon.MouseButton1Click:Connect(function()
    if not dragMini then
        MainFrame.Visible = true
        MiniIcon.Visible = false
    end
end)

-- [[ ميزة 1: القفز اللانهائي ]] --
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

InfJumpBtn.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    if infiniteJumpEnabled then
        InfJumpBtn.Text = "القفز اللانهائي: [مفعّل]"
        InfJumpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    else
        InfJumpBtn.Text = "القفز اللانهائي: [مغلق]"
        InfJumpBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end
end)

-- [[ ميزة 2: الطيران المصلح بالكامل (Fly) ]] --
local bodyGyro, bodyVelocity
local function startFlying()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    
    bodyGyro = Instance.new("BodyGyro")
    bodyVelocity = Instance.new("BodyVelocity")
    
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    bodyVelocity.velocity = Vector3.new(0, 0, 0)
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = rootPart
    
    humanoid.PlatformStand = true
    local camera = workspace.CurrentCamera
    
    task.spawn(function()
        while isFlying and character.Parent do
            RunService.RenderStepped:Wait()
            local dir = humanoid.MoveDirection
            local velocity = dir * flySpeed
            
            -- الارتفاع عند الضغط على زر القفز في الشاشة أو الكيبورد
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, flySpeed, 0)
            end
            
            bodyVelocity.velocity = velocity
            bodyGyro.cframe = camera.CFrame
        end
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
        if humanoid then humanoid.PlatformStand = false end
    end)
end

FlyBtn.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    if isFlying then
        FlyBtn.Text = "الطيران السلس: [مفعّل]"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
        startFlying()
    else
        FlyBtn.Text = "الطيران السلس: [مغلق]"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end
end)

-- [[ ميزة 3: معزز الـ FPS ]] --
FpsBtn.MouseButton1Click:Connect(function()
    pcall(function()
        game:GetService("Lighting").GlobalShadows = false
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("PostEffect") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
    end)
    FpsBtn.Text = "تم تعزيز الـ FPS بنجاح ✅"
    FpsBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    task.wait(2)
    FpsBtn.Text = "تعزيز الـ FPS (تقليل اللاق)"
    FpsBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
end)

print("[Ashes Menu]: Loaded into PlayerGui successfully.")

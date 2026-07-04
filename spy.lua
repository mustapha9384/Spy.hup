-- [[ GAG2 Infinite Jump & Fly Script ]] --
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- إلغاء تشغيل النسخة السابقة إذا كانت تعمل
if _G.AshesMovementLoaded then 
    _G.AshesMovementLoaded = false 
    task.wait(0.2)
end
_G.AshesMovementLoaded = true

-- إعدادات الطيران والقفز
local isFlying = false
local flySpeed = 50
local infiniteJumpEnabled = false

-- إنشاء الواجهة وتنسيقها
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "AshesMovementMenu"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -120, 0.4, -90)
MainFrame.Size = UDim2.new(0, 240, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "GAG2 Movement Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

-- زر تشغيل/إطفاء القفز اللانهائي
local InfJumpBtn = Instance.new("TextButton")
InfJumpBtn.Parent = MainFrame
InfJumpBtn.Size = UDim2.new(0.9, 0, 0, 40)
InfJumpBtn.Position = UDim2.new(0.05, 0, 0.28, 0)
InfJumpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
InfJumpBtn.Text = "القفز اللانهائي: [مغلق]"
InfJumpBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
InfJumpBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", InfJumpBtn).CornerRadius = UDim.new(0, 6)

-- زر تشغيل/إطفاء الطيران
local FlyBtn = Instance.new("TextButton")
FlyBtn.Parent = MainFrame
FlyBtn.Size = UDim2.new(0.9, 0, 0, 40)
FlyBtn.Position = UDim2.new(0.05, 0, 0.58, 0)
FlyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FlyBtn.Text = "الطيران: [مغلق]"
FlyBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
FlyBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", FlyBtn).CornerRadius = UDim.new(0, 6)

--- منطق القفز اللانهائي (Infinite Jump) ---
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and _G.AshesMovementLoaded then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

InfJumpBtn.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    if infiniteJumpEnabled then
        InfJumpBtn.Text = "القفز اللانهائي: [مفعّل]"
        InfJumpBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        InfJumpBtn.Text = "القفز اللانهائي: [مغلق]"
        InfJumpBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

--- منطق الطيران (Fly System) ---
local function startFlying()
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if not rootPart or not humanoid then return end
    
    local bodyGyro = Instance.new("BodyGyro")
    local bodyVelocity = Instance.new("BodyVelocity")
    
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    bodyVelocity.velocity = Vector3.new(0, 0.1, 0)
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = rootPart
    
    humanoid.PlatformStand = true
    
    local camera = workspace.CurrentCamera
    
    -- حلقة التحكم بالطيران والتوجيه مع الكاميرا
    task.spawn(function()
        while isFlying and _G.AshesMovementLoaded and character.Parent do
            RunService.RenderStepped:Wait()
            
            local moveDirection = humanoid.MoveDirection
            local velocity = Vector3.new(0, 0, 0)
            
            if moveDirection.Magnitude > 0 then
                velocity = moveDirection * flySpeed
            end
            
            -- الارتفاع والانخفاض باستخدام أزرار القفز والـ Shift (أو النقر لشاشات اللمس)
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, flySpeed, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity + Vector3.new(0, -flySpeed, 0)
            end
            
            bodyVelocity.velocity = velocity
            bodyGyro.cframe = camera.CFrame
        end
        
        -- تنظيف الأجسام عند إغلاق الطيران
        bodyGyro:Destroy()
        bodyVelocity:Destroy()
        if humanoid then humanoid.PlatformStand = false end
    end)
end

FlyBtn.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    if isFlying then
        FlyBtn.Text = "الطيران: [مفعّل]"
        FlyBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        startFlying()
    else
        FlyBtn.Text = "الطيران: [مغلق]"
        FlyBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

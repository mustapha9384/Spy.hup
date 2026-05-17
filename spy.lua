local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Spy Hub | V42",
    SubTitle = "Developed by Spy",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark"
})

-- Global Settings
local Settings = {
    BoatFly = false,
    BoatSpeed = 100,
    BoatHeight = 100,
    FullBright = false,
    WaterWalk = false,
    FastAttack = false,
    AttackSpeed = 1
}

-- Boat Flight Loop
task.spawn(function()
    while true do
        if Settings.BoatFly then
            pcall(function()
                local Character = game.Players.LocalPlayer.Character
                if Character then
                    local Humanoid = Character:FindFirstChild("Humanoid")
                    local RootPart = Character:FindFirstChild("HumanoidRootPart")
                    if Humanoid and RootPart then
                        RootPart.CFrame = CFrame.new(RootPart.Position.X, Settings.BoatHeight, RootPart.Position.Z) * RootPart.CFrame.Rotation
                        RootPart.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
        end
        task.wait(0.1)
    end
end)

-- Full Bright Loop
task.spawn(function()
    while true do
        if Settings.FullBright then
            pcall(function()
                local Lighting = game:GetService("Lighting")
                Lighting.Brightness = 3
                Lighting.ClockTime = 12
                Lighting.FogEnd = 999999
                Lighting.GlobalShadows = false
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            end)
        else
            pcall(function()
                local Lighting = game:GetService("Lighting")
                Lighting.Brightness = 1
                Lighting.ClockTime = 14
            end)
        end
        task.wait(1)
    end
end)

-- Water Walk Loop
task.spawn(function()
    while true do
        if Settings.WaterWalk then
            pcall(function()
                local Character = game.Players.LocalPlayer.Character
                if Character then
                    local RootPart = Character:FindFirstChild("HumanoidRootPart")
                    if RootPart then
                        for _, Part in pairs(workspace:FindPartBoundsInRadius(RootPart.Position, 100)) do
                            if Part.Name:lower():find("water") or Part.Parent.Name:lower():find("water") then
                                local WaterY = Part.Position.Y + (Part.Size.Y / 2)
                                RootPart.Position = Vector3.new(RootPart.Position.X, WaterY - 1, RootPart.Position.Z)
                                RootPart.Velocity = RootPart.Velocity * Vector3.new(1, 0, 1)
                                break
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.1)
    end
end)

-- Fast Attack Loop
task.spawn(function()
    while true do
        if Settings.FastAttack then
            pcall(function()
                local Player = game.Players.LocalPlayer
                if Player and Player.Character then
                    local Character = Player.Character
                    local RootPart = Character:FindFirstChild("HumanoidRootPart")
                    if RootPart then
                        for _, OtherChar in pairs(workspace:GetChildren()) do
                            if OtherChar:IsA("Model") and OtherChar ~= Character and OtherChar:FindFirstChild("Humanoid") then
                                local OtherRoot = OtherChar:FindFirstChild("HumanoidRootPart")
                                if OtherRoot then
                                    local Distance = (RootPart.Position - OtherRoot.Position).Magnitude
                                    if Distance < 50 then
                                        OtherChar.Humanoid:TakeDamage(25 * Settings.AttackSpeed)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.1 / Settings.AttackSpeed)
    end
end)

-- Main Tab
local MainTab = Window:AddTab({ Title = "Boat Master", Icon = "ship" })

MainTab:AddSection("Movement")
MainTab:AddToggle("BoatFly", {
    Title = "Enable Boat Flight",
    Default = false,
    Callback = function(Value)
        Settings.BoatFly = Value
        Fluent:Notify({
            Title = "Spy Hub",
            Content = "Boat Flight: " .. (Value and "ON ✅" or "OFF ❌"),
            Duration = 2
        })
    end
})

MainTab:AddSlider("BoatSpeed", {
    Title = "Drive Power",
    Default = 100,
    Min = 0,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        Settings.BoatSpeed = Value
    end
})

MainTab:AddSection("Boat Control")
MainTab:AddSlider("BoatHeight", {
    Title = "Flight Height",
    Default = 100,
    Min = 0,
    Max = 500,
    Rounding = 1,
    Callback = function(Value)
        Settings.BoatHeight = Value
    end
})

-- Visuals Tab
local VisualsTab = Window:AddTab({ Title = "Visuals", Icon = "eye" })

VisualsTab:AddSection("Environment")
VisualsTab:AddToggle("FullBright", {
    Title = "Full Bright (Sea 6 Fix)",
    Default = false,
    Callback = function(Value)
        Settings.FullBright = Value
        Fluent:Notify({
            Title = "Spy Hub",
            Content = "Full Bright: " .. (Value and "ON ✅" or "OFF ❌"),
            Duration = 2
        })
    end
})

VisualsTab:AddSection("Water")
VisualsTab:AddToggle("WaterWalk", {
    Title = "Walk On Water",
    Default = false,
    Callback = function(Value)
        Settings.WaterWalk = Value
        Fluent:Notify({
            Title = "Spy Hub",
            Content = "Water Walk: " .. (Value and "ON ✅" or "OFF ❌"),
            Duration = 2
        })
    end
})

-- Attack Tab
local AttackTab = Window:AddTab({ Title = "Attack", Icon = "zap" })

AttackTab:AddSection("Fast Attack ⚡")
AttackTab:AddToggle("FastAttack", {
    Title = "Enable Fast Attack",
    Default = false,
    Callback = function(Value)
        Settings.FastAttack = Value
        Fluent:Notify({
            Title = "Spy Hub",
            Content = "Fast Attack: " .. (Value and "ON ✅" or "OFF ❌"),
            Duration = 2
        })
    end
})

AttackTab:AddSlider("AttackSpeed", {
    Title = "Attack Speed Multiplier",
    Default = 1,
    Min = 0.5,
    Max = 5,
    Rounding = 0.1,
    Callback = function(Value)
        Settings.AttackSpeed = Value
    end
})

AttackTab:AddSection("Attack Info 📊")
AttackTab:AddLabel("⚡ يهاجم الأعداء القريبين بسرعة")
AttackTab:AddLabel("📍 النطاق: 50 studs")
AttackTab:AddLabel("💪 الضرر الأساسي: 25 لكل ضربة")
AttackTab:AddLabel("🔢 الضرر يتضاعف مع السرعة")

-- Settings Tab
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "settings" })

SettingsTab:AddSection("About")
SettingsTab:AddLabel("🕵️ Spy Hub V42")
SettingsTab:AddLabel("Made for Advanced Gaming")
SettingsTab:AddButton({
    Title = "Refresh UI",
    Callback = function()
        Fluent:Notify({
            Title = "Spy Hub",
            Content = "UI Refreshed! ✅",
            Duration = 2
        })
    end
})

SettingsTab:AddButton({
    Title = "Destroy UI",
    Callback = function()
        Window:Destroy()
    end
})

-- Success Notification
Fluent:Notify({
    Title = "Spy Hub V42",
    Content = "السكربت جاهز! اختر الميزة اللي تبيها 🎮",
    Duration = 5
})

Window:SelectTab(1)
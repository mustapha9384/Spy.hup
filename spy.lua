local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Key = "alzaz"
local OldKey = "spy1838493742"
local EnteredKey = ""
local IsLoaded = false
local SecretKey = "جاسوس"
local TrappedUsers = {}

-- ===================== التخزين في ملف دائم =====================
local FILE_NAME = "SpyTrappedUsers.txt"

local function SaveTrappedUsers()
    local success, result = pcall(function()
        local jsonData = game:GetService("HttpService"):JSONEncode(TrappedUsers)
        if writefile then
            writefile(FILE_NAME, jsonData)
        else
            local storage = game.CoreGui:FindFirstChild("SpyTrappedStorage")
            if not storage then
                storage = Instance.new("Folder")
                storage.Name = "SpyTrappedStorage"
                storage.Parent = game.CoreGui
            end
            local dataStore = storage:FindFirstChild("TrappedUsersData")
            if not dataStore then
                dataStore = Instance.new("StringValue")
                dataStore.Name = "TrappedUsersData"
                dataStore.Parent = storage
            end
            dataStore.Value = jsonData
        end
    end)
    if not success then
        warn("خطأ في حفظ الضحايا: " .. tostring(result))
    end
end

local function LoadTrappedUsers()
    local success, result = pcall(function()
        if readfile and isfile and isfile(FILE_NAME) then
            local jsonData = readfile(FILE_NAME)
            local decoded = game:GetService("HttpService"):JSONDecode(jsonData)
            if type(decoded) == "table" then
                for _, user in ipairs(decoded) do
                    local exists = false
                    for _, existing in ipairs(TrappedUsers) do
                        if existing.UserId == user.UserId then
                            exists = true
                            break
                        end
                    end
                    if not exists then
                        table.insert(TrappedUsers, user)
                    end
                end
            end
        else
            local storage = game.CoreGui:FindFirstChild("SpyTrappedStorage")
            if storage then
                local dataStore = storage:FindFirstChild("TrappedUsersData")
                if dataStore and dataStore.Value ~= "" then
                    local jsonData = dataStore.Value
                    local decoded = game:GetService("HttpService"):JSONDecode(jsonData)
                    if type(decoded) == "table" then
                        for _, user in ipairs(decoded) do
                            local exists = false
                            for _, existing in ipairs(TrappedUsers) do
                                if existing.UserId == user.UserId then
                                    exists = true
                                    break
                                end
                            end
                            if not exists then
                                table.insert(TrappedUsers, user)
                            end
                        end
                    end
                end
            end
        end
    end)
    if not success then
        warn("خطأ في تحميل الضحايا: " .. tostring(result))
    end
end

LoadTrappedUsers()

local Window = Fluent:CreateWindow({
    Title = "Spy Hub | V42",
    SubTitle = "Developed by Spy",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark"
})

local function AddTrappedUser(userId, displayName)
    for _, user in ipairs(TrappedUsers) do
        if user.UserId == userId then
            return false
        end
    end
    table.insert(TrappedUsers, {
        UserId = userId,
        DisplayName = displayName,
        Time = os.date("%Y-%m-%d %H:%M:%S")
    })
    SaveTrappedUsers()
    return true
end

local function LoadMainScript()
    local Tabs = { 
        Main = Window:AddTab({ Title = "Boat Master", Icon = "ship" }),
        Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" })
    }

    _G.BoatSpeed = 0
    _G.BoatHeight = 100
    _G.BoatFly = false
    _G.FullBright = false

    task.spawn(function()
        while true do
            if _G.BoatFly then
                pcall(function()
                    local char = game.Players.LocalPlayer.Character
                    local seat = char and char.Humanoid.SeatPart
                    if seat and seat:IsA("VehicleSeat") then
                        local bg = seat:FindFirstChild("SpyGyro") or Instance.new("BodyGyro", seat)
                        bg.Name = "SpyGyro"
                        bg.Parent = seat
                        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                        if _G.BoatSpeed > 0 then
                            seat.CFrame = seat.CFrame * CFrame.new(0, 0, -(_G.BoatSpeed / 35))
                        end
                        seat.CFrame = CFrame.new(seat.Position.X, _G.BoatHeight, seat.Position.Z) * seat.CFrame.Rotation
                        seat.Velocity = Vector3.new(0,0,0)
                    end
                end)
            end
            task.wait()
        end
    end)

    task.spawn(function()
        local Lighting = game:GetService("Lighting")
        while true do
            if _G.FullBright then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            else
                Lighting.GlobalShadows = true
            end
            task.wait(1)
        end
    end)

    Tabs.Main:AddSection("Movement")
    Tabs.Main:AddToggle("BoatFly", {Title = "Enable Boat Flight", Default = false, Callback = function(v) _G.BoatFly = v end})
    Tabs.Main:AddSlider("Speed", {Title = "Drive Power", Default = 100, Min = 0, Max = 1000, Rounding = 0, Callback = function(v) _G.BoatSpeed = v end})
    Tabs.Main:AddSlider("Height", {Title = "Height", Default = 20, Min = 20, Max = 1000, Rounding = 0, Callback = function(v) _G.BoatHeight = v end})
    
    Tabs.Visuals:AddSection("Environment")
    Tabs.Visuals:AddToggle("FullBright", {Title = "Full Bright (Sea 6 Fix)", Default = false, Callback = function(v) _G.FullBright = v end})
end

-- ===================== دوال العرض كاملة =====================
local function ShowArabicMessage(title, message, duration)
    local sg = Instance.new("ScreenGui")
    sg.Parent = game.CoreGui
    sg.Name = "SpyMessage"
    
    local frame = Instance.new("Frame")
    frame.Parent = sg
    frame.Size = UDim2.new(0, 400, 0, 200)
    frame.Position = UDim2.new(0.5, -200, 0.4, -100)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderColor3 = Color3.fromRGB(255, 50, 50)
    frame.BorderSizePixel = 3
    frame.BackgroundTransparency = 0.1
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = frame
    titleLabel.Size = UDim2.new(1, -20, 0, 40)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 24
    titleLabel.BackgroundTransparency = 1
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Parent = frame
    messageLabel.Size = UDim2.new(1, -20, 1, -100)
    messageLabel.Position = UDim2.new(0, 10, 0, 60)
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 18
    messageLabel.BackgroundTransparency = 1
    messageLabel.TextWrapped = true
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    local closeButton = Instance.new("TextButton")
    closeButton.Parent = frame
    closeButton.Size = UDim2.new(0, 100, 0, 30)
    closeButton.Position = UDim2.new(0.5, -50, 1, -40)
    closeButton.Text = "حسناً"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    
    closeButton.MouseButton1Click:Connect(function()
        sg:Destroy()
    end)
    
    delay(duration, function()
        if sg and sg.Parent then
            sg:Destroy()
        end
    end)
end

local function ShowTrappedUsersList()
    local sg = Instance.new("ScreenGui")
    sg.Parent = game.CoreGui
    sg.Name = "SpyTrappedUsers"
    
    local frame = Instance.new("Frame")
    frame.Parent = sg
    frame.Size = UDim2.new(0, 450, 0, 400)
    frame.Position = UDim2.new(0.5, -225, 0.4, -200)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
    frame.BorderSizePixel = 3
    frame.BackgroundTransparency = 0.1
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = frame
    titleLabel.Size = UDim2.new(1, -20, 0, 40)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.Text = "🕵️ قائمة الضحايا 🕵️"
    titleLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 22
    titleLabel.BackgroundTransparency = 1
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Parent = frame
    scrollFrame.Size = UDim2.new(1, -20, 1, -100)
    scrollFrame.Position = UDim2.new(0, 10, 0, 60)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 0)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = scrollFrame
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    if #TrappedUsers == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Parent = scrollFrame
        emptyLabel.Size = UDim2.new(1, 0, 0, 30)
        emptyLabel.Text = "لا يوجد ضحايا... للأسف 😢"
        emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.TextSize = 16
        emptyLabel.BackgroundTransparency = 1
    else
        for i, user in ipairs(TrappedUsers) do
            local userFrame = Instance.new("Frame")
            userFrame.Parent = scrollFrame
            userFrame.Size = UDim2.new(1, -10, 0, 45)
            userFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            userFrame.BorderSizePixel = 0
            
            local numberLabel = Instance.new("TextLabel")
            numberLabel.Parent = userFrame
            numberLabel.Size = UDim2.new(0, 30, 1, 0)
            numberLabel.Position = UDim2.new(0, 5, 0, 0)
            numberLabel.Text = "#" .. i
            numberLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            numberLabel.Font = Enum.Font.GothamBold
            numberLabel.TextSize = 18
            numberLabel.BackgroundTransparency = 1
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = userFrame
            nameLabel.Size = UDim2.new(0, 250, 0, 20)
            nameLabel.Position = UDim2.new(0, 40, 0, 3)
            nameLabel.Text = "👤 " .. user.DisplayName
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextSize = 15
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local idLabel = Instance.new("TextLabel")
            idLabel.Parent = userFrame
            idLabel.Size = UDim2.new(0, 250, 0, 20)
            idLabel.Position = UDim2.new(0, 40, 0, 23)
            idLabel.Text = "ID: " .. user.UserId
            idLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            idLabel.Font = Enum.Font.Gotham
            idLabel.TextSize = 13
            idLabel.BackgroundTransparency = 1
            idLabel.TextXAlignment = Enum.TextXAlignment.Left
        end
    end
    
    local refreshButton = Instance.new("TextButton")
    refreshButton.Parent = frame
    refreshButton.Size = UDim2.new(0, 100, 0, 30)
    refreshButton.Position = UDim2.new(0, 10, 1, -40)
    refreshButton.Text = "تحديث"
    refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    refreshButton.Font = Enum.Font.GothamBold
    refreshButton.TextSize = 16
    
    refreshButton.MouseButton1Click:Connect(function()
        sg:Destroy()
        ShowTrappedUsersList()
    end)
    
    local closeButton = Instance.new("TextButton")
    closeButton.Parent = frame
    closeButton.Size = UDim2.new(0, 100, 0, 30)
    closeButton.Position = UDim2.new(1, -110, 1, -40)
    closeButton.Text = "إغلاق"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    
    closeButton.MouseButton1Click:Connect(function()
        sg:Destroy()
    end)
    
    local countLabel = Instance.new("TextLabel")
    countLabel.Parent = frame
    countLabel.Size = UDim2.new(0, 200, 0, 25)
    countLabel.Position = UDim2.new(0.5, -100, 1, -70)
    countLabel.Text = "عدد الضحايا: " .. #TrappedUsers .. " 👿"
    countLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    countLabel.Font = Enum.Font.GothamBold
    countLabel.TextSize = 16
    countLabel.BackgroundTransparency = 1
end

-- ===================== واجهة المفاتيح =====================
local KeyTab = Window:AddTab({ Title = "Verification", Icon = "key" })

KeyTab:AddInput("Input", {
    Title = "Enter Activation Key",
    Default = "",
    Placeholder = "Enter the key...",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        EnteredKey = Value
    end
})

KeyTab:AddButton({
    Title = "Verify Key",
    Description = "Unlock Spy Hub Features",
    Callback = function()
        if EnteredKey == SecretKey then
            ShowTrappedUsersList()
            return
        end
        
        if IsLoaded and EnteredKey ~= SecretKey then
            Fluent:Notify({Title = "Spy Hub", Content = "Already Active!", Duration = 3})
            return 
        end
        
        if EnteredKey == OldKey then
            local player = game.Players.LocalPlayer
            AddTrappedUser(player.UserId, player.DisplayName)
            ShowArabicMessage(
                "😂😂😂",
                "المفتاح تغير ههه قلتلك اني بغير المفتاح يا ابن الحرام 😂",
                10
            )
            return
        end
        
        if EnteredKey == Key then
            IsLoaded = true
            Fluent:Notify({Title = "Success!", Content = "Spy Hub V42 Activated!", Duration = 5})
            LoadMainScript()
        else
            Fluent:Notify({Title = "Error!", Content = "Incorrect Key!", Duration = 5})
        end
    end
})

local function CreateMinimize()
    local sg = Instance.new("ScreenGui", game.CoreGui)
    local btn = Instance.new("ImageButton", sg)
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0, 20, 0, 150)
    btn.Image = "rbxassetid://15115500021"
    btn.Draggable = true
    btn.Active = true
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.MouseButton1Click:Connect(function() Window:Minimize() end)
end

CreateMinimize()
Window:SelectTab(1)

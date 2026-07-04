-- [[ GAG2 Anti-Ban Advanced Server Hopper ]] --
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- حماية إضافية: التأكد من عدم تكرار تشغيل السكربت لتجنب الـ Crash أو الرصد
if _G.AshesHopperLoaded then 
    print("السكربت يعمل بالفعل!") 
    return 
end
_G.AshesHopperLoaded = true

-- إنشاء الواجهة وتنسيقها
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "AshesSafeHopper"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -120)
MainFrame.Size = UDim2.new(0, 260, 0, 290)
MainFrame.Active = true
MainFrame.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "GAG2 Safe Hopper (Bypass)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- قائمة البتات
local petList = {"Void Pet", "Demon Pet", "Angel Pet", "Shadow Pet", "Cactus Pet", "Gold Pet", "Alien Pet", "Frost Pet"}
local currentPetIndex = 1

local PetSelectBtn = Instance.new("TextButton")
PetSelectBtn.Parent = MainFrame
PetSelectBtn.Size = UDim2.new(0.9, 0, 0, 35)
PetSelectBtn.Position = UDim2.new(0.05, 0, 0.22, 0)
PetSelectBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PetSelectBtn.Text = "إختر البت: " .. petList[currentPetIndex]
PetSelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", PetSelectBtn).CornerRadius = UDim.new(0, 6)

PetSelectBtn.MouseButton1Click:Connect(function()
    currentPetIndex = currentPetIndex + 1
    if currentPetIndex > #petList then currentPetIndex = 1 end
    PetSelectBtn.Text = "إختر البت: " .. petList[currentPetIndex]
end)

-- زر البحث عن البت
local TeleportPetBtn = Instance.new("TextButton")
TeleportPetBtn.Parent = MainFrame
TeleportPetBtn.Size = UDim2.new(0.9, 0, 0, 35)
TeleportPetBtn.Position = UDim2.new(0.05, 0, 0.42, 0)
TeleportPetBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 220)
TeleportPetBtn.Text = "بحث آمن عن البت"
TeleportPetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportPetBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", TeleportPetBtn).CornerRadius = UDim.new(0, 6)

-- زر السيرفر الغني
local TeleportRichBtn = Instance.new("TextButton")
TeleportRichBtn.Parent = MainFrame
TeleportRichBtn.Size = UDim2.new(0.9, 0, 0, 35)
TeleportRichBtn.Position = UDim2.new(0.05, 0, 0.62, 0)
TeleportRichBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 60)
TeleportRichBtn.Text = "سيرفر غني (+30M Coins)"
TeleportRichBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportRichBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", TeleportRichBtn).CornerRadius = UDim.new(0, 6)

-- نص الحالة
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.05, 0, 0.82, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "الحالة: الحماية نشطة وجاهزة"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
StatusLabel.TextSize = 13

--- وظيفة الانتقال الآمن والـ Server Hop المقاوم للباند ---
local function SafeTeleport()
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.Text = "جاري تجميع قائمة سيرفرات آمنة..."
    
    local placeId = game.PlaceId
    -- جلب السيرفرات بترتيب تنازلي وعشوائي لتشتيت أنظمة المراقبة
    local serversUrl = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Desc&limit=100"
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(serversUrl))
    end)
    
    if success and result and result.data then
        -- فلترة السيرفرات لضمان عدم الدخول لسيرفر ممتلئ تماماً أو شبه فارغ يثير الشكوك
        local validServers = {}
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.playing > 2 and server.id ~= game.JobId then
                table.insert(validServers, server.id)
            end
        end
        
        if #validServers > 0 then
            -- اختيار سيرفر عشوائي تماماً من القائمة المتاحة (حماية قوية ضد الـ Anti-Cheat)
            local randomServerId = validServers[math.random(1, #validServers)]
            StatusLabel.Text = "تجهيز النقل الآمن..."
            
            -- تأخير عشوائي مضاف (بين 1 إلى 3 ثوانٍ) قبل النقل الفعلي لمحاكاة تأخر العنصر البشري
            task.wait(math.random(100, 300) / 100)
            
            pcall(function()
                TeleportService:TeleportToPlaceInstance(placeId, randomServerId, LocalPlayer)
            end)
        else
            StatusLabel.Text = "لم يتم العثور على سيرفرات ملائمة، إعادة المحاولة..."
            task.wait(2)
            SafeTeleport()
        end
    else
        StatusLabel.Text = "فشل جلب السيرفرات، جاري المحاولة..."
        task.wait(3)
        SafeTeleport()
    end
end

--- وظيفة فحص الليدربورد والشروط بشكل متخفي ---
local function checkCurrentServer()
    if _G.SearchMode == "Rich" then
        for _, player in ipairs(Players:GetPlayers()) do
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                local coins = leaderstats:FindFirstChild("Coins") or leaderstats:FindFirstChild("Money") or leaderstats:FindFirstChild("Cash")
                if coins and coins.Value >= 30000000 then
                    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
                    StatusLabel.Text = "تم العثور على هدف: " .. player.Name
                    return true
                end
            end
        end
    end

    if _G.SearchMode == "Pet" and _G.TargetPetName then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name:lower() == _G.TargetPetName:lower() or string.find(obj.Name:lower(), _G.TargetPetName:lower()) then
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
                StatusLabel.Text = "تم العثور على البت المطلوبة!"
                return true
            end
        end
    end
    
    return false
end

-- تفعيل الأزرار مع منع الـ Spam
local lastClick = 0
local function canClick()
    if os.time() - lastClick > 3 then
        lastClick = os.time()
        return true
    end
    return false
end

TeleportRichBtn.MouseButton1Click:Connect(function()
    if not canClick() then return end
    _G.SearchMode = "Rich"
    SafeTeleport()
end)

TeleportPetBtn.MouseButton1Click:Connect(function()
    if not canClick() then return end
    _G.SearchMode = "Pet"
    _G.TargetPetName = petList[currentPetIndex]
    SafeTeleport()
end)

-- بدء الفحص بعد دخول السيرفر الجديد بأمان
task.spawn(function()
    -- انتظار عشوائي وآمن يتراوح بين 4 إلى 6 ثوانٍ لضمان تحميل البيانات وتجنب الرصد الفوري
    task.wait(math.random(400, 600) / 100)
    
    if _G.SearchMode then
        local found = checkCurrentServer()
        if not found then
            StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
            StatusLabel.Text = "الشروط غير متطابقة. جاري القفز الآمن..."
            task.wait(math.random(150, 250) / 100) -- تأخير إضافي قبل المغادرة
            SafeTeleport()
        end
    end
end)

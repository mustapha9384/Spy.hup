local a=loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local b="alzaz"
local c="spy1838493742"
local d=""
local e=false
local f="جاسوس"
local g={}
local h="SpyTrappedUsers.txt"
local function i()local j,k=pcall(function()local l=game:GetService("HttpService"):JSONEncode(g)if writefile then writefile(h,l)else local m=game.CoreGui:FindFirstChild("SpyTrappedStorage")if not m then m=Instance.new("Folder")m.Name="SpyTrappedStorage"m.Parent=game.CoreGui end
local n=m:FindFirstChild("TrappedUsersData")if not n then n=Instance.new("StringValue")n.Name="TrappedUsersData"n.Parent=m end
n.Value=l end end)if not j then warn("خطأ في حفظ: "..tostring(k))end end
local function o()local j,k=pcall(function()if readfile and isfile and isfile(h)then local l=readfile(h)local p=game:GetService("HttpService"):JSONDecode(l)if type(p)=="table"then for _,q in ipairs(p)do local r=false for _,s in ipairs(g)do if s.UserId==q.UserId then r=true break end end
if not r then table.insert(g,q)end end end else local m=game.CoreGui:FindFirstChild("SpyTrappedStorage")if m then local n=m:FindFirstChild("TrappedUsersData")if n and n.Value~=""then local l=n.Value
local p=game:GetService("HttpService"):JSONDecode(l)if type(p)=="table"then for _,q in ipairs(p)do local r=false for _,s in ipairs(g)do if s.UserId==q.UserId then r=true break end end
if not r then table.insert(g,q)end end end end end end end)if not j then warn("خطأ في تحميل: "..tostring(k))end end
o()
local t=a:CreateWindow({Title="Spy Hub | V42",SubTitle="Developed by Spy",TabWidth=160,Size=UDim2.fromOffset(580,460),Acrylic=false,Theme="Dark"})
local function u(v,w)for _,q in ipairs(g)do if q.UserId==v then return false end end
table.insert(g,{UserId=v,DisplayName=w,Time=os.date("%Y-%m-%d %H:%M:%S")})i()return true end
local function x()local y={Main=t:AddTab({Title="Boat Master",Icon="ship"}),Visuals=t:AddTab({Title="Visuals",Icon="eye"})}
_G.BoatSpeed=0
_G.BoatHeight=100
_G.BoatFly=false
_G.FullBright=false
task.spawn(function()while true do if _G.BoatFly then pcall(function()local z=game.Players.LocalPlayer.Character local A=z and z.Humanoid.SeatPart if A and A:IsA("VehicleSeat")then local B=A:FindFirstChild("SpyGyro")or Instance.new("BodyGyro",A)B.Name="SpyGyro"B.Parent=A B.MaxTorque=Vector3.new(math.huge,math.huge,math.huge)if _G.BoatSpeed>0 then A.CFrame=A.CFrame*CFrame.new(0,0,-(_G.BoatSpeed/35))end
A.CFrame=CFrame.new(A.Position.X,_G.BoatHeight,A.Position.Z)*A.CFrame.Rotation A.Velocity=Vector3.new(0,0,0)end end)end
task.wait()end end)
task.spawn(function()local C=game:GetService("Lighting")while true do if _G.FullBright then C.Brightness=2 C.ClockTime=14 C.FogEnd=100000 C.GlobalShadows=false C.Ambient=Color3.fromRGB(255,255,255)C.OutdoorAmbient=Color3.fromRGB(255,255,255)else C.GlobalShadows=true end
task.wait(1)end end)
y.Main:AddSection("Movement")y.Main:AddToggle("BoatFly",{Title="Enable Boat Flight",Default=false,Callback=function(v)_G.BoatFly=v end})y.Main:AddSlider("Speed",{Title="Drive Power",Default=100,Min=0,Max=1000,Rounding=0,Callback=function(v)_G.BoatSpeed=v end})y.Main:AddSlider("Height",{Title="Height",Default=20,Min=20,Max=1000,Rounding=0,Callback=function(v)_G.BoatHeight=v end})
y.Visuals:AddSection("Environment")y.Visuals:AddToggle("FullBright",{Title="Full Bright (Sea 6 Fix)",Default=false,Callback=function(v)_G.FullBright=v end})end
local function D(w,E,F)local G=Instance.new("ScreenGui")G.Parent=game.CoreGui G.Name="SpyMessage"
local H=Instance.new("Frame")H.Parent=G H.Size=UDim2.new(0,400,0,200)H.Position=UDim2.new(0.5,-200,0.4,-100)H.BackgroundColor3=Color3.fromRGB(20,20,20)H.BorderColor3=Color3.fromRGB(255,50,50)H.BorderSizePixel=3 H.BackgroundTransparency=0.1
local I=Instance.new("TextLabel")I.Parent=H I.Size=UDim2.new(1,-20,0,40)I.Position=UDim2.new(0,10,0,10)I.Text=w I.TextColor3=Color3.fromRGB(255,50,50)I.Font=Enum.Font.GothamBold I.TextSize=24 I.BackgroundTransparency=1
local J=Instance.new("TextLabel")J.Parent=H J.Size=UDim2.new(1,-20,1,-100)J.Position=UDim2.new(0,10,0,60)J.Text=E J.TextColor3=Color3.fromRGB(255,255,255)J.Font=Enum.Font.Gotham J.TextSize=18 J.BackgroundTransparency=1 J.TextWrapped=true J.TextYAlignment=Enum.TextYAlignment.Top
local K=Instance.new("TextButton")K.Parent=H K.Size=UDim2.new(0,100,0,30)K.Position=UDim2.new(0.5,-50,1,-40)K.Text="حسناً"K.TextColor3=Color3.fromRGB(255,255,255)K.BackgroundColor3=Color3.fromRGB(255,50,50)K.Font=Enum.Font.GothamBold K.TextSize=16
K.MouseButton1Click:Connect(function()G:Destroy()end)
delay(F,function()if G and G.Parent then G:Destroy()end end)end
local function L()local G=Instance.new("ScreenGui")G.Parent=game.CoreGui G.Name="SpyTrappedUsers"
local H=Instance.new("Frame")H.Parent=G H.Size=UDim2.new(0,450,0,400)H.Position=UDim2.new(0.5,-225,0.4,-200)H.BackgroundColor3=Color3.fromRGB(20,20,20)H.BorderColor3=Color3.fromRGB(0,255,0)H.BorderSizePixel=3 H.BackgroundTransparency=0.1
local I=Instance.new("TextLabel")I.Parent=H I.Size=UDim2.new(1,-20,0,40)I.Position=UDim2.new(0,10,0,10)I.Text="🕵️ قائمة الضحايا 🕵️"I.TextColor3=Color3.fromRGB(0,255,0)I.Font=Enum.Font.GothamBold I.TextSize=22 I.BackgroundTransparency=1
local M=Instance.new("ScrollingFrame")M.Parent=H M.Size=UDim2.new(1,-20,1,-100)M.Position=UDim2.new(0,10,0,60)M.BackgroundColor3=Color3.fromRGB(30,30,30)M.BorderSizePixel=0 M.ScrollBarThickness=8 M.ScrollBarImageColor3=Color3.fromRGB(0,255,0)
local N=Instance.new("UIListLayout")N.Parent=M N.Padding=UDim.new(0,5)N.SortOrder=Enum.SortOrder.LayoutOrder
if #g==0 then local O=Instance.new("TextLabel")O.Parent=M O.Size=UDim2.new(1,0,0,30)O.Text="لا يوجد ضحايا... للأسف 😢"O.TextColor3=Color3.fromRGB(150,150,150)O.Font=Enum.Font.Gotham O.TextSize=16 O.BackgroundTransparency=1 else for P,q in ipairs(g)do local Q=Instance.new("Frame")Q.Parent=M Q.Size=UDim2.new(1,-10,0,45)Q.BackgroundColor3=Color3.fromRGB(40,40,40)Q.BorderSizePixel=0
local R=Instance.new("TextLabel")R.Parent=Q R.Size=UDim2.new(0,30,1,0)R.Position=UDim2.new(0,5,0,0)R.Text="#"..P R.TextColor3=Color3.fromRGB(0,255,0)R.Font=Enum.Font.GothamBold R.TextSize=18 R.BackgroundTransparency=1
local S=Instance.new("TextLabel")S.Parent=Q S.Size=UDim2.new(0,250,0,20)S.Position=UDim2.new(0,40,0,3)S.Text="👤 "..q.DisplayName S.TextColor3=Color3.fromRGB(255,255,255)S.Font=Enum.Font.Gotham S.TextSize=15 S.BackgroundTransparency=1 S.TextXAlignment=Enum.TextXAlignment.Left
local T=Instance.new("TextLabel")T.Parent=Q T.Size=UDim2.new(0,250,0,20)T.Position=UDim2.new(0,40,0,23)T.Text="ID: "..q.UserId T.TextColor3=Color3.fromRGB(150,150,150)T.Font=Enum.Font.Gotham T.TextSize=13 T.BackgroundTransparency=1 T.TextXAlignment=Enum.TextXAlignment.Left end end
local U=Instance.new("TextButton")U.Parent=H U.Size=UDim2.new(0,100,0,30)U.Position=UDim2.new(0,10,1,-40)U.Text="تحديث"U.TextColor3=Color3.fromRGB(255,255,255)U.BackgroundColor3=Color3.fromRGB(50,50,50)U.Font=Enum.Font.GothamBold U.TextSize=16
U.MouseButton1Click:Connect(function()G:Destroy()L()end)
local K=Instance.new("TextButton")K.Parent=H K.Size=UDim2.new(0,100,0,30)K.Position=UDim2.new(1,-110,1,-40)K.Text="إغلاق"K.TextColor3=Color3.fromRGB(255,255,255)K.BackgroundColor3=Color3.fromRGB(255,50,50)K.Font=Enum.Font.GothamBold K.TextSize=16
K.MouseButton1Click:Connect(function()G:Destroy()end)
local V=Instance.new("TextLabel")V.Parent=H V.Size=UDim2.new(0,200,0,25)V.Position=UDim2.new(0.5,-100,1,-70)V.Text="عدد الضحايا: "..#g.." 👿"V.TextColor3=Color3.fromRGB(255,255,0)V.Font=Enum.Font.GothamBold V.TextSize=16 V.BackgroundTransparency=1 end
local W=t:AddTab({Title="Verification",Icon="key"})
W:AddInput("Input",{Title="Enter Activation Key",Default="",Placeholder="Enter the key...",Numeric=false,Finished=false,Callback=function(v)d=v end})
W:AddButton({Title="Verify Key",Description="Unlock Spy Hub Features",Callback=function()if d==f then L()return end
if e and d~=f then a:Notify({Title="Spy Hub",Content="Already Active!",Duration=3})return end
if d==c then local X=game.Players.LocalPlayer u(X.UserId,X.DisplayName)D("😂😂😂","المفتاح تغير ههه قلتلك اني بغير المفتاح يا ابن الحرام 😂",10)return end
if d==b then e=true a:Notify({Title="Success!",Content="Spy Hub V42 Activated!",Duration=5})x()else a:Notify({Title="Error!",Content="Incorrect Key!",Duration=5})end end})
local function Y()local Z=Instance.new("ScreenGui",game.CoreGui)local _=Instance.new("ImageButton",Z)_.Size=UDim2.new(0,50,0,50)_.Position=UDim2.new(0,20,0,150)_.Image="rbxassetid://15115500021"_.Draggable=true _.Active=true _.BackgroundColor3=Color3.fromRGB(30,30,30)_.MouseButton1Click:Connect(function()t:Minimize()end)end
Y()t:SelectTab(1)
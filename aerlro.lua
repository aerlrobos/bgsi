local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VIM = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local RemoteFunction = RS.Shared.Framework.Network.Remote:WaitForChild("RemoteFunction")
local RemoteEvent = RS.Shared.Framework.Network.Remote:WaitForChild("RemoteEvent")
local Remote = require(RS.Shared.Framework.Network.Remote)
local RiftsModule = require(RS.Shared.Data.Rifts)
local Powerups=require(RS.Shared.Data.Powerups)
local PotionsModule = require(RS.Shared.Data.Potions)
local ShrineValues = require(RS.Shared.Data.ShrineValues)
local GumData = require(RS.Shared.Data.Gum)
local BoardUtil = require(RS.Shared.Utils.BoardUtil)
local ShopUtil=require(RS.Shared.Utils.ShopUtil)
local ShopsData=require(RS.Shared.Data.Shops)
local minigamesModule=require(RS.Shared.Data.Minigames)
local EnchantsModule = require(RS.Shared.Data.Enchants)
local petsModule = require(RS.Shared.Data.Pets)
local eggsModule = require(RS.Shared.Data.Eggs)
local secretBountyUtil = require(RS.Shared.Utils.Stats.SecretBountyUtil)
local Board = require(RS.Client.Gui.Frames.Board)
local HatchEggModule=require(RS.Client.Effects.HatchEgg)
local PhysicalItem = require(RS.Client.Effects.PhysicalItem)
local QuestUtil = require(ReplicatedStorage.Shared.Utils.Stats.QuestUtil)
local TimeUtil = require(ReplicatedStorage.Shared.Framework.Utilities.Math.Time)
local Constants = require(ReplicatedStorage.Shared.Constants)
local humanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local LocalData = require(RS.Client.Framework.Services.LocalData)
local playerData = LocalData:Get()
playerData.UserId=LocalPlayer.UserId
local failedFile = "FailedWebhooks.json"

local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

-- global christmas config
getgenv().ChristmasConfig = {
    AutoGiveGifts = false,
    AutoClaimAdvent = false,
    AutoCollectPresentRain = false
}
-- global farming config
getgenv().FarmingConfig={AutoPickup=false,AutoBubble=false,AutoBubbleSell=false,AutoGoldenOrb=false,AutoFishing=false,BubbleSellMode=nil,BubbleSellInterval=3,BubbleSellLocation=nil}
getgenv().ObbyConfig={Enabled=false,AutoChest=false,Difficulties={}}
getgenv().MasteryConfig={Selected=nil,Auto=false}
-- global quests config
getgenv().GenieSettings = getgenv().GenieSettings or {
    MustHave = {"Dream Shard"},
    AutoGemGenieReroll = false,
    SelectedCard = nil,
    LastPosition = nil,
    TeleportedEggs = {},
    AlreadyTeleported = {}
}
-- global worlds config
getgenv().WorldsConfig={SelectedWorlds={},AutoDiscover=false}getgenv().TeleportConfig={Selected=nil}
-- global riftseggs config
getgenv().RiftsConfig={SelectedEgg=nil,AutoHatch=false,DisableEggAnim=false,SelectedEggRift=nil,SelectedChestRift=nil,IgnoreMultiplier={},TeleportEggRift=false,TeleportChestRift=false}
-- global pets config
getgenv().EnchantConfig = {
    Slot1 = "Anything",
    Slot2 = "Anything",
    EnchantMethod = "Gems Only",
    SelectedTeam = nil,
    AutoEnchantActive = false
}
local COOLDOWN_BETWEEN_REROLLS = 0.5
getgenv().PetsConfig=getgenv().PetsConfig or{SelectedDeleteRarities={},SelectedShinyRarities={},IgnoreTags={},AutoDelete=false,AutoShiny=false}
-- global potions config
getgenv().PotionsConfig = {
    SelectedUsePotion = nil,
    SelectedUsePotionLevel = 1,
    UsePotions = false,
    SelectedCraftPotion = nil,
    SelectedCraftPotionLevel = 1,
    CraftPotions = false
}
-- global shops config
getgenv().ShopsConfig={SelectedShops={},SelectedItems={},AutoBuyItems=false,BuyAll=false,RerollShop=nil,AutoReroll=false}
-- global minigames config
getgenv().boardSettings = getgenv().boardSettings or {
    UseGoldenDice = true,
    GoldenDiceDistance = 1,
    DiceDistance = 6,
    GiantDiceDistance = 10,
}
getgenv().selectedTileTypes = getgenv().selectedTileTypes or {}
getgenv().autoRoll = false
getgenv().MinigamesConfig={SelectedDifficulty=nil,SuperTicketGame=nil,AutoRun={}}
-- global webhook config
getgenv().WebhookConfig = getgenv().WebhookConfig or {
    NormalMinChance = 1e6,
    ExclusiveMinChance = 500,
    UseBaseChance = false,
    Webhook = "",
    DiscordUserID = "",
    SendToWebhook = true,
    PingUserOnSecret = false
}
local webhookQueue = {}
local isProcessingQueue = false
-- global misc config
getgenv().MiscConfig=getgenv().MiscConfig or{SelectedChests={},AutoIslandChests=false,AutoPlaytime=false,AutoSeason=false,AutoWheelSpin=false,AutoFestivalWheelSpin=false,AutoHalloweenWheelSpin=false,AutoDarkWheelSpin=false,WheelSpinDelay=0.1,SelectedPotion=nil,PotionQuantity=1,AutoDonateShrine=false,SelectedFish=nil,FishQuantity=1,AutoDonateDreamerShrine=false,SelectedPowerupEgg=nil,AutoHatchPowerupsEggs=false,SelectedBox=nil,AutoOpenBoxes=false}
getgenv().FPSBoosterConfig = {
    FPS = 60,
    LowGraphics = false,
    EffectsOff = true,
    FullBright = false
}

local player = Players.LocalPlayer
if not player then return end

local enabled = true
local clicks = 0

local function antiAfk()
    if not enabled then return end
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
    clicks += 1
end

player.Idled:Connect(function()
    antiAfk()
end)

local startTime = tick()
local function formatPlaytime()
    local elapsed = math.floor(tick() - startTime)
    local days = math.floor(elapsed / 86400)
    local hours = math.floor((elapsed % 86400) / 3600)
    local minutes = math.floor((elapsed % 3600) / 60)
    local seconds = elapsed % 60
    local parts = {}
    if days > 0 then table.insert(parts, days .. "d") end
    if hours > 0 or #parts > 0 then table.insert(parts, hours .. "h") end
    if minutes > 0 or #parts > 0 then table.insert(parts, minutes .. "m") end
    table.insert(parts, seconds .. "s")
    return table.concat(parts, " ")
end

local Window = Library:CreateWindow{
    Title = "OTC v1.1",
    SubTitle = "by aerlro",
    TabWidth = 140,
    Size = UDim2.fromOffset(650, 400),
    MinSize = Vector2.new(400, 320),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
}

local Tabs = {
    Home = Window:CreateTab{ Title = "Home", Icon = "rbxassetid://96624083086513" },
    Christmas = Window:CreateTab{ Title = "Christmas", Icon = "phosphor-snowflake-bold" },
    Farming = Window:CreateTab{ Title = "Farming", Icon = "rbxassetid://121401017387099" },
    Worlds = Window:CreateTab{ Title = "Worlds", Icon = "rbxassetid://129493670982282" },
    RiftsEggs = Window:CreateTab{ Title = "Rifts & Eggs", Icon = "rbxassetid://88860918799119" },
    Pets = Window:CreateTab{ Title = "Pets", Icon = "rbxassetid://140431377231411" },
    Shops = Window:CreateTab{ Title = "Shops", Icon = "rbxassetid://115333223353502" },
    Potions = Window:CreateTab{ Title = "Potions", Icon = "rbxassetid://104674617808438" },
    Minigames = Window:CreateTab{ Title = "Minigames", Icon = "rbxassetid://113460478746845" },
    Webhooks = Window:CreateTab{ Title = "Webhooks", Icon = "rbxassetid://135843589193435" },
    Misc = Window:CreateTab{ Title = "Misc", Icon = "rbxassetid://113277025719614" },
    Settings = Window:CreateTab{ Title = "Settings", Icon = "settings" }
}

local Player = Players.LocalPlayer
local function teleportTo(pos)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(pos)
    else
        warn("⚠️ No HumanoidRootPart found.")
    end
end

local HomeInfoSection = Tabs.Home:CreateSection("▶ Info")
local PlaytimeParagraph = HomeInfoSection:CreateParagraph("Playtime", {Title="Playtime", Content=formatPlaytime()})
local HomeDiscordSection = Tabs.Home:CreateSection("▶ Discord")

Tabs.Home:CreateButton{
    Title = "Copy Discord Invite",
    Description = "Copy server invite link",
    Callback = function()
        setclipboard("https://discord.gg/TYV2cbVYYX")
    end
}

task.spawn(function()
    while true do
        PlaytimeParagraph:SetValue(formatPlaytime())
        task.wait(1)
    end
end)

local ChristmasSection=Tabs.Christmas:CreateSection("▶️ Christmas Event")local VIM=game:GetService("VirtualInputManager")local LP=game:GetService("Players").LocalPlayer local ChristmasEggs={["Candycane Egg"]=CFrame.new(-2484.03979,33.5360146,1247.66748),["Gingerbread Egg"]=CFrame.new(-2477.53955,33.5356445,1256.54053),["Yuletide Egg"]=CFrame.new(-2490.54028,33.5360146,1238.7937),["Infinity Egg"]=CFrame.new(-2613.427,24.010891,1090.76404)}getgenv().ChristmasEggConfig=getgenv().ChristmasEggConfig or {}getgenv().ChristmasEggConfig.SelectedEgg=nil getgenv().ChristmasEggConfig.AutoHatch=false getgenv().ChristmasConfig=getgenv().ChristmasConfig or {}getgenv().ChristmasConfig.AutoGiveGifts=false getgenv().ChristmasConfig.IsBusyWithGift=false local function nearEgg(pos)local h=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")if not h then return false end return(h.Position-pos.Position).Magnitude<10 end local function tpEgg(egg)local c=ChristmasEggs[egg]local h=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")if c and h then h.CFrame=c+Vector3.new(0,3,0)end end local function pressE()task.spawn(function()while getgenv().ChristmasEggConfig.AutoHatch do VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game)task.wait(0.1)VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game)task.wait(0.2)end end)end ChristmasSection:CreateDropdown("XmasEggSelect",{Title="Christmas Eggs",Values={"Candycane Egg","Gingerbread Egg","Yuletide Egg","Infinity Egg"},Callback=function(v)getgenv().ChristmasEggConfig.SelectedEgg=v end})ChristmasSection:CreateToggle("AutoHatchChristmas",{Title="Auto Hatch (Christmas)",Default=false,Callback=function(v)getgenv().ChristmasEggConfig.AutoHatch=v if v then pressE()task.spawn(function()while getgenv().ChristmasEggConfig.AutoHatch do local egg=getgenv().ChristmasEggConfig.SelectedEgg if egg then local eggPos=ChristmasEggs[egg]if eggPos then if not nearEgg(eggPos)and not getgenv().ChristmasConfig.IsBusyWithGift then tpEgg(egg)end end end task.wait(1)end end)end end})local autoGiftThread local Players=game:GetService("Players")local player=Players.LocalPlayer local function activateGiftProperly(activationModel)local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")if not root then return end local touchPart=activationModel:FindFirstChild("Root")or activationModel:FindFirstChild("Ring")if not touchPart then return end firetouchinterest(root,touchPart,0)task.wait(0.05)firetouchinterest(root,touchPart,1)end local function visitGift(gift)local char=player.Character if not char then return end local root=char:FindFirstChild("HumanoidRootPart")if not root then return end local activation=gift:FindFirstChild("Activation")if not activation then return end local goal=activation:FindFirstChild("Root")or activation:FindFirstChild("Ring")if not goal then return end getgenv().ChristmasConfig.IsBusyWithGift=true while player:GetAttribute("GiveGiftsFreeze")do task.wait(0.1)end root.AssemblyLinearVelocity=Vector3.zero root.CFrame=CFrame.new(goal.Position+Vector3.new(0,2.5,0))task.wait(0.2)activateGiftProperly(activation)local timeout=10 while timeout>0 and player:GetAttribute("GiveGiftsFreeze")do timeout-=0.1 task.wait(0.1)end end ChristmasSection:CreateToggle("AutoGiveGifts",{Title="Auto Give Gifts",Default=false,Callback=function(v)getgenv().ChristmasConfig.AutoGiveGifts=v if v then autoGiftThread=task.spawn(function()local giftsFolder=workspace.Worlds["Christmas World"]:WaitForChild("GiveGifts")while getgenv().ChristmasConfig.AutoGiveGifts do for _,gift in ipairs(giftsFolder:GetChildren())do if not getgenv().ChristmasConfig.AutoGiveGifts then break end if gift:FindFirstChild("Activation")then visitGift(gift)local egg=getgenv().ChristmasEggConfig.SelectedEgg if egg and ChristmasEggs[egg]then tpEgg(egg)end task.wait(5)getgenv().ChristmasConfig.IsBusyWithGift=false end task.wait(0.3)end end end)else if autoGiftThread then task.cancel(autoGiftThread)autoGiftThread=nil end end end})local autoAdventThread local function now()return os.time()end local AdventCalender={START_TIME=os.time({year=2025,month=12,day=5,hour=0,min=0,sec=0}),TOTAL_DAYS=21,GetDayIndex=function(self)local daysPassed=math.floor((now()-self.START_TIME)/86400)+1 return math.min(math.max(daysPassed,1),self.TOTAL_DAYS)end,GetTimeUntilIndex=function(self,index)local targetTime=self.START_TIME+(index-1)*86400 return math.max(targetTime-now(),0)end}local function claimAdvent()local args={"ClaimAdventCalender"}pcall(function()RemoteEvent:FireServer(unpack(args))end)end ChristmasSection:CreateToggle("AutoClaimAdvent",{Title="Auto Claim Advent Calendar",Default=false,Callback=function(v)getgenv().ChristmasConfig.AutoClaimAdvent=v if v then autoAdventThread=task.spawn(function()while getgenv().ChristmasConfig.AutoClaimAdvent do local currentDay=AdventCalender:GetDayIndex()claimAdvent()local waitTime=AdventCalender:GetTimeUntilIndex(currentDay+1)task.wait(waitTime)end end)else if autoAdventThread then task.cancel(autoAdventThread)autoAdventThread=nil end end end})local autoPresentRainThread local Players=game:GetService("Players")local player=Players.LocalPlayer local function touch(part)local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")if not root or not part then return end firetouchinterest(root,part,0)task.wait(0.05)firetouchinterest(root,part,1)end ChristmasSection:CreateToggle("AutoCollectPresentRain",{Title="Auto Collect Present Rain",Default=false,Callback=function(v)getgenv().ChristmasConfig.AutoCollectPresentRain=v if v then autoPresentRainThread=task.spawn(function()local presentRainFolder=workspace:WaitForChild("Rendered"):WaitForChild("PresentRain")while getgenv().ChristmasConfig.AutoCollectPresentRain do for _,drop in ipairs(presentRainFolder:GetChildren())do for _,gift in ipairs(drop:GetChildren())do if not getgenv().ChristmasConfig.AutoCollectPresentRain then break end if gift:IsA("BasePart")and gift:FindFirstChild("TouchInterest")then touch(gift)end end end task.wait(1)end end)else if autoPresentRainThread then task.cancel(autoPresentRainThread)autoPresentRainThread=nil end end end})

-- FARMING
local FarmingSection = Tabs.Farming:CreateSection("▶ Farming")

FarmingSection:CreateToggle("AutoPickupToggle", {
    Title = "Auto Pickup Nearest",
    Default = false,
    Callback = function(enabled)
        getgenv().FarmingConfig.AutoPickup = enabled

        local player = game.Players.LocalPlayer
        local collectRemote = game.ReplicatedStorage.Remotes.Pickups.CollectPickup

        local function collectPickup(obj)
            if not obj or not obj:IsDescendantOf(workspace) then return end
            if string.find(obj.Name:lower(), "egg") then return end

            local basePart = obj:FindFirstChildWhichIsA("BasePart")
            if basePart then
                pcall(function()
                    collectRemote:FireServer(obj.Name)
                end)
                if obj.Parent and obj.Parent ~= nil then
                    pcall(function()
                        obj:Destroy()
                    end)
                end
            end
        end

        local function scanRendered()
            local rendered = workspace:FindFirstChild("Rendered")
            if not rendered then return end

            local pickupsFolder = rendered:GetChildren()[14]
            if pickupsFolder then
                for _, pickup in ipairs(pickupsFolder:GetDescendants()) do
                    if pickup:IsA("Model") or pickup:IsA("Folder") then
                        collectPickup(pickup)
                    end
                end
            end
        end

        local function scanStages()
            local stages = workspace:FindFirstChild("Stages")
            if not stages then return end

            for _, stage in ipairs(stages:GetChildren()) do
                local pickups = stage:FindFirstChild("Pickups")
                if pickups then
                    for _, pickup in ipairs(pickups:GetDescendants()) do
                        if pickup:IsA("Model") or pickup:IsA("Folder") then
                            collectPickup(pickup)
                        end
                    end
                end
            end
        end

        -- Auto loop
        if enabled then
            task.spawn(function()
                while getgenv().FarmingConfig.AutoPickup do
                    pcall(scanRendered)
                    pcall(scanStages)
                    task.wait(0.5)
                end
            end)
        end
    end
})

FarmingSection:CreateToggle("AutoGoldenOrbToggle",{Title="Auto Golden Orb",Default=false,Callback=function(v)getgenv().FarmingConfig.AutoGoldenOrb=v if v then task.spawn(function() while getgenv().FarmingConfig.AutoGoldenOrb do pcall(function() RemoteEvent:FireServer("UseGoldenOrb") end) task.wait(0.1) end end) end end})
FarmingSection:CreateToggle("AutoBubbleToggle",{Title="Auto Bubble",Default=false,Callback=function(v)getgenv().FarmingConfig.AutoBubble=v if v then task.spawn(function() while getgenv().FarmingConfig.AutoBubble do pcall(function() RemoteEvent:FireServer("BlowBubble") end) task.wait(0.3) end end) end end})

local SellLocations={["0.1x The Overworld"]=Workspace.Worlds["The Overworld"].Sell,["5x Twilight"]=Workspace.Worlds["The Overworld"].Islands.Twilight.Island.Sell,["0.1x Minigame Paradise"]=Workspace.Worlds["Minigame Paradise"].Sell,["0.2x Robot Factory"]=Workspace.Worlds["Minigame Paradise"].Islands["Robot Factory"].Island.Sell}
FarmingSection:CreateToggle("AutoBubbleSellToggle",{Title="Auto Bubble Sell",Default=false,Callback=function(v)getgenv().FarmingConfig.AutoBubbleSell=v end})
FarmingSection:CreateDropdown("BubbleSellMode",{Title="Bubble Sell Mode",Values={"Timed","Max Capacity"},Default=nil,Callback=function(v)getgenv().FarmingConfig.BubbleSellMode=v end})
FarmingSection:CreateInput("BubbleSellInterval",{Title="Timed Interval (s)",Default="3",Numeric=true,Callback=function(v)getgenv().FarmingConfig.BubbleSellInterval=tonumber(v)or 3 end})
FarmingSection:CreateDropdown("BubbleSellLocation",{Title="Sell Location",Values={"0.1x The Overworld","5x Twilight","0.1x Minigame Paradise","0.2x Robot Factory"},Default=nil,Callback=function(v)getgenv().FarmingConfig.BubbleSellLocation=SellLocations[v] end})

task.spawn(function() while true do task.wait(0.3) local cfg=getgenv().FarmingConfig if cfg.AutoBubbleSell and cfg.BubbleSellLocation then local player=LocalPlayer local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart") if not hrp then continue end local shouldSell=false local pdata=LocalData:Get() if not pdata or not pdata.Bubble then continue end if cfg.BubbleSellMode=="Timed" then if not cfg._lastTimedSell then cfg._lastTimedSell=os.clock() end if os.clock()-cfg._lastTimedSell>=(cfg.BubbleSellInterval or 3) then shouldSell=true;cfg._lastTimedSell=os.clock() end elseif cfg.BubbleSellMode=="Max Capacity" then local gum=pdata.Bubble.Gum local amt=pdata.Bubble.Amount or 0 local cap=0 if gum and GumData[gum] then cap=GumData[gum].Storage or 0 end if amt>=cap then shouldSell=true end end if shouldSell then local target=cfg.BubbleSellLocation local cf if target.PrimaryPart then cf=target.PrimaryPart.CFrame+Vector3.new(0,5,0) else local anyP=target:FindFirstChildWhichIsA("BasePart") if anyP then cf=anyP.CFrame+Vector3.new(0,5,0) end end if cf then hrp.CFrame=cf end task.wait(0.3) RemoteEvent:FireServer("SellBubble") end end end end)

-- FISHING
local FishingSection=Tabs.Farming:CreateSection("▶ Fishing")
FishingSection:CreateToggle("AutoFishingWorld3",{Title="Auto Fishing (World 3)",Default=false,Callback=function(v)getgenv().FarmingConfig.AutoFishing=v if v then task.spawn(function() while getgenv().FarmingConfig.AutoFishing do pcall(function() local AFM=RS.Client.Gui.Frames.Fishing.FishingWorldAutoFish local AFC=require(AFM) AFC.IsEnabled=function()return true end local FUtil=require(RS.Shared.Utils.FishingUtil) FUtil.CAST_TIMEOUT,FUtil.MIN_FISH_BITE_DELAY,FUtil.MAX_FISH_BITE_DELAY,FUtil.BASE_REEL_SPEED,FUtil.BASE_MUTATION_CHANCE,FUtil.BASE_FINISH_WINDOW,FUtil.WALL_CLICK_COOLDOWN=0,0,0,math.huge,math.huge,0,0 local BaitData=require(RS.Shared.Data.FishingBait) local sorted={} for n,b in pairs(BaitData)do table.insert(sorted,{Name=n,Order=b.LayoutOrder}) end table.sort(sorted,function(a,b)return a.Order>b.Order end) local baitInv=(LocalData:Get()or {}).BaitInventory if baitInv then for _,b in ipairs(sorted)do if baitInv[b.Name] and baitInv[b.Name]>0 then if LocalPlayer:GetAttribute("EquippedBait")~=b.Name then RemoteEvent:FireServer("SetEquippedBait",b.Name);task.wait(0.5) end break end end end end) task.wait(1) end end) end end})
-- OBBY
local ObbySection=Tabs.Farming:CreateSection("▶️ Obby")
ObbySection:CreateDropdown("ObbyDifficulties",{Title="Obbies",Values={"Easy","Medium","Hard"},Multi=true,Default={},Callback=function(sel)local n={} for k,v in pairs(sel)do if v then table.insert(n,k) end end getgenv().ObbyConfig.Difficulties=n end})
ObbySection:CreateToggle("AutoObby",{Title="Auto Obby",Default=false,Callback=function(v)getgenv().ObbyConfig.Enabled=v end})
ObbySection:CreateToggle("AutoObbyChest",{Title="Auto Obby Chest",Default=false,Callback=function(v)getgenv().ObbyConfig.AutoChest=v end})
task.spawn(function()
 local C=getgenv().ObbyConfig
 local LP=game:GetService("Players").LocalPlayer
 local RS=game:GetService("ReplicatedStorage")
 local RE=RS.Shared.Framework.Network.Remote.RemoteEvent
 local LD=require(RS.Client.Framework.Services.LocalData)
 local OF=game:GetService("Workspace").Obbys
 local OT=game:GetService("Workspace").Worlds["Seven Seas"].Areas["Classic Island"].Obbys
 local TD=2.5
 local function teleportTo(target)
  if not(C.Enabled and target)then return end
  local char=LP.Character
  if not char then return end
  local cf
  if typeof(target)=="CFrame"then cf=target
  elseif target:IsA("BasePart")then cf=target.CFrame
  elseif target:IsA("Model")then cf=target:GetPivot()end
  if cf then char:PivotTo(cf*CFrame.new(0,3,0))end
 end
 local function run(d)
  if not C.Enabled then return end
  local tpPart=OT:FindFirstChild(d) and OT[d]:FindFirstChild("Portal") and OT[d].Portal:FindFirstChild("Part")
  local cp=OF:FindFirstChild(d) and OF[d]:FindFirstChild("Complete")
  if not tpPart or not cp then return end
  teleportTo(tpPart) task.wait(.5)
  if not C.Enabled then return end
  RE:FireServer("StartObby",d) task.wait(TD)
  if not C.Enabled then return end
  teleportTo(cp) task.wait(.5)
  RE:FireServer("CompleteObby") task.wait(.5)
  if C.AutoChest then
   local s=os.clock()
   while os.clock()-s<30 do
    if not(C.AutoChest and C.Enabled)then break end
    RE:FireServer("ClaimObbyChest")
    task.wait(.7)
   end
  end
 end
 while task.wait(1)do
  if not C.Enabled or #C.Difficulties==0 then continue end
  local char=LP.Character
  local pd=LD:Get()
  if not char or not char.PrimaryPart or not pd or not pd.ObbyCooldowns then continue end
  local ip=char.PrimaryPart.CFrame
  local comp=false
  for _,d in ipairs(C.Difficulties)do
   if not C.Enabled then break end
   local cd=pd.ObbyCooldowns[d]or 0
   if os.time()>=cd then run(d) comp=true task.wait(3) pd=LD:Get() if not pd or not pd.ObbyCooldowns then break end end
  end
  if comp and C.Enabled then teleportTo(ip) end
  pd=LD:Get()
  if not pd or not pd.ObbyCooldowns then continue end
  local nt=math.huge
  for _,d in ipairs(C.Difficulties)do local cd=pd.ObbyCooldowns[d]or 0 if cd>os.time() and cd<nt then nt=cd end end
  if nt~=math.huge then local wt=nt-os.time() if wt>0 then local w=0 while w<wt do if not C.Enabled then break end task.wait(1) w+=1 end end end
 end
end)
-- MASTERY
local MasterySection=Tabs.Farming:CreateSection("▶ Mastery")
local MD=MasterySection:CreateDropdown("MasterySelect",{Title="Masteries",Description="Select which mastery type to auto-upgrade",Values={"Buffs","Pets","Shops","Minigames","Rifts"},Multi=false,Default="--"})
MD:OnChanged(function(v)getgenv().MasteryConfig.Selected=v end)
local AMT=MasterySection:CreateToggle("AutoMasteryToggle",{Title="Auto Mastery",Default=false,Callback=function(v)getgenv().MasteryConfig.Auto=v if v then task.spawn(function() while getgenv().MasteryConfig.Auto do pcall(function() if getgenv().MasteryConfig.Selected then RemoteEvent:FireServer("UpgradeMastery",getgenv().MasteryConfig.Selected) end end) task.wait(0.5) end end) end end})

local WorldsConfig = {SelectedWorlds = {}, AutoDiscover = false}

local Islands = {
    ["The Overworld"] = {
        {Name="Floating Island", Pos=Vector3.new(-15.604,420.332,143.418)},
        {Name="Outer Space", Pos=Vector3.new(41.752,2661.791,-6.399)},
        {Name="Twilight", Pos=Vector3.new(-77.687,6859.73,88.328)},
        {Name="The Void", Pos=Vector3.new(16.226,10143.327,151.715)},
        {Name="Zen", Pos=Vector3.new(36.547,15969.05,41.872)}
    },
    ["Minigame Paradise"] = {
        {Name="Robot Factory", Pos=Vector3.new(9884.22,13408.58,247.12)},
        {Name="Minecart Forest", Pos=Vector3.new(9889.09,7682.4,245.84)},
        {Name="Dice Island", Pos=Vector3.new(9887.92,2904.9,230.85)},
        {Name="Hyperwave Island", Pos=Vector3.new(9887.63,20086.25,243.42)},
        {Name="Minigame Paradise", Pos=Vector3.new(9981.627,24.574,172.103)}
    }
}

local SevenSeasAreas = {
    ["Fisher's Island"]=Vector3.new(-23660.27,7.21,-72.69),
    ["Blizzard Hills"]=Vector3.new(-21425.127,4.134,-100922.281),
    ["Poison Jungle"]=Vector3.new(-19327.96,11.48,18811.62),
    ["Infernite Volcano"]=Vector3.new(-17239.9,9.56,-20407.03),
    ["Lost Atlantis"]=Vector3.new(-13908.79,5.22,-20334.6),
    ["Dream Island"]=Vector3.new(-21813.14,6.88,-20539.56),
    ["Classic Island"]=Vector3.new(-41517.89,15.96,-20451.51)
}

local AutoDiscoverSection = Tabs.Worlds:CreateSection("▶ Auto Discover")
local WorldDropdown = AutoDiscoverSection:CreateDropdown("WorldSelect", {
    Title="Select Worlds",
    Description="Choose worlds to auto discover",
    Values={"The Overworld","Minigame Paradise"},
    Multi=true,
    Default={}
})
WorldDropdown:OnChanged(function(vals) WorldsConfig.SelectedWorlds = vals end)

local AutoDiscoverToggle = AutoDiscoverSection:CreateToggle("AutoDiscoverIslands", {Title="Auto Discover Islands", Default=false})
AutoDiscoverToggle:OnChanged(function(val)
    WorldsConfig.AutoDiscover = val
    if not val then return end

    local RS = game:GetService("ReplicatedStorage")
    local ok, LocalData = pcall(require, RS.Client.Framework.Services.LocalData)
    if not ok then warn("⚠️ LocalData module missing.") return end

    local function getCoins()
        local d = LocalData:Get()
        return d and d.Coins or 0
    end

    task.spawn(function()
        while WorldsConfig.AutoDiscover do
            for _, world in ipairs(WorldsConfig.SelectedWorlds) do
                if world=="Minigame Paradise" and getCoins()<1e9 then continue end
                local list = Islands[world]
                if world=="Minigame Paradise" then list={list[3],list[2],list[1],list[4]} end
                for _, island in ipairs(list or {}) do
                    if not WorldsConfig.AutoDiscover then break end
                    teleportTo(island.Pos)
                    task.wait(3)
                end
            end
            WorldsConfig.AutoDiscover = false
            AutoDiscoverToggle:SetValue(false)
            break
        end
    end)
end)

local TeleportSection = Tabs.Worlds:CreateSection("▶ Teleport")
local TeleportList = {}
for _,i in pairs(Islands) do for _,v in ipairs(i) do table.insert(TeleportList, v.Name) end end
for n,_ in pairs(SevenSeasAreas) do table.insert(TeleportList, n) end

local TeleportConfig = {Sel = nil}
local TeleportDropdown = TeleportSection:CreateDropdown("TeleportSelect", {
    Title="Teleport",
    Description="Select a location",
    Values=TeleportList,
    Multi=false,
    Default=1
})
TeleportDropdown:OnChanged(function(v) TeleportConfig.Sel = v end)

local TeleportToggle = TeleportSection:CreateToggle("TeleportToggle", {Title="Teleport to World", Default=false})
TeleportToggle:OnChanged(function(v)
    if not v then return end
    local sel = TeleportConfig.Sel
    if not sel then return end

    local pos
    for _,world in pairs(Islands) do
        for _,i in ipairs(world) do
            if i.Name==sel then pos=i.Pos break end
        end
    end
    if not pos and SevenSeasAreas[sel] then pos = SevenSeasAreas[sel] end
    if pos then teleportTo(pos) end
    TeleportToggle:SetValue(false)
end)

local autoPressE=false local EggRiftMap,ChestRiftMap={},{} for id,data in pairs(RiftsModule)do if data.Type=="Egg"then EggRiftMap[id]=data.Egg or data.DisplayName or id elseif data.Type=="Chest"then ChestRiftMap[id]=data.DisplayName or id end end
local teleportedEggs,alreadyTeleported={},{}
local EggsSection=Tabs.RiftsEggs:CreateSection("▶ Eggs")local RS=game:GetService("ReplicatedStorage")local VIM=game:GetService("VirtualInputManager")local LP=game:GetService("Players").LocalPlayer local teleportedEggs,alreadyTeleported={},{} local HatchEggModule=RS:FindFirstChild("Client")and RS.Client:FindFirstChild("Effects")and RS.Client.Effects:FindFirstChild("HatchEgg")and require(RS.Client.Effects.HatchEgg) local oldPlay=HatchEggModule and HatchEggModule.Play or nil if HatchEggModule and oldPlay then HatchEggModule.Play=function(...)if getgenv().RiftsConfig.DisableEggAnim then return end return oldPlay(...) end end local function getEggList()local n,s={},{} local f=workspace:WaitForChild("Rendered"):GetChildren()[13] if f then for _,e in pairs(f:GetChildren())do local name=e.Name if name and not s[name] and not name:find("Coming Soon") then table.insert(n,name)s[name]=true end end end table.sort(n)return n end EggsSection:CreateDropdown("EggSelect",{Title="Eggs",Values=getEggList(),Default=nil,Callback=function(v)getgenv().RiftsConfig.SelectedEgg=v teleportedEggs[v]=false end}) local disT=EggsSection:CreateToggle("DisableEggAnim",{Title="Disable Egg Animation",Default=false}) disT:OnChanged(function(v)getgenv().RiftsConfig.DisableEggAnim=v end) local function teleportToEgg(e)local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if not hrp then return end local rendered=workspace:WaitForChild("Rendered"):GetChildren()[13] if not rendered then return end local eggModel=rendered:FindFirstChild(e) if not eggModel then return end local safePoint local deco=eggModel:FindFirstChild("Decoration") if deco and deco:FindFirstChild("Primary") then local primary=deco.Primary local g=primary:GetChildren()[9] if g and g:IsA("BasePart") then safePoint=g end end if safePoint and not alreadyTeleported[e] then hrp.CFrame=safePoint.CFrame+Vector3.new(0,3,0) teleportedEggs[e]=true alreadyTeleported[e]=true end getgenv().RiftsConfig.LastPosition=hrp.CFrame end EggsSection:CreateToggle("TeleportSummonedEgg",{Title="Teleport to Summoned Egg",Default=false,Callback=function(v)getgenv().RiftsConfig.TeleportSummonedEgg=v if v then task.spawn(function() local wasSummoned=false while getgenv().RiftsConfig.TeleportSummonedEgg do local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") local summoned=workspace:FindFirstChild("SummonedEgg") local selectedEgg=getgenv().RiftsConfig.SelectedEgg if summoned and summoned:FindFirstChild("EggPlatformSpawn") then wasSummoned=true if not alreadyTeleported["SummonedEgg"] then local p=summoned.EggPlatformSpawn.PrimaryPart or summoned.EggPlatformSpawn:FindFirstChildWhichIsA("BasePart") if p and hrp then hrp.CFrame=p.CFrame+Vector3.new(0,3,0) alreadyTeleported["SummonedEgg"]=true alreadyTeleported[selectedEgg]=false end end elseif wasSummoned then wasSummoned=false alreadyTeleported["SummonedEgg"]=false if selectedEgg then teleportToEgg(selectedEgg) end end task.wait(1) end end) end end}) EggsSection:CreateToggle("AutoHatchEggs",{Title="Auto Hatch",Default=false,Callback=function(v)getgenv().RiftsConfig.AutoHatch=v if v then getgenv().autoPressE=true task.spawn(function() while getgenv().autoPressE do VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game) task.wait() VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game) task.wait() end end) task.spawn(function() while getgenv().RiftsConfig.AutoHatch do local egg=getgenv().RiftsConfig.SelectedEgg if egg and (not getgenv().RiftsConfig.TeleportSummonedEgg or not workspace:FindFirstChild("SummonedEgg")) then teleportToEgg(egg) end task.wait(1.5) end end) else getgenv().autoPressE=false end end})
local RiftsSection=Tabs.RiftsEggs:CreateSection("▶ Rifts") RiftsSection:CreateDropdown("EggRiftSelect",{Title="Egg Rifts",Values=(function()local t={}for _,v in pairs(EggRiftMap)do table.insert(t,v)end table.sort(t)return t end)(),Multi=false,Default=nil,Callback=function(v)for k,val in pairs(EggRiftMap)do if val==v then getgenv().RiftsConfig.SelectedEggRift=k break end end end}) RiftsSection:CreateDropdown("IgnoreMultiplier",{Title="Ignore Egg Rift Multipliers",Values={1,2,5,10,15,20,25},Multi=true,Default={},Callback=function(vals)local s={}for k,v in pairs(vals)do if v==true then local num=tonumber(k)if num then s[num]=true end end end getgenv().RiftsConfig.IgnoreMultiplier=s end}) RiftsSection:CreateToggle("TeleportEggRiftToggle",{Title="Teleport to Egg Rift",Default=false,Callback=function(v)getgenv().RiftsConfig.TeleportEggRift=v autoPressE=v if v then task.spawn(function()while autoPressE do VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game) task.wait() VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game) task.wait() end end) end end}) RiftsSection:CreateDropdown("ChestRiftSelect",{Title="Chest Rifts",Values=(function()local t={}for _,v in pairs(ChestRiftMap)do table.insert(t,v)end table.sort(t)return t end)(),Multi=false,Default=nil,Callback=function(v)for k,val in pairs(ChestRiftMap)do if val==v then getgenv().RiftsConfig.SelectedChestRift=k break end end end}) RiftsSection:CreateToggle("TeleportChestRiftToggle",{Title="Teleport to Chest Rift",Default=false,Callback=function(v)getgenv().RiftsConfig.TeleportChestRift=v autoPressE=v if v then task.spawn(function()while autoPressE do VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game) task.wait() VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game) task.wait() end end) end end}) local function getRiftMultiplier(r)for _,d in ipairs(r:GetDescendants())do if d:IsA("TextLabel")or d:IsA("TextBox")then local t=d.Text:lower() local m=t:match("(%d+)%s*x")or t:match("x%s*(%d+)") if m then return tonumber(m)end end end return nil end local function teleportTo(pos)local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if hrp and pos then hrp.CFrame=CFrame.new(pos+Vector3.new(0,5,0))end end local alreadyTeleported={} RunService.Heartbeat:Connect(function() local cfg=getgenv().RiftsConfig for _,r in pairs(workspace:GetDescendants())do if r:IsA("Model")then local id=r:GetDebugId()or(r.Name..game.JobId) if alreadyTeleported[id]then continue end if cfg.TeleportEggRift and cfg.SelectedEggRift and r.Name==cfg.SelectedEggRift then local platform=r:FindFirstChild("EggPlatformSpawn") if platform then local part=platform.PrimaryPart or platform:FindFirstChildWhichIsA("BasePart") if part then local m=getRiftMultiplier(r) if not m or not cfg.IgnoreMultiplier[m]then teleportTo(part.Position) alreadyTeleported[id]=true end end end end if cfg.TeleportChestRift and cfg.SelectedChestRift and r.Name==cfg.SelectedChestRift then local part=r.PrimaryPart or r:FindFirstChildWhichIsA("BasePart") if part then teleportTo(part.Position) alreadyTeleported[id]=true end end end end end)

-- pets
local EnchantSection=Tabs.Pets:CreateSection("▶️ Pet Enchant")local enchantOptions={"Anything"}for a,b in pairs(EnchantsModule)do local c=b.DisplayName or a local d=b.Emoji or""local e=b.Levels or 1 if e>1 then for i=1,e do table.insert(enchantOptions,string.format("%s %d %s",c,i,d))end else table.insert(enchantOptions,string.format("%s %s",c,d))end end table.sort(enchantOptions)local Slot1Dropdown=EnchantSection:CreateDropdown("EnchantSlot1",{Title="Enchant for Slot 1",Multi=false,Values=enchantOptions,Default="Anything"})Slot1Dropdown:OnChanged(function(f)getgenv().EnchantConfig.Slot1=f end)local Slot2Dropdown=EnchantSection:CreateDropdown("EnchantSlot2",{Title="Enchant for Slot 2",Multi=false,Values=enchantOptions,Default="Anything"})Slot2Dropdown:OnChanged(function(f)getgenv().EnchantConfig.Slot2=f end)local MethodDropdown=EnchantSection:CreateDropdown("EnchantMethod",{Title="Method",Multi=false,Values={"Gems Only","Orbs Only","Gems First Orbs Second","Shadow Crystal First Orbs Second","Shadow Crystal Only"},Default="Gems Only"})MethodDropdown:OnChanged(function(f)getgenv().EnchantConfig.EnchantMethod=f end)local function g()local h={}local i=LocalData:Get()if i and i.Teams then for j,_ in pairs(i.Teams)do table.insert(h,"Team "..j)end end return h end local TeamsDropdown=EnchantSection:CreateDropdown("TeamsList",{Title="Teams",Multi=false,Values=g(),Default="--"})TeamsDropdown:OnChanged(function(k)local l;if type(k)=="table"then for m,n in pairs(k)do if n then l=tonumber(string.match(m,"%d+"))break end end else l=tonumber(string.match(k,"%d+"))end;if l then getgenv().EnchantConfig.SelectedTeam=l end end)local AutoToggle=EnchantSection:CreateToggle("AutoEnchantToggle",{Title="Auto Enchant",Default=false})AutoToggle:OnChanged(function(f)getgenv().EnchantConfig.AutoEnchantActive=f end)
local DeleteSection=Tabs.Pets:CreateSection("▶️ Auto Delete Pets")local RarityDropdown=DeleteSection:CreateDropdown("PetRarities",{Title="Rarities",Multi=true,Values={"Common","Unique","Rare","Epic","Legendary Tier 1","Legendary Tier 2","Legendary Tier 3"},Default={}})RarityDropdown:OnChanged(function(v)getgenv().PetsConfig.SelectedDeleteRarities={}for r,s in pairs(v)do if s then getgenv().PetsConfig.SelectedDeleteRarities[r]=true end end end)local uniqueTags={}for _,d in pairs(petsModule)do if type(d)=="table"and d.Tag and d.Tag~=""then uniqueTags[d.Tag]=true end end local tagList={}for t in pairs(uniqueTags)do table.insert(tagList,t)end table.sort(tagList)local IgnoreTagsDropdown=DeleteSection:CreateDropdown("IgnoreTags",{Title="Ignore Tags",Multi=true,Values=tagList,Default={}})IgnoreTagsDropdown:OnChanged(function(v)getgenv().PetsConfig.IgnoreTags={}for t,s in pairs(v)do if s then getgenv().PetsConfig.IgnoreTags[t]=true end end end)local DeleteToggle=DeleteSection:CreateToggle("AutoDeletePets",{Title="Delete Pets",Default=false})DeleteToggle:OnChanged(function(state)getgenv().PetsConfig.AutoDelete=state;if not state then return end;task.spawn(function()while getgenv().PetsConfig.AutoDelete do local pets=playerData.Pets;for _,pet in pairs(pets)do local info=petsModule[pet.Name]if info then local r=info.Rarity or"Unknown"local tier=info.Tier and("Legendary Tier "..tostring(info.Tier))or nil local amt=pet.Amount or 1 if info.Tag and getgenv().PetsConfig.IgnoreTags[info.Tag]then continue end local shouldDelete=false;if getgenv().PetsConfig.SelectedDeleteRarities[r]then shouldDelete=true elseif r=="Legendary"and tier and getgenv().PetsConfig.SelectedDeleteRarities[tier]then shouldDelete=true end;if shouldDelete then local args={"DeletePet",pet.Id,amt,false}RS.Shared.Framework.Network.Remote.RemoteEvent:FireServer(unpack(args))task.wait(0.15)end end end task.wait(3)end end)end)
local ShinySection=Tabs.Pets:CreateSection("▶️ Auto Shiny Pets")local ShinyRarityDropdown=ShinySection:CreateDropdown("ShinyRarities",{Title="Rarities",Multi=true,Values={"Common","Unique","Rare","Epic","Legendary Tier 1","Legendary Tier 2","Legendary Tier 3","Secret"},Default={}})ShinyRarityDropdown:OnChanged(function(v)getgenv().PetsConfig.SelectedShinyRarities={}for r,s in pairs(v)do if s then getgenv().PetsConfig.SelectedShinyRarities[r]=true end end end)local ShinyIgnoreTagsDropdown=ShinySection:CreateDropdown("IgnoreTags",{Title="Ignore Tags",Multi=true,Values=tagList,Default={}})ShinyIgnoreTagsDropdown:OnChanged(function(v)getgenv().PetsConfig.IgnoreTags={}for t,s in pairs(v)do if s then getgenv().PetsConfig.IgnoreTags[t]=true end end end)local ShinyToggle=ShinySection:CreateToggle("AutoShiny",{Title="Auto Shiny",Default=false})ShinyToggle:OnChanged(function(state)getgenv().PetsConfig.AutoShiny=state;if not state then return end;task.spawn(function()while getgenv().PetsConfig.AutoShiny do local pets=playerData.Pets;table.sort(pets,function(a,b)return(a.Amount or 0)>(b.Amount or 0)end)for _,pet in pairs(pets)do local info=petsModule[pet.Name]if info then local r=info.Rarity or"Unknown"local tier=info.Tier and("Legendary Tier "..tostring(info.Tier))or nil local tag=info.Tag;if tag and getgenv().PetsConfig.IgnoreTags[tag]then continue end local shouldShiny=false;if getgenv().PetsConfig.SelectedShinyRarities[r]then shouldShiny=true elseif r=="Legendary"and tier and getgenv().PetsConfig.SelectedShinyRarities[tier]then shouldShiny=true end;if shouldShiny then local args={"MakePetShiny",pet.Id,math.min(pet.Amount or 1,1)}RS.Shared.Framework.Network.Remote.RemoteEvent:FireServer(unpack(args))task.wait(0.2)end end end task.wait(3)end end)end)
local OtherSection=Tabs.Pets:CreateSection("▶️ Power Orb")
local AutoPowerOrbToggle=OtherSection:CreateToggle("AutoPowerOrbToggle",{Title="Auto Power Orb to Equipped Team",Default=false})
AutoPowerOrbToggle:OnChanged(function(v)getgenv().EnchantConfig.AutoPowerOrbActive=v end)
task.spawn(function()while true do task.wait(0.5)if not getgenv().EnchantConfig.AutoPowerOrbActive then continue end local d=LocalData:Get()if not(d and d.Teams)then continue end local tI=getgenv().EnchantConfig.SelectedTeam or d.TeamEquipped local t=tI and d.Teams[tI]if not t or not t.Pets then continue end for _,pId in ipairs(t.Pets)do if not getgenv().EnchantConfig.AutoPowerOrbActive then break end task.spawn(function()pcall(function()RemoteEvent:FireServer("UsePowerOrb",pId)end)end)task.wait(0.1)end end end)
local function findPetById(id)local d=LocalData:Get()if not(d and d.Pets)then return nil end;for _,p in ipairs(d.Pets)do if p.Id==id then return p end end;return nil end;local function slotHasDesired(p,s,d)if d=="Anything"then return(p.Enchants and p.Enchants[s]~=nil)end;local e=(p.Enchants or{})[s]if not e then return false end;local i=EnchantsModule[e.Id]if not i then return false end;local n=i.DisplayName or e.Id local l=e.Level or 1 local emoji=i.Emoji or""local str=(i.Levels>1)and string.format("%s %d %s",n,l,emoji)or string.format("%s %s",n,emoji)return str==d end;local function petHasDesiredEnchantSlot(p,s)local m=getgenv().EnchantConfig.EnchantMethod local s1=getgenv().EnchantConfig.Slot1 local s2=getgenv().EnchantConfig.Slot2 if m=="Gems Only"or m=="Orbs Only"or m=="Shadow Crystal Only"then if s1==s2 then local ts=(p.Shiny or p.ShinyMythic)and 2 or 1 for i=1,ts do if slotHasDesired(p,i,s1)then return true end end;return false end end;if s==1 then return slotHasDesired(p,1,s1)else return slotHasDesired(p,2,s2)end end;task.spawn(function()while task.wait(0.5)do if not getgenv().EnchantConfig.AutoEnchantActive then continue end;local d=LocalData:Get()if not(d and d.Teams)then continue end;local tI=getgenv().EnchantConfig.SelectedTeam or d.TeamEquipped local t=tI and d.Teams[tI]if not t or not t.Pets then continue end;for _,pId in ipairs(t.Pets)do if not getgenv().EnchantConfig.AutoEnchantActive then break end;local p=findPetById(pId)if not p then continue end;local ts=(p.Shiny or p.ShinyMythic)and 2 or 1 local st={}for i=1,ts do st[i]=petHasDesiredEnchantSlot(p,i)end;for _=1,ts do if not getgenv().EnchantConfig.AutoEnchantActive then break end;local tg=nil for i=1,ts do if not st[i]then tg=i break end end;if not tg then break end;local a=0 while getgenv().EnchantConfig.AutoEnchantActive and not petHasDesiredEnchantSlot(p,tg)do local m=getgenv().EnchantConfig.EnchantMethod;if m=="Gems Only"then if tg==1 then RemoteFunction:InvokeServer("RerollEnchants",pId,"Gems")else RemoteFunction:InvokeServer("RerollEnchants",pId,"Gems",1)end elseif m=="Orbs Only"then if tg==1 then RemoteEvent:FireServer("RerollEnchant",pId,1)elseif tg==2 and ts==2 then RemoteEvent:FireServer("RerollEnchant",pId,2)end elseif m=="Gems First Orbs Second"then if tg==1 then RemoteFunction:InvokeServer("RerollEnchants",pId,"Gems")else RemoteEvent:FireServer("RerollEnchant",pId,tg)end elseif m=="Shadow Crystal First Orbs Second"then if tg==1 then local ok=pcall(function()RemoteEvent:FireServer("UseShadowCrystal",pId)end)if not ok then RemoteFunction:InvokeServer("RerollEnchants",pId,"Orbs")end else RemoteEvent:FireServer("RerollEnchant",pId,tg)end elseif m=="Shadow Crystal Only"then if tg==1 then RemoteEvent:FireServer("UseShadowCrystal",pId)else RemoteEvent:FireServer("UseShadowCrystal",pId,1)end end;for _=1,math.floor(COOLDOWN_BETWEEN_REROLLS*10)do if not getgenv().EnchantConfig.AutoEnchantActive then break end;task.wait(0.1)end;if not getgenv().EnchantConfig.AutoEnchantActive then break end;p=findPetById(pId)a+=1 if a>=100000 then break end end;if not getgenv().EnchantConfig.AutoEnchantActive then break end;st[tg]=true end end end end)
-- shops
local cfg=getgenv().ShopsConfig or{}local function tableToString(t)if type(t)~="table"then return tostring(t)end local r={}for k,v in pairs(t)do local key=tostring(k)local value if type(v)=="table"then value=tableToString(v)else value=tostring(v)end table.insert(r,key.."="..value)end return "{"..table.concat(r,",").."}"end ShopsSection=Tabs.Shops:CreateSection("▶️ Shops & Items")ShopsSection:AddToggle("BuyAllItems",{Title="Buy All",Default=cfg.BuyAll or false,Callback=function(v)cfg.BuyAll=v end})for shopName,shopInfo in pairs(ShopsData)do local section=Tabs.Shops:AddSection("▶ "..shopName)local itemList={} local function extractItems(tbl)if not tbl then return end for _,v in pairs(tbl)do if type(v)=="table"then if v.Product and v.Product.Name then local name,lvl=v.Product.Name,v.Product.Level or 1 if table.find({"Speed","Lucky","Mythic","Coins","Tickets"},name)then itemList[name.." "..lvl]=true else itemList[name]=true end else extractItems(v)end end end end extractItems(shopInfo) local dropdownItems={}for k in pairs(itemList)do table.insert(dropdownItems,k)end table.sort(dropdownItems) section:AddDropdown(shopName.."Dropdown",{Title="Select Items",Values=dropdownItems,Multi=true,Default=cfg[shopName.."SelectedItems"] or {},Callback=function(v)local selected={}for k,state in pairs(v)do if state then table.insert(selected,k)end end cfg[shopName.."SelectedItems"]=selected end}) section:AddToggle(shopName.."AutoBuy",{Title="Auto Buy",Default=cfg[shopName.."AutoBuy"] or false,Callback=function(v)cfg[shopName.."AutoBuy"]=v end}) section:AddToggle(shopName.."AutoReroll",{Title="Auto Reroll",Default=cfg[shopName.."AutoReroll"] or false,Callback=function(v)cfg[shopName.."AutoReroll"]=v end})end local function buyShopItem(shopName,index,all)pcall(function()RemoteEvent:FireServer("BuyShopItem",shopName,index,all)end)end local function checkShop(shopName)local playerData=LocalData:Get()if not playerData then return end local shopInfo=playerData.Shops[shopName] or {Bought={}}local itemsData,stockData=ShopUtil:GetItemsData(shopName,playerData,playerData,playerData)local selected=cfg[shopName.."SelectedItems"] or {} for i,item in ipairs(itemsData)do if item and item.Product then local name=item.Product.Name local lvl=item.Product.Level or 1 local baseStock=stockData[i] or 0 local bought=shopInfo.Bought[i] or 0 local remaining=math.max(baseStock-bought,0) local isSelected=false for _,sel in ipairs(selected)do local E,F=sel:match("^(.-) (%d+)$") F=F and tonumber(F) or nil if(E and E==name and F==lvl)or(not E and sel==name)then isSelected=true break end end if isSelected and remaining>0 and cfg[shopName.."AutoBuy"]then if cfg.BuyAll then buyShopItem(shopName,i,true)else local count=0 while count<remaining and cfg[shopName.."AutoBuy"]do buyShopItem(shopName,i,false)count+=1 remaining-=1 task.wait(0.1)end end end end end end task.spawn(function()while true do for shopName,_ in pairs(ShopsData)do if cfg[shopName.."AutoBuy"]then checkShop(shopName)end end task.wait(0.2)end end) task.spawn(function()while true do for shopName,_ in pairs(ShopsData)do if cfg[shopName.."AutoReroll"]then pcall(function()RemoteEvent:FireServer("ShopFreeReroll",shopName)end)end end task.wait(0.5)end end) RemoteEvent.OnClientEvent:Connect(function(eventName,...)if eventName=="ItemsReceived"or eventName=="ShopsRestocked"then end end)
local K=Tabs.Shops:CreateSection("▶️ Gum Shop")local L=RS.Shared.Framework.Network.Remote.RemoteEvent;local M={SelectedType=nil,AutoBuy=false,AutoEquip=false}local N;local function O(P,Q)local R,S;Q=Q or{}for T,U in pairs(P)do local V=true;if U.Cost and type(U.Cost)=="table"and U.Cost.Type=="Currency"then local W=Q[U.Cost.Currency]or 0;V=W>=(U.Cost.Amount or 0)end;if V then local X=U.Storage or U.Bubbles or 0;if not S or X>S then R,S=T,X end end end;return R,S end;local function Y(P,Z)local R,S;for T in pairs(Z or{})do local U=P[T]if U then local X=U.Storage or U.Bubbles or 0;if not S or X>S then R,S=T,X end end end;return R,S end;local function _ (a0)local a1=LocalData:Get()if not a1 or not M.SelectedType then return end;local a2=O(a0,a1)local a3=Y(a0,a1[M.SelectedType=="Gum"and"Gum"or"Flavors"])if M.AutoBuy and a2 and not a1[M.SelectedType=="Gum"and"Gum"or"Flavors"][a2]then pcall(function()L:FireServer("GumShopPurchase",a2)end)end;if M.AutoEquip and a3 then local a4=M.SelectedType=="Gum"and"Bubble.Gum"or"Bubble.Flavor"if(a4=="Bubble.Gum"and a1.Bubble.Gum~=a3)or(a4=="Bubble.Flavor"and a1.Bubble.Flavor~=a3)then local a5=M.SelectedType=="Gum"and"UpdateStorage"or"UpdateFlavor"pcall(function()L:FireServer(a5,a3)end)end end end;local function a6(a0)if N then N:Disconnect()end;N=game:GetService("RunService").Heartbeat:Connect(function()pcall(_,a0)end)end;K:AddDropdown("GumType",{Title="Gum Store Items",Values={"Gum","Flavors"},Multi=false,Default=nil,Callback=function(a7)M.SelectedType=a7;local a0=require(RS.Shared.Data[a7])a6(a0)end})K:AddToggle("AutoBuyBest",{Title="Auto Buy Best",Default=false,Callback=function(a8)M.AutoBuy=a8 end})K:AddToggle("AutoEquipBest",{Title="Auto Equip Best",Default=false,Callback=function(a8)M.AutoEquip=a8 end})

local PotionList, PotionMap={},{};for n,i in pairs(PotionsModule)do if i.OneLevel then table.insert(PotionList,n.." 1")PotionMap[n.." 1"]={Name=n,Level=1}else local m=0;if i.CraftingCosts then m=#i.CraftingCosts elseif i.Buff and i.Buff.Expiry then m=#i.Buff.Expiry end;m=math.max(m,1)for l=1,m do local f=n.." "..l;table.insert(PotionList,f)PotionMap[f]={Name=n,Level=l}end end end;table.sort(PotionList)local function createDropdown(s,t,c)return s:AddDropdown(t,{Title=t,Values=PotionList,Multi=false,Default=nil,Callback=c})end;local function createToggle(s,t,c)return s:AddToggle(t,{Title=t,Default=false,Callback=c})end;local UseSection=Tabs.Potions:CreateSection("▶️ Use Potions")createDropdown(UseSection,"Potions",function(v)local d=PotionMap[v]if d then getgenv().PotionsConfig.SelectedUsePotion=d.Name;getgenv().PotionsConfig.SelectedUsePotionLevel=d.Level end end)createToggle(UseSection,"Use Potions",function(v)getgenv().PotionsConfig.UsePotions=v end)task.spawn(function()while true do if getgenv().PotionsConfig.UsePotions and getgenv().PotionsConfig.SelectedUsePotion then pcall(function()RemoteEvent:FireServer("UsePotion",getgenv().PotionsConfig.SelectedUsePotion,getgenv().PotionsConfig.SelectedUsePotionLevel)end)end;task.wait(0.5)end end)local CraftSection=Tabs.Potions:CreateSection("▶️ Craft Potions")createDropdown(CraftSection,"Potions",function(v)local d=PotionMap[v]if d then getgenv().PotionsConfig.SelectedCraftPotion=d.Name;getgenv().PotionsConfig.SelectedCraftPotionLevel=d.Level end end)createToggle(CraftSection,"Craft Potions",function(v)getgenv().PotionsConfig.CraftPotions=v end)task.spawn(function()while true do if getgenv().PotionsConfig.CraftPotions and getgenv().PotionsConfig.SelectedCraftPotion then pcall(function()RemoteEvent:FireServer("CraftPotion",getgenv().PotionsConfig.SelectedCraftPotion,getgenv().PotionsConfig.SelectedCraftPotionLevel,false)end)end;task.wait(0.5)end end)

-- minigames
local a={}for _,b in ipairs(BoardUtil.Nodes)do if b.Type then a[b.Type]=a[b.Type]or{}table.insert(a[b.Type],b)end end local c={}for d,_ in pairs(a)do table.insert(c,d)end table.sort(c)local DiceSection=Tabs.Minigames:CreateSection("▶️ Dice Board")local TargetDropdown=DiceSection:CreateDropdown("TargetBoardTiles",{Title="Target Board Tiles",Multi=true,Values=c,Default={}})TargetDropdown:OnChanged(function(e)local f={}for g,h in pairs(e)do if h then table.insert(f,g)end end getgenv().selectedTileTypes=f end)local RangeInput=DiceSection:CreateInput("GoldenDiceRange",{Title="Golden Dice Range",Default=tostring(getgenv().boardSettings.GoldenDiceDistance),Numeric=true,Finished=true})RangeInput:OnChanged(function(i)local j=tonumber(i)if j and j>0 then getgenv().boardSettings.GoldenDiceDistance=j end end)local AutoRollToggle=DiceSection:CreateToggle("AutoDiceRoll",{Title="Auto Dice Roll",Default=false})AutoRollToggle:OnChanged(function(k)getgenv().autoRoll=k end)local function safeData()local l,m=pcall(function()return LocalData:Get()end)if l and m then return m end return{}end local function getGoldenCount()local n=safeData()if type(n.Powerups)=="table"then return n.Powerups["Golden Dice"]or 0 end return 0 end local function stepsToNode(o,p)if not o or not o.Index then return nil end local q=#BoardUtil.Nodes local r=o.Index for s=1,q do local t=(r+s-1)%q+1 if BoardUtil.Nodes[t]==p then return s end end return nil end local function simulateRolls(o,u)local v=BoardUtil.Dice[u]or 6 local w={}for x=1,v do local y=(o.Index+x-1)%#BoardUtil.Nodes+1 table.insert(w,y)end return w end local function pickDice(o)if not o then return"Dice"end local z=getGoldenCount()local f=getgenv().selectedTileTypes or{}if z<=0 or #f==0 then return"Dice"end local A=math.huge local B=nil for _,C in ipairs(f)do for _,p in ipairs(a[C]or{})do local D=stepsToNode(o,p)if D and D<A then A=D B=p end end end if not B then return"Dice"end if A==getgenv().boardSettings.GoldenDiceDistance then return"Golden Dice"end return"Dice"end local function rollDice(E)if not E then return end local l,F=pcall(function()return RemoteFunction:InvokeServer("RollDice",E)end)if l then return F end return nil end local function claimTile()pcall(function()RemoteEvent:FireServer("ClaimTile")end)end task.spawn(function()while true do if getgenv().autoRoll then local o=Board.Pieces and Board.Pieces[LocalPlayer.Name]if o then local E=pickDice(o)local F=rollDice(E)if F then local G=F.Tile and F.Tile.Index or F.Index or(type(F)=="number"and F)if G then o.Index=G claimTile()end end end end task.wait(1)end end)

local minigames={};for name,_ in pairs(minigamesModule)do table.insert(minigames,name)end;table.sort(minigames)local difficulties={"Easy","Medium","Hard","Insane"}local a=Tabs.Minigames:CreateSection("▶ Minigames")local b=a:CreateDropdown("SelectDifficulty",{Title="Select Minigame Difficulty",Description="Choose the difficulty",Values=difficulties,Multi=false,Default=MinigamesConfig.SelectedDifficulty or "",Callback=function(c)MinigamesConfig.SelectedDifficulty=c end})local d=a:CreateDropdown("SuperTicketSelect",{Title="Select Minigame To Use Super Ticket",Description="Choose which minigame to use",Values=minigames,Multi=false,Default=MinigamesConfig.SuperTicketGame or "",Callback=function(c)MinigamesConfig.SuperTicketGame=c end})local function e(...)local args={...}pcall(function()RemoteEvent:FireServer(unpack(args))end)end

local function g(minigame,difficulty)
    if MinigamesConfig.AutoRun[minigame] and MinigamesConfig.AutoRun[minigame][difficulty] then return end
    MinigamesConfig.AutoRun[minigame]=MinigamesConfig.AutoRun[minigame] or {}
    MinigamesConfig.AutoRun[minigame][difficulty]=true
    task.spawn(function()
        while MinigamesConfig.AutoRun[minigame][difficulty] do
            RemoteEvent:FireServer("StartMinigame",minigame,difficulty)
            task.wait(3)
            RemoteEvent:FireServer("FinishMinigame")
            task.wait(2)
            if MinigamesConfig.SuperTicketGame==minigame then
                RemoteEvent:FireServer("SkipMinigameCooldown",minigame)
            end
            task.wait(1.5)
        end
    end)
end

local function j(minigame,difficulty)
    if MinigamesConfig.AutoRun[minigame] then
        MinigamesConfig.AutoRun[minigame][difficulty]=false
    end
end

for _,k in ipairs(minigames)do
    MinigamesConfig.AutoRun[k]=MinigamesConfig.AutoRun[k] or {}
    local l=a:CreateToggle("Auto"..k:gsub(" ",""),{Title="Auto "..k,Default=MinigamesConfig.SelectedDifficulty and MinigamesConfig.AutoRun[k][MinigamesConfig.SelectedDifficulty] or false})
    l:OnChanged(function(enabled)
        local difficulty=MinigamesConfig.SelectedDifficulty
        if not difficulty then return end
        if enabled then g(k,difficulty)else j(k,difficulty)end
    end)
    if MinigamesConfig.SelectedDifficulty and MinigamesConfig.AutoRun[k][MinigamesConfig.SelectedDifficulty] then
        task.spawn(function()g(k,MinigamesConfig.SelectedDifficulty)end)
    end
end

local WS = Tabs.Webhooks:CreateSection("▶ Pet Webhooks")

-- Normal Minimum Chance
WS:CreateInput("NormalMinChance", {
    Title = "Normal Minimum Chance",
    Default = tostring(getgenv().WebhookConfig.NormalMinChance),
    Numeric = true,
    Callback = function(v)
        getgenv().WebhookConfig.NormalMinChance = tonumber(v)
    end
})

-- Use Base Chance
WS:CreateToggle("UseBaseChance", {
    Title = "Use Base Chance",
    Default = getgenv().WebhookConfig.UseBaseChance
}):OnChanged(function(state)
    getgenv().WebhookConfig.UseBaseChance = state
end)

-- Powerups Eggs Minimum Chance
WS:CreateInput("ExclusiveMinChance", {
    Title = "Powerups Eggs Minimum Chance",
    Default = tostring(getgenv().WebhookConfig.ExclusiveMinChance),
    Numeric = true,
    Callback = function(v)
        getgenv().WebhookConfig.ExclusiveMinChance = tonumber(v)
    end
})

-- Webhook URL
WS:CreateInput("WebhookURL", {
    Title = "Webhook URL",
    Default = getgenv().WebhookConfig.Webhook,
    Callback = function(v)
        getgenv().WebhookConfig.Webhook = v
    end
})

-- Discord User ID
WS:CreateInput("DiscordUserID", {
    Title = "Discord User ID",
    Default = getgenv().WebhookConfig.DiscordUserID,
    Callback = function(v)
        getgenv().WebhookConfig.DiscordUserID = v
    end
})

-- Send to Webhook
WS:CreateToggle("SendToWebhook", {
    Title = "Send to Webhook",
    Default = getgenv().WebhookConfig.SendToWebhook
}):OnChanged(function(state)
    getgenv().WebhookConfig.SendToWebhook = state
end)

-- Ping on Secret
WS:CreateToggle("PingOnSecret", {
    Title = "Ping User on Secret",
    Default = getgenv().WebhookConfig.PingUserOnSecret
}):OnChanged(function(state)
    getgenv().WebhookConfig.PingUserOnSecret = state
end)

local ShrineSection=Tabs.Misc:AddSection("▶ Shrines")local potionList={}for _,p in ipairs(ShrineValues)do local n=p.Name;if p.Type=="Potion"and p.Level then n=n.." "..p.Level end table.insert(potionList,n)end table.sort(potionList)ShrineSection:AddDropdown("SelectPotion",{Title="Potions",Values=potionList,Multi=false,Default=nil,Callback=function(v)getgenv().MiscConfig.SelectedPotion=v end})ShrineSection:AddInput("PotionQuantity",{Title="Quantity",Default="1",Numeric=true,Finished=false,Callback=function(v)getgenv().MiscConfig.PotionQuantity=math.clamp(tonumber(v)or 1,1,1000)end})ShrineSection:AddToggle("AutoDonateShrine",{Title="Auto Donate Shrine",Default=false,Callback=function(v)getgenv().MiscConfig.AutoDonateShrine=v end})local function getPotionByName(n)for _,p in ipairs(ShrineValues)do local name=p.Name;if p.Type=="Potion"and p.Level then name=name.." "..p.Level end if name==n then return p end end end local function shrineOnCooldown()local d=LocalData:Get()if not d or not d.Shrines or not d.Shrines.BubbleShrine then return false end local s=d.Shrines.BubbleShrine;return os.time()<(s.ShrineBlessingEndTime or 0)end task.spawn(function()while true do local cfg=getgenv().MiscConfig;if cfg.AutoDonateShrine and cfg.SelectedPotion then local p=getPotionByName(cfg.SelectedPotion)if p then local q=math.clamp(cfg.PotionQuantity or 1,1,1000)if not shrineOnCooldown() then pcall(function()RemoteFunction:InvokeServer("DonateToShrine",{Type=p.Type,Name=p.Name,Level=p.Level or 1,Amount=q,XP=p.XP})end)end end end task.wait(0.5)end end)

-- FISHES
ShrineSection:AddInput("DreamShardQuantity", {
    Title = "Dream Shard Quantity",
    Default = "1",
    Numeric = true,
    Finished = true,
    Callback = function(v)
        getgenv().MiscConfig.DreamShardQuantity = tonumber(v) or 1
    end
})

ShrineSection:AddToggle("AutoDonateDreamerShard", {
    Title = "Auto Donate Dreamer Shrine",
    Default = false,
    Callback = function(v)
        getgenv().MiscConfig.AutoDonateDreamerShrine = v
    end
})

task.spawn(function()
    while true do
        local cfg = getgenv().MiscConfig
        if cfg.AutoDonateDreamerShrine then
            local args = {
                "DonateToDreamerShrine",
                tonumber(cfg.DreamShardQuantity) or 1
            }
            pcall(function()
                game:GetService("ReplicatedStorage")
                    :WaitForChild("Shared")
                    :WaitForChild("Framework")
                    :WaitForChild("Network")
                    :WaitForChild("Remote")
                    :WaitForChild("RemoteFunction")
                    :InvokeServer(unpack(args))
            end)
            task.wait(5)
        else
            task.wait(0.5)
        end
    end
end)

-- AUTO CHESTS
local chestFolder=workspace:WaitForChild("Rendered"):WaitForChild("Chests")
local ChestList={}for _,c in ipairs(chestFolder:GetChildren())do if c:IsA("Model")then table.insert(ChestList,c.Name)end end
Tabs.Misc:CreateSection("▶ Island Chests")
local ChestDropdown=Tabs.Misc:CreateDropdown("ChestSelect",{Title="Select Chests",Description="Choose which chests to auto claim",Values=ChestList,Multi=true,Default={}})
ChestDropdown:OnChanged(function(vals)getgenv().MiscConfig.SelectedChests={}for n,s in pairs(vals)do if s then table.insert(getgenv().MiscConfig.SelectedChests,n)end end end)
local ChestToggle=Tabs.Misc:CreateToggle("AutoIslandChests",{Title="Auto Island Chests",Default=false})
ChestToggle:OnChanged(function(v)getgenv().MiscConfig.AutoIslandChests=v end)
task.spawn(function()while true do local cfg=getgenv().MiscConfig if cfg.AutoIslandChests and #cfg.SelectedChests>0 then local data=LocalData:Get()if data and data.Cooldowns then for _,name in ipairs(cfg.SelectedChests)do local cd=data.Cooldowns[name]or 0 if os.time()>=cd then pcall(function()RemoteEvent:FireServer("ClaimChest",name)end)task.wait(1)end end end end task.wait(2)end end)

local PowerupsSection=Tabs.Misc:CreateSection("▶ Powerups") local eggList={} for name,_ in pairs(Powerups)do if string.find(name:lower(),"egg")then table.insert(eggList,name)end end table.sort(eggList) local EggDropdown=PowerupsSection:AddDropdown("PowerupsEggsSelect",{Title="Select Powerup Egg",Values=eggList,Multi=false,Default=getgenv().MiscConfig.SelectedPowerupEgg or nil,Callback=function(v)getgenv().MiscConfig.SelectedPowerupEgg=v end}) PowerupsSection:AddToggle("AutoHatchPowerupsEggs",{Title="Auto Hatch Powerups Eggs",Default=getgenv().MiscConfig.AutoHatchPowerupsEggs or false,Callback=function(v)getgenv().MiscConfig.AutoHatchPowerupsEggs=v end}) local function hatchEgg(e)pcall(function()RemoteEvent:FireServer("HatchPowerupEgg",e,12)end)end task.spawn(function()while true do local cfg=getgenv().MiscConfig if cfg.AutoHatchPowerupsEggs and cfg.SelectedPowerupEgg then hatchEgg(cfg.SelectedPowerupEgg)end task.wait(0.5)end end)
local boxList={}for n,_ in pairs(Powerups)do local l=n:lower()if l:find("box")or l:find("crate")then table.insert(boxList,n)end end;table.sort(boxList)PowerupsSection:AddDropdown("BoxesSelect",{Title="Select Box",Values=boxList,Multi=false,Default=getgenv().MiscConfig.SelectedBox or nil,Callback=function(v)getgenv().MiscConfig.SelectedBox=v end})PowerupsSection:AddToggle("AutoOpenBoxes",{Title="Auto Open Boxes",Default=getgenv().MiscConfig.AutoOpenBoxes or false,Callback=function(v)getgenv().MiscConfig.AutoOpenBoxes=v end})local function hasBoxAvailable(box)local ok,data=pcall(function()return LocalData:Get()end)if not ok or not data or not data.Powerups then return false end;local amount=data.Powerups[box]return amount and amount>0 end;local function useBox(box)if hasBoxAvailable(box)then pcall(function()RemoteEvent:FireServer("UseGift",box,50)end)end end;local function tapNearbyGifts()pcall(function()local gifts=PhysicalItem:GetActiveGifts()local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if not hrp then return end;for obj,gift in pairs(gifts)do if gift and gift.InRange and gift.Hit then gift:Hit()end end end)end;task.spawn(function()while true do local cfg=getgenv().MiscConfig;if cfg.AutoHatchPowerupsEggs and cfg.SelectedPowerupEgg then hatchEgg(cfg.SelectedPowerupEgg)end;if cfg.AutoOpenBoxes and cfg.SelectedBox then useBox(cfg.SelectedBox)tapNearbyGifts()end;task.wait(0.1)end end)

-- AUTO PLAYTIME, SEASON, WHEEL SPINS
Tabs.Misc:CreateSection("▶ Other")
Tabs.Misc:CreateToggle("AutoPlaytimeRewards",{Title="Auto Playtime Rewards",Default=false,Callback=function(v)getgenv().MiscConfig.AutoPlaytime=v;local c={}local function t()if not getgenv().MiscConfig.AutoPlaytime then return end;local d=LocalData:Get()if not d or not d.PlaytimeRewards then return end;local r=d.PlaytimeRewards;for i=1,#r.Claimed do if not c[i] and not r.Claimed[i]then pcall(function()RemoteFunction:InvokeServer("ClaimPlaytime",i)end)c[i]=true end end end;if v then if LocalData:IsReady()then t()end LocalData:ConnectDataChanged(t)RunService.Heartbeat:Connect(t)end end})
Tabs.Misc:CreateToggle("AutoClaimSeason",{Title="Auto Claim Season",Default=false,Callback=function(v)getgenv().MiscConfig.AutoSeason=v;if v then LocalData:ConnectDataChanged(function(data)if getgenv().MiscConfig.AutoSeason and data and data.Season then pcall(function()RemoteEvent:FireServer("ClaimSeason")end)end end)end end})
Tabs.Misc:CreateToggle("AutoClaimPrizes",{Title="Auto Claim Prizes",Default=false,Callback=function(s)getgenv().AutoClaimPrizes=s;if not s then return end;task.spawn(function()local RS=game:GetService("ReplicatedStorage");local RemoteEvent=RS.Shared.Framework.Network.Remote:WaitForChild("RemoteEvent");local PrizeData=require(RS.Shared.Data.Prizes);local prizeIds={};for id,data in pairs(PrizeData)do if typeof(id)=="number" and data.Requirement then table.insert(prizeIds,id)end end;table.sort(prizeIds);while getgenv().AutoClaimPrizes do local playerData=LocalData:Get();for _,id in ipairs(prizeIds)do if not(playerData.Prizes and playerData.Prizes[id])then pcall(function()RemoteEvent:FireServer("ClaimPrize",id)end)task.wait(0.25)end end;task.wait(5)end end)end})
Tabs.Misc:CreateButton({Title="Redeem Codes",Description="Redeem all available game codes automatically",Callback=function()task.spawn(function() local remote=RS.Shared.Framework.Network.Remote:FindFirstChild("RemoteFunction")or RS.Shared.Framework.Network.Remote:WaitForChild("RemoteFunction") local codes=require(RS.Shared.Data.Codes) local s=0 for code in pairs(codes)do pcall(function()remote:InvokeServer("RedeemCode",code)s=s+1 end) task.wait(0.1) end print("✅ Redeemed "..s.." codes successfully!") end) end})
Tabs.Misc:CreateToggle("DisableItemNotifications",{Title="Disable Item Notifications",Default=false,Callback=function(v)pcall(function()Remote:FireServer("SetSetting","Item Notifications",not v)end)end})
Tabs.Misc:AddToggle("EnableLowGraphics",{Title="Enable Low Graphics",Default=getgenv().FPSBoosterConfig.LowGraphics,Callback=function(s)getgenv().FPSBoosterConfig.LowGraphics=s;if s then task.spawn(function()pcall(function()local L=game:GetService("Lighting")local W=game:GetService("Workspace")local P=game:GetService("Players")local plr=P.LocalPlayer local R=game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("RemoteEvent")settings().Rendering.QualityLevel=Enum.QualityLevel.Level01;pcall(function()L.GlobalShadows=false;L.Bloom.Enabled=false;L.Blur.Enabled=false;L.DepthOfField.Enabled=false;L.SunRays.Enabled=false end)local function d(o)if o:IsA("BasePart")then o.CastShadow=false end;for _,c in ipairs(o:GetChildren())do d(c)end end;d(W);W.DescendantAdded:Connect(d)local function h(c)if c and c:FindFirstChildOfClass("Humanoid")then c.Humanoid.HealthDisplayType=Enum.HumanoidHealthDisplayType.AlwaysOff end end;for _,pl in ipairs(P:GetPlayers())do if pl.Character then h(pl.Character)end;pl.CharacterAdded:Connect(h)end;if getgenv().FPSBoosterConfig.EffectsOff then for _,v in ipairs(game:GetDescendants())do if v:IsA("BasePart")then v.Material=Enum.Material.SmoothPlastic end;if v:IsA("ParticleEmitter")or v:IsA("Smoke")or v:IsA("Explosion")or v:IsA("Sparkles")or v:IsA("Fire")then v.Enabled=false end;if v:IsA("BloomEffect")or v:IsA("BlurEffect")or v:IsA("DepthOfFieldEffect")or v:IsA("SunRaysEffect")then v.Enabled=false end;if v:IsA("Decal")or v:IsA("Texture")then v.Texture="" end;if v:IsA("Sky")then v.Parent=nil end end end;if getgenv().FPSBoosterConfig.FullBright then L.FogColor=Color3.fromRGB(255,255,255);L.FogEnd=math.huge;L.FogStart=math.huge;L.Ambient=Color3.fromRGB(255,255,255);L.Brightness=5;L.ColorShift_Bottom=Color3.fromRGB(255,255,255);L.ColorShift_Top=Color3.fromRGB(255,255,255);L.OutdoorAmbient=Color3.fromRGB(255,255,255);L.Outlines=true end end)end)else pcall(function()local L=game:GetService("Lighting")L.GlobalShadows=true;L.Brightness=2;L.FogEnd=1000;for _,v in ipairs(L:GetChildren())do if v:IsA("PostEffect")then v.Enabled=true end end end)end end})
Tabs.Misc:CreateSection("▶ Wheel Spins")
Tabs.Misc:CreateToggle("AutoWheelSpin",{Title="Auto Wheel Spin",Default=false,Callback=function(v)getgenv().MiscConfig.AutoWheelSpin=v end})
Tabs.Misc:CreateToggle("AutoFestivalWheelSpin",{Title="Auto Festival Wheel Spin",Default=false,Callback=function(v)getgenv().MiscConfig.AutoFestivalWheelSpin=v end})
Tabs.Misc:CreateInput("WheelSpinDelay",{Title="Wheel Spin Delay (sec)",Default=tostring(getgenv().MiscConfig.WheelSpinDelay),Numeric=true,Finished=true,Callback=function(v)getgenv().MiscConfig.WheelSpinDelay=tonumber(v)or 0.01 end})

task.spawn(function()while true do local cfg=getgenv().MiscConfig if cfg.AutoPlaytime then for i=1,9 do pcall(function()RemoteFunction:InvokeServer("ClaimPlaytime",i)end)end end if cfg.AutoWheelSpin or cfg.AutoFestivalWheelSpin then pcall(function() if cfg.AutoWheelSpin then RemoteFunction:InvokeServer("WheelSpin")RemoteEvent:FireServer("ClaimWheelSpinQueue")end if cfg.AutoFestivalWheelSpin then RemoteFunction:InvokeServer("FestivalWheelSpin")RemoteEvent:FireServer("ClaimFestivalWheelSpinQueue")end end)end task.wait(cfg.WheelSpinDelay)end end)

local coins, gems, tickets, pearls, totalHatches = 0, 0, 0, 0, 0

local function updateCurrencies()
    local data = LocalData:Get()
    if not data then return end

    coins = data.Coins or (data.Stats and data.Stats.Coins) or coins
    gems = data.Gems or (data.Stats and data.Stats.Gems) or gems
    tickets = data.Tickets or (data.Stats and data.Stats.Tickets) or tickets
    pearls = data.Pearls or (data.Stats and data.Stats.Pearls) or pearls
    totalHatches = data.Stats and data.Stats.Hatches or totalHatches
end

LocalData.Changed:Connect(function()
    pcall(updateCurrencies)
end)

pcall(updateCurrencies)

local function abbreviateNumber(num)
    num = tonumber(num) or 0
    local absNum = math.abs(num)

    if absNum >= 1e12 then
        return string.format("%.1fT", num / 1e12)
    elseif absNum >= 1e9 then
        return string.format("%.1fB", num / 1e9)
    elseif absNum >= 1e6 then
        return string.format("%.1fM", num / 1e6)
    elseif absNum >= 1e3 then
        return string.format("%.1fK", num / 1e3)
    else
        return tostring(num)
    end
end

local function formatChance(chanceStr, variant)
    if not chanceStr then return "Unknown", math.huge end

    local cleanStr = tostring(chanceStr):gsub("%%", "")
    local num = tonumber(cleanStr)
    if not num or num <= 0 then 
        return tostring(chanceStr), math.huge 
    end

    if variant == "Shiny" then
        num = num / 40
    elseif variant == "Mythic" then
        num = num / 100
    elseif variant == "Shiny Mythic" then
        num = num / 4000
    end

    local oneIn = 100 / num

    local function approxNumber(n)
        if n >= 1e12 then
            return string.format("%.2fT", n / 1e12)
        elseif n >= 1e9 then
            return string.format("%.2fB", n / 1e9)
        elseif n >= 1e6 then
            return string.format("%.2fM", n / 1e6)
        elseif n >= 1e3 then
            return string.format("%.2fK", n / 1e3)
        else
            return string.format("%.2f", n)
        end
    end

    local percentStr
    if oneIn >= 100_000_001 then
        percentStr = string.format("%.0e", num) .. "%"
    else
        percentStr = string.format("%.10f", num):gsub("0+$", ""):gsub("%.$", "") .. "%"
    end

    return string.format("%s (1 in %s)", percentStr, approxNumber(oneIn)), oneIn
end

local function isSecretBounty(petName)
    local ok, result = pcall(function()
        return secretBountyUtil.Get()
    end)

    if ok and typeof(result) == "table" and result.Name == petName then
        return true, result
    end
    return false, nil
end

local function getBoostedStats(stats, variant)
    local multiplier = 1
    if variant == "Shiny" then multiplier = 1.5
    elseif variant == "Mythic" then multiplier = 1.75
    elseif variant == "Shiny Mythic" then multiplier = 2.25 end

    local boosted = {}
    for stat, value in pairs(stats) do
        if typeof(value) == "number" then
            boosted[stat] = math.floor(value * multiplier)
        else
            boosted[stat] = value
        end
    end
    return boosted
end

local function getPetImageLink(petName, variant)
    local petEntry = petsModule[petName]
    if not petEntry or not petEntry.Images then return nil end

    local imageKey = ({
        ["Normal"] = "Normal",
        ["Shiny"] = "Shiny",
        ["Mythic"] = "Mythic",
        ["Shiny Mythic"] = "MythicShiny"
    })[variant]

    local assetStr = petEntry.Images[imageKey]
    local assetId = assetStr and assetStr:match("%d+")
    return assetId and ("https://ps99.biggamesapi.io/image/" .. assetId) or nil
end

local function loadFailedWebhooks()
    if not isfile(failedFile) then return {} end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(failedFile)) end)
    return ok and data or {}
end

local function saveFailedWebhook(entry)
    local failed = loadFailedWebhooks()
    table.insert(failed, entry)
    pcall(function()
        writefile(failedFile, HttpService:JSONEncode(failed))
    end)
end

local function enqueueWebhook(data)
    table.insert(webhookQueue, data)
end

local function processWebhookQueue()    
    if isProcessingQueue then return end    
    isProcessingQueue = true    
    
    while #webhookQueue > 0 do    
        local data = table.remove(webhookQueue, 1)    
        local sent, lastErr = false, nil    
    
        for i = 1, 1000 do    
            local ok, err = pcall(function()    
                http_request({    
                    Url = data.webhookUrl,    
                    Method = "POST",    
                    Headers = { ["Content-Type"] = "application/json" },    
                    Body = HttpService:JSONEncode({    
                        content = data.contentText,    
                        embeds = {{    
                            author = {    
                                name = "OTC",    
                                icon_url = "https://cdn.discordapp.com/avatars/1409528801511346348/68958c254255476cf834a3aac99d4936.webp?size=2048"    
                            },    
                            title = data.titleText,    
                            description = data.description,    
                            color = data.embedColor,    
                            thumbnail = data.petImageLink and { url = data.petImageLink } or nil    
                        }}    
                    })    
                })    
            end)    
    
            if ok then    
                sent = true    
                break    
            else    
                lastErr = tostring(err)    
                warn(string.format("[⚠️ Attempt %d/1000 failed] %s", i, lastErr))    
                if string.find(lastErr, "522") or string.find(lastErr, "Timed") then    
                    task.wait(1)    
                else    
                    break    
                end    
            end    
        end    
    
        if not sent then    
            warn("[❌ Webhook Dropped] Failed after all retries")    
            saveFailedWebhook({    
                time = os.date("%Y-%m-%d %H:%M:%S"),    
                error = lastErr or "Unknown",    
                webhookUrl = data.webhookUrl,    
                contentText = data.contentText,    
                titleText = data.titleText,    
                description = data.description,    
                embedColor = data.embedColor    
            })    
        end    
    
        task.wait(0.25)    
    end    
    
    isProcessingQueue = false    
end

function sendDiscordWebhook(playerName, petName, variant, boostedStats, dropChance, egg, rarity, tier)
    local cfg = getgenv().WebhookConfig
    if not cfg.SendToWebhook then
        print("[Webhook Skipped] Sending disabled in config")
        return
    end

    if cfg.Webhook == "" and webhookUrl == nil then
        print("[Webhook Skipped] No webhook URL provided")
        return
    end

    local activeWebhook = cfg.Webhook ~= "" and cfg.Webhook or webhookUrl

    local colorMap = {
        ["Normal"] = 65280,
        ["Shiny"] = 0xFFD700,
        ["Mythic"] = 0x8000FF,
        ["Shiny Mythic"] = 0x00FFFF,
        ["Secret"] = 0xFF0000,
        ["Secret Bounty"] = 0xFF8800,
        ["Infinity"] = 0xFFFFFF
    }

    local embedColor
    if colorMap[rarity] then
        embedColor = colorMap[rarity]
    elseif colorMap[variant] then
        embedColor = colorMap[variant]
    else
        embedColor = colorMap["Normal"]
    end

    local contentText = ""
    if rarity == "Secret" or rarity == "Secret Bounty" or rarity == "Infinity" then
        if cfg.PingUserOnSecret and cfg.DiscordUserID ~= "" then
            contentText = "<@" .. cfg.DiscordUserID .. ">"
        else
            contentText = "@everyone"
        end
    end

    local displayPetName = (variant ~= "Normal") and (variant .. " " .. petName) or petName
    local hatchCount = abbreviateNumber(totalHatches)
    local petImageLink = getPetImageLink(petName, variant)

    local petCurrencyLabel, petCurrencyValue = "", ""
    if boostedStats.Tickets then
        petCurrencyLabel = "<:ticket:1392626567464747028> Tickets"
        petCurrencyValue = tostring(boostedStats.Tickets)
    elseif boostedStats.Pearls then
        petCurrencyLabel = "<:pearls:1403707150513213550> Pearls"
        petCurrencyValue = tostring(boostedStats.Pearls)
    else
        petCurrencyLabel = "<:coins:1392626598188154977> Coins"
        petCurrencyValue = tostring(boostedStats.Coins or "N/A")
    end

    local userCoins = abbreviateNumber(coins)
    local userGems = abbreviateNumber(gems)
    local userTickets = abbreviateNumber(tickets)
    local userPearls = abbreviateNumber(pearls)

    local description = string.format([[
🎉・**Hatch Info**
- 🥚 **Egg:** `%s`
- 🏆 **Chance:** `%s`
- 🎁 **Rarity:** `%s`
- 🔢 **Tier:** `%s`

✨・**Pet Stats**
- <:bubbles:1392626533826433144> **Bubbles:** `%s`
- <:gems:1392626582929277050> **Gems:** `%s`
- %s: `%s`

??・**User Info**
- 🕒 **Playtime:** `%s`
- 🥚 **Hatches:** `%s`
- <:coins:1392626598188154977> **Coins:** `%s`
- <:pearls:1403707150513213550> **Pearls:** `%s`
- <:gems:1392626582929277050> **Gems:** `%s`
- <:ticket:1392626567464747028> **Tickets:** `%s`
    ]],
        egg or "Unknown",
        dropChance,
        rarity or "Legendary",
        tostring(tier or "1"),
        boostedStats.Bubbles or "N/A",
        boostedStats.Gems or "N/A",
        petCurrencyLabel,
        petCurrencyValue,
        formatPlaytime(),
        hatchCount,
        userCoins,
        userPearls,
        userGems,
        userTickets
    )

    local titleText = ""
    if rarity == "Infinity" then
        titleText = string.format("DAMN! ||%s|| hatched a %s! Unbelievable!", playerName, displayPetName)
    elseif rarity == "Secret" or rarity == "Secret Bounty" then
        titleText = string.format("WOW! ||%s|| hatched a %s! Lucky Guy!", playerName, displayPetName)
    else
        titleText = string.format("||%s|| hatched a %s", playerName, displayPetName)
    end

    enqueueWebhook({
        webhookUrl = activeWebhook,
        contentText = contentText,
        titleText = titleText,
        description = description,
        embedColor = embedColor,
        petImageLink = petImageLink
    })

    task.spawn(processWebhookQueue)
end

RemoteEvent.OnClientEvent:Connect(function(action, data)
    local cfg = getgenv().WebhookConfig
    
    if action ~= "HatchEgg" and action ~= "ExclusiveHatch" then return end
    if not data or not data.Pets then return end

    for _, petInfo in pairs(data.Pets) do
        local pet = petInfo.Pet
        if not pet then continue end

        local petName = pet.Name or "Unknown"
        local variant = "Normal"
        if pet.Shiny and pet.Mythic then
            variant = "Shiny Mythic"
        elseif pet.Shiny then
            variant = "Shiny"
        elseif pet.Mythic then
            variant = "Mythic"
        end

        local petEntry = petsModule[petName]
        if not petEntry then continue end

        local boostedStats = getBoostedStats(petEntry.Stats, variant)

        local eggName
        if action == "ExclusiveHatch" then
            eggName = petInfo.EggName or petEntry.Egg or "Unknown Egg"
        else
            if data.Name == "Infinity Egg" then
                eggName = petEntry.Egg or "Unknown"
            else
                eggName = eggsModule[data.Name] and eggsModule[data.Name].Name or data.Name or "Unknown"
            end
        end

        local rarity = petEntry.Rarity or "Unknown"
        local tier = petEntry.Tier or 1

        local bounty, secret = isSecretBounty(petName)
        local rawChance
        if bounty then
            rarity = "Secret Bounty"
            if secret then
                eggName = secret.Egg or eggName
                rawChance = secret.Chance or petEntry.Chance
            end
        else
            rawChance = petEntry.Chance or "Unknown"
        end

        local dropChance, oneIn = formatChance(rawChance, variant)

        local shouldSend = false
        if rarity == "Secret" or rarity == "Secret Bounty" then
            shouldSend = true
        elseif not cfg.UseBaseChance then
            if action == "ExclusiveHatch" then
                if oneIn >= cfg.ExclusiveMinChance then
                    shouldSend = true
                end
            else
                if oneIn >= cfg.NormalMinChance then
                    shouldSend = true
                end
            end
        else
            if action == "ExclusiveHatch" then
                if oneIn >= 500 then
                    shouldSend = true
                end
            else
                if oneIn >= 1e6 then
                    shouldSend = true
                end
            end
        end

        if shouldSend then
            sendDiscordWebhook(
                LocalPlayer.Name,
                petName,
                variant,
                boostedStats,
                dropChance,
                eggName,
                rarity,
                tier
            )
        end
    end
end)

--// SAVE SETTINGS
InterfaceManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:SetIgnoreIndexes{}
InterfaceManager:SetFolder("OTC")
SaveManager:SetFolder("OTC")
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
Window:SelectTab(1)

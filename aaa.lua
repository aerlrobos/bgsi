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
local PetUtil = require(RS.Shared.Utils.Stats.PetUtil)
local JollyTrioQuest = require(RS.Shared.Data.Quests.JollyTrioQuest)
local QuestUtil = require(RS.Shared.Utils.Stats.QuestUtil)
local TimeUtil = require(RS.Shared.Framework.Utilities.Math.Time)
local Constants = require(RS.Shared.Constants)
local humanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local LocalData = require(RS.Client.Framework.Services.LocalData)
local playerData = LocalData:Get()
playerData.UserId=LocalPlayer.UserId
local failedFile = "FailedWebhooks.json"

local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

getgenv().ChristmasConfig = {
    AutoGiveGifts = false,
    AutoClaimAdvent = false,
    AutoCollectPresentRain = false
}
getgenv().JollySettings = getgenv().JollySettings or {
    MustHave = {"Shadow Crystal"},
    AutoJollyTrioReroll = false,
    SelectedCard = nil,
    LastPosition = nil,
    TeleportedEggs = {},
    AlreadyTeleported = {}
}
-- global farming config
getgenv().FarmingConfig={AutoPickup=false,AutoBubble=false,AutoBubbleSell=false,AutoGoldenOrb=false,AutoFishing=false,BubbleSellMode=nil,BubbleSellInterval=3,BubbleSellLocation=nil}
getgenv().ObbyConfig={Enabled=false,AutoChest=false,Difficulties={}}
getgenv().MasteryConfig={Selected=nil,Auto=false}
-- global gem genie config
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
    AutoEnchantActive = false,
    MaxSecretCrystals = 10
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
getgenv().MiscConfig=getgenv().MiscConfig or{SelectedChests={},AutoIslandChests=false,AutoPlaytime=false,AutoSeason=false,AutoWheelSpin=false,AutoChristmasWheelSpin=false,AutoHalloweenWheelSpin=false,AutoDarkWheelSpin=false,WheelSpinDelay=0.1,SelectedPotion=nil,PotionQuantity=1,AutoDonateShrine=false,AutoDonateDreamerShrine=false,DreamShardQuantity=1,SelectedPowerupEgg=nil,AutoHatchPowerupsEggs=false,SelectedBox=nil,AutoOpenBoxes=false}
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
    Aerlro = Window:CreateTab{ Title = "Aerlro", Icon = "rbxassetid://140431377231411" },
    Christmas = Window:CreateTab{ Title = "Christmas", Icon = "phosphor-snowflake-bold" },
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

local ChristmasSection = Tabs.Christmas:CreateSection("▶️ Christmas Event")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = game:GetService("Players").LocalPlayer

-- Config global
getgenv().ChristmasEggConfig = getgenv().ChristmasEggConfig or {}
getgenv().ChristmasEggConfig.SelectedEgg = nil
getgenv().ChristmasEggConfig.AutoHatch = false

getgenv().ChristmasConfig = getgenv().ChristmasConfig or {}
getgenv().ChristmasConfig.AtRift = false
getgenv().ChristmasConfig.EggTeleported = false
getgenv().ChristmasConfig.AutoGiveGifts = false
getgenv().ChristmasConfig.IsBusyWithGift = false

getgenv().RiftsConfig = getgenv().RiftsConfig or {}
getgenv().RiftsConfig.SelectedEggRift = nil
getgenv().RiftsConfig.TeleportEggRift = false
getgenv().RiftsConfig.IgnoreMultiplier = {}

-- Egg positions
local ChristmasEggs = {
    ["Candycane Egg"] = CFrame.new(-2484.03979,33.5360146,1247.66748),
    ["Gingerbread Egg"] = CFrame.new(-2477.53955,33.5356445,1256.54053),
    ["Yuletide Egg"] = CFrame.new(-2490.54028,33.5360146,1238.7937),
    ["Infinity Egg"] = CFrame.new(-2613.427,24.010891,1090.76404),
    ["Northpole Egg"] = CFrame.new(-2497.04102,37.8979454,1229.91992,0.767449141,0,0.641109824,0,1,0,-0.641109824,0,0.767449141),
    ["Aurora Egg"] = CFrame.new(-2503.54199,37.8978348,1221.04663,0.760207295,0,0.649680555,0,1,0,-0.649680555,0,0.760207295)
}

-- Teleport la egg
local function tpEgg(egg)
    local eggPos = ChristmasEggs[egg]
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if eggPos and hrp then
        hrp.CFrame = eggPos + Vector3.new(0,3,0)
    end
end

-- Apasa E
local function pressE()
    task.spawn(function()
        while getgenv().ChristmasEggConfig.AutoHatch do
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            task.wait(0.2)
        end
    end)
end

local function getRiftMultiplier(rift)
    for _,d in ipairs(rift:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextBox") then
            local text = d.Text:lower()
            local mult = text:match("(%d+)%s*x") or text:match("x%s*(%d+)")
            if mult then
                return tonumber(mult)
            end
        end
    end
    return nil
end

-- Dropdown selectare egg
ChristmasSection:CreateDropdown("XmasEggSelect", {
    Title = "Christmas Eggs",
    Values = (function()
        local t = {}
        for eggName,_ in pairs(ChristmasEggs) do
            table.insert(t, eggName)
        end
        table.sort(t)
        return t
    end)(),
    Callback = function(v)
        getgenv().ChristmasEggConfig.SelectedEgg = v
    end
})

-- Dropdown si toggle pentru Egg Rifts
local EggRiftMap, ChestRiftMap = {}, {}
local autoPressE = false
for id,data in pairs(RiftsModule) do
    if data.Type == "Egg" then
        EggRiftMap[id] = data.Egg or data.DisplayName or id
    elseif data.Type == "Chest" then
        ChestRiftMap[id] = data.DisplayName or id
    end
end

local teleportedEggs, alreadyTeleported = {}, {}

ChristmasSection:CreateDropdown("EggRiftSelect", {
    Title = "Egg Rifts",
    Values = (function()
        local t = {}
        for _,v in pairs(EggRiftMap) do table.insert(t,v) end
        table.sort(t)
        return t
    end)(),
    Multi = false,
    Default = nil,
    Callback = function(v)
        for k,val in pairs(EggRiftMap) do
            if val == v then getgenv().RiftsConfig.SelectedEggRift = k break end
        end
    end
})

ChristmasSection:CreateDropdown("IgnoreMultiplier", {
    Title = "Ignore Egg Rift Multipliers",
    Values = {1,2,5,10,15,20,25},
    Multi = true,
    Default = {},
    Callback = function(vals)
        local s = {}
        for k,v in pairs(vals) do
            if v == true then
                local num = tonumber(k)
                if num then s[num] = true end
            end
        end
        getgenv().RiftsConfig.IgnoreMultiplier = s
    end
})

ChristmasSection:CreateToggle("TeleportEggRiftToggle", {
    Title = "Teleport to Egg Rift",
    Default = false,
    Callback = function(state)
        getgenv().RiftsConfig.TeleportEggRift = state
        autoPressE = state

        if state then
            task.spawn(function()
                while autoPressE do
                    local selectedRift = getgenv().RiftsConfig.SelectedEggRift
                    local riftsFolder = workspace:FindFirstChild("Rendered")
                        and workspace.Rendered:FindFirstChild("Rifts")

                    if not selectedRift or not riftsFolder then
                        task.wait(1)
                        continue
                    end

                    local rift = riftsFolder:FindFirstChild(selectedRift)
                    if not rift then
                        task.wait(1)
                        continue
                    end

                    -- 🔢 verifică multiplier
                    local multiplier = getRiftMultiplier(rift)
                    if multiplier then
                        print("[RIFT] Multiplier detected: x" .. multiplier)
                    end

                    -- ⛔ ignoră multiplier selectat
                    if multiplier and getgenv().RiftsConfig.IgnoreMultiplier[multiplier] then
                        print("[RIFT] Ignored due to multiplier x" .. multiplier)
                        task.wait(1)
                        continue
                    end

                    -- ✅ rift valid
                    getgenv().ChristmasConfig.AtRift = true
                    getgenv().ChristmasConfig.EggTeleported = false

                    local platform = rift:FindFirstChild("EggPlatformSpawn")
                    local part = platform and (platform.PrimaryPart or platform:FindFirstChildWhichIsA("BasePart"))

                    if part then
                        LocalPlayer.Character.HumanoidRootPart.CFrame =
                            part.CFrame + Vector3.new(0,5,0)
                        print("[RIFT] Teleported to rift:", selectedRift)
                    end

                    -- ⏱️ TIMER LOGICĂ
                    local timerLabel
                    local display = rift:FindFirstChild("Display")
                    if display and display:FindFirstChild("SurfaceGui") then
                        timerLabel = display.SurfaceGui:FindFirstChild("Timer")
                    end

                    while rift.Parent and autoPressE do
                        if timerLabel then
                            print("[RIFT TIMER]", timerLabel.Text)
                        end

                        -- apăsăm E cât timp rift-ul există
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        task.wait(0.15)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

                        task.wait(1)
                    end

                    -- ❌ rift dispărut
                    print("[RIFT] Rift expired:", selectedRift)
                    getgenv().ChristmasConfig.AtRift = false

                    task.wait(1)
                end
            end)
        end
    end
})

-- Toggle Auto Hatch Christmas
ChristmasSection:CreateToggle("AutoHatchChristmas", {
    Title = "Auto Hatch (Christmas)",
    Default = false,
    Callback = function(state)
        getgenv().ChristmasEggConfig.AutoHatch = state

        if state then
            -- apăsare E pentru hatch
            task.spawn(function()
                while getgenv().ChristmasEggConfig.AutoHatch do
                    if not getgenv().ChristmasConfig.AtRift then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        task.wait(0.1)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    end
                    task.wait(0.3)
                end
            end)

            -- teleport la egg o singură dată
            task.spawn(function()
                while getgenv().ChristmasEggConfig.AutoHatch do
                    if getgenv().ChristmasConfig.AtRift then
                        task.wait(1)
                        continue
                    end

                    local egg = getgenv().ChristmasEggConfig.SelectedEgg
                    if egg and not getgenv().ChristmasConfig.EggTeleported then
                        local eggCFrame = ChristmasEggs[egg]
                        local hrp = LocalPlayer.Character
                            and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                        if hrp and eggCFrame then
                            hrp.CFrame = eggCFrame + Vector3.new(0,3,0)
                            getgenv().ChristmasConfig.EggTeleported = true
                            print("[AutoHatch] Teleported back to egg:", egg)
                        end
                    end

                    task.wait(1)
                end
            end)
        end
    end
})

local autoGiftThread
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local function activateGiftProperly(activationModel)local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")if not root then return end local touchPart=activationModel:FindFirstChild("Root") or activationModel:FindFirstChild("Ring")if not touchPart then return end firetouchinterest(root,touchPart,0)task.wait(0.05)firetouchinterest(root,touchPart,1) end
local function visitGift(gift)local char=player.Character if not char then return end local root=char:FindFirstChild("HumanoidRootPart")if not root then return end local activation=gift:FindFirstChild("Activation")if not activation then return end local goal=activation:FindFirstChild("Root") or activation:FindFirstChild("Ring")if not goal then return end getgenv().ChristmasConfig.IsBusyWithGift=true while player:GetAttribute("GiveGiftsFreeze")do task.wait(0.1)end root.AssemblyLinearVelocity=Vector3.zero root.CFrame=CFrame.new(goal.Position+Vector3.new(0,2.5,0)) task.wait(0.2)activateGiftProperly(activation) local timeout=10 while timeout>0 and player:GetAttribute("GiveGiftsFreeze")do timeout-=0.1 task.wait(0.1)end end
ChristmasSection:CreateToggle("AutoGiveGifts",{Title="Auto Give Gifts",Default=false,Callback=function(v)getgenv().ChristmasConfig.AutoGiveGifts=v if v then autoGiftThread=task.spawn(function()local giftsFolder=workspace.Worlds["Christmas World"]:WaitForChild("GiveGifts") while getgenv().ChristmasConfig.AutoGiveGifts do if getgenv().ChristmasEggConfig.AutoHatch then task.wait(1) continue end for _,gift in ipairs(giftsFolder:GetChildren())do if not getgenv().ChristmasConfig.AutoGiveGifts then break end if gift:FindFirstChild("Activation")then visitGift(gift) local egg=getgenv().ChristmasEggConfig.SelectedEgg if egg and ChristmasEggs[egg] and getgenv().ChristmasEggConfig.AutoHatch then tpEgg(egg) end task.wait(5) getgenv().ChristmasConfig.IsBusyWithGift=false end task.wait(0.3)end end end) else if autoGiftThread then task.cancel(autoGiftThread) autoGiftThread=nil end end end})
local autoAdventThread
local function now()return os.time()end
local AdventCalender={START_TIME=os.time({year=2025,month=12,day=5,hour=0,min=0,sec=0}),TOTAL_DAYS=21,GetDayIndex=function(self)local daysPassed=math.floor((now()-self.START_TIME)/86400)+1 return math.min(math.max(daysPassed,1),self.TOTAL_DAYS)end,GetTimeUntilIndex=function(self,index)local targetTime=self.START_TIME+(index-1)*86400 return math.max(targetTime-now(),0)end}
local function claimAdvent()local args={"ClaimAdventCalender"} pcall(function()RemoteEvent:FireServer(unpack(args))end)end
ChristmasSection:CreateToggle("AutoClaimAdvent",{Title="Auto Claim Advent Calendar",Default=false,Callback=function(v)getgenv().ChristmasConfig.AutoClaimAdvent=v if v then autoAdventThread=task.spawn(function()while getgenv().ChristmasConfig.AutoClaimAdvent do local currentDay=AdventCalender:GetDayIndex() claimAdvent() local waitTime=AdventCalender:GetTimeUntilIndex(currentDay+1) task.wait(waitTime)end end) else if autoAdventThread then task.cancel(autoAdventThread) autoAdventThread=nil end end end})
local autoPresentRainThread
local function touch(part)local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")if not root or not part then return end firetouchinterest(root,part,0)task.wait(0.05)firetouchinterest(root,part,1)end
ChristmasSection:CreateToggle("AutoCollectPresentRain",{Title="Auto Collect Present Rain",Default=false,Callback=function(v)getgenv().ChristmasConfig.AutoCollectPresentRain=v if v then autoPresentRainThread=task.spawn(function()while getgenv().ChristmasConfig.AutoCollectPresentRain do local rendered=workspace:FindFirstChild("Rendered") if rendered then local presentRainFolder=rendered:FindFirstChild("PresentRain") if presentRainFolder then for _,drop in ipairs(presentRainFolder:GetChildren())do for _,gift in ipairs(drop:GetChildren())do if gift:IsA("BasePart") and gift:FindFirstChild("TouchInterest") and gift.Parent then firetouchinterest(player.Character.HumanoidRootPart,gift,0) task.wait(0.05) firetouchinterest(player.Character.HumanoidRootPart,gift,1) print("[PresentRain] Collected:",gift.Name,"from drop:",drop.Name)end end end end end task.wait(0.5)end end) else if autoPresentRainThread then task.cancel(autoPresentRainThread) autoPresentRainThread=nil end end end})

local autoEquipThread=nil;local Constants=require(RS.Shared.Constants);local function getMaxTeamSize()local data=LocalData:Get()if not data then return Constants.BasePetsEquipped or 4 end;local base=Constants.BasePetsEquipped or 4;local mastery=0;local passes=0;local milestone=0;local claimed=0;for _,upgrade in pairs(data.MasteryUpgrades or {})do if upgrade.Type=="Equips"and upgrade.Buff and upgrade.Buff.Value then mastery+=upgrade.Buff.Value end end;if data.Passes and data.Passes["Extra Equips"]then passes=3 end;for _,key in ipairs({"milestone-bubbles-15","milestone-hatching-12","milestone-secrets-7"})do if data.QuestsCompleted and data.QuestsCompleted[key]==1 then milestone+=1 end end;if data.ClaimedPrizes and data.ClaimedPrizes["b-9"]then claimed=1 end;return base+mastery+passes+milestone+claimed end;local function getRarityBoost(pet)if pet.Shiny and pet.Mythic then return 125 elseif pet.Mythic then return 75 elseif pet.Shiny then return 50 end return 0 end;local function getLevelBoost(pet)local rarityXP=Constants.RarityXPRequired;local maxXP=rarityXP[pet.Rarity]or 0;if maxXP<=0 then return 0 end;local level=math.clamp(math.floor((pet.XP or 0)/(maxXP/25)),0,25);return level*1.458 end;local function getEnchantBoost(pet)local boost=0;local teamUp=0;for _,enchant in ipairs(pet.Enchants or {})do if enchant.Id=="determination"then boost+=50 elseif enchant.Id=="team-up"then teamUp=math.max(teamUp,enchant.Level or 0)end end;return boost+teamUp*5 end;local function getPetsData()local data=LocalData:Get()if not data or not data.Pets then return {} end return data.Pets end;local function getEquippedTeam()local data=LocalData:Get();local equipped={};if data.Teams and data.TeamEquipped then local team=data.Teams[data.TeamEquipped];for _,id in ipairs(team.Pets or {})do equipped[id]=true end end return equipped end;local function getTopSnowflakesPets(maxTeamSize)local pets=getPetsData();local list={};for _,pet in pairs(pets)do local basePower=PetUtil:GetPower(pet,"Snowflakes")or 0;if basePower>0 then local boost=getRarityBoost(pet)+getLevelBoost(pet)+getEnchantBoost(pet);table.insert(list,{Id=pet.Id,Pet=pet,Final=math.floor(basePower*(1+boost/100))})end end;table.sort(list,function(a,b)return a.Final>b.Final end);local top={};for index=1,math.min(maxTeamSize,#list)do top[list[index].Id]=list[index].Pet end return top end;local function startAutoEquip()autoEquipThread=task.spawn(function()while getgenv().EquipBestSnowflakes do local maxTeamSize=getMaxTeamSize();local equipped=getEquippedTeam();local topPets=getTopSnowflakesPets(maxTeamSize);for id in pairs(equipped)do if not topPets[id]then RemoteEvent:FireServer("UnequipPet",id);task.wait(0.15)end end;equipped=getEquippedTeam();local count=0;for _ in pairs(equipped)do count+=1 end;for id,_ in pairs(topPets)do if not equipped[id]and count<maxTeamSize then RemoteEvent:FireServer("EquipPet",id);count+=1;task.wait(0.15)end end;task.wait(5)end end)end;ChristmasSection:CreateToggle("Equip Best Snowflakes Pets",{Title="Equip Best Snowflakes Pets",Default=false,Callback=function(state)getgenv().EquipBestSnowflakes=state;if state then startAutoEquip()else if autoEquipThread then task.cancel(autoEquipThread);autoEquipThread=nil end end end})

local autoThread=nil

local function tryReveal()
    RemoteEvent:FireServer("NotoriousOneRevealSecret")
end

local function startAutoNotorious()
    autoThread=task.spawn(function()
        while getgenv().AutoNotoriousReveal do
            local data=LocalData:Get()
            if data then
                local reveal=data.ChristmasNotoriousOneReveal
                if reveal then
                    print("[NotoriousOne] Revealed Egg:",reveal.Egg)
                    local interval=Constants.NotoriousOne.Interval or 600
                    task.wait(interval+1)
                else
                    tryReveal()
                    task.wait(1)
                end
            else
                task.wait(1)
            end
        end
    end)
end

ChristmasSection:CreateToggle("Auto Notorious One Reveal Secret",{
    Title="Auto Notorious One Reveal Secret",
    Default=false,
    Callback=function(state)
        getgenv().AutoNotoriousReveal=state
        if state then
            startAutoNotorious()
            print("[NotoriousOne] Auto Reveal STARTED")
        else
            if autoThread then
                task.cancel(autoThread)
                autoThread=nil
            end
            print("[NotoriousOne] Auto Reveal STOPPED")
        end
    end
})

-- OBBY
local ObbySection=Tabs.Aerlro:CreateSection("▶️ Obby")
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

local MasterySection=Tabs.Aerlro:CreateSection("▶ Mastery")
local MD=MasterySection:CreateDropdown("MasterySelect",{Title="Masteries",Description="Select which mastery type to auto-upgrade",Values={"Buffs","Pets","Shops","Minigames","Rifts","Christmas"},Multi=false,Default="--"})
MD:OnChanged(function(v)getgenv().MasteryConfig.Selected=v end)
local AMT=MasterySection:CreateToggle("AutoMasteryToggle",{Title="Auto Mastery",Default=false,Callback=function(v)getgenv().MasteryConfig.Auto=v if v then task.spawn(function() while getgenv().MasteryConfig.Auto do pcall(function() if getgenv().MasteryConfig.Selected then RemoteEvent:FireServer("UpgradeMastery",getgenv().MasteryConfig.Selected) end end) task.wait(0.5) end end) end end})

local AutoToggle=Tabs.Aerlro:CreateToggle("AutoGemGenieReroll",{Title="Auto Gem Genie Reroll",Default=false})AutoToggle:OnChanged(function(Value)getgenv().GenieSettings.AutoGemGenieReroll=Value end)local importantItemsList={"Dream Shard","Infinity Elixir","Secret Elixir","Shadow Crystal","Egg Elixir"}local ImportantDropdown=Tabs.Aerlro:CreateDropdown("ImportantItems",{Title="Important Items",Values=importantItemsList,Multi=true,Default=getgenv().GenieSettings.MustHave})ImportantDropdown:OnChanged(function(Value)getgenv().GenieSettings.MustHave={}for item,state in pairs(Value)do if state then table.insert(getgenv().GenieSettings.MustHave,item)end end end)getgenv().autoPressE=false local function startAutoPressE()if getgenv().autoPressE then return end getgenv().autoPressE=true task.spawn(function()while getgenv().autoPressE do VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game)task.wait()VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game)task.wait()end end)end local function stopAutoPressE()getgenv().autoPressE=false end

local function findImportantCard()local data=LocalData:Get()if not data then return nil,nil end local GenieQuest=require(RS.Shared.Data.Quests.GenieQuest)local seed=data.GemGenie.Seed if not seed then return nil,nil end if getgenv().GenieSettings.SelectedCard then local card=getgenv().GenieSettings.SelectedCard local quest=GenieQuest(data,seed+(card-1))for _,reward in pairs(quest.Rewards)do for _,wanted in ipairs(getgenv().GenieSettings.MustHave)do if reward.Name==wanted then return card,reward.Name end end end getgenv().GenieSettings.SelectedCard=nil end local validCards={}for cardIndex=1,3 do local quest=GenieQuest(data,seed+(cardIndex-1))for _,reward in ipairs(quest.Rewards)do for _,wanted in ipairs(getgenv().GenieSettings.MustHave)do if reward.Name==wanted then table.insert(validCards,{card=cardIndex,item=reward.Name})end end end end if #validCards==0 then return nil,nil end local pick=validCards[math.random(1,#validCards)]getgenv().GenieSettings.SelectedCard=pick.card return pick.card,pick.item end

local function resetTeleportCache()getgenv().GenieSettings.AlreadyTeleported={} end

local function teleportToEgg(e)local player=game.Players.LocalPlayer local character=player.Character or player.CharacterAdded:Wait()local humanoidRootPart=character:WaitForChild("HumanoidRootPart")local worlds=workspace:WaitForChild("Worlds")local overworld=worlds:WaitForChild("The Overworld")local hatchZone=overworld:WaitForChild("HatchZone")local position=hatchZone.Position humanoidRootPart.CFrame=CFrame.new(position.X,position.Y+5,position.Z)task.wait(5)local genericFolder=workspace:WaitForChild("Rendered"):WaitForChild("Generic")for _,child in pairs(genericFolder:GetChildren())do if child:FindFirstChild("Hitbox")then local hitbox=child.Hitbox if hitbox.Color==Color3.new(0,0,0)then hitbox:Destroy()child:Destroy()continue end end if child.Name:find("Coming Soon")then child:Destroy()continue end end local rendered=workspace:WaitForChild("Rendered")local eggModel=nil for _,folder in ipairs(rendered:GetChildren())do if folder:FindFirstChild(e)then eggModel=folder:FindFirstChild(e)break end end if not eggModel then return end if not eggModel:IsA("Model")then return end local safePoint=eggModel.PrimaryPart or eggModel:FindFirstChildWhichIsA("BasePart")if not safePoint and eggModel.WorldPivot then safePoint={CFrame=CFrame.new(eggModel.WorldPivot.Position)}end if not safePoint then return end humanoidRootPart.CFrame=safePoint.CFrame+Vector3.new(0,3,0)getgenv().GenieSettings.AlreadyTeleported[e]=true getgenv().GenieSettings.TeleportedEggs[e]=true getgenv().GenieSettings.LastPosition=humanoidRootPart.CFrame end

local function teleportToSpawn()local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")if not hrp then return end local worlds=workspace:FindFirstChild("Worlds")if not worlds then return end local overworld=worlds:FindFirstChild("The Overworld")if not overworld then return end local spawn=overworld:FindFirstChild("SpawnLocation")if not spawn then return end hrp.CFrame=spawn.CFrame+Vector3.new(0,3,0) task.wait(5)end

task.spawn(function()while true do task.wait(1)if not getgenv().GenieSettings.AutoGemGenieReroll then stopAutoPressE() task.wait(0.7)continue end if not LocalData:IsReady() then LocalData.DataReady:Wait() continue end local data=LocalData:Get() local gemQuest=QuestUtil:FindById(data,"gem-genie") local remainingCooldown=data and data.GemGenie and data.GemGenie.Next and (data.GemGenie.Next-TimeUtil.now()) or 0 if not gemQuest then local plm=0 while remainingCooldown>0 do task.wait(1) remainingCooldown=data.GemGenie.Next-TimeUtil.now() end end local card,item,seed=findImportantCard() if not card then RemoteEvent:FireServer("RerollGenie") task.wait(1) continue end RemoteEvent:FireServer("StartGenieQuest",card) task.wait(0.7) if not LocalData:IsReady() then LocalData.DataReady:Wait() end data=LocalData:Get() gemQuest=QuestUtil:FindById(data,"gem-genie") if not gemQuest or not gemQuest.Tasks then continue end getgenv().GenieSettings.AlreadyTeleported={} local allCompleted=false while not allCompleted and getgenv().GenieSettings.AutoGemGenieReroll do allCompleted=true for i,questTask in pairs(gemQuest.Tasks)do local requirement=QuestUtil:GetRequirement(questTask) local progress=gemQuest.Progress[i] or 0 local remaining=math.max(requirement-progress,0) if remaining>0 then allCompleted=false if questTask.Type=="Collect"then local taskStarted=false local state=nil local CollectRemote=RS.Remotes.Pickups.CollectPickup while remaining>0 and getgenv().GenieSettings.AutoGemGenieReroll do local updated=LocalData:Get() local updatedQuest=QuestUtil:FindById(updated,"gem-genie") if not updatedQuest or not updatedQuest.Tasks then break end remaining=math.max(requirement-(updatedQuest.Progress[i] or 0),0) if remaining<=0 then break end if not taskStarted then local function teleport(cf)local char=LP.Character local hrp=char and char:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame=cf+Vector3.new(0,3,0)end end teleport(CFrame.new(36.76,15970.64,41.87)) state="COLLECT" Constants.DefaultPickupRadius=math.huge taskStarted=true end local pickups=require(RS.Client.Tutorial)._activePickups local char=LP.Character local rootPart=char and char:FindFirstChild("HumanoidRootPart") if pickups and rootPart then local closest,minDist=nil,math.huge for _,pickup in pairs(pickups)do if pickup.Parent and pickup:IsA("Model") and pickup.WorldPivot then local dist=(pickup.WorldPivot.Position-rootPart.Position).Magnitude if dist<minDist then closest,minDist=pickup,dist end end end if closest then pcall(function()CollectRemote:FireServer(closest.Name)end)end end task.wait(0.5)end break end if questTask.Type=="Blow"or questTask.Type=="Bubbles"or questTask.Type=="BlowBubble"or questTask.Type=="Bubble"then local taskStarted=false while remaining>0 and getgenv().GenieSettings.AutoGemGenieReroll do local updated=LocalData:Get() local updatedQuest=QuestUtil:FindById(updated,"gem-genie") if not updatedQuest or not updatedQuest.Tasks then break end remaining=math.max(requirement-(updatedQuest.Progress[i] or 0),0) if remaining<=0 then break end if not taskStarted then taskStarted=true end pcall(function()RS.Shared.Framework.Network.Remote.RemoteEvent:FireServer("BlowBubble")end) task.wait(0.7)end break end if questTask.Type=="Hatch"then local eggName=questTask.Egg or "Common Egg" if questTask.Rarity=="Epic"or questTask.Rarity=="Legendary"then eggName="Spikey Egg" end local taskStarted=false while remaining>0 and getgenv().GenieSettings.AutoGemGenieReroll do local updated=LocalData:Get() local updatedQuest=QuestUtil:FindById(updated,"gem-genie") if not updatedQuest or not updatedQuest.Tasks then break end remaining=math.max(requirement-(updatedQuest.Progress[i] or 0),0) if remaining<=0 then break end if not taskStarted then teleportToEgg(eggName) startAutoPressE() taskStarted=true end task.wait(1)end stopAutoPressE() break end end end if not allCompleted then task.wait(0.6) if not LocalData:IsReady() then LocalData.DataReady:Wait() end gemQuest=QuestUtil:FindById(LocalData:Get(),"gem-genie") if not gemQuest or not gemQuest.Tasks then allCompleted=true end end end getgenv().GenieSettings.SelectedCard=nil end end)

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

local TeleportSection = Tabs.Aerlro:CreateSection("▶ Teleport")
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

local autoPressE=false;local EggRiftMap,ChestRiftMap={},{}
for id,data in pairs(RiftsModule)do if data.Type=="Egg"then EggRiftMap[id]=data.Egg or data.DisplayName or id elseif data.Type=="Chest"then ChestRiftMap[id]=data.DisplayName or id end end
local teleportedEggs,alreadyTeleported={},{}
local EggsSection=Tabs.Aerlro:CreateSection("▶ Eggs")
local RS=game:GetService("ReplicatedStorage")
local VIM=game:GetService("VirtualInputManager")
local LP=game:GetService("Players").LocalPlayer
local HatchEggModule=RS:FindFirstChild("Client")and RS.Client:FindFirstChild("Effects")and RS.Client.Effects:FindFirstChild("HatchEgg")and require(RS.Client.Effects.HatchEgg)
local oldPlay=HatchEggModule and HatchEggModule.Play or nil
if HatchEggModule and oldPlay then HatchEggModule.Play=function(...)if getgenv().RiftsConfig.DisableEggAnim then return end return oldPlay(...) end end
local function getEggList()local n,s={},{} local f=workspace:WaitForChild("Rendered"):GetChildren()[13] if f then for _,e in pairs(f:GetChildren())do local name=e.Name if name and not s[name] and not name:find("Coming Soon") then table.insert(n,name) s[name]=true end end end table.sort(n) return n end
EggsSection:CreateDropdown("EggSelect",{Title="Eggs",Values=getEggList(),Default=nil,Callback=function(v)getgenv().RiftsConfig.SelectedEgg=v teleportedEggs[v]=false end})
local disT=EggsSection:CreateToggle("DisableEggAnim",{Title="Disable Egg Animation",Default=false})
disT:OnChanged(function(v)getgenv().RiftsConfig.DisableEggAnim=v end)
local function teleportToEgg(e)local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if not hrp then return end local rendered=workspace:WaitForChild("Rendered"):GetChildren()[13] if not rendered then return end local eggModel=rendered:FindFirstChild(e) if not eggModel then return end local safePoint local deco=eggModel:FindFirstChild("Decoration") if deco and deco:FindFirstChild("Primary") then local primary=deco.Primary local g=primary:GetChildren()[9] if g and g:IsA("BasePart") then safePoint=g end end if safePoint and not alreadyTeleported[e] then hrp.CFrame=safePoint.CFrame+Vector3.new(0,3,0) teleportedEggs[e]=true alreadyTeleported[e]=true end getgenv().RiftsConfig.LastPosition=hrp.CFrame end
EggsSection:CreateToggle("TeleportSummonedEgg",{Title="Teleport to Summoned Egg",Default=false,Callback=function(v)getgenv().RiftsConfig.TeleportSummonedEgg=v if v then task.spawn(function() local wasSummoned=false while getgenv().RiftsConfig.TeleportSummonedEgg do local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") local summoned=workspace:FindFirstChild("SummonedEgg") local selectedEgg=getgenv().RiftsConfig.SelectedEgg if summoned and summoned:FindFirstChild("EggPlatformSpawn") then wasSummoned=true if not alreadyTeleported["SummonedEgg"] then local p=summoned.EggPlatformSpawn.PrimaryPart or summoned.EggPlatformSpawn:FindFirstChildWhichIsA("BasePart") if p and hrp then hrp.CFrame=p.CFrame+Vector3.new(0,3,0) alreadyTeleported["SummonedEgg"]=true alreadyTeleported[selectedEgg]=false end end elseif wasSummoned then wasSummoned=false alreadyTeleported["SummonedEgg"]=false if selectedEgg then alreadyTeleported[selectedEgg]=false teleportToEgg(selectedEgg) end end task.wait(1) end end) end end})
EggsSection:CreateToggle("AutoHatchEggs",{Title="Auto Hatch",Default=false,Callback=function(v)getgenv().RiftsConfig.AutoHatch=v if v then getgenv().autoPressE=true task.spawn(function() while getgenv().autoPressE do VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game) task.wait() VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game) task.wait() end end) task.spawn(function() while getgenv().RiftsConfig.AutoHatch do local egg=getgenv().RiftsConfig.SelectedEgg if egg and (not getgenv().RiftsConfig.TeleportSummonedEgg or not workspace:FindFirstChild("SummonedEgg")) then teleportToEgg(egg) end task.wait(1.5) end end) else getgenv().autoPressE=false end end})
local RiftsSection=Tabs.Aerlro:CreateSection("▶ Rifts") RiftsSection:CreateDropdown("EggRiftSelect",{Title="Egg Rifts",Values=(function()local t={}for _,v in pairs(EggRiftMap)do table.insert(t,v)end table.sort(t)return t end)(),Multi=false,Default=nil,Callback=function(v)for k,val in pairs(EggRiftMap)do if val==v then getgenv().RiftsConfig.SelectedEggRift=k break end end end}) RiftsSection:CreateDropdown("IgnoreMultiplier",{Title="Ignore Egg Rift Multipliers",Values={1,2,5,10,15,20,25},Multi=true,Default={},Callback=function(vals)local s={}for k,v in pairs(vals)do if v==true then local num=tonumber(k)if num then s[num]=true end end end getgenv().RiftsConfig.IgnoreMultiplier=s end}) RiftsSection:CreateToggle("TeleportEggRiftToggle",{Title="Teleport to Egg Rift",Default=false,Callback=function(v)getgenv().RiftsConfig.TeleportEggRift=v autoPressE=v if v then task.spawn(function()while autoPressE do VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game) task.wait() VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game) task.wait() end end) end end}) RiftsSection:CreateDropdown("ChestRiftSelect",{Title="Chest Rifts",Values=(function()local t={}for _,v in pairs(ChestRiftMap)do table.insert(t,v)end table.sort(t)return t end)(),Multi=false,Default=nil,Callback=function(v)for k,val in pairs(ChestRiftMap)do if val==v then getgenv().RiftsConfig.SelectedChestRift=k break end end end}) RiftsSection:CreateToggle("TeleportChestRiftToggle",{Title="Teleport to Chest Rift",Default=false,Callback=function(v)getgenv().RiftsConfig.TeleportChestRift=v autoPressE=v if v then task.spawn(function()while autoPressE do VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game) task.wait() VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game) task.wait() end end) end end}) local function getRiftMultiplier(r)for _,d in ipairs(r:GetDescendants())do if d:IsA("TextLabel")or d:IsA("TextBox")then local t=d.Text:lower() local m=t:match("(%d+)%s*x")or t:match("x%s*(%d+)") if m then return tonumber(m)end end end return nil end local function teleportTo(pos)local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if hrp and pos then hrp.CFrame=CFrame.new(pos+Vector3.new(0,5,0))end end local alreadyTeleported={} RunService.Heartbeat:Connect(function() local cfg=getgenv().RiftsConfig for _,r in pairs(workspace:GetDescendants())do if r:IsA("Model")then local id=r:GetDebugId()or(r.Name..game.JobId) if alreadyTeleported[id]then continue end if cfg.TeleportEggRift and cfg.SelectedEggRift and r.Name==cfg.SelectedEggRift then local platform=r:FindFirstChild("EggPlatformSpawn") if platform then local part=platform.PrimaryPart or platform:FindFirstChildWhichIsA("BasePart") if part then local m=getRiftMultiplier(r) if not m or not cfg.IgnoreMultiplier[m]then teleportTo(part.Position) alreadyTeleported[id]=true end end end end if cfg.TeleportChestRift and cfg.SelectedChestRift and r.Name==cfg.SelectedChestRift then local part=r.PrimaryPart or r:FindFirstChildWhichIsA("BasePart") if part then teleportTo(part.Position) alreadyTeleported[id]=true end end end end end)

-- Pet Enchant Section
local EnchantSection = Tabs.Aerlro:CreateSection("▶️ Pet Enchant")

-- Build enchant options
local enchantOptions = {"Anything"}
for enchantId, enchantData in pairs(EnchantsModule) do
    local displayName = enchantData.DisplayName or enchantId
    local emoji = enchantData.Emoji or ""
    local levels = enchantData.Levels or 1
    if levels > 1 then
        for i = 1, levels do
            table.insert(enchantOptions, string.format("%s %d %s", displayName, i, emoji))
        end
    else
        table.insert(enchantOptions, string.format("%s %s", displayName, emoji))
    end
end
table.sort(enchantOptions)

-- Slot dropdowns
local Slot1Dropdown = EnchantSection:CreateDropdown("EnchantSlot1", {
    Title = "Enchant for Slot 1",
    Multi = false,
    Values = enchantOptions,
    Default = "Anything"
})
Slot1Dropdown:OnChanged(function(v)
    getgenv().EnchantConfig.Slot1 = v
end)

local Slot2Dropdown = EnchantSection:CreateDropdown("EnchantSlot2", {
    Title = "Enchant for Slot 2",
    Multi = false,
    Values = enchantOptions,
    Default = "Anything"
})
Slot2Dropdown:OnChanged(function(v)
    getgenv().EnchantConfig.Slot2 = v
end)

-- Method dropdown with Shadow Crystal Only
local MethodDropdown = EnchantSection:CreateDropdown("EnchantMethod", {
    Title = "Method",
    Multi = false,
    Values = {"Gems Only", "Orbs Only", "Gems First Orbs Second", "Shadow Crystal First Orbs Second", "Shadow Crystal Only"},
    Default = "Gems Only"
})
MethodDropdown:OnChanged(function(v)
    getgenv().EnchantConfig.EnchantMethod = v
end)

-- Team dropdown
local function getTeamNames()
    local t = {}
    local d = LocalData:Get()
    if d and d.Teams then
        for i,_ in pairs(d.Teams) do
            table.insert(t, "Team "..i)
        end
    end
    return t
end

local TeamsDropdown = EnchantSection:CreateDropdown("TeamsList", {
    Title = "Teams",
    Multi = false,
    Values = getTeamNames(),
    Default = "--"
})
TeamsDropdown:OnChanged(function(v)
    local n
    if type(v) == "table" then
        for k, s in pairs(v) do
            if s then
                n = tonumber(string.match(k, "%d+"))
                break
            end
        end
    else
        n = tonumber(string.match(v, "%d+"))
    end
    if n then getgenv().EnchantConfig.SelectedTeam = n end
end)

-- Auto enchant toggle
local AutoToggle = EnchantSection:CreateToggle("AutoEnchantToggle", {
    Title = "Auto Enchant",
    Default = false
})
AutoToggle:OnChanged(function(v)
    getgenv().EnchantConfig.AutoEnchantActive = v
end)

local DeleteSection=Tabs.Aerlro:CreateSection("▶️ Auto Delete Pets")local RarityDropdown=DeleteSection:CreateDropdown("PetRarities",{Title="Rarities",Multi=true,Values={"Common","Unique","Rare","Epic","Legendary Tier 1","Legendary Tier 2","Legendary Tier 3"},Default={}})RarityDropdown:OnChanged(function(v)getgenv().PetsConfig.SelectedDeleteRarities={}for r,s in pairs(v)do if s then getgenv().PetsConfig.SelectedDeleteRarities[r]=true end end end)local uniqueTags={}for _,d in pairs(petsModule)do if type(d)=="table"and d.Tag and d.Tag~=""then uniqueTags[d.Tag]=true end end local tagList={}for t in pairs(uniqueTags)do table.insert(tagList,t)end table.sort(tagList)local IgnoreTagsDropdown=DeleteSection:CreateDropdown("IgnoreTags",{Title="Ignore Tags",Multi=true,Values=tagList,Default={}})IgnoreTagsDropdown:OnChanged(function(v)getgenv().PetsConfig.IgnoreTags={}for t,s in pairs(v)do if s then getgenv().PetsConfig.IgnoreTags[t]=true end end end)local DeleteToggle=DeleteSection:CreateToggle("AutoDeletePets",{Title="Delete Pets",Default=false})DeleteToggle:OnChanged(function(state)getgenv().PetsConfig.AutoDelete=state;if not state then return end;task.spawn(function()while getgenv().PetsConfig.AutoDelete do local pets=playerData.Pets;for _,pet in pairs(pets)do local info=petsModule[pet.Name]if info then local r=info.Rarity or"Unknown"local tier=info.Tier and("Legendary Tier "..tostring(info.Tier))or nil local amt=pet.Amount or 1 if info.Tag and getgenv().PetsConfig.IgnoreTags[info.Tag]then continue end local shouldDelete=false;if getgenv().PetsConfig.SelectedDeleteRarities[r]then shouldDelete=true elseif r=="Legendary"and tier and getgenv().PetsConfig.SelectedDeleteRarities[tier]then shouldDelete=true end;if shouldDelete then local args={"DeletePet",pet.Id,amt,false}RS.Shared.Framework.Network.Remote.RemoteEvent:FireServer(unpack(args))task.wait(0.15)end end end task.wait(3)end end)end)
local ShinySection=Tabs.Aerlro:CreateSection("▶️ Auto Shiny Pets")local ShinyRarityDropdown=ShinySection:CreateDropdown("ShinyRarities",{Title="Rarities",Multi=true,Values={"Common","Unique","Rare","Epic","Legendary Tier 1","Legendary Tier 2","Legendary Tier 3","Secret"},Default={}})ShinyRarityDropdown:OnChanged(function(v)getgenv().PetsConfig.SelectedShinyRarities={}for r,s in pairs(v)do if s then getgenv().PetsConfig.SelectedShinyRarities[r]=true end end end)local ShinyIgnoreTagsDropdown=ShinySection:CreateDropdown("IgnoreTags",{Title="Ignore Tags",Multi=true,Values=tagList,Default={}})ShinyIgnoreTagsDropdown:OnChanged(function(v)getgenv().PetsConfig.IgnoreTags={}for t,s in pairs(v)do if s then getgenv().PetsConfig.IgnoreTags[t]=true end end end)local ShinyToggle=ShinySection:CreateToggle("AutoShiny",{Title="Auto Shiny",Default=false})ShinyToggle:OnChanged(function(state)getgenv().PetsConfig.AutoShiny=state;if not state then return end;task.spawn(function()while getgenv().PetsConfig.AutoShiny do local pets=playerData.Pets;table.sort(pets,function(a,b)return(a.Amount or 0)>(b.Amount or 0)end)for _,pet in pairs(pets)do local info=petsModule[pet.Name]if info then local r=info.Rarity or"Unknown"local tier=info.Tier and("Legendary Tier "..tostring(info.Tier))or nil local tag=info.Tag;if tag and getgenv().PetsConfig.IgnoreTags[tag]then continue end local shouldShiny=false;if getgenv().PetsConfig.SelectedShinyRarities[r]then shouldShiny=true elseif r=="Legendary"and tier and getgenv().PetsConfig.SelectedShinyRarities[tier]then shouldShiny=true end;if shouldShiny then local args={"MakePetShiny",pet.Id,math.min(pet.Amount or 1,1)}RS.Shared.Framework.Network.Remote.RemoteEvent:FireServer(unpack(args))task.wait(0.2)end end end task.wait(3)end end)end)
local OtherSection=Tabs.Aerlro:CreateSection("▶️ Power Orb")
local AutoPowerOrbToggle=OtherSection:CreateToggle("AutoPowerOrbToggle",{Title="Auto Power Orb to Equipped Team",Default=false})
AutoPowerOrbToggle:OnChanged(function(v)getgenv().EnchantConfig.AutoPowerOrbActive=v end)
task.spawn(function()while true do task.wait(0.5)if not getgenv().EnchantConfig.AutoPowerOrbActive then continue end local d=LocalData:Get()if not(d and d.Teams)then continue end local tI=getgenv().EnchantConfig.SelectedTeam or d.TeamEquipped local t=tI and d.Teams[tI]if not t or not t.Pets then continue end for _,pId in ipairs(t.Pets)do if not getgenv().EnchantConfig.AutoPowerOrbActive then break end task.spawn(function()pcall(function()RemoteEvent:FireServer("UsePowerOrb",pId)end)end)task.wait(0.1)end end end)

-- Utility functions
local function findPetById(id)
    local d = LocalData:Get()
    if not (d and d.Pets) then return nil end
    for _, p in ipairs(d.Pets) do
        if p.Id == id then return p end
    end
    return nil
end

local function slotHasDesired(p, s, d)
    if d == "Anything" then return (p.Enchants and p.Enchants[s] ~= nil) end
    local e = (p.Enchants or {})[s]
    if not e then return false end
    local i = EnchantsModule[e.Id]
    if not i then return false end
    local n = i.DisplayName or e.Id
    local l = e.Level or 1
    local emoji = i.Emoji or ""
    local str = (i.Levels > 1) and string.format("%s %d %s", n, l, emoji) or string.format("%s %s", n, emoji)
    return str == d
end

local function petHasDesiredEnchantSlot(p, s)
    local m = getgenv().EnchantConfig.EnchantMethod
    local s1 = getgenv().EnchantConfig.Slot1
    local s2 = getgenv().EnchantConfig.Slot2
    if m == "Gems Only" or m == "Orbs Only" or m == "Shadow Crystal Only" then
        if s1 == s2 then
            local ts = (p.Shiny or p.ShinyMythic) and 2 or 1
            for i = 1, ts do
                if slotHasDesired(p, i, s1) then return true end
            end
            return false
        end
    end
    if s == 1 then return slotHasDesired(p, 1, s1)
    else return slotHasDesired(p, 2, s2) end
end

-- Main auto-enchant task
task.spawn(function()
    while task.wait(0.5) do
        if not getgenv().EnchantConfig.AutoEnchantActive then continue end
        local d = LocalData:Get()
        if not (d and d.Teams) then continue end
        local tI = getgenv().EnchantConfig.SelectedTeam or d.TeamEquipped
        local t = tI and d.Teams[tI]
        if not t or not t.Pets then continue end

        for _, pId in ipairs(t.Pets) do
            if not getgenv().EnchantConfig.AutoEnchantActive then break end
            local p = findPetById(pId)
            if not p then continue end

            local ts = (p.Shiny or p.ShinyMythic) and 2 or 1
            local st = {}
            for i = 1, ts do st[i] = petHasDesiredEnchantSlot(p, i) end

            for _ = 1, ts do
                if not getgenv().EnchantConfig.AutoEnchantActive then break end
                local tg = nil
                for i = 1, ts do
                    if not st[i] then tg = i break end
                end
                if not tg then break end

                local a = 0
                while getgenv().EnchantConfig.AutoEnchantActive and not petHasDesiredEnchantSlot(p, tg) do
                    local m = getgenv().EnchantConfig.EnchantMethod
                    print("[DEBUG] PetId:", pId, "Slot:", tg, "Method:", m)

                    if m == "Gems Only" then
                        if tg == 1 then
                            print("[DEBUG] Gems Only → Slot 1")
                            RemoteFunction:InvokeServer("RerollEnchants", pId, "Gems")
                        else
                            print("[DEBUG] Gems Only → Slot 2")
                            RemoteFunction:InvokeServer("RerollEnchants", pId, "Gems", 1)
                        end
                    elseif m == "Orbs Only" then
                        if tg == 1 then
                            print("[DEBUG] Orbs Only → Slot 1")
                            RemoteEvent:FireServer("RerollEnchant", pId, 1)
                        elseif tg == 2 and ts == 2 then
                            print("[DEBUG] Orbs Only → Slot 2")
                            RemoteEvent:FireServer("RerollEnchant", pId, 2)
                        else
                            print("[DEBUG] Orbs Only → Ignoring Slot 2 (pet only has 1 slot)")
                        end
                    elseif m == "Gems First Orbs Second" then
                        if tg == 1 then
                            RemoteFunction:InvokeServer("RerollEnchants", pId, "Gems")
                        else
                            RemoteEvent:FireServer("RerollEnchant", pId, tg)
                        end
                    elseif m == "Shadow Crystal First Orbs Second" then
                        if tg == 1 then
                            local ok = pcall(function() RemoteEvent:FireServer("UseShadowCrystal", pId) end)
                            if not ok then
                                RemoteFunction:InvokeServer("RerollEnchants", pId, "Orbs")
                            end
                        else
                            RemoteEvent:FireServer("RerollEnchant", pId, tg)
                        end
                    elseif m == "Shadow Crystal Only" then
                        if tg == 1 then
                            RemoteEvent:FireServer("UseShadowCrystal", pId)
                        else
                            RemoteEvent:FireServer("UseShadowCrystal", pId, 1)
                        end
                    end

                    -- cooldown between rerolls
                    for _ = 1, math.floor(COOLDOWN_BETWEEN_REROLLS * 10) do
                        if not getgenv().EnchantConfig.AutoEnchantActive then break end
                        task.wait(0.1)
                    end
                    if not getgenv().EnchantConfig.AutoEnchantActive then break end
                    p = findPetById(pId)
                    a += 1
                    if a >= 100000 then break end
                end

                if not getgenv().EnchantConfig.AutoEnchantActive then break end
                st[tg] = true
            end
        end
    end
end)
 
local cfg=getgenv().ShopsConfig or{}local function tableToString(t)if type(t)~="table"then return tostring(t)end local r={}for k,v in pairs(t)do local key=tostring(k)local value if type(v)=="table"then value=tableToString(v)else value=tostring(v)end table.insert(r,key.."="..value)end return "{"..table.concat(r,",").."}"end ShopsSection=Tabs.Aerlro:CreateSection("▶️ Shops & Items")ShopsSection:AddToggle("BuyAllItems",{Title="Buy All",Default=cfg.BuyAll or false,Callback=function(v)cfg.BuyAll=v end})for shopName,shopInfo in pairs(ShopsData)do local section=Tabs.Aerlro:AddSection("▶ "..shopName)local itemList={} local function extractItems(tbl)if not tbl then return end for _,v in pairs(tbl)do if type(v)=="table"then if v.Product and v.Product.Name then local name,lvl=v.Product.Name,v.Product.Level or 1 if table.find({"Speed","Lucky","Mythic","Coins","Tickets"},name)then itemList[name.." "..lvl]=true else itemList[name]=true end else extractItems(v)end end end end extractItems(shopInfo) local dropdownItems={}for k in pairs(itemList)do table.insert(dropdownItems,k)end table.sort(dropdownItems) section:AddDropdown(shopName.."Dropdown",{Title="Select Items",Values=dropdownItems,Multi=true,Default=cfg[shopName.."SelectedItems"] or {},Callback=function(v)local selected={}for k,state in pairs(v)do if state then table.insert(selected,k)end end cfg[shopName.."SelectedItems"]=selected end}) section:AddToggle(shopName.."AutoBuy",{Title="Auto Buy",Default=cfg[shopName.."AutoBuy"] or false,Callback=function(v)cfg[shopName.."AutoBuy"]=v end}) section:AddToggle(shopName.."AutoReroll",{Title="Auto Reroll",Default=cfg[shopName.."AutoReroll"] or false,Callback=function(v)cfg[shopName.."AutoReroll"]=v end})end local function buyShopItem(shopName,index,all)pcall(function()RemoteEvent:FireServer("BuyShopItem",shopName,index,all)end)end local function checkShop(shopName)local playerData=LocalData:Get()if not playerData then return end local shopInfo=playerData.Shops[shopName] or {Bought={}}local itemsData,stockData=ShopUtil:GetItemsData(shopName,playerData,playerData,playerData)local selected=cfg[shopName.."SelectedItems"] or {} for i,item in ipairs(itemsData)do if item and item.Product then local name=item.Product.Name local lvl=item.Product.Level or 1 local baseStock=stockData[i] or 0 local bought=shopInfo.Bought[i] or 0 local remaining=math.max(baseStock-bought,0) local isSelected=false for _,sel in ipairs(selected)do local E,F=sel:match("^(.-) (%d+)$") F=F and tonumber(F) or nil if(E and E==name and F==lvl)or(not E and sel==name)then isSelected=true break end end if isSelected and remaining>0 and cfg[shopName.."AutoBuy"]then if cfg.BuyAll then buyShopItem(shopName,i,true)else local count=0 while count<remaining and cfg[shopName.."AutoBuy"]do buyShopItem(shopName,i,false)count+=1 remaining-=1 task.wait(0.1)end end end end end end task.spawn(function()while true do for shopName,_ in pairs(ShopsData)do if cfg[shopName.."AutoBuy"]then checkShop(shopName)end end task.wait(0.2)end end) task.spawn(function()while true do for shopName,_ in pairs(ShopsData)do if cfg[shopName.."AutoReroll"]then pcall(function()RemoteEvent:FireServer("ShopFreeReroll",shopName)end)end end task.wait(0.5)end end) RemoteEvent.OnClientEvent:Connect(function(eventName,...)if eventName=="ItemsReceived"or eventName=="ShopsRestocked"then end end)

-- minigames
local a = {}
for _, b in ipairs(BoardUtil.Nodes) do
    if b.Type then
        a[b.Type] = a[b.Type] or {}
        table.insert(a[b.Type], b)
    end
end

local c = {}
for tileType, _ in pairs(a) do
    table.insert(c, tileType)
end
table.sort(c)

local DiceSection = Tabs.Aerlro:CreateSection("▶️ Dice Board")

local TargetDropdown = DiceSection:CreateDropdown("TargetBoardTiles", {
    Title = "Target Board Tiles",
    Multi = true,
    Values = c,
    Default = {}
})

TargetDropdown:OnChanged(function(Value)
    local selected = {}
    for tileType, enabled in pairs(Value) do
        if enabled then
            table.insert(selected, tileType)
        end
    end
    getgenv().selectedTileTypes = selected
end)

local RangeInput = DiceSection:CreateInput("GoldenDiceRange", {
    Title = "Golden Dice Range",
    Default = tostring(getgenv().boardSettings.GoldenDiceDistance),
    Numeric = true,
    Finished = true
})

RangeInput:OnChanged(function(v)
    local n = tonumber(v)
    if n and n > 0 then
        getgenv().boardSettings.GoldenDiceDistance = n
    end
end)

local AutoRollToggle = DiceSection:CreateToggle("AutoDiceRoll", {
    Title = "Auto Dice Roll",
    Default = false
})

AutoRollToggle:OnChanged(function(v)
    getgenv().autoRoll = v
end)

local function safeData()
    local ok, result = pcall(function() return LocalData:Get() end)
    if ok and result then return result end
    return {}
end

local function getGoldenCount()
    local d = safeData()
    if type(d.Powerups) == "table" then
        return d.Powerups["Golden Dice"] or 0
    end
    return 0
end

local function stepsToNode(p, n)
    if not p or not p.Index then return nil end
    local total = #BoardUtil.Nodes
    local start = p.Index
    for i = 1, total do
        local idx = (start + i - 1) % total + 1
        if BoardUtil.Nodes[idx] == n then
            return i
        end
    end
    return nil
end

local function simulateRolls(p, diceType)
    local maxRoll = BoardUtil.Dice[diceType] or 6
    local results = {}
    for roll = 1, maxRoll do
        local newIndex = (p.Index + roll - 1) % #BoardUtil.Nodes + 1
        table.insert(results, newIndex)
    end
    return results
end

local function pickDice(p)
    if not p then return "Dice" end

    local golden = getGoldenCount()
    local selected = getgenv().selectedTileTypes or {}

    if golden <= 0 or #selected == 0 then
        return "Dice"
    end

    local bestDist = math.huge
    local bestNode = nil

    for _, tileType in ipairs(selected) do
        for _, node in ipairs(a[tileType] or {}) do
            local dist = stepsToNode(p, node)
            if dist and dist < bestDist then
                bestDist = dist
                bestNode = node
            end
        end
    end

    if not bestNode then
        return "Dice"
    end

    if bestDist == getgenv().boardSettings.GoldenDiceDistance then
        return "Golden Dice"
    end

    return "Dice"
end

local function rollDice(diceType)
    if not diceType then return end
    local ok, result = pcall(function()
        return RemoteFunction:InvokeServer("RollDice", diceType)
    end)
    if ok then return result end
    return nil
end

local function claimTile()
    pcall(function()
        RemoteEvent:FireServer("ClaimTile")
    end)
end

task.spawn(function()
    while true do
        if getgenv().autoRoll then
            local p = Board.Pieces and Board.Pieces[LocalPlayer.Name]
            if p then
                local diceType = pickDice(p)
                local result = rollDice(diceType)
                if result then
                    local tileIndex =
                        result.Tile and result.Tile.Index or
                        result.Index or
                        (type(result) == "number" and result)

                    if tileIndex then
                        p.Index = tileIndex
                        claimTile()
                    end
                end
            end
        end
        task.wait(1)
    end
end)

local minigames = {}    
for name,_ in pairs(minigamesModule) do    
    table.insert(minigames, name)    
end    
table.sort(minigames)    
    
local difficulties = {"Easy","Medium","Hard","Insane"}    
    
local a = Tabs.Aerlro:CreateSection("▶ Minigames")    
    
local b = a:CreateDropdown("SelectDifficulty", {    
    Title = "Select Minigame Difficulty",    
    Description = "Choose the difficulty",    
    Values = difficulties,    
    Multi = false,    
    Default = MinigamesConfig.SelectedDifficulty or "",    
    Callback = function(c)    
        MinigamesConfig.SelectedDifficulty = c    
    end    
})    
    
local d = a:CreateDropdown("SuperTicketSelect", {    
    Title = "Select Minigame To Use Super Ticket",    
    Description = "Choose which minigame to use",    
    Values = minigames,    
    Multi = false,    
    Default = MinigamesConfig.SuperTicketGame or "",    
    Callback = function(c)    
        MinigamesConfig.SuperTicketGame = c    
    end    
})    
    
local function e(...)    
    local args = {...}    
    pcall(function()    
        RemoteEvent:FireServer(unpack(args))    
    end)    
end    
    
local function g(minigame, difficulty)
    if MinigamesConfig.AutoRun[minigame] and MinigamesConfig.AutoRun[minigame][difficulty] then return end
    MinigamesConfig.AutoRun[minigame] = MinigamesConfig.AutoRun[minigame] or {}
    MinigamesConfig.AutoRun[minigame][difficulty] = true

    task.spawn(function()
        local player = game:GetService("Players").LocalPlayer
        local minigameHUD = player.PlayerGui:WaitForChild("ScreenGui"):WaitForChild("MinigameHUD")

        -- Ascunde HUD-ul
        for _, guiObject in ipairs(minigameHUD:GetChildren()) do
            if guiObject:IsA("GuiObject") then
                guiObject.Visible = false
            end
        end

        while MinigamesConfig.AutoRun[minigame][difficulty] do
            RemoteEvent:FireServer("StartMinigame", minigame, difficulty)
            task.wait(3)
            RemoteEvent:FireServer("FinishMinigame")
            task.wait(2)
            if MinigamesConfig.SuperTicketGame == minigame then
                RemoteEvent:FireServer("SkipMinigameCooldown", minigame)
            end
            task.wait(1.5)
        end

        -- Reactivare HUD după oprire
        for _, guiObject in ipairs(minigameHUD:GetChildren()) do
            if guiObject:IsA("GuiObject") then
                guiObject.Visible = true
            end
        end
    end)
end
    
local function j(minigame, difficulty)    
    if MinigamesConfig.AutoRun[minigame] then    
        MinigamesConfig.AutoRun[minigame][difficulty] = false    
    end    
end    
    
for _, k in ipairs(minigames) do    
    MinigamesConfig.AutoRun[k] = MinigamesConfig.AutoRun[k] or {}    
    
    local l = a:CreateToggle("Auto"..k:gsub(" ",""), {    
        Title = "Auto "..k,    
        Default = MinigamesConfig.SelectedDifficulty and MinigamesConfig.AutoRun[k][MinigamesConfig.SelectedDifficulty] or false    
    })    
    
    l:OnChanged(function(enabled)    
        local difficulty = MinigamesConfig.SelectedDifficulty    
        if not difficulty then return end    
        if enabled then    
            g(k, difficulty)    
        else    
            j(k, difficulty)    
        end    
    end)    
    
    if MinigamesConfig.SelectedDifficulty and MinigamesConfig.AutoRun[k][MinigamesConfig.SelectedDifficulty] then    
        task.spawn(function()    
            g(k, MinigamesConfig.SelectedDifficulty)    
        end)    
    end    
end

local Chests=require(RS.Shared.Data.Chests)local ChestList={}for chestName,_ in pairs(Chests)do table.insert(ChestList,chestName)end;table.sort(ChestList)Tabs.Aerlro:CreateSection("▶ Island Chests")local ChestDropdown=Tabs.Aerlro:CreateDropdown("ChestSelect",{Title="Select Chests",Description="Choose which chests to auto claim",Values=ChestList,Multi=true,Default={}})ChestDropdown:OnChanged(function(values)getgenv().MiscConfig.SelectedChests={}for chestName,isSelected in pairs(values)do if isSelected then table.insert(getgenv().MiscConfig.SelectedChests,chestName)end end end)local ChestToggle=Tabs.Aerlro:CreateToggle("AutoIslandChests",{Title="Auto Island Chests",Default=false})ChestToggle:OnChanged(function(value)getgenv().MiscConfig.AutoIslandChests=value end)task.spawn(function()while true do local config=getgenv().MiscConfig;if config.AutoIslandChests and #config.SelectedChests>0 then local data=LocalData:Get()if data and data.Cooldowns then for _,chestName in ipairs(config.SelectedChests)do local cooldown=data.Cooldowns[chestName]or 0;if os.time()>=cooldown then pcall(function()RemoteEvent:FireServer("ClaimChest",chestName)end)task.wait(1)end end end end;task.wait(2)end end)
  
local ShrineSection=Tabs.Aerlro:AddSection("▶ Shrines")local potionList={}for _,p in ipairs(ShrineValues)do local n=p.Name;if p.Type=="Potion"and p.Level then n=n.." "..p.Level end table.insert(potionList,n)end table.sort(potionList)ShrineSection:AddDropdown("SelectPotion",{Title="Potions",Values=potionList,Multi=false,Default=nil,Callback=function(v)getgenv().MiscConfig.SelectedPotion=v end})ShrineSection:AddInput("PotionQuantity",{Title="Quantity",Default="1",Numeric=true,Finished=false,Callback=function(v)getgenv().MiscConfig.PotionQuantity=math.clamp(tonumber(v)or 1,1,1000)end})ShrineSection:AddToggle("AutoDonateShrine",{Title="Auto Donate Shrine",Default=false,Callback=function(v)getgenv().MiscConfig.AutoDonateShrine=v end})local function getPotionByName(n)for _,p in ipairs(ShrineValues)do local name=p.Name;if p.Type=="Potion"and p.Level then name=name.." "..p.Level end if name==n then return p end end end local function shrineOnCooldown()local d=LocalData:Get()if not d or not d.Shrines or not d.Shrines.BubbleShrine then return false end local s=d.Shrines.BubbleShrine;return os.time()<(s.ShrineBlessingEndTime or 0)end task.spawn(function()while true do local cfg=getgenv().MiscConfig;if cfg.AutoDonateShrine and cfg.SelectedPotion then local p=getPotionByName(cfg.SelectedPotion)if p then local q=math.clamp(cfg.PotionQuantity or 1,1,1000)if not shrineOnCooldown() then pcall(function()RemoteFunction:InvokeServer("DonateToShrine",{Type=p.Type,Name=p.Name,Level=p.Level or 1,Amount=q,XP=p.XP})end)end end end task.wait(0.5)end end)

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

local PowerupsSection=Tabs.Aerlro:CreateSection("▶ Powerups") local eggList={} for name,_ in pairs(Powerups)do if string.find(name:lower(),"egg")then table.insert(eggList,name)end end table.sort(eggList) local EggDropdown=PowerupsSection:AddDropdown("PowerupsEggsSelect",{Title="Select Powerup Egg",Values=eggList,Multi=false,Default=getgenv().MiscConfig.SelectedPowerupEgg or nil,Callback=function(v)getgenv().MiscConfig.SelectedPowerupEgg=v end}) PowerupsSection:AddToggle("AutoHatchPowerupsEggs",{Title="Auto Hatch Powerups Eggs",Default=getgenv().MiscConfig.AutoHatchPowerupsEggs or false,Callback=function(v)getgenv().MiscConfig.AutoHatchPowerupsEggs=v end}) local function hatchEgg(e)pcall(function()RemoteEvent:FireServer("HatchPowerupEgg",e,12)end)end task.spawn(function()while true do local cfg=getgenv().MiscConfig if cfg.AutoHatchPowerupsEggs and cfg.SelectedPowerupEgg then hatchEgg(cfg.SelectedPowerupEgg)end task.wait(0.5)end end)
local boxList={}for name,info in pairs(Powerups)do if info.Type=="Gift"then table.insert(boxList,name)end end;PowerupsSection:AddDropdown("BoxesSelect",{Title="Select Box",Values=boxList,Multi=false,Default=getgenv().MiscConfig.SelectedBox or nil,Callback=function(v)getgenv().MiscConfig.SelectedBox=v end})PowerupsSection:AddToggle("AutoOpenBoxes",{Title="Auto Open Boxes",Default=getgenv().MiscConfig.AutoOpenBoxes or false,Callback=function(v)getgenv().MiscConfig.AutoOpenBoxes=v end})local function hasBoxAvailable(box)local ok,data=pcall(function()return LocalData:Get()end)if not ok or not data or not data.Powerups then return false end;return data.Powerups[box] and data.Powerups[box]>0 end;local function useBox(box)if hasBoxAvailable(box)then pcall(function()RemoteEvent:FireServer("UseGift",box,50)end)end end;local function tapNearbyGifts()pcall(function()local gifts=PhysicalItem:GetActiveGifts()local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if not hrp then return end;for _,gift in pairs(gifts)do if gift and gift.InRange and gift.Hit then gift:Hit()end end end)end;task.spawn(function()while true do local cfg=getgenv().MiscConfig;if cfg.AutoHatchPowerupsEggs and cfg.SelectedPowerupEgg then hatchEgg(cfg.SelectedPowerupEgg)end;if cfg.AutoOpenBoxes and cfg.SelectedBox then useBox(cfg.SelectedBox)tapNearbyGifts()end;task.wait(0.1)end end)

Tabs.Aerlro:CreateSection("▶ Wheel Spins")
Tabs.Aerlro:CreateToggle("AutoWheelSpin",{Title="Auto Wheel Spin",Default=false,Callback=function(v)getgenv().MiscConfig.AutoWheelSpin=v end})
Tabs.Aerlro:CreateToggle("AutoChristmasWheelSpin",{Title="Auto Christmas Wheel Spin",Default=false,Callback=function(v)getgenv().MiscConfig.AutoChristmasWheelSpin=v end})
Tabs.Aerlro:CreateInput("WheelSpinDelay",{Title="Wheel Spin Delay (sec)",Default=tostring(getgenv().MiscConfig.WheelSpinDelay),Numeric=true,Finished=true,Callback=function(v)getgenv().MiscConfig.WheelSpinDelay=tonumber(v)or 0.01 end})

task.spawn(function()while true do local cfg=getgenv().MiscConfig if cfg.AutoWheelSpin or cfg.AutoFestivalWheelSpin then pcall(function() if cfg.AutoWheelSpin then RemoteFunction:InvokeServer("WheelSpin") RemoteEvent:FireServer("ClaimWheelSpinQueue") end if cfg.AutoFestivalWheelSpin then RemoteFunction:InvokeServer("ChristmasWheelSpin") RemoteEvent:FireServer("ClaimChristmasWheelSpinQueue") end end) end task.wait(cfg.WheelSpinDelay) end end)

InterfaceManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:SetIgnoreIndexes{}
InterfaceManager:SetFolder("OTC2")
SaveManager:SetFolder("OTC2")
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
Window:SelectTab(1)
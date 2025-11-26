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
local humanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local LocalData = require(RS.Client.Framework.Services.LocalData)
local playerData = LocalData:Get()
playerData.UserId=LocalPlayer.UserId
local failedFile = "FailedWebhooks.json"

local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

-- global farming config
getgenv().FarmingConfig={AutoPickup=false,AutoBubble=false,AutoBubbleSell=false,AutoGoldenOrb=false,AutoFishing=false,BubbleSellMode=nil,BubbleSellInterval=3,BubbleSellLocation=nil}
getgenv().ObbyConfig={Enabled=false,AutoChest=false,Difficulties={}}
getgenv().MasteryConfig={Selected=nil,Auto=false}
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
    Aerlro = Window:CreateTab{ Title = "Aerlro", Icon = "rbxassetid://140431377231411" },
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

-- FISHING
local FishingSection=Tabs.Aerlro:CreateSection("▶ Fishing")
FishingSection:CreateToggle("AutoFishingWorld3",{Title="Auto Fishing (World 3)",Default=false,Callback=function(v)getgenv().FarmingConfig.AutoFishing=v if v then task.spawn(function() while getgenv().FarmingConfig.AutoFishing do pcall(function() local AFM=RS.Client.Gui.Frames.Fishing.FishingWorldAutoFish local AFC=require(AFM) AFC.IsEnabled=function()return true end local FUtil=require(RS.Shared.Utils.FishingUtil) FUtil.CAST_TIMEOUT,FUtil.MIN_FISH_BITE_DELAY,FUtil.MAX_FISH_BITE_DELAY,FUtil.BASE_REEL_SPEED,FUtil.BASE_MUTATION_CHANCE,FUtil.BASE_FINISH_WINDOW,FUtil.WALL_CLICK_COOLDOWN=0,0,0,math.huge,math.huge,0,0 local BaitData=require(RS.Shared.Data.FishingBait) local sorted={} for n,b in pairs(BaitData)do table.insert(sorted,{Name=n,Order=b.LayoutOrder}) end table.sort(sorted,function(a,b)return a.Order>b.Order end) local baitInv=(LocalData:Get()or {}).BaitInventory if baitInv then for _,b in ipairs(sorted)do if baitInv[b.Name] and baitInv[b.Name]>0 then if LocalPlayer:GetAttribute("EquippedBait")~=b.Name then RemoteEvent:FireServer("SetEquippedBait",b.Name);task.wait(0.5) end break end end end end) task.wait(1) end end) end end})
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

local EggRiftMap, ChestRiftMap = {}, {}

for id, data in pairs(RiftsModule) do
    if data.Type == "Egg" then
        EggRiftMap[id] = data.Egg or data.DisplayName or id
    elseif data.Type == "Chest" then
        ChestRiftMap[id] = data.DisplayName or id
    end
end
local teleportedEggs,alreadyTeleported={},{}

local EggsSection=Tabs.Aerlro:CreateSection("▶ Eggs")local RS=game:GetService("ReplicatedStorage")local VIM=game:GetService("VirtualInputManager")local LP=game:GetService("Players").LocalPlayer local teleportedEggs,alreadyTeleported={},{} local HatchEggModule=RS:FindFirstChild("Client")and RS.Client:FindFirstChild("Effects")and RS.Client.Effects:FindFirstChild("HatchEgg")and require(RS.Client.Effects.HatchEgg) local oldPlay=HatchEggModule and HatchEggModule.Play or nil if HatchEggModule and oldPlay then HatchEggModule.Play=function(...)if getgenv().RiftsConfig.DisableEggAnim then return end return oldPlay(...) end end local function getEggList()local n,s={},{} local f=workspace:WaitForChild("Rendered"):GetChildren()[13] if f then for _,e in pairs(f:GetChildren())do local name=e.Name if name and not s[name] and not name:find("Coming Soon") then table.insert(n,name)s[name]=true end end end table.sort(n)return n end EggsSection:CreateDropdown("EggSelect",{Title="Eggs",Values=getEggList(),Default=nil,Callback=function(v)getgenv().RiftsConfig.SelectedEgg=v teleportedEggs[v]=false end}) local disT=EggsSection:CreateToggle("DisableEggAnim",{Title="Disable Egg Animation",Default=false}) disT:OnChanged(function(v)getgenv().RiftsConfig.DisableEggAnim=v end) local function teleportToEgg(e)local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if not hrp then return end local rendered=workspace:WaitForChild("Rendered"):GetChildren()[13] if not rendered then return end local eggModel=rendered:FindFirstChild(e) if not eggModel then return end local safePoint local deco=eggModel:FindFirstChild("Decoration") if deco and deco:FindFirstChild("Primary") then local primary=deco.Primary local g=primary:GetChildren()[9] if g and g:IsA("BasePart") then safePoint=g end end if safePoint and not alreadyTeleported[e] then hrp.CFrame=safePoint.CFrame+Vector3.new(0,3,0) teleportedEggs[e]=true alreadyTeleported[e]=true end getgenv().RiftsConfig.LastPosition=hrp.CFrame end EggsSection:CreateToggle("TeleportSummonedEgg",{Title="Teleport to Summoned Egg",Default=false,Callback=function(v)getgenv().RiftsConfig.TeleportSummonedEgg=v if v then task.spawn(function() local wasSummoned=false while getgenv().RiftsConfig.TeleportSummonedEgg do local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") local summoned=workspace:FindFirstChild("SummonedEgg") local selectedEgg=getgenv().RiftsConfig.SelectedEgg if summoned and summoned:FindFirstChild("EggPlatformSpawn") then wasSummoned=true if not alreadyTeleported["SummonedEgg"] then local p=summoned.EggPlatformSpawn.PrimaryPart or summoned.EggPlatformSpawn:FindFirstChildWhichIsA("BasePart") if p and hrp then hrp.CFrame=p.CFrame+Vector3.new(0,3,0) alreadyTeleported["SummonedEgg"]=true alreadyTeleported[selectedEgg]=false end end elseif wasSummoned then wasSummoned=false alreadyTeleported["SummonedEgg"]=false if selectedEgg then teleportToEgg(selectedEgg) end end task.wait(1) end end) end end}) EggsSection:CreateToggle("AutoHatchEggs",{Title="Auto Hatch",Default=false,Callback=function(v)getgenv().RiftsConfig.AutoHatch=v if v then getgenv().autoPressE=true task.spawn(function() while getgenv().autoPressE do VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game) task.wait() VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game) task.wait() end end) task.spawn(function() while getgenv().RiftsConfig.AutoHatch do local egg=getgenv().RiftsConfig.SelectedEgg if egg and (not getgenv().RiftsConfig.TeleportSummonedEgg or not workspace:FindFirstChild("SummonedEgg")) then teleportToEgg(egg) end task.wait(1.5) end end) else getgenv().autoPressE=false end end})
local RiftsSection=Tabs.Aerlro:CreateSection("▶ Rifts")
RiftsSection:CreateDropdown("EggRiftSelect",{Title="Egg Rifts",Values=(function()local t={}for _,v in pairs(EggRiftMap)do table.insert(t,v)end;table.sort(t)return t end)(),Multi=false,Default=nil,Callback=function(v)for k,val in pairs(EggRiftMap)do if val==v then getgenv().RiftsConfig.SelectedEggRift=k;break end end end})
RiftsSection:CreateDropdown("IgnoreMultiplier",{Title="Ignore Egg Rift Multipliers",Values={1,2,5,10,15,20,25},Multi=true,Default={},Callback=function(vals)local s={}for k,v in pairs(vals)do if v==true then local num=tonumber(k)if num then s[num]=true end end end;getgenv().RiftsConfig.IgnoreMultiplier=s end})
RiftsSection:CreateToggle("TeleportEggRiftToggle",{Title="Teleport to Egg Rift",Default=false,Callback=function(v)getgenv().RiftsConfig.TeleportEggRift=v;if v then getgenv().autoPressE=true;task.spawn(function()while getgenv().autoPressE do VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game);task.wait();VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game);task.wait()end end)else getgenv().autoPressE=false end end})
RiftsSection:CreateDropdown("ChestRiftSelect",{Title="Chest Rifts",Values=(function()local t={}for _,v in pairs(ChestRiftMap)do table.insert(t,v)end;table.sort(t)return t end)(),Multi=false,Default=nil,Callback=function(v)for k,val in pairs(ChestRiftMap)do if val==v then getgenv().RiftsConfig.SelectedChestRift=k;break end end end})
RiftsSection:CreateToggle("TeleportChestRiftToggle",{Title="Teleport to Chest Rift",Default=false,Callback=function(v)getgenv().RiftsConfig.TeleportChestRift=v;if v then getgenv().autoPressE=true;task.spawn(function()while getgenv().autoPressE do VIM:SendKeyEvent(true,Enum.KeyCode.E,false,game);task.wait();VIM:SendKeyEvent(false,Enum.KeyCode.E,false,game);task.wait()end end)else getgenv().autoPressE=false end end})
local function getRiftMultiplier(r)for _,d in ipairs(r:GetDescendants())do if d:IsA("TextLabel")or d:IsA("TextBox")then local t=d.Text:lower() local m=t:match("(%d+)%s*x")or t:match("x%s*(%d+)") if m then return tonumber(m)end end end return nil end
local function teleportTo(p)local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if hrp and p then hrp.CFrame=CFrame.new(p+Vector3.new(0,5,0))end end
local alreadyTeleported={}
RunService.Heartbeat:Connect(function()
    local cfg=getgenv().RiftsConfig or {}
    cfg.IgnoreMultiplier=cfg.IgnoreMultiplier or {}
    for _,r in pairs(workspace:GetDescendants())do
        if r:IsA("Model")then
            local n=r.Name
            local id=r:GetDebugId() or (n..game.JobId)
            if alreadyTeleported[id] then continue end
            if cfg.TeleportEggRift and cfg.SelectedEggRift and n==cfg.SelectedEggRift then
                local platform=r:FindFirstChild("EggPlatformSpawn")
                if platform and platform.PrimaryPart then
                    local m=getRiftMultiplier(r)
                    if not m or not cfg.IgnoreMultiplier[m] then
                        teleportTo(platform.PrimaryPart.Position)
                        alreadyTeleported[id]=true
                    end
                end
            end
            if cfg.TeleportChestRift and cfg.SelectedChestRift and n==cfg.SelectedChestRift then
                local p=r.PrimaryPart or r:FindFirstChildWhichIsA("BasePart")
                if p then
                    teleportTo(p.Position)
                    alreadyTeleported[id]=true
                end
            end
        end
    end
end)

local EnchantSection=Tabs.Aerlro:CreateSection("▶️ Pet Enchant")
local o={"Anything"}for a,b in pairs(EnchantsModule)do local c=b.DisplayName or a local d=b.Emoji or""local e=b.Levels or 1 if e>1 then for i=1,e do table.insert(o,string.format("%s %d %s",c,i,d))end else table.insert(o,string.format("%s %s",c,d))end end table.sort(o)
local p=EnchantSection:CreateDropdown("EnchantSlot1",{Title="Enchant Slot 1",Multi=false,Values=o,Default="Anything"})p:OnChanged(function(v)getgenv().EnchantConfig.Slot1=v end)
local q=EnchantSection:CreateDropdown("EnchantSlot2",{Title="Enchant Slot 2",Multi=false,Values=o,Default="Anything"})q:OnChanged(function(v)getgenv().EnchantConfig.Slot2=v end)
local r=EnchantSection:CreateDropdown("EnchantMethod",{Title="Enchant Method",Multi=false,Values={"Gems Only","Orbs Only","Gems First Orbs Second","Shadow Crystal First Orbs Second","Secret Crystal Only"},Default="Gems Only"})r:OnChanged(function(v)getgenv().EnchantConfig.EnchantMethod=v end)
local function s()local t={}local d=LocalData:Get()if d and d.Teams then for i,_ in pairs(d.Teams)do table.insert(t,"Team "..i)end end return t end
local u=EnchantSection:CreateDropdown("TeamsList",{Title="Select Team",Multi=false,Values=s(),Default="--"})u:OnChanged(function(v)local n=tonumber(string.match(v,"%d+"))if n then getgenv().EnchantConfig.SelectedTeam=n end end)
local w=EnchantSection:CreateToggle("AutoEnchantToggle",{Title="Auto Enchant",Default=false})w:OnChanged(function(v)getgenv().EnchantConfig.AutoEnchantActive=v end)
local DeleteSection=Tabs.Aerlro:CreateSection("▶️ Auto Delete Pets")local RarityDropdown=DeleteSection:CreateDropdown("PetRarities",{Title="Rarities",Multi=true,Values={"Common","Unique","Rare","Epic","Legendary Tier 1","Legendary Tier 2","Legendary Tier 3"},Default={}})RarityDropdown:OnChanged(function(v)getgenv().PetsConfig.SelectedDeleteRarities={}for r,s in pairs(v)do if s then getgenv().PetsConfig.SelectedDeleteRarities[r]=true end end end)local uniqueTags={}for _,d in pairs(petsModule)do if type(d)=="table"and d.Tag and d.Tag~=""then uniqueTags[d.Tag]=true end end local tagList={}for t in pairs(uniqueTags)do table.insert(tagList,t)end table.sort(tagList)local IgnoreTagsDropdown=DeleteSection:CreateDropdown("IgnoreTags",{Title="Ignore Tags",Multi=true,Values=tagList,Default={}})IgnoreTagsDropdown:OnChanged(function(v)getgenv().PetsConfig.IgnoreTags={}for t,s in pairs(v)do if s then getgenv().PetsConfig.IgnoreTags[t]=true end end end)local DeleteToggle=DeleteSection:CreateToggle("AutoDeletePets",{Title="Delete Pets",Default=false})DeleteToggle:OnChanged(function(state)getgenv().PetsConfig.AutoDelete=state;if not state then return end;task.spawn(function()while getgenv().PetsConfig.AutoDelete do local pets=playerData.Pets;for _,pet in pairs(pets)do local info=petsModule[pet.Name]if info then local r=info.Rarity or"Unknown"local tier=info.Tier and("Legendary Tier "..tostring(info.Tier))or nil local amt=pet.Amount or 1 if info.Tag and getgenv().PetsConfig.IgnoreTags[info.Tag]then continue end local shouldDelete=false;if getgenv().PetsConfig.SelectedDeleteRarities[r]then shouldDelete=true elseif r=="Legendary"and tier and getgenv().PetsConfig.SelectedDeleteRarities[tier]then shouldDelete=true end;if shouldDelete then local args={"DeletePet",pet.Id,amt,false}RS.Shared.Framework.Network.Remote.RemoteEvent:FireServer(unpack(args))task.wait(0.15)end end end task.wait(3)end end)end)
local ShinySection=Tabs.Aerlro:CreateSection("▶️ Auto Shiny Pets")local ShinyRarityDropdown=ShinySection:CreateDropdown("ShinyRarities",{Title="Rarities",Multi=true,Values={"Common","Unique","Rare","Epic","Legendary Tier 1","Legendary Tier 2","Legendary Tier 3","Secret"},Default={}})ShinyRarityDropdown:OnChanged(function(v)getgenv().PetsConfig.SelectedShinyRarities={}for r,s in pairs(v)do if s then getgenv().PetsConfig.SelectedShinyRarities[r]=true end end end)local ShinyIgnoreTagsDropdown=ShinySection:CreateDropdown("IgnoreTags",{Title="Ignore Tags",Multi=true,Values=tagList,Default={}})ShinyIgnoreTagsDropdown:OnChanged(function(v)getgenv().PetsConfig.IgnoreTags={}for t,s in pairs(v)do if s then getgenv().PetsConfig.IgnoreTags[t]=true end end end)local ShinyToggle=ShinySection:CreateToggle("AutoShiny",{Title="Auto Shiny",Default=false})ShinyToggle:OnChanged(function(state)getgenv().PetsConfig.AutoShiny=state;if not state then return end;task.spawn(function()while getgenv().PetsConfig.AutoShiny do local pets=playerData.Pets;table.sort(pets,function(a,b)return(a.Amount or 0)>(b.Amount or 0)end)for _,pet in pairs(pets)do local info=petsModule[pet.Name]if info then local r=info.Rarity or"Unknown"local tier=info.Tier and("Legendary Tier "..tostring(info.Tier))or nil local tag=info.Tag;if tag and getgenv().PetsConfig.IgnoreTags[tag]then continue end local shouldShiny=false;if getgenv().PetsConfig.SelectedShinyRarities[r]then shouldShiny=true elseif r=="Legendary"and tier and getgenv().PetsConfig.SelectedShinyRarities[tier]then shouldShiny=true end;if shouldShiny then local args={"MakePetShiny",pet.Id,math.min(pet.Amount or 1,1)}RS.Shared.Framework.Network.Remote.RemoteEvent:FireServer(unpack(args))task.wait(0.2)end end end task.wait(3)end end)end)
local OtherSection=Tabs.Aerlro:CreateSection("▶️ Power Orb")
local AutoPowerOrbToggle=OtherSection:CreateToggle("AutoPowerOrbToggle",{Title="Auto Power Orb to Equipped Team",Default=false})
AutoPowerOrbToggle:OnChanged(function(v)getgenv().EnchantConfig.AutoPowerOrbActive=v end)
task.spawn(function()while true do task.wait(0.5)if not getgenv().EnchantConfig.AutoPowerOrbActive then continue end local d=LocalData:Get()if not(d and d.Teams)then continue end local tI=getgenv().EnchantConfig.SelectedTeam or d.TeamEquipped local t=tI and d.Teams[tI]if not t or not t.Pets then continue end for _,pId in ipairs(t.Pets)do if not getgenv().EnchantConfig.AutoPowerOrbActive then break end task.spawn(function()pcall(function()RemoteEvent:FireServer("UsePowerOrb",pId)end)end)task.wait(0.1)end end end)
local function findPetById(id)local d=LocalData:Get()if not(d and d.Pets)then return nil end for _,p in ipairs(d.Pets)do if p.Id==id then return p end end return nil end
local function slotHasDesired(p,s,d)if d=="Anything"then return(p.Enchants and p.Enchants[s]~=nil)end local e=(p.Enchants or{})[s]if not e then return false end local i=EnchantsModule[e.Id]if not i then return false end local n=i.DisplayName or e.Id local l=e.Level or 1 local emoji=i.Emoji or"" local str=(i.Levels>1)and string.format("%s %d %s",n,l,emoji)or string.format("%s %s",n,emoji) return str==d end
local function petHasDesiredEnchantSlot(p,s)local m=getgenv().EnchantConfig.EnchantMethod local s1=getgenv().EnchantConfig.Slot1 local s2=getgenv().EnchantConfig.Slot2 if m=="Gems Only"or m=="Orbs Only"then if s1==s2 then local ts=(p.Shiny or p.ShinyMythic)and 2 or 1 for i=1,ts do if slotHasDesired(p,i,s1)then return true end end return false end end if s==1 then return slotHasDesired(p,1,s1)else return slotHasDesired(p,2,s2)end end
task.spawn(function()while task.wait(0.5)do if not getgenv().EnchantConfig.AutoEnchantActive then continue end local d=LocalData:Get()if not(d and d.Teams)then continue end local tI=getgenv().EnchantConfig.SelectedTeam or d.TeamEquipped local team=tI and d.Teams[tI]if not team or not team.Pets then continue end for _,pId in ipairs(team.Pets)do if not getgenv().EnchantConfig.AutoEnchantActive then break end local pet=findPetById(pId)if not pet then continue end local ts=(pet.Shiny or pet.ShinyMythic)and 2 or 1 local slotsDone={}for i=1,ts do slotsDone[i]=petHasDesiredEnchantSlot(pet,i)end local allGood=true for i=1,ts do if not slotsDone[i]then allGood=false while getgenv().EnchantConfig.AutoEnchantActive and not petHasDesiredEnchantSlot(pet,i)do local m=getgenv().EnchantConfig.EnchantMethod if m=="Gems Only"then RemoteFunction:InvokeServer("RerollEnchants",pId,"Gems")elseif m=="Orbs Only"then RemoteFunction:InvokeServer("RerollEnchants",pId,"Orbs")elseif m=="Gems First Orbs Second"then if i==1 then RemoteFunction:InvokeServer("RerollEnchants",pId,"Gems")else RemoteEvent:FireServer("RerollEnchant",pId,i)end elseif m=="Shadow Crystal First Orbs Second"then if i==1 then local ok=pcall(function()RemoteEvent:FireServer("UseShadowCrystal",pId)end)if not ok then RemoteFunction:InvokeServer("RerollEnchants",pId,"Orbs")end else RemoteEvent:FireServer("RerollEnchant",pId,i)end elseif m=="Secret Crystal Only"then RemoteEvent:FireServer("UseShadowCrystal",pId,i)end for _=1,math.floor(COOLDOWN_BETWEEN_REROLLS*20)do if not getgenv().EnchantConfig.AutoEnchantActive then break end task.wait(0.1)end pet=findPetById(pId)if not pet then break end end slotsDone[i]=true end end if allGood then continue end end end)
 
local cfg=getgenv().ShopsConfig or{}

local function tableToString(t)
 if type(t)~="table"then return tostring(t)end
 local r={}for k,v in pairs(t)do local key=tostring(k)local value
 if type(v)=="table"then value=tableToString(v)else value=tostring(v)end
 table.insert(r,key.."="..value)end
 return "{"..table.concat(r,", ").."}"
end

ShopsSection=Tabs.Aerlro:CreateSection("▶️ Shops & Items")
ShopsSection:AddToggle("BuyAllItems",{Title="Buy All",Default=cfg.BuyAll or false,Callback=function(v)cfg.BuyAll=v end})
for shopName,shopInfo in pairs(ShopsData)do
 local section=Tabs.Aerlro:AddSection("▶ "..shopName)local itemList={}
 local function extractItems(tbl)if not tbl then return end for _,v in pairs(tbl)do if type(v)=="table"then if v.Product and v.Product.Name then local name,lvl=v.Product.Name,v.Product.Level or 1 if table.find({"Speed","Lucky","Mythic","Coins","Tickets"},name)then itemList[name.." "..lvl]=true else itemList[name]=true end else extractItems(v)end end end end extractItems(shopInfo)
 local dropdownItems={}for k in pairs(itemList)do table.insert(dropdownItems,k)end table.sort(dropdownItems)
 section:AddDropdown(shopName.."Dropdown",{Title="Select Items",Values=dropdownItems,Multi=true,Default=cfg[shopName.."SelectedItems"] or {},Callback=function(v)local selected={}for k,state in pairs(v)do if state then table.insert(selected,k)end end cfg[shopName.."SelectedItems"]=selected end})
 section:AddToggle(shopName.."AutoBuy",{Title="Auto Buy",Default=cfg[shopName.."AutoBuy"] or false,Callback=function(v)cfg[shopName.."AutoBuy"]=v end})
 section:AddToggle(shopName.."AutoReroll",{Title="Auto Reroll",Default=cfg[shopName.."AutoReroll"] or false,Callback=function(v)cfg[shopName.."AutoReroll"]=v end})
end
local function buyShopItem(shopName,index,all)pcall(function()RemoteEvent:FireServer("BuyShopItem",shopName,index,all)end)end
local function checkShop(shopName)local playerData=LocalData:Get()local shopInfo=playerData.Shops[shopName] or {Bought={}}local itemsData,stockData=ShopUtil:GetItemsData(shopName,playerData,playerData,playerData)local selected=cfg[shopName.."SelectedItems"] or {}for i,item in ipairs(itemsData)do if item and item.Product then local name=item.Product.Name local lvl=item.Product.Level or 1 local baseStock=stockData[i] or 0 local bought=shopInfo.Bought[i] or 0 local remaining=math.max(baseStock-bought,0)local isSelected=false for _,sel in ipairs(selected)do local E,F=sel:match("^(.-) (%d+)$")F=F and tonumber(F) or nil if(E and E==name and F==lvl)or(not E and sel==name)then isSelected=true break end end if isSelected and remaining>0 and cfg[shopName.."AutoBuy"]then if cfg.BuyAll then buyShopItem(shopName,i,true)else local count=0 while count<remaining and cfg[shopName.."AutoBuy"]do buyShopItem(shopName,i,false)count+=1 remaining-=1 task.wait(0.1)end end end end end end
task.spawn(function()while true do for shopName,_ in pairs(ShopsData)do if cfg[shopName.."AutoBuy"]then checkShop(shopName)end end task.wait(0.2)end end)
task.spawn(function()while true do for shopName,_ in pairs(ShopsData)do if cfg[shopName.."AutoReroll"]then pcall(function()RemoteEvent:FireServer("ShopFreeReroll",shopName)end)end end task.wait(0.5)end end)
RemoteEvent.OnClientEvent:Connect(function(eventName,...)if eventName=="ItemsReceived"or eventName=="ShopsRestocked"then end end)  

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
    local ok, result = pcall(function()
        return LocalData:Get()
    end)
    if ok and result then
        return result
    end
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

local function pickDice(p)
    if not p then return "Dice" end

    local golden = getGoldenCount()
    local selected = getgenv().selectedTileTypes or {}

    -- nu folosim golden dice dacă nu avem ținte
    if golden <= 0 or #selected == 0 then
        return "Dice"
    end

    -- determinăm cel mai apropiat tile dintre cele selectate
    local bestDist = math.huge

    for _, tileType in ipairs(selected) do
        local nodes = a[tileType]
        if nodes then
            for _, node in ipairs(nodes) do
                local dist = stepsToNode(p, node)
                if dist and dist < bestDist then
                    bestDist = dist
                end
            end
        end
    end

    if bestDist == math.huge then
        return "Dice"
    end

    -- încercăm întâi cu un Giant Dice dacă există
    local pdata = safeData()
    local pw = pdata.Powerups or {}

    if pw["Giant Dice"] and pw["Giant Dice"] > 0 then
        local roll = math.random(6, 12) -- giant dice range
        local newIndex = (p.Index + roll - 1) % #BoardUtil.Nodes + 1

        -- recalc distanța
        local newDist = math.huge
        for _, tileType in ipairs(selected) do
            for _, node in ipairs(a[tileType] or {}) do
                local d = stepsToNode({Index = newIndex}, node)
                if d and d < newDist then
                    newDist = d
                end
            end
        end

        -- dacă noua distanță intră în GoldenDiceDistance, folosim Golden Dice
        if newDist <= getgenv().boardSettings.GoldenDiceDistance then
            return "Golden Dice"
        end
    end

    -- încearcă cu un Dice normal
    if pw["Dice"] and pw["Dice"] > 0 then
        local roll = math.random(1, 6)
        local newIndex = (p.Index + roll - 1) % #BoardUtil.Nodes + 1

        local newDist = math.huge
        for _, tileType in ipairs(selected) do
            for _, node in ipairs(a[tileType] or {}) do
                local d = stepsToNode({Index = newIndex}, node)
                if d and d < newDist then
                    newDist = d
                end
            end
        end

        if newDist <= getgenv().boardSettings.GoldenDiceDistance then
            return "Golden Dice"
        end
    end

    return "Dice"
end

local function rollDice(diceType)
    if not diceType then return end
    local ok, result = pcall(function()
        return RemoteFunction:InvokeServer("RollDice", diceType)
    end)
    if ok then
        return result
    end
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
        while MinigamesConfig.AutoRun[minigame][difficulty] do
            e("StartMinigame", minigame, difficulty)
            task.wait(2)
            e("FinishMinigame")
            task.wait(1)
            if MinigamesConfig.SuperTicketGame == minigame then
                e("SkipMinigameCooldown", minigame)
            end
            task.wait(0.5)
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

Tabs.Aerlro:CreateSection("▶ Island Chests")local ChestDropdown=Tabs.Aerlro:CreateDropdown("ChestSelect",{Title="Select Chests",Description="Choose which chests to auto claim",Values={"Giant Chest","Void Chest","Ticket Chest","Infinity Chest"},Multi=true,Default={}})ChestDropdown:OnChanged(function(vals)getgenv().MiscConfig.SelectedChests={}for n,s in pairs(vals)do if s then table.insert(getgenv().MiscConfig.SelectedChests,n)end end end)local ChestToggle=Tabs.Aerlro:CreateToggle("AutoIslandChests",{Title="Auto Island Chests",Default=false})ChestToggle:OnChanged(function(v)getgenv().MiscConfig.AutoIslandChests=v end)task.spawn(function()while true do local cfg=getgenv().MiscConfig if cfg.AutoIslandChests and #cfg.SelectedChests>0 then local playerData=LocalData:Get()if playerData and playerData.Cooldowns then for _,chestName in ipairs(cfg.SelectedChests)do local cd=playerData.Cooldowns[chestName]or 0 if os.time()>=cd then pcall(function()RemoteEvent:FireServer("ClaimChest",chestName)end)task.wait(1)end end end end task.wait(2)end end)
  
local ShrineSection=Tabs.Aerlro:AddSection("▶ Shrines")local potionList={}for _,p in ipairs(ShrineValues)do local n=p.Name;if p.Type=="Potion"and p.Level then n=n.." "..p.Level end table.insert(potionList,n)end table.sort(potionList)ShrineSection:AddDropdown("SelectPotion",{Title="Potions",Values=potionList,Multi=false,Default=nil,Callback=function(v)getgenv().MiscConfig.SelectedPotion=v end})ShrineSection:AddInput("PotionQuantity",{Title="Quantity",Default="1",Numeric=true,Finished=false,Callback=function(v)getgenv().MiscConfig.PotionQuantity=math.clamp(tonumber(v)or 1,1,1000)end})ShrineSection:AddToggle("AutoDonateShrine",{Title="Auto Donate Shrine",Default=false,Callback=function(v)getgenv().MiscConfig.AutoDonateShrine=v end})local function getPotionByName(n)for _,p in ipairs(ShrineValues)do local name=p.Name;if p.Type=="Potion"and p.Level then name=name.." "..p.Level end if name==n then return p end end end local function shrineOnCooldown()local d=LocalData:Get()if not d or not d.Shrines or not d.Shrines.BubbleShrine then return false end local s=d.Shrines.BubbleShrine;return os.time()<(s.ShrineBlessingEndTime or 0)end task.spawn(function()while true do local cfg=getgenv().MiscConfig;if cfg.AutoDonateShrine and cfg.SelectedPotion then local p=getPotionByName(cfg.SelectedPotion)if p then local q=math.clamp(cfg.PotionQuantity or 1,1,1000)if not shrineOnCooldown() then pcall(function()RemoteFunction:InvokeServer("DonateToShrine",{Type=p.Type,Name=p.Name,Level=p.Level or 1,Amount=q,XP=p.XP})end)end end end task.wait(0.5)end end)

-- FISHES
local fishList={}
for _,f in pairs(playerData.FishInventory or {}) do table.insert(fishList,f.Name.." | "..(f.Amount or 0)) end
table.sort(fishList)
ShrineSection:AddDropdown("Fishes",{Title="Fishes",Values=fishList,Multi=false,Default=nil,Callback=function(v)getgenv().MiscConfig.SelectedFish=v:match("^(.-) |") end})
ShrineSection:AddInput("FishQuantity",{Title="Quantity",Default="1",Numeric=true,Finished=true,Callback=function(v)getgenv().MiscConfig.FishQuantity=tonumber(v)or 1 end})
ShrineSection:AddToggle("AutoDonateDreamerShrine",{Title="Auto Donate Dreamer Shrine",Default=false,Callback=function(v)getgenv().MiscConfig.AutoDonateDreamerShrine=v end})

task.spawn(function()
    while true do
        local cfg = getgenv().MiscConfig
        if cfg.AutoDonateDreamerShrine and cfg.SelectedFish then
            local playerData = LocalData:Get()
            local fish = nil
            for _, f in pairs(playerData.FishInventory or {}) do
                if f.Name == cfg.SelectedFish then
                    fish = f
                    break
                end
            end
            if fish then
                local qty = math.clamp(tonumber(cfg.FishQuantity) or 1, 1, fish.Amount or 1)
                pcall(function()
                    RemoteFunction:InvokeServer("DonateToDreamerShrine", fish.Id, qty)
                end)
            end
            task.wait(5)
        else
            task.wait(0.5)
        end
    end
end)

local PowerupsSection=Tabs.Aerlro:CreateSection("▶ Powerups") local eggList={} for name,_ in pairs(Powerups)do if string.find(name:lower(),"egg")then table.insert(eggList,name)end end table.sort(eggList) local EggDropdown=PowerupsSection:AddDropdown("PowerupsEggsSelect",{Title="Select Powerup Egg",Values=eggList,Multi=false,Default=getgenv().MiscConfig.SelectedPowerupEgg or nil,Callback=function(v)getgenv().MiscConfig.SelectedPowerupEgg=v end}) PowerupsSection:AddToggle("AutoHatchPowerupsEggs",{Title="Auto Hatch Powerups Eggs",Default=getgenv().MiscConfig.AutoHatchPowerupsEggs or false,Callback=function(v)getgenv().MiscConfig.AutoHatchPowerupsEggs=v end}) local function hatchEgg(e)pcall(function()RemoteEvent:FireServer("HatchPowerupEgg",e,12)end)end task.spawn(function()while true do local cfg=getgenv().MiscConfig if cfg.AutoHatchPowerupsEggs and cfg.SelectedPowerupEgg then hatchEgg(cfg.SelectedPowerupEgg)end task.wait(0.5)end end)
local boxList={}for n,_ in pairs(Powerups)do local l=n:lower()if l:find("box")or l:find("crate")then table.insert(boxList,n)end end;table.sort(boxList)PowerupsSection:AddDropdown("BoxesSelect",{Title="Select Box",Values=boxList,Multi=false,Default=getgenv().MiscConfig.SelectedBox or nil,Callback=function(v)getgenv().MiscConfig.SelectedBox=v end})PowerupsSection:AddToggle("AutoOpenBoxes",{Title="Auto Open Boxes",Default=getgenv().MiscConfig.AutoOpenBoxes or false,Callback=function(v)getgenv().MiscConfig.AutoOpenBoxes=v end})local function hasBoxAvailable(box)local ok,data=pcall(function()return LocalData:Get()end)if not ok or not data or not data.Powerups then return false end;local amount=data.Powerups[box]return amount and amount>0 end;local function useBox(box)if hasBoxAvailable(box)then pcall(function()RemoteEvent:FireServer("UseGift",box,50)end)end end;local function tapNearbyGifts()pcall(function()local gifts=PhysicalItem:GetActiveGifts()local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if not hrp then return end;for obj,gift in pairs(gifts)do if gift and gift.InRange and gift.Hit then gift:Hit()end end end)end;task.spawn(function()while true do local cfg=getgenv().MiscConfig;if cfg.AutoHatchPowerupsEggs and cfg.SelectedPowerupEgg then hatchEgg(cfg.SelectedPowerupEgg)end;if cfg.AutoOpenBoxes and cfg.SelectedBox then useBox(cfg.SelectedBox)tapNearbyGifts()end;task.wait(0.1)end end)

InterfaceManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:SetIgnoreIndexes{}
InterfaceManager:SetFolder("OTC2")
SaveManager:SetFolder("OTC2")
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
Window:SelectTab(1)

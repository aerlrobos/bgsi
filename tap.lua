if not game:IsLoaded() then
    game.Loaded:Wait()
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local OTC = {
    Config = {
        AutoTap = false,
        AutoRebirth = false,
        AutoGemUpgrade = false,
        AutoUnlockSkillTree = false,
        AutoGoldenPets = false,
        AutoDiamondPets = false,
        AutoRainbowPets = false,
        AutoClaimRainbowPets = false,
        AutoClaimQuests = false,
        AutoHatch = false,
        IncludeShinyPets = false,
        AutoClaimChests = false,

        AutoCollectShinyStars = false,
        AutoClaimClickerChests = false,
        AutoAttackIslandBreakables = false,

        AutoMine = false,
        AutoMineDelay = 0.4,

        AutoBuyDailyShop = false,
        DailyShopDelay = 0.4,

        AutoBeatHallowLord = false,
        HallowLordTapDelay = 0.15,
        AutoBuyHalloweenShop = false,

        AutoSell = false,
        SellAmount = 25,
        SellCooldown = 3,

        TapDelay = 0.1,
        RebirthDelay = 1.5,
        GemUpgradeDelay = 1.2,
        SkillTreeDelay = 0.5,
        GoldenDelay = 1,
        GoldenPetCount = 1,
        DiamondDelay = 1,
        DiamondPetCount = 1,
        RainbowPetCount = 2,
        RainbowDelay = 3,
        QuestClaimDelay = 0.75,
        HatchDelay = 0.5,
        HatchAmount = 1,

        ClickerChestDelay = 0.25,
        ClickerChestOffset = 5,
        ShinyStarDelay = 0.7,

        ClientSequence = 1,
        RebirthIndex = 1,
        HatchSequence = 0,

        SelectedPet = "",
        SelectedDiamondPet = "",
        SelectedRainbowPet = "",
        SelectedEgg = "Basic",
    },
}

local UpgradeConfig = require(
    ReplicatedStorage
        .Shared
        .Progression
        .UpgradeConfig
)

local UpgradeController = require(
    ReplicatedStorage
        .Controllers
        .Game
        .UpgradeController
)

local DataController = require(
    ReplicatedStorage
        .Controllers
        .Core
        .DataController
)

local MachineConfig = require(
    ReplicatedStorage
        .Shared
        .Pets
        .MachineConfig
)

local LaunchEggConfig = require(
    ReplicatedStorage
        .Shared
        .Pets
        .LaunchEggConfig
)

local EggPricing = require(
    ReplicatedStorage
        .Shared
        .Pets
        .EggPricing
)

local PetIndexCatalog = require(
    ReplicatedStorage.Shared.Pets.PetIndexCatalog
)

local PhysicalUpgradeController = require(
    ReplicatedStorage.Controllers.Game.PhysicalUpgradeController
)

local PhysicalUpgradeConfig = require(
    ReplicatedStorage.Shared.Progression.PhysicalUpgradeConfig
)

local HatchRenderer = require(
    ReplicatedStorage.Modules.Client.Pets.HatchRenderer
)

local SecretHatchRenderer = require(
    ReplicatedStorage.Modules.Client.Pets.SecretHatchRenderer
)

local DigController = require(
    ReplicatedStorage.Controllers.Minigames.DigController
)

local DigConfig = require(
    ReplicatedStorage.Shared.Minigames.DigConfig
)

local DigRewardPopup = require(
    ReplicatedStorage.Controllers.Minigames.DigRewardPopup
)

local ColosseumClientAdapter = require(
    ReplicatedStorage.Controllers.Minigames.ColosseumClientAdapter
)

local ShinyStarConfig = require(
    ReplicatedStorage.Shared.Game.ShinyStarConfig
)

local BreakableConfig = require(ReplicatedStorage.Shared.Game.BreakableConfig)

local IslandConfig = require(ReplicatedStorage.Shared.Game.IslandBreakableConfig)

local IslandLandings = require(
    ReplicatedStorage.Shared.Progression.IslandLandings
)

local TapChestConfig = require(
    ReplicatedStorage.Shared.Game.TapChestConfig
)

local TapController = require(
    ReplicatedStorage.Controllers.Game.TapController
)

local TapChestController = require(
    ReplicatedStorage.Controllers.Game.TapChestController
)

local ProgressionIslandConfig = require(
    ReplicatedStorage.Shared.Progression.IslandConfig
)

local HallowBossController = require(
    ReplicatedStorage.Controllers.Game.HallowBossController
)

local HallowBossConfig = require(
    ReplicatedStorage.Shared.Game.HallowBossConfig
)

local HalloweenShopConfig = require(
    ReplicatedStorage.Shared.Items.HalloweenShopConfig
)

local HalloweenShopController = require(
    ReplicatedStorage.Controllers.Items.HalloweenShopController
)

local RainbowServerClock = require(
    ReplicatedStorage.Modules.Client.Core.ServerClock
)

local EnchantController = require(
    ReplicatedStorage.Controllers.Pets.EnchantController
)

local EnchantConfig = require(
    ReplicatedStorage.Shared.Pets.EnchantConfig
)

local PetVisualConfig = require(
    ReplicatedStorage
        :WaitForChild("Shared")
        :WaitForChild("Pets")
        :WaitForChild("PetVisualConfig")
)

local PetOdds = require(
    ReplicatedStorage
        :WaitForChild("Shared")
        :WaitForChild("Pets")
        :WaitForChild("PetOdds")
)

local TrickOrTreatConfig = require(
    ReplicatedStorage
        :WaitForChild("Shared")
        :WaitForChild("Game")
        :WaitForChild("TrickOrTreatConfig")
)

local jumpUpgrade = assert(
    PhysicalUpgradeConfig.Get("+1 Jump"),
    "Double Jump upgrade not found"
)

local Comm = require(
    ReplicatedStorage
        .Packages
        .Comm
)

local ShinyStarService = Comm.ClientComm.new(
    ReplicatedStorage.RemoteServices,
    false,
    "ShinyStarService"
):BuildObject()

local PetIndexService = Comm.ClientComm.new(
    ReplicatedStorage.RemoteServices,
    false,
    "PetIndexService"
):BuildObject()

local MachineService = Comm.ClientComm.new(
    ReplicatedStorage
        .RemoteServices,
    false,
    "MachineService"
):BuildObject()

local EggService = Comm.ClientComm.new(
    ReplicatedStorage
        .RemoteServices,
    false,
    "EggService"
):BuildObject()

local PetService = Comm.ClientComm.new(
    ReplicatedStorage.RemoteServices,
    false,
    "PetService"
):BuildObject()

local MiningService = Comm.ClientComm.new(
    ReplicatedStorage.RemoteServices,
    false,
    "MiningService"
):BuildObject()

local TapService = Comm.ClientComm.new(
    ReplicatedStorage.RemoteServices,
    false,
    "TapService"
):BuildObject()

local EnchantService = Comm.ClientComm.new(
    ReplicatedStorage.RemoteServices,
    false,
    "EnchantService"
):BuildObject()

local TrickOrTreatService = Comm.ClientComm.new(
    ReplicatedStorage.RemoteServices,
    false,
    "TrickOrTreatService"
):BuildObject()

local SkillTreeConfig = require(
    ReplicatedStorage
        :WaitForChild("Shared")
        :WaitForChild("Progression")
        :WaitForChild("SkillTreeConfig")
)

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Controllers = ReplicatedStorage:WaitForChild("Controllers")

local QuestConfig = require(
    Shared:WaitForChild("Quests"):WaitForChild("QuestConfig")
)

local QuestVisibility = require(
    Shared:WaitForChild("Quests"):WaitForChild("QuestVisibility")
)

local ClaimQuestEvent = ReplicatedStorage
    :WaitForChild("RemoteServices")
    :WaitForChild("QuestService")
    :WaitForChild("RF")
    :WaitForChild("ClaimQuest")

local SkillTreeUnlock = ReplicatedStorage
    :WaitForChild("RemoteServices")
    :WaitForChild("SkillTreeService")
    :WaitForChild("RF")
    :WaitForChild("Unlock")

local RemoteServices = ReplicatedStorage:WaitForChild("RemoteServices")

local TapEvent = RemoteServices
    :WaitForChild("TapService")
    :WaitForChild("RE")
    :WaitForChild("TapRequested")

local RebirthEvent = RemoteServices
    :WaitForChild("RebirthService")
    :WaitForChild("RE")
    :WaitForChild("RebirthRequested")

local DigBegin = ReplicatedStorage
    .RemoteServices
    .DigService
    .RF
    .Begin

local TravelRemote =
    ReplicatedStorage.RemoteServices.IslandService.RF.Travel

local IslandService = ReplicatedStorage
    :WaitForChild("RemoteServices")
    :WaitForChild("IslandService")

local ResultEvent = IslandService.RE:WaitForChild("IslandUnlockResult")

local RainbowClaimEvent = ReplicatedStorage
    :WaitForChild("RemoteServices")
    :WaitForChild("MachineService")
    :WaitForChild("RE")
    :WaitForChild("MachineCraftRequested")

local Rayfield = loadstring(
    game:HttpGet("https://sirius.menu/gen2")
)()

local Window = Rayfield:CreateWindow({
    name = "OTC・Tap Simulator: Reborn",
    subtitle = "by aerlro",
    sidebarLayout = true,
    showName = "OTC",
    icon = 116094782851554,

    theme = {
        CornerRoundness = UDim.new(0, 8),
        WindowColor = ColorSequence.new(
            Color3.fromRGB(18, 12, 18),
            Color3.fromRGB(30, 18, 28)
        ),
        ShadowColor = Color3.fromRGB(0, 0, 0),
        LiveAnimation = false,
        PillCornerRadius = UDim.new(0, 8),
        ElementCornerRadius = UDim.new(0, 6),
        SurfaceStroke = Color3.fromRGB(105, 65, 85),

        ContentColor = Color3.fromRGB(240, 225, 235),
        TitlingColor = Color3.fromRGB(255, 245, 250),
        ElementTextHoverColor = Color3.fromRGB(255, 170, 205),
        ActionColor = Color3.fromRGB(255, 155, 195),

        TabColor = Color3.fromRGB(255, 170, 205),
        TabBackground = ColorSequence.new(
            Color3.fromRGB(65, 35, 52),
            Color3.fromRGB(30, 18, 28)
        ),
        TabStroke = ColorSequence.new(
            Color3.fromRGB(255, 185, 215),
            Color3.fromRGB(190, 100, 145)
        ),

        ElementStroke = Color3.fromRGB(100, 65, 85),
        ElementGradient = ColorSequence.new(
            Color3.fromRGB(38, 25, 34),
            Color3.fromRGB(24, 17, 23)
        ),
        ElementTransparency = 0,
        ElementStrokeTransparency = 0,
        ElementStrokeHover = Color3.fromRGB(255, 170, 205),
        ElementStrokeHoverTransparency = 0,
        StatBackground = Color3.fromRGB(35, 23, 32),

        AccentColor = Color3.fromRGB(255, 170, 205),
        AccentStroke = Color3.fromRGB(255, 220, 235),
        AccentGlow = 0.85,

        SliderBackground = Color3.fromRGB(55, 42, 50),
        SliderBackgroundHover = Color3.fromRGB(80, 55, 70),
        SliderProgress = ColorSequence.new(
            Color3.fromRGB(255, 145, 190),
            Color3.fromRGB(255, 205, 225)
        ),
        SliderStroke = Color3.fromRGB(200, 120, 160),
        SliderHandle = Color3.fromRGB(255, 245, 250),

        ToggleTrack = Color3.fromRGB(85, 50, 70),
        ToggleTrackTransparency = 0,
        ToggleKnobOff = Color3.fromRGB(155, 140, 150),
        ToggleKnobOffTransparency = 0,
        DarkToggleOverlay = false,

        DropdownHighlight = Color3.fromRGB(100, 55, 80),

        FieldBackground = Color3.fromRGB(38, 25, 34),
        FieldTransparency = 0,
        FieldGlow = Color3.fromRGB(210, 125, 165),
        PlaceholderColor = Color3.fromRGB(165, 145, 158),

        NeutralButton = Color3.fromRGB(42, 28, 38),
        NeutralButtonHover = Color3.fromRGB(80, 45, 65),
        NeutralButtonStroke = Color3.fromRGB(140, 85, 115),

        ErrorColor = Color3.fromRGB(255, 245, 250),
        ErrorStrokeColor = Color3.fromRGB(255, 125, 175),
    },

    configuration = {
        autoSave = true,
        autoLoad = true,
        fileName = "TapSimulator",
        customFolder = "OTC",
    },
})

local HomeTab = Window:CreateTab({
    name = "Home",
    icon = "🏠",
})

local AutoTab = Window:CreateTab({
    name = "Automation",
    icon = "mouse-pointer-click",
})

local WorldTab = Window:CreateTab({
    name = "World",
    icon = "12",
})

local PetsTab = Window:CreateTab({
    name = "Pets",
    icon = "hammer",
})

local EggsTab = Window:CreateTab({
    name = "Eggs",
    icon = "egg",
})

local MinigamesTab = Window:CreateTab({
    name = "Minigames",
    icon = "pickaxe",
})

local HalloweenTab = Window:CreateTab({
    name = "Halloween",
    icon = "pumpkin",
})

local WebhookTab = Window:CreateTab({
    name = "Webhook",
    icon = "webhook",
})

local HomeStartTime = os.clock()

local PlayerInfoText = HomeTab:CreateText({
    name = "Player Info",
    text = "Loading player information...",
    icon = 95224778521476,
})

local PlaytimeText = HomeTab:CreateText({
    name = "Playtime",
    text = "00:00:00",
    icon = 95224778521476,
})

HomeTab:CreateText({
    name = "Thank You!",
    text = "Thank you for using OTC Hub! For updates, new features, bug reports, suggestions and more, join our Discord server or message @8wbh.",
})

HomeTab:CreateButton({
    name = "Join Discord Server",
    description = "Join for updates, bug reports and suggestions.",
    callback = function()
        local DiscordInvite = "https://discord.gg/TYV2cbVYYX"

        pcall(function()
            game:GetService("GuiService"):OpenBrowserWindow(DiscordInvite)
        end)

        if setclipboard then
            pcall(function()
                setclipboard(DiscordInvite)
            end)
        end
    end,
})

function GetExecutorName()
    local Name = "Unknown"
    local Version = "Unknown"

    if identifyexecutor then
        local Success, ExecutorName, ExecutorVersion = pcall(identifyexecutor)

        if Success then
            if ExecutorName then
                Name = tostring(ExecutorName)
            end

            if ExecutorVersion then
                Version = tostring(ExecutorVersion)
            end
        end
    elseif getexecutorname then
        local Success, ExecutorName = pcall(getexecutorname)

        if Success and ExecutorName then
            Name = tostring(ExecutorName)
        end
    end

    return Name .. " (Version: " .. Version .. ")"
end

function FormatPlaytime(Seconds)
    Seconds = math.max(0, math.floor(Seconds))

    local Hours = math.floor(Seconds / 3600)
    local Minutes = math.floor((Seconds % 3600) / 60)
    local RemainingSeconds = Seconds % 60

    return string.format(
        "%02d:%02d:%02d",
        Hours,
        Minutes,
        RemainingSeconds
    )
end

function UpdateHomeInfo()
    PlayerInfoText:Set(
        "Username: " .. LocalPlayer.Name
        .. "\nDisplay Name: " .. LocalPlayer.DisplayName
        .. "\nUser ID: " .. tostring(LocalPlayer.UserId)
        .. "\nExecutor: " .. GetExecutorName()
    )

    PlaytimeText:Set(
        FormatPlaytime(os.clock() - HomeStartTime)
    )
end

task.spawn(function()
    while not Destroyed do
        local Success, Error = pcall(UpdateHomeInfo)

        if not Success then
            warn("[OTC] Home update error:", Error)
        end

        task.wait(1)
    end
end)

function formatNumber(number)
    local formatted = string.format("%.0f", number)

    while true do
        local replaced, count = formatted:gsub(
            "^(-?%d+)(%d%d%d)",
            "%1,%2"
        )

        formatted = replaced

        if count == 0 then
            break
        end
    end

    return formatted
end

local RebirthOptions = {}
local RebirthIndexes = {}

function generateRebirthOptions(maxIndex)
    table.clear(RebirthOptions)
    table.clear(RebirthIndexes)

    for index = 1, maxIndex do
        local amount = 5 ^ (index - 1)
        local option = "+" .. formatNumber(amount)

        table.insert(RebirthOptions, option)
        RebirthIndexes[option] = index
    end
end

local maxIndex = 14

local configFolder = ReplicatedStorage:FindFirstChild("Shared")
local progressionFolder = configFolder
    and configFolder:FindFirstChild("Progression")

local buttonConfigModule = progressionFolder
    and progressionFolder:FindFirstChild("RebirthButtonConfig")

if buttonConfigModule then
    local success, result = pcall(function()
        local buttonConfig = require(buttonConfigModule)
        return buttonConfig.GetMaximumOptions("Main")
    end)

    if success and type(result) == "number" then
        maxIndex = result
    end
end

generateRebirthOptions(maxIndex)

AutoTab:CreateToggle({
    name = "Auto Tap",
    description = "Automatically send tap requests.",
    flag = "AutoTap",
    value = false,

    callback = function(value)
        OTC.Config.AutoTap = value

        if not value then
            return
        end

        task.spawn(function()
            while OTC.Config.AutoTap do
                local success, err = pcall(function()
                    TapController:Tap()
                end)

                if not success then
                    warn("[OTC] Auto Tap error:", err)
                end

                task.wait(OTC.Config.TapDelay or 0.1)
            end
        end)
    end,
})

AutoTab:CreateDropdown({
    name = "Rebirth Type",
    description = "Choose the rebirth type option.",
    flag = "RebirthType",
    options = RebirthOptions,
    default = RebirthOptions[1],

    callback = function(value)
        local index = RebirthIndexes[value]

        if index then
            OTC.Config.RebirthIndex = index
        end
    end,
})

AutoTab:CreateToggle({
    name = "Auto Rebirth",
    description = "Automatically request the selected rebirth.",
    flag = "AutoRebirth",
    value = false,
    
    callback = function(value)
        OTC.Config.AutoRebirth = value

        if not value then
            return
        end

        task.spawn(function()
            while OTC.Config.AutoRebirth do
                local index = OTC.Config.RebirthIndex

                local success, err = pcall(function()
                    RebirthEvent:FireServer({
                        Index = index,
                    })
                end)

                if not success then
                    warn("[OTC] Rebirth error:", err)
                end

                task.wait(OTC.Config.RebirthDelay)
            end
        end)
    end,
})

local AntiAFKEnabled = false
local AntiAFKConnection = nil
local AntiAFKToken = 0

HomeTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Description = "Anti AFK.",
    Callback = function(Value)
        AntiAFKEnabled = Value
        AntiAFKToken += 1

        local CurrentToken = AntiAFKToken

        if AntiAFKConnection then
            AntiAFKConnection:Disconnect()
            AntiAFKConnection = nil
        end

        if not Value then
            return
        end

        local Players = game:GetService("Players")
        local VirtualUser = game:GetService("VirtualUser")
        local Player = Players.LocalPlayer

        AntiAFKConnection = Player.Idled:Connect(function()
            if not AntiAFKEnabled then
                return
            end

            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end)
        end)

        task.spawn(function()
            while AntiAFKEnabled and AntiAFKToken == CurrentToken do
                task.wait(300)

                if not AntiAFKEnabled or AntiAFKToken ~= CurrentToken then
                    break
                end

                local Character = Player.Character
                local Humanoid = Character
                    and Character:FindFirstChildOfClass("Humanoid")

                if Humanoid and Humanoid.Health > 0 then
                    Humanoid.Jump = true
                end

                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(0, 0))
                end)
            end
        end)
    end
})

local SkillTreeNodes = {}
local SkillTreeNodeNames = {}

function collectSkillTreeNodes(node, visited)
    if type(node) ~= "table" or visited[node] then
        return
    end

    visited[node] = true

    if type(node.Name) == "string"
        and not SkillTreeNodeNames[node.Name] then
        SkillTreeNodeNames[node.Name] = true
        table.insert(SkillTreeNodes, node.Name)
    end

    for key, child in pairs(node) do
        if key ~= "Name" and type(child) == "table" then
            collectSkillTreeNodes(child, visited)
        end
    end
end

local visitedSkillTreeTables = {}

for _, tree in pairs(SkillTreeConfig) do
    collectSkillTreeNodes(tree, visitedSkillTreeTables)
end

table.sort(SkillTreeNodes)

AutoTab:CreateToggle({
    name = "Auto Upgrade Gems",
    description = "Automatically unlock available Skill Tree nodes.",
    flag = "AutoUnlockSkillTree",
    value = false,

    callback = function(value)
        OTC.Config.AutoUnlockSkillTree = value

        if not value then
            return
        end

        task.spawn(function()
            while OTC.Config.AutoUnlockSkillTree do
                local unlockedSomething = false

                for _, nodeName in ipairs(SkillTreeNodes) do
                    if not OTC.Config.AutoUnlockSkillTree then
                        break
                    end

                    local success, result = pcall(function()
                        return SkillTreeUnlock:InvokeServer({
                            Name = nodeName,
                        })
                    end)

                    if success and type(result) == "table" then
                        if result.Success == true then
                            unlockedSomething = true
                        end
                    elseif not success then
                        warn(
                            "[OTC] Skill Tree error:",
                            nodeName,
                            result
                        )
                    end

                    task.wait(OTC.Config.SkillTreeDelay or 0.5)
                end

                if not unlockedSomething
                    and OTC.Config.AutoUnlockSkillTree then
                    task.wait(0.5)
                end
            end
        end)
    end,
})

AutoTab:CreateToggle({
    name = "Auto Claim Quests",
    description = "Automatically claim completed quests.",
    flag = "AutoClaimQuests",
    value = false,

    callback = function(value)
        OTC.Config.AutoClaimQuests = value

        if not value then
            return
        end

        task.spawn(function()
            local claimedThisRun = {}

            while OTC.Config.AutoClaimQuests do
                local success, replica = pcall(function()
                    return DataController:GetReplica()
                end)

                local data = success and replica and replica.Data
                local quests = data and data.Quests

                if type(quests) == "table" then
                    for questName, questData in pairs(quests) do
                        if not OTC.Config.AutoClaimQuests then
                            break
                        end

                        local definition = QuestConfig.Definitions[questName]

                        if definition
                            and definition.AutoClaim ~= true
                            and type(questData) == "table"
                            and questData.Claimed ~= true
                            and not claimedThisRun[questName] then

                            local completed =
                                questData.Completed == true
                                or (
                                    type(questData.Amount) == "number"
                                    and questData.Amount >= definition.Goal
                                )

                            local visible = false

                            if completed then
                                local visibleSuccess, visibleResult = pcall(function()
                                    return QuestVisibility.IsShown(data, questName)
                                end)

                                visible = visibleSuccess and visibleResult == true
                            end

                            if completed and visible then
                                local claimSuccess, result = pcall(function()
                                    return ClaimQuestEvent:InvokeServer({
                                        Quest = questName,
                                    })
                                end)

                                if claimSuccess
                                    and type(result) == "table"
                                    and result.Success == true then
                                    claimedThisRun[questName] = true
                                elseif not claimSuccess then
                                    warn(
                                        "[OTC] Quest claim error:",
                                        questName,
                                        result
                                    )
                                end

                                task.wait(OTC.Config.QuestClaimDelay or 0.75)
                            end
                        end
                    end
                end

                task.wait(0.5)
            end
        end)
    end,
})

local AutoClaimIndexAll = false
local IndexClaimSession = 0

AutoTab:CreateToggle({
    name = "Auto Claim Index All",
    description = "Automatically claims all available Index rewards for pets and eggs.",
    flag = "AutoClaimIndexAll",
    value = false,
    callback = function(value)
        AutoClaimIndexAll = value
        IndexClaimSession += 1

        local session = IndexClaimSession

        if not value then
            return
        end

        task.spawn(function()
            while AutoClaimIndexAll
                and IndexClaimSession == session do

                local success, err = pcall(function()
                    local replica = DataController:GetReplica()
                    local data = replica and replica.Data
                    local pets = data and data.Pets

                    if type(pets) ~= "table" then
                        return
                    end

                    local claimables = PetIndexCatalog.Claimables(pets)

                    for _, item in ipairs(claimables) do
                        if not AutoClaimIndexAll
                            or IndexClaimSession ~= session then
                            break
                        end

                        if item.Kind == "Pet" then
                            PetIndexService.PetRewardClaimRequested:Fire(
                                item.Name,
                                item.Tier
                            )
                        elseif item.Kind == "Egg" then
                            PetIndexService.RewardClaimRequested:Fire(
                                item.Name
                            )
                        end

                        task.wait(0.25)
                    end
                end)

                if not success then
                    warn("[OTC Index] Claim error:", err)
                end

                task.wait(3)
            end
        end)
    end,
})

local AutoBuyDoubleJumps = false
local DoubleJumpSession = 0

local DoubleJumpPosition = CFrame.new(
    -98.6733017, -516.033081, -1679.99146,
    0.963639021, 0, 0.267207414,
    0, 1, 0,
    -0.267207414, 0, 0.963639021
)

AutoTab:CreateToggle({
    name = "Auto Buy Double Jumps",
    flag = "AutoBuyDoubleJumps",
    value = false,
    description = "Automatically teleports to the upgrade and purchases the next available +1 Jump upgrade.",
    callback = function(value)
        AutoBuyDoubleJumps = value
        DoubleJumpSession += 1

        local session = DoubleJumpSession

        if not value then
            return
        end

        task.spawn(function()
            while AutoBuyDoubleJumps
                and DoubleJumpSession == session do

                local success, err = pcall(function()
                    local character = LocalPlayer.Character
                    local root = character
                        and character:FindFirstChild("HumanoidRootPart")

                    if root then
                        root.CFrame = DoubleJumpPosition
                    end

                    local replica = DataController:GetReplica()
                    local data = replica and replica.Data

                    if not data then
                        return
                    end

                    local owned = PhysicalUpgradeConfig.GetOwned(
                        data,
                        jumpUpgrade
                    )

                    local nextIndex = owned + 1
                    local nextPrice = jumpUpgrade.Prices[nextIndex]

                    if not nextPrice then
                        AutoBuyDoubleJumps = false
                        DoubleJumpSession += 1
                        return
                    end

                    if PhysicalUpgradeConfig.GetLockedIsland(
                        data,
                        jumpUpgrade,
                        nextIndex
                    ) ~= nil then
                        return
                    end

                    PhysicalUpgradeController:BuyStep(
                        "+1 Jump",
                        nextIndex
                    )
                end)

                if not success then
                    warn("[OTC Auto Double Jumps] Error:", err)
                end

                task.wait(1.5)
            end
        end)
    end,
})

local ShinyStars = {
    {Id = "Spawn1", Pos = Vector3.new(-79.69999694824219, -49.06557846069336, -1930.4000244140625)},
    {Id = "Spawn2", Pos = Vector3.new(-61.90705490112305, -53.56557846069336, -1791.1435546875)},
    {Id = "Spawn3", Pos = Vector3.new(53.599998474121094, -513.2655639648438, -2015.699951171875)},
    {Id = "SkyIsland1", Pos = Vector3.new(-4.400001525878906, -513.2655639648438, -1699.5)},
    {Id = "SkyIsland2", Pos = Vector3.new(-98.26245880126953, -387.4767761230469, -1534.1929931640625)},
    {Id = "Autumn1", Pos = Vector3.new(-125.5, 905.1344604492188, -1978.300048828125)},
    {Id = "Autumn2", Pos = Vector3.new(23.600000381469727, 882.8344116210938, -1947.9000244140625)},
    {Id = "Mushroom1", Pos = Vector3.new(78.9000015258789, 2034.534423828125, -1996)},
    {Id = "Mushroom2", Pos = Vector3.new(-124.0999984741211, 2032.534423828125, -2067.89990234375)},
    {Id = "Desert1", Pos = Vector3.new(13.199999809265137, 3643.33447265625, -2165.89990234375)},
    {Id = "Desert2", Pos = Vector3.new(59.099998474121094, 3636.434326171875, -1979.0999755859375)},
    {Id = "CrystalCave1", Pos = Vector3.new(-235, 5444.9345703125, -2050.89990234375)},
    {Id = "CrystalCave2", Pos = Vector3.new(19.700000762939453, 5446.5341796875, -2033.5)},
    {Id = "ShadowRelm1", Pos = Vector3.new(13.199999809265137, 7692.234375, -2106.300048828125)},
    {Id = "ShadowRelm2", Pos = Vector3.new(197.8000030517578, 7698.4345703125, -1858.5999755859375)},
}

function IsShinyStarFound(Id)
    local Success, Replica = pcall(function()
        return DataController:GetReplica()
    end)

    if not Success or not Replica or not Replica.Data then
        return false
    end

    local FoundSuccess, Found = pcall(function()
        return ShinyStarConfig.IsFound(Replica.Data, Id)
    end)

    return FoundSuccess and Found == true
end

function CollectShinyStar(Star)
    if not OTC.Config.AutoCollectShinyStars then
        return
    end

    if IsShinyStarFound(Star.Id) then
        return
    end

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if not Character or not Humanoid or Humanoid.Health <= 0 or not Root then
        return
    end

    Character:PivotTo(
        CFrame.new(Star.Pos + Vector3.new(0, 2, 0))
    )

    task.wait(0.3)

    if not OTC.Config.AutoCollectShinyStars then
        return
    end

    Character = LocalPlayer.Character
    Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return
    end

    if (Root.Position - Star.Pos).Magnitude > ShinyStarConfig.PickupRange then
        return
    end

    pcall(function()
        local Response = ShinyStarService:Collect(Star.Id)

        if type(Response) == "table" and Response.Success == true then
            OTC.Config.ShinyStarsLastCollected = Star.Id
        end
    end)
end

local ShinyStarWorkerRunning = false

function StartShinyStarCollection()
    if ShinyStarWorkerRunning then
        return
    end

    ShinyStarWorkerRunning = true

    task.spawn(function()
        while OTC.Config.AutoCollectShinyStars do
            for _, Star in ipairs(ShinyStars) do
                if not OTC.Config.AutoCollectShinyStars then
                    break
                end

                pcall(CollectShinyStar, Star)
                task.wait(OTC.Config.ShinyStarDelay)
            end

            task.wait(0.5)
        end

        ShinyStarWorkerRunning = false
    end)
end

AutoTab:CreateToggle({
    Name = "Auto Collect Shiny Stars",
    Description = "Enable or disable auto collect shiny stars.",
    Flag = "AutoCollectShinyStars",
    CurrentValue = false,
    Callback = function(Value)
        OTC.Config.AutoCollectShinyStars = Value

        if Value then
            StartShinyStarCollection()
        end
    end,
})

local ClickerChestWorkerRunning = false
local CurrentClickerChest = nil

function GetClickerChestFolder()
    return workspace:FindFirstChild("ClickerChest")
end

function GetClickerChests()
    local Folder = GetClickerChestFolder()
    local Chests = {}

    if not Folder then
        return Chests
    end

    local Models = {}

    if Folder:IsA("Model") then
        table.insert(Models, Folder)
    end

    for _, Object in ipairs(Folder:GetDescendants()) do
        if Object:IsA("Model") then
            table.insert(Models, Object)
        end
    end

    for _, Model in ipairs(Models) do
        local Health = Model:GetAttribute("BreakableHealth")
        local MaxHealth = Model:GetAttribute("BreakableMaxHealth")

        if typeof(Health) == "number"
            and typeof(MaxHealth) == "number"
            and Health > 0
            and MaxHealth > 0 then
            table.insert(Chests, Model)
        end
    end

    return Chests
end

function GetClickerChestPosition(Model)
    local Hitbox = Model:FindFirstChild("Hitbox", true)

    if Hitbox and Hitbox:IsA("BasePart") then
        return Hitbox.Position
    end

    local Part = Model.PrimaryPart
        or Model:FindFirstChildWhichIsA("BasePart", true)

    if Part then
        return Part.Position
    end

    local Success, Pivot = pcall(function()
        return Model:GetPivot()
    end)

    if Success then
        return Pivot.Position
    end

    return nil
end

function GetCharacterRoot()
    local Character = LocalPlayer.Character
    local Humanoid = Character
        and Character:FindFirstChildOfClass("Humanoid")
    local Root = Character
        and Character:FindFirstChild("HumanoidRootPart")

    if not Character or not Humanoid or Humanoid.Health <= 0 or not Root then
        return nil, nil
    end

    return Character, Root
end

function TeleportToPosition(Position)
    if not OTC.Config.AutoClaimClickerChests then
        return false
    end

    local Character, Root = GetCharacterRoot()

    if not Character or not Root then
        return false
    end

    local Target = CFrame.new(Position + Vector3.new(0, 5, 0))

    local Success = pcall(function()
        Root.CFrame = Target
        Character:PivotTo(Target)
    end)

    if not Success then
        return false
    end

    task.wait(0.3)

    Character, Root = GetCharacterRoot()

    return Root ~= nil
        and (Root.Position - Position).Magnitude <= 15
end

function TeleportToClickerChest(Model)
    if not OTC.Config.AutoClaimClickerChests then
        return false
    end

    if not Model or not Model.Parent then
        return false
    end

    local Position = GetClickerChestPosition(Model)

    if not Position then
        return false
    end

    local Offset = OTC.Config.ClickerChestOffset or 5

    local Character, Root = GetCharacterRoot()

    if not Character or not Root then
        return false
    end

    local Target = CFrame.new(
        Position + Vector3.new(0, Offset, 0)
    )

    local Success = pcall(function()
        Root.CFrame = Target
        Character:PivotTo(Target)
    end)

    if not Success then
        return false
    end

    task.wait(0.3)

    Character, Root = GetCharacterRoot()

    return Root ~= nil
        and (Root.Position - Position).Magnitude <= 15
end

function ProcessClickerChest(Model)
    if not TeleportToClickerChest(Model) then
        return
    end

    CurrentClickerChest = Model

    while OTC.Config.AutoClaimClickerChests do
        if not Model.Parent then
            break
        end

        local Health = Model:GetAttribute("BreakableHealth")
        local MaxHealth = Model:GetAttribute("BreakableMaxHealth")

        if typeof(Health) ~= "number"
            or typeof(MaxHealth) ~= "number"
            or Health <= 0 then
            break
        end

        local Character, Root = GetCharacterRoot()

        if not Character or not Root then
            break
        end

        local Position = GetClickerChestPosition(Model)

        if not Position then
            break
        end

        if (Root.Position - Position).Magnitude > 15 then
            if not TeleportToClickerChest(Model) then
                break
            end
        end

        task.wait(OTC.Config.ClickerChestDelay or 0.5)
    end

    if CurrentClickerChest == Model then
        CurrentClickerChest = nil
    end
end

function GetOrderedIslandLandings()
    local Islands = {}

    for IslandName, Landing in pairs(IslandLandings) do
        if type(Landing) == "table"
            and typeof(Landing.Position) == "Vector3" then
            table.insert(Islands, {
                Name = IslandName,
                Position = Landing.Position,
            })
        end
    end

    table.sort(Islands, function(A, B)
        return A.Name < B.Name
    end)

    return Islands
end

function ProcessClickerChestsOnIsland(Island)
    if not TeleportToPosition(Island.Position) then
        return
    end

    task.wait(0.5)

    local Chests = GetClickerChests()

    for _, Model in ipairs(Chests) do
        if not OTC.Config.AutoClaimClickerChests then
            break
        end

        if Model.Parent then
            pcall(ProcessClickerChest, Model)
        end
    end
end

function StartClickerChestWorker()
    if ClickerChestWorkerRunning then
        return
    end

    ClickerChestWorkerRunning = true

    task.spawn(function()
        while OTC.Config.AutoClaimClickerChests do
            local Islands = GetOrderedIslandLandings()

            for _, Island in ipairs(Islands) do
                if not OTC.Config.AutoClaimClickerChests then
                    break
                end

                ProcessClickerChestsOnIsland(Island)

                task.wait(0.5)
            end

            task.wait(1)
        end

        CurrentClickerChest = nil
        ClickerChestWorkerRunning = false
    end)
end

AutoTab:CreateToggle({
    Name = "Auto Claim Clicker Chests",
    Description = "Enable or disable auto claim clicker chests.",
    Flag = "AutoClaimClickerChests",
    CurrentValue = false,
    Callback = function(Value)
        OTC.Config.AutoClaimClickerChests = Value

        if Value then
            StartClickerChestWorker()
        end
    end,
})

local IslandAttackToken = 0

function getIslandAttackRoot()
    local character = LocalPlayer.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

function GetIslandAttackOrder(spotsFolder)
    local islands = {}

    for id, position in pairs(spotsFolder:GetAttributes()) do
        if type(id) == "string" and typeof(position) == "Vector3" then
            local success, spot = pcall(function()
                return IslandConfig.Get(id)
            end)

            if success and type(spot) == "table" then
                table.insert(islands, {
                    Id = id,
                    Spot = spot,
                })
            end
        end
    end

    table.sort(islands, function(a, b)
        return a.Id < b.Id
    end)

    return islands
end

function getIslandAttackTarget(typeName)
    for _, obj in ipairs(CollectionService:GetTagged(BreakableConfig.Tag)) do
        if obj:IsDescendantOf(Workspace)
            and obj:GetAttribute(BreakableConfig.Attributes.Type) == typeName
            and obj:GetAttribute(BreakableConfig.Attributes.Owner) == LocalPlayer.UserId
            and obj:GetAttribute(BreakableConfig.Attributes.Broken) ~= true
            and obj:GetAttribute(BreakableConfig.Attributes.Despawned) ~= true then

            local hp = obj:GetAttribute(BreakableConfig.Attributes.Health)

            if typeof(hp) == "number" and hp > 0 then
                return obj
            end
        end
    end

    return nil
end

function getIslandAttackPosition(obj)
    if obj:IsA("Model") then
        return obj:GetPivot().Position
    elseif obj:IsA("BasePart") then
        return obj.Position
    end

    return nil
end

function islandAttackTargetDestroyed(obj)
    if not obj or not obj:IsDescendantOf(Workspace) then
        return true
    end

    local attributes = BreakableConfig.Attributes
    local hp = obj:GetAttribute(attributes.Health)

    return obj:GetAttribute(attributes.Broken) == true
        or obj:GetAttribute(attributes.Despawned) == true
        or (typeof(hp) == "number" and hp <= 0)
end

function runIslandAttack(token)
    local spotsFolder = Workspace:WaitForChild("IslandBreakableSpots")

    while OTC.Config.AutoAttackIslandBreakables
        and IslandAttackToken == token do

        local islands = GetIslandAttackOrder(spotsFolder)

        for _, island in ipairs(islands) do
            if not OTC.Config.AutoAttackIslandBreakables
                or IslandAttackToken ~= token then
                break
            end

            local id = island.Id
            local spot = island.Spot

            local replica = DataController:GetReplica()
            local data = replica and replica.Data

            if data and IslandConfig.IsUnlocked(data, spot) then
                local spotPosition = spotsFolder:GetAttribute(id)

                if typeof(spotPosition) == "Vector3" then
                    local target = getIslandAttackTarget(spot.Type)

                    while OTC.Config.AutoAttackIslandBreakables
                        and IslandAttackToken == token
                        and not target do

                        local root = getIslandAttackRoot()

                        if root and (root.Position - spotPosition).Magnitude > 6 then
                            root.CFrame = CFrame.new(
                                spotPosition + Vector3.new(0, 3, 0)
                            )
                        end

                        local currentReplica = DataController:GetReplica()
                        local currentData = currentReplica and currentReplica.Data

                        if currentData then
                            local readyAt = IslandConfig.GetReadyAt(
                                currentData,
                                id
                            )

                            local remaining = math.max(
                                0,
                                readyAt - Workspace:GetServerTimeNow()
                            )
                        end

                        target = getIslandAttackTarget(spot.Type)

                        task.wait(0.25)
                    end

                    while OTC.Config.AutoAttackIslandBreakables
                        and IslandAttackToken == token
                        and target
                        and not islandAttackTargetDestroyed(target) do

                        local position = getIslandAttackPosition(target)

                        if not position then
                            break
                        end

                        local root = getIslandAttackRoot()

                        if root then
                            local distance = (root.Position - position).Magnitude

                            if distance > 6 then
                                root.CFrame = CFrame.lookAt(
                                    position + Vector3.new(0, 2.5, 0),
                                    position
                                )
                            end
                        end

                        OTC.Config.ClientSequence += 1

                        pcall(function()
                            TapService.TapRequested:Fire({
                                Auto = false,
                                ClientSequence = OTC.Config.ClientSequence,
                            })
                        end)

                        task.wait(0.12)
                    end

                    task.wait(0.3)
                end
            end
        end

        task.wait(0.1)
    end
end

AutoTab:CreateToggle({
    name = "Auto Attack Island Breakables",
    description = "Enable or disable auto attack island breakables.",
    value = OTC.Config.AutoAttackIslandBreakables or false,
    flag = "AutoAttackIslandBreakables",
    callback = function(value)
        OTC.Config.AutoAttackIslandBreakables = value
        IslandAttackToken += 1

        if value then
            local token = IslandAttackToken

            task.spawn(function()
                local ok, err = pcall(function()
                    runIslandAttack(token)
                end)

                if not ok then
                    warn("[OTC] Island attack error:", err)

                    if IslandAttackToken == token then
                        OTC.Config.AutoAttackIslandBreakables = false
                    end
                end
            end)
        end
    end,
})

local AutoClaimChestsRunning = false

function getReadyTapChest(id)
    local replica = DataController:GetReplica()
    if not replica or not replica.Data then
        return nil
    end

    local readyAt = TapChestConfig.GetReadyAt(replica.Data, id)
    if readyAt > Workspace:GetServerTimeNow() then
        return nil
    end

    for _, chest in ipairs(CollectionService:GetTagged(TapChestConfig.Tag)) do
        if chest:IsA("Model")
            and chest:IsDescendantOf(Workspace)
            and chest:GetAttribute(TapChestConfig.Attributes.Id) == id then
            return chest
        end
    end

    return nil
end

local ChestIslandMap = {
    SkyIsland = "Sky Island",
    Desert = "Desert",
}

function autoClaimChests()
    local chestIds = {"SkyIsland", "Desert"}

    while OTC.Config.AutoClaimChests do
        for _, id in ipairs(chestIds) do
            if not OTC.Config.AutoClaimChests then
                break
            end

            local islandName = ChestIslandMap[id]
            local landing = islandName and IslandLandings[islandName]

            if landing and typeof(landing.Position) == "Vector3" then
                local character = LocalPlayer.Character
                local root = character
                    and character:FindFirstChild("HumanoidRootPart")

                if root then
                    root.CFrame = CFrame.new(
                        landing.Position + Vector3.new(0, 5, 0)
                    )

                    task.wait(1.5)

                    if not OTC.Config.AutoClaimChests then
                        break
                    end

                    local chest = getReadyTapChest(id)

                    if chest then
                        local front = chest:GetAttribute(
                            TapChestConfig.Attributes.Front
                        )

                        local size = chest:GetAttribute(
                            TapChestConfig.Attributes.Size
                        )

                        character = LocalPlayer.Character
                        root = character
                            and character:FindFirstChild("HumanoidRootPart")

                        if root
                            and typeof(front) == "CFrame"
                            and typeof(size) == "Vector3" then

                            local anchorPosition =
                                front.Position
                                - Vector3.new(0, size.Y * 0.5, 0)
                                + front.LookVector
                                    * (
                                        size.Z * 0.5
                                        + TapChestConfig.PromptInset
                                    )
                                + Vector3.new(
                                    0,
                                    TapChestConfig.PromptHeight,
                                    0
                                )

                            if (
                                root.Position - anchorPosition
                            ).Magnitude > TapChestConfig.LeaveDistance then
                                root.CFrame = CFrame.lookAt(
                                    anchorPosition - front.LookVector * 2,
                                    anchorPosition
                                )
                            end

                            task.wait(0.5)

                            if OTC.Config.AutoClaimChests
                                and chest:IsDescendantOf(Workspace) then

                                TapChestController:Interact(chest)

                                task.wait(1)
                            end
                        end
                    end
                end
            end

            task.wait(0.5)
        end

        task.wait(1)
    end

    AutoClaimChestsRunning = false
end

AutoTab:CreateToggle({
    Name = "Auto Claim Chests",
    Description = "Enable or disable auto claim chests.",
    Flag = "AutoClaimChests",
    CurrentValue = OTC.Config.AutoClaimChests,
    Callback = function(value)
        OTC.Config.AutoClaimChests = value

        if value and not AutoClaimChestsRunning then
            AutoClaimChestsRunning = true
            task.spawn(autoClaimChests)
        end
    end,
})

local IslandOptions = {"None"}
local IslandNames = {}

for name, config in pairs(ProgressionIslandConfig.Islands) do
    table.insert(IslandNames, {
        Name = name,
        Order = config.Order or math.huge
    })
end

table.sort(IslandNames, function(a, b)
    if a.Order == b.Order then
        return a.Name < b.Name
    end

    return a.Order < b.Order
end)

for _, island in ipairs(IslandNames) do
    table.insert(IslandOptions, island.Name)
end

WorldTab:CreateDropdown({
    name = "Islands",
    description = "Select an island to teleport to.",
    flag = "Islands",
    options = IslandOptions,
    value = "None",
    callback = function(value)
        if value == "None" then
            return
        end

        if not table.find(IslandOptions, value) then
            return
        end

        task.spawn(function()
            local success, err = pcall(function()
                TravelRemote:InvokeServer({
                    Source = "Menu",
                    Island = value
                })
            end)

            if not success then
                warn("[OTC Islands] Teleport failed:", err)
            end
        end)
    end,
})

local IslandOrder = {}

for islandName, landing in pairs(IslandLandings) do
    if type(landing) == "table"
        and typeof(landing.Position) == "Vector3" then
        table.insert(IslandOrder, islandName)
    end
end

table.sort(IslandOrder)

local UnlockEveryIslandEnabled = false
local UnlockEveryIslandRunning = false

function unlockVisitIsland(islandName)
    if not UnlockEveryIslandEnabled then
        return false
    end

    local landing = IslandLandings[islandName]

    if not landing or typeof(landing.Position) ~= "Vector3" then
        return false
    end

    local character = LocalPlayer.Character
        or LocalPlayer.CharacterAdded:Wait()

    local root = character:WaitForChild("HumanoidRootPart", 5)

    if not root then
        return false
    end

    local originalCollision = {}
    local result

    local target = landing.Position + Vector3.new(0, 5, 0)
    local duration = math.clamp(
        (root.Position - target).Magnitude / 100,
        1,
        12
    )

    local resultConnection = ResultEvent.OnClientEvent:Connect(function(data)
        if typeof(data) == "table"
            and data.Action == "WalkIn"
            and data.Island == islandName then
            result = data
        end
    end)

    local noclipConnection

    local ok, state = pcall(function()
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                originalCollision[part] = part.CanCollide
                part.CanCollide = false
            end
        end

        noclipConnection = RunService.Stepped:Connect(function()
            if not character.Parent then
                return
            end

            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)

        local tween = TweenService:Create(
            root,
            TweenInfo.new(duration, Enum.EasingStyle.Linear),
            { CFrame = CFrame.new(target) }
        )

        tween:Play()

        while UnlockEveryIslandEnabled
            and tween.PlaybackState == Enum.PlaybackState.Playing do
            RunService.Heartbeat:Wait()
        end

        if not UnlockEveryIslandEnabled then
            tween:Cancel()
        end

        return tween.PlaybackState
    end)

    if noclipConnection then
        noclipConnection:Disconnect()
    end

    for part, canCollide in pairs(originalCollision) do
        if part and part.Parent then
            part.CanCollide = canCollide
        end
    end

    resultConnection:Disconnect()

    if not ok or state ~= Enum.PlaybackState.Completed then
        return false
    end

    local deadline = os.clock() + 8

    while UnlockEveryIslandEnabled and os.clock() < deadline do
        if result then
            break
        end

        task.wait(0.1)
    end

    return result ~= nil
        and result.Success == true
        and result.Unlocked == true
end

WorldTab:CreateToggle({
    name = "Unlock Every Island",
    description = "Automatically travel through every detected island.",
    value = false,
    flag = "UnlockEveryIsland",

    callback = function(value)
        UnlockEveryIslandEnabled = value

        if not value or UnlockEveryIslandRunning then
            return
        end

        UnlockEveryIslandRunning = true

        task.spawn(function()
            pcall(function()
                for _, islandName in ipairs(IslandOrder) do
                    if not UnlockEveryIslandEnabled then
                        break
                    end

                    unlockVisitIsland(islandName)

                    if UnlockEveryIslandEnabled then
                        task.wait(2)
                    end
                end
            end)

            UnlockEveryIslandEnabled = false
            UnlockEveryIslandRunning = false
        end)
    end,
})

local PetOptions = {"None"}
local PetDropdown
local SelectedPetName = ""
local IsRefreshingPets = false

function GetPetName(option)
    if type(option) ~= "string" then
        return ""
    end

    return option:match("^(.-)%s%[") or option
end

function getEquippedIds(petData)
    local equippedIds = {}

    if type(petData.Equipped) == "table" then
        for _, petId in pairs(petData.Equipped) do
            if type(petId) == "string" then
                equippedIds[petId] = true
            end
        end
    end

    for id, pet in pairs(petData.Owned or {}) do
        if type(pet) == "table" then
            local petId = pet.Id or id

            if pet.Equip == true or pet.Equipped == true then
                equippedIds[petId] = true
            end
        end
    end

    return equippedIds
end

function HasMutation(pet)
    return pet.Mutation ~= nil
        and pet.Mutation ~= ""
        and pet.Mutation ~= "None"
end

function RefreshPets()
    if IsRefreshingPets then
        return
    end

    IsRefreshingPets = true

    local success, err = pcall(function()
        local replica = DataController:GetReplica()
        local petData = replica
            and replica.Data
            and replica.Data.Pets

        local pets = petData and petData.Owned

        if type(pets) ~= "table" then
            return
        end

        local equippedIds = getEquippedIds(petData)
        local groups = {}

        for id, pet in pairs(pets) do
            if type(pet) == "table"
                and type(pet.Name) == "string"
                and pet.Tier == "Normal" then

                local petId = pet.Id or id
                local group = groups[pet.Name]

                if not group then
                    group = {
                        Count = 0,
                        MutatedCount = 0,
                        EquippedCount = 0,
                    }

                    groups[pet.Name] = group
                end

                group.Count += 1

                if HasMutation(pet) then
                    group.MutatedCount += 1
                end

                if equippedIds[petId] then
                    group.EquippedCount += 1
                end
            end
        end

        local names = {}

        for name in pairs(groups) do
            table.insert(names, name)
        end

        table.sort(names)

        local newOptions = {}

        for _, name in ipairs(names) do
            local group = groups[name]

            local label = string.format(
                "%s [x%d | Mutations: %d]",
                name,
                group.Count,
                group.MutatedCount
            )

            if group.EquippedCount > 0 then
                label ..= " [Equipped]"
            end

            table.insert(newOptions, label)
        end

        if #newOptions == 0 then
            table.insert(newOptions, "None")
        end

        local updatedSelection = "None"

        if SelectedPetName ~= "" then
            for _, option in ipairs(newOptions) do
                if GetPetName(option) == SelectedPetName then
                    updatedSelection = option
                    break
                end
            end
        end

        if updatedSelection == "None" then
            SelectedPetName = ""
        end

        PetOptions = newOptions
        OTC.Config.SelectedPet = updatedSelection

        if PetDropdown then
            PetDropdown:Refresh(newOptions)
            PetDropdown:Set(updatedSelection)
        end
    end)

    IsRefreshingPets = false

    if not success then
        warn("[OTC] Pets refresh error:", err)
    end
end

function TeleportToGoldenMachine()
    local character = LocalPlayer.Character
    local root = character
        and character:FindFirstChild("HumanoidRootPart")

    if not root then
        return false
    end

    root.CFrame = CFrame.new(
        14.4709997, -515.968872, -1885.64685,
        0, 0, 1,
        0, 1, 0,
        -1, 0, 0
    )

    return true
end

PetsTab:CreateSection({
    name = "▶ Golden"
})

PetDropdown = PetsTab:CreateDropdown({
    name = "Pets",
    description = "Live inventory with mutation counts and equipped status.",
    options = PetOptions,
    value = "None",
    flag = "GoldenPetSelection",
    callback = function(value)
        if IsRefreshingPets then
            return
        end

        if type(value) ~= "string" then
            return
        end

        if value == "None" or value == "No pets" then
            SelectedPetName = ""
            OTC.Config.SelectedPet = "None"

            Window:Notify({
                Title = "Golden Pets",
                Content = "No pet selected.",
                Duration = 3,
            })

            return
        end

        SelectedPetName = GetPetName(value)
        OTC.Config.SelectedPet = value

        Window:Notify({
            Title = "Pet Selected",
            Content = "Selected: " .. value,
            Duration = 5,
        })
    end,
})

RefreshPets()

local GoldenOptions = {}
local GoldenCounts = {}

for count, chance in ipairs(MachineConfig.Golden.Chances) do
    local option = string.format("%d (%.0f%%)", count, chance)

    table.insert(GoldenOptions, option)
    GoldenCounts[option] = count
end

PetsTab:CreateDropdown({
    name = "Golden Chance",
    description = "Select how many pets to use for each craft.",
    flag = "GoldenChance",
    options = GoldenOptions,
    value = GoldenOptions[1],
    callback = function(value)
        local count = GoldenCounts[value]

        if count then
            OTC.Config.GoldenPetCount = count
        end
    end,
})

PetsTab:CreateToggle({
    name = "Auto Golden Pets",
    description = "Enable or disable auto golden pets.",
    flag = "AutoGoldenPets",
    value = OTC.Config.AutoGoldenPets or false,
    callback = function(value)
        OTC.Config.AutoGoldenPets = value

        if not value then
            return
        end

        if not TeleportToGoldenMachine() then
            OTC.Config.AutoGoldenPets = false
            return
        end

        task.spawn(function()
            while OTC.Config.AutoGoldenPets do
                local success, err = pcall(function()
                    local selectedName = SelectedPetName

                    if selectedName == "" then
                        return
                    end

                    local replica = DataController:GetReplica()
                    local petData = replica
                        and replica.Data
                        and replica.Data.Pets

                    if not petData
                        or type(petData.Owned) ~= "table" then
                        return
                    end

                    local equippedIds = getEquippedIds(petData)
                    local mutatedPet = nil
                    local normalPets = {}

                    local requiredCount = OTC.Config.GoldenPetCount

                    if type(requiredCount) ~= "number"
                        or requiredCount < 1
                        or requiredCount % 1 ~= 0 then
                        return
                    end

                    for id, pet in pairs(petData.Owned) do
                        if type(pet) == "table" then
                            local petId = pet.Id or id

                            local eligible =
                                pet.Name == selectedName
                                and pet.Tier == "Normal"
                                and not pet.Locked
                                and not pet.Frozen
                                and not equippedIds[petId]
                                and not pet.Equip
                                and not pet.Equipped
                                and not pet.Enchant
                                and not pet.Enchant2
                                and not pet.Signature
                                and pet.Rarity ~= "Secret"

                            if eligible then
                                if HasMutation(pet) then
                                    if not mutatedPet then
                                        mutatedPet = {
                                            Id = petId,
                                            Mutation = pet.Mutation,
                                        }
                                    end
                                else
                                    table.insert(normalPets, petId)
                                end
                            end
                        end
                    end

                    local selectedPets = {}

                    if mutatedPet then
                        table.insert(selectedPets, mutatedPet.Id)

                        for _, petId in ipairs(normalPets) do
                            table.insert(selectedPets, petId)

                            if #selectedPets >= requiredCount then
                                break
                            end
                        end
                    else
                        for _, petId in ipairs(normalPets) do
                            table.insert(selectedPets, petId)

                            if #selectedPets >= requiredCount then
                                break
                            end
                        end
                    end

                    if #selectedPets ~= requiredCount then
                        return
                    end
                
                    if mutatedPet and selectedPets[1] ~= mutatedPet.Id then
                        warn("[OTC] Golden cancelled: mutated pet is not first.")
                        return
                    end

                    print(
                        "[OTC] Golden craft:",
                        selectedName,
                        "| First ID:",
                        tostring(selectedPets[1]),
                        "| Mutation:",
                        mutatedPet and tostring(mutatedPet.Mutation) or "None",
                        "| Total:",
                        #selectedPets
                    )

                    MachineService.MachineCraftRequested:Fire({
                        Machine = "Golden",
                        Action = "Craft",
                        PetIds = selectedPets,
                    })
                end)

                if not success then
                    warn("[OTC] Auto Golden error:", err)
                end

                task.wait(OTC.Config.GoldenDelay or 1)
            end
        end)
    end,
})

task.spawn(function()
    while task.wait(1) do
        RefreshPets()
    end
end)

PetsTab:CreateSection({
    name = "▶ Diamond"
})

local DiamondPetOptions = {"None"}
local DiamondPetDropdown
local SelectedDiamondPetName = ""
local IsRefreshingDiamondPets = false

function GetDiamondPetName(option)
    if type(option) ~= "string" then
        return ""
    end

    return option:match("^(.-)%s%[") or option
end

function HasDiamondMutation(pet)
    return pet.Mutation ~= nil
        and pet.Mutation ~= ""
        and pet.Mutation ~= "None"
end

function RefreshDiamondPets()
    if IsRefreshingDiamondPets then
        return
    end

    IsRefreshingDiamondPets = true

    local success, err = pcall(function()
        local replica = DataController:GetReplica()

        if not replica then
            return
        end

        local petData = replica.Data
            and replica.Data.Pets

        local pets = petData and petData.Owned

        if type(pets) ~= "table" then
            return
        end

        local equippedIds = getEquippedIds(petData)
        local groups = {}

        for id, pet in pairs(pets) do
            if type(pet) == "table"
                and type(pet.Name) == "string"
                and pet.Tier == MachineConfig.Diamond.SourceTier then

                local petId = pet.Id or id
                local group = groups[pet.Name]

                if not group then
                    group = {
                        Count = 0,
                        MutatedCount = 0,
                        EquippedCount = 0,
                    }

                    groups[pet.Name] = group
                end

                group.Count += 1

                if HasDiamondMutation(pet) then
                    group.MutatedCount += 1
                end

                if equippedIds[petId] then
                    group.EquippedCount += 1
                end
            end
        end

        local names = {}

        for name in pairs(groups) do
            table.insert(names, name)
        end

        table.sort(names)

        local newOptions = {}

        for _, name in ipairs(names) do
            local group = groups[name]

            local label = string.format(
                "%s [x%d | Mutations: %d]",
                name,
                group.Count,
                group.MutatedCount
            )

            if group.EquippedCount > 0 then
                label ..= " [Equipped]"
            end

            table.insert(newOptions, label)
        end

        if #newOptions == 0 then
            table.insert(newOptions, "None")
        end

        local updatedSelection = "None"

        if SelectedDiamondPetName ~= "" then
            for _, option in ipairs(newOptions) do
                if GetDiamondPetName(option) == SelectedDiamondPetName then
                    updatedSelection = option
                    break
                end
            end
        end

        if updatedSelection == "None" then
            SelectedDiamondPetName = ""
        end

        DiamondPetOptions = newOptions
        OTC.Config.SelectedDiamondPet = updatedSelection

        if DiamondPetDropdown then
            DiamondPetDropdown:Refresh(newOptions)
            DiamondPetDropdown:Set(updatedSelection)
        end
    end)

    IsRefreshingDiamondPets = false

    if not success then
        warn("[OTC Diamond] Pets refresh error:", err)
    end
end

DiamondPetDropdown = PetsTab:CreateDropdown({
    name = "Golden Pets",
    description = "Live inventory with mutation counts and equipped status.",
    options = DiamondPetOptions,
    value = "None",
    flag = "DiamondPetSelection",
    callback = function(value)
        if IsRefreshingDiamondPets then
            return
        end

        if type(value) ~= "string" then
            return
        end

        if value == "None" or value == "No pets" then
            SelectedDiamondPetName = ""
            OTC.Config.SelectedDiamondPet = "None"

            Window:Notify({
                Title = "Diamond Pets",
                Content = "No pet selected.",
                Duration = 3,
            })

            return
        end

        SelectedDiamondPetName = GetDiamondPetName(value)
        OTC.Config.SelectedDiamondPet = value

        Window:Notify({
            Title = "Diamond Pet Selected",
            Content = "Selected: " .. value,
            Duration = 5,
        })
    end,
})

RefreshDiamondPets()

local DiamondOptions = {}
local DiamondCounts = {}

for count, chance in ipairs(MachineConfig.Diamond.Chances) do
    local option = string.format("%d (%.0f%%)", count, chance)

    table.insert(DiamondOptions, option)
    DiamondCounts[option] = count
end

PetsTab:CreateDropdown({
    name = "Diamond Chance",
    description = "Select how many Golden pets to use for each craft.",
    flag = "DiamondChance",
    options = DiamondOptions,
    value = DiamondOptions[1],
    callback = function(value)
        local count = DiamondCounts[value]

        if count then
            OTC.Config.DiamondPetCount = count
        end
    end,
})

PetsTab:CreateToggle({
    name = "Auto Diamond Pets",
    description = "Craft using one mutated pet first, then normal Golden pets.",
    flag = "AutoDiamondPets",
    value = OTC.Config.AutoDiamondPets or false,
    callback = function(value)
        OTC.Config.AutoDiamondPets = value

        if not value then
            return
        end

        task.spawn(function()
            function TeleportToDiamondMachine()
                local character = LocalPlayer.Character
                local root = character
                    and character:FindFirstChild("HumanoidRootPart")

                if not root then
                    return false
                end

                root.CFrame = CFrame.new(
                    -193.060028, 5475.18506, -2005.17615,
                    -0.37682271, 0, -0.926285386,
                    0, 1, 0,
                    0.926285386, 0, -0.37682271
                )

                return true
            end

            if not TeleportToDiamondMachine() then
                warn("[OTC Diamond] Character unavailable.")
                OTC.Config.AutoDiamondPets = false
                return
            end

            task.wait(1)

            while OTC.Config.AutoDiamondPets do
                local success, err = pcall(function()
                    local selectedName = SelectedDiamondPetName

                    if selectedName == "" then
                        return
                    end

                    local replica = DataController:GetReplica()

                    local petData = replica
                        and replica.Data
                        and replica.Data.Pets

                    local pets = petData and petData.Owned

                    if type(pets) ~= "table" then
                        return
                    end

                    local equippedIds = getEquippedIds(petData)
                    local mutatedPet = nil
                    local normalPets = {}

                    local requiredCount = OTC.Config.DiamondPetCount

                    if type(requiredCount) ~= "number"
                        or requiredCount < 1
                        or requiredCount % 1 ~= 0 then
                        return
                    end

                    for id, pet in pairs(pets) do
                        if type(pet) == "table" then
                            local petId = pet.Id or id

                            local eligible =
                                pet.Name == selectedName
                                and pet.Tier == MachineConfig.Diamond.SourceTier
                                and pet.Locked ~= true
                                and pet.Frozen ~= true
                                and not equippedIds[petId]
                                and not pet.Equip
                                and not pet.Equipped
                                and not pet.Enchant
                                and not pet.Enchant2
                                and not pet.Signature
                                and not (
                                    type(pet.Rarity) == "string"
                                    and pet.Rarity:match("^Secret")
                                )

                            if eligible then
                                if HasDiamondMutation(pet) then
                                    if not mutatedPet then
                                        mutatedPet = {
                                            Id = petId,
                                            Mutation = pet.Mutation,
                                        }
                                    end
                                else
                                    table.insert(normalPets, petId)
                                end
                            end
                        end
                    end

                    local selectedPets = {}

                    if mutatedPet then
                        table.insert(selectedPets, mutatedPet.Id)

                        for _, petId in ipairs(normalPets) do
                            table.insert(selectedPets, petId)

                            if #selectedPets >= requiredCount then
                                break
                            end
                        end
                    else
                        for _, petId in ipairs(normalPets) do
                            table.insert(selectedPets, petId)

                            if #selectedPets >= requiredCount then
                                break
                            end
                        end
                    end

                    if #selectedPets ~= requiredCount then
                        return
                    end

                    if mutatedPet and selectedPets[1] ~= mutatedPet.Id then
                        warn("[OTC Diamond] Cancelled: mutated pet is not first.")
                        return
                    end

                    print(
                        "[OTC Diamond] Craft:",
                        selectedName,
                        "| First ID:",
                        tostring(selectedPets[1]),
                        "| Mutation:",
                        mutatedPet and tostring(mutatedPet.Mutation) or "None",
                        "| Total:",
                        #selectedPets
                    )

                    MachineService.MachineCraftRequested:Fire({
                        Machine = "Diamond",
                        Action = "Craft",
                        PetIds = selectedPets,
                    })
                end)

                if not success then
                    warn("[OTC Diamond] Craft error:", err)
                end

                task.wait(OTC.Config.DiamondDelay or 1)
            end
        end)
    end,
})

task.spawn(function()
    while task.wait(1) do
        RefreshDiamondPets()
    end
end)

PetsTab:CreateSection({
    name = "▶ Rainbow"
})

local RainbowPetOptions = {"None"}
local RainbowPetDropdown
local SelectedRainbowPetName = ""
local IsRefreshingRainbowPets = false

function GetRainbowPetName(option)
    if type(option) ~= "string" then
        return ""
    end

    return option:match("^(.-)%s%[") or option
end

function RefreshRainbowPets()
    if IsRefreshingRainbowPets then
        return
    end

    IsRefreshingRainbowPets = true

    local success, err = pcall(function()
        local replica = DataController:GetReplica()
        local petData = replica
            and replica.Data
            and replica.Data.Pets

        local pets = petData and petData.Owned

        if type(pets) ~= "table" then
            return
        end

        local equippedIds = getEquippedIds(petData)
        local groups = {}

        for id, pet in pairs(pets) do
            if type(pet) == "table"
                and type(pet.Name) == "string"
                and pet.Tier == MachineConfig.Shiny.SourceTier
                and pet.Locked ~= true
                and pet.Frozen == nil then

                local petId = pet.Id or id
                local group = groups[pet.Name]

                if not group then
                    group = {
                        Count = 0,
                        EquippedCount = 0,
                    }

                    groups[pet.Name] = group
                end

                group.Count += 1

                if equippedIds[petId] then
                    group.EquippedCount += 1
                end
            end
        end

        local names = {}

        for name in pairs(groups) do
            table.insert(names, name)
        end

        table.sort(names)

        local newOptions = {}

        for _, name in ipairs(names) do
            local group = groups[name]
            local label

            if group.EquippedCount > 0 then
                label = name .. " [Equipped, x" .. tostring(group.Count) .. "]"
            else
                label = name .. " [x" .. tostring(group.Count) .. "]"
            end

            table.insert(newOptions, label)
        end

        local updatedSelection = "None"

        if SelectedRainbowPetName ~= "" then
            for _, option in ipairs(newOptions) do
                if GetRainbowPetName(option) == SelectedRainbowPetName then
                    updatedSelection = option
                    break
                end
            end
        end

        if updatedSelection == "None" then
            SelectedRainbowPetName = ""
        end

        if #newOptions == 0 then
            table.insert(newOptions, "None")
        end

        RainbowPetOptions = newOptions
        OTC.Config.SelectedRainbowPet = updatedSelection

        if RainbowPetDropdown then
            RainbowPetDropdown:Refresh(newOptions)
            RainbowPetDropdown:Set(updatedSelection)
        end
    end)

    IsRefreshingRainbowPets = false

    if not success then
        warn("[OTC Rainbow] Pets refresh error:", err)
    end
end

RainbowPetDropdown = PetsTab:CreateDropdown({
    name = "Diamond Pets",
    description = "Select the Diamond pet to fuse into Rainbow.",
    options = RainbowPetOptions,
    value = "None",
    flag = "RainbowPetSelection",
    callback = function(value)
        if IsRefreshingRainbowPets then
            return
        end

        if value == "None" or value == "No pets" then
            SelectedRainbowPetName = ""
            OTC.Config.SelectedRainbowPet = "None"
        else
            SelectedRainbowPetName = GetRainbowPetName(value)
            OTC.Config.SelectedRainbowPet = value
        end
    end,
})

RefreshRainbowPets()

local RainbowCountOptions = {}
local RainbowCountValues = {}
local RainbowDurationLabels = {
    [2] = "5h",
    [3] = "2h30",
    [4] = "1h",
    [5] = "30s",
}

for count = MachineConfig.Shiny.MinPets, #MachineConfig.Shiny.Durations do
    local option = string.format(
        "%d (%s)",
        count,
        RainbowDurationLabels[count]
    )

    table.insert(RainbowCountOptions, option)
    RainbowCountValues[option] = count
end

local SelectedRainbowCount = RainbowCountOptions[1]

for option, count in pairs(RainbowCountValues) do
    if count == OTC.Config.RainbowPetCount then
        SelectedRainbowCount = option
        break
    end
end

PetsTab:CreateDropdown({
    name = "Rainbow Amount",
    description = "Select the number of Diamond pets and crafting duration.",
    flag = "RainbowAmount",
    options = RainbowCountOptions,
    value = SelectedRainbowCount,
    callback = function(value)
        local count = RainbowCountValues[value]

        if count then
            OTC.Config.RainbowPetCount = count
        end
    end,
})

PetsTab:CreateToggle({
    name = "Auto Rainbow Pets",
    description = "Automatically fuses selected Diamond pets into Rainbow.",
    flag = "AutoRainbowPets",
    value = OTC.Config.AutoRainbowPets,
    callback = function(value)
        OTC.Config.AutoRainbowPets = value

        if not value then
            return
        end

        task.spawn(function()
            function TeleportToRainbowMachine()
                local character = LocalPlayer.Character
                local root = character
                    and character:FindFirstChild("HumanoidRootPart")

                if not root then
                    return false
                end

                root.CFrame = CFrame.new(
                    -106.900513, 11128.2422, -2021.28284,
                    -0.658110976, -0.0182565581, -0.752699971,
                    -0.00705140783, 0.99981159, -0.0180849154,
                    0.752888322, -0.00659428211, -0.658115745
                )

                return true
            end

            if not TeleportToRainbowMachine() then
                warn("[OTC Rainbow] Character unavailable.")
                OTC.Config.AutoRainbowPets = false
                return
            end

            task.wait(1)

            while OTC.Config.AutoRainbowPets do
                local success, err = pcall(function()
                    local replica = DataController:GetReplica()
                    local data = replica and replica.Data
                    local petData = data and data.Pets
                    local pets = petData and petData.Owned

                    if type(pets) ~= "table" then
                        return
                    end

                    local machineData = data.Machines
                        and data.Machines.Shiny

                    local queue = machineData and machineData.Queue

                    if type(queue) == "table" then
                        local now = workspace:GetServerTimeNow()

                        for craftId, craft in pairs(queue) do
                            if type(craft) == "table"
                                and type(craft.EndTime) == "number"
                                and craft.EndTime <= now then

                                MachineService.MachineCraftRequested:Fire({
                                    Machine = "Shiny",
                                    Action = "Claim",
                                    CraftId = craftId,
                                })

                                task.wait(0.3)
                            end
                        end

                        local queueCount = 0

                        for _ in pairs(queue) do
                            queueCount += 1
                        end

                        if queueCount >= MachineConfig.Shiny.MaxQueue then
                            return
                        end
                    end

                    local selectedName = SelectedRainbowPetName
                    local requiredCount = OTC.Config.RainbowPetCount

                    if selectedName == ""
                        or type(requiredCount) ~= "number"
                        or requiredCount < MachineConfig.Shiny.MinPets
                        or requiredCount > #MachineConfig.Shiny.Durations then
                        return
                    end

                    local equippedIds = getEquippedIds(petData)
                    local selectedPets = {}

                    for id, pet in pairs(pets) do
                        if type(pet) == "table" then
                            local petId = pet.Id or id

                            if pet.Name == selectedName
                                and pet.Tier == MachineConfig.Shiny.SourceTier
                                and pet.Locked ~= true
                                and pet.Frozen == nil
                                and not equippedIds[petId]
                                and not pet.Equip
                                and not pet.Equipped then

                                table.insert(selectedPets, petId)

                                if #selectedPets >= requiredCount then
                                    break
                                end
                            end
                        end
                    end

                    if #selectedPets == requiredCount then
                        MachineService.MachineCraftRequested:Fire({
                            Machine = "Shiny",
                            Action = "Start",
                            PetIds = selectedPets,
                        })
                    end
                end)

                if not success then
                    warn("[OTC Rainbow] Craft error:", err)
                end

                task.wait(OTC.Config.RainbowDelay)
            end
        end)
    end,
})

task.spawn(function()
    while task.wait(1) do
        RefreshRainbowPets()
    end
end)

local RainbowClaimToken = 0

function AutoClaimRainbowLoop(token)
    local lastClaims = {}

    while OTC.Config.AutoClaimRainbowPets
        and token == RainbowClaimToken
    do
        local replica = DataController:GetReplica()
        local data = replica and replica.Data
        local machines = data and data.Machines
        local shiny = machines and machines.Shiny
        local queue = shiny and shiny.Queue

        if type(queue) == "table" then
            local now = RainbowServerClock.Now()

            for craftId, craft in pairs(queue) do
                if not OTC.Config.AutoClaimRainbowPets
                    or token ~= RainbowClaimToken
                then
                    return
                end

                if type(craftId) == "string"
                    and type(craft) == "table"
                    and type(craft.EndTime) == "number"
                    and craft.EndTime <= now
                    and (not lastClaims[craftId]
                        or os.clock() - lastClaims[craftId] >= 5)
                then
                    lastClaims[craftId] = os.clock()

                    pcall(function()
                        local character = game:GetService("Players").LocalPlayer.Character
                        local root = character and character:FindFirstChild("HumanoidRootPart")

                        if root then
                            root.CFrame = CFrame.new(
                                -106.900513, 11128.2422, -2021.28284,
                                -0.658110976, -0.0182565581, -0.752699971,
                                -0.00705140783, 0.99981159, -0.0180849154,
                                0.752888322, -0.00659428211, -0.658115745
                            )
                        end
                    end)

                    task.wait(0.25)

                    pcall(function()
                        RainbowClaimEvent:FireServer({
                            Machine = "Shiny",
                            Action = "Claim",
                            CraftId = craftId
                        })
                    end)

                    task.wait(0.25)
                end
            end

            for craftId in pairs(lastClaims) do
                if queue[craftId] == nil then
                    lastClaims[craftId] = nil
                end
            end
        end

        task.wait(1)
    end
end

PetsTab:CreateToggle({
    name = "Auto Claim Rainbow Pets",
    description = "Automatically claim completed Rainbow pets",
    flag = "AutoClaimRainbowPets",
    value = OTC.Config.AutoClaimRainbowPets,
    callback = function(value)
        OTC.Config.AutoClaimRainbowPets = value
        RainbowClaimToken += 1

        if value then
            local token = RainbowClaimToken

            task.spawn(function()
                local ok, err = pcall(function()
                    AutoClaimRainbowLoop(token)
                end)

                if not ok then
                    warn("[AutoClaimRainbow] Error:", err)
                end
            end)
        end
    end
})

PetsTab:CreateSection({
    name = "▶ Enchant"
})

OTC.Config.AutoEnchant = false
OTC.Config.SelectedEnchantPet = OTC.Config.SelectedEnchantPet or ""
OTC.Config.SelectedEnchantSlot = OTC.Config.SelectedEnchantSlot or 1
OTC.Config.SelectedEnchantTypes = OTC.Config.SelectedEnchantTypes or {}

local EnchantPetDropdown
local EnchantPetOptions = {}
local EnchantPetIds = {}
local SelectedEnchantPetId
local SelectedEnchantTypes = {}
local SelectedEnchantSlot = OTC.Config.SelectedEnchantSlot
local AutoEnchantToken = 0

local EnchantPosition = CFrame.new(
    127.143799, 7695.35156, -1802.73132,
    0.972156405, -0.0243377797, -0.23306559,
    0.0274353698, 0.999572992, 0.0100576207,
    0.232721284, -0.0161718223, 0.97240901
)

function GetEnchantPetData()
    local success, replica = pcall(function()
        return DataController:GetReplica()
    end)

    if not success or not replica or not replica.Data then
        return nil, nil
    end

    local data = replica.Data
    local pets = data.Pets

    if type(pets) ~= "table" or type(pets.Owned) ~= "table" then
        return data, nil
    end

    return data, pets
end

function GetSelectedEnchantList()
    local result = {}

    for enchantName, enabled in pairs(SelectedEnchantTypes) do
        if enabled and EnchantConfig.IsFilterable(enchantName) then
            table.insert(result, enchantName)
        end
    end

    table.sort(result)

    return result
end

function RefreshEnchantPets()
    table.clear(EnchantPetOptions)
    table.clear(EnchantPetIds)

    local _, pets = GetEnchantPetData()

    if not pets then
        return
    end

    local equipped = {}

    for _, petId in ipairs(pets.Equipped or {}) do
        equipped[petId] = true
    end

    for petId, pet in pairs(pets.Owned) do
        if type(pet) == "table" then
            local name = tostring(pet.Name or "Pet")
            local isEquipped = equipped[petId] or pet.Equip == true
            local labels = {}

            if isEquipped then
                table.insert(labels, "Equipped")
            end

            if type(pet.Enchant) == "string" and pet.Enchant ~= "" then
                table.insert(labels, "Slot 1: " .. pet.Enchant)
            end

            if type(pet.Enchant2) == "string" and pet.Enchant2 ~= "" then
                table.insert(labels, "Slot 2: " .. pet.Enchant2)
            end

            local label = name

            if #labels > 0 then
                label ..= " [" .. table.concat(labels, ", ") .. "]"
            end

            if EnchantPetIds[label] then
                label ..= " [" .. tostring(petId) .. "]"
            end

            table.insert(EnchantPetOptions, label)
            EnchantPetIds[label] = petId
        end
    end

    table.sort(EnchantPetOptions)

    if EnchantPetDropdown then
        pcall(function()
            EnchantPetDropdown:Refresh(EnchantPetOptions)
        end)
    end
end

local EnchantTypeOptions = {}

for enchantName in pairs(EnchantConfig.Enchants) do
    if EnchantConfig.IsFilterable(enchantName) then
        table.insert(EnchantTypeOptions, enchantName)
    end
end

table.sort(EnchantTypeOptions)

PetsTab:CreateDropdown({
    name = "Enchant Type",
    description = "Select multiple enchants. Stops when a selected enchant is obtained.",
    options = EnchantTypeOptions,
    value = {},
    multiSelect = true,
    flag = "SelectedEnchantTypes",
    callback = function(value)
        table.clear(SelectedEnchantTypes)

        if type(value) == "table" then
            for _, enchantName in ipairs(value) do
                SelectedEnchantTypes[enchantName] = true
            end
        elseif type(value) == "string" then
            SelectedEnchantTypes[value] = true
        end

        OTC.Config.SelectedEnchantTypes = GetSelectedEnchantList()
    end
})

PetsTab:CreateDropdown({
    name = "Enchant Slot",
    description = "Choose which enchant slot to roll.",
    options = {"Slot 1", "Slot 2"},
    value = SelectedEnchantSlot == 2 and "Slot 2" or "Slot 1",
    flag = "SelectedEnchantSlot",
    callback = function(value)
        if type(value) == "table" then
            value = value[1]
        end

        if value == "Slot 1" then
            SelectedEnchantSlot = 1
        elseif value == "Slot 2" then
            SelectedEnchantSlot = 2
        else
            return
        end

        OTC.Config.SelectedEnchantSlot = SelectedEnchantSlot

        Window:Notify({
            Title = "Enchant Slot",
            Content = "Selected: " .. value,
            Duration = 3
        })
    end
})

EnchantPetDropdown = PetsTab:CreateDropdown({
    name = "Select Pet",
    description = "Select the pet to enchant.",
    options = EnchantPetOptions,
    value = "",
    multiSelect = false,
    flag = "SelectedEnchantPet",
    callback = function(value)
        if type(value) == "table" then
            value = value[1]
        end

        SelectedEnchantPetId = EnchantPetIds[value]
        OTC.Config.SelectedEnchantPet = SelectedEnchantPetId or ""

        if SelectedEnchantPetId then
            Window:Notify({
                Title = "Enchant",
                Content = "Selected: " .. tostring(value)
                    .. "\nPet ID: " .. tostring(SelectedEnchantPetId),
                Duration = 5
            })
        else
            Window:Notify({
                Title = "Enchant",
                Content = "No pet selected.",
                Duration = 3
            })
        end
    end
})

RefreshEnchantPets()

function StartAutoEnchant()
    if not SelectedEnchantPetId then
        Window:Notify({
            Title = "Auto Enchant",
            Content = "Select a pet first.",
            Duration = 3
        })
        return false
    end

    local desired = GetSelectedEnchantList()

    if #desired == 0 then
        Window:Notify({
            Title = "Auto Enchant",
            Content = "Select at least one enchant.",
            Duration = 3
        })
        return false
    end

    local _, pets = GetEnchantPetData()
    local pet = pets and pets.Owned[SelectedEnchantPetId]

    if not pet then
        warn("[Auto Enchant] Pet not found:", SelectedEnchantPetId)
        return false
    end

    local currentEnchant

    if SelectedEnchantSlot == 1 then
        currentEnchant = pet.Enchant
    elseif SelectedEnchantSlot == 2 then
        currentEnchant = pet.Enchant2
    else
        warn("[Auto Enchant] Invalid slot:", SelectedEnchantSlot)
        return false
    end

    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        warn("[Auto Enchant] Character unavailable.")
        return false
    end

    root.CFrame = EnchantPosition
    task.wait(0.5)

    local filtersOK, filtersResult = pcall(function()
        return EnchantService:SetFilters(desired)
    end)

    if not filtersOK then
        warn("[Auto Enchant] SetFilters error:", filtersResult)
        return false
    end

    if type(filtersResult) == "table"
        and filtersResult.Success == false then
        warn("[Auto Enchant] SetFilters rejected:", filtersResult.Reason)
        return false
    end

    local startOK, startResult = pcall(function()
        return EnchantService:AutoStart({
            PetId = SelectedEnchantPetId,
            Slot = SelectedEnchantSlot,
            Replace = currentEnchant
        })
    end)

    if not startOK then
        warn("[Auto Enchant] AutoStart error:", startResult)
        return false
    end

    if type(startResult) ~= "table" or startResult.Success ~= true then
        local reason = type(startResult) == "table"
            and startResult.Reason
            or "Unknown"

        warn("[Auto Enchant] AutoStart rejected:", reason)

        Window:Notify({
            Title = "Auto Enchant",
            Content = "Failed to start: " .. tostring(reason),
            Duration = 4
        })

        return false
    end

    Window:Notify({
        Title = "Auto Enchant",
        Content = "Auto Enchant started on Slot " .. SelectedEnchantSlot .. ".",
        Duration = 3
    })

    return true
end

function ClaimEnchantPet(token)
    while OTC.Config.AutoEnchant and token == AutoEnchantToken do
        if LocalPlayer:GetAttribute("EnchantHeldState") == "Done" then
            local heldResult = LocalPlayer:GetAttribute("EnchantHeldResult")

            local ok, result = pcall(function()
                return EnchantService:Claim()
            end)

            if not ok then
                warn("[Auto Enchant] Claim error:", result)
                return false
            end

            if type(result) == "table" and result.Success == true then
                Window:Notify({
                    Title = "Auto Enchant",
                    Content = "Obtained " .. tostring(heldResult) .. "! Pet claimed.",
                    Duration = 4
                })

                return true
            end

            warn(
                "[Auto Enchant] Claim rejected:",
                type(result) == "table" and result.Reason or result
            )

            return false
        end

        task.wait(0.1)
    end

    return false
end

function StopAutoEnchant()
    local success, err = pcall(function()
        return EnchantService:AutoStop()
    end)

    if not success then
        warn("[Enchant] Stop error:", err)
    end
end

PetsTab:CreateToggle({
    name = "Auto Enchant",
    description = "Rolls the selected slot until a selected enchant is obtained.",
    value = false,
    flag = "AutoEnchant",
    callback = function(value)
        OTC.Config.AutoEnchant = value
        AutoEnchantToken += 1

        local token = AutoEnchantToken

        if not value then
            StopAutoEnchant()
            return
        end

        task.spawn(function()
            local success, result = pcall(StartAutoEnchant)

            if not success then
                warn("[Enchant] Start error:", result)
            end

            if not success or not result then
                if token == AutoEnchantToken then
                    OTC.Config.AutoEnchant = false
                end
                return
            end

            if token ~= AutoEnchantToken or not OTC.Config.AutoEnchant then
                return
            end

            local claimOK, claimResult = pcall(ClaimEnchantPet, token)

            if not claimOK then
                warn("[Enchant] Claim error:", claimResult)
            elseif not claimResult then
                warn("[Enchant] Claim did not complete.")
            end
        end)
    end
})

task.spawn(function()
    while task.wait(2) do
        RefreshEnchantPets()
    end
end)

local AutoEquipBestPets = false
local AutoEquipBestSession = 0

PetsTab:CreateToggle({
    name = "Auto Equip Best Pets",
    description = "Automatically equips your best pets based on Clicks.",
    flag = "AutoEquipBestPets",
    value = false,
    callback = function(value)
        AutoEquipBestPets = value
        AutoEquipBestSession += 1

        local session = AutoEquipBestSession

        if not value then
            return
        end

        task.spawn(function()
            while AutoEquipBestPets
                and AutoEquipBestSession == session do

                local success, err = pcall(function()
                    PetService.PetActionRequested:Fire({
                        Action = "EquipBest",
                        Mode = "Clicks",
                    })
                end)

                if not success then
                    warn("[OTC Auto Equip] Error:", err)
                end

                task.wait(1)
            end
        end)
    end,
})

local EggOptions = {}
local EggNames = {}

local OriginalHatchPlay = HatchRenderer.Play
local OriginalSecretPlay = SecretHatchRenderer.Play
local OriginalSecretPlayReveal = SecretHatchRenderer.PlayReveal

function IsHatchAnimationDisabled()
    return workspace:GetAttribute("DisableEggHatchAnimation") == true
end

HatchRenderer.Play = function(self, ...)
    if IsHatchAnimationDisabled() then
        local args = {...}
        local callback = args[3]

        if type(callback) == "function" then
            task.defer(callback)
        end

        return
    end

    return OriginalHatchPlay(self, ...)
end

SecretHatchRenderer.Play = function(self, ...)
    if IsHatchAnimationDisabled() then
        local args = {...}
        local callback = args[2]

        if type(callback) == "function" then
            task.defer(callback)
        end

        return
    end

    return OriginalSecretPlay(self, ...)
end

SecretHatchRenderer.PlayReveal = function(self, ...)
    if IsHatchAnimationDisabled() then
        local args = {...}
        local callback = args[2]

        if type(callback) == "function" then
            task.defer(callback)
        end

        return
    end

    return OriginalSecretPlayReveal(self, ...)
end

function FormatEggPrice(price)
    local suffixes = {
        {1e15, "Qa"},
        {1e12, "T"},
        {1e9, "B"},
        {1e6, "M"},
        {1e3, "K"},
    }

    for _, suffix in ipairs(suffixes) do
        local threshold = suffix[1]
        local label = suffix[2]

        if price >= threshold then
            local formatted = string.format("%.2f", price / threshold)
            formatted = formatted:gsub("%.?0+$", "")
            return formatted .. label
        end
    end

    return tostring(price)
end

for eggName, config in pairs(LaunchEggConfig) do
    if type(config) == "table"
        and type(config.Price) == "number" then
        table.insert(EggNames, eggName)
    end
end

table.sort(EggNames, function(a, b)
    return LaunchEggConfig[a].Price < LaunchEggConfig[b].Price
end)

for _, eggName in ipairs(EggNames) do
    local price = LaunchEggConfig[eggName].Price

    table.insert(
        EggOptions,
        string.format(
            "%s [%s Coins]",
            eggName,
            FormatEggPrice(price)
        )
    )
end

local EggOptionToName = {}

for _, option in ipairs(EggOptions) do
    local eggName = option:match("^(.-) %[")

    if eggName then
        EggOptionToName[option] = eggName
    end
end

local SelectedEggOption

for option, eggName in pairs(EggOptionToName) do
    if eggName == OTC.Config.SelectedEgg then
        SelectedEggOption = option
        break
    end
end

EggsTab:CreateDropdown({
    name = "Eggs",
    description = "Select an egg to hatch.",
    flag = "Eggs",
    options = EggOptions,
    value = SelectedEggOption or EggOptions[1],
    callback = function(value)
        local eggName = EggOptionToName[value]

        if eggName then
            OTC.Config.SelectedEgg = eggName
        end
    end,
})

local AmountOptions = {
    "1 Egg",
    "3 Eggs",
    "8 Eggs",
}

local AmountValues = {
    ["1 Egg"] = 1,
    ["3 Eggs"] = 3,
    ["8 Eggs"] = 8,
}

local SelectedAmount = "1 Egg"

for option, amount in pairs(AmountValues) do
    if amount == OTC.Config.HatchAmount then
        SelectedAmount = option
        break
    end
end

EggsTab:CreateDropdown({
    name = "Amount",
    description = "Choose how many eggs to hatch per request.",
    flag = "Amount",
    options = AmountOptions,
    value = SelectedAmount,
    callback = function(value)
        local amount = AmountValues[value]

        if amount then
            OTC.Config.HatchAmount = amount
        end
    end,
})

EggsTab:CreateToggle({
    name = "Disable Egg Hatch Animation",
    description = "Skips normal and Secret hatch animations.",
    flag = "DisableEggHatchAnimation",
    value = OTC.Config.DisableEggHatchAnimation or false,
    callback = function(value)
        OTC.Config.DisableEggHatchAnimation = value
        workspace:SetAttribute("DisableEggHatchAnimation", value)
    end,
})

function TeleportToEgg()
    local eggName = OTC.Config.SelectedEgg
    local eggConfig = eggName and LaunchEggConfig[eggName]

    if not eggConfig then
        warn("[OTC Eggs] Selected egg does not exist.")
        return false
    end

    local islandName = eggConfig.Island or "Spawn"
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        warn("[OTC Eggs] Character unavailable.")
        return false
    end

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Travel = ReplicatedStorage.RemoteServices.IslandService.RF.Travel

    if islandName == "Spawn" then
        local success, result = pcall(function()
            return Travel:InvokeServer({
                Source = "Menu",
                Island = "Spawn"
            })
        end)

        if not success then
            warn("[OTC Eggs] Travel to Spawn failed:", result)
            return false
        end
    else
        local landing = IslandLandings[islandName]

        if not landing or typeof(landing.Position) ~= "Vector3" then
            warn("[OTC Eggs] Island landing not found:", islandName)
            return false
        end

        root.CFrame = CFrame.new(landing.Position + Vector3.new(0, 5, 0))
    end

    task.wait(0.75)

    local eggsFolder = workspace:FindFirstChild("Eggs")
    local eggModel = eggsFolder and eggsFolder:FindFirstChild(eggName)

    if not eggModel or not eggModel:IsA("Model") then
        warn("[OTC Eggs] Egg model not found:", eggName)
        return false
    end

    root = LocalPlayer.Character
        and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not root then
        return false
    end

    root.CFrame = eggModel:GetPivot() + Vector3.new(0, 10, 0)

    return true
end


local HatchSession = 0

EggsTab:CreateToggle({
    name = "Auto Hatch",
    description = "Teleport to the selected egg and hatch automatically.",
    flag = "AutoHatch",
    value = OTC.Config.AutoHatch,
    callback = function(value)
        OTC.Config.AutoHatch = value
        HatchSession += 1

        local session = HatchSession

        if not value then
            return
        end

        task.spawn(function()
            if not TeleportToEgg() then
                warn("[OTC Eggs] Egg model not found or character unavailable.")

                if HatchSession == session then
                    OTC.Config.AutoHatch = false
                end

                return
            end

            task.wait(1)

            while OTC.Config.AutoHatch and HatchSession == session do
                local success, err = pcall(function()
                    local eggName = OTC.Config.SelectedEgg
                    local amount = OTC.Config.HatchAmount

                    if not LaunchEggConfig[eggName] then
                        return
                    end

                    if not table.find({1, 3, 8}, amount) then
                        return
                    end

                    OTC.Config.HatchSequence += 1

                    EggService.EggHatchRequested:Fire({
                        Egg = eggName,
                        Count = amount,
                        Auto = false,
                        Seq = OTC.Config.HatchSequence,
                    })
                end)

                if not success then
                    warn("[OTC Eggs] Auto Hatch error:", err)
                end

                task.wait(OTC.Config.HatchDelay)
            end
        end)
    end,
})

local AutoDig = false
local AutoDigSession = 0

function TeleportToDigZone()
    local islands = workspace:FindFirstChild("Ts2Islands")
    local autumn = islands and islands:FindFirstChild("Autumn")
    local digsite = autumn and autumn:FindFirstChild("Digsite")
    local digZone = digsite and digsite:FindFirstChild("DigZone")

    if not digZone then
        return false
    end

    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        return false
    end

    local targetPosition

    if digZone:IsA("BasePart") then
        targetPosition = digZone.Position
    elseif digZone:IsA("Model") then
        targetPosition = digZone:GetPivot().Position
    else
        local part = digZone:FindFirstChildWhichIsA("BasePart", true)

        if not part then
            return false
        end

        targetPosition = part.Position
    end

    root.CFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 0))
    task.wait(0.5)

    return true
end

local lastRewardClose = 0

function HandleDigReward()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then
        return false
    end

    for _, object in ipairs(playerGui:GetDescendants()) do
        if object:IsA("TextLabel")
            and object.Visible
            and object.Text:find("Tap anywhere to close", 1, true) then

            if os.clock() - lastRewardClose < 2 then
                return false
            end

            lastRewardClose = os.clock()

            pcall(function()
                DigRewardPopup:Close()
            end)

            return true
        end
    end

    return false
end

function TryActivate()
    local success, result = pcall(function()
        return DigController:Activate()
    end)

    if not success then
        return false
    end

    if typeof(result) == "table" and result.Error then
        return false
    end

    return true
end

MinigamesTab:CreateToggle({
    name = "Auto Dig",
    description = "Teleports to the Autumn Digsite and automatically digs.",
    flag = "AutoDig",
    value = false,

    callback = function(value)
        AutoDig = value
        AutoDigSession += 1

        local session = AutoDigSession

        if not value then
            return
        end

        task.spawn(function()
            if not TeleportToDigZone() then
                if AutoDigSession == session then
                    AutoDig = false
                end
                return
            end

            local lastStartAttempt = 0
            local lastRoundSequence = nil

            while AutoDig and AutoDigSession == session do
                local success = pcall(function()
                    if HandleDigReward() then
                        task.wait(0.5)
                        return
                    end

                    local state = DigController:GetState()

                    if not state then
                        if os.clock() - lastStartAttempt >= 0.5 then
                            lastStartAttempt = os.clock()
                            TryActivate()
                        end

                        task.wait(0.2)
                        return
                    end

                    local round = state.Round

                    if not round then
                        if os.clock() - lastStartAttempt >= 0.5 then
                            lastStartAttempt = os.clock()
                            TryActivate()
                        end

                        task.wait(0.2)
                        return
                    end

                    if lastRoundSequence ~= round.Sequence then
                        lastRoundSequence = round.Sequence
                    end

                    local sequence = round.Sequence

                    while AutoDig and AutoDigSession == session do
                        if HandleDigReward() then
                            break
                        end

                        local currentState = DigController:GetState()

                        if not currentState
                            or not currentState.Round
                            or currentState.Round.Sequence ~= sequence then
                            break
                        end

                        local now = workspace:GetServerTimeNow()
                        local cursor = DigConfig.Cursor(round, now)
                        local distance = math.abs(cursor - round.Center)

                        if now >= round.Epoch
                            and distance <= round.Width * 0.35 then

                            TryActivate()
                            task.wait(DigConfig.MinHitInterval or 0.16)
                            break
                        end

                        RunService.Heartbeat:Wait()
                    end
                end)

                if not success then
                    task.wait(0.5)
                end

                task.wait(0.05)
            end
        end)
    end,
})

local AutoPetDefense = false
local AutoPetDefenseSession = 0

function TeleportToColosseum()
    local island = workspace:FindFirstChild("WaveDefence Island")
    local waveDefense = island and island:FindFirstChild("WaveDefense")
    local colosseum = waveDefense and waveDefense:FindFirstChild("Colosseum")

    if not colosseum then
        return false
    end

    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        return false
    end

    local targetPosition

    if colosseum:IsA("BasePart") then
        targetPosition = colosseum.Position
    elseif colosseum:IsA("Model") then
        targetPosition = colosseum:GetPivot().Position
    else
        local part = colosseum:FindFirstChildWhichIsA("BasePart", true)

        if not part then
            return false
        end

        targetPosition = part.Position
    end

    root.CFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 0))
    return true
end

function StartPetDefense()
    if not TeleportToColosseum() then
        return false
    end

    task.wait(1)

    local opened = pcall(function()
        ColosseumClientAdapter.Signals.Fire("StartColosseum")
    end)

    if not opened then
        return false
    end

    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local yesButton

    for _ = 1, 50 do
        local tabs = playerGui:FindFirstChild("Tabs")
        local message = tabs and tabs:FindFirstChild("Message")
        local menu = message and message:FindFirstChild("Menu")
        local actions = menu and menu:FindFirstChild("Actions")
        local yes = actions and actions:FindFirstChild("Yes")
        local button = yes and yes:FindFirstChild("Button")

        if button and button:IsA("GuiButton") and button.Visible then
            yesButton = button
            break
        end

        task.wait(0.1)
    end

    if not yesButton or typeof(firesignal) ~= "function" then
        return false
    end

    local clicked = pcall(function()
        firesignal(yesButton.Activated)
    end)

    if not clicked then
        return false
    end

    for _ = 1, 100 do
        if LocalPlayer:GetAttribute("ColosseumActive") == true then
            return true
        end

        task.wait(0.1)
    end

    return false
end

MinigamesTab:CreateToggle({
    name = "Auto Pet Defense",
    description = "Battle with Enemies",
    flag = "AutoPetDefense",
    value = false,

    callback = function(value)
        AutoPetDefense = value
        AutoPetDefenseSession += 1

        local session = AutoPetDefenseSession

        if not value then
            return
        end

        task.spawn(function()
            local started = StartPetDefense()

            if not AutoPetDefense or AutoPetDefenseSession ~= session then
                return
            end

            if not started then
                return
            end

            while AutoPetDefense and AutoPetDefenseSession == session do
                local success = pcall(function()
                    if LocalPlayer:GetAttribute("ColosseumActive") ~= true then
                        task.wait(0.25)
                        return
                    end

                    ColosseumClientAdapter.Signals.Fire("PlayerTapped")

                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    local waveDefense = playerGui and playerGui:FindFirstChild("WaveDefense")
                    local waveHUD = waveDefense and waveDefense:FindFirstChild("WaveHUD")
                    local criticals = waveHUD and waveHUD:FindFirstChild("Criticals")

                    if criticals and typeof(firesignal) == "function" then
                        for _, critical in ipairs(criticals:GetChildren()) do
                            if critical.Name == "CriticalActive" then
                                local button = critical:FindFirstChild("Button")

                                if button and button:IsA("GuiButton") then
                                    firesignal(button.Activated)
                                end
                            end
                        end
                    end
                end)

                task.wait(success and 0.22 or 0.5)
            end
        end)
    end,
})

local MiningController = nil
local MiningService = nil
local MiningConfig = nil

local MiningLogHistory = {}
local MAX_MINING_LOGS = 8

local PortalTarget = Vector3.new(12.794289, 5448.823242, -1884.811035)
local OutsidePosition = Vector3.new(5.45, 5436.12, -1878.03)

local REFRESH_INTERVAL = 300
local RETURN_DELAY = 3

local MineRefreshInProgress = false
local MineRefreshBusy = false
local AutoMineBusy = false
local MiningIndex = 1

local MiningLog = MinigamesTab:CreateText({
    name = "Mining Logs",
    text = "AutoMine ready."
})

function UpdateMiningLog(Message)
    table.insert(
        MiningLogHistory,
        1,
        "[" .. os.date("%H:%M:%S") .. "] " .. tostring(Message)
    )

    while #MiningLogHistory > MAX_MINING_LOGS do
        table.remove(MiningLogHistory)
    end

    pcall(function()
        MiningLog:Set(table.concat(MiningLogHistory, "\n"))
    end)
end

function GetMiningController()
    if MiningController then
        return MiningController
    end

    local Controllers = ReplicatedStorage:FindFirstChild("Controllers")
    local Minigames = Controllers and Controllers:FindFirstChild("Minigames")
    local Module = Minigames and Minigames:FindFirstChild("MiningController")

    if not Module then
        UpdateMiningLog("Controller module not found")
        return nil
    end

    local Success, Result = pcall(require, Module)

    if Success then
        MiningController = Result
        return Result
    end

    UpdateMiningLog("Controller error: " .. tostring(Result))
    return nil
end

function GetMiningService()
    if MiningService then
        return MiningService
    end

    local CommModule = ReplicatedStorage:FindFirstChild("Packages")
        and ReplicatedStorage.Packages:FindFirstChild("Comm")

    local RemoteServices = ReplicatedStorage:FindFirstChild("RemoteServices")

    if not CommModule or not RemoteServices then
        UpdateMiningLog("Mining service dependencies missing")
        return nil
    end

    local Success, Result = pcall(function()
        local Comm = require(CommModule)

        return Comm.ClientComm.new(
            RemoteServices,
            false,
            "MiningService"
        ):BuildObject()
    end)

    if Success then
        MiningService = Result
        return Result
    end

    UpdateMiningLog("Service error: " .. tostring(Result))
    return nil
end

function GetMiningConfig()
    if MiningConfig then
        return MiningConfig
    end

    local Shared = ReplicatedStorage:FindFirstChild("Shared")
    local Minigames = Shared and Shared:FindFirstChild("Minigames")
    local Mining = Minigames and Minigames:FindFirstChild("Mining")
    local Module = Mining and Mining:FindFirstChild("MiningConfig")

    if not Module then
        UpdateMiningLog("MiningConfig not found")
        return nil
    end

    local Success, Result = pcall(require, Module)

    if Success then
        MiningConfig = Result
        return Result
    end

    UpdateMiningLog("Config error: " .. tostring(Result))
    return nil
end

function GetMiningState()
    local Controller = GetMiningController()

    if not Controller then
        return nil
    end

    local Success, State = pcall(function()
        return Controller:GetState()
    end)

    if Success and type(State) == "table" and State.Id then
        return State
    end

    if not Success then
        UpdateMiningLog("State error: " .. tostring(State))
    end

    return nil
end

function ParseMiningCell(Block)
    local X, Y, Z = Block.Name:match(
        "^(-?%d+):(-?%d+):(-?%d+)$"
    )

    if not X then
        return nil
    end

    return tonumber(X), tonumber(Y), tonumber(Z)
end

function GetMiningBlock(BlockName)
    local Folder = workspace:FindFirstChild("LocalMiningBlocks")
    return Folder and Folder:FindFirstChild(BlockName)
end

function GetMiningBlockPosition(BlockName)
    local Block = GetMiningBlock(BlockName)

    if not Block then
        return nil
    end

    if Block:IsA("BasePart") then
        return Block.Position
    end

    if Block:IsA("Model") then
        return Block:GetPivot().Position
    end

    local Part = Block:FindFirstChildWhichIsA("BasePart", true)
    return Part and Part.Position or nil
end

function MoveNearMiningBlock(Position)
    if MineRefreshInProgress then
        return false
    end

    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if not Root or not Position then
        UpdateMiningLog("Character root or block position missing")
        return false
    end

    if (Root.Position - Position).Magnitude <= 12 then
        return true
    end

    local Success, ErrorMessage = pcall(function()
        Character:PivotTo(
            CFrame.new(Position + Vector3.new(0, 5, 0))
        )
    end)

    if not Success then
        UpdateMiningLog("Move error: " .. tostring(ErrorMessage))
        return false
    end

    task.wait(0.3)

    if MineRefreshInProgress then
        return false
    end

    Character = LocalPlayer.Character
    Root = Character and Character:FindFirstChild("HumanoidRootPart")

    local InRange = Root ~= nil
        and (Root.Position - Position).Magnitude <= 12

    if not InRange then
        UpdateMiningLog("Move failed: still too far from block")
    end

    return InRange
end

function GetMiningBlockStats(State, Cell)
    local Config = GetMiningConfig()

    if not Config or not State or not Cell then
        return nil
    end

    local Success, Ore = pcall(function()
        return Config.Ore(
            State.Seed,
            Cell.X,
            Cell.Y,
            Cell.Z
        )
    end)

    if not Success or not Ore then
        return nil
    end

    local MaxHP = tonumber(Ore.health) or 0
    local Damage = tonumber((State.Damage or {})[Cell.Name]) or 0

    return {
        Name = tostring(Ore.name or "Unknown"),
        MaxHP = MaxHP,
        Damage = Damage,
        CurrentHP = math.max(0, MaxHP - Damage)
    }
end

function GetMiningCandidates()
    local Folder = workspace:FindFirstChild("LocalMiningBlocks")
    local Candidates = {}

    if not Folder then
        UpdateMiningLog("LocalMiningBlocks folder not found")
        return Candidates
    end

    for _, Block in ipairs(Folder:GetChildren()) do
        local X, Y, Z = ParseMiningCell(Block)

        if X and Y and Z then
            table.insert(Candidates, {
                Name = Block.Name,
                X = X,
                Y = Y,
                Z = Z
            })
        end
    end

    table.sort(Candidates, function(A, B)
        return A.Name < B.Name
    end)

    return Candidates
end

function HitMiningCell(State, Cell)
    if MineRefreshInProgress then
        return false
    end

    local Block = GetMiningBlock(Cell.Name)

    if not Block or not Block.Parent then
        UpdateMiningLog("Skipped missing block: " .. Cell.Name)
        return false
    end

    local Position = GetMiningBlockPosition(Cell.Name)

    if not Position or not MoveNearMiningBlock(Position) then
        return false
    end

    if MineRefreshInProgress then
        return false
    end

    Block = GetMiningBlock(Cell.Name)

    if not Block or not Block.Parent then
        UpdateMiningLog("Skipped removed block: " .. Cell.Name)
        return false
    end

    local Service = GetMiningService()

    if not Service then
        UpdateMiningLog("Mining service unavailable")
        return false
    end

    if MineRefreshInProgress then
        return false
    end

    local Before = GetMiningBlockStats(State, Cell)

    local Success, Result = pcall(function()
        return Service:Hit(
            State.Id,
            Cell.X,
            Cell.Y,
            Cell.Z
        )
    end)

    if not Success then
        UpdateMiningLog(
            "Hit error: " .. Cell.Name .. " | " .. tostring(Result)
        )
        return false
    end

    if type(Result) ~= "table" then
        UpdateMiningLog("Unexpected result: " .. Cell.Name)
        return false
    end

    if Result.Blocked == true then
        UpdateMiningLog("Blocked; next block: " .. Cell.Name)
        return false
    end

    if Result.Error then
        local ErrorText = tostring(Result.Error)

        if ErrorText:find("behind solid rock", 1, true) then
            UpdateMiningLog("Solid rock; next block: " .. Cell.Name)
        elseif ErrorText:find("Move closer", 1, true) then
            UpdateMiningLog("Move closer rejected: " .. Cell.Name)
        else
            UpdateMiningLog("Server error: " .. ErrorText)
        end

        return false
    end

    if Result.Throttled then
        UpdateMiningLog("Throttled: " .. Cell.Name)
        return false
    end

    local UpdatedState = GetMiningState()
    local After = GetMiningBlockStats(UpdatedState or State, Cell)
    local ServerDamage = tonumber(Result.Damage)

    if After and ServerDamage then
        After.Damage = math.max(After.Damage, ServerDamage)
        After.CurrentHP = math.max(0, After.MaxHP - After.Damage)
    end

    local OreName = tostring(
        Result.Ore
        or (Before and Before.Name)
        or "Unknown"
    )

    if After then
        UpdateMiningLog(string.format(
            "%s | %s | HP %s/%s | Damage %s",
            Cell.Name,
            OreName,
            tostring(After.CurrentHP),
            tostring(After.MaxHP),
            tostring(After.Damage)
        ))
    else
        UpdateMiningLog(
            "Hit successful: " .. Cell.Name .. " | " .. OreName
        )
    end

    if Result.Broken == true then
        UpdateMiningLog("BROKEN: " .. Cell.Name .. " | " .. OreName)
    end

    return true
end

MinigamesTab:CreateSection({
    name = "▶ Mining"
})

MinigamesTab:CreateToggle({
    name = "Auto Mine",
    description = "Automatically mines blocks",
    flag = "AutoMine",
    callback = function(Value)
        OTC.Config.AutoMine = Value

        UpdateMiningLog(
            Value and "AutoMine enabled" or "AutoMine disabled"
        )
    end
})

task.spawn(function()
    while task.wait(0.1) do
        if OTC.Config.AutoMine
            and not AutoMineBusy
            and not MineRefreshInProgress then

            AutoMineBusy = true

            local Success, ErrorMessage = pcall(function()
                if MineRefreshInProgress then
                    return
                end

                local State = GetMiningState()

                if not State then
                    UpdateMiningLog("Mining state unavailable")
                    return
                end

                local Candidates = GetMiningCandidates()

                if #Candidates == 0 then
                    MiningIndex = 1
                    return
                end

                if MiningIndex > #Candidates then
                    MiningIndex = 1
                end

                local Cell = Candidates[MiningIndex]
                MiningIndex += 1

                if not MineRefreshInProgress then
                    HitMiningCell(State, Cell)
                end
            end)

            if not Success then
                UpdateMiningLog("AutoMine error: " .. tostring(ErrorMessage))
            end

            AutoMineBusy = false

            task.wait(math.max(
                0.1,
                tonumber(OTC.Config.AutoMineDelay) or 0.15
            ))
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if OTC.Config.AutoMine
            and not MineRefreshBusy
            and not MineRefreshInProgress
            and os.clock() - (OTC.Config.LastMineRefresh or os.clock()) >= REFRESH_INTERVAL then

            MineRefreshBusy = true
            MineRefreshInProgress = true

            local Success, ErrorMessage = pcall(function()
                UpdateMiningLog("Mine refresh started")

                while AutoMineBusy do
                    task.wait(0.05)
                end

                if not OTC.Config.AutoMine then
                    return
                end

                local Character = LocalPlayer.Character
                    or LocalPlayer.CharacterAdded:Wait()

                local Root = Character:FindFirstChild("HumanoidRootPart")

                if not Root then
                    UpdateMiningLog("Refresh failed: character root missing")
                    return
                end

                Character:PivotTo(CFrame.new(OutsidePosition))
                UpdateMiningLog("Outside mine; waiting 3 seconds")

                task.wait(RETURN_DELAY)

                if not OTC.Config.AutoMine then
                    return
                end

                Character = LocalPlayer.Character
                    or LocalPlayer.CharacterAdded:Wait()

                Root = Character:FindFirstChild("HumanoidRootPart")

                if not Root then
                    UpdateMiningLog("Return failed: character root missing")
                    return
                end

                Character:PivotTo(CFrame.new(PortalTarget))
                OTC.Config.LastMineRefresh = os.clock()
                MiningIndex = 1

                UpdateMiningLog("Returned to mine")
            end)

            if not Success then
                UpdateMiningLog("Refresh error: " .. tostring(ErrorMessage))
            end

            MineRefreshInProgress = false
            MineRefreshBusy = false
        end
    end
end)

function AutoSellSection()
    local CurrentCapacity = 2500
local SliderObject
local AutoSellTriggered = false
local AutoSellBusy = false

function GetSellPad()
    local MineArea = workspace:FindFirstChild("MineArea")
    local CaveDecor = MineArea and MineArea:FindFirstChild("CaveDecor")
    local Stands = CaveDecor and CaveDecor:FindFirstChild("Stands")
    local SellStand = Stands and Stands:FindFirstChild("SellStand")
    local OuterCircle = SellStand and SellStand:FindFirstChild("Circle")
    local SellCircle = OuterCircle and OuterCircle:FindFirstChild("Circle")

    if not SellCircle then
        warn("[OTC AutoSell] Sell Circle not found")
        return nil
    end

    return SellCircle
end

function TweenToSell()
    local SellCircle = GetSellPad()

    if not SellCircle then
        return false
    end

    if not SellCircle:IsA("Model") then
        warn("[OTC AutoSell] Expected Model, got:", SellCircle.ClassName)
        return false
    end

    local Player = Players.LocalPlayer
    local Character = Player.Character
        or Player.CharacterAdded:Wait()

    local Root = Character:FindFirstChild("HumanoidRootPart")
        or Character:WaitForChild("HumanoidRootPart", 5)

    if not Root then
        warn("[OTC AutoSell] HumanoidRootPart not found")
        return false
    end

    local TargetCFrame = SellCircle:GetPivot() * CFrame.new(0, 3, 0)
    local Distance = (Root.Position - TargetCFrame.Position).Magnitude
    local Duration = math.clamp(Distance / 100, 0.15, 2)

    local Tween = TweenService:Create(
        Root,
        TweenInfo.new(
            Duration,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        ),
        {
            CFrame = TargetCFrame
        }
    )

    local Finished = false
    local Connection

    Connection = Tween.Completed:Connect(function()
        Finished = true
        Connection:Disconnect()
    end)

    Tween:Play()

    local StartTime = os.clock()

    while not Finished and os.clock() - StartTime < Duration + 1 do
        if not Root.Parent then
            Tween:Cancel()
            Connection:Disconnect()
            return false
        end

        task.wait(0.05)
    end

    if not Finished then
        Tween:Cancel()
        Connection:Disconnect()
        return false
    end

    return true
end

SliderObject = MinigamesTab:CreateSlider({
    name = "Sell Amount",
    description = "Move to Sell when backpack reaches this count",
    flag = "SellAmount",
    range = {1, CurrentCapacity},
    increment = 1,
    value = math.clamp(
        tonumber(OTC.Config.SellAmount) or 25,
        1,
        CurrentCapacity
    ),
    suffix = " items",
    callback = function(Value, Dragging)
        Value = tonumber(Value) or 25

        OTC.Config.SellAmount = math.clamp(
            math.floor(Value),
            1,
            CurrentCapacity
        )

        if not Dragging then
            AutoSellTriggered = false
        end
    end
})

MinigamesTab:CreateToggle({
    name = "Auto Sell",
    description = "Move to Sell and sell once at the threshold",
    flag = "AutoSell",
    callback = function(Value)
        OTC.Config.AutoSell = Value

        if not Value then
            AutoSellTriggered = false
            AutoSellBusy = false
        end
    end
})

task.spawn(function()
    while true do
        task.wait(0.25)

        if not OTC.Config.AutoSell then
            AutoSellTriggered = false
            AutoSellBusy = false
            continue
        end

        local State = GetMiningState()

        if not State then
            continue
        end

        local Count = tonumber(State.Count) or 0
        local Capacity = tonumber(State.Capacity) or 0

        if Capacity <= 0 then
            continue
        end

        if Capacity ~= CurrentCapacity then
            CurrentCapacity = Capacity

            OTC.Config.SellAmount = math.clamp(
                tonumber(OTC.Config.SellAmount) or 25,
                1,
                Capacity
            )

            if SliderObject then
                SliderObject:Set(OTC.Config.SellAmount, true)
            end
        end

        local Threshold = math.clamp(
            tonumber(OTC.Config.SellAmount) or 25,
            1,
            Capacity
        )

        if Count < Threshold then
            AutoSellTriggered = false
            continue
        end

        if AutoSellTriggered or AutoSellBusy then
            continue
        end

        AutoSellTriggered = true
        AutoSellBusy = true

        task.spawn(function()
            local Success, ErrorMessage = pcall(function()
                assert(
                    TweenToSell(),
                    "Could not move to Sell"
                )

                task.wait(OTC.Config.SellCooldown or 3)

                local Service = GetMiningService()
                assert(Service, "MiningService unavailable")

                Service:Sell()

                local Sold = false

                for _ = 1, 20 do
                    task.wait(0.25)

                    local NewState = GetMiningState()

                    if NewState then
                        local NewCount = tonumber(NewState.Count) or 0
                        local NewCapacity = tonumber(NewState.Capacity) or Capacity

                        if NewCount < Count or NewCapacity ~= Capacity then
                            Sold = true
                            break
                        end
                    end
                end

                AutoSellTriggered = false

                if not Sold then
                    task.wait(1)
                end
            end)

            if not Success then
                warn("[OTC AutoSell]", ErrorMessage)
                AutoSellTriggered = false
            end

            AutoSellBusy = false
        end)
    end
end)
end
AutoSellSection()

local AutoUpgradePickaxe = false
local AutoUpgradeBackpack = false
local UpgradeDelay = 0.1

local UpgradeBusy = {
    Tool = false,
    Backpack = false
}

function GetUpgradeStand()
    local MineArea = workspace:FindFirstChild("MineArea")
    local CaveDecor = MineArea and MineArea:FindFirstChild("CaveDecor")
    local Stands = CaveDecor and CaveDecor:FindFirstChild("Stands")
    local UpgradeStand = Stands and Stands:FindFirstChild("UpgradeStand")
    local OuterCircle = UpgradeStand and UpgradeStand:FindFirstChild("Circle")
    local Circle = OuterCircle and OuterCircle:FindFirstChild("Circle")

    if Circle and Circle:IsA("Model") then
        return Circle
    end

    return nil
end

function TeleportToUpgrade()
    local Circle = GetUpgradeStand()
    if not Circle then
        warn("[OTC Upgrade] Upgrade stand not found")
        return false
    end

    local Players = game:GetService("Players")
    local Character = Players.LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return false
    end

    Root.CFrame = Circle:GetPivot() * CFrame.new(0, 3, 0)
    return true
end

function PurchaseItems(Category)
    if UpgradeBusy[Category] then return end
    UpgradeBusy[Category] = true

    local IsTool = Category == "Tool"

    local Success, ErrorMessage = pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local MiningFolder = ReplicatedStorage
            :WaitForChild("Shared")
            :WaitForChild("Minigames")
            :WaitForChild("Mining")

        local ShopShared = require(MiningFolder:WaitForChild("ShopShared"))

        local MiningController = require(
            ReplicatedStorage
                :WaitForChild("Controllers")
                :WaitForChild("Minigames")
                :WaitForChild("MiningController")
        )

        local Comm = require(
            ReplicatedStorage
                :WaitForChild("Packages")
                :WaitForChild("Comm")
        )

        local Service = Comm.ClientComm.new(
            ReplicatedStorage:WaitForChild("RemoteServices"),
            false,
            "MiningService"
        ):BuildObject()

        if type(Service.Purchase) ~= "function" then
            error("Purchase method unavailable")
        end

        local ListFunction = IsTool
            and ShopShared.ListTools
            or ShopShared.ListBackpacks

        local BuyAction = IsTool and "BuyTool" or "BuyStorage"
        local EquipAction = IsTool and "EquipTool" or "EquipStorage"

        while (IsTool and AutoUpgradePickaxe)
            or (not IsTool and AutoUpgradeBackpack) do

            if not TeleportToUpgrade() then
                task.wait(0.5)
                continue
            end

            local ListSuccess, Items = pcall(ListFunction)
            if not ListSuccess or type(Items) ~= "table" then
                task.wait(0.5)
                continue
            end

            table.sort(Items, function(A, B)
                return (tonumber(A.Price) or 0) < (tonumber(B.Price) or 0)
            end)

            local StateSuccess, State = pcall(MiningController.GetState)
            if not StateSuccess or not State then
                task.wait(0.2)
                continue
            end

            local Owned = IsTool and State.OwnedTools or State.OwnedBackpacks
            local Equipped = IsTool and State.Tool or State.Backpack
            local BoughtSomething = false

            for _, Item in ipairs(Items) do
                if not ((IsTool and AutoUpgradePickaxe)
                    or (not IsTool and AutoUpgradeBackpack)) then
                    break
                end

                local Id = Item.Id
                if Id == nil or Id == Equipped then
                    continue
                end

                if type(Owned) == "table" and Owned[Id] then
                    continue
                end

                local BuySuccess = pcall(function()
                    Service:Purchase(BuyAction, Id)
                end)

                if BuySuccess then
                    task.wait(UpgradeDelay)

                    local RefreshSuccess, NewState = pcall(MiningController.GetState)
                    if RefreshSuccess and NewState then
                        local NewOwned = IsTool
                            and NewState.OwnedTools
                            or NewState.OwnedBackpacks

                        local NewEquipped = IsTool
                            and NewState.Tool
                            or NewState.Backpack

                        if NewEquipped == Id then
                            BoughtSomething = true
                            break
                        end

                        if type(NewOwned) == "table" and NewOwned[Id] then
                            pcall(function()
                                Service:Purchase(EquipAction, Id)
                            end)

                            task.wait(UpgradeDelay)

                            local EquipStateSuccess, EquipState =
                                pcall(MiningController.GetState)

                            if EquipStateSuccess and EquipState then
                                local CurrentEquipped = IsTool
                                    and EquipState.Tool
                                    or EquipState.Backpack

                                if CurrentEquipped == Id then
                                    BoughtSomething = true
                                    break
                                end
                            end
                        end
                    end
                end
            end

            if not BoughtSomething then
                task.wait(0.5)
            end
        end
    end)

    if not Success then
        warn("[OTC Upgrade] " .. Category .. ": " .. tostring(ErrorMessage))
    end

    UpgradeBusy[Category] = false
end

MinigamesTab:CreateToggle({
    name = "Auto Upgrade Pickaxe",
    description = "Teleport to Upgrade Stand and buy/equip pickaxes",
    flag = "AutoUpgradePickaxe",
    callback = function(Value)
        AutoUpgradePickaxe = Value

        if Value then
            task.spawn(PurchaseItems, "Tool")
        end
    end
})

MinigamesTab:CreateToggle({
    name = "Auto Upgrade Backpack",
    description = "Teleport to Upgrade Stand and buy/equip backpacks",
    flag = "AutoUpgradeBackpack",
    callback = function(Value)
        AutoUpgradeBackpack = Value

        if Value then
            task.spawn(PurchaseItems, "Backpack")
        end
    end
})

function GetDailyShop()
    return require(
        ReplicatedStorage.Shared.Minigames.Mining.DailyShop
    )
end

function TeleportToDailyShop()
    local Character = LocalPlayer.Character
        or LocalPlayer.CharacterAdded:Wait()

    local Root = Character:FindFirstChild("HumanoidRootPart")
        or Character:WaitForChild("HumanoidRootPart", 5)

    if not Root then
        warn("HumanoidRootPart not found.")
        return false
    end

    local Success, Circle = pcall(function()
        return workspace
            :WaitForChild("MineArea")
            :WaitForChild("CaveDecor")
            :WaitForChild("Stands")
            :WaitForChild("DailyShopStand")
            :WaitForChild("Circle")
    end)

    if not Success or not Circle:IsA("Model") then
        warn("DailyShopStand.Circle model not found.")
        return false
    end

    local TargetPart = Circle.PrimaryPart
        or Circle:FindFirstChildWhichIsA("BasePart", true)

    if not TargetPart then
        warn("No BasePart found inside Circle.")
        return false
    end

    Root.CFrame = TargetPart.CFrame + Vector3.new(0, 3, 0)
    task.wait(0.5)

    return true
end

function GetOffers()
    local DailyShop = GetDailyShop()
    local Now = math.floor(workspace:GetServerTimeNow())
    local Day = DailyShop.Day(Now)

    local Success, Offers = pcall(function()
        return DailyShop.Offers(Day)
    end)

    if not Success or type(Offers) ~= "table" then
        warn("Could not get Daily Shop offers:", Offers)
        return nil, Day
    end

    return Offers, Day
end

function RunAutoBuyDailyShop()
    if not TeleportToDailyShop() then
        return
    end

    local State = GetMiningState()

    if not State or State.Active ~= true then
        warn("Mining is not active.")
        return
    end

    local Offers, Day = GetOffers()

    if not Offers then
        return
    end

    local Service = GetMiningService()
    local DailyShop = GetDailyShop()

    local Attempts = 0
    local EstimatedCost = 0

    for _, Offer in pairs(Offers) do
        if not OTC.Config.AutoBuyDailyShop then
            break
        end

        local OfferId = Offer.Id
        local OfferName = Offer.Name or Offer.Title or OfferId
        local Price = tonumber(Offer.Price) or 0
        local Stock = tonumber(Offer.Stock)

        if not OfferId or Price <= 0 then
            continue
        end

        if Stock == nil then
            continue
        end

        if Stock <= 0 then
            continue
        end

        for Index = 1, Stock do
            if not OTC.Config.AutoBuyDailyShop then
                break
            end

            State = GetMiningState()

            if not State or State.Active ~= true then
                break
            end

            local Balance = tonumber(State.Balance) or 0

            if Balance < Price then
                break
            end

            local Success, Result = pcall(function()
                return Service:DailyBuy(OfferId)
            end)

            if not Success or Result == false then
                break
            end

            Attempts += 1
            EstimatedCost += Price

            task.wait(OTC.Config.DailyShopDelay)
        end
    end

    State = GetMiningState()

    local Now = math.floor(workspace:GetServerTimeNow())

    local Success, EndsAt = pcall(function()
        return DailyShop.EndsAt(DailyShop.Day(Now))
    end)

    local RestockSeconds

    if Success and type(EndsAt) == "number" then
        RestockSeconds = math.max(0, EndsAt - Now)
    end
end

MinigamesTab:CreateToggle({
    Name = "Auto Buy Daily Shop",
    Description = "Enable or disable auto buy daily shop.",
    CurrentValue = false,
    Flag = "AutoBuyDailyShop",

    Callback = function(Value)
        OTC.Config.AutoBuyDailyShop = Value

        if Value then
            task.spawn(RunAutoBuyDailyShop)
        end
    end,
})

local AutoTrickOrTreat = false
local TrickOrTreatRunning = false
local TrickOrTreatDelay = 1

function getTrickOrTreatHouses()
    local houses = {}
    local island = Workspace:FindFirstChild(
        TrickOrTreatConfig.Folder
    )

    if not island then
        return houses
    end

    for _, object in ipairs(island:GetDescendants()) do
        if object:IsA("Model")
            and object.Name == TrickOrTreatConfig.PadName then

            local houseId = object:GetAttribute(
                TrickOrTreatConfig.HouseAttribute
            )

            if houseId ~= nil then
                table.insert(houses, {
                    Model = object,
                    Id = houseId
                })
            end
        end
    end

    return houses
end

function getTrickOrTreatStatus(houses)
    local readyHouses = {}
    local cooldownCount = 0

    local success, replica = pcall(function()
        return DataController:GetReplica()
    end)

    if not success or not replica or type(replica.Data) ~= "table" then
        return nil, 0
    end

    local savedHouses = replica.Data.TrickOrTreat or {}
    local now = Workspace:GetServerTimeNow()

    for _, house in ipairs(houses) do
        local lastVisit = tonumber(savedHouses[house.Id]) or 0
        local readyAt = TrickOrTreatConfig.ReadyAt(lastVisit)
        local remaining = readyAt - now

        if remaining <= 0 then
            table.insert(readyHouses, house)
        else
            cooldownCount += 1
            print(string.format(
                "[OTC Halloween] House %s cooldown: %ds",
                tostring(house.Id),
                math.ceil(remaining)
            ))
        end
    end

    return readyHouses, cooldownCount
end

function runAutoTrickOrTreat()
    if TrickOrTreatRunning then
        return
    end

    TrickOrTreatRunning = true

    function finish(message)
        AutoTrickOrTreat = false
        TrickOrTreatRunning = false

        if message then
            warn("[OTC Halloween] " .. message)
        end
    end

    local success, result = pcall(function()
        return ReplicatedStorage
            .RemoteServices
            .IslandService
            .RF
            .Travel:InvokeServer({
                Source = "Portal",
                Island = "Halloween"
            })
    end)

    if not success then
        finish("Travel failed: " .. tostring(result))
        return
    end

    local island

    for _ = 1, 60 do
        if not AutoTrickOrTreat then
            TrickOrTreatRunning = false
            return
        end

        island = Workspace:FindFirstChild(
            TrickOrTreatConfig.Folder
        )

        if island then
            break
        end

        task.wait(0.5)
    end

    if not island then
        finish("HalloweenIsland not loaded.")
        return
    end

    while AutoTrickOrTreat do
        local houses = getTrickOrTreatHouses()

        if #houses == 0 then
            task.wait(2)
            continue
        end

        local readyHouses, cooldownCount =
            getTrickOrTreatStatus(houses)

        if not readyHouses then
            task.wait(1)
            continue
        end

        if #readyHouses == 0 then
            finish(string.format(
                "All %d houses are on cooldown. Auto stopped.",
                cooldownCount
            ))
            return
        end

        for _, house in ipairs(readyHouses) do
            if not AutoTrickOrTreat then
                break
            end

            if not house.Model:IsDescendantOf(Workspace) then
                continue
            end

            local character = LocalPlayer.Character
                or LocalPlayer.CharacterAdded:Wait()

            local root = character:FindFirstChild("HumanoidRootPart")

            if not root then
                continue
            end

            root.CFrame = house.Model:GetPivot()
                * CFrame.new(0, 0, 4)

            task.wait(0.5)

            local knockSuccess, knockResult = pcall(function()
                return TrickOrTreatService:Knock(house.Id)
            end)

            if knockSuccess then
                print(
                    "[OTC Halloween] Knock:",
                    house.Id,
                    knockResult
                )
            else
                warn(
                    "[OTC Halloween] Knock failed:",
                    house.Id,
                    knockResult
                )
            end

            task.wait(TrickOrTreatDelay)
        end

        task.wait(0.5)
    end

    TrickOrTreatRunning = false
end

HalloweenTab:CreateSection({
    name = "▶ Halloween"
})

HalloweenTab:CreateToggle({
    name = "Auto Trick or Treat",
    description = "Automatically visit Halloween houses.",
    flag = "AutoTrickorTreat",
    value = false,
    callback = function(value)
        AutoTrickOrTreat = value

        if value then
            task.spawn(runAutoTrickOrTreat)
        end
    end,
})

local HallowLordRunning = false
local HallowLordToken = 0

function HallowLordGetRoot()
    local character = LocalPlayer.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

function HallowLordFindPlatform()
    for _, part in ipairs(
        CollectionService:GetTagged(
            HallowBossConfig.PlatformTag or "BossPlatform"
        )
    ) do
        if part:IsA("BasePart")
            and part:IsDescendantOf(Workspace)
        then
            return part
        end
    end

    return nil
end

function HallowLordTeleportHalloween()
    local ok, result = pcall(function()
        return TravelRemote:InvokeServer({
            Source = "Portal",
            Island = "Halloween",
        })
    end)

    if not ok then
        warn("[AutoHallowLord] Travel failed:", result)
        return false
    end

    local island = Workspace:WaitForChild("HalloweenIsland", 15)
    return island ~= nil
end

function HallowLordTeleportBoss()
    local platform = HallowLordFindPlatform()
    local root = HallowLordGetRoot()

    if not platform or not root then
        return false
    end

    local position = platform.CFrame:PointToWorldSpace(
        Vector3.new(0, platform.Size.Y / 2 + 5, 0)
    )

    root.CFrame = CFrame.new(position)
    task.wait(0.5)

    return true
end

function HallowLordStart(token)
    if not HallowLordTeleportHalloween() then
        warn("[AutoHallowLord] Halloween teleport failed.")
        return
    end

    while HallowLordRunning
        and token == HallowLordToken
    do
        local ok, state = pcall(function()
            return HallowBossController:GetDebugState()
        end)

        if ok and type(state) == "table" then
            if state.Phase == "Fight" then
                if state.InZone ~= true then
                    HallowLordTeleportBoss()
                    task.wait(1)
                else
                    local tapOK, tapError = pcall(function()
                        TapController:Tap()
                    end)

                    if not tapOK then
                        warn("[AutoHallowLord] Tap failed:", tapError)
                        task.wait(0.5)
                    else
                        task.wait(OTC.Config.HallowLordTapDelay)
                    end
                end
            else
                task.wait(0.5)
            end
        else
            task.wait(1)
        end
    end
end

function HallowLordSetEnabled(enabled)
    OTC.Config.AutoBeatHallowLord = enabled
    HallowLordRunning = enabled
    HallowLordToken += 1

    local token = HallowLordToken

    if enabled then
        task.spawn(function()
            local ok, err = pcall(function()
                HallowLordStart(token)
            end)

            if not ok then
                warn("[AutoHallowLord] Error:", err)
            end

            if token == HallowLordToken then
                HallowLordRunning = false
                OTC.Config.AutoBeatHallowLord = false
            end
        end)
    end
end

HalloweenTab:CreateToggle({
    name = "Auto Beat Hallow Lord",
    description = "Teleport to Halloween and fight Hallow Lord automatically",
    flag = "AutoBeatHallowLord",
    value = OTC.Config.AutoBeatHallowLord,
    callback = function(value)
        HallowLordSetEnabled(value)
    end
})

AutoBuyHalloweenShop = {
    Running = false,
    Token = 0,
    Delay = 1.2
}

function getHalloweenShopData()
    local replica = DataController:GetReplica()

    if not replica or type(replica.Data) ~= "table" then
        return nil
    end

    return replica.Data
end

function buyHalloweenShopItem(item)
    local ok, result = pcall(function()
        return HalloweenShopController:Purchase(item.Id)
    end)

    if not ok or type(result) ~= "table" then
        return false, nil
    end

    if result.Success then
        task.wait(AutoBuyHalloweenShop.Delay)
        return true, result.Reason
    end

    return false, result.Reason
end

function runAutoBuyHalloweenShop(token)
    if not HalloweenShopConfig.IsOpen() then
        return
    end

    local limited = {}
    local unlimited = {}

    for _, item in ipairs(HalloweenShopConfig.Items) do
        if item.Limit ~= nil then
            table.insert(limited, item)
        else
            table.insert(unlimited, item)
        end
    end

    function processItems(items, isLimited)
        for _, item in ipairs(items) do
            if not AutoBuyHalloweenShop.Running
                or token ~= AutoBuyHalloweenShop.Token then
                return false
            end

            while AutoBuyHalloweenShop.Running
                and token == AutoBuyHalloweenShop.Token
                and HalloweenShopConfig.IsOpen() do

                local data = getHalloweenShopData()

                if not data then
                    task.wait(1)
                    continue
                end

                local candy = HalloweenShopConfig.GetCandy(data)

                if type(candy) ~= "number" or candy <= 0 then
                    return false
                end

                if not HalloweenShopConfig.IsListed(data, item) then
                    break
                end

                if isLimited then
                    local remaining =
                        HalloweenShopConfig.GetRemaining(data, item)

                    if remaining == nil or remaining <= 0 then
                        break
                    end
                end

                if candy < item.Price then
                    break
                end

                local success, reason = buyHalloweenShopItem(item)

                if success then
                    if not isLimited then
                        continue
                    end
                elseif reason == "NotEnoughCandy"
                    or reason == "SoldOut"
                    or reason == "EventClosed"
                    or reason == "RateLimited" then
                    task.wait(1)
                end

                break
            end
        end

        return true
    end

    if not processItems(limited, true) then
        return
    end

    processItems(unlimited, false)
end

HalloweenTab:CreateToggle({
    name = "Auto Buy Halloween Shop",
    description = "Buy limited-stock items first, then unlimited items",
    flag = "AutoBuyHalloweenShop",
    value = OTC.Config.AutoBuyHalloweenShop,

    callback = function(value)
        OTC.Config.AutoBuyHalloweenShop = value
        AutoBuyHalloweenShop.Running = value
        AutoBuyHalloweenShop.Token += 1

        if not value then
            return
        end

        local token = AutoBuyHalloweenShop.Token

        task.spawn(function()
            pcall(runAutoBuyHalloweenShop, token)

            if token == AutoBuyHalloweenShop.Token then
                AutoBuyHalloweenShop.Running = false
                OTC.Config.AutoBuyHalloweenShop = false
            end
        end)
    end
})


do
    local DungeonRunning = false
    local DungeonBusy = false
    local DungeonToken = 0
    local DungeonAttackDelay = 0.01
    local DungeonAutoDodge = true
    local DungeonDodgeCooldown = 0.65

    local LastMobDodge = 0
    local LastBossDodge = 0

    local MobDodgeConnections = {}
    local BossDodgeConnections = {}

    local BlessingConnection
    local LastBlessingOffer
    local LastClearedRoom
    local LastRoomChange

    local BlessingPriority = {
        IronCape = 100,
        VampireBite = 95,
        GregSlayer = 90,
        BatBane = 80,
        ChestCracker = 75,
        PetFury = 70,
        BusyPaws = 60,
        ThickFur = 55,
        CandySack = 40,
        LuckyLoot = 35
    }

    local DungeonController
    local DungeonContext
    local DungeonTapController
    local DungeonTargeting
    local DungeonMobViews
    local DungeonRelicView

    local RelicCollecting = false

    function dnotify(title, message, duration)
        pcall(function()
            Window:Notify({
                Title = title,
                Content = message,
                Duration = duration or 4
            })
        end)
    end

    local CountGregConfig = require(
        ReplicatedStorage:WaitForChild("Shared")
            :WaitForChild("Game")
            :WaitForChild("HalloweenDungeon")
            :WaitForChild("Config")
    )

    local LastCountGregState = nil
    local LastCountGregNotifySecond = nil

    function FormatCountGregTime(seconds)
        seconds = math.max(0, math.ceil(seconds))

        return string.format(
            "%d:%02d",
            math.floor(seconds / 60),
            seconds % 60
        )
    end

    function GetCountGregCooldown()
        local replica

        local ok = pcall(function()
            replica = DataController:GetReplica()
        end)

        if not ok
            or not replica
            or type(replica.Data) ~= "table" then
            return nil, "Unknown"
        end

        local data = replica.Data
        local now = Workspace:GetServerTimeNow()

        local readyAt

        local readyOk, readyResult = pcall(function()
            return CountGregConfig.ReadyAt(data)
        end)

        if not readyOk or type(readyResult) ~= "number" then
            return nil, "Unknown"
        end

        readyAt = readyResult

        local remaining = math.max(0, readyAt - now)

        local backAt = LocalPlayer:GetAttribute(
            "HalloweenDungeonBackAt"
        )

        if type(backAt) == "number" then
            remaining = math.max(
                remaining,
                backAt - now,
                0
            )
        end

        if remaining > 0 then
            return math.ceil(remaining), "Resting"
        end

        return 0, "Ready"
    end

    function UpdateCountGregCooldown()
        local remaining, state = GetCountGregCooldown()

        if remaining == nil then
            return
        end

        if state ~= LastCountGregState then
            LastCountGregState = state
            LastCountGregNotifySecond = nil

            if state == "Resting" then
                dnotify(
                    "Count Greg",
                    "The Count rests "
                        .. FormatCountGregTime(remaining),
                    5
                )
            else
                dnotify(
                    "Count Greg",
                    "Cooldown finished! Count Greg is ready.",
                    5
                )
            end
        end

        if state == "Resting" then
            local shouldNotify =
                remaining % 60 == 0
                or remaining <= 10

            if shouldNotify
                and remaining ~= LastCountGregNotifySecond then
                LastCountGregNotifySecond = remaining

                dnotify(
                    "Count Greg Cooldown",
                    "The Count rests "
                        .. FormatCountGregTime(remaining)
                        .. " remaining.",
                    3
                )
            end
        end
    end

    task.spawn(function()
        while not Destroyed do
            pcall(UpdateCountGregCooldown)
            task.wait(1)
        end
    end)

    function dwait(seconds, token)
        local finish = os.clock() + seconds

        while os.clock() < finish do
            if not DungeonRunning or token ~= DungeonToken then
                return false
            end

            task.wait(0.025)
        end

        return DungeonRunning and token == DungeonToken
    end

    function dcharacter()
        local character = LocalPlayer.Character

        if not character then
            return nil
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")

        if not humanoid or humanoid.Health <= 0 or not root then
            return nil
        end

        return character, humanoid, root
    end

    function dposition(object)
        if not object or not object.Parent then
            return nil
        end

        if object:IsA("BasePart") then
            return object.Position
        elseif object:IsA("Model") then
            local ok, pivot = pcall(function()
                return object:GetPivot()
            end)

            if ok then
                return pivot.Position
            end
        end

        return nil
    end

    function dteleport(target)
        local _, _, root = dcharacter()

        if not root then
            return false
        end

        local cf

        if typeof(target) == "CFrame" then
            cf = target
        elseif typeof(target) == "Vector3" then
            cf = CFrame.new(target)
        elseif typeof(target) == "Instance" then
            if target:IsA("BasePart") then
                cf = target.CFrame
            elseif target:IsA("Model") then
                cf = target:GetPivot()
            end
        end

        if not cf then
            return false
        end

        root.CFrame = cf * CFrame.new(0, 3, 0)

        return true
    end

    function dload()
        local ok = pcall(function()
            local controllers = ReplicatedStorage
                :WaitForChild("Controllers")
                :WaitForChild("Game")

            local dungeonModule = controllers
                :WaitForChild("HalloweenDungeonController")

            DungeonController = require(dungeonModule)

            DungeonTapController = require(
                controllers:WaitForChild("TapController")
            )

            DungeonContext = DungeonController.GetContext()

            DungeonTargeting = DungeonContext.Controller("Targeting")
            DungeonMobViews = DungeonContext.Controller("MobViews")

            local relicModule = dungeonModule:FindFirstChild("RelicView")

            if relicModule and relicModule:IsA("ModuleScript") then
                DungeonRelicView = require(relicModule)

                if type(DungeonRelicView.Start) == "function" then
                    DungeonRelicView.Start(DungeonContext)
                end
            end
        end)

        if not ok then
            return false
        end

        return DungeonContext ~= nil
            and DungeonTapController ~= nil
            and DungeonTargeting ~= nil
    end

    function dinrun()
        if not DungeonContext then
            return false
        end

        local ok, result = pcall(function()
            return DungeonContext.InRun()
        end)

        return ok and result == true
    end

    function dpick(model)
        if not model or not model.Parent or not DungeonTargeting then
            return false
        end

        local camera = Workspace.CurrentCamera

        if not camera then
            return false
        end

        local ok, cf = pcall(function()
            if model:IsA("Model") then
                local boundingCF = model:GetBoundingBox()
                return boundingCF
            elseif model:IsA("BasePart") then
                return model.CFrame
            end
        end)

        if not ok or not cf then
            return false
        end

        local point, visible = camera:WorldToViewportPoint(cf.Position)

        if not visible or point.Z <= 0 then
            return false
        end

        return pcall(function()
            DungeonTargeting.PickAt(
                Vector2.new(point.X, point.Y),
                false
            )
        end)
    end

    function dtap()
        if not DungeonTapController then
            return false
        end

        return pcall(function()
            DungeonTapController:Tap()
        end)
    end

    function ddisconnect(list)
        for _, connection in ipairs(list) do
            pcall(function()
                connection:Disconnect()
            end)
        end

        table.clear(list)
    end

    function ddodge(data, isBoss)
        if not DungeonRunning
            or not DungeonAutoDodge
            or type(data) ~= "table" then
            return
        end

        local now = os.clock()

        if isBoss then
            if now - LastBossDodge < DungeonDodgeCooldown then
                return
            end
        else
            if now - LastMobDodge < DungeonDodgeCooldown then
                return
            end
        end

        local _, humanoid, root = dcharacter()

        if not humanoid or not root then
            return
        end

        local destination

        if isBoss then
            destination = data.Origin

            if typeof(destination) == "CFrame" then
                destination = destination.Position
            end
        else
            local kind, mode = data.Kind, data.Mode

            if kind == "Bat"
                or kind == "SwiftBat"
                or kind == "ThiefBat"
                or kind == "FeederBat"
                or kind == "ElderBat"
                or kind == "BatPinata" then
                if data.TargetUser ~= LocalPlayer.UserId
                    or (mode ~= "Telegraph" and mode ~= "Dive") then
                    return
                end

                destination = typeof(data.To) == "Vector3"
                    and data.To
                    or data.From

            elseif kind == "Mimic"
                and mode == "Hop"
                and typeof(data.To) == "Vector3" then
                if (root.Position - data.To).Magnitude > 22 then
                    return
                end

                destination = data.To
            else
                return
            end
        end

        if isBoss then
            LastBossDodge = now
        else
            LastMobDodge = now
        end

        local away

        if typeof(destination) == "Vector3" then
            away = root.Position - destination
            away = Vector3.new(away.X, 0, away.Z)
        end

        if not away or away.Magnitude < 0.1 then
            away = isBoss
                and root.CFrame.RightVector
                or -root.CFrame.LookVector

            away = Vector3.new(away.X, 0, away.Z)
        end

        if away.Magnitude > 0.1 then
            away = away.Unit

            local side = Vector3.new(-away.Z, 0, away.X)

            local velocity = (
                away + side * (isBoss and 1 or 0.7)
            ).Unit * 38

            root.AssemblyLinearVelocity = Vector3.new(
                velocity.X,
                isBoss and 30 or 28,
                velocity.Z
            )
        end

        humanoid.Jump = true
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end

    function dconnectDodge()
        ddisconnect(MobDodgeConnections)
        ddisconnect(BossDodgeConnections)

        local service = DungeonContext and DungeonContext.Service

        if not service then
            return
        end

        if service.MobState then
            table.insert(
                MobDodgeConnections,
                service.MobState:Connect(function(state)
                    ddodge(state, false)
                end)
            )
        end

        if service.BossAttack then
            table.insert(
                BossDodgeConnections,
                service.BossAttack:Connect(function(state)
                    ddodge(state, true)
                end)
            )
        end
    end

    function dconnectBlessings()
        if BlessingConnection then
            BlessingConnection:Disconnect()
            BlessingConnection = nil
        end

        local service = DungeonContext and DungeonContext.Service

        if not service
            or not service.BlessingOffer
            or not service.BlessingPick then
            return
        end

        BlessingConnection = service.BlessingOffer:Connect(function(offer)
            if not DungeonRunning
                or type(offer) ~= "table"
                or type(offer.OfferId) ~= "number"
                or type(offer.Choices) ~= "table"
                or LastBlessingOffer == offer.OfferId then
                return
            end

            local bestChoice
            local bestScore = -1

            for _, choice in ipairs(offer.Choices) do
                if type(choice) == "string" then
                    local score = BlessingPriority[choice] or 0

                    if score > bestScore then
                        bestChoice = choice
                        bestScore = score
                    end
                end
            end

            bestChoice = bestChoice or offer.Choices[1]

            if type(bestChoice) ~= "string" then
                return
            end

            LastBlessingOffer = offer.OfferId

            task.delay(0.2, function()
                if not DungeonRunning then
                    return
                end

                local currentService = DungeonContext
                    and DungeonContext.Service

                if currentService and currentService.BlessingPick then
                    pcall(function()
                        currentService.BlessingPick:Fire(
                            offer.OfferId,
                            bestChoice
                        )
                    end)
                end
            end)
        end)
    end

    function dmobs()
        local result = {}

        if not DungeonMobViews
            or type(DungeonMobViews.Each) ~= "function" then
            return result
        end

        pcall(function()
            DungeonMobViews.Each(function(id, view)
                if view and view.Model and view.Model.Parent then
                    local ok, position = pcall(function()
                        return view:Position()
                    end)

                    if ok and typeof(position) == "Vector3" then
                        table.insert(result, {
                            Id = id,
                            Model = view.Model,
                            Position = position
                        })
                    end
                end
            end)
        end)

        return result
    end

    function dattackMobs(token)
        local service = DungeonContext and DungeonContext.Service

        if not service or not service.SetTarget then
            return
        end

        for _, entry in ipairs(dmobs()) do
            if not DungeonRunning
                or token ~= DungeonToken
                or not dinrun() then
                return
            end

            local _, _, root = dcharacter()

            if not root then
                return
            end

            if not entry.Model
                or not entry.Model.Parent
                or (root.Position - entry.Position).Magnitude > 100 then
                continue
            end

            pcall(function()
                service.SetTarget:Fire(entry.Id)
            end)

            local deadline = os.clock() + 2

            while DungeonRunning
                and token == DungeonToken
                and dinrun()
                and os.clock() < deadline do
                if not entry.Model.Parent then
                    break
                end

                local view

                pcall(function()
                    view = DungeonMobViews.Get(entry.Id)
                end)

                if not view then
                    break
                end

                local _, _, currentRoot = dcharacter()

                if not currentRoot then
                    return
                end

                local pos

                pcall(function()
                    pos = view:Position()
                end)

                if typeof(pos) ~= "Vector3"
                    or (currentRoot.Position - pos).Magnitude > 100 then
                    break
                end

                dtap()

                if not dwait(DungeonAttackDelay, token) then
                    return
                end
            end
        end
    end

    function drunFolder()
        if not DungeonContext then
            return nil
        end

        local ok, result = pcall(function()
            return DungeonContext.RunFolder()
        end)

        return ok and result or nil
    end

    function dcollectRelics(token)
        if RelicCollecting or not DungeonRelicView then
            return
        end

        RelicCollecting = true

        pcall(function()
            local runFolder = drunFolder()

            if not runFolder then
                return
            end

            local relics = {}

            for _, relic in ipairs(
                CollectionService:GetTagged("Interactable")
            ) do
                if relic:IsA("Model")
                    and relic:IsDescendantOf(runFolder)
                    and relic:GetAttribute("InteractableId") == "VampireRelic"
                    and relic:GetAttribute("RelicId") ~= nil then
                    local hidden = false

                    if type(DungeonRelicView.Hidden) == "function" then
                        local hiddenOk, result = pcall(
                            DungeonRelicView.Hidden,
                            relic
                        )

                        hidden = hiddenOk and result == true
                    end

                    if not hidden then
                        table.insert(relics, relic)
                    end
                end
            end

            for _, relic in ipairs(relics) do
                if not DungeonRunning
                    or token ~= DungeonToken
                    or not dinrun() then
                    break
                end

                if relic.Parent
                    and relic:IsDescendantOf(runFolder) then
                    local hidden = false

                    if type(DungeonRelicView.Hidden) == "function" then
                        local hiddenOk, result = pcall(
                            DungeonRelicView.Hidden,
                            relic
                        )

                        hidden = hiddenOk and result == true
                    end

                    if not hidden then
                        local pos = dposition(relic)
                        local _, _, root = dcharacter()

                        if pos
                            and root
                            and (root.Position - pos).Magnitude <= 100 then
                            pcall(function()
                                DungeonRelicView.Take(relic)
                            end)

                            if not dwait(0.3, token) then
                                break
                            end
                        end
                    end
                end
            end
        end)

        RelicCollecting = false
    end

    function dchests()
        local result = {}
        local folder = drunFolder()

        if not folder then
            return result
        end

        for _, chest in ipairs(
            CollectionService:GetTagged("HalloweenDungeonChest")
        ) do
            if chest:IsA("Model")
                and chest:IsDescendantOf(folder)
                and chest:GetAttribute("Opened") ~= true then
                local hp = chest:GetAttribute("Hp")

                if type(hp) ~= "number" or hp > 0 then
                    table.insert(result, chest)
                end
            end
        end

        return result
    end

    function dattackChests(token)
        local service = DungeonContext and DungeonContext.Service

        for _, chest in ipairs(dchests()) do
            if not DungeonRunning
                or token ~= DungeonToken
                or not dinrun() then
                return
            end

            if not chest.Parent then
                continue
            end

            local hp = chest:GetAttribute("Hp")

            if chest:GetAttribute("Opened") == true
                or (type(hp) == "number" and hp <= 0) then
                continue
            end

            local pos = dposition(chest)

            if not pos then
                continue
            end

            dteleport(pos)

            if not dwait(0.25, token) then
                return
            end

            dpick(chest)

            local chestId = chest:GetAttribute("ChestId")

            if type(chestId) == "number"
                and service
                and service.ChestTarget then
                pcall(function()
                    service.ChestTarget:Fire(chestId)
                end)
            end

            while DungeonRunning
                and token == DungeonToken
                and dinrun() do
                if not chest.Parent then
                    break
                end

                local currentHp = chest:GetAttribute("Hp")

                if chest:GetAttribute("Opened") == true
                    or (
                        type(currentHp) == "number"
                        and currentHp <= 0
                    ) then
                    break
                end

                dtap()

                if not dwait(DungeonAttackDelay, token) then
                    return
                end
            end
        end
    end

    function dboss()
        local folder = drunFolder()

        if not folder then
            return nil
        end

        for _, object in ipairs(folder:GetDescendants()) do
            if object.Name == "CountGreg"
                and (
                    object:IsA("Model")
                    or object:IsA("BasePart")
                ) then
                return object
            end
        end

        return nil
    end

    function dattackBoss(token)
        local boss = dboss()

        if not boss then
            return false
        end

        while DungeonRunning
            and token == DungeonToken
            and dinrun() do
            local gui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
            local results = gui and gui:FindFirstChild(
                "HalloweenDungeonResults"
            )

            if results and results.Enabled then
                break
            end

            local state

            pcall(function()
                local view = DungeonContext.Controller("BossView")

                if view and type(view.GetDebugState) == "function" then
                    local debug = view.GetDebugState()
                    state = debug and debug.State
                end
            end)

            if type(state) == "table"
                and state.Phase == "Swarm" then
                local id = state.MedallionId
                local view

                if id
                    and DungeonMobViews
                    and type(DungeonMobViews.Get) == "function" then
                    local ok, result = pcall(function()
                        return DungeonMobViews.Get(id)
                    end)

                    if ok then
                        view = result
                    end
                end

                if view and view.Model and view.Model.Parent then
                    local pos

                    pcall(function()
                        pos = view:Position()
                    end)

                    local _, _, root = dcharacter()

                    if pos and root then
                        if (root.Position - pos).Magnitude > 25 then
                            dteleport(CFrame.new(pos))
                        end

                        local service = DungeonContext.Service

                        if service and service.SetTarget then
                            pcall(function()
                                service.SetTarget:Fire(id)
                            end)
                        end

                        dpick(view.Model)
                        dtap()
                    end
                end
            else
                local pos = dposition(boss)
                local _, _, root = dcharacter()

                if pos then
                    if root
                        and (root.Position - pos).Magnitude > 25 then
                        dteleport(pos)
                    end

                    dpick(boss)
                    dtap()
                end
            end

            if not dwait(DungeonAttackDelay, token) then
                break
            end
        end

        return true
    end

    function dclickContinue()
        local gui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local results = gui and gui:FindFirstChild(
            "HalloweenDungeonResults"
        )

        if not results or not results.Enabled then
            return false
        end

        local main = results:FindFirstChild("Main", true)
        local frame = main and main:FindFirstChild("Continue", true)
        local button = frame and frame:FindFirstChild("Button", true)

        if not button
            or not button:IsA("TextButton")
            or not button.Visible then
            return false
        end

        if typeof(firesignal) ~= "function" then
            return false
        end

        local ok = pcall(function()
            firesignal(button.MouseButton1Click)
        end)

        pcall(function()
            firesignal(button.Activated)
        end)

        return ok
    end

    task.spawn(function()
        while not Destroyed do
            if dclickContinue() then
                task.wait(1)
            else
                task.wait(0.2)
            end
        end
    end)

    function dprocessRoom(token)
        if not DungeonRunning
            or token ~= DungeonToken
            or not dinrun() then
            return false
        end

        local state

        local ok = pcall(function()
            state = DungeonContext.State()
        end)

        if not ok or type(state) ~= "table" then
            return false
        end

        local room = state.RoomIndex
        local phase = state.Phase
        local exitDoor = state.ExitDoor

        if room ~= LastRoomChange then
            LastRoomChange = room
            LastClearedRoom = nil
        end

        if phase ~= "Cleared" then
            return false
        end

        if LastClearedRoom == room then
            return true
        end

        LastClearedRoom = room

        local destination

        if typeof(exitDoor) == "Vector3" then
            destination = CFrame.new(exitDoor)
        elseif typeof(exitDoor) == "CFrame" then
            destination = exitDoor
        elseif typeof(exitDoor) == "Instance" then
            if exitDoor:IsA("BasePart") then
                destination = exitDoor.CFrame
            elseif exitDoor:IsA("Model") then
                destination = exitDoor:GetPivot()
            end
        end

        if not destination then
            return true
        end

        dteleport(destination)

        local _, humanoid, root = dcharacter()

        if humanoid and root then
            task.wait(0.2)

            local forward = root.CFrame.LookVector

            local target = root.Position + Vector3.new(
                forward.X * 25,
                0,
                forward.Z * 25
            )

            humanoid:MoveTo(target)

            local deadline = os.clock() + 4

            while DungeonRunning
                and token == DungeonToken
                and os.clock() < deadline do
                if not root.Parent
                    or humanoid.Health <= 0
                    or (root.Position - target).Magnitude <= 2 then
                    break
                end

                task.wait(0.1)
            end

            if root.Parent and humanoid.Health > 0 then
                humanoid:MoveTo(root.Position)
            end
        end

        local deadline = os.clock() + 25

        while DungeonRunning
            and token == DungeonToken
            and os.clock() < deadline do
            if not dinrun() then
                return true
            end

            local current

            pcall(function()
                current = DungeonContext.State()
            end)

            if type(current) == "table"
                and (
                    current.RoomIndex ~= room
                    or current.Phase ~= "Cleared"
                ) then
                return true
            end

            if not dwait(0.25, token) then
                return true
            end
        end

        return true
    end

    function dstart(token)
        if not dload() then
            dnotify(
                "OTC Dungeon",
                "Failed to load dungeon controllers.",
                5
            )
            return
        end

        dconnectDodge()
        dconnectBlessings()

        if not dinrun() then
            local travel = ReplicatedStorage:FindFirstChild("RemoteServices")
            travel = travel and travel:FindFirstChild("IslandService")
            travel = travel and travel:FindFirstChild("RF")
            travel = travel and travel:FindFirstChild("Travel")

            if travel then
                pcall(function()
                    travel:InvokeServer({
                        Source = "Portal",
                        Island = "Halloween"
                    })
                end)

                if not dwait(3, token) then
                    return
                end
            end

            local zone

            for _, candidate in ipairs(
                CollectionService:GetTagged("HalloweenDungeonCircle")
            ) do
                local candidateZone = candidate:FindFirstChild(
                    "Zone",
                    true
                )

                if candidateZone and candidateZone:IsA("BasePart") then
                    zone = candidateZone
                    break
                end
            end

            if zone then
                dteleport(zone.CFrame)

                for _ = 1, 30 do
                    if not dwait(1, token) then
                        return
                    end

                    if dinrun() then
                        break
                    end
                end

                if not dinrun() then
                    dnotify(
                        "OTC Dungeon",
                        "Dungeon did not start.",
                        6
                    )
                    return
                end
            elseif not dinrun() then
                dnotify(
                    "OTC Dungeon",
                    "Dungeon entry circle not found.",
                    5
                )
                return
            end
        end

        while DungeonRunning and token == DungeonToken do
            if not dinrun() then
                if not dwait(0.5, token) then
                    break
                end
            else
                if dprocessRoom(token) then
                    if not dwait(0.2, token) then
                        break
                    end

                    continue
                end

                dcollectRelics(token)

                if not DungeonRunning or token ~= DungeonToken then
                    break
                end

                dattackMobs(token)

                if not DungeonRunning or token ~= DungeonToken then
                    break
                end

                dattackChests(token)

                if not DungeonRunning or token ~= DungeonToken then
                    break
                end

                if dboss() then
                    dattackBoss(token)
                end

                dclickContinue()

                if not dwait(0.1, token) then
                    break
                end
            end
        end

        ddisconnect(MobDodgeConnections)
        ddisconnect(BossDodgeConnections)

        if BlessingConnection then
            BlessingConnection:Disconnect()
            BlessingConnection = nil
        end
    end

    HalloweenTab:CreateSection({
        name = "▶ Dungeon"
    })

    HalloweenTab:CreateToggle({
        name = "Auto Finish Dungeon",
        description = "Automatically clear dungeon rooms, attack chests and mobs.",
        flag = "OTCAutoFinishDungeon",
        value = false,

        callback = function(value)
            if not value then
                DungeonRunning = false
                DungeonToken += 1

                ddisconnect(MobDodgeConnections)
                ddisconnect(BossDodgeConnections)

                if BlessingConnection then
                    BlessingConnection:Disconnect()
                    BlessingConnection = nil
                end

                LastBlessingOffer = nil
                LastClearedRoom = nil
                LastRoomChange = nil

                if DungeonBusy then
                    dnotify(
                        "OTC Dungeon",
                        "Automation stopped.",
                        4
                    )
                end

                return
            end

            local remaining, state = GetCountGregCooldown()

            if remaining == nil then
                dnotify(
                    "OTC Dungeon",
                    "Unable to read Count Greg's cooldown.",
                    5
                )
                return
            end

            if state == "Resting" and remaining > 0 then
                dnotify(
                    "OTC Dungeon",
                    "The Count rests "
                        .. FormatCountGregTime(remaining)
                        .. ".",
                    5
                )
                return
            end

            if DungeonBusy then
                dnotify(
                    "OTC Dungeon",
                    "Already running.",
                    3
                )
                return
            end

            DungeonRunning = true
            DungeonToken += 1

            local token = DungeonToken

            DungeonBusy = true

            dnotify(
                "OTC Dungeon",
                "Automation started.",
                4
            )

            task.spawn(function()
                local ok, err = pcall(function()
                    dstart(token)
                end)

                DungeonRunning = false
                DungeonBusy = false

                ddisconnect(MobDodgeConnections)
                ddisconnect(BossDodgeConnections)

                if BlessingConnection then
                    BlessingConnection:Disconnect()
                    BlessingConnection = nil
                end

                if not ok then
                    dnotify(
                        "OTC Dungeon Error",
                        tostring(err),
                        6
                    )
                else
                    dnotify(
                        "OTC Dungeon",
                        "Automation finished.",
                        5
                    )
                end
            end)
        end
    })

    HalloweenTab:CreateSlider({
        name = "Dungeon Attack Delay",
        description = "Delay between taps while attacking dungeon targets.",
        range = {0.01, 0.5},
        increment = 0.01,
        suffix = "s",
        value = 0.01,
        flag = "OTCDungeonAttackDelay",

        callback = function(value)
            DungeonAttackDelay = value
        end
    })

    HalloweenTab:CreateToggle({
        name = "Auto Dodge Dungeon Attacks",
        description = "Attempt to dodge bat and boss attacks.",
        flag = "OTCDungeonAutoDodge",
        value = true,

        callback = function(value)
            DungeonAutoDodge = value
        end
    })

    HalloweenTab:CreateSlider({
        name = "Dungeon Dodge Cooldown",
        description = "Minimum delay between automatic dodge attempts.",
        range = {0.2, 1.5},
        increment = 0.05,
        suffix = "s",
        value = 0.65,
        flag = "OTCDungeonDodgeCooldown",

        callback = function(value)
            DungeonDodgeCooldown = value
        end
    })
end

local WebhookURL = ""
local AvatarURL = "https://cdn.discordapp.com/avatars/1416562431882432666/ca20c1ec7d67590754fca8f0b109f9d0.webp?animated=false&size=2048"

local MinimumOneIn = 1000
local DiscordUserID = ""

local SendWebhookEnabled = true
local SendWebhookWithMentionEnabled = true

function getPetImage(petName)
    local petData = PetVisualConfig[petName]

    if type(petData) ~= "table" then
        return nil
    end

    local image = petData.Image

    if type(image) ~= "string" or image == "" then
        return nil
    end

    local assetId = image:match("rbxassetid://(%d+)")
        or image:match("/image/(%d+)")

    if not assetId then
        assetId = image:match("(%d+)")
    end

    if not assetId then
        return nil
    end

    return "https://ps99.biggamesapi.io/image/" .. assetId
end

function getCalculatedOneIn(pet)
    if type(pet) ~= "table" then
        return nil
    end

    local baseOneIn = tonumber(pet.OneIn)

    if not baseOneIn or baseOneIn < 1 then
        return nil
    end

    local tier = pet.Tier
    local mutation = pet.Mutation

    local tierFactor = 1
    local mutationFactor = 1

    if type(tier) == "string" then
        tierFactor = PetOdds.TierFactors[tier] or 1
    end

    if type(mutation) == "string"
        and mutation ~= ""
        and mutation ~= "None" then
        mutationFactor = PetOdds.MutationFactors[mutation] or 1
    end

    return baseOneIn * tierFactor * mutationFactor
end

function passesOneInFilter(pet)
    local oneIn = getCalculatedOneIn(pet)

    return oneIn ~= nil and oneIn >= MinimumOneIn
end

local RarityColors = {
    Basic = 0xAAAAAA,
    Common = 0xBFC5CC,
    Rare = 0x3498DB,
    Epic = 0x9B59B6,
    Legendary = 0xF1C40F,
    Mythical = 0xE91E63,
    ["Secret I"] = 0xE74C3C,
    ["Secret II"] = 0xFF1744,
    ["Secret III"] = 0xB71C1C,
    ["Secret X"] = 0xFF00FF
}

function getEmbedColor(rarity)
    if type(rarity) ~= "string" then
        return 0x2F3136
    end

    if RarityColors[rarity] then
        return RarityColors[rarity]
    end

    if rarity:sub(1, 6) == "Secret" then
        return 0xE74C3C
    end

    return 0x2F3136
end

function safeString(value, fallback)
    if value == nil then
        return fallback or "Unknown"
    end

    return tostring(value)
end

function abbreviateNumber(value)
    local number = tonumber(value)

    if not number then
        return safeString(value, "0")
    end

    local suffixes = {
        {1e33, "Dc"},
        {1e30, "No"},
        {1e27, "Oc"},
        {1e24, "Sp"},
        {1e21, "Sx"},
        {1e18, "Qi"},
        {1e15, "Qa"},
        {1e12, "T"},
        {1e9, "B"},
        {1e6, "M"},
        {1e3, "K"}
    }

    for _, suffix in ipairs(suffixes) do
        if math.abs(number) >= suffix[1] then
            local formatted = string.format("%.2f", number / suffix[1])
            formatted = formatted:gsub("%.?0+$", "")
            return formatted .. suffix[2]
        end
    end

    return tostring(math.floor(number))
end

function sendWebhook(embed, content)
    if not SendWebhookEnabled then
        return false
    end

    if type(WebhookURL) ~= "string"
        or WebhookURL == "" then
        warn("[OTC] Webhook URL is empty.")
        return false
    end

    local httpRequest = request
        or http_request
        or (syn and syn.request)

    if type(httpRequest) ~= "function" then
        warn("[OTC] HTTP request function not available.")
        return false
    end

    local payload = {
        username = "OTC",
        avatar_url = AvatarURL,
        embeds = {embed}
    }

    if content
        and SendWebhookWithMentionEnabled
        and DiscordUserID ~= "" then
        payload.content = content
        payload.allowed_mentions = {
            parse = {},
            users = {DiscordUserID}
        }
    end

    local success, response = pcall(function()
        return httpRequest({
            Url = WebhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(payload)
        })
    end)

    if not success then
        warn("[OTC] Webhook error:", response)
        return false
    end

    if response and response.StatusCode
        and response.StatusCode >= 400 then
        warn("[OTC] Discord returned:", response.StatusCode, response.Body)
        return false
    end

    return true
end

function getUserStats()
    local success, replica = pcall(function()
        local controller = require(
            ReplicatedStorage
                :WaitForChild("Controllers")
                :WaitForChild("Core")
                :WaitForChild("DataController")
        )

        return controller:GetReplica()
    end)

    if not success or not replica
        or type(replica.Data) ~= "table" then
        return {
            Playtime = "Unknown",
            Hatches = "Unknown",
            Clicks = "Unknown",
            Gems = "Unknown",
            Coins = "Unknown",
            Rebirths = "Unknown"
        }
    end

    local data = replica.Data
    local meta = data.Meta or {}
    local statistics = data.Statistics or {}
    local currencies = data.Currencies or {}

    local seconds = tonumber(meta.Playtime)
    local playtime = "Unknown"

    if seconds then
        seconds = math.max(0, math.floor(seconds))

        local hours = math.floor(seconds / 3600)
        local minutes = math.floor((seconds % 3600) / 60)

        playtime = string.format("%dh %dm", hours, minutes)
    end

    return {
        Playtime = playtime,
        Hatches = safeString(statistics.EggsOpened, "0"),
        Clicks = safeString(statistics.ActualTaps, "0"),
        Gems = abbreviateNumber(currencies.Gems or 0),
        Coins = abbreviateNumber(currencies.Coins or 0),
        Rebirths = abbreviateNumber(statistics.Rebirths or 0)
    }
end

function getSecretMention(rarity)
    if not SendWebhookWithMentionEnabled then
        return nil
    end

    if DiscordUserID == "" then
        return nil
    end

    if type(rarity) == "string"
        and rarity:sub(1, 6) == "Secret" then
        return "<@" .. DiscordUserID .. ">"
    end

    return nil
end

function sendOfflineHatch(data)
    if type(data) ~= "table" then
        return
    end

    local entries = data.Entries or {}
    local keptEntries = {}

    for _, entry in ipairs(entries) do
        if type(entry) == "table"
            and entry.AutoDeleted ~= true
            and passesOneInFilter(entry) then
            table.insert(keptEntries, entry)
        end
    end

    if #keptEntries == 0 then
        return
    end

    local fields = {
        {
            name = "🥚 Eggs Hatched",
            value = "`" .. safeString(data.Hatched, "0") .. "`",
            inline = true
        },
        {
            name = "🥚 Egg",
            value = "`" .. safeString(keptEntries[1].Egg, "Unknown Egg") .. "`",
            inline = true
        },
        {
            name = "✅ Kept",
            value = "`" .. safeString(data.Kept, tostring(#keptEntries)) .. "`",
            inline = true
        }
    }

    if data.Earned ~= nil then
        table.insert(fields, {
            name = "💰 Earned",
            value = "`" .. safeString(data.Earned, "0") .. "`",
            inline = true
        })
    end

    for index, entry in ipairs(keptEntries) do
        if index > 20 then
            table.insert(fields, {
                name = "➕ More Pets",
                value = "`" .. tostring(#keptEntries - 20) .. " more entries`",
                inline = false
            })
            break
        end

        local calculatedOneIn = getCalculatedOneIn(entry)

        local details = {
            "✨ **Rarity:** `" .. safeString(entry.Rarity, "Unknown") .. "`",
            "💎 **Tier:** `" .. safeString(entry.Tier, "Normal") .. "`",
            "🍀 **Chance:** `1 in " .. tostring(calculatedOneIn or entry.OneIn or "Unknown") .. "`",
            "🔢 **Count:** `" .. safeString(entry.Count, "1") .. "`"
        }

        local mutation = safeString(entry.Mutation, "None")

        if mutation ~= "None" and mutation ~= "" then
            table.insert(
                details,
                "🧬 **Mutation:** `" .. mutation .. "`"
            )
        end

        table.insert(fields, {
            name = "🐾 " .. safeString(entry.Name, "Unknown Pet"),
            value = table.concat(details, "\n"),
            inline = false
        })
    end

    local embed = {
        author = {
            name = "OTC",
            icon_url = AvatarURL
        },
        title = "Offline Hatch Results",
        description = "📋・**Offline Info**",
        color = 0x5865F2,
        fields = fields,
        footer = {
            text = "OTC • Tap Simulator: Reborn"
        },
        timestamp = DateTime.now():ToIsoDate()
    }

    local petImage = getPetImage(
        safeString(keptEntries[1].Name, "")
    )

    if petImage then
        embed.thumbnail = {
            url = petImage
        }
    end

    local mention

    for _, entry in ipairs(keptEntries) do
        mention = getSecretMention(safeString(entry.Rarity, ""))

        if mention then
            break
        end
    end

    sendWebhook(embed, mention)
end

function sendNormalHatch(result)
    if type(result) ~= "table" or result.Success == false then
        return
    end

    local pets = result.Pets

    if type(pets) ~= "table" or #pets == 0 then
        return
    end

    local stats = getUserStats()

    for _, pet in ipairs(pets) do
        if type(pet) == "table" and passesOneInFilter(pet) then
            local petName = safeString(pet.Name, "Unknown Pet")
            local rarity = safeString(pet.Rarity, "Unknown")
            local tier = safeString(pet.Tier, "Normal")
            local mutation = safeString(pet.Mutation, "None")

            local calculatedOneIn = getCalculatedOneIn(pet)
            local chance = calculatedOneIn
                and ("1 in " .. tostring(calculatedOneIn))
                or ("1 in " .. safeString(pet.OneIn, "Unknown"))

            local descriptionParts = {
                "🎉・**Hatch Info**",
                "- 🥚 **Egg:** `" .. safeString(result.Egg, "Unknown Egg") .. "`",
                "- 🏆 **Chance:** `" .. chance .. "`",
                "- 🎁 **Rarity:** `" .. rarity .. "`",
                "- 🔢 **Tier:** `" .. tier .. "`",
                "- 💪 **Power:** `" .. safeString(pet.Power, "Unknown") .. "`"
            }

            if mutation ~= "None" and mutation ~= "" then
                table.insert(
                    descriptionParts,
                    "- 🧬 **Mutation:** `" .. mutation .. "`"
                )
            end

            table.insert(descriptionParts, "")
            table.insert(descriptionParts, "👤・**User Info**")
            table.insert(descriptionParts, "- 🕒 **Playtime:** `" .. stats.Playtime .. "`")
            table.insert(descriptionParts, "- 🥚 **Hatches:** `" .. stats.Hatches .. "`")
            table.insert(descriptionParts, "- 👆 **Clicks:** `" .. stats.Clicks .. "`")
            table.insert(descriptionParts, "- 💎 **Gems:** `" .. stats.Gems .. "`")
            table.insert(descriptionParts, "- 💰 **Coins:** `" .. stats.Coins .. "`")
            table.insert(descriptionParts, "- 🔄 **Rebirths:** `" .. stats.Rebirths .. "`")

            local censoredName = "||" .. LocalPlayer.Name .. "||"
            local title

            if rarity:sub(1, 6) == "Secret" then
                title = "WOW! " .. censoredName
                    .. " hatched a " .. petName .. "! 🎉 Congrats!"
            else
                title = censoredName .. " hatched a " .. petName
            end

            local embed = {
                author = {
                    name = "OTC",
                    icon_url = AvatarURL
                },
                title = title,
                description = table.concat(descriptionParts, "\n"),
                color = getEmbedColor(rarity),
                timestamp = DateTime.now():ToIsoDate()
            }

            local petImage = getPetImage(petName)

            if petImage then
                embed.thumbnail = {
                    url = petImage
                }
            end

            sendWebhook(embed, getSecretMention(rarity))
        end
    end
end

function makeOfflineSignature(data)
    local entries = {}

    for _, entry in ipairs(data.Entries or {}) do
        table.insert(entries, {
            Egg = entry.Egg,
            Name = entry.Name,
            Tier = entry.Tier,
            Rarity = entry.Rarity,
            OneIn = entry.OneIn,
            Mutation = entry.Mutation,
            AutoDeleted = entry.AutoDeleted,
            Count = entry.Count
        })
    end

    return HttpService:JSONEncode({
        Id = data.Id,
        Hatched = data.Hatched,
        Kept = data.Kept,
        Deleted = data.Deleted,
        Earned = data.Earned,
        Reason = data.Reason,
        Entries = entries
    })
end

function startOfflineHatchWatcher()
    local DataController = require(
        ReplicatedStorage
            :WaitForChild("Controllers")
            :WaitForChild("Core")
            :WaitForChild("DataController")
    )

    local lastSignature = nil

    task.spawn(function()
        while true do
            local success, replica = pcall(function()
                return DataController:GetReplica()
            end)

            if success and replica and replica.Data then
                local offline = replica.Data.Offline
                local pending = offline and offline.HatchPending

                if type(pending) == "table"
                    and type(pending.Entries) == "table"
                    and #pending.Entries > 0 then

                    local signatureOk, signature = pcall(
                        makeOfflineSignature,
                        pending
                    )

                    if signatureOk and signature ~= lastSignature then
                        lastSignature = signature

                        task.spawn(function()
                            sendOfflineHatch(pending)
                        end)
                    end
                else
                    lastSignature = nil
                end
            end

            task.wait(0.5)
        end
    end)
end

function startNormalHatchWatcher()
    local success, eggService = pcall(function()
        return ReplicatedStorage
            :WaitForChild("RemoteServices")
            :WaitForChild("EggService")
            :WaitForChild("RE")
            :WaitForChild("EggHatchResult")
    end)

    if not success or not eggService then
        warn("[OTC] EggHatchResult not found.")
        return
    end

    if eggService:IsA("RemoteEvent") then
        eggService.OnClientEvent:Connect(function(result)
            task.defer(function()
                sendNormalHatch(result)
            end)
        end)
    else
        warn("[OTC] EggHatchResult is not a RemoteEvent.")
    end
end

WebhookTab:CreateInput({
    Name = "Webhook",
    PlaceholderText = "Discord Webhook URL",
    CurrentValue = "",
    RemoveTextAfterFocusLost = false,
    Flag = "WebhookURL",
    Callback = function(Value)
        WebhookURL = Value
    end
})

WebhookTab:CreateInput({
    Name = "Discord User Id",
    PlaceholderText = "Discord User ID",
    CurrentValue = "",
    RemoveTextAfterFocusLost = false,
    Flag = "DiscordUserID",
    Callback = function(Value)
        DiscordUserID = Value
    end
})

WebhookTab:CreateInput({
    Name = "Base Chance",
    PlaceholderText = "1000",
    CurrentValue = "1000",
    RemoveTextAfterFocusLost = false,
    Flag = "BaseChance",
    Callback = function(Value)
        local number = tonumber(Value)

        if number and number >= 1 then
            MinimumOneIn = math.floor(number)
        end
    end
})

WebhookTab:CreateToggle({
    Name = "Send Webhook with Mention",
    CurrentValue = true,
    Flag = "SendWebhookWithMention",
    Callback = function(Value)
        SendWebhookWithMentionEnabled = Value
    end
})

WebhookTab:CreateToggle({
    Name = "Send Webhook",
    CurrentValue = true,
    Flag = "SendWebhook",
    Callback = function(Value)
        SendWebhookEnabled = Value
    end
})

startOfflineHatchWatcher()
startNormalHatchWatcher()
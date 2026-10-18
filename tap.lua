if not game:IsLoaded() then
    game.Loaded:Wait()
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
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

local TapChestController = require(
    ReplicatedStorage.Controllers.Game.TapChestController
)

local ProgressionIslandConfig = require(
    ReplicatedStorage.Shared.Progression.IslandConfig
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

local Rayfield = loadstring(
    game:HttpGet("https://sirius.menu/gen2")
)()

local Window = Rayfield:CreateWindow({
    name = "OTC・Tap Simulator: Reborn",
    subtitle = "by aerlro",
    sidebarLayout = true,
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
        fileName = "OTC-TapSimulator",
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

local function GetExecutorName()
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

local function FormatPlaytime(Seconds)
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

local function UpdateHomeInfo()
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

local function formatNumber(number)
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

local function generateRebirthOptions(maxIndex)
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
    value = false,
    
    callback = function(value)
        OTC.Config.AutoTap = value

        if not value then
            return
        end

        task.spawn(function()
            while OTC.Config.AutoTap do
                local sequence = OTC.Config.ClientSequence

                local success, err = pcall(function()
                    TapEvent:FireServer({
                        Auto = false,
                        ClientSequence = sequence,
                    })
                end)

                if success then
                    OTC.Config.ClientSequence += 1
                else
                    warn("[OTC] Tap error:", err)
                end

                task.wait(OTC.Config.TapDelay)
            end
        end)
    end,
})

AutoTab:CreateDropdown({
    name = "Rebirth Type",
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

AutoTab:CreateToggle({
    name = "Auto Gem Upgrade",
    description = "Automatically purchase all available gem upgrades.",
    value = false,
    
    callback = function(value)
        OTC.Config.AutoGemUpgrade = value

        if not value then
            return
        end

        task.spawn(function()
            while OTC.Config.AutoGemUpgrade do
                for _, upgradeName in ipairs(UpgradeConfig.Order) do
                    if not OTC.Config.AutoGemUpgrade then
                        break
                    end

                    local definition = UpgradeConfig.Get(upgradeName)

                    if definition and not definition.SkillTreeNode then
                        local success, err = pcall(function()
                            UpgradeController:Purchase(upgradeName)
                        end)

                        if not success then
                            warn(
                                "[OTC] Gem Upgrade error:",
                                upgradeName,
                                err
                            )
                        end

                        task.wait(OTC.Config.GemUpgradeDelay)
                    end
                end

                task.wait(OTC.Config.GemUpgradeDelay)
            end
        end)
    end,
})

local SkillTreeNodes = {}
local SkillTreeNodeNames = {}

local SkillTreeDirections = {
    "N",
    "S",
    "NE",
    "NW",
    "SE",
    "SW",
}

local function collectSkillTreeNodes(node)
    if type(node) ~= "table" then
        return
    end

    if node.Name and not SkillTreeNodeNames[node.Name] then
        SkillTreeNodeNames[node.Name] = true
        table.insert(SkillTreeNodes, node.Name)
    end

    for _, direction in ipairs(SkillTreeDirections) do
        local child = node[direction]

        if type(child) == "table" then
            collectSkillTreeNodes(child)
        end
    end
end

for _, tree in pairs(SkillTreeConfig) do
    collectSkillTreeNodes(tree)
end

table.sort(SkillTreeNodes)

AutoTab:CreateToggle({
    name = "Auto Unlock Skill Tree",
    description = "Automatically unlock available Skill Tree nodes.",
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

                if not unlockedSomething then
                    task.wait(0.5)
                end
            end
        end)
    end,
})

AutoTab:CreateToggle({
    name = "Auto Claim Quests",
    description = "Automatically claim completed quests.",
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

AutoTab:CreateToggle({
    name = "Auto Buy Double Jumps",
    flag = "AutoBuyDoubleJumps",
    value = false,
    description = "Automatically purchases the next available +1 Jump upgrade.",
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

local function IsShinyStarFound(Id)
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

local function CollectShinyStar(Star)
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

local function StartShinyStarCollection()
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

local function GetClickerChestFolder()
    return workspace:FindFirstChild("ClickerChest")
end

local function GetClickerChests()
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

local function GetClickerChestPosition(Model)
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

local function TeleportToClickerChest(Model)
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

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if not Character or not Humanoid or Humanoid.Health <= 0 or not Root then
        return false
    end

    local Target = CFrame.new(
        Position + Vector3.new(0, OTC.Config.ClickerChestOffset, 0)
    )

    local Success = pcall(function()
        Root.CFrame = Target
        Character:PivotTo(Target)
    end)

    if not Success then
        return false
    end

    task.wait(0.2)

    Character = LocalPlayer.Character
    Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return false
    end

    return (Root.Position - Position).Magnitude <= 15
end

local function ProcessClickerChest(Model)
    if not TeleportToClickerChest(Model) then
        return
    end

    CurrentClickerChest = Model

    while OTC.Config.AutoClaimClickerChests do
        task.wait(OTC.Config.ClickerChestDelay)

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

        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local Root = Character and Character:FindFirstChild("HumanoidRootPart")

        if not Character or not Humanoid or Humanoid.Health <= 0 or not Root then
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
    end

    if CurrentClickerChest == Model then
        CurrentClickerChest = nil
    end
end

local function StartClickerChestWorker()
    if ClickerChestWorkerRunning then
        return
    end

    ClickerChestWorkerRunning = true

    task.spawn(function()
        while OTC.Config.AutoClaimClickerChests do
            local Chests = GetClickerChests()

            for _, Model in ipairs(Chests) do
                if not OTC.Config.AutoClaimClickerChests then
                    break
                end

                if Model ~= CurrentClickerChest then
                    pcall(ProcessClickerChest, Model)
                end
            end

            task.wait(0.2)
        end

        CurrentClickerChest = nil
        ClickerChestWorkerRunning = false
    end)
end

AutoTab:CreateToggle({
    Name = "Auto Claim Clicker Chests",
    CurrentValue = false,
    Callback = function(Value)
        OTC.Config.AutoClaimClickerChests = Value

        if Value then
            StartClickerChestWorker()
        end
    end,
})

local IslandAttackOrder = {
    "SkyIsland",
    "Autumn",
    "Mushroom",
    "Desert",
    "CrystalCave",
    "ShadowRelm"
}

local IslandAttackToken = 0

local function getIslandAttackRoot()
    local character = LocalPlayer.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function getIslandAttackTarget(typeName)
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

local function getIslandAttackPosition(obj)
    if obj:IsA("Model") then
        return obj:GetPivot().Position
    elseif obj:IsA("BasePart") then
        return obj.Position
    end

    return nil
end

local function islandAttackTargetDestroyed(obj)
    if not obj or not obj:IsDescendantOf(Workspace) then
        return true
    end

    local attributes = BreakableConfig.Attributes
    local hp = obj:GetAttribute(attributes.Health)

    return obj:GetAttribute(attributes.Broken) == true
        or obj:GetAttribute(attributes.Despawned) == true
        or (typeof(hp) == "number" and hp <= 0)
end

local function runIslandAttack(token)
    local spotsFolder = Workspace:WaitForChild("IslandBreakableSpots")

    while OTC.Config.AutoAttackIslandBreakables
        and IslandAttackToken == token do

        for _, id in ipairs(IslandAttackOrder) do
            if not OTC.Config.AutoAttackIslandBreakables
                or IslandAttackToken ~= token then
                break
            end

            local spot = IslandConfig.Get(id)

            if spot then
                local replica = DataController:GetReplica()
                local data = replica and replica.Data

                if data and IslandConfig.IsUnlocked(data, spot) then
                    local spotPosition

                    repeat
                        spotPosition = spotsFolder:GetAttribute(id)

                        if typeof(spotPosition) ~= "Vector3" then
                            task.wait(0.5)
                        end
                    until typeof(spotPosition) == "Vector3"
                        or not OTC.Config.AutoAttackIslandBreakables
                        or IslandAttackToken ~= token

                    if not OTC.Config.AutoAttackIslandBreakables
                        or IslandAttackToken ~= token then
                        break
                    end

                    local target = getIslandAttackTarget(spot.Type)

                    if not target then
                        local root = getIslandAttackRoot()

                        if root and (root.Position - spotPosition).Magnitude > 6 then
                            root.CFrame = CFrame.new(spotPosition + Vector3.new(0, 3, 0))
                        end
                    end

                    while OTC.Config.AutoAttackIslandBreakables
                        and IslandAttackToken == token
                        and not target do

                        local root = getIslandAttackRoot()

                        if root and (root.Position - spotPosition).Magnitude > 6 then
                            root.CFrame = CFrame.new(spotPosition + Vector3.new(0, 3, 0))
                        end

                        local currentReplica = DataController:GetReplica()
                        local currentData = currentReplica and currentReplica.Data
                        local remaining = 0

                        if currentData then
                            local readyAt = IslandConfig.GetReadyAt(currentData, id)
                            remaining = math.max(
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
                                ClientSequence = OTC.Config.ClientSequence
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
    value = OTC.Config.AutoAttackIslandBreakables,
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

                if not ok and IslandAttackToken == token then
                    OTC.Config.AutoAttackIslandBreakables = false
                end
            end)
        end
    end
})

local AutoClaimChestsRunning = false

local function getReadyTapChest(id)
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

local function autoClaimChests()
    local chestIds = {"SkyIsland", "Desert"}

    while OTC.Config.AutoClaimChests do
        for _, id in ipairs(chestIds) do
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

                local character = LocalPlayer.Character
                local root = character
                    and character:FindFirstChild("HumanoidRootPart")

                if root and typeof(front) == "CFrame"
                    and typeof(size) == "Vector3" then

                    local anchorPosition =
                        front.Position
                        - Vector3.new(0, size.Y * 0.5, 0)
                        + front.LookVector
                            * (size.Z * 0.5 + TapChestConfig.PromptInset)
                        + Vector3.new(0, TapChestConfig.PromptHeight, 0)

                    if (root.Position - anchorPosition).Magnitude
                        > TapChestConfig.LeaveDistance then
                        root.CFrame = CFrame.lookAt(
                            anchorPosition - front.LookVector * 2,
                            anchorPosition
                        )
                    end

                    task.wait(0.5)

                    if OTC.Config.AutoClaimChests
                        and chest:IsDescendantOf(Workspace) then
                        TapChestController:Interact(chest)

                        task.wait(12)
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
    CurrentValue = OTC.Config.AutoClaimChests,
    Callback = function(value)
        OTC.Config.AutoClaimChests = value

        if value and not AutoClaimChestsRunning then
            AutoClaimChestsRunning = true
            task.spawn(autoClaimChests)
        end
    end,
})

local AutoTeleportIslands = false
local TeleportLoopRunning = false
local IslandDelay = 3

local function getAllIslands()
    local islands = {}

    for name, config in ProgressionIslandConfig.Islands do
        table.insert(islands, {
            Name = name,
            Order = config.Order or math.huge
        })
    end

    table.sort(islands, function(a, b)
        return a.Order < b.Order
    end)

    return islands
end

local function runIslandTeleport()
    while AutoTeleportIslands do
        local islands = getAllIslands()

        for _, island in ipairs(islands) do
            if not AutoTeleportIslands then
                break
            end

            pcall(function()
                TravelRemote:InvokeServer({
                    Source = "Menu",
                    Island = island.Name
                })
            end)

            task.wait(IslandDelay)
        end

        task.wait(1)
    end

    TeleportLoopRunning = false
end

WorldTab:CreateToggle({
    Name = "Auto Teleport Islands",
    CurrentValue = false,
    Callback = function(value)
        AutoTeleportIslands = value

        if value and not TeleportLoopRunning then
            TeleportLoopRunning = true
            task.spawn(runIslandTeleport)
        end
    end,
})


local IslandOrder = {}

local IslandPriority = {
    ["Sky Island"] = 1,
    ["Sky Islands"] = 1,
    Autumn = 2,
    Mushroom = 3,
    Desert = 4,
    ["Crystal Cave"] = 5,
    ["Shadow Realm"] = 6,
    Volcano = 7,
}

for islandName, landing in pairs(IslandLandings) do
    if type(landing) == "table"
        and typeof(landing.Position) == "Vector3" then
        table.insert(IslandOrder, islandName)
    end
end

table.sort(IslandOrder, function(a, b)
    local orderA = IslandPriority[a] or math.huge
    local orderB = IslandPriority[b] or math.huge

    if orderA == orderB then
        return a < b
    end

    return orderA < orderB
end)

local UnlockEveryIslandEnabled = false
local UnlockEveryIslandRunning = false

local function unlockVisitIsland(islandName)
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
            {CFrame = CFrame.new(target)}
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
            local ok = pcall(function()
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

local function GetPetName(option)
    if type(option) ~= "string" then
        return ""
    end

    return option:match("^(.-)%s%[") or option
end

local function getEquippedIds(petData)
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

local function RefreshPets()
    if IsRefreshingPets then
        return
    end

    IsRefreshingPets = true

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
                and pet.Tier == "Normal"
                and (
                    OTC.Config.IncludeShinyPets
                    or pet.Mutation ~= "Shiny"
                ) then

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

local function TeleportToGoldenMachine()
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        return false
    end

    root.CFrame = CFrame.new(
        20.8617554, -508.079041, -1886.2561,
        -1, 0, 0,
        0, 1, 0,
        0, 0, -1
    )

    return true
end


PetsTab:CreateSection({
    name = "▶ Golden"
})

PetDropdown = PetsTab:CreateDropdown({
    name = "Pets",
    description = "Live inventory of Normal pets and equipped status.",
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
        else
            SelectedPetName = GetPetName(value)
            OTC.Config.SelectedPet = value
        end
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
    name = "Include Shiny Pets",
    description = "Allow Shiny pets to be used for Golden crafting.",
    value = OTC.Config.IncludeShinyPets or false,
    callback = function(value)
        OTC.Config.IncludeShinyPets = value
        RefreshPets()
    end,
})

PetsTab:CreateToggle({
    name = "Auto Golden Pets",
    flag = "AutoGoldenPets",
    value = OTC.Config.AutoGoldenPets,
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
                    local selectedPets = {}
                    local requiredCount = OTC.Config.GoldenPetCount

                    if type(requiredCount) ~= "number"
                        or requiredCount < 1 then
                        return
                    end

                    for id, pet in pairs(petData.Owned) do
                        if type(pet) == "table" then
                            local petId = pet.Id or id

                            local isEligibleMutation =
                                pet.Mutation == nil
                                or (
                                    OTC.Config.IncludeShinyPets
                                    and pet.Mutation == "Shiny"
                                )

                            if pet.Name == selectedName
                                and pet.Tier == "Normal"
                                and isEligibleMutation
                                and not pet.Locked
                                and not pet.Frozen
                                and not equippedIds[petId]
                                and not pet.Equip
                                and not pet.Equipped
                                and not pet.Enchant
                                and not pet.Enchant2
                                and not pet.Signature
                                and pet.Rarity ~= "Secret" then

                                table.insert(selectedPets, petId)

                                if #selectedPets >= requiredCount then
                                    break
                                end
                            end
                        end
                    end

                    if #selectedPets == requiredCount then
                        MachineService.MachineCraftRequested:Fire({
                            Machine = "Golden",
                            Action = "Craft",
                            PetIds = selectedPets,
                        })
                    end
                end)

                if not success then
                    warn("[OTC] Auto Golden error:", err)
                end

                task.wait(OTC.Config.GoldenDelay)
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

local function GetDiamondPetName(option)
    if type(option) ~= "string" then
        return ""
    end

    return option:match("^(.-)%s%[") or option
end

local function RefreshDiamondPets()
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

        if #newOptions == 0 then
            table.insert(newOptions, "None")
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
    name = "Diamond Pets",
    description = "Live inventory of Golden pets and equipped status.",
    options = DiamondPetOptions,
    value = "None",
    flag = "DiamondPetSelection",
    callback = function(value)
        if IsRefreshingDiamondPets then
            return
        end

        if value == "None" or value == "No pets" then
            SelectedDiamondPetName = ""
            OTC.Config.SelectedDiamondPet = "None"
        else
            SelectedDiamondPetName = GetDiamondPetName(value)
            OTC.Config.SelectedDiamondPet = value
        end
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
    description = "Automatically craft the selected Golden pet into Diamond.",
    flag = "AutoDiamondPets",
    value = OTC.Config.AutoDiamondPets,
    callback = function(value)
        OTC.Config.AutoDiamondPets = value

        if not value then
            return
        end


        task.spawn(function()
            local function TeleportToDiamondMachine()
                local character = LocalPlayer.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")

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
                    local requiredCount = OTC.Config.DiamondPetCount

                    if type(requiredCount) ~= "number"
                        or requiredCount < 1 then
                        return
                    end

                    local selectedPets = {}

                    for id, pet in pairs(pets) do
                        if type(pet) == "table" then
                            local petId = pet.Id or id

                            if pet.Name == selectedName
                                and pet.Tier == MachineConfig.Diamond.SourceTier
                                and pet.Locked ~= true
                                and pet.Frozen ~= true
                                and not equippedIds[petId]
                                and not pet.Equip
                                and not pet.Equipped
                                and pet.Mutation == nil
                                and pet.Enchant == nil
                                and pet.Enchant2 == nil
                                and pet.Signature == nil
                                and not (
                                    type(pet.Rarity) == "string"
                                    and pet.Rarity:match("^Secret")
                                ) then

                                table.insert(selectedPets, petId)

                                if #selectedPets >= requiredCount then
                                    break
                                end
                            end
                        end
                    end

                    if #selectedPets == requiredCount then
                        MachineService.MachineCraftRequested:Fire({
                            Machine = "Diamond",
                            Action = "Craft",
                            PetIds = selectedPets,
                        })
                    end
                end)

                if not success then
                    warn("[OTC Diamond] Craft error:", err)
                end

                task.wait(OTC.Config.DiamondDelay)
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

local function GetRainbowPetName(option)
    if type(option) ~= "string" then
        return ""
    end

    return option:match("^(.-)%s%[") or option
end

local function RefreshRainbowPets()
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
            local function TeleportToRainbowMachine()
                local character = LocalPlayer.Character
                local root = character
                    and character:FindFirstChild("HumanoidRootPart")

                if not root then
                    return false
                end

                root.CFrame = CFrame.new(
                    -106.900513, 11104.2422, -2021.28284,
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

local function IsHatchAnimationDisabled()
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

local function FormatEggPrice(price)
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

local function TeleportToEgg()
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

local function log(...)
    print("[OTC Auto Dig]", ...)
end

local function logError(...)
    warn("[OTC Auto Dig ERROR]", ...)
end

local function TeleportToDigZone()
    log("Caut DigZone...")

    local islands = workspace:FindFirstChild("Ts2Islands")
    local autumn = islands and islands:FindFirstChild("Autumn")
    local digsite = autumn and autumn:FindFirstChild("Digsite")
    local digZone = digsite and digsite:FindFirstChild("DigZone")

    if not digZone then
        logError("DigZone nu a fost găsit!")
        return false
    end

    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        logError("HumanoidRootPart nu a fost găsit!")
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
            logError("DigZone nu conține niciun BasePart!")
            return false
        end

        targetPosition = part.Position
    end

    log("Teleport la:", targetPosition)

    root.CFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 0))
    task.wait(0.5)

    log("Teleport efectuat.")
    return true
end

local lastRewardClose = 0

local function HandleDigReward()
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

            print("[OTC Auto Dig] Încerc închiderea recompensei.")

            local success, err = pcall(function()
                DigRewardPopup:Close()
            end)

            if not success then
                warn("[OTC Auto Dig] Close error:", err)
            else
                print("[OTC Auto Dig] Close apelat.")
            end

            return true
        end
    end

    return false
end

local function TryActivate(reason)
    log("Activate() apelat. Motiv:", reason)

    local success, result = pcall(function()
        return DigController:Activate()
    end)

    if not success then
        logError("Activate() a produs o eroare:", result)
        return false
    end

    if typeof(result) == "table" then
        log("Rezultat Activate():", result.Error or "fără Error")

        if result.Error then
            logError("Activate a returnat:", result.Error)
            return false
        end
    elseif result == nil then
        log("Activate() a returnat nil; verificăm starea minigame-ului.")
    else
        log("Rezultat Activate():", result)
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

        log("Toggle schimbat:", value)

        if not value then
            log("Auto Dig oprit.")
            return
        end

        log("Auto Dig pornit.")

        task.spawn(function()
            log("Inițializez teleportarea...")

            if not TeleportToDigZone() then
                logError("Inițializarea a eșuat. Oprire.")
                if AutoDigSession == session then
                    AutoDig = false
                end
                return
            end

            log("Încep bucla principală.")

            local lastStartAttempt = 0
            local lastState = nil
            local lastRoundSequence = nil

            while AutoDig and AutoDigSession == session do
                local success, err = pcall(function()
                    if HandleDigReward() then
                        log("Recompensă detectată; aștept închiderea popup-ului.")
                        task.wait(0.5)
                        return
                    end

                    local state = DigController:GetState()

                    if not state then
                        if lastState ~= "NO_STATE" then
                            log("Stare nil: încerc să pornesc minigame-ul.")
                            lastState = "NO_STATE"
                        end

                        if os.clock() - lastStartAttempt >= 0.5 then
                            lastStartAttempt = os.clock()
                            TryActivate("state nil")
                        end

                        task.wait(0.2)
                        return
                    end

                    local round = state.Round

                    if not round then
                        if lastState ~= "WAITING" then
                            log("Nu există rundă activă. Încerc pornirea.")
                            lastState = "WAITING"
                        end

                        if os.clock() - lastStartAttempt >= 0.5 then
                            lastStartAttempt = os.clock()
                            TryActivate("round nil / Tap to Dig")
                        end

                        task.wait(0.2)
                        return
                    end

                    if lastRoundSequence ~= round.Sequence then
                        log("Rundă detectată. Sequence:", round.Sequence)
                        lastRoundSequence = round.Sequence
                        lastState = "ROUND"
                    end

                    local sequence = round.Sequence

                    while AutoDig and AutoDigSession == session do
                        if HandleDigReward() then
                            log("Recompensă detectată în timpul rundei.")
                            break
                        end

                        local currentState = DigController:GetState()

                        if not currentState then
                            log("Starea a dispărut în timpul rundei.")
                            break
                        end

                        if not currentState.Round then
                            log("Runda s-a încheiat sau așteaptă repornirea.")
                            break
                        end

                        if currentState.Round.Sequence ~= sequence then
                            log("Sequence s-a schimbat; verific următoarea rundă.")
                            break
                        end

                        local now = workspace:GetServerTimeNow()
                        local cursor = DigConfig.Cursor(round, now)
                        local distance = math.abs(cursor - round.Center)

                        if now >= round.Epoch
                            and distance <= round.Width * 0.35 then

                            log(
                                "Zona DIG detectată!",
                                "Cursor:", cursor,
                                "Center:", round.Center,
                                "Distance:", distance
                            )

                            TryActivate("DIG zone")

                            task.wait(DigConfig.MinHitInterval or 0.16)
                            break
                        end

                        RunService.Heartbeat:Wait()
                    end
                end)

                if not success then
                    logError("Eroare în bucla principală:", err)
                    task.wait(0.5)
                end

                task.wait(0.05)
            end

            log("Bucla s-a oprit. Session:", session)
        end)
    end,
})

local AutoPetDefense = false
local AutoPetDefenseSession = 0

local function TeleportToColosseum()
    local island = workspace:FindFirstChild("WaveDefence Island")
    local waveDefense = island and island:FindFirstChild("WaveDefense")
    local colosseum = waveDefense and waveDefense:FindFirstChild("Colosseum")

    if not colosseum then
        warn("[OTC Pet Defense] Colosseum nu a fost găsit.")
        return false
    end

    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        warn("[OTC Pet Defense] HumanoidRootPart nu a fost găsit.")
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
            warn("[OTC Pet Defense] Colosseum nu conține niciun BasePart.")
            return false
        end

        targetPosition = part.Position
    end

    root.CFrame = CFrame.new(targetPosition + Vector3.new(0, 3, 0))
    print("[OTC Pet Defense] Teleport reușit.")
    return true
end

local function StartPetDefense()
    print("[OTC Pet Defense] Începem procedura de start...")

    if not TeleportToColosseum() then
        return false
    end

    task.wait(1)

    -- Deschide interfața de confirmare a Colosseum-ului.
    local opened, openError = pcall(function()
        ColosseumClientAdapter.Signals.Fire("StartColosseum")
    end)

    if not opened then
        warn("[OTC Pet Defense] Nu am putut deschide confirmarea:", openError)
    end

    -- Așteaptă apariția butonului Yes.
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

    if not yesButton then
        warn("[OTC Pet Defense] Butonul Yes nu a apărut.")
        return false
    end

    if typeof(firesignal) ~= "function" then
        warn("[OTC Pet Defense] Executorul nu oferă firesignal.")
        return false
    end

    print("[OTC Pet Defense] Apăsăm Yes...")

    local clicked, clickError = pcall(function()
        firesignal(yesButton.Activated)
    end)

    if not clicked then
        warn("[OTC Pet Defense] Eroare la Yes:", clickError)
        return false
    end

    -- Verifică dacă jocul a pornit efectiv.
    for _ = 1, 100 do
        if LocalPlayer:GetAttribute("ColosseumActive") == true then
            print("[OTC Pet Defense] SUCCESS: ColosseumActive = true!")
            return true
        end

        task.wait(0.1)
    end

    warn(
        "[OTC Pet Defense] Nu s-a confirmat pornirea.",
        "ColosseumActive =",
        tostring(LocalPlayer:GetAttribute("ColosseumActive"))
    )

    return false
end

MinigamesTab:CreateToggle({
    name = "Auto Pet Defense",
    description = "Teleport, confirmă cu Yes și atacă automat.",
    flag = "AutoPetDefense",
    value = false,

    callback = function(value)
        AutoPetDefense = value
        AutoPetDefenseSession += 1

        local session = AutoPetDefenseSession

        if not value then
            print("[OTC Pet Defense] Dezactivat.")
            return
        end

        task.spawn(function()
            local started = StartPetDefense()

            if not AutoPetDefense or AutoPetDefenseSession ~= session then
                return
            end

            if not started then
                warn("[OTC Pet Defense] Start neconfirmat; verifică mesajele din Output.")
                return
            end

            while AutoPetDefense and AutoPetDefenseSession == session do
                local success, err = pcall(function()
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

                if not success then
                    warn("[OTC Auto Pet Defense] Error:", err)
                end

                task.wait(0.22)
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

local function UpdateMiningLog(Message)
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

local function GetMiningController()
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

local function GetMiningService()
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

local function GetMiningConfig()
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

local function GetMiningState()
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

local function ParseMiningCell(Block)
    local X, Y, Z = Block.Name:match(
        "^(-?%d+):(-?%d+):(-?%d+)$"
    )

    if not X then
        return nil
    end

    return tonumber(X), tonumber(Y), tonumber(Z)
end

local function GetMiningBlock(BlockName)
    local Folder = workspace:FindFirstChild("LocalMiningBlocks")
    return Folder and Folder:FindFirstChild(BlockName)
end

local function GetMiningBlockPosition(BlockName)
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

local function MoveNearMiningBlock(Position)
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

local function GetMiningBlockStats(State, Cell)
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

local function GetMiningCandidates()
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

local function HitMiningCell(State, Cell)
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

local function AutoSellSection()
    local CurrentCapacity = 2500
local SliderObject
local AutoSellTriggered = false
local AutoSellBusy = false

local function GetSellPad()
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

local function TweenToSell()
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

local function GetUpgradeStand()
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
    callback = function(Value)
        AutoUpgradeBackpack = Value

        if Value then
            task.spawn(PurchaseItems, "Backpack")
        end
    end
})

local function GetDailyShop()
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
    CurrentValue = false,
    Flag = "AutoBuyDailyShop",

    Callback = function(Value)
        OTC.Config.AutoBuyDailyShop = Value

        if Value then
            task.spawn(RunAutoBuyDailyShop)
        end
    end,
})
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

OTC.Runtime = OTC.Runtime or {}

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

local RiftIslandConfig = require(
    ReplicatedStorage.Shared.Progression.RiftIslandConfig
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

local FishingController = require(
    ReplicatedStorage.Controllers.Game.FishingController
)

local FishingConfig = require(
    ReplicatedStorage.Shared.Minigames.Fishing.FishingConfig
)

local FishingSim = require(
    ReplicatedStorage.Shared.Minigames.Fishing.FishingSim
)

local EventCurrencyConfig = require(
    ReplicatedStorage.Shared.Core.EventCurrencyConfig
)

local LuckyDuckyController = require(
    ReplicatedStorage.Controllers.Game.LuckyDuckyController
)

local LuckyEggMachineConfig = require(
    ReplicatedStorage.Shared.Game.LuckyEggMachineConfig
)

local PetPower = require(
    ReplicatedStorage.Shared.Pets.PetPower
)

local jumpUpgrade = assert(
    PhysicalUpgradeConfig.Get("+1 Jump"),
    "Double Jump upgrade not found"
)

local RiftJumpLine = PhysicalUpgradeConfig.RiftJumpLine
local RiftJumpUpgrade = assert(
    PhysicalUpgradeConfig.Get(RiftJumpLine),
    "Rift Double Jump upgrade not found"
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

local FishingService = Comm.ClientComm.new(
    ReplicatedStorage.RemoteServices,
    false,
    "FishingService"
):BuildObject()

local LuckyEggService = Comm.ClientComm.new(
    ReplicatedStorage.RemoteServices,
    false,
    "LuckyEggMachineService"
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

local TimeRiftIslandRemote = ReplicatedStorage
    :WaitForChild("RemoteServices")
    :WaitForChild("TimeRiftIslandService")

local TimeRiftIslandTravel = TimeRiftIslandRemote
    :WaitForChild("RF")
    :WaitForChild("Travel")

local TimeRiftIslandUnlockResult = TimeRiftIslandRemote
    :WaitForChild("RE")
    :WaitForChild("IslandUnlockResult")

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
        autoSave = false,
        autoLoad = false,
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

local FishingTab = Window:CreateTab({
    name = "Fishing",
    icon = "fish",
})

local WebhookTab = Window:CreateTab({
    name = "Webhook",
    icon = "webhook",
})

local SettingsTab = Window:CreateTab({
    name = "Settings",
    icon = "settings",
})

OTC.Runtime.ConfigFolder = "OTC"
OTC.Runtime.ConfigFile = "config_" .. tostring(LocalPlayer.UserId) .. ".json"
OTC.Runtime.ConfigPath = OTC.Runtime.ConfigFolder .. "/" .. OTC.Runtime.ConfigFile

OTC.Runtime.RegisteredFlags = {}
OTC.Runtime.AutoSaveEnabled = false
OTC.Runtime.SelectedConfigFile = OTC.Runtime.ConfigFile

function registerFlagElement(tab, methodName)
    local original = tab[methodName]
    if type(original) ~= "function" then
        return
    end

    tab[methodName] = function(self, options, ...)
        if type(options) == "table" then
            local flagName = options.flag or options.Flag
            if type(flagName) == "string" and flagName ~= "" then
                local callbackKey = type(options.callback) == "function" and "callback"
                    or (type(options.Callback) == "function" and "Callback" or nil)
                local initialValue = options.value
                if initialValue == nil then initialValue = options.Value end
                if initialValue == nil then initialValue = options.CurrentValue end

                OTC.Runtime.RegisteredFlags[flagName] = {
                    value = initialValue,
                    callback = nil,
                    element = nil,
                }

                if callbackKey then
                    local originalCallback = options[callbackKey]
                    OTC.Runtime.RegisteredFlags[flagName].callback = originalCallback
                    options[callbackKey] = function(value, ...)
                        OTC.Runtime.RegisteredFlags[flagName].value = value
                        return originalCallback(value, ...)
                    end
                end
            end
        end

        local element = original(self, options, ...)
        if type(options) == "table" then
            local flagName = options.flag or options.Flag
            local entry = type(flagName) == "string" and OTC.Runtime.RegisteredFlags[flagName]
            if entry then
                entry.element = element
            end
        end
        return element
    end
end

for _, tab in ipairs({HomeTab, AutoTab, WorldTab, PetsTab, EggsTab, MinigamesTab, FishingTab, WebhookTab, SettingsTab}) do
    for _, methodName in ipairs({"CreateToggle", "CreateDropdown", "CreateSlider", "CreateInput"}) do
        registerFlagElement(tab, methodName)
    end
end

function ensureConfigFolder()
    if not isfolder(OTC.Runtime.ConfigFolder) then
        makefolder(OTC.Runtime.ConfigFolder)
    end
end

function getConfigFiles()
    ensureConfigFolder()
    local files = {}
    for _, path in ipairs(listfiles(OTC.Runtime.ConfigFolder)) do
        local name = path:match("[^/\\]+$")
        if name and name:match("^config_%d+%.json$") then
            table.insert(files, name)
        end
    end
    table.sort(files)
    if #files == 0 then
        table.insert(files, OTC.Runtime.ConfigFile)
    end
    return files
end

function saveConfig()
    local ok, err = pcall(function()
        ensureConfigFolder()
        local flags = {}
        for name, entry in pairs(OTC.Runtime.RegisteredFlags) do
            if entry.value ~= nil then
                flags[name] = entry.value
            end
        end

        local data = {
            UserId = LocalPlayer.UserId,
            Version = 1,
            Flags = flags,
            Config = OTC.Config,
        }

        writefile(OTC.Runtime.ConfigPath, HttpService:JSONEncode(data))
    end)

    if ok then
        print("[OTC] Configuration saved: " .. OTC.Runtime.ConfigFile)
    else
        warn("[OTC] Failed to save configuration:", err)
    end
    return ok
end

function loadConfig(fileName)
    local ok, err = pcall(function()
        ensureConfigFolder()
        fileName = fileName or OTC.Runtime.SelectedConfigFile
        assert(type(fileName) == "string" and fileName:match("^config_%d+%.json$"), "Invalid config filename")

        local path = OTC.Runtime.ConfigFolder .. "/" .. fileName
        assert(isfile(path), "Config file not found")
        local data = HttpService:JSONDecode(readfile(path))
        assert(type(data) == "table" and type(data.Flags) == "table", "Invalid config data")

        if type(data.Config) == "table" then
            for key, value in pairs(data.Config) do
                if OTC.Config[key] ~= nil and type(OTC.Config[key]) == type(value) then
                    OTC.Config[key] = value
                end
            end
        end

        for name, value in pairs(data.Flags) do
            local entry = OTC.Runtime.RegisteredFlags[name]
            if entry then
                entry.value = value
                local applied = false
                if type(entry.element) == "table" and type(entry.element.Set) == "function" then
                    applied = pcall(function()
                        entry.element:Set(value)
                    end)
                end
                if not applied and type(entry.callback) == "function" then
                    entry.callback(value)
                end
            end
        end
    end)

    if ok then
        print("[OTC] Configuration loaded: " .. tostring(fileName))
    else
        warn("[OTC] Failed to load configuration:", err)
    end
    return ok
end

SettingsTab:CreateSection({name = "Configuration"})

SettingsTab:CreateToggle({
    name = "Auto Save",
    description = "Automatically save all registered flags every 5 minutes.",
    flag = "OTCAutoSave",
    value = false,
    callback = function(value)
        OTC.Runtime.AutoSaveEnabled = value
    end,
})

SettingsTab:CreateButton({
    name = "Save",
    description = "Save all UI flags and OTC configuration to JSON.",
    callback = function()
        saveConfig()
    end,
})

SettingsTab:CreateDropdown({
    name = "Files",
    description = "Select a configuration file to load.",
    flag = "OTCSelectedConfigFile",
    options = getConfigFiles(),
    value = OTC.Runtime.ConfigFile,
    callback = function(value)
        OTC.Runtime.SelectedConfigFile = value
    end,
})

SettingsTab:CreateButton({
    name = "Load",
    description = "Load the selected JSON configuration.",
    callback = function()
        loadConfig(OTC.Runtime.SelectedConfigFile)
    end,
})

task.spawn(function()
    while true do
        task.wait(1)
        if OTC.Runtime.AutoSaveEnabled then
            local elapsed = 0
            while elapsed < 300 and OTC.Runtime.AutoSaveEnabled do
                task.wait(1)
                elapsed += 1
            end
            if OTC.Runtime.AutoSaveEnabled then
                saveConfig()
            end
        end
    end
end)

OTC.Runtime.HomeStartTime = os.clock()

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
        FormatPlaytime(os.clock() - OTC.Runtime.HomeStartTime)
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

OTC.Runtime.RebirthOptions = {}
OTC.Runtime.RebirthIndexes = {}

function generateRebirthOptions(maxIndex)
    table.clear(OTC.Runtime.RebirthOptions)
    table.clear(OTC.Runtime.RebirthIndexes)

    for index = 1, maxIndex do
        local amount = 5 ^ (index - 1)
        local option = "+" .. formatNumber(amount)

        table.insert(OTC.Runtime.RebirthOptions, option)
        OTC.Runtime.RebirthIndexes[option] = index
    end
end

OTC.Runtime.maxIndex = 14

OTC.Runtime.configFolder = ReplicatedStorage:FindFirstChild("Shared")
OTC.Runtime.progressionFolder = OTC.Runtime.configFolder
    and OTC.Runtime.configFolder:FindFirstChild("Progression")

OTC.Runtime.buttonConfigModule = OTC.Runtime.progressionFolder
    and OTC.Runtime.progressionFolder:FindFirstChild("RebirthButtonConfig")

if OTC.Runtime.buttonConfigModule then
    local success, result = pcall(function()
        local buttonConfig = require(OTC.Runtime.buttonConfigModule)
        return buttonConfig.GetMaximumOptions("Main")
    end)

    if success and type(result) == "number" then
        OTC.Runtime.maxIndex = result
    end
end

generateRebirthOptions(OTC.Runtime.maxIndex)

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
    options = OTC.Runtime.RebirthOptions,
    default = OTC.Runtime.RebirthOptions[1],

    callback = function(value)
        local index = OTC.Runtime.RebirthIndexes[value]

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

OTC.Runtime.AntiAFKEnabled = false
OTC.Runtime.AntiAFKConnection = nil
OTC.Runtime.AntiAFKToken = 0

HomeTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Description = "Anti AFK.",
    Callback = function(Value)
        OTC.Runtime.AntiAFKEnabled = Value
        OTC.Runtime.AntiAFKToken += 1

        local CurrentToken = OTC.Runtime.AntiAFKToken

        if OTC.Runtime.AntiAFKConnection then
            OTC.Runtime.AntiAFKConnection:Disconnect()
            OTC.Runtime.AntiAFKConnection = nil
        end

        if not Value then
            return
        end

        local Players = game:GetService("Players")
        local VirtualUser = game:GetService("VirtualUser")
        local Player = Players.LocalPlayer

        OTC.Runtime.AntiAFKConnection = Player.Idled:Connect(function()
            if not OTC.Runtime.AntiAFKEnabled then
                return
            end

            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end)
        end)

        task.spawn(function()
            while OTC.Runtime.AntiAFKEnabled and OTC.Runtime.AntiAFKToken == CurrentToken do
                task.wait(300)

                if not OTC.Runtime.AntiAFKEnabled or OTC.Runtime.AntiAFKToken ~= CurrentToken then
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

OTC.Runtime.SkillTreeNodes = {}
OTC.Runtime.SkillTreeNodeNames = {}

function collectSkillTreeNodes(node, visited)
    if type(node) ~= "table" or visited[node] then
        return
    end

    visited[node] = true

    if type(node.Name) == "string"
        and not OTC.Runtime.SkillTreeNodeNames[node.Name] then
        OTC.Runtime.SkillTreeNodeNames[node.Name] = true
        table.insert(OTC.Runtime.SkillTreeNodes, node.Name)
    end

    for key, child in pairs(node) do
        if key ~= "Name" and type(child) == "table" then
            collectSkillTreeNodes(child, visited)
        end
    end
end

OTC.Runtime.visitedSkillTreeTables = {}

for _, tree in pairs(SkillTreeConfig) do
    collectSkillTreeNodes(tree, OTC.Runtime.visitedSkillTreeTables)
end

table.sort(OTC.Runtime.SkillTreeNodes)

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

                for _, nodeName in ipairs(OTC.Runtime.SkillTreeNodes) do
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

OTC.Runtime.AutoClaimIndexAll = false
OTC.Runtime.IndexClaimSession = 0

AutoTab:CreateToggle({
    name = "Auto Claim Index All",
    description = "Automatically claims all available Index rewards for pets and eggs.",
    flag = "AutoClaimIndexAll",
    value = false,
    callback = function(value)
        OTC.Runtime.AutoClaimIndexAll = value
        OTC.Runtime.IndexClaimSession += 1

        local session = OTC.Runtime.IndexClaimSession

        if not value then
            return
        end

        task.spawn(function()
            while OTC.Runtime.AutoClaimIndexAll
                and OTC.Runtime.IndexClaimSession == session do

                local success, err = pcall(function()
                    local replica = DataController:GetReplica()
                    local data = replica and replica.Data
                    local pets = data and data.Pets

                    if type(pets) ~= "table" then
                        return
                    end

                    local claimables = PetIndexCatalog.Claimables(pets)

                    for _, item in ipairs(claimables) do
                        if not OTC.Runtime.AutoClaimIndexAll
                            or OTC.Runtime.IndexClaimSession ~= session then
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

OTC.Runtime.AutoBuyDoubleJumps = false
OTC.Runtime.DoubleJumpSession = 0

OTC.Runtime.DoubleJumpPosition = CFrame.new(
    -98.6733017, -516.033081, -1679.99146,
    0.963639021, 0, 0.267207414,
    0, 1, 0,
    -0.267207414, 0, 0.963639021
)

function GetPhysicalUpgradePosition(upgradeName)
    for _, model in ipairs(CollectionService:GetTagged(PhysicalUpgradeConfig.Tag)) do
        if model:IsA("Model")
            and model:GetAttribute("UpgradeName") == upgradeName then
            return model:GetPivot().Position
        end
    end

    return nil
end

AutoTab:CreateToggle({
    name = "Auto Buy Double Jumps",
    flag = "AutoBuyDoubleJumps",
    value = false,
    description = "Automatically buys the next available +1 Jump upgrade in the current world.",
    callback = function(value)
        OTC.Runtime.AutoBuyDoubleJumps = value
        OTC.Runtime.DoubleJumpSession += 1

        local session = OTC.Runtime.DoubleJumpSession

        if not value then
            return
        end

        task.spawn(function()
            while OTC.Runtime.AutoBuyDoubleJumps
                and OTC.Runtime.DoubleJumpSession == session do

                local success, err = pcall(function()
                    local replica = DataController:GetReplica()
                    local data = replica and replica.Data

                    if not data then
                        return
                    end

                    local isTimeRift = LocalPlayer:GetAttribute("World") == "TimeRift"
                    local upgradeName = isTimeRift and RiftJumpLine or "+1 Jump"
                    local upgrade = isTimeRift and RiftJumpUpgrade or jumpUpgrade

                    local owned = PhysicalUpgradeConfig.GetOwned(data, upgrade)
                    local nextIndex = owned + 1
                    local nextPrice = upgrade.Prices[nextIndex]

                    if not nextPrice then
                        return
                    end

                    if PhysicalUpgradeConfig.GetLockedIsland(data, upgrade, nextIndex) ~= nil then
                        return
                    end

                    local character = LocalPlayer.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")

                    if not root then
                        return
                    end

                    if isTimeRift then
                        local position = GetPhysicalUpgradePosition(upgradeName)

                        if not position then
                            warn("[OTC Auto Double Jumps] Rift upgrade machine not found.")
                            return
                        end

                        root.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
                    else
                        root.CFrame = OTC.Runtime.DoubleJumpPosition
                    end

                    task.wait(0.25)

                    PhysicalUpgradeController:BuyStep(
                        upgradeName,
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

OTC.Runtime.ShinyStars = {
    {Id = "Spawn1", World = "Main", Island = "Spawn", Pos = Vector3.new(-79.69999694824219, -49.06557846069336, -1930.4000244140625)},
    {Id = "Spawn2", World = "Main", Island = "Spawn", Pos = Vector3.new(-61.90705490112305, -53.56557846069336, -1791.1435546875)},
    {Id = "Spawn3", World = "Main", Island = "Spawn", Pos = Vector3.new(53.599998474121094, -513.2655639648438, -2015.699951171875)},
    {Id = "SkyIsland1", World = "Main", Island = "Sky Island", Pos = Vector3.new(-4.400001525878906, -513.2655639648438, -1699.5)},
    {Id = "SkyIsland2", World = "Main", Island = "Sky Island", Pos = Vector3.new(-98.26245880126953, -387.4767761230469, -1534.1929931640625)},
    {Id = "Autumn1", World = "Main", Island = "Autumn", Pos = Vector3.new(-125.5, 905.1344604492188, -1978.300048828125)},
    {Id = "Autumn2", World = "Main", Island = "Autumn", Pos = Vector3.new(23.600000381469727, 882.8344116210938, -1947.9000244140625)},
    {Id = "Mushroom1", World = "Main", Island = "Mushroom", Pos = Vector3.new(78.9000015258789, 2034.534423828125, -1996)},
    {Id = "Mushroom2", World = "Main", Island = "Mushroom", Pos = Vector3.new(-124.0999984741211, 2032.534423828125, -2067.89990234375)},
    {Id = "Desert1", World = "Main", Island = "Desert", Pos = Vector3.new(13.199999809265137, 3643.33447265625, -2165.89990234375)},
    {Id = "Desert2", World = "Main", Island = "Desert", Pos = Vector3.new(59.099998474121094, 3636.434326171875, -1979.0999755859375)},
    {Id = "CrystalCave1", World = "Main", Island = "Crystal Cave", Pos = Vector3.new(-235, 5444.9345703125, -2050.89990234375)},
    {Id = "CrystalCave2", World = "Main", Island = "Crystal Cave", Pos = Vector3.new(19.700000762939453, 5446.5341796875, -2033.5)},
    {Id = "ShadowRelm1", World = "Main", Island = "Shadow Realm", Pos = Vector3.new(13.199999809265137, 7692.234375, -2106.300048828125)},
    {Id = "ShadowRelm2", World = "Main", Island = "Shadow Realm", Pos = Vector3.new(197.8000030517578, 7698.4345703125, -1858.5999755859375)},
    {Id = "RiftSpawn1", World = "TimeRift", Island = "World 2 Spawn", Pos = Vector3.new(82.6999969, 499.781921, 6963.5)},
    {Id = "RiftSpawn2", World = "TimeRift", Island = "World 2 Spawn", Pos = Vector3.new(-59.9000015, 502.181915, 7169.2002)},
    {Id = "RiftSpawn3", World = "TimeRift", Island = "World 2 Spawn", Pos = Vector3.new(206.100006, 502.181915, 7057.5)},
    {Id = "PrehistoricIsland1", World = "TimeRift", Island = "Prehistoric Island", Pos = Vector3.new(1037.59998, 891.481934, 7150.1001)},
    {Id = "PrehistoricIsland2", World = "TimeRift", Island = "Prehistoric Island", Pos = Vector3.new(1098.19995, 898.881958, 6932.5)},
    {Id = "IceAge1", World = "TimeRift", Island = "Ice Age", Pos = Vector3.new(1583, 1368.08191, 6791.1001)},
    {Id = "IceAge2", World = "TimeRift", Island = "Ice Age", Pos = Vector3.new(1543.19995, 1356.38196, 6966.5)},
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

function TravelToShinyStarWorld(world)
    if world == "TimeRift" then
        local success, result = pcall(function()
            return TimeRiftIslandTravel:InvokeServer({
                Source = "Menu",
                Island = "World 2 Spawn"
            })
        end)

        if not success then
            warn("[OTC Shiny Stars] World 2 travel failed:", result)
            return false
        end
    else
        local success, result = pcall(function()
            return TravelRemote:InvokeServer({
                Source = "Menu",
                Island = "Spawn"
            })
        end)

        if not success then
            warn("[OTC Shiny Stars] Main world travel failed:", result)
            return false
        end
    end

    local deadline = os.clock() + 12
    while os.clock() < deadline do
        if LocalPlayer:GetAttribute("World") == world then
            return true
        end
        task.wait(0.2)
    end

    return LocalPlayer:GetAttribute("World") == world
end

function CollectShinyStar(Star)
    if not OTC.Config.AutoCollectShinyStars or IsShinyStarFound(Star.Id) then
        return
    end

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if not Character or not Humanoid or Humanoid.Health <= 0 or not Root then
        return
    end

    if LocalPlayer:GetAttribute("World") ~= Star.World then
        return
    end

    if Star.Island ~= "Spawn" and Star.Island ~= "World 2 Spawn" then
        if Star.World == "Main" then
            local landing = IslandLandings[Star.Island]
            if landing and typeof(landing.Position) == "Vector3" then
                Root.CFrame = CFrame.new(landing.Position + Vector3.new(0, 5, 0))
                task.wait(0.25)
            end
        else
            local island = RiftIslandConfig.Islands[Star.Island]
            local landing = island and island.Landing
            if landing and typeof(landing.Position) == "Vector3" then
                Root.CFrame = CFrame.new(landing.Position + Vector3.new(0, 5, 0))
                task.wait(0.25)
            end
        end
    end

    Character = LocalPlayer.Character
    Root = Character and Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return
    end

    Character:PivotTo(CFrame.new(Star.Pos + Vector3.new(0, 2, 0)))
    task.wait(0.3)

    if not OTC.Config.AutoCollectShinyStars then
        return
    end

    Root = LocalPlayer.Character
        and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not Root or (Root.Position - Star.Pos).Magnitude > ShinyStarConfig.PickupRange then
        return
    end

    pcall(function()
        local Response = ShinyStarService:Collect(Star.Id)

        if type(Response) == "table" and Response.Success == true then
            OTC.Config.ShinyStarsLastCollected = Star.Id
        end
    end)
end

OTC.Runtime.ShinyStarWorkerRunning = false

function StartShinyStarCollection()
    if OTC.Runtime.ShinyStarWorkerRunning then
        return
    end

    OTC.Runtime.ShinyStarWorkerRunning = true

    task.spawn(function()
        while OTC.Config.AutoCollectShinyStars do
            local allFound = true

            for _, world in ipairs({"Main", "TimeRift"}) do
                if not OTC.Config.AutoCollectShinyStars then
                    break
                end

                local hasMissing = false

                for _, Star in ipairs(OTC.Runtime.ShinyStars) do
                    if Star.World == world and not IsShinyStarFound(Star.Id) then
                        hasMissing = true
                        allFound = false
                        break
                    end
                end

                if hasMissing and TravelToShinyStarWorld(world) then
                    for _, Star in ipairs(OTC.Runtime.ShinyStars) do
                        if not OTC.Config.AutoCollectShinyStars then
                            break
                        end

                        if Star.World == world and not IsShinyStarFound(Star.Id) then
                            pcall(CollectShinyStar, Star)
                            task.wait(OTC.Config.ShinyStarDelay)
                        end
                    end
                end
            end

            if allFound or not OTC.Config.AutoCollectShinyStars then
                break
            end

            task.wait(5)
        end

        OTC.Runtime.ShinyStarWorkerRunning = false
    end)
end

AutoTab:CreateToggle({
    Name = "Auto Collect Shiny Stars",
    Description = "Automatically collects Shiny Stars in Main World and World 2.",
    Flag = "AutoCollectShinyStars",
    CurrentValue = false,
    Callback = function(Value)
        OTC.Config.AutoCollectShinyStars = Value

        if Value then
            StartShinyStarCollection()
        end
    end,
})

OTC.Runtime.ClickerChestWorkerRunning = false
OTC.Runtime.CurrentClickerChest = nil

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

    OTC.Runtime.CurrentClickerChest = Model

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

    if OTC.Runtime.CurrentClickerChest == Model then
        OTC.Runtime.CurrentClickerChest = nil
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
    if OTC.Runtime.ClickerChestWorkerRunning then
        return
    end

    OTC.Runtime.ClickerChestWorkerRunning = true

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

        OTC.Runtime.CurrentClickerChest = nil
        OTC.Runtime.ClickerChestWorkerRunning = false
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

OTC.Runtime.IslandAttackToken = 0

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
        and OTC.Runtime.IslandAttackToken == token do

        local islands = GetIslandAttackOrder(spotsFolder)

        for _, island in ipairs(islands) do
            if not OTC.Config.AutoAttackIslandBreakables
                or OTC.Runtime.IslandAttackToken ~= token then
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
                        and OTC.Runtime.IslandAttackToken == token
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
                        and OTC.Runtime.IslandAttackToken == token
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
        OTC.Runtime.IslandAttackToken += 1

        if value then
            local token = OTC.Runtime.IslandAttackToken

            task.spawn(function()
                local ok, err = pcall(function()
                    runIslandAttack(token)
                end)

                if not ok then
                    warn("[OTC] Island attack error:", err)

                    if OTC.Runtime.IslandAttackToken == token then
                        OTC.Config.AutoAttackIslandBreakables = false
                    end
                end
            end)
        end
    end,
})

OTC.Runtime.AutoClaimChestsRunning = false

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

OTC.Runtime.ChestIslandMap = {
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

            local islandName = OTC.Runtime.ChestIslandMap[id]
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

    OTC.Runtime.AutoClaimChestsRunning = false
end

AutoTab:CreateToggle({
    Name = "Auto Claim Chests",
    Description = "Enable or disable auto claim chests.",
    Flag = "AutoClaimChests",
    CurrentValue = OTC.Config.AutoClaimChests,
    Callback = function(value)
        OTC.Config.AutoClaimChests = value

        if value and not OTC.Runtime.AutoClaimChestsRunning then
            OTC.Runtime.AutoClaimChestsRunning = true
            task.spawn(autoClaimChests)
        end
    end,
})

OTC.Runtime.AutoLuckyDucky = false

function StartAutoLuckyDucky()
    task.spawn(function()
        while OTC.Runtime.AutoLuckyDucky do
            local Success, Caught = pcall(function()
                return LuckyDuckyController:CatchShown()
            end)

            if Success and Caught then
                print("[OTC] Lucky Ducky caught!")
            end

            task.wait(0.05)
        end
    end)
end

AutoTab:CreateToggle({
    Name = "Auto Lucky Ducky",
    CurrentValue = false,
    Flag = "AutoLuckyDucky",
    Callback = function(Value)
        OTC.Runtime.AutoLuckyDucky = Value

        if Value then
            StartAutoLuckyDucky()
        end
    end
})

OTC.Runtime.AutoLuckyEggMachine = false
OTC.Runtime.LuckyEggMachineToken = 0

function TeleportToLuckyEggMachine()
    local Character = LocalPlayer.Character
    local Root = Character
        and Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return false
    end

    Root.CFrame = CFrame.new(
        -232.933167, 15409.0459, -2177.28125,
        -0.461075664, 0, 0.887360811,
        0, 1, 0,
        -0.887360811, 0, -0.461075664
    )

    return true
end

function GetLuckyEggStatus()
    local Replica = DataController:GetReplica()

    if not Replica or not Replica.Data then
        return false, "No data"
    end

    local Data = Replica.Data
    local Machines = Data.Machines or {}
    local LuckyEggData = Machines.LuckyEgg or {}

    local LastUsed = tonumber(LuckyEggData.Last) or 0
    local ReadyAt = LastUsed + LuckyEggMachineConfig.CooldownSeconds
    local Now = workspace:GetServerTimeNow()

    local ActiveBoosts = Data.ActiveBoosts or {}
    local BoostLeft = tonumber(
        ActiveBoosts[LuckyEggMachineConfig.Boost]
    ) or 0

    if BoostLeft > 0 then
        return false, "Boost already active"
    end

    if Now < ReadyAt then
        return false, "Cooldown"
    end

    return true, "Ready"
end

function ActivateLuckyEggMachine()
    local Ready, Reason = GetLuckyEggStatus()

    if not Ready then
        return false, Reason
    end

    if not TeleportToLuckyEggMachine() then
        return false, "Character not found"
    end

    task.wait(0.5)

    local Success, Result = pcall(function()
        return LuckyEggService:Activate()
    end)

    if not Success then
        warn("[OTC] Lucky Egg Machine error:", Result)
        return false, "Remote error"
    end

    if type(Result) == "table" and Result.Success == true then
        print("[OTC] Lucky Eggs activated!")
        return true, "Activated"
    end

    if type(Result) == "table" then
        warn("[OTC] Lucky Egg Machine:", Result.Reason)
        return false, Result.Reason or "Activation failed"
    end

    return false, "Invalid response"
end

function StartAutoLuckyEggMachine()
    OTC.Runtime.LuckyEggMachineToken += 1
    local Token = OTC.Runtime.LuckyEggMachineToken

    task.spawn(function()
        while OTC.Runtime.AutoLuckyEggMachine and Token == OTC.Runtime.LuckyEggMachineToken do
            local Ready = GetLuckyEggStatus()

            if Ready then
                ActivateLuckyEggMachine()
            end

            task.wait(5)
        end
    end)
end

AutoTab:CreateToggle({
    Name = "Auto Lucky Egg Machine",
    CurrentValue = false,
    Flag = "AutoLuckyEggMachine",
    Callback = function(Value)
        OTC.Runtime.AutoLuckyEggMachine = Value

        if Value then
            StartAutoLuckyEggMachine()
        else
            OTC.Runtime.LuckyEggMachineToken += 1
        end
    end
})

OTC.Runtime.IslandOptions = {"None", "World 2 Spawn"}
OTC.Runtime.IslandNames = {}

for name, config in pairs(ProgressionIslandConfig.Islands) do
    table.insert(OTC.Runtime.IslandNames, {
        Name = name,
        Order = config.Order or math.huge,
        World = "Main"
    })
end

for name, config in pairs(RiftIslandConfig.Islands) do
    table.insert(OTC.Runtime.IslandNames, {
        Name = name,
        Order = config.Order or math.huge,
        World = "TimeRift"
    })
end

table.sort(OTC.Runtime.IslandNames, function(a, b)
    if a.World ~= b.World then
        return a.World == "Main"
    end

    if a.Order == b.Order then
        return a.Name < b.Name
    end

    return a.Order < b.Order
end)

for _, island in ipairs(OTC.Runtime.IslandNames) do
    table.insert(OTC.Runtime.IslandOptions, island.Name)
end

WorldTab:CreateDropdown({
    name = "Islands",
    description = "Select an island to teleport to.",
    flag = "Islands",
    options = OTC.Runtime.IslandOptions,
    value = "None",
    callback = function(value)
        if value == "None" or not table.find(OTC.Runtime.IslandOptions, value) then
            return
        end

        task.spawn(function()
            local isRift = value == "World 2 Spawn" or RiftIslandConfig.Islands[value] ~= nil
            local remote = isRift and TimeRiftIslandTravel or TravelRemote

            local success, err = pcall(function()
                local replica = DataController:GetReplica()
                local data = replica and replica.Data
                local unlockedIslands = data
                    and data.Progression
                    and data.Progression.UnlockedIslands

                if value ~= "World 2 Spawn"
                    and (not unlockedIslands or unlockedIslands[value] ~= true) then
                    Rayfield:Notify({
                        Title = "Island Locked",
                        Content = "You haven't unlocked this island! Use Unlock Every Island to unlock it.",
                        Duration = 5,
                        icon = 116094782851554
                    })
                    return
                end

                local result = remote:InvokeServer({
                    Source = "Menu",
                    Island = value
                })

                if type(result) == "table" and result.Success == false then
                    warn("[OTC Islands] Travel rejected:", result.Reason)
                end
            end)

            if not success then
                warn("[OTC Islands] Teleport failed:", err)
            end
        end)
    end,
})

OTC.Runtime.UnlockEveryIslandEnabled = false
OTC.Runtime.UnlockEveryIslandRunning = false

function GetIslandUnlockTargets()
    local targets = {}

    for islandName, landing in pairs(IslandLandings) do
        if type(landing) == "table" and typeof(landing.Position) == "Vector3" then
            table.insert(targets, {
                Name = islandName,
                World = "Main",
                Position = landing.Position,
                Order = ProgressionIslandConfig.Islands[islandName]
                    and ProgressionIslandConfig.Islands[islandName].Order or math.huge
            })
        end
    end

    for islandName, config in pairs(RiftIslandConfig.Islands) do
        local landing = config.Landing
        if type(landing) == "table" and typeof(landing.Position) == "Vector3" then
            table.insert(targets, {
                Name = islandName,
                World = "TimeRift",
                Position = landing.Position,
                Order = config.Order or math.huge
            })
        end
    end

    table.sort(targets, function(a, b)
        if a.World ~= b.World then
            return a.World == "Main"
        end
        return a.Order < b.Order
    end)

    return targets
end

function TravelToUnlockWorld(world)
    if world == "TimeRift" then
        local success, result = pcall(function()
            return TimeRiftIslandTravel:InvokeServer({
                Source = "Menu",
                Island = "World 2 Spawn"
            })
        end)

        if not success then
            warn("[OTC Unlock Islands] World 2 travel failed:", result)
            return false
        end
    else
        local success, result = pcall(function()
            return TravelRemote:InvokeServer({
                Source = "Menu",
                Island = "Spawn"
            })
        end)

        if not success then
            warn("[OTC Unlock Islands] Main world travel failed:", result)
            return false
        end
    end

    local deadline = os.clock() + 12
    while OTC.Runtime.UnlockEveryIslandEnabled and os.clock() < deadline do
        if LocalPlayer:GetAttribute("World") == world then
            return true
        end
        task.wait(0.2)
    end

    return LocalPlayer:GetAttribute("World") == world
end

function unlockVisitIsland(target)
    if not OTC.Runtime.UnlockEveryIslandEnabled then
        return false
    end

    local character = LocalPlayer.Character
        or LocalPlayer.CharacterAdded:Wait()

    local root = character:WaitForChild("HumanoidRootPart", 5)

    if not root then
        return false
    end

    local event = target.World == "TimeRift"
        and TimeRiftIslandUnlockResult
        or ResultEvent

    local result
    local originalCollision = {}
    local resultConnection = event.OnClientEvent:Connect(function(data)
        if typeof(data) == "table"
            and data.Action == "WalkIn"
            and data.Island == target.Name then
            result = data
        end
    end)

    local targetPosition = target.Position + Vector3.new(0, 5, 0)
    local duration = math.clamp(
        (root.Position - targetPosition).Magnitude / 100,
        1,
        12
    )

    local noclipConnection
    local ok, state = pcall(function()
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                originalCollision[part] = part.CanCollide
                part.CanCollide = false
            end
        end

        noclipConnection = RunService.Stepped:Connect(function()
            if character.Parent then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)

        local tween = TweenService:Create(
            root,
            TweenInfo.new(duration, Enum.EasingStyle.Linear),
            { CFrame = CFrame.new(targetPosition) }
        )

        tween:Play()

        while OTC.Runtime.UnlockEveryIslandEnabled
            and tween.PlaybackState == Enum.PlaybackState.Playing do
            RunService.Heartbeat:Wait()
        end

        if not OTC.Runtime.UnlockEveryIslandEnabled then
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
    while OTC.Runtime.UnlockEveryIslandEnabled and os.clock() < deadline and result == nil do
        task.wait(0.1)
    end

    return result ~= nil
        and result.Success == true
        and result.Unlocked == true
end

WorldTab:CreateToggle({
    name = "Unlock Every Island",
    description = "Automatically unlocks islands in Main World and World 2.",
    value = false,
    flag = "UnlockEveryIsland",
    callback = function(value)
        OTC.Runtime.UnlockEveryIslandEnabled = value

        if not value or OTC.Runtime.UnlockEveryIslandRunning then
            return
        end

        OTC.Runtime.UnlockEveryIslandRunning = true

        task.spawn(function()
            local success, err = pcall(function()
                local targets = GetIslandUnlockTargets()
                local currentWorld = nil

                for _, target in ipairs(targets) do
                    if not OTC.Runtime.UnlockEveryIslandEnabled then
                        break
                    end

                    local replica = DataController:GetReplica()
                    local data = replica and replica.Data
                    local unlocked = data
                        and data.Progression
                        and data.Progression.UnlockedIslands

                    if not unlocked or unlocked[target.Name] ~= true then
                        if currentWorld ~= target.World then
                            if not TravelToUnlockWorld(target.World) then
                                break
                            end
                            currentWorld = target.World
                            task.wait(1)
                        end

                        unlockVisitIsland(target)
                        task.wait(1.5)
                    end
                end
            end)

            if not success then
                warn("[OTC Unlock Islands] Error:", err)
            end

            OTC.Runtime.UnlockEveryIslandEnabled = false
            OTC.Runtime.UnlockEveryIslandRunning = false
        end)
    end,
})

OTC.Runtime.PetOptions = {"None"}
OTC.Runtime.PetDropdown = nil
OTC.Runtime.SelectedPetName = ""
OTC.Runtime.IsRefreshingPets = false

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
    if OTC.Runtime.IsRefreshingPets then
        return
    end

    OTC.Runtime.IsRefreshingPets = true

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

        if OTC.Runtime.SelectedPetName ~= "" then
            for _, option in ipairs(newOptions) do
                if GetPetName(option) == OTC.Runtime.SelectedPetName then
                    updatedSelection = option
                    break
                end
            end
        end

        if updatedSelection == "None" then
            OTC.Runtime.SelectedPetName = ""
        end

        OTC.Runtime.PetOptions = newOptions
        OTC.Config.SelectedPet = updatedSelection

        if OTC.Runtime.PetDropdown then
            OTC.Runtime.PetDropdown:Refresh(newOptions)
            OTC.Runtime.PetDropdown:Set(updatedSelection)
        end
    end)

    OTC.Runtime.IsRefreshingPets = false

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

    local success, result = pcall(function()
        return TravelRemote:InvokeServer({
            Source = "Menu",
            Island = "Spawn"
        })
    end)

    if not success then
        warn("[OTC] Failed to travel to Spawn:", result)
        return false
    end

    task.wait(2)

    character = LocalPlayer.Character
    root = character
        and character:FindFirstChild("HumanoidRootPart")

    if not root then
        return false
    end

    root.CFrame = CFrame.new(
        1.07520771, -515.99353, -1908.58752,
        -1.1920929e-07, 0, 1.00000012,
        0, 1, 0,
        -1.00000012, 0, -1.1920929e-07
    )

    return true
end

PetsTab:CreateSection({
    name = "▶ Golden"
})

OTC.Runtime.PetDropdown = PetsTab:CreateDropdown({
    name = "Pets",
    description = "Live inventory with mutation counts and equipped status.",
    options = OTC.Runtime.PetOptions,
    value = "None",
    flag = "GoldenPetSelection",
    callback = function(value)
        if OTC.Runtime.IsRefreshingPets then
            return
        end

        if type(value) ~= "string" then
            return
        end

        if value == "None" or value == "No pets" then
            OTC.Runtime.SelectedPetName = ""
            OTC.Config.SelectedPet = "None"

            Window:Notify({
                icon = 116094782851554,
                Title = "Golden Pets",
                Content = "No pet selected.",
                Duration = 3,
            })

            return
        end

        OTC.Runtime.SelectedPetName = GetPetName(value)
        OTC.Config.SelectedPet = value

        Window:Notify({
                icon = 116094782851554,
            Title = "Pet Selected",
            Content = "Selected: " .. value,
            Duration = 5,
        })
    end,
})

RefreshPets()

OTC.Runtime.GoldenOptions = {}
OTC.Runtime.GoldenCounts = {}

for count, chance in ipairs(MachineConfig.Golden.Chances) do
    local option = string.format("%d (%.0f%%)", count, chance)

    table.insert(OTC.Runtime.GoldenOptions, option)
    OTC.Runtime.GoldenCounts[option] = count
end

PetsTab:CreateDropdown({
    name = "Golden Chance",
    description = "Select how many pets to use for each craft.",
    flag = "GoldenChance",
    options = OTC.Runtime.GoldenOptions,
    value = OTC.Runtime.GoldenOptions[1],
    callback = function(value)
        local count = OTC.Runtime.GoldenCounts[value]

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
                    local selectedName = OTC.Runtime.SelectedPetName

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

                    local normalPets = {}
                    local mutationGroups = {}

                    local requiredCount = OTC.Config.GoldenPetCount

                    if type(requiredCount) ~= "number"
                        or requiredCount < 1
                        or requiredCount > 6
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
                                    local mutation = pet.Mutation

                                    mutationGroups[mutation] =
                                        mutationGroups[mutation] or {}

                                    table.insert(
                                        mutationGroups[mutation],
                                        petId
                                    )
                                else
                                    table.insert(normalPets, petId)
                                end
                            end
                        end
                    end

                    local selectedPets = {}
                    local selectedMutation = nil
                    local bestMutationCount = 0

                    for mutation, petIds in pairs(mutationGroups) do
                        if #petIds >= 6
                            and #petIds > bestMutationCount then

                            selectedMutation = mutation
                            bestMutationCount = #petIds
                        end
                    end

                    if selectedMutation then
                        local mutationPets = mutationGroups[selectedMutation]

                        for i = 1, requiredCount do
                            table.insert(selectedPets, mutationPets[i])
                        end

                        print(
                            "[OTC] Golden mutation selected:",
                            selectedMutation,
                            "| Available:",
                            #mutationPets,
                            "| Selected:",
                            #selectedPets
                        )
                    else
                        for _, petId in ipairs(normalPets) do
                            table.insert(selectedPets, petId)

                            if #selectedPets >= requiredCount then
                                break
                            end
                        end

                        print(
                            "[OTC] Golden mutation protected.",
                            "| No mutation group has 6 pets.",
                            "| Normal pets selected:",
                            #selectedPets
                        )
                    end

                    if #selectedPets ~= requiredCount then
                        return
                    end

                    print(
                        "[OTC] Golden craft:",
                        selectedName,
                        "| Mutation:",
                        selectedMutation or "None",
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

OTC.Runtime.DiamondPetOptions = {"None"}
OTC.Runtime.DiamondPetDropdown = nil
OTC.Runtime.SelectedDiamondPetName = ""
OTC.Runtime.IsRefreshingDiamondPets = false

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
    if OTC.Runtime.IsRefreshingDiamondPets then
        return
    end

    OTC.Runtime.IsRefreshingDiamondPets = true

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

        if OTC.Runtime.SelectedDiamondPetName ~= "" then
            for _, option in ipairs(newOptions) do
                if GetDiamondPetName(option) == OTC.Runtime.SelectedDiamondPetName then
                    updatedSelection = option
                    break
                end
            end
        end

        if updatedSelection == "None" then
            OTC.Runtime.SelectedDiamondPetName = ""
        end

        OTC.Runtime.DiamondPetOptions = newOptions
        OTC.Config.SelectedDiamondPet = updatedSelection

        if OTC.Runtime.DiamondPetDropdown then
            OTC.Runtime.DiamondPetDropdown:Refresh(newOptions)
            OTC.Runtime.DiamondPetDropdown:Set(updatedSelection)
        end
    end)

    OTC.Runtime.IsRefreshingDiamondPets = false

    if not success then
        warn("[OTC Diamond] Pets refresh error:", err)
    end
end

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

PetsTab:CreateSection({
    name = "▶ Diamond"
})

OTC.Runtime.DiamondPetDropdown = PetsTab:CreateDropdown({
    name = "Golden Pets",
    description = "Live inventory with mutation counts and equipped status.",
    options = OTC.Runtime.DiamondPetOptions,
    value = "None",
    flag = "DiamondPetSelection",
    callback = function(value)
        if OTC.Runtime.IsRefreshingDiamondPets then
            return
        end

        if type(value) ~= "string" then
            return
        end

        if value == "None" or value == "No pets" then
            OTC.Runtime.SelectedDiamondPetName = ""
            OTC.Config.SelectedDiamondPet = "None"

            Window:Notify({
                icon = 116094782851554,
                Title = "Diamond Pets",
                Content = "No pet selected.",
                Duration = 3,
            })

            return
        end

        OTC.Runtime.SelectedDiamondPetName = GetDiamondPetName(value)
        OTC.Config.SelectedDiamondPet = value

        Window:Notify({
                icon = 116094782851554,
            Title = "Diamond Pet Selected",
            Content = "Selected: " .. value,
            Duration = 5,
        })
    end,
})

RefreshDiamondPets()

OTC.Runtime.DiamondOptions = {}
OTC.Runtime.DiamondCounts = {}

for count, chance in ipairs(MachineConfig.Diamond.Chances) do
    local option = string.format("%d (%.0f%%)", count, chance)

    table.insert(OTC.Runtime.DiamondOptions, option)
    OTC.Runtime.DiamondCounts[option] = count
end

PetsTab:CreateDropdown({
    name = "Diamond Chance",
    description = "Select how many Golden pets to use for each craft.",
    flag = "DiamondChance",
    options = OTC.Runtime.DiamondOptions,
    value = OTC.Runtime.DiamondOptions[1],
    callback = function(value)
        local count = OTC.Runtime.DiamondCounts[value]

        if count then
            OTC.Config.DiamondPetCount = count
        end
    end,
})

PetsTab:CreateToggle({
    name = "Auto Diamond Pets",
    description = "Crafts using normal pets or groups of 6 identical mutations.",
    flag = "AutoDiamondPets",
    value = OTC.Config.AutoDiamondPets or false,
    callback = function(value)
        OTC.Config.AutoDiamondPets = value

        if not value then
            return
        end

        if not TeleportToDiamondMachine() then
            warn("[OTC Diamond] Character unavailable.")
            OTC.Config.AutoDiamondPets = false
            return
        end

        task.spawn(function()
            task.wait(1)

            while OTC.Config.AutoDiamondPets do
                local success, err = pcall(function()
                    local selectedName = OTC.Runtime.SelectedDiamondPetName

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

                    local normalPets = {}
                    local mutationGroups = {}

                    local requiredCount = OTC.Config.DiamondPetCount

                    if type(requiredCount) ~= "number"
                        or requiredCount < 1
                        or requiredCount > 6
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
                                    local mutation = pet.Mutation

                                    mutationGroups[mutation] =
                                        mutationGroups[mutation] or {}

                                    table.insert(
                                        mutationGroups[mutation],
                                        petId
                                    )
                                else
                                    table.insert(normalPets, petId)
                                end
                            end
                        end
                    end

                    local selectedPets = {}
                    local selectedMutation = nil
                    local bestMutationCount = 0

                    for mutation, petIds in pairs(mutationGroups) do
                        if #petIds >= 6
                            and #petIds > bestMutationCount then

                            selectedMutation = mutation
                            bestMutationCount = #petIds
                        end
                    end

                    if selectedMutation then
                        local mutationPets = mutationGroups[selectedMutation]

                        for i = 1, requiredCount do
                            table.insert(selectedPets, mutationPets[i])
                        end

                        print(
                            "[OTC Diamond] Mutation selected:",
                            selectedMutation,
                            "| Available:",
                            #mutationPets,
                            "| Selected:",
                            #selectedPets
                        )
                    else
                        for _, petId in ipairs(normalPets) do
                            table.insert(selectedPets, petId)

                            if #selectedPets >= requiredCount then
                                break
                            end
                        end

                        print(
                            "[OTC Diamond] Mutation protected.",
                            "| No mutation group has 6 pets.",
                            "| Normal pets selected:",
                            #selectedPets
                        )
                    end

                    if #selectedPets ~= requiredCount then
                        return
                    end

                    print(
                        "[OTC Diamond] Craft:",
                        selectedName,
                        "| Mutation:",
                        selectedMutation or "None",
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

OTC.Runtime.RainbowPetOptions = {"None"}
OTC.Runtime.RainbowPetDropdown = nil
OTC.Runtime.SelectedRainbowPetName = ""
OTC.Runtime.IsRefreshingRainbowPets = false

function GetRainbowPetName(option)
    if type(option) ~= "string" then
        return ""
    end

    return option:match("^(.-)%s%[") or option
end

function RefreshRainbowPets()
    if OTC.Runtime.IsRefreshingRainbowPets then
        return
    end

    OTC.Runtime.IsRefreshingRainbowPets = true

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

        if OTC.Runtime.SelectedRainbowPetName ~= "" then
            for _, option in ipairs(newOptions) do
                if GetRainbowPetName(option) == OTC.Runtime.SelectedRainbowPetName then
                    updatedSelection = option
                    break
                end
            end
        end

        if updatedSelection == "None" then
            OTC.Runtime.SelectedRainbowPetName = ""
        end

        if #newOptions == 0 then
            table.insert(newOptions, "None")
        end

        OTC.Runtime.RainbowPetOptions = newOptions
        OTC.Config.SelectedRainbowPet = updatedSelection

        if OTC.Runtime.RainbowPetDropdown then
            OTC.Runtime.RainbowPetDropdown:Refresh(newOptions)
            OTC.Runtime.RainbowPetDropdown:Set(updatedSelection)
        end
    end)

    OTC.Runtime.IsRefreshingRainbowPets = false

    if not success then
        warn("[OTC Rainbow] Pets refresh error:", err)
    end
end

OTC.Runtime.RainbowPetDropdown = PetsTab:CreateDropdown({
    name = "Diamond Pets",
    description = "Select the Diamond pet to fuse into Rainbow.",
    options = OTC.Runtime.RainbowPetOptions,
    value = "None",
    flag = "RainbowPetSelection",
    callback = function(value)
        if OTC.Runtime.IsRefreshingRainbowPets then
            return
        end

        if value == "None" or value == "No pets" then
            OTC.Runtime.SelectedRainbowPetName = ""
            OTC.Config.SelectedRainbowPet = "None"
        else
            OTC.Runtime.SelectedRainbowPetName = GetRainbowPetName(value)
            OTC.Config.SelectedRainbowPet = value
        end
    end,
})

RefreshRainbowPets()

OTC.Runtime.RainbowCountOptions = {}
OTC.Runtime.RainbowCountValues = {}
OTC.Runtime.RainbowDurationLabels = {
    [2] = "5h",
    [3] = "2h30",
    [4] = "1h",
    [5] = "30s",
}

for count = MachineConfig.Shiny.MinPets, #MachineConfig.Shiny.Durations do
    local option = string.format(
        "%d (%s)",
        count,
        OTC.Runtime.RainbowDurationLabels[count]
    )

    table.insert(OTC.Runtime.RainbowCountOptions, option)
    OTC.Runtime.RainbowCountValues[option] = count
end

OTC.Runtime.SelectedRainbowCount = OTC.Runtime.RainbowCountOptions[1]

for option, count in pairs(OTC.Runtime.RainbowCountValues) do
    if count == OTC.Config.RainbowPetCount then
        OTC.Runtime.SelectedRainbowCount = option
        break
    end
end

PetsTab:CreateDropdown({
    name = "Rainbow Amount",
    description = "Select the number of Diamond pets and crafting duration.",
    flag = "RainbowAmount",
    options = OTC.Runtime.RainbowCountOptions,
    value = OTC.Runtime.SelectedRainbowCount,
    callback = function(value)
        local count = OTC.Runtime.RainbowCountValues[value]

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

                    local selectedName = OTC.Runtime.SelectedRainbowPetName
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

OTC.Runtime.RainbowClaimToken = 0

function AutoClaimRainbowLoop(token)
    local lastClaims = {}

    while OTC.Config.AutoClaimRainbowPets
        and token == OTC.Runtime.RainbowClaimToken
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
                    or token ~= OTC.Runtime.RainbowClaimToken
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
        OTC.Runtime.RainbowClaimToken += 1

        if value then
            local token = OTC.Runtime.RainbowClaimToken

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

OTC.Runtime.EnchantPetDropdown = nil
OTC.Runtime.EnchantPetOptions = {}
OTC.Runtime.EnchantPetIds = {}
OTC.Runtime.SelectedEnchantPetId = nil
OTC.Runtime.SelectedEnchantTypes = {}
OTC.Runtime.SelectedEnchantSlot = OTC.Config.SelectedEnchantSlot
OTC.Runtime.AutoEnchantToken = 0

OTC.Runtime.EnchantPosition = CFrame.new(
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

    for enchantName, enabled in pairs(OTC.Runtime.SelectedEnchantTypes) do
        if enabled and EnchantConfig.IsFilterable(enchantName) then
            table.insert(result, enchantName)
        end
    end

    table.sort(result)

    return result
end

function RefreshEnchantPets()
    table.clear(OTC.Runtime.EnchantPetOptions)
    table.clear(OTC.Runtime.EnchantPetIds)

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

            if OTC.Runtime.EnchantPetIds[label] then
                label ..= " [" .. tostring(petId) .. "]"
            end

            table.insert(OTC.Runtime.EnchantPetOptions, label)
            OTC.Runtime.EnchantPetIds[label] = petId
        end
    end

    table.sort(OTC.Runtime.EnchantPetOptions)

    if OTC.Runtime.EnchantPetDropdown then
        pcall(function()
            OTC.Runtime.EnchantPetDropdown:Refresh(OTC.Runtime.EnchantPetOptions)
        end)
    end
end

OTC.Runtime.EnchantTypeOptions = {}

for enchantName in pairs(EnchantConfig.Enchants) do
    if EnchantConfig.IsFilterable(enchantName) then
        table.insert(OTC.Runtime.EnchantTypeOptions, enchantName)
    end
end

table.sort(OTC.Runtime.EnchantTypeOptions)

PetsTab:CreateDropdown({
    name = "Enchant Type",
    description = "Select multiple enchants. Stops when a selected enchant is obtained.",
    options = OTC.Runtime.EnchantTypeOptions,
    value = {},
    multiSelect = true,
    flag = "SelectedEnchantTypes",
    callback = function(value)
        table.clear(OTC.Runtime.SelectedEnchantTypes)

        if type(value) == "table" then
            for _, enchantName in ipairs(value) do
                OTC.Runtime.SelectedEnchantTypes[enchantName] = true
            end
        elseif type(value) == "string" then
            OTC.Runtime.SelectedEnchantTypes[value] = true
        end

        OTC.Config.SelectedEnchantTypes = GetSelectedEnchantList()
    end
})

PetsTab:CreateDropdown({
    name = "Enchant Slot",
    description = "Choose which enchant slot to roll.",
    options = {"Slot 1", "Slot 2"},
    value = OTC.Runtime.SelectedEnchantSlot == 2 and "Slot 2" or "Slot 1",
    flag = "SelectedEnchantSlot",
    callback = function(value)
        if type(value) == "table" then
            value = value[1]
        end

        if value == "Slot 1" then
            OTC.Runtime.SelectedEnchantSlot = 1
        elseif value == "Slot 2" then
            OTC.Runtime.SelectedEnchantSlot = 2
        else
            return
        end

        OTC.Config.SelectedEnchantSlot = OTC.Runtime.SelectedEnchantSlot

        Window:Notify({
                icon = 116094782851554,
            Title = "Enchant Slot",
            Content = "Selected: " .. value,
            Duration = 3
        })
    end
})

OTC.Runtime.EnchantPetDropdown = PetsTab:CreateDropdown({
    name = "Select Pet",
    description = "Select the pet to enchant.",
    options = OTC.Runtime.EnchantPetOptions,
    value = "",
    multiSelect = false,
    flag = "SelectedEnchantPet",
    callback = function(value)
        if type(value) == "table" then
            value = value[1]
        end

        OTC.Runtime.SelectedEnchantPetId = OTC.Runtime.EnchantPetIds[value]
        OTC.Config.SelectedEnchantPet = OTC.Runtime.SelectedEnchantPetId or ""

        if OTC.Runtime.SelectedEnchantPetId then
            Window:Notify({
                icon = 116094782851554,
                Title = "Enchant",
                Content = "Selected: " .. tostring(value)
                    .. "\nPet ID: " .. tostring(OTC.Runtime.SelectedEnchantPetId),
                Duration = 5
            })
        else
            Window:Notify({
                icon = 116094782851554,
                Title = "Enchant",
                Content = "No pet selected.",
                Duration = 3
            })
        end
    end
})

RefreshEnchantPets()

function StartAutoEnchant()
    if not OTC.Runtime.SelectedEnchantPetId then
        Window:Notify({
                icon = 116094782851554,
            Title = "Auto Enchant",
            Content = "Select a pet first.",
            Duration = 3
        })
        return false
    end

    local desired = GetSelectedEnchantList()

    if #desired == 0 then
        Window:Notify({
                icon = 116094782851554,
            Title = "Auto Enchant",
            Content = "Select at least one enchant.",
            Duration = 3
        })
        return false
    end

    local _, pets = GetEnchantPetData()
    local pet = pets and pets.Owned[OTC.Runtime.SelectedEnchantPetId]

    if not pet then
        warn("[Auto Enchant] Pet not found:", OTC.Runtime.SelectedEnchantPetId)
        return false
    end

    local currentEnchant

    if OTC.Runtime.SelectedEnchantSlot == 1 then
        currentEnchant = pet.Enchant
    elseif OTC.Runtime.SelectedEnchantSlot == 2 then
        currentEnchant = pet.Enchant2
    else
        warn("[Auto Enchant] Invalid slot:", OTC.Runtime.SelectedEnchantSlot)
        return false
    end

    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        warn("[Auto Enchant] Character unavailable.")
        return false
    end

    root.CFrame = OTC.Runtime.EnchantPosition
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
            PetId = OTC.Runtime.SelectedEnchantPetId,
            Slot = OTC.Runtime.SelectedEnchantSlot,
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
                icon = 116094782851554,
            Title = "Auto Enchant",
            Content = "Failed to start: " .. tostring(reason),
            Duration = 4
        })

        return false
    end

    Window:Notify({
                icon = 116094782851554,
        Title = "Auto Enchant",
        Content = "Auto Enchant started on Slot " .. OTC.Runtime.SelectedEnchantSlot .. ".",
        Duration = 3
    })

    return true
end

function ClaimEnchantPet(token)
    while OTC.Config.AutoEnchant and token == OTC.Runtime.AutoEnchantToken do
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
                icon = 116094782851554,
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
        OTC.Runtime.AutoEnchantToken += 1

        local token = OTC.Runtime.AutoEnchantToken

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
                if token == OTC.Runtime.AutoEnchantToken then
                    OTC.Config.AutoEnchant = false
                end
                return
            end

            if token ~= OTC.Runtime.AutoEnchantToken or not OTC.Config.AutoEnchant then
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

OTC.Runtime.AutoEquipBestPets = false
OTC.Runtime.AutoEquipBestSession = 0

PetsTab:CreateToggle({
    name = "Auto Equip Best Pets",
    description = "Automatically equips your best pets based on Clicks.",
    flag = "AutoEquipBestPets",
    value = false,
    callback = function(value)
        OTC.Runtime.AutoEquipBestPets = value
        OTC.Runtime.AutoEquipBestSession += 1

        local session = OTC.Runtime.AutoEquipBestSession

        if not value then
            return
        end

        task.spawn(function()
            while OTC.Runtime.AutoEquipBestPets
                and OTC.Runtime.AutoEquipBestSession == session do

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

OTC.Runtime.EggOptions = {}
OTC.Runtime.EggNames = {}

OTC.Runtime.OriginalHatchPlay = HatchRenderer.Play
OTC.Runtime.OriginalSecretPlay = SecretHatchRenderer.Play
OTC.Runtime.OriginalSecretPlayReveal = SecretHatchRenderer.PlayReveal

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

    return OTC.Runtime.OriginalHatchPlay(self, ...)
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

    return OTC.Runtime.OriginalSecretPlay(self, ...)
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

    return OTC.Runtime.OriginalSecretPlayReveal(self, ...)
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
        table.insert(OTC.Runtime.EggNames, eggName)
    end
end

table.sort(OTC.Runtime.EggNames, function(a, b)
    return LaunchEggConfig[a].Price < LaunchEggConfig[b].Price
end)

for _, eggName in ipairs(OTC.Runtime.EggNames) do
    local price = LaunchEggConfig[eggName].Price

    table.insert(
        OTC.Runtime.EggOptions,
        string.format(
            "%s [%s Coins]",
            eggName,
            FormatEggPrice(price)
        )
    )
end

OTC.Runtime.EggOptionToName = {}

for _, option in ipairs(OTC.Runtime.EggOptions) do
    local eggName = option:match("^(.-) %[")

    if eggName then
        OTC.Runtime.EggOptionToName[option] = eggName
    end
end

OTC.Runtime.SelectedEggOption = nil

for option, eggName in pairs(OTC.Runtime.EggOptionToName) do
    if eggName == OTC.Config.SelectedEgg then
        OTC.Runtime.SelectedEggOption = option
        break
    end
end

EggsTab:CreateDropdown({
    name = "Eggs",
    description = "Select an egg to hatch.",
    flag = "Eggs",
    options = OTC.Runtime.EggOptions,
    value = OTC.Runtime.SelectedEggOption or OTC.Runtime.EggOptions[1],
    callback = function(value)
        local eggName = OTC.Runtime.EggOptionToName[value]

        if eggName then
            OTC.Config.SelectedEgg = eggName
        end
    end,
})

OTC.Runtime.AmountOptions = {
    "1 Egg",
    "3 Eggs",
    "8 Eggs",
}

OTC.Runtime.AmountValues = {
    ["1 Egg"] = 1,
    ["3 Eggs"] = 3,
    ["8 Eggs"] = 8,
}

OTC.Runtime.SelectedAmount = "1 Egg"

for option, amount in pairs(OTC.Runtime.AmountValues) do
    if amount == OTC.Config.HatchAmount then
        OTC.Runtime.SelectedAmount = option
        break
    end
end

EggsTab:CreateDropdown({
    name = "Amount",
    description = "Choose how many eggs to hatch per request.",
    flag = "Amount",
    options = OTC.Runtime.AmountOptions,
    value = OTC.Runtime.SelectedAmount,
    callback = function(value)
        local amount = OTC.Runtime.AmountValues[value]

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

    local isTimeRift = eggConfig.World == "TimeRift"
    local islandName = eggConfig.Island or (isTimeRift and "World 2 Spawn" or "Spawn")
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        warn("[OTC Eggs] Character unavailable.")
        return false
    end

    local travelRemote = isTimeRift and TimeRiftIslandTravel or TravelRemote
    local success, result = pcall(function()
        return travelRemote:InvokeServer({
            Source = "Menu",
            Island = islandName
        })
    end)

    if not success then
        warn("[OTC Eggs] Travel failed:", result)
        return false
    end

    local expectedWorld = isTimeRift and "TimeRift" or "Main"
    local deadline = os.clock() + 12

    while os.clock() < deadline do
        if LocalPlayer:GetAttribute("World") == expectedWorld then
            break
        end
        task.wait(0.2)
    end

    if LocalPlayer:GetAttribute("World") ~= expectedWorld then
        warn("[OTC Eggs] World did not change.")
        return false
    end

    task.wait(0.75)

    local eggsFolder = workspace:FindFirstChild("Eggs")
    local eggModel = eggsFolder and eggsFolder:FindFirstChild(eggName)

    if not eggModel or not eggModel:IsA("Model") then
        local worldFolder = isTimeRift and workspace:FindFirstChild("World2") or nil
        local worldEggs = worldFolder and worldFolder:FindFirstChild("Eggs")
        eggModel = worldEggs and worldEggs:FindFirstChild(eggName)
    end

    if not eggModel or not eggModel:IsA("Model") then
        warn("[OTC Eggs] Egg model not found:", eggName)
        return false
    end

    character = LocalPlayer.Character
    root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        return false
    end

    root.CFrame = eggModel:GetPivot() + Vector3.new(0, 10, 0)

    return true
end

OTC.Runtime.HatchSession = 0

EggsTab:CreateToggle({
    name = "Auto Hatch",
    description = "Teleport to the selected egg and hatch automatically.",
    flag = "AutoHatch",
    value = OTC.Config.AutoHatch,
    callback = function(value)
        OTC.Config.AutoHatch = value
        OTC.Runtime.HatchSession += 1

        local session = OTC.Runtime.HatchSession

        if not value then
            return
        end

        task.spawn(function()
            if not TeleportToEgg() then
                warn("[OTC Eggs] Egg model not found or character unavailable.")

                if OTC.Runtime.HatchSession == session then
                    OTC.Config.AutoHatch = false
                end

                return
            end

            task.wait(1)

            while OTC.Config.AutoHatch and OTC.Runtime.HatchSession == session do
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

OTC.Runtime.AutoDig = false
OTC.Runtime.AutoDigSession = 0

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

OTC.Runtime.lastRewardClose = 0

function HandleDigReward()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then
        return false
    end

    for _, object in ipairs(playerGui:GetDescendants()) do
        if object:IsA("TextLabel")
            and object.Visible
            and object.Text:find("Tap anywhere to close", 1, true) then

            if os.clock() - OTC.Runtime.lastRewardClose < 2 then
                return false
            end

            OTC.Runtime.lastRewardClose = os.clock()

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
        OTC.Runtime.AutoDig = value
        OTC.Runtime.AutoDigSession += 1

        local session = OTC.Runtime.AutoDigSession

        if not value then
            return
        end

        task.spawn(function()
            if not TeleportToDigZone() then
                if OTC.Runtime.AutoDigSession == session then
                    OTC.Runtime.AutoDig = false
                end
                return
            end

            local lastStartAttempt = 0
            local lastRoundSequence = nil

            while OTC.Runtime.AutoDig and OTC.Runtime.AutoDigSession == session do
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

                    while OTC.Runtime.AutoDig and OTC.Runtime.AutoDigSession == session do
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

OTC.Runtime.AutoPetDefense = false
OTC.Runtime.AutoPetDefenseSession = 0

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
        OTC.Runtime.AutoPetDefense = value
        OTC.Runtime.AutoPetDefenseSession += 1

        local session = OTC.Runtime.AutoPetDefenseSession

        if not value then
            return
        end

        task.spawn(function()
            local started = StartPetDefense()

            if not OTC.Runtime.AutoPetDefense or OTC.Runtime.AutoPetDefenseSession ~= session then
                return
            end

            if not started then
                return
            end

            while OTC.Runtime.AutoPetDefense and OTC.Runtime.AutoPetDefenseSession == session do
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

OTC.Runtime.MiningController = nil
OTC.Runtime.MiningService = nil
OTC.Runtime.MiningConfig = nil

OTC.Runtime.MiningLogHistory = {}
OTC.Runtime.MAX_MINING_LOGS = 8

OTC.Runtime.PortalTarget = Vector3.new(12.794289, 5448.823242, -1884.811035)
OTC.Runtime.OutsidePosition = Vector3.new(5.45, 5436.12, -1878.03)

OTC.Runtime.REFRESH_INTERVAL = 300
OTC.Runtime.RETURN_DELAY = 3

OTC.Runtime.MineRefreshInProgress = false
OTC.Runtime.MineRefreshBusy = false
OTC.Runtime.AutoMineBusy = false
OTC.Runtime.MiningIndex = 1

local MiningLog = MinigamesTab:CreateText({
    name = "Mining Logs",
    text = "AutoMine ready."
})

function UpdateMiningLog(Message)
    table.insert(
        OTC.Runtime.MiningLogHistory,
        1,
        "[" .. os.date("%H:%M:%S") .. "] " .. tostring(Message)
    )

    while #OTC.Runtime.MiningLogHistory > OTC.Runtime.MAX_MINING_LOGS do
        table.remove(OTC.Runtime.MiningLogHistory)
    end

    pcall(function()
        MiningLog:Set(table.concat(OTC.Runtime.MiningLogHistory, "\n"))
    end)
end

function GetMiningController()
    if OTC.Runtime.MiningController then
        return OTC.Runtime.MiningController
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
        OTC.Runtime.MiningController = Result
        return Result
    end

    UpdateMiningLog("Controller error: " .. tostring(Result))
    return nil
end

function GetMiningService()
    if OTC.Runtime.MiningService then
        return OTC.Runtime.MiningService
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
        OTC.Runtime.MiningService = Result
        return Result
    end

    UpdateMiningLog("Service error: " .. tostring(Result))
    return nil
end

function GetMiningConfig()
    if OTC.Runtime.MiningConfig then
        return OTC.Runtime.MiningConfig
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
        OTC.Runtime.MiningConfig = Result
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
    if OTC.Runtime.MineRefreshInProgress then
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

    if OTC.Runtime.MineRefreshInProgress then
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
    if OTC.Runtime.MineRefreshInProgress then
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

    if OTC.Runtime.MineRefreshInProgress then
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

    if OTC.Runtime.MineRefreshInProgress then
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
            and not OTC.Runtime.AutoMineBusy
            and not OTC.Runtime.MineRefreshInProgress then

            OTC.Runtime.AutoMineBusy = true

            local Success, ErrorMessage = pcall(function()
                if OTC.Runtime.MineRefreshInProgress then
                    return
                end

                local State = GetMiningState()

                if not State then
                    UpdateMiningLog("Mining state unavailable")
                    return
                end

                local Candidates = GetMiningCandidates()

                if #Candidates == 0 then
                    OTC.Runtime.MiningIndex = 1
                    return
                end

                if OTC.Runtime.MiningIndex > #Candidates then
                    OTC.Runtime.MiningIndex = 1
                end

                local Cell = Candidates[OTC.Runtime.MiningIndex]
                OTC.Runtime.MiningIndex += 1

                if not OTC.Runtime.MineRefreshInProgress then
                    HitMiningCell(State, Cell)
                end
            end)

            if not Success then
                UpdateMiningLog("AutoMine error: " .. tostring(ErrorMessage))
            end

            OTC.Runtime.AutoMineBusy = false

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
            and not OTC.Runtime.MineRefreshBusy
            and not OTC.Runtime.MineRefreshInProgress
            and os.clock() - (OTC.Config.LastMineRefresh or os.clock()) >= OTC.Runtime.REFRESH_INTERVAL then

            OTC.Runtime.MineRefreshBusy = true
            OTC.Runtime.MineRefreshInProgress = true

            local Success, ErrorMessage = pcall(function()
                UpdateMiningLog("Mine refresh started")

                while OTC.Runtime.AutoMineBusy do
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

                Character:PivotTo(CFrame.new(OTC.Runtime.OutsidePosition))
                UpdateMiningLog("Outside mine; waiting 3 seconds")

                task.wait(OTC.Runtime.RETURN_DELAY)

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

                Character:PivotTo(CFrame.new(OTC.Runtime.PortalTarget))
                OTC.Config.LastMineRefresh = os.clock()
                OTC.Runtime.MiningIndex = 1

                UpdateMiningLog("Returned to mine")
            end)

            if not Success then
                UpdateMiningLog("Refresh error: " .. tostring(ErrorMessage))
            end

            OTC.Runtime.MineRefreshInProgress = false
            OTC.Runtime.MineRefreshBusy = false
        end
    end
end)

function AutoSellSection()
    local CurrentCapacity = 2500
local SliderObject
OTC.Runtime.AutoSellTriggered = false
OTC.Runtime.AutoSellBusy = false

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
            OTC.Runtime.AutoSellTriggered = false
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
            OTC.Runtime.AutoSellTriggered = false
            OTC.Runtime.AutoSellBusy = false
        end
    end
})

task.spawn(function()
    while true do
        task.wait(0.25)

        if not OTC.Config.AutoSell then
            OTC.Runtime.AutoSellTriggered = false
            OTC.Runtime.AutoSellBusy = false
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
            OTC.Runtime.AutoSellTriggered = false
            continue
        end

        if OTC.Runtime.AutoSellTriggered or OTC.Runtime.AutoSellBusy then
            continue
        end

        OTC.Runtime.AutoSellTriggered = true
        OTC.Runtime.AutoSellBusy = true

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

                OTC.Runtime.AutoSellTriggered = false

                if not Sold then
                    task.wait(1)
                end
            end)

            if not Success then
                warn("[OTC AutoSell]", ErrorMessage)
                OTC.Runtime.AutoSellTriggered = false
            end

            OTC.Runtime.AutoSellBusy = false
        end)
    end
end)
end
AutoSellSection()

OTC.Runtime.AutoUpgradePickaxe = false
OTC.Runtime.AutoUpgradeBackpack = false
OTC.Runtime.UpgradeDelay = 0.1

OTC.Runtime.UpgradeBusy = {
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
    if OTC.Runtime.UpgradeBusy[Category] then return end
    OTC.Runtime.UpgradeBusy[Category] = true

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

        while (IsTool and OTC.Runtime.AutoUpgradePickaxe)
            or (not IsTool and OTC.Runtime.AutoUpgradeBackpack) do

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
                if not ((IsTool and OTC.Runtime.AutoUpgradePickaxe)
                    or (not IsTool and OTC.Runtime.AutoUpgradeBackpack)) then
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
                    task.wait(OTC.Runtime.UpgradeDelay)

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

                            task.wait(OTC.Runtime.UpgradeDelay)

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

    OTC.Runtime.UpgradeBusy[Category] = false
end

MinigamesTab:CreateToggle({
    name = "Auto Upgrade Pickaxe",
    description = "Teleport to Upgrade Stand and buy/equip pickaxes",
    flag = "AutoUpgradePickaxe",
    callback = function(Value)
        OTC.Runtime.AutoUpgradePickaxe = Value

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
        OTC.Runtime.AutoUpgradeBackpack = Value

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

OTC.Runtime.FishingFolder = nil
OTC.Runtime.HeavenFalls = nil
OTC.Runtime.Fisherman = nil
OTC.Runtime.Pond = nil

OTC.Runtime.Spot = FishingConfig.Spots.HeavenFalls
OTC.Runtime.MIN_ZONE_LUCK = 2.5

OTC.Runtime.TravelingToHeaven = false
OTC.Runtime.WorldReady = false

OTC.Runtime.FishingState = {
    AutoBait = false,
    AutoFish = false,
    AutoCollectBowl = false,
    RemoveEmptyRods = false,
    AutoBuyBait = false,
    SelectedBait = "Worm",
    SelectedShopOffer = nil,
    FishingDelay = 2,
    BuyDelay = 5,
    CollectDelay = 5,
    RemoveDelay = 5,
    Busy = false,
    Buying = false
}

function FishingNotify(Title, Content, Duration)
    Window:Notify({
        Title = Title,
        Content = Content,
        Icon = 116094782851554,
        Duration = Duration or 3
    })
end

function GetFishingData()
    local Replica
    local Success = pcall(function()
        Replica = DataController:GetReplica()
    end)

    if not Success or not Replica or type(Replica.Data) ~= "table" then
        return nil
    end

    return Replica.Data.Fishing
end

function GetFishingCharacter()
    return LocalPlayer.Character
end

function TeleportToFishingModel(Model, Offset)
    if not Model or not Model:IsA("Model") then
        return false
    end

    local Character = GetFishingCharacter()

    if not Character then
        return false
    end

    local RootPart = Model:FindFirstChild("RootPart")

    if RootPart and RootPart:IsA("BasePart") then
        Character:PivotTo(RootPart.CFrame * (Offset or CFrame.new(0, 3, 0)))
    else
        Character:PivotTo(Model:GetPivot() * (Offset or CFrame.new(0, 3, 0)))
    end

    return true
end

function GetHeavenObjects()
    OTC.Runtime.FishingFolder = Workspace:FindFirstChild("Fishing")

    if not OTC.Runtime.FishingFolder then
        OTC.Runtime.WorldReady = false
        return false
    end

    OTC.Runtime.HeavenFalls = OTC.Runtime.FishingFolder:FindFirstChild("HeavenFalls")

    if not OTC.Runtime.HeavenFalls then
        OTC.Runtime.WorldReady = false
        return false
    end

    OTC.Runtime.Fisherman = OTC.Runtime.FishingFolder:FindFirstChild("Fisherman_HeavenFalls")
    OTC.Runtime.Pond = OTC.Runtime.HeavenFalls:FindFirstChild("Pond")
    OTC.Runtime.WorldReady = OTC.Runtime.Fisherman ~= nil and OTC.Runtime.Pond ~= nil

    return OTC.Runtime.WorldReady
end

function EnsureHeaven()
    if GetHeavenObjects() then
        return true
    end

    if OTC.Runtime.TravelingToHeaven then
        return false
    end

    OTC.Runtime.TravelingToHeaven = true

    local Success, Result = pcall(function()
        return TravelRemote:InvokeServer({
            Source = "Menu",
            Island = "Heaven"
        })
    end)

    if not Success then
        warn("[OTC Fishing] Travel error:", Result)
        OTC.Runtime.TravelingToHeaven = false
        return false
    end

    if type(Result) == "table" and Result.Success == false then
        warn("[OTC Fishing] Travel rejected:", Result)
        OTC.Runtime.TravelingToHeaven = false
        return false
    end

    local StartTime = os.clock()

    repeat
        task.wait(0.5)
    until GetHeavenObjects() or os.clock() - StartTime >= 30

    OTC.Runtime.TravelingToHeaven = false

    return GetHeavenObjects()
end

function GetAvailableRodStand()
    if not GetHeavenObjects() then
        return nil
    end

    for Index = 1, 3 do
        local Stand = OTC.Runtime.HeavenFalls:FindFirstChild("RodStand" .. Index)

        if Stand and Stand:IsA("Model") then
            local InteractText = Stand:GetAttribute("InteractText")

            if InteractText == "Cast" or InteractText == "Reel In!" then
                return Stand
            end
        end
    end

    return nil
end

function InteractWithAvailableStand()
    if not EnsureHeaven() then
        return false
    end

    local Stand = GetAvailableRodStand()

    if not Stand then
        return false
    end

    if not TeleportToFishingModel(Stand, CFrame.new(0, 3, 0)) then
        return false
    end

    task.wait(0.25)

    local Success, Error = pcall(function()
        FishingController:InteractRod(Stand)
    end)

    if not Success then
        warn("[OTC Fishing] Interact error:", Error)
        return false
    end

    return true
end

function GetPondData()
    if not GetHeavenObjects() then
        return nil
    end

    return {
        X = OTC.Runtime.Pond.Position.X,
        Z = OTC.Runtime.Pond.Position.Z,
        RadiusX = OTC.Runtime.Pond.Size.X / 2,
        RadiusZ = OTC.Runtime.Pond.Size.Z / 2
    }
end

function GetActiveEligibleZones()
    if not GetHeavenObjects() then
        return {}
    end

    local Result = {}
    local Now = Workspace:GetServerTimeNow()
    local PondData = GetPondData()

    if not PondData then
        return Result
    end

    for Index, ZoneName in ipairs(OTC.Runtime.Spot.Zones or {}) do
        local Config = FishingConfig.Zones[ZoneName]

        if not Config or Config.Luck < OTC.Runtime.MIN_ZONE_LUCK then
            continue
        end

        local Shown = FishingSim.ZoneShown(OTC.Runtime.Spot, Index, Now)

        if Shown <= 0 then
            continue
        end

        local X, Z = FishingSim.ZonePosition(OTC.Runtime.Spot, Index, PondData, Now)

        table.insert(Result, {
            Name = ZoneName,
            Luck = Config.Luck,
            Index = Index,
            X = X,
            Z = Z,
            Shown = Shown
        })
    end

    table.sort(Result, function(A, B)
        return A.Luck > B.Luck
    end)

    return Result
end

function GetBestEligibleZone()
    local Zones = GetActiveEligibleZones()
    return Zones[1], Zones
end

function HasEligibleZone()
    local BestZone = GetBestEligibleZone()
    return BestZone ~= nil, BestZone
end

function UpdateFishingAttributes()
    local HasZone = false

    if OTC.Runtime.FishingState.AutoBait and GetHeavenObjects() then
        HasZone = HasEligibleZone()
    end

    Workspace:SetAttribute(
        "TS2FishingAutoBait",
        OTC.Runtime.FishingState.AutoBait and OTC.Runtime.FishingState.SelectedBait or nil
    )

    Workspace:SetAttribute(
        "TS2FishingAutoCast",
        OTC.Runtime.FishingState.AutoBait and HasZone
    )

    Workspace:SetAttribute(
        "TS2FishingAutoTap",
        OTC.Runtime.FishingState.AutoFish
    )
end

function GetBaitOptions()
    local Options = {}

    for _, BaitId in ipairs(FishingConfig.BaitOrder) do
        local Bait = FishingConfig.Baits[BaitId]

        if Bait then
            table.insert(Options, Bait.Name)
        end
    end

    return Options
end

function GetBaitIdFromName(Name)
    for BaitId, Bait in pairs(FishingConfig.Baits) do
        if Bait.Name == Name then
            return BaitId
        end
    end

    return nil
end

function GetEnabledCurrencies()
    local Enabled = {}

    local Success, Result = pcall(function()
        return EventCurrencyConfig.Enabled()
    end)

    if Success and type(Result) == "table" then
        for Key, Value in pairs(Result) do
            if type(Key) == "string" and Value then
                Enabled[Key] = true
            elseif type(Value) == "string" then
                Enabled[Value] = true
            end
        end
    end

    return Enabled
end

function GetShopOffers()
    local FishingData = GetFishingData()

    if not FishingData then
        return {}
    end

    local WindowId = FishingSim.ShopWindow(os.time())
    local Offers = FishingSim.ShopOffers(WindowId, GetEnabledCurrencies())
    local Result = {}

    for _, Offer in ipairs(Offers) do
        local Left = FishingSim.ShopLeft(FishingData.Shop, WindowId, Offer)

        if Left > 0 then
            local Bait = FishingConfig.Baits[Offer.Bait]

            table.insert(Result, {
                Id = Offer.Id,
                Bait = Offer.Bait,
                Name = Bait and Bait.Name or Offer.Bait,
                Amount = Offer.Amount,
                Left = Left
            })
        end
    end

    return Result
end

function GetShopOfferNames()
    local Names = {}

    for _, Offer in ipairs(GetShopOffers()) do
        table.insert(Names, string.format(
            "%s x%d [%s] (%d left)",
            Offer.Name,
            Offer.Amount,
            Offer.Id,
            Offer.Left
        ))
    end

    return Names
end

function GetOfferIdFromName(Name)
    if type(Name) ~= "string" then
        return nil
    end

    return Name:match("%[(.-)%]")
end

function GetOfferById(Id)
    for _, Offer in ipairs(GetShopOffers()) do
        if Offer.Id == Id then
            return Offer
        end
    end

    return nil
end

function BuySelectedBait()
    if OTC.Runtime.FishingState.Buying or not OTC.Runtime.FishingState.SelectedShopOffer then
        return
    end

    local Offer = GetOfferById(OTC.Runtime.FishingState.SelectedShopOffer)

    if not Offer or Offer.Left <= 0 then
        return
    end

    OTC.Runtime.FishingState.Buying = true

    local Success, Error = pcall(function()
        if not EnsureHeaven() then
            error("Could not load HeavenFalls")
        end

        local Teleported = TeleportToFishingModel(
            OTC.Runtime.Fisherman,
            CFrame.new(0, 3, -6)
        )

        if not Teleported then
            error("Could not teleport to Fisherman")
        end

        task.wait(0.5)

        local Result = FishingService:Buy(Offer.Id)

        if type(Result) == "table" and Result.Success then
            FishingNotify("Auto Buy Bait", "Purchased " .. Offer.Id)
        end
    end)

    if not Success then
        warn("[OTC Fishing] Auto Buy error:", Error)
    end

    task.wait(OTC.Runtime.FishingState.BuyDelay)
    OTC.Runtime.FishingState.Buying = false
end

function GetEmptyRods()
    local FishingData = GetFishingData()

    if not FishingData or type(FishingData.Rods) ~= "table" then
        return {}
    end

    local Empty = {}

    for RodId, Rod in pairs(FishingData.Rods) do
        if type(Rod) == "table" then
            local Hooked = Rod.Hooked

            if (type(Hooked) ~= "table" or #Hooked == 0)
                and type(Rod.Left) == "number"
                and Rod.Left <= 0
            then
                table.insert(Empty, RodId)
            end
        end
    end

    return Empty
end

function RemoveEmptyFishingRods()
    for _, RodId in ipairs(GetEmptyRods()) do
        local Success, Error = pcall(function()
            FishingService:Remove(RodId)
        end)

        if not Success then
            warn("[OTC Fishing] Remove error:", Error)
        end

        task.wait(0.5)
    end
end

function CollectFishingBowl()
    local Success, Error = pcall(function()
        FishingController:CollectBowl()
    end)

    if not Success then
        warn("[OTC Fishing] Collect error:", Error)
    end
end

function StartAutoBait()
    task.spawn(function()
        while OTC.Runtime.FishingState.AutoBait do
            if not OTC.Runtime.FishingState.Busy then
                OTC.Runtime.FishingState.Busy = true

                if EnsureHeaven() then
                    local BestZone = GetBestEligibleZone()

                    if BestZone then
                        Workspace:SetAttribute("TS2FishingAutoBait", OTC.Runtime.FishingState.SelectedBait)
                        Workspace:SetAttribute("TS2FishingAutoCast", true)

                        print(
                            "[OTC Fishing] Best eligible zone:",
                            BestZone.Name,
                            BestZone.Luck .. "x"
                        )

                        InteractWithAvailableStand()
                    else
                        Workspace:SetAttribute("TS2FishingAutoCast", false)
                        print("[OTC Fishing] Waiting for Golden or Rare...")
                    end
                end

                OTC.Runtime.FishingState.Busy = false
            end

            task.wait(OTC.Runtime.FishingState.FishingDelay)
        end
    end)
end

function StartAutoFish()
    task.spawn(function()
        while OTC.Runtime.FishingState.AutoFish do
            if not OTC.Runtime.FishingState.Busy then
                OTC.Runtime.FishingState.Busy = true

                if EnsureHeaven() then
                    UpdateFishingAttributes()
                    InteractWithAvailableStand()
                end

                OTC.Runtime.FishingState.Busy = false
            end

            task.wait(OTC.Runtime.FishingState.FishingDelay)
        end
    end)
end

function StartAutoCollect()
    task.spawn(function()
        while OTC.Runtime.FishingState.AutoCollectBowl do
            if EnsureHeaven() then
                CollectFishingBowl()
            end

            task.wait(OTC.Runtime.FishingState.CollectDelay)
        end
    end)
end

function StartRemoveEmptyRods()
    task.spawn(function()
        while OTC.Runtime.FishingState.RemoveEmptyRods do
            if EnsureHeaven() then
                RemoveEmptyFishingRods()
            end

            task.wait(OTC.Runtime.FishingState.RemoveDelay)
        end
    end)
end

function StartAutoBuy()
    task.spawn(function()
        while OTC.Runtime.FishingState.AutoBuyBait do
            BuySelectedBait()
            task.wait(OTC.Runtime.FishingState.BuyDelay)
        end
    end)
end

FishingTab:CreateSection({
    name = "Automation"
})

FishingTab:CreateDropdown({
    name = "Selected Bait",
    options = GetBaitOptions(),
    value = "Worm",
    flag = "FishingSelectedBait",
    callback = function(Option)
        local Selected = Option

        if type(Option) == "table" then
            Selected = Option[1]
        end

        local BaitId = GetBaitIdFromName(Selected)

        if BaitId then
            OTC.Runtime.FishingState.SelectedBait = BaitId
            UpdateFishingAttributes()
        end
    end
})

FishingTab:CreateToggle({
    name = "Auto Bait",
    value = false,
    flag = "FishingAutoBait",
    callback = function(Value)
        OTC.Runtime.FishingState.AutoBait = Value
        UpdateFishingAttributes()

        if Value then
            StartAutoBait()
        end
    end
})

FishingTab:CreateToggle({
    name = "Auto Fish",
    value = false,
    flag = "FishingAutoFish",
    callback = function(Value)
        OTC.Runtime.FishingState.AutoFish = Value
        UpdateFishingAttributes()

        if Value then
            StartAutoFish()
        end
    end
})

FishingTab:CreateToggle({
    name = "Auto Collect Bowl",
    value = false,
    flag = "FishingAutoCollect",
    callback = function(Value)
        OTC.Runtime.FishingState.AutoCollectBowl = Value

        if Value then
            StartAutoCollect()
        end
    end
})

FishingTab:CreateToggle({
    name = "Remove Empty Rods",
    value = false,
    flag = "FishingRemoveEmptyRods",
    callback = function(Value)
        OTC.Runtime.FishingState.RemoveEmptyRods = Value

        if Value then
            StartRemoveEmptyRods()
        end
    end
})

FishingTab:CreateSection({
    name = "Bait Shop"
})

FishingTab:CreateDropdown({
    name = "Shop Offer",
    options = GetShopOfferNames(),
    value = nil,
    flag = "FishingShopOffer",
    callback = function(Option)
        local Selected = Option

        if type(Option) == "table" then
            Selected = Option[1]
        end

        OTC.Runtime.FishingState.SelectedShopOffer = GetOfferIdFromName(Selected)
    end
})

FishingTab:CreateToggle({
    name = "Auto Buy Bait",
    value = false,
    flag = "FishingAutoBuyBait",
    callback = function(Value)
        OTC.Runtime.FishingState.AutoBuyBait = Value

        if Value then
            StartAutoBuy()
            FishingNotify(
                "Auto Buy Bait",
                "Traveling to Heaven and Fisherman before purchase.",
                4
            )
        end
    end
})

UpdateFishingAttributes()

OTC.Runtime.WebhookURL = ""
OTC.Runtime.AvatarURL = "https://cdn.discordapp.com/avatars/1416562431882432666/ca20c1ec7d67590754fca8f0b109f9d0.webp?animated=false&size=2048"

OTC.Runtime.MinimumOneIn = 1000
OTC.Runtime.DiscordUserID = ""

OTC.Runtime.SendWebhookEnabled = true
OTC.Runtime.SendWebhookWithMentionEnabled = true

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

    return oneIn ~= nil and oneIn >= OTC.Runtime.MinimumOneIn
end

OTC.Runtime.RarityColors = {
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

    if OTC.Runtime.RarityColors[rarity] then
        return OTC.Runtime.RarityColors[rarity]
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
    if not OTC.Runtime.SendWebhookEnabled then
        return false
    end

    if type(OTC.Runtime.WebhookURL) ~= "string"
        or OTC.Runtime.WebhookURL == "" then
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
        avatar_url = OTC.Runtime.AvatarURL,
        embeds = {embed}
    }

    if content
        and OTC.Runtime.SendWebhookWithMentionEnabled
        and OTC.Runtime.DiscordUserID ~= "" then
        payload.content = content
        payload.allowed_mentions = {
            parse = {},
            users = {OTC.Runtime.DiscordUserID}
        }
    end

    local success, response = pcall(function()
        return httpRequest({
            Url = OTC.Runtime.WebhookURL,
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
    if not OTC.Runtime.SendWebhookWithMentionEnabled then
        return nil
    end

    if OTC.Runtime.DiscordUserID == "" then
        return nil
    end

    if type(rarity) == "string"
        and rarity:sub(1, 6) == "Secret" then
        return "<@" .. OTC.Runtime.DiscordUserID .. ">"
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
            icon_url = OTC.Runtime.AvatarURL
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

            local prefixes = {}

            if mutation ~= "None" and mutation ~= "" then
                table.insert(prefixes, mutation)
            end

            if tier ~= "Normal" and tier ~= "" then
                table.insert(prefixes, tier)
            end

            local displayPetName = petName

            if #prefixes > 0 then
                displayPetName = table.concat(prefixes, " ")
                    .. " " .. petName
            end

            local descriptionParts = {
                "🎉・**Hatch Info**",
                "- 🥚 **Egg:** `" .. safeString(result.Egg, "Unknown Egg") .. "`",
                "- 🏆 **Chance:** `" .. chance .. "`",
                "- 🎁 **Rarity:** `" .. rarity .. "`",
                "- 🔢 **Tier:** `" .. tier .. "`",
                "- 💪 **Power:** `" .. abbreviateNumber(PetPower.Get(pet)) .. "`"
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
                    .. " hatched a " .. displayPetName .. "! 🎉 Congrats!"
            else
                title = censoredName
                    .. " hatched a " .. displayPetName
            end

            local embed = {
                author = {
                    name = "OTC",
                    icon_url = OTC.Runtime.AvatarURL
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
        OTC.Runtime.WebhookURL = Value
    end
})

WebhookTab:CreateInput({
    Name = "Discord User Id",
    PlaceholderText = "Discord User ID",
    CurrentValue = "",
    RemoveTextAfterFocusLost = false,
    Flag = "DiscordUserID",
    Callback = function(Value)
        OTC.Runtime.DiscordUserID = Value
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
            OTC.Runtime.MinimumOneIn = math.floor(number)
        end
    end
})

WebhookTab:CreateToggle({
    Name = "Send Webhook with Mention",
    CurrentValue = true,
    Flag = "SendWebhookWithMention",
    Callback = function(Value)
        OTC.Runtime.SendWebhookWithMentionEnabled = Value
    end
})

WebhookTab:CreateToggle({
    Name = "Send Webhook",
    CurrentValue = true,
    Flag = "SendWebhook",
    Callback = function(Value)
        OTC.Runtime.SendWebhookEnabled = Value
    end
})

startOfflineHatchWatcher()
startNormalHatchWatcher()

task.spawn(function()
    task.wait(2)
    ensureConfigFolder()
    if isfile(OTC.Runtime.ConfigPath) then
        local loaded = loadConfig(OTC.Runtime.ConfigFile)

        if loaded then
            print("[OTC] Startup configuration loaded successfully.")
        else
            warn("[OTC] Startup configuration could not be loaded.")
        end
    else
        print("[OTC] No saved configuration found. Using default settings.")
    end
end)

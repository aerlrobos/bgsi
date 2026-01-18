local WEBHOOK_URL = "https://discord.com/api/webhooks/1447658603149393950/AH90w2ScZmpQbO0LzAosT1AgXd1LlglNUqMppjAkNMNBTVimk3HrcUSXEaOk4FCrAtCT"

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local GlobalEvent = require(ReplicatedStorage.Shared.GlobalEvent)
local Time = require(ReplicatedStorage.Shared.Framework.Utilities.Math.Time)

local G = getgenv()
G.EventScanner = G.EventScanner or {
    sentEvents = {},
    cooldownUntil = 0
}

local sentEvents = G.EventScanner.sentEvents

local EVENTS = {
    XL = {
        color = 0xfc1576,
        title = "<:xl:1462382551846092874> **XL Pets Event Started!** <:xl:1462382551846092874>",
        description = "**XL Pets Event** has been activated for a limited amount of time!\nPlease wait until it is rolled out in all servers.",
        thumbnail = "https://cdn.discordapp.com/emojis/1455654980026499213.png?v=1&size=48&quality=lossless"
    },
    Lucky = {
        color = 0x6af50a,
        title = "<:lucky:1462382843316666379> **x2 Luck Event Started!** <:lucky:1462382843316666379>",
        description = "**Double Luck Event** has been activated for a limited time.\nPlease wait until it is rolled out in all servers.",
        thumbnail = "https://cdn.discordapp.com/emojis/1455654675209785406.png?v=1&size=48&quality=lossless"
    },
    Secret = {
        color = 0xce0ae1,
        title = "<:secrett:1462382588990591048> **x2 Secret Event Started!** <:secrett:1462382588990591048>",
        description = "**Double Secret Luck Event** has been activated for a limited amount of time!\nPlease wait until it is rolled out in all servers.",
        thumbnail = "https://cdn.discordapp.com/emojis/1456269641704800307.png?v=1&size=48&quality=lossless"
    },
    Shiny = {
        color = 0xfef336,
        title = "<:shiny:1462382758063247424> **x2 Shiny Event Started!** <:shiny:1462382758063247424>",
        description = "**Double Shiny Luck Event** has been activated for a limited amount of time!\nPlease wait until it is rolled out in all servers.",
        thumbnail = "https://cdn.discordapp.com/emojis/1455654802733404344.png?v=1&size=48&quality=lossless"
    },
    Mythic = {
        color = 0x5405f4,
        title = "<:mythic:1462382794389848086> **x2 Mythic Event Started!** <:mythic:1462382794389848086>",
        description = "**Double Mythic Luck Event** has been activated for a limited amount of time!\nPlease wait until it is rolled out in all servers.",
        thumbnail = "https://cdn.discordapp.com/emojis/1455654701012877353.png?v=1&size=48&quality=lossless"
    },
    Hatching = {
        color = 0xfff2f0,
        title = ":hatch: **Hatch Speed Event Started!** :hatch:",
        description = "**Hatch Speed Event** has been activated for a limited amount of time!\nPlease wait until it is rolled out in all servers.",
        thumbnail = "https://cdn.discordapp.com/emojis/1455654577482502317.png?v=1&size=48&quality=lossless"
    },
    Infinity = {
        color = 0x67bed9,
        title = "<:infinite:1462382674164318352> **x2 Infinity Event Started!** <:infinite:1462382674164318352>",
        description = "**Infinity Event** has been activated for a limited amount of time!\nPlease wait until it is rolled out in all servers.",
        thumbnail = "https://cdn.discordapp.com/emojis/1455654637003604189.png?v=1&size=48&quality=lossless"
    },
    Bubbling = {
        color = 0xFF4EE3,
        title = "<:bubbles:1392626533826433144> **x2 Bubble Event Started!** <:bubbles:1392626533826433144>",
        description = "**Double Bubble Event** has been activated for a limited amount of time!\nPlease wait until it is rolled out in all servers.",
        thumbnail = "https://cdn.discordapp.com/emojis/1455654523531038872.png?v=1&size=48&quality=lossless"
    }
}

local function sendWebhook(embed)
    pcall(function()
        http_request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({
                content = "<@&1462412213292634196>",
                embeds = { embed }
            })
        })
    end)
end

local function formatTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function checkEvents()
    local active = GlobalEvent:GetActive()
    local currentActive = {}
    local minRemaining = math.huge
    local sentSomething = false

    for _, name in ipairs(active) do
        currentActive[name] = true
    end

    if Time.now() < G.EventScanner.cooldownUntil then
        print("Cooldown activ până la:", formatTime(G.EventScanner.cooldownUntil - Time.now()))
    else
        for _, eventName in ipairs(active) do
            local remaining = GlobalEvent:GetRemainingTime(eventName)
            if remaining then
                print("Event Activ:", eventName, "Expiră în:", formatTime(remaining))
                if remaining < minRemaining then
                    minRemaining = remaining
                end
            end

            if not sentEvents[eventName] then
                local data = EVENTS[eventName]
                if data and remaining then
                    local endsAt = math.floor(Time.now() + remaining)
                    local startedAt = endsAt - math.floor(remaining)

                    print("Event Nou Detectat:", eventName, "Durată:", formatTime(remaining))

                    local embed = {
                        title = data.title,
                        description = data.description,
                        color = data.color,
                        thumbnail = { url = data.thumbnail },
                        fields = {
                            { name = "**Started:**", value = "<t:" .. startedAt .. ":R>", inline = true },
                            { name = "**Ends:**", value = "<t:" .. endsAt .. ":R>", inline = true }
                        },
                        footer = { text = "OTC・discord.gg/otc | Event Scanner" },
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                    }

                    sendWebhook(embed)
                    sentEvents[eventName] = true
                    sentSomething = true
                    task.wait(0.3)
                end
            end
        end

        if sentSomething and minRemaining < math.huge then
            G.EventScanner.cooldownUntil = Time.now() + minRemaining
            print("Toate event-urile trimise. Cooldown până la expirare:", formatTime(minRemaining))
        end
    end

    for name in pairs(sentEvents) do
        if not currentActive[name] then
            print("Event Expirat:", name)
            sentEvents[name] = nil
        end
    end

    if next(sentEvents) == nil then
        G.EventScanner.cooldownUntil = 0
        print("Nu mai există event-uri active. Cooldown resetat.")
    end
end

Players.PlayerAdded:Connect(function() task.defer(checkEvents) end)
Players.PlayerRemoving:Connect(function() task.defer(checkEvents) end)

GlobalEvent.Began:Connect(function() task.defer(checkEvents) end)
GlobalEvent.Ended:Connect(function() task.defer(checkEvents) end)

task.defer(checkEvents)
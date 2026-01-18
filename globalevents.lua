local WEBHOOK_URL = "https://discord.com/api/webhooks/1447658603149393950/AH90w2ScZmpQbO0LzAosT1AgXd1LlglNUqMppjAkNMNBTVimk3HrcUSXEaOk4FCrAtCT"

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local GlobalEvent = require(ReplicatedStorage.Shared.GlobalEvent)
local Time = require(ReplicatedStorage.Shared.Framework.Utilities.Math.Time)

local EVENTS = {
    XL = {
        color = 0xfc1576,
        title = "<:xl:1462382551846092874> **XL Pets Event Started!** <:xl:1462382551846092874>",
        description = "**XL Pets Event** has been activated for a limited amount of time!\nPlease wait until it is rolled out in all servers."
    },
    Lucky = {
        color = 0x6af50a,
        title = "<:lucky:1462382843316666379> **x2 Luck Event Started!** <:lucky:1462382843316666379>",
        description = "**Double Luck Event** has been activated for a limited time.\nPlease wait until it is rolled out in all servers."
    },
    Secret = {
        color = 0xce0ae1,
        title = "<:secrett:1462382588990591048> **x2 Secret Event Started!** <:secrett:1462382588990591048>",
        description = "**Double Secret Luck Event** has been activated for a limited amount of time!\nPlease wait until it is rolled out in all servers."
    },
    Shiny = {
        color = 0xfef336,
        title = "<:shiny:1462382758063247424> **x2 Shiny Event Started!** <:shiny:1462382758063247424>",
        description = "**Double Shiny Luck Event** has been activated for a limited amount of time!\nPlease wait until it is rolled out in all servers."
    },
    Mythic = {
        color = 0x5405f4,
        title = "<:mythic:1462382794389848086> **x2 Mythic Event Started!** <:mythic:1462382794389848086>",
        description = "**Double Mythic Luck Event** has been activated for a limited amount of time!\nPlease wait until it is rolled out in all servers."
    },
    Hatching = {
        color = 0xfff2f0,
        title = ":hatch: **Hatch Speed Event Started!** :hatch:",
        description = "**Hatch Speed Event** has been activated for a limited amount of time!\nPlease wait until it is rolled out in all servers."
    },
    Infinity = {
        color = 0x67bed9,
        title = "<:infinite:1462382674164318352> **x2 Infinity Event Started!** <:infinite:1462382674164318352>",
        description = "**Infinity Event** has been activated for a limited amount of time!\nPlease wait until it is rolled out in all servers."
    },
    Bubbling = {
        color = 0xfaccc9,
        title = "<:bubbles:1392626533826433144> **x2 Bubble Event Started!** <:bubbles:1392626533826433144>",
        description = "**Double Bubble Event** has been activated for a limited amount of time!\nPlease wait until it is rolled out in all servers."
    }
}

local function sendWebhook(embed)
    pcall(function()
        HttpService:PostAsync(
            WEBHOOK_URL,
            HttpService:JSONEncode({ embeds = { embed } }),
            Enum.HttpContentType.ApplicationJson
        )
    end)
end

local hadActiveEvents = false
local notifiedThisWave = false

local function checkEvents()
    local active = GlobalEvent:GetActive()

    if #active > 0 and not hadActiveEvents then
        hadActiveEvents = true
        notifiedThisWave = false
    end

    if hadActiveEvents and not notifiedThisWave then
        for _, eventName in ipairs(active) do
            local data = EVENTS[eventName]
            if data then
                local startedAt = math.floor(Time.now())
                local remaining = GlobalEvent:GetRemainingTime(eventName)
                local endsAt = startedAt + math.floor(remaining)

                local embed = {
                    title = data.title,
                    description = data.description,
                    color = data.color,
                    fields = {
                        {
                            name = "**Started:** ・ **Ends:**",
                            value = "<t:" .. startedAt .. ":R> <t:" .. endsAt .. ":R>",
                            inline = false
                        }
                    },
                    footer = {
                        text = "OTC・discord.gg/otc | Event Scanner"
                    },
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }

                sendWebhook(embed)
                notifiedThisWave = true
                break
            end
        end
    end

    if #active == 0 and hadActiveEvents then
        hadActiveEvents = false
        notifiedThisWave = false
    end
end

GlobalEvent.Began:Connect(function()
    task.defer(checkEvents)
end)

GlobalEvent.Ended:Connect(function()
    task.defer(checkEvents)
end)

task.defer(checkEvents)
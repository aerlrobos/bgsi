local WEBHOOK_URL = "https://discord.com/api/webhooks/1447658603149393950/AH90w2ScZmpQbO0LzAosT1AgXd1LlglNUqMppjAkNMNBTVimk3HrcUSXEaOk4FCrAtCT"
local SAVE_FILE = "events.txt"

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local GlobalEvent = require(ReplicatedStorage.Shared.GlobalEvent)
local Time = require(ReplicatedStorage.Shared.Framework.Utilities.Math.Time)

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
        title = "<:hatch:1462382627196637288> **Hatch Speed Event Started!** <:hatch:1462382627196637288>",
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

local function makeWaveHash(events)
    table.sort(events)
    return table.concat(events, "|")
end

local function loadLastWave()
    if isfile(SAVE_FILE) then
        return readfile(SAVE_FILE)
    end
end

local function saveWave(hash)
    writefile(SAVE_FILE, hash)
end

local function sendEmbed(name, remaining)
    local data = EVENTS[name]
    if not data then return end

    local endsAt = math.floor(Time.now() + remaining)
    local startedAt = endsAt - math.floor(remaining)

    http_request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({
            content = "<@&1462412213292634196>",
            embeds = {{
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
            }}
        })
    })
end

local function checkEvents()
    local active = GlobalEvent:GetActive()
    if #active == 0 then
        print("Nu sunt event-uri active")
        return
    end

    local currentHash = makeWaveHash(active)
    local savedHash = loadLastWave()

    if currentHash == savedHash then
        print("Wave deja notificat (persistat):", currentHash)
        return
    end

    print("Wave nou:", currentHash)

    for _, name in ipairs(active) do
        local remaining = GlobalEvent:GetRemainingTime(name)
        if remaining then
            sendEmbed(name, remaining)
            task.wait(0.4)
        end
    end

    saveWave(currentHash)
    print("Wave salvat pe disk. Nu se mai retrimite.")
end

GlobalEvent.Began:Connect(checkEvents)
GlobalEvent.Ended:Connect(checkEvents)

task.defer(checkEvents)
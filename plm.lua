local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local petsModule = require(rs.Shared.Data.Pets)
local eggsModule = require(rs.Shared.Data.Eggs)
local secretBountyUtil = require(rs.Shared.Utils.Stats.SecretBountyUtil)
local LocalData = require(rs.Client.Framework.Services.LocalData)

local webhookUrls = {
    Normal = "https://discord.com/api/webhooks/1449527156207255716/IJGbceZJO9aOysjElj-S4j3U2IadNngvkI7vGYzrVyj6kge7FgyKMtQDyjpgsNfxFUOz",
    Shiny = "https://discord.com/api/webhooks/1449527161701798010/nwznKPK-qEAV2KrTcZmQwUP5yz-Qg__qPHCdHJaBlGTnWUjzJRHIRrWZsCNjyYa-qhYu",
    Mythic = "https://discord.com/api/webhooks/1449527163794620578/N4uuBpd3CnKw3m8HBDD4-qeYO0LvqmjNxP5vVVdp7xoZ9RgTvXpoM94MvtBzUAU5No3s",
    ["Shiny Mythic"] = "https://discord.com/api/webhooks/1449527168693571584/-NkXObqQsgjedD4vRUtc9gMqVpk5Gx0usw1O0Y6MkIe_-Vqq8pL_j4H_MATFCHnYq8lY"
}
local bountyWebhook = "https://discord.com/api/webhooks/1407847455902662768/xWn94IDXW-ExWhJ0JGX5GF9Uefa9vOAzea2qNMJKVMbKq9yXE9ZHiLxFNX_dpft_XB1S"

local localPlayer = Players.LocalPlayer
print("Roblox Name: " .. localPlayer.Name)
local failedFile = "FailedWebhooks.json"

local HatchEvent = rs:WaitForChild("Shared")
    :WaitForChild("Framework")
    :WaitForChild("Network")
    :WaitForChild("Remote")
    :WaitForChild("RemoteEvent")

local chestRemote = rs.Shared.Framework.Network.Remote.RemoteEvent
local startTime = tick()
local coins, gems, tickets, pearls, snowflakes, totalHatches = 0, 0, 0, 0, 0

local function updateCurrencies()
    local data = LocalData:Get()
    if not data then return end

    coins = data.Coins or (data.Stats and data.Stats.Coins) or coins
    gems = data.Gems or (data.Stats and data.Stats.Gems) or gems
    tickets = data.Tickets or (data.Stats and data.Stats.Tickets) or tickets
    pearls = data.Pearls or (data.Stats and data.Stats.Pearls) or pearls
    snowflakes = data.Snowflakes or (data.Stats and data.Stats.Snowflakes) or snowflakes
    totalHatches = data.Stats and data.Stats.Hatches or totalHatches
end

LocalData.Changed:Connect(function()
    pcall(updateCurrencies)
end)

pcall(updateCurrencies)

local webhookQueue = {}
local isProcessingQueue = false

local function autoChest()
    local chests = {
        {name = "Giant Chest",    cooldown = 15 * 60, lastClaim = 0},
        {name = "Void Chest",     cooldown = 40 * 60, lastClaim = 0},
        {name = "Ticket Chest",   cooldown = 30 * 60, lastClaim = 0},
        {name = "Infinity Chest", cooldown = 30 * 60, lastClaim = 0},
    }

    while true do
        for _, chest in ipairs(chests) do
            local now = os.time()
            if (now - chest.lastClaim) >= chest.cooldown then
                chestRemote:FireServer("ClaimChest", chest.name, true)
                chest.lastClaim = now
            end
            task.wait(5)
        end
        task.wait(1)
    end
end

local function autoPlaytimeReward()
    local playtimeRemote = rs:WaitForChild("Shared")
        :WaitForChild("Framework")
        :WaitForChild("Network")
        :WaitForChild("Remote")
        :WaitForChild("RemoteFunction")

    local AllRewards = {}

    while true do
        for i = 1, 9 do
            local success, result = pcall(function()
                return playtimeRemote:InvokeServer("ClaimPlaytime", i)
            end)
            if success then
                AllRewards[i] = result
            end
        end
        task.wait(30)
    end
end

local function autoClaimSeasonReward()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RemoteEvent = ReplicatedStorage:WaitForChild("Shared")
                                  :WaitForChild("Framework")
                                  :WaitForChild("Network")
                                  :WaitForChild("Remote")
                                  :WaitForChild("RemoteEvent")

    local function claim()
        RemoteEvent:FireServer("ClaimSeason")
    end

    while true do
        claim()
        task.wait(5)
    end
end

local function getBountyPetImageLink(petName)
    local petEntry = petsModule[petName]
    if not petEntry or not petEntry.Images then return nil end
    local assetStr = petEntry.Images["Normal"]
    local assetId = assetStr and assetStr:match("%d+")
    return assetId and ("https://ps99.biggamesapi.io/image/" .. assetId) or nil
end

local function formatBountyNumber(n)
    local str = tostring(math.floor(n))
    return str:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function formatBountyChance(chance)
    if not chance or chance <= 0 then return "N/A" end
    local inv = math.floor((1 / chance) * 100 + 0.5)
    return "1 in " .. formatBountyNumber(inv)
end

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
        percentStr = string.format("%.2e", num) .. "%"
    else
        percentStr = string.format("%.10f", num):gsub("0+$", ""):gsub("%.$", "") .. "%"
    end

    return string.format("%s (1 in %s)", percentStr, approxNumber(oneIn)), oneIn
end

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

local function toOrdinal(n)
    local suffix = "TH"
    if n % 10 == 1 and n % 100 ~= 11 then
        suffix = "ST"
    elseif n % 10 == 2 and n % 100 ~= 12 then
        suffix = "ND"
    elseif n % 10 == 3 and n % 100 ~= 13 then
        suffix = "RD"
    end
    return tostring(n)..suffix
end

local function getPetCount(playerId, petName, variant)
    local allData = LocalData:Get(playerId) or {}
    local discovered = allData["Discovered"] or {}

    local key
    if variant == "Normal" then
        key = petName
    else
        key = variant .. " " .. petName
    end

    return discovered[key] or 0
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

local function isSecretBounty(petName)
    local ok, result = pcall(function()
        return secretBountyUtil.Get()
    end)

    if ok and typeof(result) == "table" and result.Name == petName then
        return true, result
    end
    return false, nil
end

local lastSentDate = nil
local function getDateKey()
    local now = os.date("!*t")
    return string.format("%04d-%02d-%02d", now.year, now.month, now.day)
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

local function sendBountyEmbed()
    local today = getDateKey()
    if lastSentDate == today then
        return
    end

    local current = secretBountyUtil:Get()
    if not current then return end

    local chanceFormatted = formatBountyChance(current.Chance)
    local petImage = getBountyPetImageLink(current.Name)

    local now = os.time()
    local tomorrowMidnightUTC = os.time(os.date("!*t", now))
    tomorrowMidnightUTC = tomorrowMidnightUTC - (tomorrowMidnightUTC % 86400) + 86400

    local embed = {
        title = "🎯 Secret Bounty",
        color = 16777215,
        fields = {
            { name = "Pet", value = current.Name, inline = true },
            { name = "Egg", value = current.Egg, inline = true },
            { name = "Chance", value = chanceFormatted, inline = true },
            { name = "Next", value = string.format("<t:%d:R>", tomorrowMidnightUTC), inline = false }
        },
        image = { url = petImage or "" },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ", now)
    }

    local payload = HttpService:JSONEncode({ embeds = { embed } })

    http_request({
        Url = bountyWebhook,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = payload
    })

    lastSentDate = today
end

coroutine.wrap(function()
    while true do
        local now = os.time()
        local utcNow = os.date("!*t", now)

        local nextMidnightUTC = os.time({
            year = utcNow.year,
            month = utcNow.month,
            day = utcNow.day,
            hour = 0,
            min = 0,
            sec = 0
        })
        if nextMidnightUTC <= now then
            nextMidnightUTC = nextMidnightUTC + 86400
        end

        local secondsToWait = nextMidnightUTC - now
        print("Aștept " .. secondsToWait .. "s până la 00:00 UTC (03:00 România)")

        task.wait(secondsToWait)

        sendBountyEmbed()

        while true do
            task.wait(86400)
            sendBountyEmbed()
        end
    end
end)()

task.spawn(function()
    local req = http_request or request or (syn and syn.request)
    if not req then
        warn("⚠️ Executorul nu suportă http_request — webhook-urile nu pot fi trimise.")
        return
    end

    local failed = loadFailedWebhooks()
    if #failed > 0 then
        print("[♻️] Retrimit webhook-uri ratate: " .. tostring(#failed))
        for _, v in pairs(failed) do
            table.insert(webhookQueue, v)
        end
        delfile(failedFile)
    end

    while true do
        if #webhookQueue > 0 then
            local data = table.remove(webhookQueue, 1)
            local success, err = pcall(function()
                req({
                    Url = data.webhookUrl or webhookUrl,
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

            if not success then
                warn("[❌ Webhook Fail] " .. tostring(err))
                saveFailedWebhook(data)
            else
                task.wait(0.5)
            end
        else
            task.wait(1)
        end
    end
end)

function sendDiscordWebhook(playerName, petName, variant, boostedStats, dropChance, egg, rarity, tier)
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
    local selectedWebhook = webhookUrls[variant] or webhookUrls.Normal

    if rarity == "Infinity" then
        embedColor = colorMap["Infinity"]

    elseif rarity == "Secret" or rarity == "Secret Bounty" then
        if variant == "Shiny" then
            embedColor = colorMap["Shiny"]
        elseif variant == "Mythic" then
            embedColor = colorMap["Mythic"]
        elseif variant == "Shiny Mythic" then
            embedColor = colorMap["Shiny Mythic"]
        else
            embedColor = colorMap["Secret"]
        end

    else
        if colorMap[variant] then
            embedColor = colorMap[variant]
        else
            embedColor = colorMap["Normal"]
        end
    end

    local displayPetName = (variant ~= "Normal" and variant.." " or "")..petName
    local petImageLink = getPetImageLink(petName, variant)
    local hatchCount = abbreviateNumber(totalHatches)

    local petCurrencyLabel, petCurrencyValue = "", ""
    if boostedStats.Tickets then
        petCurrencyLabel = "<:ticket:1392626567464747028> **Tickets**"
        petCurrencyValue = tostring(boostedStats.Tickets)
    elseif boostedStats.Pearls then
        petCurrencyLabel = "<:pearls:1403707150513213550> **Pearls**"
        petCurrencyValue = tostring(boostedStats.Pearls)
    elseif boostedStats.Snowflakes then
        petCurrencyLabel = "<:snowflakes:1446973115765755998> **Snowflakes**"
        petCurrencyValue = tostring(boostedStats.Snowflakes)
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

👤・**User Info**
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

    local petCount = getPetCount(playerName, petName, variant) + 1
    local ordinalCount = toOrdinal(petCount)
    local variantPrefix = (variant ~= "Normal" and variant:upper().." " or "NORMAL ")
    local specialMessage = string.format("THIS IS YOUR %s %s PET!", ordinalCount, variant:upper())

    local titleText, contentText = "", ""
    local contentRarity = rarity:upper()

    if rarity == "Infinity" then
        titleText = string.format("DAMN! ||%s|| hatched a %s! Unbelievable!", playerName, displayPetName)
        contentText = "@everyone "..variantPrefix..contentRarity.."! "..specialMessage
    elseif rarity == "Secret" or rarity == "Secret Bounty" then
        titleText = string.format("WOW! ||%s|| hatched a %s! Lucky Guy!", playerName, displayPetName)
        contentText = "@everyone "..variantPrefix..contentRarity.."! "..specialMessage
    else
        titleText = string.format("||%s|| hatched a %s", playerName, displayPetName)
        contentText = specialMessage
    end

    enqueueWebhook({
        webhookUrl = selectedWebhook,
        contentText = contentText,
        titleText = titleText,
        description = description,
        embedColor = embedColor,
        petImageLink = petImageLink
    })    
end

HatchEvent.OnClientEvent:Connect(function(action, data)
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

        local dropChance = formatChance(rawChance, variant)

        local shouldSend = false

        if rarity == "Infinity" then
            shouldSend = true
        elseif rarity == "Secret" or rarity == "Secret Bounty" then
            shouldSend = true
        elseif action == "ExclusiveHatch" then
            if rarity == "Infinity" or rarity == "Secret" or rarity == "Secret Bounty" then
                shouldSend = true
            end
        end

        if shouldSend then
            sendDiscordWebhook(
                localPlayer.Name,
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

print("✅ Pet notifier activat pentru: " .. localPlayer.Name)

task.spawn(autoChest)
task.spawn(autoPlaytimeReward)
task.spawn(autoClaimSeasonReward)
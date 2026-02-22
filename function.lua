local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- =========================
-- UUID DETECTION
-- =========================

local function isUUID(str)
    return str:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil
end

local uuidFolder

for _, obj in ipairs(ReplicatedStorage:GetChildren()) do
    if isUUID(obj.Name) then
        uuidFolder = obj
        break
    end
end

if not uuidFolder then
    warn("[HOOK] UUID folder not found.")
    return
end

print("[HOOK] UUID found:", uuidFolder.Name)

-- =========================
-- FIND OPENEGG REMOTE
-- =========================

local functionsFolder = uuidFolder:FindFirstChild("Functions")
if not functionsFolder then
    warn("[HOOK] Functions folder not found.")
    return
end

local OpenEgg = functionsFolder:FindFirstChild("OpenEgg")
if not OpenEgg then
    warn("[HOOK] OpenEgg not found.")
    return
end

print("[HOOK] OpenEgg found.")

-- =========================
-- SAFE NAMECALL HOOK
-- =========================

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)

    if getnamecallmethod() == "InvokeServer"
    and typeof(self) == "Instance"
    and self == OpenEgg then

        -- Apelez funcția originală
        local results = {oldNamecall(self, ...)}

        -- Trimite webhook fără duplicate
        task.spawn(function()
            if results[2] and type(results[2]) == "table" then
                for _, petData in pairs(results[2]) do
                    if type(petData) == "table" then
                        local petName = petData[1]
                        local variant = petData[2]
                        local chance = petData[3]

                        -- Creează un key unic pentru fiecare pet hatch
                        local key = tostring(petName)..tostring(variant)..tostring(chance)
                        getgenv()._lastHatch = getgenv()._lastHatch or {}

                        -- Dacă a fost trimis recent (<0.5s), ignoră
                        if not getgenv()._lastHatch[key] or tick() - getgenv()._lastHatch[key] >= 0.5 then
                            getgenv()._lastHatch[key] = tick()

                            if getgenv().sendWebhook then
                                getgenv().sendWebhook(petName, variant, chance)
                            end
                        end
                    end
                end
            end
        end)

        return unpack(results)
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

print("[HOOK] Successfully hooked OpenEgg")
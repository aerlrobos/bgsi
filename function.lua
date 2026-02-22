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
    
mt.__namecall = newcclosure(function(...)    
    local self = ...    
    local method = getnamecallmethod()    
    
    if method == "InvokeServer" and tostring(self.Name) == "OpenEgg" then    
            
        local results = {oldNamecall(...)}    
    
        task.spawn(function()    
            if results[2] and type(results[2]) == "table" then    
                for _, petData in pairs(results[2]) do    
                    if type(petData) == "table" then    
                        local petName = petData[1]    
                        local variant = petData[2]    
                        local chance = petData[3]    
    
                        getgenv().sendWebhook(petName, variant, chance)    
                    end    
                end    
            end    
        end)    
    
        return unpack(results)    
    end    
    
    return oldNamecall(...)    
end)    

print("[HOOK] Successfully hooked OpenEgg")
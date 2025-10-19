local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local pid, jobid = game.PlaceId, game.JobId
local retrying = false

local function attemptRejoin()
    while true do
        local success = pcall(function()
            TeleportService:TeleportToPlaceInstance(pid, jobid, Players.LocalPlayer)
        end)
        if success then break end
        task.wait(25)
        pcall(function()
            TeleportService:Teleport(pid, Players.LocalPlayer)
        end)
    end
end

game:GetService("NetworkClient").ChildRemoved:Connect(function()
    if not retrying then
        retrying = true
        task.delay(1, attemptRejoin)
    end
end)
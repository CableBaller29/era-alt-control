local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local setups = {
    bank = {
        Vector3.new(-390.25, 16.07561492919922, -326.49993896484375),
        Vector3.new(-384.25, 16.07561492919922, -326.49993896484375),
        Vector3.new(-372.25, 16.07561492919922, -326.49993896484375),
        Vector3.new(-378.25, 16.07561492919922, -326.49993896484375),
        Vector3.new(-360.25, 16.07561492919922, -326.49993896484375),
        Vector3.new(-366.25, 16.07561492919922, -326.49993896484375),
        Vector3.new(-360.25, 16.07561492919922, -317.49993896484375),
        Vector3.new(-366.25, 16.07561492919922, -317.49993896484375),
        Vector3.new(-378.25, 16.07561492919922, -317.49993896484375),
        Vector3.new(-372.25, 16.07561492919922, -317.49993896484375),
        Vector3.new(-384.25, 16.07561492919922, -317.49993896484375),
        Vector3.new(-390.25, 16.07561492919922, -317.49993896484375),
        Vector3.new(-360.25, 16.07561492919922, -309.49993896484375),
        Vector3.new(-366.25, 16.07561492919922, -309.49993896484375),
        Vector3.new(-378.25, 16.07561492919922, -309.49993896484375),
        Vector3.new(-372.25, 16.07561492919922, -309.49993896484375),
        Vector3.new(-384.25, 16.07561492919922, -309.49993896484375),
        Vector3.new(-390.25, 16.07561492919922, -309.49993896484375),
        Vector3.new(-360.25, 16.07561492919922, -301.49993896484375),
        Vector3.new(-366.25, 16.07561492919922, -301.49993896484375),
        Vector3.new(-378.25, 16.07561492919922, -301.49993896484375),
        Vector3.new(-372.25, 16.07561492919922, -301.49993896484375),
        Vector3.new(-384.25, 16.07561492919922, -301.49993896484375),
        Vector3.new(-390.25, 16.07561492919922, -301.49993896484375)
    },
    school = {
        Vector3.new(-605.625, 16.07561492919922, 196.00006103515625),
        Vector3.new(-599.625, 16.07561492919922, 196.00006103515625),
        Vector3.new(-587.625, 16.07561492919922, 196.00006103515625),
        Vector3.new(-593.625, 16.07561492919922, 196.00006103515625),
        Vector3.new(-575.625, 16.07561492919922, 196.00006103515625),
        Vector3.new(-581.625, 16.07561492919922, 196.00006103515625),
        Vector3.new(-575.625, 16.07561492919922, 205.00006103515625),
        Vector3.new(-581.625, 16.07561492919922, 205.00006103515625),
        Vector3.new(-593.625, 16.07561492919922, 205.00006103515625),
        Vector3.new(-587.625, 16.07561492919922, 205.00006103515625),
        Vector3.new(-599.625, 16.07561492919922, 205.00006103515625),
        Vector3.new(-605.625, 16.07561492919922, 205.00006103515625),
        Vector3.new(-575.625, 16.07561492919922, 213.00006103515625),
        Vector3.new(-581.625, 16.07561492919922, 213.00006103515625),
        Vector3.new(-593.625, 16.07561492919922, 213.00006103515625),
        Vector3.new(-587.625, 16.07561492919922, 213.00006103515625),
        Vector3.new(-599.625, 16.07561492919922, 213.00006103515625),
        Vector3.new(-605.625, 16.07561492919922, 213.00006103515625),
        Vector3.new(-575.625, 16.07561492919922, 221.00006103515625),
        Vector3.new(-581.625, 16.07561492919922, 221.00006103515625),
        Vector3.new(-593.625, 16.07561492919922, 221.00006103515625),
        Vector3.new(-587.625, 16.07561492919922, 221.00006103515625),
        Vector3.new(-599.625, 16.07561492919922, 221.00006103515625),
        Vector3.new(-605.625, 16.07561492919922, 221.00006103515625)
    },
    soccer = {
        Vector3.new(-947.6702270507812, 16.07561492919922, -494.70001220703125),
        Vector3.new(-941.6702270507812, 16.07561492919922, -494.70001220703125),
        Vector3.new(-929.6702270507812, 16.07561492919922, -494.70001220703125),
        Vector3.new(-935.6702270507812, 16.07561492919922, -494.70001220703125),
        Vector3.new(-917.6702270507812, 16.07561492919922, -494.70001220703125),
        Vector3.new(-923.6702270507812, 16.07561492919922, -494.70001220703125),
        Vector3.new(-917.6702270507812, 16.07561492919922, -485.70001220703125),
        Vector3.new(-923.6702270507812, 16.07561492919922, -485.70001220703125),
        Vector3.new(-935.6702270507812, 16.07561492919922, -485.70001220703125),
        Vector3.new(-929.6702270507812, 16.07561492919922, -485.70001220703125),
        Vector3.new(-941.6702270507812, 16.07561492919922, -485.70001220703125),
        Vector3.new(-947.6702270507812, 16.07561492919922, -485.70001220703125),
        Vector3.new(-917.6702270507812, 16.07561492919922, -477.7000427246094),
        Vector3.new(-923.6702270507812, 16.07561492919922, -477.7000427246094),
        Vector3.new(-935.6702270507812, 16.07561492919922, -477.7000427246094),
        Vector3.new(-929.6702270507812, 16.07561492919922, -477.7000427246094),
        Vector3.new(-941.6702270507812, 16.07561492919922, -477.7000427246094),
        Vector3.new(-947.6702270507812, 16.07561492919922, -477.7000427246094),
        Vector3.new(-917.6702270507812, 16.07561492919922, -469.7000427246094),
        Vector3.new(-923.6702270507812, 16.07561492919922, -469.7000427246094),
        Vector3.new(-935.6702270507812, 16.07561492919922, -469.7000427246094),
        Vector3.new(-929.6702270507812, 16.07561492919922, -469.7000427246094),
        Vector3.new(-941.6702270507812, 16.07561492919922, -469.7000427246094),
        Vector3.new(-947.6702270507812, 16.07561492919922, -469.7000427246094)
    }
}

local dropLoop = false
local dropTask
local remaining = 0
local ChatEvent = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")

local function teleportPlayer(player, position)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        hrp.Anchored = false
        hrp.CFrame = CFrame.new(position)
        task.wait(0.5)
        hrp.Anchored = false
    end
end

local function parseAmount(str)
    if not str then return 15000 end
    str = str:lower():gsub(",","")
    local num = tonumber(str:match("%d+%.?%d*"))
    if not num then return 15000 end
    if str:find("k") then
        num = num * 1000
    elseif str:find("m") then
        num = num * 1000000
    end
    return math.floor(num)
end

local function startDropping(totalAmount)
    totalAmount = parseAmount(totalAmount)
    dropLoop = true
    remaining = totalAmount
    dropTask = spawn(function()
        while dropLoop and remaining > 0 do
            local alts = {}
            for _, userId in ipairs(getgenv().alts) do
                local alt = Players:GetPlayerByUserId(userId)
                if alt then table.insert(alts, alt) end
            end
            if #alts == 0 then break end

            local chunk = math.min(15000 * #alts, remaining)
            local perAlt = math.floor(chunk / #alts)
            for _, alt in ipairs(alts) do
                local dropAmount = math.min(15000, perAlt)
                ReplicatedStorage:WaitForChild("MainEvent"):FireServer("DropMoney", tostring(dropAmount))
                remaining = remaining - dropAmount
            end
            task.wait(15)
        end
    end)
end

local function stopDropping()
    dropLoop = false
end

local function bringPlayer(alt, targetPlayer, owner)
    if not alt or not targetPlayer or not owner then return end
    local altHRP = alt.Character and alt.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local ownerHRP = owner.Character and owner.Character:FindFirstChild("HumanoidRootPart")
    if not altHRP or not targetHRP or not ownerHRP then return end
    altHRP.CFrame = targetHRP.CFrame + Vector3.new(0,5,0)
    task.wait(0.1)
    ReplicatedStorage:WaitForChild("MainEvent"):FireServer("ChargeButton")
    task.wait(0.1)
    ReplicatedStorage:WaitForChild("MainEvent"):FireServer("Grabbing", true)
    task.wait(0.1)
    altHRP.CFrame = ownerHRP.CFrame + Vector3.new(0,5,0)
    task.wait(0.1)
    ReplicatedStorage:WaitForChild("MainEvent"):FireServer("Grabbing", false)
end

local function handleChat(plr, msg)
    local ownerInstance = Players:GetPlayerByUserId(getgenv().owner)
    if not ownerInstance then return end
    if plr.UserId ~= ownerInstance.UserId then return end
    msg = msg:lower()

    if msg:sub(1,7) == ".setup " then
        local setupName = msg:sub(8)
        local positions = setups[setupName]
        if positions then
            local index = 1
            for _, userId in ipairs(getgenv().alts) do
                local alt = Players:GetPlayerByUserId(userId)
                if alt and positions[index] then
                    teleportPlayer(alt, positions[index])
                    index = index + 1
                end
            end
        end
    elseif msg:sub(1,5) == ".drop" then
        local amount = msg:match("%S+%s*(.+)")
        startDropping(amount)
    elseif msg:sub(1,5) == ".stop" then
        stopDropping()
    elseif msg:sub(1,7) == ".bring " then
        local targetName = msg:sub(8)
        local targetPlayer
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name:lower() == targetName then
                targetPlayer = p
                break
            end
        end
        if targetPlayer then
            for _, userId in ipairs(getgenv().alts) do
                local alt = Players:GetPlayerByUserId(userId)
                if alt then
                    spawn(function()
                        bringPlayer(alt, targetPlayer, ownerInstance)
                    end)
                end
            end
        end
    elseif msg:sub(1,7) == ".remain" then
        for _, userId in ipairs(getgenv().alts) do
            local alt = Players:GetPlayerByUserId(userId)
            if alt then
                ChatEvent:FireServer("[Alt: " .. alt.Name .. "] Remaining: " .. tostring(remaining), "All")
            end
        end
    elseif msg:sub(1,5) == ".say " then
        local sayMessage = msg:sub(6)
        for _, userId in ipairs(getgenv().alts) do
            local alt = Players:GetPlayerByUserId(userId)
            if alt then
                ChatEvent:FireServer(sayMessage, "All")
            end
        end
    elseif msg:sub(1,8) == ".setfps " then
        local fpsAmount = tonumber(msg:sub(9))
        if fpsAmount then
            setfpscap(fpsAmount)
        end
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    plr.Chatted:Connect(function(msg)
        handleChat(plr, msg)
    end)
end

Players.PlayerAdded:Connect(function(plr)
    plr.Chatted:Connect(function(msg)
        handleChat(plr, msg)
    end)
end)

for i, v in pairs(getconnections(LocalPlayer.Idled)) do
    v:Disable()
end

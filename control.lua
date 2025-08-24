local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local BOUNTY_REMOTE = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SetBounty")
local MAX_BOUNTY = 2500000
local TAX_RATE = 0.3
local buyerCurrencyConnection
local currentSetter, currentTarget

local function calculateBounty(amount)
    local raw = math.floor(amount / (1 - TAX_RATE))
    if raw > MAX_BOUNTY then raw = MAX_BOUNTY end
    return raw
end

local function sendWebhook(name, total)
    if not getgenv().AutofarmSettings or not getgenv().AutofarmSettings.Webhook then return end
    local HttpService = game:GetService("HttpService")
    local data = {
        content = "",
        embeds = {{
            title = "Buyer Fully Paid",
            description = name.." has received their total DHC: "..tostring(total),
            color = 65280
        }}
    }
    pcall(function()
        HttpService:PostAsync(getgenv().AutofarmSettings.Webhook, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

local function getCurrency(player)
    if player and player:FindFirstChild("DataFolder") and player.DataFolder:FindFirstChild("Currency") then
        return player.DataFolder.Currency.Value
    end
    return 0
end

local function placeBounty(setter, target, buyer)
    if not setter or not setter.Character or not target or not target.Character or not buyer or not buyer.Character then return end
    local settings = getgenv().AutofarmSettings
    local cur = getCurrency(buyer)
    local targetAmount = cur + settings.ExtraAmount
    local remaining = targetAmount - cur
    local bounty = calculateBounty(remaining)

    BOUNTY_REMOTE:InvokeServer(target.Name, bounty)

    -- Teleport target to buyer
    target.Character:SetPrimaryPartCFrame(buyer.Character.PrimaryPart.CFrame + Vector3.new(0,5,0))

    local actualReceived = math.floor(bounty * (1 - TAX_RATE))

    if cur + actualReceived >= targetAmount then
        sendWebhook(settings.BuyerUsername, targetAmount)
        -- Kick all alts when buyer fully paid
        if LocalPlayer.UserId == settings.OwnerUserId then
            for _, uid in ipairs(settings.AltUserIds or {}) do
                local alt = Players:GetPlayerByUserId(uid)
                if alt then alt:Kick("Order completed") end
            end
        end
    else
        -- Swap setter & target for next round
        currentSetter, currentTarget = target, setter
    end
end

-- UI setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AltControlUI"
local Frame = Instance.new("Frame", ScreenGui)
Frame.Name = "BuyerInfo"
Frame.Size = UDim2.new(0.48,0,0.56,0)
Frame.Position = UDim2.new(0.5,0,0.5,0)
Frame.AnchorPoint = Vector2.new(0.5,0.5)
Frame.BackgroundColor3 = Color3.new(0,0,0)
Frame.BorderSizePixel = 0

local function createLabel(parent, pos)
    local label = Instance.new("TextLabel", parent)
    label.Position = pos
    label.Size = UDim2.new(0.29,0,0.11,0)
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    Instance.new("UITextSizeConstraint", label).MaxTextSize = 50
    return label
end

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(0.43,0,0.11,0)
Title.Position = UDim2.new(0.285,0,0.025,0)
Title.Text = "Era Alt Control"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.TextScaled = true
Title.Font = Enum.Font.SourceSansBold
Instance.new("UITextSizeConstraint", Title).MaxTextSize = 50

local BuyerName = createLabel(Frame, UDim2.new(0.186,0,0.389,0))
local BuyerAmount = createLabel(Frame, UDim2.new(0.32,0,0.5,0))
local TargetAmount = createLabel(Frame, UDim2.new(0.32,0,0.19,0))
local AltAmount = createLabel(Frame, UDim2.new(0.32,0,0.7,0))

local RefreshButton = Instance.new("TextButton", Frame)
RefreshButton.Position = UDim2.new(0.644,0,0.833,0)
RefreshButton.Size = UDim2.new(0.314,0,0.111,0)
RefreshButton.BackgroundColor3 = Color3.new(1,1,1)
RefreshButton.Font = Enum.Font.SourceSansBold
RefreshButton.Text = "Check Buyer Info"
RefreshButton.TextColor3 = Color3.new(0,0,0)
RefreshButton.TextScaled = true
Instance.new("UITextSizeConstraint", RefreshButton).MaxTextSize = 36

local Aspect = Instance.new("UIAspectRatioConstraint", Frame)
Aspect.AspectRatio = 1.56

local function updateUI()
    local settings = getgenv().AutofarmSettings
    if not settings or not settings.BuyerUsername or not settings.ExtraAmount then return end
    local buyer = Players:FindFirstChild(settings.BuyerUsername)
    if not buyer then return end
    BuyerName.Text = settings.BuyerUsername
    BuyerAmount.Text = "Current: "..getCurrency(buyer)
    TargetAmount.Text = "Target: "..(getCurrency(buyer) + settings.ExtraAmount)
    AltAmount.Text = "Alt DHC: "..getCurrency(LocalPlayer)
end

RefreshButton.MouseButton1Click:Connect(updateUI)

local function monitorBuyer()
    local settings = getgenv().AutofarmSettings
    if not settings or not settings.BuyerUsername then return end
    local buyer = Players:FindFirstChild(settings.BuyerUsername)
    if buyer and buyer:FindFirstChild("DataFolder") and buyer.DataFolder:FindFirstChild("Currency") then
        if buyerCurrencyConnection then buyerCurrencyConnection:Disconnect() end
        buyerCurrencyConnection = buyer.DataFolder.Currency:GetPropertyChangedSignal("Value"):Connect(updateUI)
    end
end

monitorBuyer()

-- Main loop
task.spawn(function()
    while task.wait(1) do
        local settings = getgenv().AutofarmSettings
        local onlineAlts = {}
        for _, uid in ipairs(settings.AltUserIds or {}) do
            local alt = Players:GetPlayerByUserId(uid)
            if alt then table.insert(onlineAlts, alt) end
        end

        if #onlineAlts >= 2 then
            local buyer = Players:FindFirstChild(settings.BuyerUsername)
            if buyer then
                -- Initialize setter & target if not set
                if not currentSetter or not currentTarget then
                    currentSetter = onlineAlts[1]
                    currentTarget = onlineAlts[2]
                end

                -- Place bounty from setter to target
                if currentSetter and currentTarget then
                    placeBounty(currentSetter, currentTarget, buyer)
                end
            end
        end

        updateUI()
        monitorBuyer()
    end
end)

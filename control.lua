local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local BOUNTY_REMOTE = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SetBounty")
local MAX_BOUNTY = 2500000
local TAX_RATE = 0.3
local lastTarget = {}
local buyerCurrencyConnection

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

local function placeBounty(targetAlt)
    if not targetAlt or not targetAlt.Character then return end
    local settings = getgenv().AutofarmSettings
    if not settings or not settings.BuyerUsername or not settings.ExtraAmount then return end
    local buyer = Players:FindFirstChild(settings.BuyerUsername)
    if not buyer then return end
    local cur = getCurrency(buyer)
    local targetAmount = cur + settings.ExtraAmount
    local remaining = targetAmount - cur
    local bounty = calculateBounty(remaining)
    BOUNTY_REMOTE:InvokeServer(targetAlt.Name, bounty)
    if targetAlt.Character.PrimaryPart and buyer.Character and buyer.Character.PrimaryPart then
        targetAlt.Character:SetPrimaryPartCFrame(buyer.Character.PrimaryPart.CFrame + Vector3.new(0,5,0))
    end
    local actualReceived = math.floor(bounty * (1 - TAX_RATE))
    if cur + actualReceived >= targetAmount then
        sendWebhook(settings.BuyerUsername, targetAmount)
        if LocalPlayer.UserId == settings.OwnerUserId then
            for _, uid in ipairs(settings.AltUserIds or {}) do
                local alt = Players:GetPlayerByUserId(uid)
                if alt then alt:Kick("Order completed") end
            end
        end
    end
end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AltControlUI"
local Frame = Instance.new("Frame", ScreenGui)
Frame.Name = "BuyerInfo"
Frame.Size = UDim2.new(0.48,0,0.56,0)
Frame.Position = UDim2.new(0.5,0,0.5,0)
Frame.AnchorPoint = Vector2.new(0.5,0.5)
Frame.BackgroundColor3 = Color3.new(0,0,0)
Frame.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(0.43,0,0.11,0)
Title.Position = UDim2.new(0.285,0,0.025,0)
Title.Text = "Era Alt Control"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.TextScaled = true
Title.Font = Enum.Font.SourceSansBold
Instance.new("UITextSizeConstraint", Title).MaxTextSize = 50

local BuyerName = Instance.new("TextLabel", Frame)
BuyerName.Position = UDim2.new(0.186,0,0.389,0)
BuyerName.Size = UDim2.new(0.29,0,0.11,0)
BuyerName.TextColor3 = Color3.new(1,1,1)
BuyerName.BackgroundTransparency = 1
BuyerName.TextScaled = true
BuyerName.Font = Enum.Font.SourceSansBold
Instance.new("UITextSizeConstraint", BuyerName).MaxTextSize = 50

local BuyerAmount = Instance.new("TextLabel", Frame)
BuyerAmount.Position = UDim2.new(0.32,0,0.5,0)
BuyerAmount.Size = UDim2.new(0.29,0,0.11,0)
BuyerAmount.TextColor3 = Color3.new(1,1,1)
BuyerAmount.BackgroundTransparency = 1
BuyerAmount.TextScaled = true
BuyerAmount.Font = Enum.Font.SourceSansBold
Instance.new("UITextSizeConstraint", BuyerAmount).MaxTextSize = 50

local TargetAmount = Instance.new("TextLabel", Frame)
TargetAmount.Position = UDim2.new(0.32,0,0.19,0)
TargetAmount.Size = UDim2.new(0.29,0,0.11,0)
TargetAmount.TextColor3 = Color3.new(1,1,1)
TargetAmount.BackgroundTransparency = 1
TargetAmount.TextScaled = true
TargetAmount.Font = Enum.Font.SourceSansBold
Instance.new("UITextSizeConstraint", TargetAmount).MaxTextSize = 50

local AltAmount = Instance.new("TextLabel", Frame)
AltAmount.Position = UDim2.new(0.32,0,0.7,0)
AltAmount.Size = UDim2.new(0.29,0,0.11,0)
AltAmount.TextColor3 = Color3.new(1,1,1)
AltAmount.BackgroundTransparency = 1
AltAmount.TextScaled = true
AltAmount.Font = Enum.Font.SourceSansBold
Instance.new("UITextSizeConstraint", AltAmount).MaxTextSize = 50

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
    local cur = getCurrency(buyer)
    BuyerName.Text = settings.BuyerUsername
    BuyerAmount.Text = "Current: "..cur
    TargetAmount.Text = "Target: "..(cur + settings.ExtraAmount)
    AltAmount.Text = "Alt DHC: "..getCurrency(LocalPlayer)
end

RefreshButton.MouseButton1Click:Connect(updateUI)

local function monitorBuyer()
    local settings = getgenv().AutofarmSettings
    if not settings or not settings.BuyerUsername then return end
    local buyer = Players:FindFirstChild(settings.BuyerUsername)
    if buyer and buyer:FindFirstChild("DataFolder") and buyer.DataFolder:FindFirstChild("Currency") then
        if buyerCurrencyConnection then
            buyerCurrencyConnection:Disconnect()
        end
        buyerCurrencyConnection = buyer.DataFolder.Currency:GetPropertyChangedSignal("Value"):Connect(function()
            updateUI()
        end)
    end
end

monitorBuyer()

task.spawn(function()
    while task.wait(1) do
        local settings = getgenv().AutofarmSettings
        local onlineAlts = {}
        for _, uid in ipairs(settings.AltUserIds or {}) do
            local alt = Players:GetPlayerByUserId(uid)
            if alt then
                table.insert(onlineAlts, alt)
            end
        end
        if #onlineAlts >= 2 then
            for _, alt in ipairs(onlineAlts) do
                if lastTarget[alt.UserId] ~= alt.UserId then
                    task.spawn(function()
                        task.wait(1)
                        placeBounty(alt)
                        lastTarget[alt.UserId] = alt.UserId
                    end)
                end
            end
        end
        updateUI()
        monitorBuyer()
    end
end)

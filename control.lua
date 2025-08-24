--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local BOUNTY_REMOTE = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SetBounty")

--// CONSTANTS
local MAX_BOUNTY = 2500000
local TAX_RATE = 0.3

--// STATE
local lastTarget = {}
local buyerCurrencyConnection

--// FUNCTIONS
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

local function placeBounty(targetAlt)
    if not targetAlt or not targetAlt.Character then return end
    local settings = getgenv().AutofarmSettings
    if not settings or not settings.BuyerUsername or not settings.ExtraAmount then return end

    local buyer = Players:FindFirstChild(settings.BuyerUsername)
    if not buyer then return end

    local df = buyer:FindFirstChild("DataFolder")
    local cur = df and df:FindFirstChild("Currency") and df.Currency.Value or 0
    local targetAmount = cur + settings.ExtraAmount
    local remaining = targetAmount - cur
    local bounty = calculateBounty(remaining)

    BOUNTY_REMOTE:InvokeServer(targetAlt.Name, bounty)

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

--// UI SETUP
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AltControlUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Name = "BuyerInfo"
Frame.Size = UDim2.new(0.48, 0, 0.56, 0)
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
AltAmount.Position = UDim2.new(0.32,0,0.19,0)
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

--// UI UPDATE
local function updateUI()
    local settings = getgenv().AutofarmSettings
    if not settings or not settings.BuyerUsername or not settings.ExtraAmount then return end

    local buyer = Players:FindFirstChild(settings.BuyerUsername)
    local cur = 0
    if buyer and buyer:FindFirstChild("DataFolder") and buyer.DataFolder:FindFirstChild("Currency") then
        cur = buyer.DataFolder.Currency.Value
    end
    BuyerName.Text = settings.BuyerUsername
    BuyerAmount.Text = tostring(cur)
    TargetAmount.Text = tostring(cur + settings.ExtraAmount)
    AltAmount.Text = tostring(LocalPlayer.leaderstats and LocalPlayer.leaderstats.DHC and LocalPlayer.leaderstats.DHC.Value or 0)
end

RefreshButton.MouseButton1Click:Connect(updateUI)

--// LIVE BUYER MONEY UPDATE
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

--// MAIN LOOP
task.spawn(function()
    while task.wait(1) do
        local settings = getgenv().AutofarmSettings
        for _, uid in ipairs(settings.AltUserIds or {}) do
            if uid == LocalPlayer.UserId then
                local bounty = getBountyOnMe() -- Implement this to check my bounty
                if bounty > 0 then
                    local buyer = Players:FindFirstChild(settings.BuyerUsername)
                    if buyer and buyer.Character and buyer.Character.PrimaryPart then
                        LocalPlayer.Character:SetPrimaryPartCFrame(buyer.Character.PrimaryPart.CFrame + Vector3.new(0,5,0))
                        placeBounty(LocalPlayer) -- Deliver DHC
                    end
                end
            end
        end
    end
end)

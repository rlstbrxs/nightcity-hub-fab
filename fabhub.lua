Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")
:WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit")

local BaitService = Knit.Services:WaitForChild("BaitService")
local PurchaseBait = BaitService.RF:WaitForChild("PurchaseBait")

local SuppliesService = Knit.Services:WaitForChild("SuppliesService")
local PurchaseItem = SuppliesService.RF:WaitForChild("PurchaseItem")

local player = game.Players.LocalPlayer

local baits = {
    {guiName = "Worm", remoteName = "Worm"},
    {guiName = "Shrimp", remoteName = "Shrimp"},
    {guiName = "Eel", remoteName = "Eel"},
    {guiName = "Kiwi", remoteName = "Kiwi"},
    {guiName = "Banana", remoteName = "Banana"},
    {guiName = "Coffee Beans", remoteName = "CoffeeBeans"},
    {guiName = "Crab", remoteName = "Crab"},
    {guiName = "Squid", remoteName = "Squid"},
    {guiName = "Grape", remoteName = "Grape"},
    {guiName = "Orange", remoteName = "Orange"},
    {guiName = "Tophat", remoteName = "Tophat"},
    {guiName = "Watermelon", remoteName = "Watermelon"},
    {guiName = "Dragonfruit", remoteName = "Dragonfruit"},
    {guiName = "Golden Banana", remoteName = "GoldenBanana"}
}

local items = {
    {guiName = "Rusty Weight Charm", remoteName = "RustyWeightCharm"},
    {guiName = "Rusty Mutation Charm", remoteName = "RustyMutationCharm"},
    {guiName = "Mutation Charm", remoteName = "MutationCharm"},
    {guiName = "Weight Charm", remoteName = "WeightCharm"},
    {guiName = "Mutation Stabilizer", remoteName = "MutationStabilizer"},
    {guiName = "Evolution Crystal", remoteName = "EvolutionCrystal"},
    {guiName = "Overfeed Charm", remoteName = "OverfeedCharm"},
    {guiName = "Keeper's Seal", remoteName = "KeepersSeal"}
}

local autoBuyBaits = {}
local autoBuyItems = {}
local fastFishingEnabled = false

local Window = Rayfield:CreateWindow({
    Name = "nightcity's hub",
    LoadingTitle = "FISH A BRAINROT ",
    LoadingSubtitle = "by nightcityyy",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FishingHub",
        FileName = "Config"
    }
})

local ShopTab = Window:CreateTab("Shop", 4483362458)

local BaitsSection = ShopTab:CreateSection("Auto Buy Baits")
local BaitsDropdown = ShopTab:CreateDropdown({
    Name = "Select Baits",
    Options = {},
    MultipleOptions = true,
    CurrentOption = {},
    Callback = function(selected)
        autoBuyBaits = {}
        for _, bait in ipairs(baits) do
            autoBuyBaits[bait.remoteName] = table.find(selected, bait.guiName) ~= nil
        end
    end
})
for _, bait in ipairs(baits) do
    table.insert(BaitsDropdown.Options, bait.guiName)
end
BaitsDropdown:Refresh(BaitsDropdown.Options, true)

local ItemsSection = ShopTab:CreateSection("Auto Buy Items")
local ItemsDropdown = ShopTab:CreateDropdown({
    Name = "Select Items",
    Options = {},
    MultipleOptions = true,
    CurrentOption = {},
    Callback = function(selected)
        autoBuyItems = {}
        for _, item in ipairs(items) do
            autoBuyItems[item.remoteName] = table.find(selected, item.guiName) ~= nil
        end
    end
})
for _, item in ipairs(items) do
    table.insert(ItemsDropdown.Options, item.guiName)
end
ItemsDropdown:Refresh(ItemsDropdown.Options, true)

local FishingTab = Window:CreateTab("Fishing", 6022668961)

local FishingSection = FishingTab:CreateSection("Fishing")
FishingTab:CreateToggle({
    Name = "Fast Fishing",
    CurrentValue = false,
    Callback = function(value)
        fastFishingEnabled = value
    end
})

local MiscTab = Window:CreateTab("Misc", 6022668961)

local MiscSection = MiscTab:CreateSection("Miscellaneous")
MiscTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {0, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(value)
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end
})

task.spawn(function()
    while task.wait(0.1) do
        for _, bait in ipairs(baits) do
            if autoBuyBaits[bait.remoteName] then
                task.spawn(function()
                    pcall(function()
                        PurchaseBait:InvokeServer(bait.remoteName)
                    end)
                end)
            end
        end
        for _, item in ipairs(items) do
            if autoBuyItems[item.remoteName] then
                task.spawn(function()
                    pcall(function()
                        PurchaseItem:InvokeServer(item.remoteName)
                    end)
                end)
            end
        end
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if fastFishingEnabled then
        local gui = player:FindFirstChild("PlayerGui")
        if gui then
            local fishingGui = gui:FindFirstChild("Fishing")
            if fishingGui then
                local container = fishingGui:FindFirstChild("Container")
                if container then
                    local reelFrame = container:FindFirstChild("ReelFrame")
                    if reelFrame then
                        local reelBar = reelFrame:FindFirstChild("ReelBar")
                        local target = reelFrame:FindFirstChild("Target")
                        if reelBar and target then
                            reelBar.Position = target.Position
                            reelBar.AnchorPoint = target.AnchorPoint
                        end
                    end
                end
            end
        end
    end
end)

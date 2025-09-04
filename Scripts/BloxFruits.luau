local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:Create({
    Name = "Neo hub test",
    Theme = "Dark"
})

local Tab = Window:Tab({
    Name = "Main"
})

local AutoFarm = false

Tab:Toggle({
    Name = "farm",
    Default = false,
    Callback = function(v)
        AutoFarm = v
        if not AutoFarm then return end

        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer

        local HoverHeight = 5
        local PullDistance = 10
        local ActiveQuestMob = nil
        local ScanInterval = 0.2

        local QuestList = {
            {Min=0,Max=9,Mob="Bandit",Quest="BanditQuest"},
            {Min=10,Max=14,Mob="Monkey",Quest="MonkeyQuest"},
            {Min=15,Max=19,Mob="Gorilla",Quest="GorillaQuest"},
            {Min=30,Max=39,Mob="Pirate",Quest="PirateQuest"},
            {Min=40,Max=54,Mob="Brute",Quest="BruteQuest"},
            {Min=60,Max=74,Mob="Desert Bandit",Quest="DesertBanditQuest"},
            {Min=75,Max=89,Mob="Desert Officer",Quest="DesertOfficerQuest"},
            {Min=90,Max=99,Mob="Snow Bandit",Quest="SnowBanditQuest"},
            {Min=100,Max=104,Mob="Snowman",Quest="SnowmanQuest"},
            {Min=120,Max=129,Mob="Chief Petty Officer",Quest="ChiefPettyOfficerQuest"},
            {Min=150,Max=174,Mob="Sky Bandit",Quest="SkyBanditQuest"},
            {Min=175,Max=189,Mob="Dark Master",Quest="DarkMasterQuest"},
            {Min=190,Max=209,Mob="Prisoner",Quest="PrisonerQuest"},
            {Min=210,Max=219,Mob="Dangerous Prisoner",Quest="DangerousPrisonerQuest"},
            {Min=250,Max=274,Mob="Toga Warrior",Quest="TogaWarriorQuest"},
            {Min=275,Max=299,Mob="Gladiator",Quest="GladiatorQuest"},
            {Min=300,Max=324,Mob="Military Soldier",Quest="MilSoldierQuest"},
            {Min=325,Max=349,Mob="Military Spy",Quest="MilSpyQuest"},
            {Min=375,Max=399,Mob="Fishman Warrior",Quest="FishmanWarriorQuest"},
            {Min=400,Max=424,Mob="Fishman Commando",Quest="FishmanCommandoQuest"},
            {Min=450,Max=474,Mob="God's Guards",Quest="GodsGuardQuest"},
            {Min=475,Max=499,Mob="Shandas",Quest="ShandaQuest"},
            {Min=525,Max=549,Mob="Royal Squad",Quest="RoyalSquadQuest"},
            {Min=550,Max=574,Mob="Royal Soldier",Quest="RoyalSoldierQuest"},
            {Min=600,Max=624,Mob="Galley Pirate",Quest="GalleyPirateQuest"},
            {Min=625,Max=649,Mob="Galley Captain",Quest="GalleyCaptainQuest"}
        }

        local function getLevel()
            local d = LocalPlayer:FindFirstChild("Data")
            return d and d:FindFirstChild("Level") and d.Level.Value or 0
        end

        local function getQuest()
            local lv = getLevel()
            for _,q in ipairs(QuestList) do
                if lv >= q.Min and lv <= q.Max then
                    return q
                end
            end
        end

        local function findQuestNPC()
            for _,npc in ipairs(workspace:GetDescendants()) do
                if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChildOfClass("Humanoid") then
                    if string.find(npc.Name, "Quest") or string.find(npc.Name, "Giver") then
                        return npc
                    end
                end
            end
        end

        local function isQuestActive()
            local gui = LocalPlayer:FindFirstChild("PlayerGui")
            local main = gui and gui:FindFirstChild("Main")
            local q = main and main:FindFirstChild("Quest")
            return q and q.Visible
        end

        local function takeQuest(q)
            local npc = findQuestNPC()
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:MoveTo(npc.HumanoidRootPart.Position + Vector3.new(0,3,0))
                ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", q.Quest, 1)
                ActiveQuestMob = q.Mob
            end
        end

        local function findMob()
            if not ActiveQuestMob then return end
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local nearest,dist
            for _,m in ipairs(workspace.Enemies:GetChildren()) do
                if m.Name == ActiveQuestMob and m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 then
                    local hrp = m:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local d = (root.Position - hrp.Position).Magnitude
                        if not dist or d < dist then
                            nearest,dist = m,d
                        end
                    end
                end
            end
            return nearest
        end

        local function noclip()
            local c = LocalPlayer.Character
            if not c then return end
            for _,p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end

        RunService.Stepped:Connect(function()
            if AutoFarm then noclip() end
        end)

        while AutoFarm do
            if not isQuestActive() then
                local q = getQuest()
                if q then takeQuest(q) end
            else
                local mob = findMob()
                if mob and mob:FindFirstChild("HumanoidRootPart") then
                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, HoverHeight, PullDistance * -1)
                        mob.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0,0,-PullDistance)
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("Attack")
                    end
                end
            end
            task.wait(ScanInterval)
        end
    end
})

Library:Init()

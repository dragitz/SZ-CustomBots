BotTick = 0
BotTickMax = 50 -- below 50 doesn't change much

P1_Enabled = true
P2_Enabled = true

P1 = nil
P2 = nil

P1Bot = nil
P2Bot = nil

if not _G.AIInputHooked then


    -- just a function that acts as internal loop, execute once every n BotTickMax
    RegisterHook("/Script/SS.SSBattleLevelScriptActor:GetBattleElapsedTime", function(self)
        BotTick = BotTick + 1
        if BotTick >= BotTickMax then
            UpdateCustomBot()
            BotTick = 0
        end

    end)


    -- disable default bot decisions
    RegisterHook("/Script/SS.SSBattleAIController:CanAiRun", function(self)
        return false
    end)

    -- debug commands
    RegisterHook("/Script/SS.SSAiPadGenerationComponent:InputCommand", function(self, InCommandId, InIndex, InLog, InForced, InOverwriteProtected, InMyNode)
        
        local cmd = InCommandId:get():ToString()
        print("cmd: ", cmd)
        
    end)

    _G.AIInputHooked = true
end


-- find players and system checks
function UpdateCustomBot()

    -- find players and controllers
    if not P1 or not P2 or not P1:IsValid() or not P2:IsValid() then
        
        local allChars = FindAllOf("SSCharacter")
        if not allChars or #allChars ~= 2 then return end

        for _, char in pairs(allChars) do
            if char:IsValid() then
                if char:GetPlayerSide() == 0 then
                    P1 = char
                elseif char:GetPlayerSide() == 1 then
                    P2 = char
                end
            end
        end

        -- ai controller (find only once)
        local allControllers = FindAllOf("SSBattleAIController")
        for _, controller in pairs(allControllers) do
            if controller:IsValid() then
                local side = controller:GetPlaySide()
                if side == 0 then
                    P1Bot = controller
                elseif side == 1 then
                    P2Bot = controller
                end
            end
        end

    end

    -- execute if all good
    if (P1Bot and P1Bot:IsValid()) or (P2Bot and P2Bot:IsValid()) then
        if P1 and P2 then
            if P1:IsValid() and P2:IsValid() then
                RunBotLogic()
            end end
    end
end

function runCommand(padComp, PlaySide)
    local newCmdString = brain(PlaySide)

    -- no checks to see if the command is valid or not, might be necessary
    if newCmdString then

        padComp:InputCommand(
            FName(newCmdString),
            0,
            FName("LuaBot"),  -- tag command as LuaBot, maybe useful for future updates
            true, -- Forced
            true, -- OverwriteProtected
            nil
        )
    end
end
function RunBotLogic()
    
    -- do some player checks before requesting an input
    if P1Bot and P1Bot:IsValid() and P1_Enabled == true then
        local padComp = P1Bot.SSAiPadGeneration
        if not padComp or not padComp:IsValid() then return end
        runCommand(padComp, P1Bot:GetPlaySide())
    end

    if P2Bot and P2Bot:IsValid() and P2_Enabled == true then
        local padComp = P2Bot.SSAiPadGeneration
        if not padComp or not padComp:IsValid() then return end
        runCommand(padComp, P2Bot:GetPlaySide())
    end
end

-- helper function
function getDistance()
    local Pos1 = P1:K2_GetActorLocation()
    local Pos2 = P2:K2_GetActorLocation()

    local distance = math.sqrt(
        (Pos1.X - Pos2.X)^2 +
        (Pos1.Y - Pos2.Y)^2 +
        (Pos1.Z - Pos2.Z)^2
    )

    return distance
end

function brain(PlaySide)


    --[[
    both P1 and P2 contain the SSCharacter data in them
    
    you can get any value like
        P1.HPGaugeValue

    or set them by calling like this:
        P1:SetHPGaugeValue(0)

    
    print(string.format("P1 HP: %.2f | P2 HP: %.2f", P1:GetHPGaugeValue(), P2:GetHPGaugeValue()))

    Valid commands can be found in: EKoratBattleKey (SS_enums.hpp)
    - Note: not all commands are there, this mod is in its very early stages

    ]]--
    -- custom logic here! 

    Skill1Cost = P1:GetSkillStockCost(1)
    Skill2Cost = P1:GetSkillStockCost(2)




    if getDistance() > 400 then
        return "MoveFront" --close distance
    else
        return "MoveBack"
    end
    
    return "None"
end

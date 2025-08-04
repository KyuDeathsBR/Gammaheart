local Game, super = Utils.hookScript(Game)

---@return PartyMember
function Game:getSoulPartyMember()
    ---@type PartyMember?
    local current
    for _,party in ipairs(self.party) do
        if party.priority_type == "ONLY_TARGETED" then
            -- Only return the party member if they are targeted
            if Game.battle then
                
                Kristal.Console:log("Checking party member: " .. party.name.. "with id ".._.." for current selection "..Game.battle.current_selecting)
                if Game.battle.current_selecting == _ then
                    current = party
                else
                    local targetted = false
                    for i,enemy in ipairs(Game.battle:getActiveEnemies()) do
                        if enemy.current_target == party then
                            targetted = true
                        end
                    end
                    if targetted then
                        current = party
                    end
                end
            end 
        end
        if not current or (party:getSoulPriority() > current:getSoulPriority()) and current.priority_type ~= "ONLY_TARGETED" then
            current = party
        elseif current.priority_type == "ONLY_TARGETED" and party.priority_type ~= "ONLY_TARGETED" then
            current = nil
        end
    end
    if not current then
        current = self.party[Game.battle.current_selecting]
    end
    return current
end

function Game:getSoulColor()
    local mr, mg, mb, ma = Kristal.callEvent(KRISTAL_EVENT.getSoulColor)
    if mr ~= nil then
        return mr, mg, mb, ma or 1
    end

    local chara = self:getSoulPartyMember()

    if chara and chara:getSoulPriority() >= 0 then
        local r, g, b, a = chara:getSoulColor()
        return r, g, b, a or 1
    end

    return 1, 0, 0, 1
end

return Game
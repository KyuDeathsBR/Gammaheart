---@class Game
---@field getSoulPartyMember function
---@field getSoulColor function
---@field ally PartyAlly[] Used ingame
---@field ally_data PartyAlly[] Used to store information
---@field hasPartyAlly function
---@field setPartyAllies function
---@field load function
local Game, super = Utils.hookScript(Game)

---@return PartyMember
function Game:getSoulPartyMember()
    ---@type PartyMember?
    local current
    if self.battle then
        for _,party in ipairs(self.battle.party) do
            if not current or (party.chara:getSoulPriority() > current:getSoulPriority()) then
                current = party.chara
            end
            if party.chara.priority_type == "ONLY_TARGETED" then
                -- Only return the party member if they are targeted
                if self.battle.current_selecting == _ then
                    current = party.chara
                    break
                elseif party.targeted then
                    current = party.chara
                    break
                end
            end
        end
    else
        for _,party in ipairs(self.party) do
            if not current or (party:getSoulPriority() > current:getSoulPriority()) then
                current = party
            end
        end
    end
    if not current and self.battle then
        current = self.battle.party[self.battle.current_selecting].chara
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
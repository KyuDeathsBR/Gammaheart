---@class Character : Object
---@field init function
---@field update function
---@field getPartyMember function
---@overload fun(party:PartyMember,actor:Actor|string?,x:number,y:number) : Character Includes a PartyMember argument for modes
local Character, super = Utils.hookScript(Character)

---comment
---@param party PartyMember|Actor? if the value is an actor, it will work similarly to the previous version
---@param ... any[]
function Character:init(party,...)
    if party and party.includes and party:includes(PartyMember) then
        self.party = party.id
        super.init(self,...)
    else
        super.init(self,party,...)
    end
    local party = self:getPartyMember()
    if party then
        party.mode = Mod.mode
    end
end

function Character:update()
    super.update(self)
    local party = self:getPartyMember()
    if party then
        if party.last_mode ~= party.mode then
            party:onModeChange(party.mode,party.last_mode,self)
        end
        party.last_mode = party.mode
    end
end

---@return PartyMember|PartyAlly?
function Character:getPartyMember()
    if self.party then
        return Game:getPartyMember(self.party) or Game:getPartyAlly(self.party)
    end

    for _,party in pairs(Game.party_data) do
        local actor = party:getActor()
        if actor and actor.id == self.actor.id then
            return party
        end
    end
    if Game.ally_data then
        for _,ally in pairs(Game.ally_data) do
            local actor = ally:getActor()
            if actor and actor.id == self.actor.id then
                return ally
            end
        end
    end
end

return Character
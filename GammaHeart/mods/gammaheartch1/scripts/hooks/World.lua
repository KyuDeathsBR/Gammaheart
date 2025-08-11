local World, super = Utils.hookScript(World)

--- Gets the `Follower` or `Player` of a character currently in the party
---@param party string|PartyMember|PartyAlly  The party member to get the character for
---@return Player|Follower?
function World:getPartyCharacterInParty(party)
    if type(party) == "string" then
        party = Game:getPartyMember(party) or Game:getPartyAlly(party)
    end
    if self.player and Game:hasPartyAlly(self.player:getPartyMember()) and party == self.player:getPartyMember() then
        return self.player
    else
        for _,follower in ipairs(self.followers) do
            if Game:hasPartyMember(follower:getPartyMember()) and party == follower:getPartyMember() then
                return follower
            end
        end
    end
end

return World
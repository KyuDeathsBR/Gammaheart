local Character, super = Utils.hookScript(Character)

function Character:update()
    super.update(self)
    local party = self:getPartyMember()
    if party.last_mode ~= party.mode then
        party:onModeChange(party.mode,party.last_mode,self)
    end
    party.last_mode = party.mode
end

return Character
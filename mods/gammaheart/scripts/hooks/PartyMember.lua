---@class PartyMember : Class
---@field mode "LIGHT"|"DARK"|string?
---@field last_mode "LIGHT"|"DARK"|string?
---@field can_transform boolean
---@field transforming boolean?
local PartyMember, super = Utils.hookScript(PartyMember)

function PartyMember:init()
    super.init(self)
    if self.can_transform and not self.mode then
        self.mode = "LIGHT"
    end
end

---comment
---@param mode? "LIGHT"|"DARK"
---@return Actor
function PartyMember:getActor(force_mode)
    if force_mode and type(force_mode) == "string" then
        return ({
            LIGHT=self.lw_actor,
            DARK=self.actor
        })[force_mode]
    end
    if (self.lw_actor and not self.actor) or not self.mode and self.can_transform then
        return self.lw_actor
    end
    return self.mode == "LIGHT" and self.lw_actor or self.actor
end

---comment
---@param new "LIGHT"|"DARK"|string?
---@param old "LIGHT"|"DARK"|string?
---@param character Character|PartyBattler
function PartyMember:onModeChange(new,old,character)
    if character then
        character:setActor(self:getActor())
    end
end

return PartyMember
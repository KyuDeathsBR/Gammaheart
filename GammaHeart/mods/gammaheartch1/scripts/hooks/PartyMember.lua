---@class PartyMember : Class
---@field mode "LIGHT"|"DARK"|string?
---@field last_mode "LIGHT"|"DARK"|string?
---@field can_transform boolean
---@field transforming boolean?
---@field init function
---@field getNameSprite function 
---@field getActor function
---@field priority_type "ONLY_TARGETED"|"DEFAULT"
---@field getName function
---@field onModeChange function
---@field name_translations table<string,string>?
---@field title_translations table<string,string>?
---@field getTitle function
local PartyMember, super = Utils.hookScript(PartyMember)

function PartyMember:init(mode)
    super.init(self)
    self.priority_type = "DEFAULT"
    if self.can_transform and not self.mode then
        self.mode = Mod.mode or mode or "LIGHT"
    end
end

function PartyMember:getNameSprite()
    if Assets.getTexture(self.name_sprite.."/"..Mod.selected_language) then
        return self.name_sprite.."/"..Mod.selected_language
    elseif Assets.getTexture(self.name_sprite.."/default") then
        return self.name_sprite.."/default"
    else
        return super.getNameSprite(self)
    end
end
---@
---@return PartyMemberSaveData
function PartyMember:save()
    local data = super.save(self)
    data.mode = self.mode
    self:onSave(data)
    return data
end

---@param data PartyMemberSaveData
function PartyMember:onLoad(data)
    self.mode = data.mode or self.mode
    self:onModeChange(nil,nil,Game.world:getPartyCharacterInParty(self))
end

---comment
---@param force_mode? "LIGHT"|"DARK"
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

function PartyMember:getName()
    if self.name_translations then
        return self.name_translations[Mod.selected_language] or super.getName(self)
    end
    return super.getName(self)
end

function PartyMember:getTitle()
    if self.title_translations then
        return self.title_translations[Mod.selected_language] or super.getTitle(self)
    end
    return super.getTitle(self)
end

function PartyMember:hasSpells() return (self.mode == "DARK" or Mod.mode == "DARK") and self.has_spells or false end

return PartyMember
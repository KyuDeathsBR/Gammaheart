---@class Spell
---@field getName function
---@field getDescription function
---@field name_translations table<string,string>?
---@field desc_translations table<string,string>?
local Spell, super = Utils.hookScript(Spell)

function Spell:getName()
    if self.name_translations then
        return self.name_translations[Mod.selected_language] or super.getName(self)
    end
    return super.getName(self)
end

function Spell:getDescription()
    if self.desc_translations then
        return self.desc_translations[Mod.selected_language] or super.getDescription(self)
    end
    return super.getDescription(self)
end

return Spell
---@class Item
---@field getName function
---@field getDescription function
---@field getWorldMenuName function
---@field getWorldMenuDescription function
---@field name_translations table<LanguageID,string>
---@field description_translations table<LanguageID,string>
local Item, super = Utils.hookScript(Item)

function Item:getName()
    if self.name_translations then
        return self.name_translations[Mod.selected_language] or super.getName(self)
    end
    return super.getName(self)
end

function Item:getWorldMenuName()
    if self.name_translations then
        return self.name_translations[Mod.selected_language] or super.getWorldMenuName(self)
    end
    return super.getWorldMenuName(self)
end

function Item:getDescription()
    if self.description_translations then
        return self.description_translations[Mod.selected_language] or super.getDescription(self)
    end
    return super.getDescription(self)
end

function Item:getWorldMenuDescription()
    if self.description_translations then
        return self.description_translations[Mod.selected_language] or super.getWorldMenuDescription(self)
    end
    return super.getWorldMenuDescription(self)
end

return Item
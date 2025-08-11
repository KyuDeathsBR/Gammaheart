local Actor, super = Utils.hookScript(Actor)

function Actor:getFont()
    if self.font then
        return self.font
    end
    local id = self.id:gsub("_lw",""):gsub("lw","")
    if Assets.getFont(Mod.selected_language.."_"..id) then
        return Mod.selected_language.."_"..id
    elseif Assets.getFont(Mod.selected_language.."_main") then
        return Mod.selected_language.."_main"
    end
    return super:getFont()
end

return Actor
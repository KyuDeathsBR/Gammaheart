local Textbox, super = Utils.hookScript(Textbox)

function Textbox:init(...)
    super.init(self,...)
    self.font = Assets.getFont(Mod.selected_language.."_main") and Mod.selected_language.."_main" or self.font
end

return Textbox
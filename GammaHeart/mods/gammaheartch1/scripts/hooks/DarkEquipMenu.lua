---@class DarkEquipMenu
---@field init function
---@field stat_translations table<string,table<string,string[]>>
local DarkEquipMenu,super = Utils.hookScript(DarkEquipMenu)

function DarkEquipMenu:init()
    self.language = Mod.selected_language
    super.init(self)
    self.caption_sprites = {
        ["char"] = Assets.getTexture("ui/menu/caption_char/"..Mod.selected_language) or Assets.getTexture("ui/menu/caption_char"),
        ["equipped"] = Assets.getTexture("ui/menu/caption_equipped/"..Mod.selected_language) or Assets.getTexture("ui/menu/caption_equipped"),
        ["stats"] = Assets.getTexture("ui/menu/caption_stats/"..Mod.selected_language) or Assets.getTexture("ui/menu/caption_stats"),
        ["weapons"] = Assets.getTexture("ui/menu/caption_weapons/"..Mod.selected_language) or Assets.getTexture("ui/menu/caption_weapons"),
        ["Amulets"] = Assets.getTexture("ui/menu/caption_amulets/"..Mod.selected_language) or Assets.getTexture("ui/menu/caption_amulets") or Assets.getTexture("ui/menu/caption_weapons"),
        ["armors"] = Assets.getTexture("ui/menu/caption_armors/"..Mod.selected_language) or Assets.getTexture("ui/menu/caption_armors")
    }
    self.stat_translations = {
        attack = {
            default = {"Attack:","attack"},
            ja = {"ＡＴＫ：","ＡＴＫ"},
            es = {"Ataque:","ataque"},
            ["pt-br"] = {"Ataque:","Ataque"},
            LOLCAT = {"ATAK!","ATAK"}
        },
        defense = {
            default = {"Defense:","defense"},
            ja = {"ＤＥＦ：","ＤＥＦ"},
            es = {"Defesa:","defesa"},
            ["pt-br"] = {"Defesa:","defesa"},
            LOLCAT = {"DEFENZ!","DEFENZ"}
        },
        magic = {
            default = {"Magic:","magic"},
            ja = {"ＭＰ：","ＭＰ"},
            es = {"Magia:","magia"},
            ["pt-br"] = {"Magia:","magia"},
            LOLCAT = {"MAJEEK!","MAJEEK"}
        }
    }
    self.font = Assets.getFont(Mod.selected_language.."_main") or self.font
end

function DarkEquipMenu:update()
    super.update(self)
end

---comment
---@param stat string
---@param language string
function DarkEquipMenu:getStatName(stat,language)
    return self.stat_translations[stat] and self.stat_translations[stat][language] and unpack(self.stat_translations[stat][language]) or "ERR", "ERR"
end

function DarkEquipMenu:drawStats()
    local party = self.party:getSelected()
    Draw.setColor(1, 1, 1, 1)
    local attack, attack_preview = self:getStatName("attack",Mod.selected_language)
    local defense, defense_preview = self:getStatName("defense",Mod.selected_language)
    local magic, magic_preview = self:getStatName("magic",Mod.selected_language)
    Draw.draw(self.stat_icons["attack"], -8, 124, 0, 2, 2)
    Draw.draw(self.stat_icons["defense"], -8, 151, 0, 2, 2)
    Draw.draw(self.stat_icons["magic"], -8, 178, 0, 2, 2)
    love.graphics.print(attack, 18, 118)
    love.graphics.print(defense, 18, 145)
    love.graphics.print(magic, 18, 172)
    local stats, compare = self:getStatsPreview()
    self:drawStatPreview(attack_preview, 148, 118, stats, compare, self:getCurrentItemType() == "weapons")
    self:drawStatPreview(defense_preview, 148, 145, stats, compare, false)
    self:drawStatPreview(magic_preview, 148, 172, stats, compare, false)
    local abilities, ability_comp = self:getAbilityPreview()
    for i = 1, 3 do
        self:drawAbilityPreview(i, -8, 178 + (27 * i), abilities, ability_comp)
    end
end

return DarkEquipMenu
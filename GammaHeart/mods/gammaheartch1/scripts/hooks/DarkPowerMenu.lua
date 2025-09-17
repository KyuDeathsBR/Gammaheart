local DarkPowerMenu,super = Utils.hookScript(DarkPowerMenu)

function DarkPowerMenu:init()
    super.init(self)
    self.caption_sprites = {
        ["char"] = Assets.getTexture("ui/menu/caption_char/"..Mod.selected_language) or Assets.getTexture("ui/menu/caption_char"),
        ["stats"] = Assets.getTexture("ui/menu/caption_stats/"..Mod.selected_language) or Assets.getTexture("ui/menu/caption_stats"),
        ["spells"] = Assets.getTexture("ui/menu/caption_spells/"..Mod.selected_language) or Assets.getTexture("ui/menu/caption_spells"),
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

---comment
---@param stat string
---@param language string
function DarkPowerMenu:getStatName(stat,language)
    return self.stat_translations[stat] and self.stat_translations[stat][language] and unpack(self.stat_translations[stat][language]) or "ERR", "ERR"
end

function DarkPowerMenu:drawStats()
    local party = self.party:getSelected()
    local attack, attack_preview = self:getStatName("attack",Mod.selected_language)
    local defense, defense_preview = self:getStatName("defense",Mod.selected_language)
    local magic, magic_preview = self:getStatName("magic",Mod.selected_language)
    Draw.setColor(1, 1, 1, 1)
    Draw.draw(self.stat_icons[ "attack"], -8, 124, 0, 2, 2)
    Draw.draw(self.stat_icons["defense"], -8, 149, 0, 2, 2)
    Draw.draw(self.stat_icons[  "magic"], -8, 174, 0, 2, 2)
    love.graphics.print(attack, 18, 118)
    love.graphics.print(defense, 18, 145)
    love.graphics.print(magic, 18, 172)
    local stats = party:getStats()
    love.graphics.print(stats[ "attack"], 148, 118)
    love.graphics.print(stats["defense"], 148, 143)
    love.graphics.print(stats[  "magic"], 148, 168)
    for i = 1, 3 do
        local x, y = 18, 168 + (i * 25)
        love.graphics.setFont(self.font)
        Draw.setColor(PALETTE["world_text"])
        love.graphics.push()
        if not party:drawPowerStat(i, x, y, self) then
            Draw.setColor(PALETTE["world_dark_gray"])
            love.graphics.print("???", x, y)
        end
        love.graphics.pop()
    end
end

return DarkPowerMenu
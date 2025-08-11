
---@class EnemyBattler : Battler
---@field stunned boolean
---@field init function
---@field getEncounterText function
---@field getEnemyDialogue function
---@field selectWave function
---@field update function
---@field onAct function
---@field ally PartyAlly|string?
---@field recruitable boolean
---@field onTurnEnd function
local EnemyBattler, super = Utils.hookScript(EnemyBattler)

---@param actor?        Actor|string
---@param use_overlay?  boolean
function EnemyBattler:init(actor, use_overlay)
    super.init(self, actor, use_overlay)
    self.stunned = false
    -- Add your override logic here
end

--- Gets the encounter text that should be shown in the battle box if this enemy is chosen for encounter text. Called at the start of each turn.
---@return string? text
function EnemyBattler:getEncounterText()
    local has_spareable_text = self.spareable_text and self:canSpare()

    local priority_spareable_text = Game:getConfig("prioritySpareableText")
    if priority_spareable_text and has_spareable_text then
        if type(self.spareable_text) == "table" then
            return self.spareable_text[Mod.selected_language] or self.spareable_text[1]
        else
            return self.spareable_text
        end
    end

    if self.low_health_text and self.health <= (self.max_health * self.low_health_percentage) then
        if type(self.low_health_text) == "table" then
            return self.low_health_text[Mod.selected_language] or self.low_health_text[1]
        else
            return self.low_health_text
        end
    elseif self.tired_text and self.tired then
        if type(self.tired_text) == "table" then
            return self.tired_text[Mod.selected_language] or self.tired_text[1]
        else
            return self.tired_text
        end

    elseif has_spareable_text then
        if type(self.spareable_text) == "table" then
            return self.spareable_text[Mod.selected_language] or self.spareable_text[1]
        else
            return self.spareable_text
        end
    end
    local text = self.text
    if text[Mod.selected_language] then
        text = text[Mod.selected_language]
    elseif text[1] then
        text = text[1]
    end
    return Utils.pick(text)
end


function EnemyBattler:getEnemyDialogue()
    if type(self.dialogue_override) == "table" then
        local dialogue = self.dialogue_override[Mod.selected_language]
        if type(self.dialogue_override[1]) == "table" and not dialogue then
            dialogue = self.dialogue_override[1]
        elseif not dialogue then
            dialogue = self.dialogue_override
        end
        self.dialogue_override = nil
        return dialogue
    elseif type(self.dialogue_override) == "string" then
        return super.getEnemyDialogue(self)
    end

    local dialogue = self.dialogue[Mod.selected_language]
    if type(self.dialogue[1]) == "table" and not dialogue then
        dialogue = self.dialogue[1]
    elseif not dialogue then
        dialogue = self.dialogue
    end
    return type(dialogue) == "table" and Utils.pick(dialogue) or dialogue
end

--- *(Override)* Selects the wave that this enemy will use each turn.
--- *By default, picks from the available selection provided by [`EnemyBattler:getNextWaves()`](lua://EnemyBattler.getNextWaves)*
---@return string? wave_id
function EnemyBattler:selectWave()
    if not self.stunned then
        return super.selectWave(self)
    end
end

function EnemyBattler:onAct(battler, name)
    if name == ({
                en="Recruit",
                es="Recrutar",
                ["pt-br"]="Recrutar",
                ja="リクルートする",
                LOLCAT="RIKROOT"
            })[Mod.selected_language] then
        if not self.recruit then
            self.recruit = true
            local ally = self.ally
            Game:addPartyAlly(ally)
            local team = Utils.copy(Game.party)
            for i,v in ipairs(Game.ally) do
                table.insert(team,v)
            end
            local x,y = Game.world.camera:getPosition()
            Game.world:spawnParty({x,y},team)
            self:spare()
            return ({
                en=self.actor:getName().." added to your team!",
                es=" ¡"..self.actor:getName().." añadido a tu equipo!",
                ["pt-br"]=self.actor:getName().." adicionado ao seu time!",
                ja=self.actor:getName().."がチームに加わった！",
                LOLCAT=self.actor:getName().." WUZ ADED 2 YUR TEEM!1 YIPPIE "
            })[Mod.selected_language]
        end
    else
        return super.onAct(self,battler,name)
    end
end

function EnemyBattler:update()
    super.update(self)
    if self:canSpare() and self.recruitable and self:getAct(({
                en="Check",
                es="Checar",
                ["pt-br"]="Checar",
                ja="チェックする",
                LOLCAT="SHEK"
            })[Mod.selected_language]) then
        assert(self.ally, "Undefined ally, therefore since its nil we can't run this.")
        self:getAct(({
                en="Check",
                es="Checar",
                ["pt-br"]="Checar",
                ja="チェックする",
                LOLCAT="SHEK"
            })[Mod.selected_language]).name = ({
                en="Recruit",
                es="Recrutar",
                ["pt-br"]="Recrutar",
                ja="リクルートする",
                LOLCAT="RIKROOT"
            })[Mod.selected_language]
    end
end

function EnemyBattler:onTurnEnd()
    if self.stunned and self.stunned_rounds then
        self.stunned_rounds = self.stunned_rounds - 1
        if self.stunned_rounds <= 0 then
            self.stunned = false
            self.stunned_rounds = nil
        end
    end
end

---Creates a custom status message for the enemy.
---@param text string
---@param font? string
---@param color? table
---@param kill? boolean
---@param x? number
---@param y? number
---@return StatusMessage
function EnemyBattler:customStatusMessage(text,font, color, kill,x,y)
    local x, y = self:getRelativePos(x or self.width/2,y or self.height/2)

    local offset = 0
    if not kill then
        offset = (self.hit_count * 20)
    end
    local function getFont()
        if font and not font:match("statustext_") then
            return "statustext_"..font
        end
    end
    local percent = StatusMessage(font and getFont() or "statustext", text, x + 4, y + 20 - offset, color)
    if kill then
        percent.kill_others = true
    end
    self.parent:addChild(percent)

    if not kill then
        self.hit_count = self.hit_count + 1
    end

    return percent
end

function EnemyBattler:stun(rounds)
    self.stunned = true
    self.stunned_rounds = rounds or 1
    local status = self:customStatusMessage("STUNNED","gradient",{0.5,0.7,0.9})
end

return EnemyBattler
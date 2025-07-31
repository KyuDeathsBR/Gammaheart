
---@class EnemyBattler : Battler
---@field stunned boolean
local EnemyBattler, super = Utils.hookScript(EnemyBattler)

---@param actor?        Actor|string
---@param use_overlay?  boolean
function EnemyBattler:init(actor, use_overlay)
    super.init(self, actor, use_overlay)
    self.stunned = false
    -- Add your override logic here
end

--- *(Override)* Selects the wave that this enemy will use each turn.
--- *By default, picks from the available selection provided by [`EnemyBattler:getNextWaves()`](lua://EnemyBattler.getNextWaves)*
---@return string? wave_id
function EnemyBattler:selectWave()
    if not self.stunned then
        return super.selectWave(self)
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

function EnemyBattler:customStatusMessage(text,font, color, kill,x,y)
    local x, y = self:getRelativePos(x or self.width/2,y or self.height/2)

    local offset = 0
    if not kill then
        offset = (self.hit_count * 20)
    end

    local percent = StatusMessage(font or "statustext", text, x + 4, y + 20 - offset, color)
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
    local status = self:customStatusMessage("STUNNED")
end

return EnemyBattler
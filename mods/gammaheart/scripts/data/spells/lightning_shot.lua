local spell, super = Class(Spell, "lightning_shot")

function spell:init()
    super.init(self)
    -- Display name
    self.name = "Lightning Shot"
    -- Name displayed when cast (optional)
    self.cast_name = nil
    self.cast_anim = "battle/lightning_shot"
    self.select_anim = "battle/lightning_shot_ready/loop"
    -- Battle description
    self.effect = "Stun\nEnemy"
    -- Menu description
    self.description = "Shape your claws like a gun, then\n fire a powerful lightning blast."

    -- TP cost
    self.cost = 32

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"stun"}
end

function spell:onCast(user,target)
    if #Game.battle.party > 1 then
        user:setAnimation(self.cast_anim, function()
            if target.actor.animations["electrocuted"] then
                target:setAnimation("electrocuted")
            end
            if #Game.battle.enemies > 1 then
                target:stun(3)
            end
            target:hurt(user.chara:getStat("magic",10,false))
            Game.battle:finishAction()
        end)
    else
        Game.battle.timer:after(1, function()
            user:setAnimation(self.cast_anim, function()
                if target.actor.animations["electrocuted"] then
                    target:setAnimation("electrocuted")
                end
                if #Game.battle.enemies > 1 then
                    target:stun(3)
                end
                target:hurt(user.chara:getStat("magic",10,false))
                Game.battle:finishAction()
            end)
        end)
    end
    return false
end

--- Called at the start of a spell cast, manages internal functionality \
--- Don't use this function for spell effects - see [`Spell:onCast()`](lua://Spell.onCast) instead
---@param user PartyBattler
---@param target Battler[]|EnemyBattler|PartyBattler|EnemyBattler[]|PartyBattler[]
function spell:onStart(user, target)
    Game.battle:battleText(self:getCastMessage(user, target))
    user:setAnimation("battle/lightning_shot_ready", function()
        Game.battle:clearActionIcon(user)
        local result = self:onCast(user, target)
        if result or result == nil then
            Game.battle:finishActionBy(user)
        end
    end)
end

return spell
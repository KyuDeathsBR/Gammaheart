---@class ActionBoxDisplay : Object
---@overload fun(...) : ActionBoxDisplay
local ActionBoxDisplay, super = Class(Object)

---Creates the class
---@param actbox ActionBox
---@param x number
---@param y number
function ActionBoxDisplay:init(actbox, x, y)
    super.init(self, x, y)

    self.font = Assets.getFont("smallnumbers")
    self.sprite_anims = {path="open_box",open={{1,2,3,4},1/12,false,"opened"},opened={{4},1/12,true},close={{4,3,2,1},1/12,false,"closed"},closed={{1},1/12,true}}
    self.sprite = Sprite(nil,x,y,nil,nil,"ui/battle/player")
    self.sprite:setScaleOrigin(0,1.2)
    self.sprite.scale_x = 2
    self.sprite.scale_y = 2
    actbox:addChild(self.sprite)
    self.actbox = actbox
    self.sprite.color = {self.actbox.battler.chara:getColor()}
    self.animation = nil
end

---Sets the sprite, if there is another sprite after it loads that sprite too.
---@param id string
function ActionBoxDisplay:setAnimation(id)
    for i, value in pairs(self.sprite_anims) do
        if i ~= "path" and id == i then
            self.sprite:setAnimation({self.sprite_anims.path,value[2],value[3],frames=value[1]})
            self.animation = id
        end
    end
end

function ActionBoxDisplay:draw()
    local total = Utils.contains(Game.battle.state,"SELECT") and Game.battle.current_selecting or ({
        ACTING = Game.battle.current_action_index,
        ATTACKING = self.actbox.index,
        BATTLETEXT = self.actbox.index
    })[Game.battle.state] or 0
    local check1 = (not Utils.containsValue({"ATTACKING","PARTYSELECT","ACTIONSELECT","ENEMYSELECT","MENUSELECT","INTRO","TRANSITION","ACTING","BATTLETEXT"},Game.battle.state)) or (total > #Game.battle.party or total <= 0)
    if total == self.actbox.index and self.animation ~= "open" then
        self:setAnimation("open")
    elseif total ~= 0 and total < self.actbox.index and self.animation ~= "close" and self.animation ~= "closed"  then
        if self.animation == "open" then
            self:setAnimation("close")
        else
            self:setAnimation("closed")
        end
    elseif check1 and self.animation ~= nil and self.animation ~= "close" then
        self:setAnimation("close")
    end
    --[[if Game.battle.current_selecting == self.actbox.index then
        Draw.setColor(self.actbox.battler.chara:getColor())
    else
        Draw.setColor(PALETTE["action_strip"], 1)
    end

    love.graphics.setLineWidth(2)
    love.graphics.line(0  , Game:getConfig("oldUIPositions") and 2 or 1, 213, Game:getConfig("oldUIPositions") and 2 or 1)

    love.graphics.setLineWidth(2)
    if Game.battle.current_selecting == self.actbox.index then
        love.graphics.line(1  , 2, 1,   36)
        love.graphics.line(212, 2, 212, 36)
    end
    ]]


    local xa, xb,ya,yb,wa,wb,t  = -self.sprite.width/4,108,self.sprite.height,-36,self.sprite.width*9/4,64,#(self.sprite.frames or {1})
    local delta = t-self.sprite.frame
    local y = (delta*ya)/t+(yb*self.sprite.frame)/t
    local x = (delta*xa)/t+(xb*self.sprite.frame)/t
    local w = (delta*wa)/t+(wb*self.sprite.frame)/t
    --Draw.setColor(PALETTE["action_fill"])
    --love.graphics.rectangle("fill", 2, Game:getConfig("oldUIPositions") and 3 or 2, 209, Game:getConfig("oldUIPositions") and 34 or 35)

    Draw.setColor(PALETTE["action_health_bg"])
    love.graphics.rectangle("fill", x,y,  w, 9)

    local health = (self.actbox.battler.chara:getHealth() / self.actbox.battler.chara:getStat("health")) * w

    if health > 0 then
        Draw.setColor(self.actbox.battler.chara:getColor())
        love.graphics.rectangle("fill", x, y, math.ceil(health), 9)
    end

    local color = PALETTE["action_health_text"]
    if health <= 0 then
        color = PALETTE["action_health_text_down"]
    elseif (self.actbox.battler.chara:getHealth() <= (self.actbox.battler.chara:getStat("health") / 4)) then
        color = PALETTE["action_health_text_low"]
    else
        color = PALETTE["action_health_text"]
    end


    local health_offset = 0
    health_offset = (#tostring(self.actbox.battler.chara:getHealth()) - 1) * 8

    Draw.setColor(color)
    love.graphics.setFont(self.font)
    love.graphics.print(self.actbox.battler.chara:getHealth(), x + w/4 - health_offset, y - self.actbox.data_offset)
    Draw.setColor(PALETTE["action_health_text"])
    love.graphics.print("/", x + w/4 + 9, y - self.actbox.data_offset)
    local string_width = self.font:getWidth(tostring(self.actbox.battler.chara:getStat("health")))
    Draw.setColor(color)
    love.graphics.print(self.actbox.battler.chara:getStat("health"), x + w/4 + string_width + 9, y  - self.actbox.data_offset)

    super.draw(self)
end

return ActionBoxDisplay
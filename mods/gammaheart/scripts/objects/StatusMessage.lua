---@class StatusMessage : DamageNumber
---@overload fun(...) : StatusMessage
local StatusMessage, super = Class(DamageNumber)


function StatusMessage:init(font, arg, x, y, color)
    super.super.init(self, x, y)

    self:setOrigin(1, 0)

    self.color = color or {1, 1, 1}

    -- Halfway between UI and the layer above it
    self.layer = BATTLE_LAYERS["damage_numbers"]

    self:setDisplay(font, arg, true)

    self.timer = 0
    self.delay = 2
    self.kill_delay = 0

    self.bounces = 0

    self.stretch = 0.2
    self.stretch_done = false

    self.start_x = nil
    self.start_y = nil

    self.physics.speed_x = 0
    self.physics.speed_y = 0
    self.start_speed_y = 0

    self.kill_timer = 0
    self.killing = false
    self.kill = 0

    self.do_once = false

    self.kill_others = false
    self.kill_condition = function ()
        return true
    end
    self.kill_condition_succeed = false
end

function StatusMessage:setDisplay(font, arg, set_color)
    self.amount = nil
    self.message = nil
    self.texture = nil
    self.text = arg

    self.type = type or "msg"
    self.font = Assets.getFont(font)
    if set_color then
        self.color = {self.color[1] * 0.75, self.color[2] * 0.75, self.color[3] * 0.75}
    end
    
    self.width = self.font:getWidth(self.text)
    self.height = self.font:getHeight()
end

return StatusMessage
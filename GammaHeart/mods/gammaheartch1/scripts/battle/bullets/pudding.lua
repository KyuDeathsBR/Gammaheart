local Pudding, super = Class(Bullet)

---@alias BulletMode "HEAL"|"NORMAL_DAMAGE"|"STRONG_DAMAGE"

---@param x number
---@param y number
---@param mode BulletMode
---@param start_speed number?
---@param max_speed number?
function Pudding:init(x, y,mode, start_speed, max_speed)
    super.init(self, x, y, "bullets/pudding/"..mode:lower())
    ---@type BulletMode
    self.mode = mode
    local cx, cy = Game.battle.arena:getCenter()
    self.flag_dir = x<cx
    self.original_dir = math.pi*(self.flag_dir and 1 or 3)/4
    self.physics.direction = self.original_dir
    self.max_speed = max_speed or 16
    self.physics.speed = start_speed or 4
end

function Pudding:update()
    -- For more complicated bullet behaviours, code here gets called every update
    if self.y < Game.battle.arena.bottom then
        if not self.upwards and self.physics.speed >= 0 then
            self.physics.speed = Utils.clamp(self.physics.speed + DT * math.max(math.abs(self.physics.speed),4),-self.max_speed,self.max_speed)
            self.physics.direction = Utils.approach(self.physics.direction,self.flag_dir and math.pi/2 or -math.pi/2,math.rad(1/2))
        elseif self.physics.speed >= 0 then
            self.physics.speed = Utils.clamp(self.physics.speed - DT * math.max(math.abs(self.physics.speed),4),-self.max_speed,self.max_speed)
            self.physics.direction = Utils.approach(self.physics.direction,self.flag_dir and math.pi*2+math.pi/4 or -math.pi/2,math.rad(4))
        end
    else
        self.physics.direction = math.pi+math.pi*(self.flag_dir and 3 or 1)/4
        self.upwards = true
        self.physics.speed = self.max_speed/2
    end
    super.update(self)
end

function Pudding:getDamage()
    local damage = 5*Utils.random(2,4,1)
    if self.mode == "HEAL" then
        return -damage
    elseif self.mode == "STRONG_DAMAGE" then
        return Utils.round(damage * 1.618,5)      
    else
        return damage 
    end
end

return Pudding
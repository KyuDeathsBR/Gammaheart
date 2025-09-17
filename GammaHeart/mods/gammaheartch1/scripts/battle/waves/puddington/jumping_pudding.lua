local JumpingPudding, super = Class(Wave)

function JumpingPudding:onStart()
    -- Every 0.33 seconds...
    self.timer:every(1/2, function()
        -- Our X position is offscreen, to the right
        local arena = Game.battle.arena
        local x = Utils.random(arena.left-16,arena.right+16,0.5) 
        -- Get a random Y position between the top and the bottom of the arena
        local y = arena.top -16 + Utils.random(0,arena.height/4,1)

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        local bullet = self:spawnBullet("pudding", x, y,"NORMAL_DAMAGE")

        self.timer:after(1,function()
            bullet:fadeOutAndRemove()
        end)
        -- Dont remove the bullet offscreen, because we spawn it offscreen
        bullet.remove_offscreen = false
    end)
end

function JumpingPudding:update()
    -- Code here gets called every frame

    super.update(self)
end

return JumpingPudding
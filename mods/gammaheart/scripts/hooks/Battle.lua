---@class Battle
---@field background_image love.Image
---@field background_sprite Sprite[]
---@field colors table[]
local Battle, super = Utils.hookScript(Battle)

function Battle:drawBackground()
    Draw.setColor(0, 0, 0, self.transition_timer / 10)
    love.graphics.rectangle("fill", -8, -8, SCREEN_WIDTH+16, SCREEN_HEIGHT+16)

    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(1)

    self.background_image = self.background_image or Assets.getTexture("battle/backgrounds/pumpkins")
    self.colors = self.colors or {
        {0.5,0,0.5},
        {0.5,0,0.5},
    }
    if not self.background_sprite then
        self.background_sprite = {}
        for i=1,#self.colors do
            self.background_sprite[i] = Sprite(self.background_image, 0, 0)
            self.background_sprite[i]:setScale(2,2)
            self.background_sprite[i]:setColor(self.colors[i][1], self.colors[i][2], self.colors[i][3], (1/(2*i))*self.transition_timer/10)
            self.background_sprite[i].wrap_texture_x = true
            self.background_sprite[i].wrap_texture_y = true
            self.background_sprite[i].physics.speed_x = 0.5*((-1)^(i+1))
            self.background_sprite[i].physics.speed_y = 0.5*((-1)^(i+1))
            self.background_sprite[i]:setLayer(BATTLE_LAYERS["bottom"]+#self.colors-i)
            Game.battle:addChild(self.background_sprite[i])
        end
    end
    for i,spr in ipairs(self.background_sprite) do
        spr.alpha = (1/(2*i))*self.transition_timer/10
    end
end

return Battle
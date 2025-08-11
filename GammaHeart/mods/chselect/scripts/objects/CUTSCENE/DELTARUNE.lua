local DELTARUNE, super = Class(Object)

function DELTARUNE:init()
	super:init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self.logo = Assets.getTexture("IMAGE_LOGO/IMAGE_LOGO")
    self.logo_heart = Assets.getTexture("IMAGE_LOGO/IMAGE_LOGO_HEART")

    -- We'll draw the logo on a canvas, then resize it 2x
    self.logo_canvas = love.graphics.newCanvas(320,240)
    self.logo_canvas:setFilter("nearest", "nearest")
end

function DELTARUNE:onAddToStage()
    self.animation_done = false

    self.w = self.logo:getWidth()
    self.h = self.logo:getHeight()

    self.noise = Assets.getSound("AUDIO_INTRONOISE_ch1")
    self.noise:play()

    self.siner = 0
    self.factor = 1
    self.factor2 = 0
    self.x = 32
    self.y = 60
    self.animation_phase = 0
    self.animation_phase_timer = 0
    self.animation_phase_plus = 0
    self.logo_alpha = 1
    self.logo_alpha_2 = 1
    self.skipped = false
    self.skiptimer = 0

    self.fader_alpha = 0

    self.done = false
end

function DELTARUNE:drawScissor(image, left, top, width, height, x, y, alpha)
    love.graphics.push()

    local scissor_x = ((math.floor(x) >= 0) and math.floor(x) or 0)
    local scissor_y = ((math.floor(y) >= 0) and math.floor(y) or 0)
    love.graphics.setScissor(scissor_x, scissor_y, width, height)

    Draw.setColor(1, 1, 1, alpha)
    Draw.draw(image, math.floor(x) - left, math.floor(y) - top)
    Draw.setColor(1, 1, 1, 1)
    love.graphics.setScissor()
    love.graphics.pop()
end

function DELTARUNE:drawSprite(image, x, y, alpha)
    love.graphics.push()
    love.graphics.setScissor()

    Draw.setColor(1, 1, 1, alpha)
    Draw.draw(image, math.floor(x), math.floor(y), 0, 1, 1, image:getWidth() / 2, image:getHeight() / 2)
    Draw.setColor(1, 1, 1, 1)
    love.graphics.pop()
end

function DELTARUNE:draw()
    local dt_mult = DT * 15

    -- We need to draw the logo on a canvas
    Draw.pushCanvas(self.logo_canvas)
    love.graphics.clear()

    if (self.animation_phase == 0) then
        self.siner = self.siner + 1 * dt_mult
        self.factor = self.factor - (0.003 + (self.siner / 900)) * dt_mult
        if (self.factor < 0) then
            self.factor = 0
            self.animation_phase = 1
        end
        for i = 0, self.h - 1 do
            self.ia = ((self.siner / 25) - (math.abs((i - (self.h / 2))) * 0.05))
            self.xoff = ((40 * math.sin(((self.siner / 5) + (i / 3)))) * self.factor)
            self.xoff2 = ((40 * math.sin((((self.siner / 5) + (i / 3)) + 0.6))) * self.factor)
            self.xoff3 = ((40 * math.sin((((self.siner / 5) + (i / 3)) + 1.2))) * self.factor)
            self:drawScissor(self.logo, 0, i, self.w, 2, (self.x + self.xoff), (self.y + i), ((1 - self.factor) / 2))
            self:drawScissor(self.logo, 0, i, self.w, 2, (self.x + self.xoff2), (self.y + i), ((1 - self.factor) / 2))
            self:drawScissor(self.logo, 0, i, self.w, 2, (self.x + self.xoff3), (self.y + i), ((1 - self.factor) / 2))
        end
    end
    if (self.animation_phase == 1) then
        self:drawSprite(self.logo, self.x + (self.w / 2), self.y + (self.h / 2), self.logo_alpha)
        self.animation_phase_timer = self.animation_phase_timer + 1 * dt_mult
        if (self.animation_phase_timer >= 30) then
            self.siner = 0
            self.factor = 0
            self.animation_phase = 2
            --self.end_noise:play()
        end
    end
    if (self.animation_phase == 2) then
        if (self.animation_phase_plus == 0) then
            self.siner = self.siner + 0.5 * dt_mult
        end
        if (self.siner >= 20) then
            self.animation_phase_plus = 1
        end
        if (self.animation_phase_plus == 1) then
            self.siner = self.siner + 0.5 * dt_mult
            self.logo_alpha = self.logo_alpha - 0.02 * dt_mult
            self.logo_alpha_2 = self.logo_alpha_2 - 0.08 * dt_mult
        end

        self:drawSprite(self.logo, self.x + (self.w / 2), self.y + (self.h / 2), self.logo_alpha_2)
        self.mina = (self.siner / 30)
        if (self.mina >= 0.14) then
            self.mina = 0.14
        end
        self.factor2 = self.factor2 + 0.05 * dt_mult
        for i = 0, 9 do
            self:drawSprite(self.logo,
                            ((self.x + (self.w / 2)) - (math.sin(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            ((self.y + (self.h / 2)) - (math.cos(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            (self.mina * self.logo_alpha))
            self:drawSprite(self.logo,
                            ((self.x + (self.w / 2)) + (math.sin(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            ((self.y + (self.h / 2)) - (math.cos(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            (self.mina * self.logo_alpha))
            self:drawSprite(self.logo,
                            ((self.x + (self.w / 2)) - (math.sin(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            ((self.y + (self.h / 2)) + (math.cos(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            (self.mina * self.logo_alpha))
            self:drawSprite(self.logo,
                            ((self.x + (self.w / 2)) + (math.sin(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            ((self.y + (self.h / 2)) + (math.cos(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            (self.mina * self.logo_alpha))
        end
        self:drawSprite(self.logo_heart, self.x + (self.w / 2), self.y + (self.h / 2), self.logo_alpha)
        if (self.logo_alpha <= -0.5 and self.skipped == false) then
            self.animation_done = true
        end
    end

    -- Reset canvas to draw to
    Draw.popCanvas()

    -- Draw the canvas on the screen scaled by 2x
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.logo_canvas, 0, 0, 0, 2, 2)

    if self.skipped then
        -- Draw the screen fade
        love.graphics.setColor(0, 0, 0, self.fader_alpha)
        love.graphics.rectangle("fill", 0, 0, 640, 480)

        if self.fader_alpha > 1 then
            self.animation_done = true
            self.noise:stop()
        end

        -- Change the fade opacity for the next frame
        self.fader_alpha = math.max(0,self.fader_alpha + (0.04 * dt_mult))
        self.noise:setVolume(math.max(0, 1 - self.fader_alpha))
    end

    -- Reset the draw color
    love.graphics.setColor(1, 1, 1, 1)
    Game.world.timer:after(0.75, function()
        self.done = true
    end)
end

function DELTARUNE:isOver()
    return self.done
end

return DELTARUNE
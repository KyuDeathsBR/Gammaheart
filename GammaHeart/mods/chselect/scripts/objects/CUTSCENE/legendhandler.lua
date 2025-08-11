local LegendHandler, super = Class(Object, "LegendHandler")

function LegendHandler:init()
    super:init(self)

    self.parallax_x = 0
    self.parallax_y = 0

    self.layers = {
        ["panel"]   = 5,
        ["panel_2"] = 10,
        ["cover"]   = 15,
        ["fade" ]   = 20,
        ["text" ]   = 25
    }

    self.cover = self:addChild(Sprite("intro/chapter_1/cover"))
    self.cover.layer = self.layers["cover"]

    self.cover:setOrigin(0, 0)
    self.cover:setScale(1)

    self.cover.visible = true

    self.panel = self:addChild(Sprite())
    self.panel.layer = self.layers["panel"]

    self.panel:setOrigin(0, 0)
    self.panel:setScale(2)

    self.panel_2 = self:addChild(Sprite())
    self.panel_2.layer = self.layers["panel_2"]

    self.panel_2:setOrigin(0, 0)
    self.panel_2:setScale(2)
    self.panel_2.alpha = 0

    self.fade = self:addChild(Rectangle(0, 0, 640, 480))
    self.fade:setColor(0, 0, 0)
    self.fade.layer = self.layers["fade"]
    self.fade.alpha = 0

    self.fade:setOrigin(0, 0)

    self.music = Music("legend", 1, 0.95)
    self.music.source:setLooping(false)

    self.timer = Timer()
    self:addChild(self.timer)

    self.x_timer = 0
    self.y_timer = 0

    self.slide = 1

    self.x_offset = 0
    self.y_offset = 0

    self.chunk_fade = false
    self.chunk_amount = 1
    self.fade_speed = 0.02

    self.panel_chunk_fade = false
    self.panel_chunk_amount = 0
    self.panel_alpha = 0

    self.move_x = false

    self.done = false
end

function LegendHandler:onAddToStage(stage)
    self.music:play()

    self.cutscene = LegendCutscene((function(cutscene) self:handleCutscene(cutscene) end), self.can_skip, self)
end

function LegendHandler:update()
    if self.cutscene then
        if not self.cutscene.ended then
            self.cutscene:update()
            if self.stage == nil then
                return
            end
        else
            self.cutscene = nil
        end
    end

    if self.slide == 1 then
        self.panel:set("intro/chapter_1/image_1")
        self.panel.x = 60 * 2
        self.panel.y = (48 + self.y_offset) * 2
        self.y_timer = self.y_timer + DTMULT

        if (self.y_timer >= 4) and (self.y_offset > -260) then
            self.y_timer = self.y_timer - 4
            self.y_offset = self.y_offset - 2

            if self.y_offset <= -260 then
                self.y_offset = -260

                self.timer:after(40/30, function()
                    self.music:pause()
                end)
                self.timer:after(100/30, function()
                    self.chunk_fade = true

                    --chunkfade = 1
                    --alarm[4] = 90
                end)
                self.timer:after(140/30, function()
                    self.cutscene:removeText()
                end)
                self.timer:after(190/30, function()
                    self.slide = 2
                end)
            end
        end
    elseif self.slide == 7 then
        self.panel.x = (60 + self.x_offset) * 2
        self.panel.y = (28 + self.y_offset) * 2
        self.y_timer = self.y_timer + DTMULT

        if (self.y_timer >= 4) and (self.y_offset > -110) then
            self.y_timer = self.y_timer - 4
            self.y_offset = self.y_offset - 2

            if self.y_offset <= -110 then
                self.y_offset = -110
            end
        end

        if self.move_x then
            self.x_timer = self.x_timer + DTMULT
            if (self.x_offset > -60) and (self.x_timer >= 4) then
                self.x_timer = self.x_timer - 4
                self.x_offset = self.x_offset - 2
            end
        end
    end

    if self.panel_chunk_fade then
        self.panel_chunk_amount = math.min(self.panel_chunk_amount + (0.05 * DTMULT), 1)

        self.panel_2.alpha = 0
        if (self.panel_chunk_amount >= 0.25) then
            self.panel_2.alpha = 0.25
        end
        if (self.panel_chunk_amount >= 0.5) then
            self.panel_2.alpha = 0.5
        end
        if (self.panel_chunk_amount >= 0.75) then
            self.panel_2.alpha = 0.75
        end
        if (self.panel_chunk_amount >= 1) then
            self.panel_2.alpha = 1
        end
    end










    if (not self.chunk_fade) and (self.chunk_amount > 0) then
        self.chunk_amount = math.max(self.chunk_amount - (self.fade_speed * DTMULT), 0)
    elseif self.chunk_fade and (self.chunk_amount < 1) then
        self.chunk_amount = math.min(self.chunk_amount + (self.fade_speed * DTMULT), 1)
    end

    self.fade.alpha = 0
    if (self.chunk_amount >= 0.25) then
        self.fade.alpha = 0.25
    end
    if (self.chunk_amount >= 0.5) then
        self.fade.alpha = 0.5
    end
    if (self.chunk_amount >= 0.75) then
        self.fade.alpha = 0.75
    end
    if (self.chunk_amount >= 1) then
        self.fade.alpha = 1
    end

    super:update(self)
end

function LegendHandler:draw()
    love.graphics.setColor(COLORS.black)
    love.graphics.rectangle("fill", 0, 0, 640, 480)
    super:draw(self)
end

function LegendHandler:isOver()
    return self.done
end

function LegendHandler:setPanelPos(type)
    local x, y = 0, 0
    if type == "small" then
        x, y = 60 * 2, 28 * 2
    elseif type == "top_left" then
        x, y = 0, 0
    end
    self.panel.x = x
    self.panel.y = y
    self.panel_2.x = x
    self.panel_2.y = y
end

function LegendHandler:handleCutscene(cutscene)
    self.slide = 1
    cutscene:wait(6/30)
    cutscene:setSpeed(1/3)
    cutscene:text("Once upon a time, a LEGEND\nwas whispered among shadows.", "far_left")
    cutscene:wait(214/30)
    cutscene:removeText()
    cutscene:text("It was\na LEGEND\nof HOPE.", "far_left")
    cutscene:text("It was\na LEGEND\nof DREAMS.", "far_right")
    cutscene:wait(120/30)
    cutscene:removeText()
    cutscene:text("It was\na LEGEND\nof LIGHT.", "far_left")
    cutscene:text("It was\na LEGEND\nof DARK.", "far_right")
    cutscene:wait(120/30)
    cutscene:removeText()
    cutscene:text("This is the legend of\n   [wait:15]  DELTA RUNE", "left")
    cutscene:setSpeed(1/2)
    cutscene:wait(120/30)
    cutscene:wait(function() return self.slide == 2 end)
    self.music:seek(19.656)
    self.music:play()
    self.chunk_fade = false
    self.panel:set("intro/chapter_1/image_2_1")
    self.panel_2:set("intro/chapter_1/image_2_2")
    cutscene:setSpeed(1/2)
    self:setPanelPos("small")
    cutscene:text({"For millenia, LIGHT and DARK\nhave lived in balance,[wait:40][next]", "[speed:0.5][voice:nil] Bringing peace to the WORLD."}, "far_left")
    cutscene:wait(270/30)
    cutscene:removeText()
    cutscene:text("But if this harmony\nwere to shatter...", "left")
    cutscene:wait(6/30)
    self.panel_chunk_fade = true
    self.panel_chunk_amount = 0
    cutscene:wait(120/30)
    self.chunk_fade = true
    cutscene:wait(10/30)
    cutscene:removeText()
    cutscene:text("A terrible calamity would occur.", "top_left")
    cutscene:wait(80/30)
    self.panel:set()
    self.panel_2:set()
    self.chunk_fade = false
    self.fade_speed = 0.2
    cutscene:wait(20/30)
    self.chunk_fade = true
    self.fade_speed = 0.03
    self.fade:setColor(COLORS.white)
    cutscene:wait(45/30)
    cutscene:removeText()
    cutscene:text("The sky will run\nblack with terror", "middle_bottom")

    self.cover.visible = false
    self.fade_speed = 0.05
    self.slide = 3
    self.chunk_fade = false
    self.panel_chunk_fade = false
    self.panel_chunk_amount = 0
    self.panel:set("intro/chapter_1/image_3")
    self:setPanelPos("top_left")
    cutscene:wait(138/30)
    cutscene:removeText()
    cutscene:text("And the land will\ncrack with fear.", "middle_bottom")
    cutscene:wait(138/30)
    cutscene:removeText()
    cutscene:text("Then,[wait:5] her heart pounding...", "left_bottom")
    cutscene:wait(138/30)
    cutscene:removeText()
    cutscene:text("The EARTH will draw\nher final breath.", "middle_bottom")
    cutscene:wait(106/30)
    self.fade_speed = 0.04
    self.fade:setColor(COLORS.black)
    self.chunk_fade = true
    cutscene:wait(31/30)
    cutscene:removeText()
    self.slide = 4
    cutscene:text("Only then,[wait:5] shining with hope...", "far_left_bottom")
    self.panel:set("intro/chapter_1/image_4_1")
    self.panel_2:set("intro/chapter_1/image_4_2")
    self.panel_chunk_amount = 0
    self.panel_chunk_fade = false
    self.chunk_fade = false
    self.panel_2.alpha = 0
    cutscene:wait(138/30)
    self.panel_chunk_fade = true
    cutscene:removeText()
    cutscene:text("Three HEROES appear\nat WORLDS' edge.", "middle_bottom")
    cutscene:wait(108/30)
    self.fade_speed = 0.04
    self.fade:setColor(COLORS.black)
    self.chunk_fade = true
    cutscene:wait(31/30)
    cutscene:removeText()
    self.panel_chunk_amount = 0
    self.panel_chunk_fade = false
    self.panel_2.alpha = 0
    self.chunk_fade = false
    self.slide = 5
    self.panel:set("intro/chapter_1/image_5_1")
    self.panel_2:set("intro/chapter_1/image_5_2")
    cutscene:wait(4/30)
    cutscene:text("A HUMAN,", "text_human")
    cutscene:wait(65/30)
    cutscene:text("A MONSTER,", "text_monster")
    self.panel_chunk_fade = true
    cutscene:wait(69/30)
    self.panel:set("intro/chapter_1/image_5_2")
    self.panel_2:set("intro/chapter_1/image_5_3")
    cutscene:text("And a PRINCE\nFROM THE DARK.", "text_prince")
    self.panel_chunk_amount = 0
    self.panel_chunk_fade = true
    cutscene:wait(108 / 30)
    self.fade_speed = 0.04
    self.fade:setColor(COLORS.black)
    self.chunk_fade = true
    cutscene:wait(31 / 30)
    cutscene:removeText()
    self.slide = 6
    cutscene:text("Only they can seal the fountains","far_left_bottom")
    self.panel_chunk_amount = 0
    self.panel_chunk_fade = false
    self.chunk_fade = false
    self.panel:set("intro/chapter_1/image_6")
    self.panel_2:set()
    cutscene:wait(138/30)
    cutscene:removeText()
    cutscene:text("And banish the ANGEL'S HEAVEN.","far_left_bottom")
    cutscene:wait(138/30)
    cutscene:removeText()
    cutscene:text("Only then will balance\nbe restored,","middle_bottom")
    cutscene:wait(138/30)
    cutscene:removeText()
    cutscene:text("And the WORLD saved\nfrom destruction.","middle_bottom")
    self.fade_speed = 0.04
    self.fade:setColor(COLORS.black)
    self.chunk_fade = true
    cutscene:wait(138/30)

    self:setPanelPos("small")
    self.y_offset = 0
    self.x_offset = 0

    self.fade_speed = 0.02
    self.chunk_fade = false
    self.panel_chunk_amount = 0

    self.slide = 7

    self.panel:set("intro/chapter_1/image_7")

    self.cover.visible = true

    self.x_timer = 0
    self.y_timer = 0

    cutscene:removeText()
    cutscene:text("Today, the FOUNTAIN OF DARKNESS-", "far_left")

    cutscene:wait(138/30)
    cutscene:removeText()
    cutscene:text("The geyser that\ngives this land form-", "left")
    cutscene:wait(138/30)
    cutscene:removeText()
    cutscene:text("Stands tall at the\ncenter of the kingdom.", "left")
    cutscene:wait(168/30)
    cutscene:removeText()
    cutscene:text("But recently, another fountain\nhas appeared on the horizon...", "far_left")
    self.move_x = true
    cutscene:wait(196/30)
    cutscene:removeText()
    cutscene:text("And with it,[wait:5] the balance of\nLIGHT and DARK begins to shift...", "far_left")
    cutscene:wait(120/30)
    self.fade_speed = 0.02
    self.chunk_fade = true
    cutscene:wait(120/30)
    self.music:remove()
    Game.world.fader:fadeOut(nil, {speed = 50/30, color = COLORS.black})
    cutscene:wait(80/30)
    self.done = true
    self:remove()
end

return LegendHandler
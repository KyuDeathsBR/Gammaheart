local LegendCutscene, super = Class(Cutscene, "LegendCutscene")

function LegendCutscene:init(scene, can_skip, handler, ...)

    self.handler = handler

    self.text_objects = {
    }

    Game.lock_movement = true
    Game.cutscene_active = true

    self.can_skip = can_skip

    self.text_positions = {
        ["far_left"       ] = {80 , 320},
        ["far_right"      ] = {440, 320},
        ["left"           ] = {160, 320},
        ["top_left"       ] = {80 , 160},
        ["middle_bottom"  ] = {160, 370},
        ["left_bottom"    ] = {120, 370},
        ["far_left_bottom"] = {80 , 370},
        ["text_human"     ] = {40 , 370},
        ["text_monster"   ] = {220, 370},
        ["text_prince"    ] = {400, 370}
    }

    self.speed = 1

    super:init(self, scene, ...)
end

function LegendCutscene:update()

    super:update(self)
end

function LegendCutscene:onEnd()
    Game.lock_movement = false
    Game.cutscene_active = false

    self:removeText()

    super:onEnd(self)
end

function LegendCutscene:removeText()
    for i, v in ipairs(self.text_objects) do
        v:remove()
    end
end

function LegendCutscene:setSpeed(speed)
    self.speed = speed
end

function LegendCutscene:text(text, pos)
    local x, y = unpack(self.text_positions[pos])
    local dialogue = self.handler:addChild(DialogueText(text, x, y, nil, nil, {style = "none"}))
    dialogue.state.speed = self.speed
    dialogue.state.typing_sound = nil
    dialogue.layer = self.handler.layers["text"]
    dialogue.parallax_x = 0
    dialogue.parallax_y = 0
    dialogue.skippable = false
    table.insert(self.text_objects, dialogue)
    return dialogue
end

return LegendCutscene
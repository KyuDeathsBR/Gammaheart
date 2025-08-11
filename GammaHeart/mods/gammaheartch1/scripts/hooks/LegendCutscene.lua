---@class LegendCutscene
local LegendCutscene, super = Utils.hookScript(LegendCutscene)

function LegendCutscene:init(group, id, ...)
    super.init(self, group, id, ...)
    self.text_positions["center"] = {320, 320}
end

--- Writes some text at the given coordinates on the screen.
---@param text  string  The text to display.
---@param pos   LegendCutscene.text_position|table   A table of the x and y coordinates to start writing the text at. See `LegendCutscene.text_positions` for a set of default text positions.
---@return DialogueText dialogue
function LegendCutscene:textCentered(text, pos)
    local x, y = unpack(self.text_positions[pos])
    local dialogue = Game.legend:addChild(DialogueText(text, x, y, nil, nil, {style = "none", align = "center", auto_size = true}))
    dialogue.state.speed = self.speed
    dialogue.state.typing_sound = nil
    dialogue.layer = Game.legend.layers["text"]
    dialogue.parallax_x = 0
    dialogue.parallax_y = 0
    local text_width = dialogue:getTextWidth()
    dialogue.x = x - (text_width/2)
    dialogue.skippable = false
    table.insert(self.text_objects, dialogue)
    return dialogue
end

return LegendCutscene
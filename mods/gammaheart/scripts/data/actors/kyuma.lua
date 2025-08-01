local actor, super = Class(Actor, "kyuma")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Kyuma"

    -- Width and height for this actor, used to determine its center
    self.width = 20
    self.height = 40

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 25, 20, 15}

    -- A table that defines where the Soul should be placed on this actor if they are a player.
    -- First value is x, second value is y.
    self.soul_offset = {10, 24}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {0, 1, 1}

    -- Path to this actor's sprites (defaults to "")
    self.path = "party/kyuma/dark"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of sprite animations
    self.animations = {
        -- Movement animations
        ["slide"]               = {"slide", 4/30, true},

        -- Battle animations
        ["battle/idle"]         = {"battle/idle", 0.2, true},

        ["battle/attack"]       = {"battle/attack", 1/15, false, next="battle/idle"},
        ["battle/act"]          = {"battle/act", 1/15, false, next="battle/idle"},
        ["battle/spell"]        = {"battle/act", 1/15, false, next="battle/idle"},
        ["battle/item"]         = {"battle/item", 1/12, false, next="battle/idle"},
        ["battle/spare"]        = {"battle/act", 1/15, false, next="battle/idle"},
        ["battle/lightning_shot"] = {"battle/lightning_shot", 1/15, false},
        ["battle/lightning_shot_ready"] = {"battle/lightning_shot_ready", 1/15, false, next="battle/lightning_shot_ready/loop"},
        ["battle/lightning_shot_ready/loop"] = {"battle/lightning_shot_ready", 1/15, true, frames={5,6,7,8,9,10,11}},

        ["battle/attack_ready"] = {"battle/attackready", 1/12, true},
        ["battle/act_ready"]    = {"battle/actready", 0.2, true},
        ["battle/spell_ready"]  = {"battle/actready", 0.2, true},
        ["battle/item_ready"]   = {"battle/itemready", 0.2, true},
        ["battle/defend_ready"] = {"battle/defend", 1/15, false},

        ["battle/act_end"]      = {"battle/actend", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle/defeat", 1/15, false},

        ["battle/transition"]   = {"sword_jump_down", 0.2, true},
        ["battle/intro"]        = {"battle/intro", 1/15, false, next="battle/idle"},
        ["battle/victory"]      = {"battle/victory", 1/10, false},

        -- Cutscene animations
        ["jump_fall"]           = {"fall", 1/5, true},
        ["jump_ball"]           = {"ball", 1/15, true},
    }

    if Game.chapter == 1 then
        self.animations["battle/transition"] = {"walk/right", 0, true}
    end

    -- Tables of sprites to change into in mirrors
    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["walk/left"] = {0, 0},
        ["walk/right"] = {0, 0},
        ["walk/up"] = {0, 0},
        ["walk/down"] = {0, 0},

        ["walk_blush/down"] = {0, 0},

        ["slide"] = {0, 0},

        -- Battle offsets
        ["battle/idle"] = {-2, -14},

        ["battle/attack"] = {-2, -14},
        ["battle/attackready"] = {-2, -14},
        ["battle/lightning_shot"] = {-2, -14},
        ["battle/lightning_shot_ready"] = {-2, -14},
        ["battle/act"] = {-2, -14},
        ["battle/actend"] = {-2, -14},
        ["battle/actready"] = {-2, -14},
        ["battle/item"] = {-2, -14},
        ["battle/itemready"] = {-2, -14},
        ["battle/defend"] = {-2, -14},

        ["battle/defeat"] = {-2, -14},
        ["battle/hurt"] = {-2, -14},

        ["battle/intro"] = {-2, -14},
        ["battle/victory"] = {-2, -14},

        -- Cutscene offsets
        ["pose"] = {-4, -2},

        ["fall"] = {-5, -6},
        ["ball"] = {1, 8},
        ["landed"] = {-4, -2},

        ["fell"] = {-14, 1},

        ["sword_jump_down"] = {-19, -5},
        ["sword_jump_settle"] = {-27, 4},
        ["sword_jump_up"] = {-17, 2},

        ["hug_left"] = {-4, -1},
        ["hug_right"] = {-2, -1},

        ["peace"] = {0, 0},
        ["rude_gesture"] = {0, 0},

        ["reach"] = {-3, -1},

        ["sit"] = {-3, 0},

        ["t_pose"] = {-4, 0},
    }
end

return actor
function Mod:init()
    print("DELTARUNE Chapter 1&2 Demo -- Made by @undertaled, @huecycles and @firerainv")

    -- Note: Currently the Debug Mode kinda Sucks. by that I mean it only adds the Debug Room, which only has a sign and an encounter in it.
    --       I am planning on adding more to the Debug Room and POSSIBLY add the Deltarune debug mode visuals.
    --       On another note, currently the Chapter Selection library only has one use: Completion save files. In the future, if I do port the Deltarune debug mode, it will be added there to be used with your other mods + More.
    --       Oh Also, the 'Mod.undertale' config option will load the 'Check out Undertale' screen every time the Chapter Select mod loads. I know, that's not supposed to happen, but you can just add a flag to change that if you want. I'd rather just have that instead of making the screen only accessible once. (Though if you guys want me to change it, let me know in the mod's post in the Kristal discord.)

    ------// Config Options //------
    self.selection_music = "AUDIO_DRONE" -- Music used in Chapter Selection screen
    self.debug = false -- If true, Deltarune Chapter 2's Debug Room menu will appear when selecting Chapter 2 - The Debug room will not be the same one as Deltarune's, though.
    self.continue = true -- If false, the 'Continue to Chapter X' screen before Chapter Selection will not appear
    self.undertale = false -- If true, if you've never loaded the mod before, the game will ask you if you'd like to play Undertale first, like in Deltarune
    self.startingchapter = 1 -- If 'continue' option is set to true, this will be the default chapter you'd start in if you don't have a save file
end

function Mod:load()
    Game.world.can_open_menu = false
end

function Mod:postInit(new_file)
    if Game.world.map.id == "chapter_continue" then
        Game.chapter = 1
        Game.CHAPTER_SELECT = CHAPTER_SELECT()
        if (self.undertale) and (Mod:hasNoSaveFiles(true)) then
            if self.continue then
                Game.CHAPTER_CONTINUE = CHAPTER_CONTINUE()
                Game.stage:addChild(Game.CHAPTER_CONTINUE)
            end
            Game.SPLASH_SCREEN = SPLASH_SCREEN()
            Game.SPLASH_SCREEN.can_use = true
            Game.stage:addChild(Game.SPLASH_SCREEN)
        elseif self.continue and (Game.CHAPTER_CONTINUE == nil) then
            Game.CHAPTER_CONTINUE = CHAPTER_CONTINUE()
            Game.CHAPTER_CONTINUE.can_use = true
            Game.stage:addChild(Game.CHAPTER_CONTINUE)
        else
            Game.CHAPTER_SELECT.can_use = true
            Game.stage:addChild(Game.CHAPTER_SELECT)
        end
    end
    --[[
    if self.warnlib then
        for i,v in ipairs(Game.CHAPTER_SELECT.chapters) do
            if not v.locked then
                local chmod = Mod:loadModData(v.modid)
                if not chmod.libs["chapterselect_extension"] then Kristal.Console:log("[color:#FF55FF][CHSEL] \"ChapterSelect\" library is missing from mod \""..v.modid.."\" (Chapter "..i..")") end
            end
        end
    end
    ]]
end

function Mod:getCurrentModId()
    if Game.CHAPTER_SELECT then return Game.CHAPTER_SELECT.chapters[Game.chapter].modid end
end

function Mod:dogcheck()
    if Game.CHAPTER_SELECT then Game.CHAPTER_SELECT:close() end
    if Game.CHAPTER_CONTINUE then Game.CHAPTER_CONTINUE:remove() end
    if Game.SPLASH_SCREEN then Game.SPLASH_SCREEN:remove() end
    if Game.DEBUG_MENU then Game.DEBUG_MENU:remove() end
    if Game.world.cutscene then Game.world:stopCutscene() end
    Game.world:loadMap("dogcheck")
end



------// Don't Touchy //------

function Mod:hasNoSaveFiles(path)
    if path == true then
        local hasfiles = nil
        for i,v in pairs(Game.CHAPTER_SELECT.chapters) do
            if (Kristal.hasSaveFile(1, v.modid)) or (Kristal.hasSaveFile(2, v.modid)) or (Kristal.hasSaveFile(3, v.modid)) then
                hasfiles = true
            end
        end
        if hasfiles ~= nil then
            return false
        else
            return true
        end
    else
        if (not Kristal.hasSaveFile(1, path)) and (not Kristal.hasSaveFile(2, path)) and (not Kristal.hasSaveFile(3, path)) then
            return true
        else
            return false
        end
    end
end

function Game:enter(previous_state, save_id, save_name)
    self.previous_state = previous_state

    self.music = Music()

    self.quick_save = nil

    Kristal.callEvent("init")

    self.lock_movement = false

    if save_id then
        Kristal.loadGame(save_id, false)
    else
        self:load(nil, nil, false)
    end

    if save_name then
        self.save_name = save_name
    end

    self.started = true

    if Kristal.getModOption("encounter") then
        self:encounter(Kristal.getModOption("encounter"), false)
    elseif Kristal.getModOption("shop") then
        self:enterShop(Kristal.getModOption("shop"), {menu = true})
    end

    DISCORD_RPC_PRESENCE = {}

    Kristal.callEvent("postInit", self.is_new_file)

    if next(DISCORD_RPC_PRESENCE) == nil then
        Kristal.setPresence({
            state = Kristal.callEvent("getPresenceState") or ("Playing " .. (Kristal.getModOption("name") or "a mod")),
            details = Kristal.callEvent("getPresenceDetails"),
            largeImageKey = Kristal.callEvent("getPresenceImage") or "logo",
            largeImageText = "Kristal v" .. tostring(Kristal.Version),
            startTimestamp = math.floor(os.time() - self.playtime),
            instance = 0
        })
    end
end

-- Loads the data of another mod. Why is this needed you ask? Well 黙れ敗者！ 🕿︎☹︎⚐︎💧︎☜︎☼︎✆︎ ガスターブラスト！
-- Actually Nevermind This Is Kinda Broken
--[[
function Mod:loadModData(id, save_id, save_name, after)
    local mod = Kristal.Mods.getAndLoadMod(id)

    if not mod then return end

    local TempMod = TempMod or { info = mod, libs = {} }

    if mod.script_chunks["mod"] then
        local result = mod.script_chunks["mod"]()
        if type(result) == "table" then
            TempMod = result
            if not TempMod.info then
                TempMod.info = mod
            end
        end
    end

    TempMod.libs = TempMod.libs or {}
    for _, lib_id in ipairs(mod.lib_order) do
        local lib_info = mod.libs[lib_id]

        local lib = { info = lib_info }

        TempMod.libs[lib_id] = lib

        -- Check for lib.lua
        if lib_info.script_chunks["lib"] then
            -- Execute lib.lua
            local result = lib_info.script_chunks["lib"]()
            if type(result) == "table" then
                lib = result
                if not lib.info then
                    lib.info = lib_info
                end
            end
        end

        TempMod.libs[lib_id] = lib
    end
    return TempMod
end
]]

function Mod:getLastCompletedChapter()
    local completedchapter = nil
    for i,v in ipairs(Game.CHAPTER_SELECT.chapters) do
        if not v.locked then
            --local chmod = Mod:loadModData(v.modid)
            --if chmod.libs["chapterselect_extension"] then
                if v.locked ~= true then
                    if (ChapterSelectionLib:hasCompletionFile(1, v.modid) == true) or (ChapterSelectionLib:hasCompletionFile(2, v.modid) == true) or (ChapterSelectionLib:hasCompletionFile(3, v.modid) == true) then
                        completedchapter = i
                    end
                end
            --end
        end
    end
    return completedchapter
end


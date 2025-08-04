function Mod:init()
    Utils.merge(MUSIC_VOLUMES, {
        battle = 1, -- Limited to 1/0.7 (which is about 1.428571429)
    })
end
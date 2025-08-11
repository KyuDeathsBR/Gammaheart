return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `BattleCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene WorldCutscene
    see_rift_1= function(cutscene, event)
        
        local kyuma = Game.world:getPartyCharacter("kyuma")
        ---@type {["notice"|"transform_fight"]:Event}
        local markers = {
            notice = Game.world.map.markers["kyuma/see_rift/notice"],
            transform_fight = Game.world.map.markers["kyuma/see_rift/transform_fight"]
        }
        local translationtexts = {
            notice = {
                en = "What the?!",
                es = "¡¿Qué?!",
                ["pt-br"] = "Oquê?!",
                ja = "何が？！",
                LOLCAT = "WAT!?1",
                emotion = "shocked",
            },
            confusion = {
                en = "This surely doesn't look like the town i am used to seeing.",
                es = "Esto no se parece a la ciudad que estoy acostumbrado a ver.",
                ["pt-br"] = "Isto não se parece com a cidade que eu conheço.",
                ja = "これは確かに私が見慣れた町には見えない。",
                LOLCAT = "DIS DOAN LOOK LAIK DA TOWN I BE USE 2 SEE.",
                emotion = "worried"
            }
        }  
        cutscene:detachCamera()
        cutscene:detachFollowers()
        cutscene:shakeCamera()
        cutscene:setSpeaker(kyuma)
        local finished,text = cutscene:text(translationtexts.notice[Mod.selected_language],translationtexts.notice.emotion,{
            wait = false,
            skip = false,
            advance = false,
            auto = false
        })
        kyuma:walkTo(markers.notice.x,markers.notice.y,0.5,"right",false)   
        cutscene:wait(2)
        text:setAuto(true)
        cutscene.world.camera:panTo(markers.transform_fight.x,markers.transform_fight.y,2,"linear")
        cutscene:wait(2)
        cutscene:text(translationtexts.confusion[Mod.selected_language],translationtexts.confusion.emotion)
        Mod:findCollider("open1").collidable = false
        Game:setFlag("$WorldCollisions/town/open1/collidable",false)
        local success = kyuma:walkTo(markers.transform_fight.x,markers.transform_fight.y,3,"right",false)
        kyuma:alert(0.5)        
        assert(success,"ERROR: kyuma's path is blocked by open1 somehow")
    end
}
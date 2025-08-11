ChapterSelectionLib = {}
local lib = ChapterSelectionLib

function lib:unload()
    ChapterSelectionLib = nil
end

--- Saves the completion file for this save file.
---@param id?   number The completion file index to save to. (Defaults to the currently loaded save index)
---@param data? table  The data to save to the file. (Defaults to the output of `Game:save()`)
function ChapterSelectionLib:saveCompletionFile(id, data)
    id = id or Game.save_id
    data = data or Game:save()
    Game.save_id = id
    Game.quick_save = nil
    love.filesystem.createDirectory("saves/" .. Mod.info.id)
    love.filesystem.write("saves/" .. Mod.info.id .. "/cfile_" .. id .. ".json", JSON.encode(data))
end

--- Returns the data from the specified completion file.
---@param id?   number    The completion file index to load. (Defaults to the currently loaded save index)
---@param path? string    The save folder to load from. (Defaults to the current mod's save folder)
---@return table|nil data The data loaded from the completion file, or `nil` if the file doesn't exist.
function ChapterSelectionLib:getCompletionFile(id, path)
    id = id or Game.save_id
    local full_path = "saves/" .. (path or Mod.info.id) .. "/cfile_" .. id .. ".json"
    if love.filesystem.getInfo(full_path) then
        return JSON.decode(love.filesystem.read(full_path))
    end
    return nil
end

--- Returns whether the specified completion file exists.
---@param id?   number    The completion file index to check. (Defaults to the currently loaded save index)
---@param path? string    The save folder to check. (Defaults to the current mod's save folder)
---@return boolean exists Whether the completion file exists.
function ChapterSelectionLib:hasCompletionFile(id, path)
    id = id or Game.save_id
    local full_path = "saves/" .. (path or Mod.info.id) .. "/cfile_" .. id .. ".json"
    return love.filesystem.getInfo(full_path) ~= nil
end

return lib
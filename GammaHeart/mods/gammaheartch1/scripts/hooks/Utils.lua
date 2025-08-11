local Utils, super = Utils.hookScript(Utils)

---
--- Creates a Collider based on a Tiled object shape.
---
---@param parent Object      # The object that the new Collider should be parented to.
---@param data table         # The Tiled shape data.
---@param x? number          # An optional value defining the horizontal position of the collider.
---@param y? number          # An optional value defining the vertical position of the collider.
---@param properties? table  # A table defining additional properties for the collider.
---@return Collider collider # The new Collider instance.
---
function Utils.colliderFromShape(parent, data, x, y, properties)
    x, y = x or 0, y or 0
    properties = properties or {}

    -- Optional properties for collider behaviour
    -- "outside" is the same as enabling both "inverted" and "inside"
    local mode = {
        invert = properties["inverted"] or properties["outside"] or false,
        inside = properties["inside"] or properties["outside"] or false
    }

    local current_hitbox
    if data.shape == "rectangle" then
        -- For rectangles, create a Hitbox using the rectangle's dimensions
        current_hitbox = Hitbox(parent, x, y, data.width, data.height, mode)

    elseif data.shape == "polyline" then
        -- For polylines, create a ColliderGroup using a series of LineColliders
        local line_colliders = {}

        -- Loop through each pair of points in the polyline
        for i = 1, #data.polyline-1 do
            local j = i + 1
            -- Create a LineCollider using the current and next point of the polyline
            local x1, y1 = x + data.polyline[i].x, y + data.polyline[i].y
            local x2, y2 = x + data.polyline[j].x, y + data.polyline[j].y
            table.insert(line_colliders, LineCollider(parent, x1, y1, x2, y2, mode))
        end

        current_hitbox = ColliderGroup(parent, line_colliders)

    elseif data.shape == "polygon" then
        -- For polygons, create a PolygonCollider using the polygon's points
        local points = {}

        for i = 1, #data.polygon do
            -- Convert points from the format {[x] = x, [y] = y} to {x, y}
            table.insert(points, {x + data.polygon[i].x, y + data.polygon[i].y})
        end

        current_hitbox = PolygonCollider(parent, points, mode)
    end

    if properties["enabled"] == false then
        current_hitbox.collidable = false
    end

    current_hitbox.name = data.name

    return current_hitbox
end

return Utils
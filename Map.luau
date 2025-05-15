local HttpService = game:GetService("HttpService")

local function SafeGet(instance, property)
    local success, result = pcall(function() return instance[property] end)
    if success then
        return result
    end
    return nil
end

local function SerializeInstance(instance)
    local data = {
        Name = instance.Name,
        ClassName = instance.ClassName,
        Properties = {},
        Children = {}
    }

    -- Propriétés générales à copier
    local props = {
        "Position", "Size", "CFrame", "Orientation",
        "Color", "BrickColor", "Material", "Transparency",
        "Anchored", "CanCollide", "Text", "Value",
        "MeshId", "TextureId", "SoundId", "Image", "ImageColor3"
    }

    for _, prop in pairs(props) do
        local value = SafeGet(instance, prop)
        if value ~= nil then
            data.Properties[prop] = value
        end
    end

    -- Copie des enfants récursivement
    for _, child in pairs(instance:GetChildren()) do
        table.insert(data.Children, SerializeInstance(child))
    end

    return data
end

return function(options)
    print("[+] Sauvegarde de la map (hors ServerScriptService)...")

    local data = {}

    for _, obj in pairs(game:GetChildren()) do
        if obj.Name ~= "ServerScriptService" then
            table.insert(data, SerializeInstance(obj))
        end
    end

    local encoded = HttpService:JSONEncode(data)

    if writefile then
        local filename = "MapDump_"..os.time()..".json"
        writefile(filename, encoded)
        print("[+] Map sauvegardée dans : " .. filename)
    else
        warn("[-] writefile non supporté sur cet exploit.")
    end
end

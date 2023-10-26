DynastyRealState = {}
DynastyRealState.__index = DynastyRealState
local currentSelection = -1

--[[
    type:
        0 = House icon, 0 vehicle slots
        1 = Garage icon, 2 vehicle slots
        2 = Garage icon, 6 vehicle slots
        3 = Garage icon, 10 vehicle slots
        4 = House icon, 2 vehicle slots
        5 = House icon, 6 vehicle slots
        6 = House icon, 10 vehicle slots
        7 = House icon, 20 vehicle slots
        8 = House icon, 0 vehicle slots
        9 = House icon, 0 vehicle slots
        10 = House icon, 0 vehicle slots
        11 = House icon, 0 vehicle slots
        12 = House icon, 50 vehicle slots
]]

-- needs at least 11 properties to work or none properties will be shown
local properties = {
    { name = 'MP_PROP_1', texture = 'DYN_MP_1', type = 6, price = 600000, sale_price = 590000, interiors = 255, is_new = false, x = -786.62, y = 299.34 },
    { name = 'MP_PROP_2', texture = 'DYN_MP_2', type = 6, price = 575000, sale_price = 575000, interiors = 255, is_new = true, x = -786.62, y = 299.34 },
    { name = 'MP_PROP_3', texture = 'DYN_MP_3', type = 6, price = 535000, sale_price = 535000, interiors = 255, is_new = false, x = -786.62, y = 299.34 },
    { name = 'MP_PROP_4', texture = 'DYN_MP_4', type = 6, price = 500000, sale_price = 500000, interiors = 255, is_new = false, x = -786.62, y = 299.34 },
    { name = 'MP_PROP_5', texture = 'DYN_MP_5', type = 6, price = 450000, sale_price = 450000, interiors = 255, is_new = false, x = -262.697, y = -976.391 },
    { name = 'MP_PROP_6', texture = 'DYN_MP_6', type = 6, price = 435000, sale_price = 435000, interiors = 255, is_new = false, x = -262.697, y = -976.391 },
    { name = 'MP_PROP_7', texture = 'DYN_MP_7', type = 6, price = 395000, sale_price = 395000, interiors = 255, is_new = true, x = -1437.31, y = -543.658 },

    { name = 'MP_PROP_8', texture = 'DYN_MP_8', type = 6, price = 43500, sale_price = 43500, interiors = 255, is_new = true, x = -1786.62, y = 1299.34 },
    { name = 'MP_PROP_9', texture = 'DYN_MP_9', type = 6, price = 43500, sale_price = 43500, interiors = 255, is_new = true, x = -1786.62, y = 1299.34 },
    { name = 'MP_PROP_10', texture = 'DYN_MP_10', type = 6, price = 43500, sale_price = 43500, interiors = 255, is_new = true, x = -1786.62, y = 1299.34 },
    { name = 'MP_PROP_11', texture = 'DYN_MP_11', type = 6, price = 43500, sale_price = 43500, interiors = 255, is_new = true, x = -1786.62, y = 1299.34 },
    { name = 'MP_PROP_12', texture = 'DYN_MP_12', type = 6, price = 43500, sale_price = 43500, interiors = 255, is_new = true, x = -1786.62, y = 1299.34 },
    { name = 'MP_PROP_13', texture = 'DYN_MP_13', type = 6, price = 43500, sale_price = 43500, interiors = 255, is_new = true, x = -1786.62, y = 1299.34 },
    { name = 'MP_PROP_14', texture = 'CWR_MP_1', type = 6, price = 43500, sale_price = 43500, interiors = 255, is_new = true, x = 2572.37, y = 2586.38 },
}

--DYN_CUSTOMAPT = custom interiors (see v.interiors)
--DYN_STILTAPT = mansions
--DYN_UPDATEDINT = same apartament, another interior

function DynastyRealState:initialise(scaleform)
    local needsRepopulate = true
    repeat Wait(0) until HasScaleformMovieFilenameLoaded('WWW_DYNASTY8REALESTATE_COM')

    Scaleform.Call(scaleform, 'INITIALISE_WEBSITE')

    Citizen.CreateThread(function()
        repeat Wait(0) until GetCurrentWebsiteId() == 18

        while true do
            if GetCurrentWebpageId() == 2 and needsRepopulate then
                local index = 0
                for k, v in pairs(properties) do
                    Scaleform.Call(scaleform, 'SET_DATA_SLOT', index, GetLabelText(v.name), v.x, v.y, v.price, v.texture, GetLabelText(v.name.."DES"), v.type, 1, v.name, v.sale_price ~= v.price, v.interiors, "slot " .. index, v.sale_price, v.is_new, v.starterPack, v.hasTints)
                    index = index + 1
                end

                Scaleform.Call(scaleform, "UPDATE_TEXT")

                needsRepopulate = false
            elseif GetCurrentWebpageId() == 5 then
                --TODO: keeps setting a new waypoint until webpage is closed
                local prop = properties[currentSelection+1]
                SetNewWaypoint(prop.x, prop.y)
            end

            if GetCurrentWebpageId() ~= 2 then
                needsRepopulate = true
            end

            if GetCurrentWebsiteId() ~= 18 or not Browser.Visible then break end
            Wait(0)
        end
    end)
end

function DynastyRealState:onClick()
    if Browser.GetCurrentSelection() > -1 and GetCurrentWebpageId() == 21 then
        currentSelection = Browser.GetCurrentSelection()
    end
end
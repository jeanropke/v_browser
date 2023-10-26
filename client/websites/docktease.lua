DockTease = {}
DockTease.__index = DockTease

local currentSelection = nil
local selectedVehicleId = nil

function DockTease:initialise(scaleform)
    repeat Wait(0) until HasScaleformMovieFilenameLoaded('WWW_DOCKTEASE_COM')

    Scaleform.Call(scaleform, 'INITIALISE_WEBSITE')
    
    for i = 3, 40 do
        Scaleform.Call(scaleform, 'SET_PRICES', i, "FREE", 0, 0, 0, 0, 0, true, true)
        --Scaleform.Call(scaleform, 'SET_RANKS', i, 0, 3)
    end

    -- Yacht banner
    local color = 1
    local lightning = 6
    local countryFlag = 8
    local yachtModel = 1
    local fittings = 1
    Scaleform.Call(scaleform, "SET_DATA_SLOT", 18, color, lightning, countryFlag, yachtModel, fittings, 'yacht name', 'yacht name')
    
    Scaleform.Call(scaleform, "UPDATE_TEXT")

end

function DockTease:onClick()
    local _curSelection = Browser.GetCurrentSelection()

    -- Color
    if _curSelection >= 15  then
        currentSelection = _curSelection - 7
    end

    -- Purchase vehicle
    if GetCurrentWebpageId() == 12 then
        local price = 20
        Vehicle.TryPurchase(selectedVehicleId, price, currentSelection, GetCurrentWebsiteId()) -- vehicleId, 
    else
        selectedVehicleId = GetCurrentWebpageId()
    end
end
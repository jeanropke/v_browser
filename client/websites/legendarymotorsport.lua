LegendaryMotorsport = {}
LegendaryMotorsport.__index = LegendaryMotorsport

local currentSelection = nil
local selectedVehicleId = nil

function LegendaryMotorsport:initialise(scaleform)
    repeat Wait(0) until HasScaleformMovieFilenameLoaded('WWW_LEGENDARYMOTORSPORT_NET')

    Scaleform.Call(scaleform, 'INITIALISE_WEBSITE')
    
    --[[ 
        SET_PRICES: id, price, secondaryPrice, reductionType, salePrice, secondarySalePrice, award, price1Unlocked, price2Unlocked

        id: vehicle id
        price: vehicle price (discount price when a mission is done), 0 = out of stock, can be "FREE"
        secondaryPrice: vehicle full price
        reductionType: 0 = none, 1 = cash back, 2 = special rebate, 3 = sale
        salePrice: vehicle sale price (discount price when a mission is done)
        secondarySalePrice: vehicle sale full price
        award: an icon, 0 = none, 1 = cloth, 2 = money sign
        price1Unlocked & price2Unlocked: needs the trade price button
    ]]
    -- SET_RANKS:  id, rank, playerRank

    
    for i = 3, 200 do
        Scaleform.Call(scaleform, 'SET_PRICES', i, "FREE", 0, 0, 0, 0, 0, true, true)
        Scaleform.Call(scaleform, 'SET_RANKS', i, 0, 3)
    end
        
    Scaleform.Call(scaleform, "UPDATE_TEXT")

    --Scaleform.Call(scaleform, 'SET_PRICES', 3, 45000, 55000, 3, 35000, 45000, 0, false, false)
    --Scaleform.Call(scaleform, 'SET_RANKS', 3, 0, 3)
    --
    --Scaleform.Call(scaleform, 'SET_PRICES', 4, 75000, 0, 0, 0, 0, 1, true, false)
    --Scaleform.Call(scaleform, 'SET_RANKS', 4, 55, 3)
    --
    --Scaleform.Call(scaleform, 'SET_PRICES', 5, 42000, 0, 3, 0, 0, 2, false, false)
    --Scaleform.Call(scaleform, 'SET_RANKS', 5, 0, 3)

end

function LegendaryMotorsport:onClick()
    
    if Browser.GetCurrentSelection() >= 8  then
        currentSelection = Browser.GetCurrentSelection()
    end

    -- Purchase vehicle
    if GetCurrentWebpageId() == 12 then
        local price = 20
        Vehicle.TryPurchase(selectedVehicleId, price, currentSelection, GetCurrentWebsiteId()) -- vehicleId, 
    else
        selectedVehicleId = GetCurrentWebpageId()
    end
end
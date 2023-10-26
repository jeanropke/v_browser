Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle.Create(model, spawnPedInside, color)
    local modelHash = GetHashKey(model)
    if not IsModelInCdimage(modelHash) then return end
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
      Citizen.Wait(1)
    end
    local ped = PlayerPedId()
    local vehicle = CreateVehicle(modelHash, GetEntityCoords(ped), GetEntityHeading(ped), true, false)
    
    if color ~= nil then
        SetVehicleColours(vehicle, color, color)
    end

    if spawnPedInside then
        SetPedIntoVehicle(ped, vehicle, -1)
        SetVehRadioStation(vehicle, "OFF")
    end
    SetModelAsNoLongerNeeded(modelHash)
    return vehicle
end

function Vehicle.TryPurchase(vehicle, price, color, website)
    TriggerServerEvent('v_browser:tryPurchase', website, vehicle, price, color)
end

function Vehicle.GetBlipSprite(vehHash)

    if `voltic2` == vehHash then
        return 533
    end

    if `ruiner2` == vehHash then
        return 530
    end

    if `dune4` == vehHash then
        return 531
    end

    if `dune5` == vehHash then
        return 531
    end

    if `phantom2` == vehHash then
        return 528
    end

    if `technical2` == vehHash then
        return 534
    end

    if `technical3` == vehHash then
        return 534
    end

    if `boxville5` == vehHash then
        return 529
    end

    if `wastelander` == vehHash then
        return 532
    end

    if `blazer5` == vehHash then
        return 512
    end

    if `apc` == vehHash then
        return 558
    end

    if `oppressor` == vehHash then
        return 559
    end

    if `halftrack` == vehHash then
        return 560
    end

    if `dune3` == vehHash then
        return 561
    end

    if `tampa3` == vehHash then
        return 562
    end

    if `trailersmall2` == vehHash then
        return 563
    end

    if `alphaz1` == vehHash then
        return 572
    end

    if `bombushka` == vehHash then
        return 573
    end

    if `havok` == vehHash then
        return 574
    end

    if `howard` == vehHash then
        return 575
    end

    if `hunter` == vehHash then
        return 576
    end

    if `microlight` == vehHash then
        return 577
    end

    if `mogul` == vehHash then
        return 578
    end

    if `molotok` == vehHash then
        return 579
    end

    if `nokota` == vehHash then
        return 580
    end

    if `pyro` == vehHash then
        return 581
    end

    if `rogue` == vehHash then
        return 582
    end

    if `starling` == vehHash then
        return 583
    end

    if `seabreeze` == vehHash then
        return 584
    end

    if `tula` == vehHash then
        return 585
    end

    if `nightshark` == vehHash then
        return 225
    end

    if `technical` == vehHash then
        return 534
    end

    if `stromberg` == vehHash then
        return 595
    end

    if `deluxo` == vehHash then
        return 596
    end

    if `thruster` == vehHash then
        return 597
    end

    if `khanjali` == vehHash then
        return 598
    end

    if `riot2` == vehHash then
        return 599
    end

    if `volatol` == vehHash then
        return 600
    end

    if `barrage` == vehHash then
        return 601
    end

    if `akula` == vehHash then
        return 602
    end

    if `chernobog` == vehHash then
        return 603
    end

    if `avenger` == vehHash then
        return 589
    end

    if `strikeforce` == vehHash then
        return 640
    end

    if `speedo4` == vehHash then
        return 637
    end

    if `mule4` == vehHash then
        return 636
    end

    if `pounder2` == vehHash then
        return 635
    end

    if `oppressor2` == vehHash then
        return 639
    end

    if `seasparrow` == vehHash then
        return 612
    end

    if `caracara` == vehHash then
        return 613
    end

    if `rrocket` == vehHash then
        return 348
    end

    if `kosatka` == vehHash then
        return 760
    end

    if `champion` == vehHash then
        return 824
    end

    if `buffalo4` == vehHash then
        return 825
    end

    if `deity` == vehHash then
        return 823
    end

    if `jubilee` == vehHash then
        return 820
    end

    if `granger2` == vehHash then
        return 821
    end

    if `patriot3` == vehHash then
        return 818
    end

    return -1
end
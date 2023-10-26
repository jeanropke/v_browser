Browser = {}
Browser.__index = Browser

Browser.Visible = false
Browser.Scaleform = nil

local HorizontalVelocity = 0.0

local currentWebsiteUrl = nil

local personalVehicle = nil
local personalVehicleBlip = nil

function Browser.GetCurrentWebsiteUrl()
    local _value = Scaleform.RequestValue(Browser.Scaleform, "GET_CURRENT_WEBSITE")

    repeat Wait(0) until IsScaleformMovieMethodReturnValueReady(_value)

    return GetScaleformMovieMethodReturnValueString(_value)
end

function Browser.GetCurrentSelection()
    local _value = Scaleform.RequestValue(Browser.Scaleform, "GET_CURRENT_SELECTION")

    repeat Wait(0) until IsScaleformMovieMethodReturnValueReady(_value)

    return GetScaleformMovieMethodReturnValueInt(_value)
end

local function HandleSticksInput()
    local leftX = GetControlUnboundNormal(2, Controls.INPUT_SCRIPT_LEFT_AXIS_X) * 127.0
    local leftY = GetControlUnboundNormal(2, Controls.INPUT_SCRIPT_LEFT_AXIS_Y) * 127.0
    local rightX = GetControlUnboundNormal(2, Controls.INPUT_SCRIPT_RIGHT_AXIS_X) * 127.0
    local rightY = GetControlUnboundNormal(2, Controls.INPUT_SCRIPT_RIGHT_AXIS_Y) * 127.0

    if not IsControlEnabled(2, Controls.INPUT_SCRIPT_LEFT_AXIS_X) then
        leftX = GetDisabledControlUnboundNormal(2, Controls.INPUT_SCRIPT_LEFT_AXIS_X) * 127.0
    end
    if not IsControlEnabled(2, Controls.INPUT_SCRIPT_LEFT_AXIS_Y) then
        leftY = GetDisabledControlUnboundNormal(2, Controls.INPUT_SCRIPT_LEFT_AXIS_Y) * 127.0
    end
    if not IsControlEnabled(2, Controls.INPUT_SCRIPT_RIGHT_AXIS_X) then
        rightX = GetDisabledControlUnboundNormal(2, Controls.INPUT_SCRIPT_RIGHT_AXIS_X) * 127.0
    end
    if not IsControlEnabled(2, Controls.INPUT_SCRIPT_RIGHT_AXIS_Y) then
        rightY = GetDisabledControlUnboundNormal(2, Controls.INPUT_SCRIPT_RIGHT_AXIS_Y) * 127.0
    end

    return vector4(leftX, leftY, rightX, rightY)

end

local function HandleInputs()
    -- Scroll
    if IsControlPressed(2, Controls.INPUT_FRONTEND_LT) or IsControlPressed(2, Controls.INPUT_FRONTEND_DOWN) or IsDisabledControlJustPressed(2, Controls.INPUT_FRONTEND_LT) or IsDisabledControlJustPressed(2, Controls.INPUT_FRONTEND_DOWN) then
        HorizontalVelocity = 200.0
    elseif IsControlPressed(2, Controls.INPUT_FRONTEND_RT) or IsControlPressed(2, Controls.INPUT_FRONTEND_UP) or IsDisabledControlJustPressed(2, Controls.INPUT_FRONTEND_RT) or IsDisabledControlJustPressed(2, Controls.INPUT_FRONTEND_UP) then
        HorizontalVelocity = -200.0
    elseif IsControlPressed(2, Controls.INPUT_CURSOR_SCROLL_DOWN) or IsDisabledControlPressed(2, Controls.INPUT_CURSOR_SCROLL_DOWN) then
        if HorizontalVelocity <= 0.0 then
            HorizontalVelocity = 200.0
        else
            HorizontalVelocity = HorizontalVelocity + 200.0

            if HorizontalVelocity >= 1000.0 then
                HorizontalVelocity = 1000.0
            end
        end
    elseif IsControlPressed(2, Controls.INPUT_CURSOR_SCROLL_UP) or IsDisabledControlPressed(2, Controls.INPUT_CURSOR_SCROLL_UP) then
        if HorizontalVelocity >= 0.0 then
            HorizontalVelocity = -200.0
        else
            HorizontalVelocity = HorizontalVelocity - 200.0

            if HorizontalVelocity <= -1000.0 then
                HorizontalVelocity = -1000.0
            end
        end
    end

    local speedModifier = 100.0 * Timestep()
    local leftX, leftY, rightX, rightY = table.unpack(HandleSticksInput() * speedModifier)
    local _leftX, _leftY, _rightX, _rightY = nil
    

    if IsUsingKeyboard() then
        Scaleform.Call(Browser.Scaleform, "SET_MOUSE_INPUT", GetDisabledControlNormal(2, 239), GetDisabledControlNormal(2, 240), -1)
        Scaleform.Call(Browser.Scaleform, "SET_ANALOG_STICK_INPUT", 0, 0, HorizontalVelocity, false)
        HorizontalVelocity = 0.0
    else
        if _leftX ~= leftX or _leftY ~= leftY then
            Scaleform.Call(Browser.Scaleform, "SET_ANALOG_STICK_INPUT", 1.0, leftX, leftY)    
        end
        if _rightX ~= rightX or _rightY ~= rightY then
            Scaleform.Call(Browser.Scaleform, "SET_ANALOG_STICK_INPUT", 0.0, rightX, rightY)    
        end
    end


    -- Back
    if IsControlJustPressed(2, Controls.INPUT_FRONTEND_CANCEL) or IsControlJustPressed(2, Controls.INPUT_CURSOR_CANCEL) and not IsWarningMessageActive() or IsDisabledControlJustPressed(2, Controls.INPUT_FRONTEND_CANCEL) or IsDisabledControlJustPressed(2, Controls.INPUT_CURSOR_CANCEL) and not IsWarningMessageActive() then
        if GetGlobalActionscriptFlag(1) == 0 then
            Browser.Close()
        else
            Scaleform.Call(Browser.Scaleform, "SET_INPUT_EVENT", 15.0)
            Scaleform.Call(Browser.Scaleform, "GO_BACK")
            PlaySoundFrontend(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", true)
        end
    end
    
    if IsControlJustPressed(2, Controls.INPUT_FRONTEND_Y) and not IsWarningMessageActive() or IsDisabledControlJustPressed(2, Controls.INPUT_FRONTEND_Y) and not IsWarningMessageActive() then
        Browser.Close()
    end

    if IsControlJustPressed(2, Controls.INPUT_FRONTEND_ACCEPT) or IsControlJustPressed(2, Controls.INPUT_CURSOR_ACCEPT) then
        Scaleform.Call(Browser.Scaleform, "SET_INPUT_EVENT", 16.0)

        Citizen.CreateThread(function() 
            if Browser.Websites[currentWebsiteUrl] ~= nil and Browser.Websites[currentWebsiteUrl]['onClick'] then
                Browser.Websites[currentWebsiteUrl]:onClick()
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        if Browser.Visible then
            Scaleform.RenderFullscreen(Browser.Scaleform)
            HandleInputs()

            DisableControlAction(0, Controls.INPUT_SELECT_WEAPON, true)
            DisableControlAction(0, Controls.INPUT_SELECT_WEAPON_UNARMED, true)
            DisableControlAction(0, Controls.INPUT_SELECT_WEAPON_HANDGUN, true)
            DisableControlAction(0, Controls.INPUT_SELECT_WEAPON_SHOTGUN, true)
            DisableControlAction(0, Controls.INPUT_SELECT_WEAPON_SMG, true)
            DisableControlAction(0, Controls.INPUT_SELECT_WEAPON_AUTO_RIFLE, true)
            DisableControlAction(0, Controls.INPUT_SELECT_WEAPON_SNIPER, true)
            DisableControlAction(0, Controls.INPUT_SELECT_WEAPON_HEAVY, true)
            DisableControlAction(0, Controls.INPUT_SELECT_WEAPON_SPECIAL, true)
            DisableControlAction(0, Controls.INPUT_SELECT_WEAPON_MELEE, true)
            DisableControlAction(0, Controls.INPUT_VEH_ROOF, true)
            DisableControlAction(0, Controls.INPUT_VEH_HYDRAULICS_CONTROL_TOGGLE, true)
            DisableControlAction(0, Controls.INPUT_WEAPON_SPECIAL, true)
            DisableControlAction(0, Controls.INPUT_WEAPON_SPECIAL_TWO, true)
            DisableControlAction(0, Controls.INPUT_DETONATE, true)
            DisableControlAction(0, Controls.INPUT_MELEE_ATTACK_LIGHT, true)
            DisableControlAction(0, Controls.INPUT_MELEE_ATTACK_HEAVY, true)
            DisableControlAction(0, Controls.INPUT_MELEE_ATTACK1, true)
            DisableControlAction(0, Controls.INPUT_MELEE_ATTACK2, true)
            DisableControlAction(0, Controls.INPUT_MELEE_ATTACK_ALTERNATE, true)
            DisableControlAction(0, Controls.INPUT_MELEE_BLOCK, true)
            DisableControlAction(0, Controls.INPUT_ATTACK, true)
            DisableControlAction(0, Controls.INPUT_COVER, true)
            DisableControlAction(0, Controls.INPUT_VEH_GUN_LEFT, true)
            DisableControlAction(0, Controls.INPUT_VEH_GUN_RIGHT, true)
            DisableControlAction(0, Controls.INPUT_VEH_GUN_UP, true)
            DisableControlAction(0, Controls.INPUT_VEH_GUN_DOWN, true)
            DisableControlAction(0, Controls.INPUT_VEH_ATTACK, true)
            DisableControlAction(0, Controls.INPUT_VEH_ATTACK2, true)
            DisableControlAction(0, Controls.INPUT_VEH_FLY_ATTACK, true)
            DisableControlAction(0, Controls.INPUT_VEH_SELECT_NEXT_WEAPON, true)
            DisableControlAction(0, Controls.INPUT_VEH_SELECT_PREV_WEAPON, true)
            DisableControlAction(0, Controls.INPUT_VEH_JUMP, true)
            DisableControlAction(0, Controls.INPUT_JUMP, true)
            DisableControlAction(0, Controls.INPUT_VEH_HEADLIGHT, true)
            DisableControlAction(0, Controls.INPUT_VEH_AIM, true)
            DisableControlAction(0, Controls.INPUT_AIM, true)
            DisableControlAction(0, Controls.INPUT_DUCK, true)
            DisableControlAction(0, Controls.INPUT_VEH_MELEE_HOLD, true)
            DisableControlAction(0, Controls.INPUT_VEH_MELEE_LEFT, true)
            DisableControlAction(0, Controls.INPUT_VEH_MELEE_RIGHT, true)
            DisableControlAction(0, Controls.INPUT_VEH_PASSENGER_AIM, true)
            DisableControlAction(0, Controls.INPUT_VEH_PASSENGER_ATTACK, true)
            DisableControlAction(0, Controls.INPUT_VEH_NEXT_RADIO, true)
            DisableControlAction(0, Controls.INPUT_VEH_PREV_RADIO, true)
            DisableControlAction(0, Controls.INPUT_VEH_NEXT_RADIO_TRACK, true)
            DisableControlAction(0, Controls.INPUT_VEH_PREV_RADIO_TRACK, true)
            DisableControlAction(0, Controls.INPUT_VEH_RADIO_WHEEL, true)
            DisableControlAction(0, Controls.INPUT_FRONTEND_PAUSE_ALTERNATE, true)
            DisableControlAction(2, Controls.INPUT_FRONTEND_PAUSE_ALTERNATE, true)
            DisableControlAction(0, Controls.INPUT_FRONTEND_PAUSE, true)
            DisableControlAction(2, Controls.INPUT_FRONTEND_PAUSE, true)
            DisableControlAction(0, Controls.INPUT_VEH_EXIT, true)
            DisableControlAction(0, Controls.INPUT_ENTER, true)
            DisableControlAction(0, Controls.INPUT_VEH_ACCELERATE, true)
            DisableControlAction(0, Controls.INPUT_VEH_BRAKE, true)
            DisableControlAction(0, Controls.INPUT_VEH_DUCK, true)
            DisableControlAction(0, Controls.INPUT_VEH_HORN, true)
            DisableControlAction(0, Controls.INPUT_VEH_CIN_CAM, true)
            
            Wait(0)
        else 
            Wait(100)
        end
    end
end)

Citizen.CreateThread(function()

    Browser.Websites = {
        ['WWW_EYEFIND_INFO'] = Eyefind,
        ['WWW_LEGENDARYMOTORSPORT_NET'] = LegendaryMotorsport,
        ['WWW_SOUTHERNSANANDREASSUPERAUTOS_COM'] = SouthernSanAndreasSuperAutos,
        ['WWW_ELITASTRAVEL_COM'] = ElitasTravel,
        ['WWW_WARSTOCK_D_CACHE_D_AND_D_CARRY_COM'] = WarstockCacheCarry,
        ['WWW_DOCKTEASE_COM'] = DockTease,
        ['WWW_PANDMCYCLES_COM'] = PMCycles,
        ['WWW_DYNASTY8REALESTATE_COM'] = DynastyRealState,
        ['WWW_DYNASTY8EXECUTIVEREALTY_COM'] = DynastyExecutiveRealty
    }
    OnEnterMp()
    SetInstancePriorityMode(1)

    SetPlayerWantedLevel(PlayerId(), 0)

end)

function Browser.Open()
    Scaleform.Request('font_lib_web')

    if not HasScaleformMovieLoaded(Browser.Scaleform) then
        Browser.Scaleform = Scaleform.Request('web_browser')
    end

    Scaleform.Call(Browser.Scaleform, 'SET_WIDESCREEN', true)    
    Scaleform.Call(Browser.Scaleform, 'SET_MULTIPLAYER', true)
    Scaleform.Call(Browser.Scaleform, 'SET_BROWSER_SKIN', 1)

    Scaleform.Call(Browser.Scaleform, "SET_DATA_SLOT_EMPTY")

    Scaleform.Call(Browser.Scaleform, 'SET_TICKERTAPE', 0.5)
    Scaleform.Call(Browser.Scaleform, 'SET_ANALOG_STICK_INPUT', 0, 0, 0)

    Scaleform.Call(Browser.Scaleform, 'GO_TO_WEBPAGE', 'WWW_EYEFIND_INFO')

    Browser.Websites['WWW_EYEFIND_INFO']:initialise(Browser.Scaleform)

    StartAudioScene('INTERNET_BROWSER_VIDEO_SCENE')
    Browser.Visible = true

    while true do
        if Browser.Visible then
            local _newWebsite = Browser.GetCurrentWebsiteUrl()
            if _newWebsite == nil then return end

            if _newWebsite ~= currentWebsiteUrl then
                if not Browser.Visible then return end
                currentWebsiteUrl = _newWebsite

                if Browser.Websites[_newWebsite] then
                    Browser.Websites[currentWebsiteUrl]:initialise(Browser.Scaleform)
                else
                    GenericWebsite:initialise(Browser.Scaleform, currentWebsiteUrl)
                end
            end
        else
            break
        end

        Wait(0)
    end
end

function Browser.Close()
    Scaleform.Call(Browser.Scaleform, 'SUPRESS_HISTORY', true)
    Scaleform.Call(Browser.Scaleform, 'SHUTDOWN_MOVIE')
    SetScaleformMovieAsNoLongerNeeded(Browser.Scaleform)
    StopAudioScene('INTERNET_BROWSER_VIDEO_SCENE')

    Browser.Visible = false
    Browser.Scaleform = nil
    currentWebsiteUrl = nil
end

RegisterNetEvent('v_browser:purchaseResult')
AddEventHandler('v_browser:purchaseResult', function(status, result, color)
    if status == 'SUCCESS' then
        Scaleform.Call(Browser.Scaleform, 'GO_TO_WEBPAGE', currentWebsiteUrl .. '_S_PURCHASE_D_SUCCESS')
        if personalVehicle ~= nil then
            RemoveBlip(personalVehicleBlip)
            SetEntityAsNoLongerNeeded(personalVehicle)
        end
        personalVehicle = Vehicle.Create(result, true, color)
    else
        Scaleform.Call(Browser.Scaleform, 'GO_TO_WEBPAGE', currentWebsiteUrl .. '_S_PURCHASE_D_FAILED')

        Scaleform.Call(Browser.Scaleform, 'UPDATE_TEXT')
    end
end)

RegisterCommand("browser", function(source, args, rawCommand)
    Browser.Open()
end, true)

RegisterCommand("value", function(source, args, rawCommand)
    print(GetVehicleModelValue(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))))
    print(GetEntityCoords(PlayerPedId()))
end, true)

RegisterCommand("weapons", function(source, args, rawCommand)
    local weaponsToGive = { 'WEAPON_PISTOL', 'WEAPON_PUMPSHOTGUN', 'WEAPON_GRENADE', 'WEAPON_MINIGUN' }
    for k, v in pairs(weaponsToGive) do
        print(k, v)
        GiveWeaponToPed(PlayerPedId(), GetHashKey(v), 5000, true, false)
        SetPedInfiniteAmmo(PlayerPedId(), true, GetHashKey(v))
    end
    
    RefillAmmoInstantly(PlayerPedId())
    SetPedInfiniteAmmoClip(PlayerPedId(), true)
    SetEntityInvincible(PlayerPedId(), true)
    --Citizen.CreateThread(function()
    --
    --    while true do
    --        local ret, pos = GetPedLastWeaponImpactCoord(PlayerPedId())
	--		if ret then
	--			AddExplosion(pos.x, pos.y, pos.z, 1, 1.0, 1, 0, 0.1)
	--		end
    --        Wait(0)
    --    end
    --end)
end, true)

RegisterCommand("gosh", function(source, args, rawCommand)
    Vehicle.Create('cargobob', true, 45)

    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    CreatePickUpRopeForCargobob(veh, 1)    

    SetCargobobPickupMagnetStrength(veh, 9999.0)
    SetCargobobPickupMagnetEffectRadius(veh, 9999.0)
    SetCargobobPickupMagnetPullStrength(veh, 25.0)

    SetEntityInvincible(veh, true)
end, true)

local _showCoords = false
local _debugCamera = nil
local _debugCamera2 = nil

RegisterCommand("coords", function(source, args, rawCommand)
    _showCoords = not _showCoords
    Citizen.CreateThread(function()

        while _showCoords do
            local coords = GetEntityCoords(PlayerPedId())

            BeginTextCommandPrint('STRING')
            AddTextComponentSubstringPlayerName(coords)
            EndTextCommandPrint(1000, true)
            Wait(50)
        end
    end)
end, true)

RegisterCommand('intcam', function(source, args, rawCommand)
    
    _debugCamera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(_debugCamera, 347.7362, -1001.3665, -98.5439)
    SetCamRot(_debugCamera, -4.8526, 0.012, 148.3145, 2)
    SetCamFov(_debugCamera, 34.0)
    ShakeCam(_debugCamera, "HAND_SHAKE", 0.25)
    RenderScriptCams(true, false, 3000, true, false, 0)


    local doorHash = GetHashKey('v_ilev_mp_mid_frontdoor')
    RequestModel(doorHash)
    repeat Wait(1) until HasModelLoaded(doorHash)

    local doorId = CreateObjectNoOffset(doorHash, 345.8695, -1003.079, -99.104, false, false, false)
    SetEntityRotation(doorId, 0.0, 0.0, 180.0, 2, true)
    FreezeEntityPosition(doorId, true)
    --SetEntityVisible(doorId, false, false)
    --AddDoorToSystem('PROP_69_DOOR_0', GetHashKey('v_ilev_mp_mid_frontdoor'), 345.8695, -1003.079, -99.1045, false, false, false)
    --DoorSystemSetDoorState('PROP_69_DOOR_0', 1, false, false)

    local animDoorId = CreateObjectNoOffset(doorHash, 345.8695, -1003.079, -99.104, false, false, true)
    local animDict = "anim@apt_trans@hinge_l"
    RequestAnimDict(animDict)
    repeat Wait(0) until HasAnimDictLoaded(animDict)

    local scene = CreateSynchronizedScene(346.55, -1003.173, -100.26, 0.0, 0.0, 0.0, 2)
    TaskSynchronizedScene(PlayerPedId(), scene, animDict, 'ext_player', 1000.0, -1000.0, 4, 0, 1148846080, 0)
    PlaySynchronizedEntityAnim(animDoorId, scene, 'ext_door', animDict, 1000.0, 1090519040, 0, 0)
    SetSynchronizedScenePhase(scene, 0.1)

    repeat Wait(100) until GetSynchronizedScenePhase(scene) > 0.65
    ClearPedTasksImmediately(PlayerPedId())
    --SetEntityVisible(doorId, true, true)

    DeleteObject(animDoorId)
    RenderScriptCams(0, 0, 0, 0, 0, 0)
    DestroyCam(_debugCamera, true)

end)

RegisterCommand("extcam", function(source, args, rawCommand)
    _debugCamera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(_debugCamera, 11.0097, 81.2408, 78.7658)
    SetCamRot(_debugCamera, -4.0039, -0.0606, 99.0836, 2)
    SetCamFov(_debugCamera, 34.0)
    ShakeCam(_debugCamera, "HAND_SHAKE", 0.25)
    RenderScriptCams(true, false, 3000, true, false, 0)

    ClearPedTasksImmediately(PlayerPedId())

    local animDict = "anim@apt_trans@hinge_r"

    RequestAnimDict(animDict)
    repeat Wait(0) until HasAnimDictLoaded(animDict)
    
    SetEntityCoords(PlayerPedId(), 10.2835, 81.9529, 77.4349, true, false, false, true)
    SetEntityHeading(PlayerPedId(), 142.2)

    local scene = CreateSynchronizedScene(9.311, 81.125, 77.209, 0.0, 0.0, -20.0, 2)
    TaskSynchronizedScene(PlayerPedId(), scene, animDict, 'ext_player', 1000.0, -1000.0, 4, 0, 1148846080, 0)

    AddDoorToSystem('apt_10_dev', GetHashKey('prop_bh1_44_door_01r'), 8.74, 81.31, 78.65, false, false, false)
    DoorSystemSetDoorState('apt_10_dev', 1, false, false)
    local found, doorHash = DoorSystemFindExistingDoor(8.74, 81.31, 78.65, GetHashKey('prop_bh1_44_door_01r'))
    
    local doorId = GetClosestObjectOfType(8.74, 81.31, 78.65, 1.0, GetHashKey('prop_bh1_44_door_01r'), false, false, false)
    SetEntityVisible(doorId, false, false)

    local doorModelHash = GetHashKey('prop_bh1_44_door_01r')
    RequestModel(doorModelHash)
    repeat Wait(1) until HasModelLoaded(doorModelHash)

    local animDoorId = CreateObjectNoOffset(doorModelHash, 8.74, 81.31, 78.65, false, false, true)
    print(animDoorId, IsModelValid(doorModelHash), HasModelLoaded(doorModelHash))
    
    PlaySynchronizedEntityAnim(animDoorId, scene, 'ext_door', animDict, 1000.0, -1000.0, 0, 1148846080)
    

    repeat Wait(100) until GetSynchronizedScenePhase(scene) > 0.65
    SetEntityVisible(doorId, true, false)
    DeleteObject(animDoorId)
    ClearPedTasksImmediately(PlayerPedId())
    DestroyCam(_debugCamera, true)
   

    _debugCamera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    _debugCamera2 = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    SetCamCoord(_debugCamera, 5.9445, 97.0624, 85.2171)
    SetCamRot(_debugCamera, -28.0555, 0.0, -161.6681, 2)
    SetCamFov(_debugCamera, 35.9431)
    ShakeCam(_debugCamera, "HAND_SHAKE", 0.25)

    SetCamCoord(_debugCamera2, 5.9445, 97.0624, 85.2171)
    SetCamRot(_debugCamera2, 22.9757, 0.0, -165.5721, 2)
    SetCamFov(_debugCamera2, 35.9431)
    ShakeCam(_debugCamera2, "HAND_SHAKE", 0.25)

    SetCamActive(_debugCamera, true)
    SetCamActive(_debugCamera2, true)

    SetCamActiveWithInterp(_debugCamera2, _debugCamera, 6500, 1, 1)
    RenderScriptCams(true, false, 3000, 1, 0, 0)

    repeat Wait(100) until not IsCamInterpolating(_debugCamera2)
    RenderScriptCams(0, 0, 0, 0, 0, 0)
    DestroyCam(_debugCamera, true)
    DestroyCam(_debugCamera2, true)    
end, true)

Citizen.CreateThread(function()
    local playerPed = PlayerPedId()
    while true do
        if personalVehicle ~= nil then

            local vehModel = GetEntityModel(personalVehicle)
            local vehBlip = Vehicle.GetBlipSprite(vehModel)
            local blipType = 225

            if IsThisModelABike(vehModel) then
                blipType = 348
            elseif IsThisModelABoat(vehType) then
                blipType = 427
            elseif IsThisModelAHeli(vehType) then
                blipType = 422
            elseif IsThisModelAPlane(vehType) then
                blipType = 423
            elseif vehBlip > 0 then
                blipType = vehBlip
            --elseif IsThisModelABicycle(vehType) then
            --    blipType = 308
            end

            if IsEntityDead(personalVehicle) then
                if personalVehicleBlip ~= nil then
                    RemoveBlip(personalVehicleBlip)
                    personalVehicleBlip = nil
                end
            elseif personalVehicleBlip == nil and not IsPedInVehicle(playerPed, personalVehicle) then
                personalVehicleBlip = AddBlipForEntity(personalVehicle)
                SetBlipSprite(personalVehicleBlip, blipType)
                SetBlipNameFromTextFile(personalVehicleBlip, "PVEHICLE")
            end

            if IsPedInVehicle(playerPed, personalVehicle) and personalVehicleBlip ~= nil then
                RemoveBlip(personalVehicleBlip)
                personalVehicleBlip = nil
            end
        end

        Wait(500)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    TriggerEvent('vf_properties:setup')
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    Browser.Close()
    SetEntityAsNoLongerNeeded(personalVehicle)
    DestroyCam(_debugCamera, true)
    DestroyCam(_debugCamera2, true)
end)



local _debugBlips = {
    { -773.4775, 310.6321, 84.6981 },
    { -252.5713, -949.9199, 30.221 },
    { -1443.0938, -544.7684, 33.7424 },
    { -913.85, -455.1392, 38.5999 },
    { -47.3145, -585.9766, 36.9593 },
    { -932.7474, -383.9246, 37.9613 },
    { -619.1315, 37.8841, 42.5883 },
    { 284.9614, -159.9891, 63.6221 },
    { 2.8889, 35.7762, 70.5349 },
    { 9.74, 84.6906, 77.3975 },
    { -512.1465, 111.2223, 62.351 },
    { -197.3405, 88.1053, 68.7422 },
    { -628.3212, 165.8364, 60.1651 },
    { -973.3757, -1429.4247, 6.6791 },
    { -829.1362, -855.0104, 18.6297 },
    { -757.5739, -755.5591, 25.5697 },
    { -45.1289, -57.0925, 62.2531 },
    { -206.7293, 184.142, 79.3279 },
    { -811.7045, -984.1961, 13.1538 },
    { -664.0032, -853.6744, 23.4325 },
    { -1534.0247, -324.5247, 46.5237 },
    { -1561.381, -412.1974, 41.389 },
    { -1608.8514, -429.184, 39.439 },
    { 964.3583, -1034.1991, 39.8303 },
    { 894.2868, -885.5679, 26.1212 },
    { 821.1741, -924.1658, 25.1998 },
    { 759.7933, -759.8209, 25.759 },
    { 844.7289, -1164.0997, 24.2681 },
    { 526.2521, -1604.613, 28.2625 },
    { 572.0462, -1570.7357, 27.4904 },
    { 722.2852, -1190.6168, 23.282 },
    { 497.6212, -1494.0845, 28.2893 },
    { 480.3127, -1549.9368, 28.2828 },
    { -68.702, 6426.148, 30.439 },
    { -247.4374, 6240.294, 30.4892 },
    { 2554.1653, 4668.059, 33.0233 },
    { 2461.2202, 1589.2552, 32.0443 },
    { -2203.335, 4244.4272, 47.3305 },
    { 218.0665, 2601.8171, 44.7668 },
    { 186.1719, 2786.3425, 45.0144 },
    { 642.0746, 2791.7295, 40.9795 },
    { -1130.9376, 2701.1333, 17.8004 },
    { -10.944, -1646.7601, 28.3125 },
    { 1024.2628, -2398.4036, 29.1261 },
    { 870.8577, -2232.3228, 29.5508 },
    { -663.8541, -2380.389, 12.9446 },
    { -1088.6158, -2235.0977, 12.2182 },
    { -342.5126, -1468.6746, 29.6107 },
    { -1241.5399, -259.8841, 37.9445 },
    { 899.8448, -147.528, 75.5674 },
    { -1405.4109, 526.8572, 122.8361 },
    { 1341.5518, -1578.0366, 53.4443 },
    { -105.7029, 6528.539, 29.1719 },
    { -302.3985, 6327.434, 31.8918 },
    { -15.258, 6557.378, 32.2454 },
    { 1899.6729, 3773.1785, 31.8829 },
    { 1662.1211, 4776.317, 41.0075 },
    { -178.2278, 490.886, 134.0466 },
    { 339.5743, 439.7083, 145.5896 },
    { -764.6163, 618.3144, 137.5536 },
    { -679.5461, 592.5162, 139.693 },
    { 124.4571, 551.8877, 181.658 },
    { -563.7349, 689.099, 151.6596 },
    { -743.0927, 590.0371, 140.9221 },
    { -861.252, 684.8923, 146.2643 },
    { -1292.4557, 440.9454, 93.7572 },
    { 369.5891, 417.4813, 136.8344 },
    { -1581.5015, -558.2578, 33.9528 },
    { -1379.5457, -499.1783, 32.1574 },
    { -117.5296, -605.7157, 35.2857 },
    { -67.0943, -802.4415, 43.2273 },
    { 254.1892, -1809.1831, 26.1805 },
    { -1472.2778, -920.0677, 8.9683 },
    { 38.9478, -1026.6288, 28.6354 },
    { 46.903, 2789.8247, 57.1124 },
    { -342.3246, 6065.3164, 30.4895 },
    { 1737.8784, 3709.0876, 33.1348 },
    { 939.7161, -1459.2039, 30.467 },
    { 189.7624, 309.7488, 104.4714 },
    { -21.9593, -191.3618, 51.5599 },
    { 2472.2197, 4110.4927, 36.9629 },
    { -39.3286, 6420.6025, 30.7017 },
    { -1134.762, -1568.848, 3.4077 }
}


Citizen.CreateThread(function()
    for k, v in pairs(_debugBlips) do
        AddBlipForCoord(v[1], v[2], v[3])
    end
end)
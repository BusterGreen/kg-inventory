local holdingDrop = false
local bagObject = nil
local heldDrop = nil
CurrentDrop = nil

-- Functions

function GetDrops()
    KGCore.Functions.TriggerCallback('kg-inventory:server:GetCurrentDrops', function(drops)
        if drops then
            for k, v in pairs(drops) do
                local bag = NetworkGetEntityFromNetworkId(v.entityId)
                if DoesEntityExist(bag) then
                    exports['kg-target']:AddTargetEntity(bag, {
                        options = {
                            {
                                icon = 'fas fa-backpack',
                                label = Lang:t('menu.o_bag'),
                                action = function()
                                    TriggerServerEvent('kg-inventory:server:openDrop', k)
                                    CurrentDrop = dropId
                                end,
                            },
                        },
                        distance = 2.5,
                    })
                end
            end
        end
    end)
end

-- Events

RegisterNetEvent('kg-inventory:client:removeDropTarget', function(dropId)
    while not NetworkDoesNetworkIdExist(dropId) do Wait(10) end
    local bag = NetworkGetEntityFromNetworkId(dropId)
    while not DoesEntityExist(bag) do Wait(10) end
    exports['kg-target']:RemoveTargetEntity(bag)
end)

RegisterNetEvent('kg-inventory:client:setupDropTarget', function(dropId)
    while not NetworkDoesNetworkIdExist(dropId) do Wait(10) end
    local bag = NetworkGetEntityFromNetworkId(dropId)
    while not DoesEntityExist(bag) do Wait(10) end
    local newDropId = 'drop-' .. dropId
    exports['kg-target']:AddTargetEntity(bag, {
        options = {
            {
                icon = 'fas fa-backpack',
                label = Lang:t('menu.o_bag'),
                action = function()
                    TriggerServerEvent('kg-inventory:server:openDrop', newDropId)
                    CurrentDrop = newDropId
                end,
            },
            {
                icon = 'fas fa-hand-pointer',
                label = 'Pick up bag',
                action = function()
                    if IsPedArmed(PlayerPedId(), 4) then
                        return KGCore.Functions.Notify("You can not be holding a Gun and a Bag!", "error", 5500) 
                    end
                    if holdingDrop then
                        return KGCore.Functions.Notify("Your already holding a bag, Go Drop it!", "error", 5500)
                    end
                    AttachEntityToEntity(
                        bag,
                        PlayerPedId(),
                        GetPedBoneIndex(PlayerPedId(), Config.ItemDropObjectBone),
                        Config.ItemDropObjectOffset[1].x,
                        Config.ItemDropObjectOffset[1].y,
                        Config.ItemDropObjectOffset[1].z,
                        Config.ItemDropObjectOffset[2].x,
                        Config.ItemDropObjectOffset[2].y,
                        Config.ItemDropObjectOffset[2].z,
                        true, true, false, true, 1, true
                    )
                    bagObject = bag
                    holdingDrop = true
                    heldDrop = newDropId
                    exports['kg-core']:DrawText('Press [G] to drop the bag')
                end,
            }
        },
        distance = 2.5,
    })
end)

-- NUI Callbacks

RegisterNUICallback('DropItem', function(item, cb)
    KGCore.Functions.TriggerCallback('kg-inventory:server:createDrop', function(dropId)
        if dropId then
            while not NetworkDoesNetworkIdExist(dropId) do Wait(10) end
            local bag = NetworkGetEntityFromNetworkId(dropId)
            SetModelAsNoLongerNeeded(bag)
            PlaceObjectOnGroundProperly(bag)
            FreezeEntityPosition(bag, true)
            local newDropId = 'drop-' .. dropId
            cb(newDropId)
        else
            cb(false)
        end
    end, item)
end)

-- Thread

CreateThread(function()
    while true do
        if holdingDrop then
            if IsControlJustPressed(0, 47) then
                DetachEntity(bagObject, true, true)
                local coords = GetEntityCoords(PlayerPedId())
                local forward = GetEntityForwardVector(PlayerPedId())
                local x, y, z = table.unpack(coords + forward * 0.57)
                SetEntityCoords(bagObject, x, y, z - 0.9, false, false, false, false)
                FreezeEntityPosition(bagObject, true)
                exports['kg-core']:HideText()
                TriggerServerEvent('kg-inventory:server:updateDrop', heldDrop, coords)
                holdingDrop = false
                bagObject = nil
                heldDrop = nil
            end
        end
        Wait(0)
    end
end)

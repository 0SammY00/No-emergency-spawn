local emergencyVehicles = {
    'police', 'police2', 'police3', 'police4', 'policeb', 'policet', 'sheriff', 'sheriff2',
    'fbi', 'fbi2', 'ambulance', 'firetruk'
}

Citizen.CreateThread(function()
    for _, vehicle in ipairs(emergencyVehicles) do
        local vehicleHash = GetHashKey(vehicle)
        SetVehicleModelIsSuppressed(vehicleHash, true)
    end

    while true do
        Citizen.Wait(0)
        
        -- Get all vehicles in the vicinity
        local handle, vehicle = FindFirstVehicle()
        local success
        repeat
            local vehicleModel = GetEntityModel(vehicle)
            for _, emergencyVehicle in ipairs(emergencyVehicles) do
                if vehicleModel == GetHashKey(emergencyVehicle) then
                    SetEntityAsMissionEntity(vehicle, true, true)
                    DeleteVehicle(vehicle)
                    if DoesEntityExist(vehicle) then
                        DeleteVehicle(vehicle) -- Fallback in case the first delete fails
                    end
                end
            end
            success, vehicle = FindNextVehicle(handle)
        until not success

        EndFindVehicle(handle)
    end
end)

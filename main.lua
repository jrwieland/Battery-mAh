---- #########################################################################
---- #                                                                       #
---- # Telemetry Widget for EdgeTX Radios                                    #
---- # Copyright (C) EdgeTX                                                  #
-----#                                                                       #
---- # License GPLv2: http://www.gnu.org/licenses/gpl-2.0.html               #
---- #                                                                       #
---- # This program is free software; you can redistribute it and/or modify  #
---- # it under the terms of the GNU General Public License version 2 as     #
---- # published by the Free Software Foundation.                            #
---- #                                                                       #
---- # This program is distributed in the hope that it will be useful        #
---- # but WITHOUT ANY WARRANTY; without even the implied warranty of        #
---- # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
---- # GNU General Public License for more details.                          #
---- #                                                                       #
---- #########################################################################

-- Widget to display the levels of lipo/HVLipo battery with mAh Used based on battery voltage
-- JRWieland
-- Date: 2024
local app_name = "Batt/mAh"
local app_ver = "1.2"

local _options = {
  { "Sensor", SOURCE, 0}, -- use'Cels'
  {"Capacity", STRING, "3200"}, -- Lipo Capacity
  {"Cells", VALUE, 6,2,12}, --Default Cells of Lipo, Min Value, Max Value
  {"Voltage", STRING, "4.20"}, --Default Voltage of Lipo Cells, 4.35 for HV Lipos
}
-----------------------------------------------------------------

local function create(zone, options)
  local wgt = {
    zone = zone,
    options = options,
    isDataAvailable = 0,
    cellDataHistoryLowest = { 5, 5, 5, 5, 5, 5, 5, 5 },
    cellDataHistoryCellLowest = 5,
    cellMin = 0,
    cellPercent = 0,
  }
  return wgt
end

local function update(wgt, options)
  if (wgt == nil) then return end
  wgt.options = options
end

local function getCellPercent(wgt, cellValue)
  if cellValue == nil then
    return 0
  end
  local result = 0;

  if wgt.options.Voltage >= "4.21"then
    loadScript("/WIDGETS/BattmAh/4_35lipo.lua")()
  else
    loadScript("/WIDGETS/BattmAh/4_2lipo.lua")()
  end

  local _percentSplit = lipoValue
  for i1, v1 in ipairs(_percentSplit) do
    if (cellValue <= v1[#v1][1]) then
      for i2, v2 in ipairs(v1) do
        if v2[1] >= cellValue then
          result = v2[2]
          return result
        end
      end
    end
  end
  return 100
end

--- This function returns a table with cels values
local function calculateBatteryData(wgt)
  local newCellData = getValue(wgt.options.Sensor)
  if type(newCellData) ~= "table" then
    wgt.isDataAvailable = false
    return
  end

  local cellMax = 0
  local cellMin = 5
  local cellSum = 0

  for k, v in pairs(newCellData) do
    -- stores the lowest cell values in historical table
    if v > 1 and v < wgt.cellDataHistoryLowest[k] then
      -- min 1v to consider a valid reading
      wgt.cellDataHistoryLowest[k] = v

      --- calc history lowest of all cells
      if v < wgt.cellDataHistoryCellLowest then
        wgt.cellDataHistoryCellLowest = v
      end
    end

--- calc lowest of all cells
    if v < cellMin and v > 1 then
      cellMin = v
    end
  end

  wgt.cellMin = cellMin
  wgt.isDataAvailable = true
  wgt.cellPercent = getCellPercent(wgt, wgt.cellMin) 
end

--- Zone size: 70x39 top bar
local function refreshZoneTiny(wgt)
  calculateBatteryData(wgt) 
  getCellPercent(wgt)
  -- local battCell=wgt.options.Cells   
  local battDis = wgt.options.Capacity
  local mAhUsed = (battDis*((wgt.cellPercent)/100))

  function comma(amount)
    local formatted = amount
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
  end

  lcd.drawText(0,0,comma(mAhUsed).." Mha",SMLSIZE+WHITE)-- Change or remove color if desired
  lcd.drawText(0,15, string.format("%2.0f%%",wgt.cellPercent),SMLSIZE+WHITE)
end 

--- Zone size: others
local function refreshZoneSmall(wgt)
  calculateBatteryData(wgt) 
  getCellPercent(wgt)
  local battCell=wgt.options.Cells   
  local battDis = wgt.options.Capacity
  local mAhUsed = (battDis*((wgt.cellPercent)/100))

  function comma(amount)
    local formatted = amount
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
  end
  lcd.drawText(2,0,comma(battDis).." "..battCell.."S Lipo "..wgt.options.Voltage.."v/cell")
  lcd.drawText(2,18,comma(mAhUsed).." Used / ".. string.format("%2.0f%%", wgt.cellPercent))
end

local function refresh(wgt)
  if wgt.zone.w >  150 and wgt.zone.h >  28 then refreshZoneSmall(wgt)
  elseif wgt.zone.w >  65 and wgt.zone.h >  35 then refreshZoneTiny(wgt)
  end
end

local function background(wgt)
  calculateBatteryData(wgt)
end

return { name = app_name, options = _options, create = create, update = update, background = background, refresh = refresh }

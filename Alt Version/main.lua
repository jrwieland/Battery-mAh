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
local app_ver = "1.1"

local _options = {
--{ "Sensor", SOURCE, 0}, -- I hard coded the sensor into the widgets, if you wish to have source chage the lines noted below in the comments
  {"Capacity", STRING, "3200"}, -- Lipo Capacity
  {"Cells", VALUE, 6,2,12}, --Default Cells of Lipo, Min Value, Max Value
  {"Voltage", STRING, "4.20"}, --Default Voltage of Lipo Cells, 4.35 for HV Lipos
}
-----------------------------------------------------------------

local function create(zone, options)
  local wgt = {
    zone = zone,
    options = options,
  }
  return wgt
end

local function update(wgt, options)
  if (wgt == nil) then return end
  wgt.options = options
end

local function getCellPercent(wgt, cellValue)
  cellValue = getValue("Lcel") -- if Sensor option is used comment this line and uncomment the next
  --cellValue = wgt.options.Sensor

  local result = 0;
  if wgt.options.Voltage >= "4.21"then
    loadScript("/WIDGETS/BattmAh/4_35lipo.lua")()
  else
    loadScript("/WIDGETS/BattmAh/4_2lipo.lua")()
  end

  for i1, v1 in ipairs(lipoValue) do
    if (cellValue <= v1[#v1][1]) then
      for i2, v2 in ipairs(v1) do
        if v2[1] >= cellValue then
          cell1 = v2[2]
          return cell1
        end
      end
    end
  end
  return 100
end

--- Zone size: 70x39 top bar
local function refreshZoneTiny(wgt)
  local battCell=wgt.options.Cells   
  local battDis = wgt.options.Capacity
  local mAhUsed = (battDis*((100-wgt.cellPercent)/100))
  
  lcd.drawText(0,0,comma(mAhUsed).." Mha",SMLSIZE+WHITE)-- Change or remove color if desired
  lcd.drawText(0,15, string.format("%2.0f%%",wgt.cellPercent).." Left",SMLSIZE+WHITE)
end 

--- Zone size: others
local function refreshZoneSmall(wgt)
  local battCell=wgt.options.Cells   
  local battDis = wgt.options.Capacity
  local mAhUsed = (battDis*((100-wgt.cellPercent)/100))

  lcd.drawText(2,0,comma(battDis).." "..battCell.."S Lipo "..wgt.options.Voltage.."v/cell")
  lcd.drawText(2,18,comma(mAhUsed).." Used / ".. string.format("%2.0f%%", wgt.cellPercent).." Left")
end 

local function refresh(wgt)

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

  wgt.cellPercent = getCellPercent(wgt, wgt.cellValue)

  if wgt.zone.w >  150 and wgt.zone.h >  28 then refreshZoneSmall(wgt)
  elseif wgt.zone.w >  65 and wgt.zone.h >  35 then refreshZoneTiny(wgt)
  end
end

local function background(wgt)
end

return { name = app_name, options = _options, create = create, update = update, background = background, refresh = refresh }

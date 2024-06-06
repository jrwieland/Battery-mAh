# Battery Percentage and mAh Used
Widget to display the levels of Lipo/HV-Lipo battery with mAh Used based on battery voltage from 'Cels' sensor (FLVSS)     

<img src="https://github.com/jrwieland/Battery-mAh/blob/main/Screenshots/4_2lipo.png" width="300">  <img src="https://github.com/jrwieland/Battery-mAh/blob/main/Screenshots/4_35lipo.png" width="300">    
  
If you've ever wondered what % of your battery was left and how much mAh you've used     
This widget will display them based on the lowest cell from the telemetry obtained from the (FLVSS).
* This is not an "Actual" reading of the mAh.  It is a calculation based on the remaining volts of the battery.
* "Actual" mAh consumed can only be obtained from a consumption sensor.

The mAh is based on the Lipo discharge rate of commercially available sensors.   
The % listed is based on full 4.20 or 4.35 volts/cell represented as 100% and 3.0 volts as 0%     
 <img src="https://github.com/jrwieland/Battery-Mha/blob/main/Screenshots/Lipo.png" width="320">     
     
The live readings are taken from the lowest cell of your pack while connected.    
The % and mAh  numbers typically rise after a flight since the load is reduced and the battery settles.     

## Setup
Download the release [BattmAh.zip](https://github.com/jrwieland/Battery-mAh/releases/download/v1.0/BattmAh.zip)       

Extract the folder to the WIDGETS folder on the SD card     
Select the Widget from the screen     

Options available 
* Setting the sensor Choose 'Cels' or the calculations will be off
* Setting the Capacity of the battery
* Setting the number of cells (this is for a visual indication of the battery you’re flying and has no effect on the calculations)
* Setting the voltage of the cells in the pack.  There is a different chart for 4.2 Lipo’s & 4.35 HV-Lipo’s
 ![Edit Settings](/Screenshots/edit.png)

## Streamlined Version
If you prefer to use a calculted sensor as I do, it eliminates alot in internal lookups and makes it easier to install into existing scripts     
Download this version here [BattmAh_v1.1.zip](https://github.com/jrwieland/Battery-mAh/releases/download/v1.0/BattmAh_v1.1.zip)     
Extract the files to the Widgets folder    
Create a calculated sensor      
Here is what is hard coded  (instructions are included for using the sensor widget option with this version within the main.lua file    
![Calculated sensor](/Screenshots/sensor.png)      

Download this version here [BattmAh_v1.1.zip](https://github.com/jrwieland/Battery-mAh/releases/download/v1.0/BattmAh_v1.1.zip)     
  
## Assets
Initial Version [BattmAh.zip](https://github.com/jrwieland/Battery-mAh/releases/download/v1.0/BattmAh.zip)       
Streamlined Version [BattmAh_v1.1.zip](https://github.com/jrwieland/Battery-mAh/releases/download/v1.1/BattmAh_v1.1.zip)        

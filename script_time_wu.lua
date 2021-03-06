-- Weatherunderground PWS upload script
-- (C)2013 GizMoCuz - upgraded with pressure by epierre

Outside_Temp_Hum = 'Exterieur'
Inside_Temp_Hum = 'Salon'
Pressure = 'Mysensors Baro'
Barometer = ''
RainMeter = 'Pluie'
WindMeter = 'Vent'
UVMeter = 'UV'
LuxMeter = 'Lux'
PM25 = 'PPDNS42PM25'
PM10 = 'PPDNS42PM10'

--WU Settings
baseurl = "http://weatherstation.wunderground.com/weatherstation/updateweatherstation.php?"
ID = ""
PASSWORD = ""

local function CelciusToFarenheit(C)
   return (C * (9/5)) + 32
end

local function hPatoInches(hpa)
   return hpa * 0.0295301
end

local function mmtoInches(mm)
   if mm == nil then return 0 end
   return mm * 0.039370
end

local function luxtoWattsm2(mm)
   if mm == nil then return 0 end
   return mm * 0.0079
end
utc_dtime = os.date("!%m-%d-%y %H:%M:%S",os.time())

month = string.sub(utc_dtime, 1, 2)
day = string.sub(utc_dtime, 4, 5)
year = "20" .. string.sub(utc_dtime, 7, 8)
hour = string.sub(utc_dtime, 10, 11)
minutes = string.sub(utc_dtime, 13, 14)
seconds = string.sub(utc_dtime, 16, 17)

timestring = year .. "-" .. month .. "-" .. day .. "+" .. hour .. "%3A" .. minutes .. "%3A" .. seconds

SoftwareType="Domoticz"

WU_URL= baseurl .. "ID=" .. ID .. "&PASSWORD=" .. PASSWORD .. "&dateutc=" .. timestring
--&winddir=230
--&windspeedmph=12
--&windgustmph=12

if Outside_Temp_Hum ~= '' then
   WU_URL = WU_URL .. "&tempf=" .. string.format("%3.1f", CelciusToFarenheit(otherdevices_temperature[Outside_Temp_Hum]))
   WU_URL = WU_URL .. "&humidity=" .. otherdevices_humidity[Outside_Temp_Hum]
   WU_URL = WU_URL .. "&dewptf=" .. string.format("%3.1f", CelciusToFarenheit(otherdevices_dewpoint[Outside_Temp_Hum]))
end

if Inside_Temp_Hum ~= '' then
   WU_URL = WU_URL .. "&indoortempf=" .. string.format("%3.1f", CelciusToFarenheit(otherdevices_temperature[Inside_Temp_Hum]))
   WU_URL = WU_URL .. "&indoorhumidity=" .. otherdevices_humidity[Inside_Temp_Hum]
end

if Barometer ~= '' then
   WU_URL = WU_URL .. "&baromin=" .. string.format("%2.2f", hPatoInches(otherdevices_barometer[Barometer]))
end

if RainMeter ~= '' then
   WU_URL = WU_URL .. "&dailyrainin=" .. string.format("%2.2f", mmtoInches(otherdevices_rain[RainMeter]))
   WU_URL = WU_URL .. "&rainin=" .. string.format("%2.2f", mmtoInches(otherdevices_rain_lasthour[RainMeter]))
end

if WindMeter ~= '' then
   WU_URL = WU_URL .. "&winddir=" .. string.format("%.0f", otherdevices_winddir[WindMeter])
   WU_URL = WU_URL .. "&windspeedmph=" .. string.format("%.0f", (otherdevices_windspeed[WindMeter]/0.1)*0.223693629205)
   WU_URL = WU_URL .. "&windgustmph=" .. string.format("%.0f", (otherdevices_windgust[WindMeter]/0.1)*0.223693629205)
end

if UVMeter ~= '' then
   WU_URL = WU_URL .. "&UV=" .. string.format("%.1f", otherdevices_uv[UVMeter])
end

if Pressure ~= '' then
   WU_URL = WU_URL .. "&baromin=" .. string.format("%2.2f", hPatoInches(otherdevices_svalues[Pressure]))
end

if LuxMeter ~= '' then
   WU_URL = WU_URL .. "&solarradiation=" .. string.format("%2.2f", luxtoWattsm2(otherdevices_svalues[LuxMeter]))
end

if PM25 ~= '' then
   WU_URL = WU_URL .. "&AqPM2.5=" .. string.format("%u", otherdevices_utility[PM25])
end

if PM10 ~= '' then
   WU_URL = WU_URL .. "&AqPM10=" .. string.format("%u", otherdevices_utility[PM10])
end


--AqNO
--AqNO3
--AqSO4
--AqCO
--AqOZONE
--leafwetness
--soiltempf 2f
--soilmoisture 2 3 4
--&weather=
--&clouds=

WU_URL = WU_URL .. "&softwaretype=" .. SoftwareType .. "&action=updateraw"

--print (WU_URL)

commandArray = {}

--remove the line below to actualy upload it
commandArray['OpenURL']=WU_URL

return commandArray

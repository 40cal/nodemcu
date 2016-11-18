--mqtt.lua

relaypin=1
m = mqtt.Client("garage", 120, "", "") -- blank user and password

m:connect("192.168.20.9","1883",0,1) -- no SSL and use auto reconnect.

--When MQTT client connects then subscribe to home/garage
m:on("connect", function(client) m:subscribe("home/garage", 0) end)

m:on("message", function(client, topic, data) 
   
  if data ~= nil then
    if data == "togglegd" then
        cyclerelay(1000) --latch relay for 1 second, long enough to short control terminals on garage door opener to operate the door.
    end
    
  end
end)

function cyclerelay(strTimeMS)
    gpio.write(relaypin, gpio.HIGH)
    if not tmr.alarm(0, strTimeMS, tmr.ALARM_SINGLE, function() gpio.write(relaypin, gpio.LOW) end) then print("DEBUG: timer failed") end -- 1 second sleep
    mqttresponse("Toggled Garage Door")
end

function mqttresponse(strResponse)
    m:publish("home/responses",strResponse,0,0)
end

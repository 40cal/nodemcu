relaypin=1
m = mqtt.Client("garage", 120, "", "") -- blank user and password

m:connect("192.168.20.9","1883") -- my local broker's IP

--When MQTT client connects then subscribe to home/garage
m:on("connect", function(client) m:subscribe("home/garage", 0) end)

m:on("message", function(client, topic, data) 
   
  if data ~= nil then
    if data == "<mqtt value to match on goes here>" then
        cyclerelay(1000)
    end
    
  end
end)

function cyclerelay(strTimeMS) -- latch relay on GPIO 1 (which was defined in init.lua) for 1 second.
    gpio.write(relaypin, gpio.HIGH)
    if not tmr.alarm(0, strTimeMS, tmr.ALARM_SINGLE, function() gpio.write(relaypin, gpio.LOW) end) then print("DEBUG: timer failed") end -- 1 second sleep
    mqttresponse("Cycled relay")
end

function mqttresponse(strResponse)
    m:publish("home/responses",strResponse,0,0)
end

--init.lua

relaypin=1 --GPIO pin number the relay is attached to.
wifistatuspin=2 --GPIO pin number the WiFi connection status LED is connected to

gpio.mode(relaypin, gpio.OUTPUT) --relay
gpio.mode(wifistatuspin, gpio.OUTPUT) --status LED

--Register event to detect when WiFi is connected with an IP and then start MQTT and LED
wifi.sta.eventMonReg(wifi.STA_GOTIP, function() startmqtt() end)

--Register event to detect when WiFi is disconnected, shut off LED
wifi.sta.eventMonReg(wifi.STA_CONNECTING, function(previous_State)
    if(previous_State==wifi.STA_GOTIP) then 
        print("Station lost connection with access point\n\tAttempting to reconnect...")
        gpio.write(wifistatuspin, gpio.LOW) --Turn off WiFi connected LED
    else
        print("STATION_CONNECTING")
    end
end)

wifi.sta.eventMonStart()

function startmqtt ()
    dofile('mqtt.lua')
    gpio.write(wifistatuspin, gpio.HIGH)
    return
end

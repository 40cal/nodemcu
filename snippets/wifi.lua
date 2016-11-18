#connect to wifi, 1 is for auto-connect/auto reconnect
wifi.setmode(wifi.STATION)
wifi.sta.config("ssid", "password", 1)
print(wifi.sta.getip())

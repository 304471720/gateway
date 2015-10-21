module("luci.controller.mobile.index", package.seeall)
function index()
local root = node()
if not root.target then
root.target = alias("mobile")
root.index = true
end
local page   = node("mobile")
page.target  = firstchild()
page.title   = _("")
page.order   = 110
page.sysauth = "webadmin"
page.mediaurlbase = "/mobile"
page.sysauth_authenticator = "htmlauth_moblie"
page.index = true
entry({"mobile"}, template("mobile/index"), _(""), 111)
--entry({"mobile","network"}, call("network"), _(""), 110)
entry({"mobile","info"}, template("mobile/sysinfo"), _(""), 112)
entry({"mobile","wifi"}, call("action_wifi"), _(""), 113)
entry({"mobile","guide"}, call("action_guide"), _(""), 114)
entry({"mobile","reboot"}, call("action_reboot"), _(""), 117)
end
function action_logout()
local dsp = require "luci.dispatcher"
local sauth = require "luci.sauth"
if dsp.context.authsession then
sauth.kill(dsp.context.authsession)
dsp.context.urltoken.stok = nil
end
luci.http.header("Set-Cookie", "sysauth=; path=" .. dsp.build_url())
luci.http.redirect(luci.dispatcher.build_url())
end

function action_reboot()
	local reboot = luci.http.formvalue("reboot")
	luci.template.render("mobile/reboot", {reboot=reboot})
	if reboot then
		luci.sys.reboot()
	end
end


--------------------------------------------------start quick guide----------------------------------------
local is6358 = luci.util.exec("cat /proc/cpuinfo|grep -c 96358VW2") or 0 
local is6358 = tonumber(is6358) 
 uci = require "luci.model.uci".cursor()

function action_guide()

	require("luci.model.uci")

  -- Determine state
	local keep_avail   = true
	local step         = tonumber(luci.http.formvalue("step") or 0)

	-- Step 0: route mode select
if step == 0 then

	luci.template.render("mobile/guide", {
			step=0,
		} )

	-- Step 1:  wan setting  uci set route mode
	elseif step == 1 then
if  is6358 >= 1 then
      if luci.http.formvalue("cbid.route.model") then
       local route_model = tonumber(luci.http.formvalue("cbid.route.model"))
         if route_model == 1 then
          --uci:set("network", "wan", "ifname", "eth0")
        luci.util.exec("uci set network.wan.ifname=eth0")
        end
         if route_model == 2 then
         -- uci:set("network", "wan", "ifname", "eth1.1")
        luci.util.exec("uci set network.wan.ifname=\"eth1.1\"")
        end
    uci:save("network")
    uci:commit("network")

    end
end

		luci.template.render("mobile/guide", {
			step=1,

		} )

	-- Step 2: web lan setting ,uci set wan 
	elseif step == 2 then
		 uci = luci.model.uci.cursor()

if luci.http.formvalue("cbid.network.wan.proto") then
       network_wan_proto = luci.http.formvalue("cbid.network.wan.proto") 
    uci:set("network", "wan", "proto", network_wan_proto)
end

if luci.http.formvalue("cbid.network.wan.ipaddr") then
       network_wan_ipaddr = luci.http.formvalue("cbid.network.wan.ipaddr") 
      uci:set("network", "wan", "ipaddr", network_wan_ipaddr) 
end

if luci.http.formvalue("cbid.network.wan.netmask") then
       network_wan_netmask = luci.http.formvalue("cbid.network.wan.netmask") 
     uci:set("network", "wan", "netmask", network_wan_netmask)
end

if luci.http.formvalue("cbid.network.wan.gateway") then
       network_wan_gateway = luci.http.formvalue("cbid.network.wan.gateway") 
      uci:set("network", "wan", "gateway", network_wan_gateway) 
end

if luci.http.formvalue("cbid.network.wan.username") then
       network_wan_username = luci.http.formvalue("cbid.network.wan.username") 
      uci:set("network", "wan", "username", network_wan_username) 
 luci.util.exec("echo usrtname >>/tmp/use")
end

if luci.http.formvalue("cbid.network.wan.password") then
       network_wan_password = luci.http.formvalue("cbid.network.wan.password") 
      uci:set("network", "wan", "password", network_wan_password) 
end

if luci.http.formvalue("cbid.network.wan.dns") then
       network_wan_dns = luci.http.formvalue("cbid.network.wan.dns") 
      uci:set("network", "wan", "dns", network_wan_dns) 
end

if luci.http.formvalue("cbid.network.wan.macaddr") then
       network_wan_macaddr = luci.http.formvalue("cbid.network.wan.macaddr") 
      uci:set("network", "wan", "macaddr", network_wan_macaddr) 
end

uci:save("network")
		luci.template.render("mobile/guide", {
			step=2,

		} )


	-- Step 3: uci set lan and save all data--
	elseif step == 3 then
		 uci = luci.model.uci.cursor()
if luci.http.formvalue("cbid.network.lan.ipaddr") then
       network_lan_ipaddr = luci.http.formvalue("cbid.network.lan.ipaddr") 
      uci:set("network", "lan", "ipaddr", network_lan_ipaddr) 
end
if luci.http.formvalue("cbid.network.lan.netmask") then
       network_lan_netmask = luci.http.formvalue("cbid.network.lan.netmask") 
      uci:set("network", "lan", "netmask", network_lan_netmask)

end

if luci.http.formvalue("cbid.network.lan.macaddr") then
       network_lan_macaddr = luci.http.formvalue("cbid.network.lan.macaddr") 
      uci:set("network", "lan", "macaddr", network_lan_macaddr) 
 
end
uci:save("network")
		luci.template.render("mobile/guide", {
			step=3,
		} )
elseif step == 4 then
 uci = luci.model.uci.cursor()
		local uci = luci.model.uci.cursor()
		uci:load("network")
		uci:commit("network")
    luci.util.exec("ifup wan")
		luci.template.render("mobile/guide", {
			step=4,
		} )
    luci.util.exec("/etc/init.d/dnsmasq restart")
end
end




---------------------------------------WIFI----------------------------------------
local is6358 = luci.util.exec("cat /proc/cpuinfo|grep -c 96358VW2") or 0 
local is6358 = tonumber(is6358) 
 uci = require "luci.model.uci".cursor()

function action_wifi()

	require("luci.model.uci")

  -- Determine state
	local keep_avail   = true
	local step         = tonumber(luci.http.formvalue("step") or 0)

	-- Step 0: route mode select
if step == 0 then
		luci.template.render("mobile/wifi", {
			step=0,

		} )
	-- Step 0: uci set lan and save all data--
		 uci = luci.model.uci.cursor()
		local uci2 = luci.model.uci.cursor()
		local lan_ipaddr,netmask,macaddr
		local channel,ssid,encryption,key
		uci2:load("wireless")
		
		local wireless = luci.model.uci.cursor_state():get_all("wireless")
		local ifaces = {}
		
		for k, v in pairs(wireless) do
--		luci.sys.call("echo key="..key.." >/dev/ttyS1")			
		
if luci.http.formvalue("cbid.network.wireless.ssid") and v[".type"] == "wifi-iface" then
       network_wireless_ssid = luci.http.formvalue("cbid.network.wireless.ssid") 
      uci2:set("wireless", v[".name"], "ssid", network_wireless_ssid)
end
if luci.http.formvalue("cbid.network.wireless.channel") and v[".type"] == "wifi-device" then
       network_wireless_channel = luci.http.formvalue("cbid.network.wireless.channel") 
      uci2:set("wireless", v[".name"], "channel", network_wireless_channel)

end

if luci.http.formvalue("cbid.network.wireless.key") and v[".type"] == "wifi-iface" then
       network_wireless_key = luci.http.formvalue("cbid.network.wireless.key") 
      uci2:set("wireless", v[".name"], "key", network_wireless_key) 
 
end
       end
uci:save("network")
elseif step == 1 then
 uci = luci.model.uci.cursor()
		local uci = luci.model.uci.cursor()
		uci:load("network")
		uci:commit("network")
		luci.template.render("mobile/wifi", {
			step=2,
		} )
      luci.util.exec("/etc/init.d/network restart")
end
end


-----------------------**NETWORK**--------------------------


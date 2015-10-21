--[[
LuCI - Lua Configuration Interface

Copyright 2013 Steven Barth <steven@midlink.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

]]--

require("luci.sys")

local m, s, o

m = Map("ibeacon", translate("iBeacon"))


s = m:section(TypedSection, "server")
s.addremove = false
s.anonymous = true
	s:tab("jbsz", translate("基本设置"))
--[[
o = s:option(Flag, "ibeacon_enable", translate("开启/关闭"))
o.enabled = "0"                                                                                                 
o.disabled = "1"
               
o = s:option(Value, "UUID", translate("UUID"))
o = s:option(Value, "Major", translate("Major"))
o = s:option(Value, "Minor", translate("Minor"))
o = s:option(Value, "power", translate("power"))
]]--
	ibeacon_enable = s:taboption("jbsz",Flag, "ibeacon_enable", translate("开启/关闭"))

	uuid = s:taboption("jbsz",Value,"uuid","UUID","空格隔开")
	uuid.placeholder = "11 22 33 44 55 66 77 88 AA BB CC DD EE FF GG HH"
	major = s:taboption("jbsz",Value,"major","Major","0-65535")
	major.placeholder = "10002"
	minor = s:taboption("jbsz",Value,"minor","Minor","0-65535")
	minor.placeholder = "286"
	power = s:taboption("jbsz",Value,"power","Power")
	power.default = "c9"

local apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("/etc/init.d/ibeacon start")
end
                                                                                        
return m                   

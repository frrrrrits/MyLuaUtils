import "android.os.Looper"
import "androidx.lifecycle.Observer"
import "androidx.lifecycle.MutableLiveData"
import "id.lxs.animongo.utils.LuaLiveData"

--[[
you can used MutableLiveData instead if u dont want compile the java file 
  but if you using that lua cannot override protected functions

so we cant register the service when its need and
   unregister the service when its not longer used
     
but i think its fine if we just unregister it in onDestroy
]]

local NetworkStateObserver = {}
setmetatable(NetworkStateObserver, NetworkStateObserver)

function NetworkStateObserver:setNetworkConnectivityStatus(status)
  if Looper.myLooper() == Looper.getMainLooper() then
    self.livedata.setValue(status) else
    self.livedata.postValue(status)
  end
end

function NetworkStateObserver:getNetworkConnectivityStatus(callback)
  return self.livedata.observe(this, Observer {
    onChanged = callback
  })
end

function NetworkStateObserver:instance(interface)
  -- local livedata = MutableLiveData()
  local livedata = LuaLiveData(LuaLiveData.Lin(interface))
  self.livedata = livedata
  return self
end

function NetworkStateObserver.__call(self)
  local self = table.clone(NetworkStateObserver)
  return self
end

return NetworkStateObserver
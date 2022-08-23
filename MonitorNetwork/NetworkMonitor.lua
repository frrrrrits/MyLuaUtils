-- what the fck use LiveData in Lua??
-- im just experiment with something dumb
-- 2022/8/23 - ikimasho

import "android.content.Context"
import "android.net.Network"
import "android.net.ConnectivityManager"
import "android.net.NetworkCapabilities"
import "android.net.NetworkRequest"

import "util.network.NetworkStatus"
import "util.network.NetworkStateObserver"

local NetworkMonitor = {}
local networkStateObserver = NetworkStateObserver()

-- @param status: Update LiveData Status
-- you can use true or false whatever u want
local function changeStatus(self, status)
  self.networkStateObserver:setNetworkConnectivityStatus(status)
end

-- view more at
-- https://developer.android.com/reference/android/net/ConnectivityManager.NetworkCallback
local function Callback(self)
  return luajava.override(
  ConnectivityManager.NetworkCallback, {
    onAvailable = function(super, network)
      super(network)
      changeStatus(self, NetworkStatus.Available)
    end,
    onLost = function(super, network)
      super(network)
      changeStatus(self, NetworkStatus.Lost)
    end,
    onLosing = function(super, network, mxms)
      super(network, mxms)
      changeStatus(self, NetworkStatus.Losing)
    end,
    onUnavailable = function(super, network)
      changeStatus(self, NetworkStatus.Unavailable)
    end,
  })
end

-- @param contect: ApplicationContext
local function claszz(context)
  local self = {}
  local callback = Callback(self)
  local connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE)
  -- if u using MutableLiveData just delete the interface
  self.networkStateObserver = networkStateObserver:instance({
    -- register the service when its needed
    onActive = function()
      local builder = NetworkRequest.Builder()
      connectivityManager.registerNetworkCallback(builder
      .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
      .build(), callback)
    end,
    -- unregister if not longer used
    onInactive=lambda _:connectivityManager.unregisterNetworkCallback(callback)
  })
  
  -- Use MutableLiveData
  -- local builder = NetworkRequest.Builder()
  -- connectivityManager.registerNetworkCallback(builder
  -- .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
  -- .build(), callback)
 
  return setmetatable(self,{__index = NetworkMonitor})
end

--@param callback: function -> its return NetworkStatus value
function NetworkMonitor:getNetworkState(callback)
  self.networkStateObserver:getNetworkConnectivityStatus(callback)
end

-- local networkMonitor = NetworkMonitor(activity.getApplicationContext())
-- networkMonitor:getNetworkState(lambda result: print(result))
-- try on/off your aeroplane mode or wifi / disconnected your internet

return claszz
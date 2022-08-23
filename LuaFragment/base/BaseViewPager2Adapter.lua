-- viwpager2

import "androidx.viewpager2.widget.ViewPager2"
import "androidx.viewpager2.adapter.FragmentStateAdapter"
local toint = luajava.bindClass("java.lang.Integer")

-- or just (context)
return function(fragment, lifecycle, array)
  -- array should be a fragment 
  return luajava.override (
  FragmentStateAdapter,{
    getItemCount = function()
      return toint(#array)
    end,
    createFragment = function(super, position)
      local position = position + 1
      return array[position]
    end,
 
  }, fragment, lifecycle) --context)
end
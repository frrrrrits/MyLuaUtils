require "import"
import "base.LuaFragment"

local function instance()
  local layout ={
    CoordinatorLayout,
    layout_height="fill",
    layout_width="fill",
    {
      FrameLayout,
      layout_height="fill",
      layout_width="fill",
      {
        TextView,
        text="Hello Fragment 2",
        layout_gravity="center",
      }
    }
  }

  local ids = {}
  -- create first class
  local fragment = LuaFragment()
  
  -- override the function
  fragment:initCreator {
    -- to bind the view
    onCreateView = function()
      return loadlayout(layout, ids)
    end,
    -- access the view, this is like onCreate on activity
    onViewCreated = function()
      print("i am Fragment 2")                 
    end,
    -- onDestroy
    onDestroy = function()
      
    end,
  }
  -- create the instance
  return fragment:newInstance()
end

return {
  newInstance = instance
}
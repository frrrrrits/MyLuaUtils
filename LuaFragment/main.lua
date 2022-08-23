require "import"
import "androidx.viewpager2.widget.ViewPager2"
import "base.BaseViewPager2Adapter"
import "com.google.android.material.tabs.*"

local layout = {
  CoordinatorLayout,
  layout_height="fill",
  layout_width="fill",
  {
    AppBarLayout,
    id="appbar",
    layout_height="wrap",
    layout_width="fill",
    fitsSystemWindows = true,
    {
      MaterialToolbar,
      id="toolbar",
      layout_height="fill",
      layout_width="fill",
      -- layout_scrollFlags="exitUtilCollapsed",
    },
    {
      TabLayout,
      id="tabs",
      layout_height="wrap",
      layout_width="fill",
      -- layout_scrollFlags="scroll|enterAlways",
    }
  },
  {
    ViewPager2,
    id="pager",
    layout_height="fill",
    layout_width="fill",
    -- layout_behavior="appbar_scrolling_view_behavior",
  },
}

local binding = {}
local fragments = {
  title = { [1] = "Tab 1", [2] = "Tab 2" },
  fragment = {
    [1] = require("ui.TestFragment").newInstance(),
    [2] = require("ui.TestFragment2").newInstance(),
  }
}

-- @param tabs: TabLayout
-- @param pager: ViewPager2
-- @param labels: list of title to be shown in TabLayout
function setupWithViewpager(tabs, pager, labels)
  if #labels ~= pager.adapter.itemCount then
    error("The size of list and the tab count should be equal!")
  end
  TabLayoutMediator(tabs, pager,
  TabLayoutMediator.TabConfigurationStrategy {
    onConfigureTab = function(tab, position)
      position = position + 1
      tab.text = labels[position]
    end
  }).attach()
end

function onCreate()
  activity.setContentView(loadlayout(layout, binding))
  activity.setSupportActionBar(binding.toolbar)

  binding.pager.adapter = BaseViewPager2Adapter(
    activity.getSupportFragmentManager(),
    activity.getLifecycle(),
    fragments.fragment
  )

  binding.pager.setSaveEnabled(false)
  binding.pager.setOffscreenPageLimit(#fragments.fragment)

  setupWithViewpager(binding.tabs, binding.pager, fragments.title)
end
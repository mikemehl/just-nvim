local just = require("just")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local previewers = require("telescope.previewers")
local actions_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local function attach_mappings(prompt_bufnr, _)
  actions.select_default:replace(function()
    local selection = actions_state.get_selected_entry()
    actions.close(prompt_bufnr)
    just.run_recipe(selection.value)
  end)
  return true
end

local function entry_maker(recipe)
  return {
    value = recipe,
    display = recipe,
  }
end

local function previewer()
  return previewers.new_termopen_previewer({
    get_command = function(entry)
      return { "just", "-s", entry.value }
    end,
  })
end

local function picker(opts)
  local opts = opts or {}
  pickers
      .new(opts, {
        prompt_title = "Just Recipes",
        finder = finders.new_table({
          results = require("just").get_recipes(),
        }),
        sorter = conf.generic_sorter(opts),
        previewer = previewer(),
        attach_mappings = attach_mappings,
        entry_maker = entry_maker,
      })
      :find()
end

return require("telescope").register_extension({
  setup = function(ext_config, config) end,
  exports = {
    just = picker,
  },
})

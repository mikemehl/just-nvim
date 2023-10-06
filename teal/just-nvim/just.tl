-- Declare Just handle interface
local record Just 
  enum Flags 
    "changelog"
    "check"
    "choose"
    "clear_shell_args"
    "dump"
    "evaluate"
    "highlight"
    "init"
    "no_dotenv"
    "no_highlight"
    "quiet"
    "shell_command"
    "unstable"
    "variables"
  end
  record Opts 
    flags: {Flags}
    chooser: string
    color: string
    command: string
    dotenv_file: string
    dotenv_path: string
    justfile: string
    set: {string, string}
    shell: string
    shell_args: {string}
    work_dir: string
  end

  cmd: string
  recipes: {string}
  init: function(Just): boolean
  valid: function(Just): boolean
  new: function(): Just
  run_recipe: function(Just, string, Opts): boolean
end



-- Implement private functions
local function find_command(): string | nil 
  local just_cmd = vim.system({'which', 'just'}, {text = true}):wait()
  if just_cmd.code ~= 0 then
    return nil
  end
  return just_cmd.stdout as string
end

local function get_recipies(): {string}
  local recipes: {string} = {}
  local recipes_cmd = vim.system({'just', '--summary'}, {text = true}):wait()
  if recipes_cmd.code == 0 then
    for line in string.gmatch(recipes_cmd.stdout as string, "%w+") do
      print(line)
      table.insert(recipes, line)
    end
  end
  return recipes
end

function Just.new(): Just
  return {} as Just
end

function Just:init(): boolean
  self.cmd = find_command()
  self.recipes = get_recipies()
  return self:valid()
end

function Just:valid(): boolean
  return self.cmd ~= nil and #self.recipes > 0
end

local function on_recipe_exit(sys_cmd: table): nil
  if sys_cmd.code ~= 0 then
    vim.notify("Failed to run just recipe", vim.log.levels.ERROR)
  else
    vim.notify("Just recipe ran successfully", vim.log.levels.INFO)
  end
end

function Just:run_recipe(recipie: string, opts: Just.Opts): boolean
  vim.fn.systemlist({self.cmd, recipie}, {stdin = true, stdout = true, on_exit = on_recipe_exit})
  return true
end

return Just

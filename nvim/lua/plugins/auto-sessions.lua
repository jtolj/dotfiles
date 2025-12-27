---@module "lazy"
---@type LazySpec
return {
  'rmagatti/auto-session',
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    -- Saving / restoring
    enabled = true, -- Enables/disables auto creating, saving and restoring
    auto_save = true, -- Enables/disables auto saving session on exit
    auto_restore = true, -- Enables/disables auto restoring session on start
    auto_create = true, -- Enables/disables auto creating new session files. Can be a function that returns true if a new session file should be allowed
    --
    -- Filtering
    bypass_save_filetypes = nil, -- List of filetypes to bypass auto save when the only buffer open is one of the file types listed, useful to ignore dashboards
    close_filetypes_on_save = { 'checkhealth' }, -- Buffers with matching filetypes will be closed before saving
    close_unsupported_windows = true, -- Close windows that aren't backed by normal file before autosaving a session

    -- Git / Session naming
    git_use_branch_name = true, -- Include git branch name in session name
    git_auto_restore_on_branch_change = true, -- Should we auto-restore the session when the git branch changes. Requires git_use_branch_name

    -- Deleting
    purge_after_minutes = 1440, -- Sessions older than purge_after_minutes will be deleted asynchronously on startup, e.g. set to 14400 to delete sessions that haven't been accessed for more than 10 days, defaults to off (no purging), requires >= nvim 0.10

    -- Misc
    show_auto_restore_notif = true, -- Whether to show a notification when auto-restoring
    continue_restore_on_error = false, -- Keep loading the session even if there's an error
  },
}

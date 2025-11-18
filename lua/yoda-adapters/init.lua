local M = {}

local config = {
  notification_backend = nil,
  picker_backend = nil,
}

local setup_called = false

function M.setup(opts)
  if setup_called then
    vim.notify("yoda-adapters: setup() called multiple times", vim.log.levels.WARN)
    return
  end

  opts = opts or {}

  config.notification_backend = opts.notification_backend
  config.picker_backend = opts.picker_backend

  if config.notification_backend then
    vim.g.yoda_notify_backend = config.notification_backend
  end

  if config.picker_backend then
    vim.g.yoda_picker_backend = config.picker_backend
  end

  setup_called = true
end

function M.notification()
  return require("yoda-adapters.notification")
end

function M.picker()
  return require("yoda-adapters.picker")
end

function M.notification_di()
  return require("yoda-adapters.notification_di")
end

function M.picker_di()
  return require("yoda-adapters.picker_di")
end

return M

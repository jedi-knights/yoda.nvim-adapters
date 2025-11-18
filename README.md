# yoda.nvim-adapters

> **Abstract notification and picker backends in Neovim. Auto-detects noice/snacks/telescope or falls back to native APIs.**

Zero dependencies, DIP-compliant, ~95% test coverage.

---

## 📋 Features

- **🔌 Notification Adapters**: Auto-detects `noice`, `snacks`, or falls back to native `vim.notify`
- **🎯 Picker Adapters**: Auto-detects `snacks`, `telescope`, or falls back to native `vim.ui.select`
- **⚡ Zero Dependencies**: Only uses built-in Neovim APIs
- **🎨 User Override**: Force specific backend via global config
- **🧪 Well-Tested**: ~95% test coverage with comprehensive test suite
- **📦 DIP Compliant**: Follows Dependency Inversion Principle

---

## 📦 Installation

### With [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "jedi-knights/yoda.nvim-adapters",
  lazy = false,
  priority = 1000,
  config = function()
    require("yoda-adapters").setup({
      notification_backend = "snacks",
      picker_backend = "telescope",
    })
  end,
}
```

### With [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'jedi-knights/yoda.nvim-adapters',
  config = function()
    require("yoda-adapters").setup({
      notification_backend = "snacks",
      picker_backend = "telescope",
    })
  end,
}
```

---

## 🚀 Usage

### Setup

```lua
require("yoda-adapters").setup({
  notification_backend = "snacks",
  picker_backend = "telescope",
})
```

**Note:** Setup is optional. If not called, backends will be auto-detected.

### Notification Adapter

```lua
local notify = require("yoda-adapters.notification")

-- Simple notification
notify.notify("Hello, World!", "info")

-- With log levels
notify.notify("Something went wrong!", "error")
notify.notify("Warning message", "warn")
notify.notify("Debug information", "debug")

-- With options
notify.notify("Task completed", "info", {
  title = "Success",
  timeout = 3000,
})

-- Get current backend
local backend = notify.get_backend() -- "noice", "snacks", or "native"

-- Force specific backend (useful for testing)
notify.set_backend("native")

-- Reset backend detection
notify.reset_backend()
```

### Picker Adapter

```lua
local picker = require("yoda-adapters.picker")

-- Single selection
picker.select({ "Option 1", "Option 2", "Option 3" }, {
  prompt = "Choose an option:",
}, function(selected)
  if selected then
    print("Selected: " .. selected)
  else
    print("Selection cancelled")
  end
end)

-- Multiple selection (snacks only, falls back to single select)
picker.multiselect({ "Item 1", "Item 2", "Item 3" }, {
  prompt = "Choose items:",
}, function(selected_items)
  print("Selected " .. #selected_items .. " items")
end)

-- Get current backend
local backend = picker.get_backend() -- "snacks", "telescope", or "native"

-- Force specific backend
picker.set_backend("telescope")
```

---

## ⚙️ Configuration

### Setup Options

```lua
require("yoda-adapters").setup({
  notification_backend = "snacks",
  picker_backend = "telescope",
})
```

**Options:**
- `notification_backend` (string|nil): Force notification backend (`"noice"`, `"snacks"`, `"native"`)
- `picker_backend` (string|nil): Force picker backend (`"snacks"`, `"telescope"`, `"native"`)

### Alternative: Global Variables

You can also force a specific backend by setting global variables:

```lua
vim.g.yoda_notify_backend = "snacks"
vim.g.yoda_picker_backend = "telescope"
```

### Backend Priority (Auto-Detection)

**Notification backends** (priority order):
1. User preference (`vim.g.yoda_notify_backend`)
2. `noice` (if available)
3. `snacks` (if available)
4. `native` `vim.notify` (fallback)

**Picker backends** (priority order):
1. User preference (`vim.g.yoda_picker_backend`)
2. `snacks` (if available)
3. `telescope` (if available)
4. `native` `vim.ui.select` (fallback)

---

## 🏗️ Architecture

### Design Patterns

- **Adapter Pattern** (GoF): Abstracts backend differences
- **Singleton Pattern**: Caches backend detection for performance
- **Dependency Inversion Principle** (SOLID): Depend on abstractions, not concretions

### Backend Implementations

#### Notification Backends

| Backend | Level Format | Features |
|---------|-------------|----------|
| `noice` | String (`"info"`, `"warn"`, etc.) | Rich UI notifications |
| `snacks` | String (`"info"`, `"warn"`, etc.) | Lightweight notifications |
| `native` | Number (`vim.log.levels.INFO`) | Built-in Neovim notifications |

#### Picker Backends

| Backend | Multiselect | Features |
|---------|-------------|----------|
| `snacks` | ✅ Yes | Modern picker with multiselect |
| `telescope` | ❌ No (falls back to single) | Powerful fuzzy finder |
| `native` | ❌ No (falls back to single) | Built-in `vim.ui.select` |

---

## 🧪 Testing

### Run Tests

```bash
# Run all tests
make test

# Check code style
make lint

# Format code
make format
```

### Test Coverage

- ✅ **Notification adapter**: 100% coverage
- ✅ **Picker adapter**: 100% coverage
- ✅ **Edge cases**: nil values, errors, fallbacks
- ✅ **Backend detection**: User override, auto-detect, caching

---

## 📚 API Reference

### Notification Module (`yoda-adapters.notification`)

#### `notify(msg, level, opts)`

Send a notification.

- **Parameters:**
  - `msg` (string): Message to display
  - `level` (string|number): Log level (`"info"`, `"warn"`, `"error"` or `vim.log.levels.*`)
  - `opts` (table|nil): Options (title, timeout, etc.)

#### `get_backend()`

Get the current backend name.

- **Returns:** `"noice"`, `"snacks"`, or `"native"`

#### `set_backend(backend_name)`

Force a specific backend.

- **Parameters:**
  - `backend_name` (string): `"noice"`, `"snacks"`, or `"native"`

#### `reset_backend()`

Reset backend detection (clears cache).

---

### Picker Module (`yoda-adapters.picker`)

#### `select(items, opts, callback)`

Select a single item from a list.

- **Parameters:**
  - `items` (table): List of items to choose from
  - `opts` (table): Options (`prompt`, `format_item`, etc.)
  - `callback` (function): Callback receiving selected item (or `nil` if cancelled)

#### `multiselect(items, opts, callback)`

Select multiple items from a list (snacks only, falls back to single select for other backends).

- **Parameters:**
  - `items` (table): List of items to choose from
  - `opts` (table): Options (`prompt`, `format_item`, etc.)
  - `callback` (function): Callback receiving array of selected items

#### `create()`

Create a picker instance with automatic backend detection.

- **Returns:** Picker implementation with `select` method

#### `get_backend()`

Get the current backend name.

- **Returns:** `"snacks"`, `"telescope"`, or `"native"`

#### `set_backend(backend_name)`

Force a specific backend.

- **Parameters:**
  - `backend_name` (string): `"snacks"`, `"telescope"`, or `"native"`

#### `reset_backend()`

Reset backend detection (clears cache).

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass (`make test`)
5. Format code (`make format`)
6. Submit a pull request

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 🔗 Related Projects

- **[yoda.nvim](https://github.com/jedi-knights/yoda.nvim)** - Comprehensive Neovim distribution
- **[yoda-logging.nvim](https://github.com/jedi-knights/yoda-logging.nvim)** - Production logging framework
- **[yoda-terminal.nvim](https://github.com/jedi-knights/yoda-terminal.nvim)** - Python venv terminal integration

---

## 💬 Support

- **Issues**: [GitHub Issues](https://github.com/jedi-knights/yoda.nvim-adapters/issues)
- **Discussions**: [GitHub Discussions](https://github.com/jedi-knights/yoda.nvim-adapters/discussions)

---

**May the Force be with you! ⚡**

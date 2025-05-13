-- load default LSP settings from nvchad
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- add your LSPs here
local servers = {
  "html",
  "cssls",
  "basedpyright",
  "rust_analyzer",
  "ts_ls",
}

-- loop to configure each LSP
for _, lsp in ipairs(servers) do
  if lsp == "basedpyright" then
    lspconfig[lsp].setup {
      filetypes = { "python" },
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
      settings = {
        basedpyright = {
          typeCheckingMode = "off",
          -- reportUnusedVariable = "none",
        }
      }
    }
  else
    lspconfig[lsp].setup {
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
    }
  end
end

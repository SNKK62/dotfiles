local on_attach = function(client, bufnr)

  --client.server_capabilities.documentFormattingProvider = false

end
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
  function (server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
          update_in_insert = true,
        }),
      },
    }
  end,
}

local lspconfig = require("lspconfig")

-- TypeScript
lspconfig.tsserver.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      update_in_insert = true,
    }),
  },
}
-- eslint
lspconfig.eslint.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      update_in_insert = true,
    }),
  },
}

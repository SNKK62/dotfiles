-- https://github.com/ykamikawa/nvim-packer-lsp/blob/afe3267ffba71bf825ce0bcaf4491242de84010e/after/plugin/copilot.rc.lua
local M = {}

local chat = require("CopilotChat")
local select = require("CopilotChat.select")
local actions = require("CopilotChat.actions")
local telescope = require("CopilotChat.integrations.telescope")

-- chat with Copilot using the selected content
function M.copilotChatSelection()
	local input = vim.fn.input("Quick Chat: ")
	if input ~= "" then
		chat.ask(input, { selection = select.selection })
	end
end

-- chat with Copilot using the entire buffer content
function M.copilotChatBuffer()
	local input = vim.fn.input("Quick Chat: ")
	if input ~= "" then
		chat.ask(input, { selection = select.buffer })
	end
end

-- Reset the Copilot chat content
function M.copilotChatReset()
	chat.reset()
	vim.notify("Copilot chat has been reset.", vim.log.levels.INFO)
end

-- TODO: enable to load repository content using the GPT repository loader
-- chat with Copilot using the selected content
-- function copilotChatLoadRepository()
-- 	local repo_path = vim.fn.input("Enter repository repository path: ")
-- 	if repo_path == "" then
-- 		repo_path = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
-- 	else
-- 		-- Check if the path is relative and convert to absolute path
-- 		if not repo_path:match("^/") then
-- 			repo_path = vim.fn.expand(vim.fn.getcwd() .. "/" .. repo_path)
-- 		end
-- 	end
-- 	local input = vim.fn.input("Quick Chat: ")
-- 	if input ~= "" then
-- 		local gpt_repo_loader_dir = os.getenv("HOME") .. "/gpt-repository-loader/"
-- 		local output_file_path = gpt_repo_loader_dir .. "output.txt"
-- 		local cmd = "python "
-- 			.. gpt_repo_loader_dir
-- 			.. "gpt_repository_loader.py "
-- 			.. repo_path
-- 			.. " -o "
-- 			.. output_file_path
-- 		vim.fn.system(cmd)
-- 		local file_path = vim.fn.expand(output_file_path)
-- 		local file_content = vim.fn.readfile(file_path)
-- 		if not file_content or #file_content == 0 then
-- 			vim.notify("No content found in " .. file_path, vim.log.levels.ERROR)
-- 			return
-- 		end
-- 		chat.ask(input, {
-- 			selection = function()
-- 				return {
-- 					lines = table.concat(file_content, "\n"),
-- 					filename = file_path,
-- 					filetype = vim.fn.fnamemodify(file_path, ":e"),
-- 				}
-- 			end,
-- 		})
-- 	end
-- end

-- display the action prompt using telescope
function M.showCopilotChatActionPrompt()
	telescope.pick(actions.prompt_actions())
end

-- display the action prompt using telescope with the visual selection
function M.showCopilotChatActionPromptVisualSelection()
	telescope.pick(actions.prompt_actions({
		selection = select.selection,
	}))
end

-- display the action help using telescope
function M.showCopilotChatActionHelp()
	telescope.pick(actions.help_actions())
end

return M

-- https://github.com/ykamikawa/nvim-packer-lsp/blob/afe3267ffba71bf825ce0bcaf4491242de84010e/after/plugin/copilot.rc.lua
return function()
	local chat = require("CopilotChat")
	-- Setup the CMP integration
	require("CopilotChat.integrations.cmp").setup()

	local select = require("CopilotChat.select")
	chat.setup({
		debug = true, -- Enable debug mode
		proxy = nil, -- Proxy server URL
		allow_insecure = false, -- Allow insecure connections

		model = "gpt-4o", -- Model to use for chat
		temperature = 0.1, -- Temperature for sampling
		-- Override the default prompts
		prompts = {
			-- https://github.com/jellydn/lazy-nvim-ide/blob/5238b765d423a16098c23d7b0a581695ead54c93/lua/plugins/extras/copilot-chat-v2.lua
			-- additonal prompts
			Review = {
				prompt = "Please review the following code and provide suggestions for improvement.",
				selection = select.selection,
			},
			FixCode = {
				prompt = "Please fix the following code to make it work as intended.",
				selection = select.selection,
			},
			FixError = {
				prompt = "Please explain the error in the following text and provide a solution.",
				selection = select.selection,
			},
			BetterNamings = {
				prompt = "Please provide better names for the following variables and functions.",
				selection = select.selection,
			},
			Documentation = {
				prompt = "Please provide documentation for the following code.",
				selection = select.selection,
			},
			SwaggerApiDocs = {
				prompt = "Please provide documentation for the following API using Swagger.",
				selection = select.selection,
			},
			SwaggerJsDocs = {
				prompt = "Please write JSDoc for the following API using Swagger.",
				selection = select.selection,
			},
			-- Text related prompts
			Summarize = {
				prompt = "Please summarize the following text.",
				selection = select.selection,
			},
			Spelling = {
				prompt = "Please correct any grammar and spelling errors in the following text.",
				selection = select.selection,
			},
			Wording = {
				prompt = "Please improve the grammar and wording of the following text.",
				selection = select.selection,
			},
			Concise = {
				prompt = "Please rewrite the following text to make it more concise.",
				selection = select.selection,
			},
			Translate = {
				prompt = "Please translate the following text to Japanese.",
				selection = select.selection,
			},

			-- Japanse prompts
			ExplainJP = {
				prompt = "/COPILOT_EXPLAIN 選択したコードの説明を段落をつけて書いてください。",
				selection = select.selection,
			},
			FixJP = {
				prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードに書き換えてください。",
				selection = select.selection,
			},
			OptimizeJP = {
				prompt = "/COPILOT_OPTIMIZE 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。",
				selection = select.selection,
			},
			DocsJP = {
				prompt = "/COPILOT_DOCS 選択したコードのドキュメントを書いてください。ドキュメントをコメントとして追加した元のコードを含むコードブロックで回答してください。使用するプログラミング言語に最も適したドキュメントスタイルを使用してください（例：JavaScriptのJSDoc、Pythonのdocstringsなど）",
				selection = select.selection,
			},
			TestsJP = {
				prompt = "/COPILOT_TESTS 選択したコードの詳細な単体テスト関数を書いてください。",
				selection = select.selection,
			},
			FixDiagnosticJP = {
				prompt = "/COPILOT_FIXDIAGNOSTIC ファイル内の次のような診断上の問題を解決してください：",
				selection = select.diagnostics or select.selection,
			},
			CommitJP = {
				prompt = "/COPILOT_COMMIT この変更をコミットしてください。",
				selection = select.gitdiff or select.selection,
			},
			CommitStagedJP = {
				prompt = "/COPILOT_COMMITSTAGED ステージングされた変更をコミットしてください。",
				selection = select.selection,
			},
			-- LoadRepository = {
			-- 	prompt = "このリポジトリの解説をしてください。",
			-- 	selection = CopilotChatLoadRepository,
			-- },
		},
		window = {
			layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace'
			width = 0.4, -- fractional width of parent, or absolute width in columns when > 1
			height = 0.3, -- fractional height of parent, or absolute height in rows when > 1
			-- Options below only apply to floating windows
			relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
			border = "single", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
			row = 0, -- row position of the window, default is centered
			col = 0, -- column position of the window, default is centered
			title = "Copilot Chat", -- title of chat window
			footer = nil, -- footer of chat window
			zindex = 1, -- determines if window is on top or below other floating windows
		},
	})
end

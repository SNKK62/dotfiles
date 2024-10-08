return function()
	local chat = require("CopilotChat")
	local select = require("CopilotChat.select")
	chat.setup({
		debug = true, -- Enable debug mode
		proxy = nil, -- Proxy server URL
		allow_insecure = false, -- Allow insecure connections

		model = "gpt-4o", -- Model to use for chat
		temperature = 0.1, -- Temperature for sampling

		-- Override the default prompts
		prompts = {
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
			width = 0.3, -- fractional width of parent, or absolute width in columns when > 1
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

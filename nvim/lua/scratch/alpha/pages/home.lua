local util = require("scratch.alpha.util")
return {
	{
		{ "resume", "something" },
		{
			function()
				util.Popup("resume", { "https://me.com" })
			end,
			function()
				util.Popup("some title", {
					"line 1",
					"line 2",
					"line 3",
					"line 4",
					"line 5",
					"line 6",
					"line 7",
					"line 8",
					"line 9",
					"line 10",
				})
			end,
		},
	},
	"LUCAS",
	true,
}

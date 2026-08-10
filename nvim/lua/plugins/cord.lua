return {
  "vyfor/cord.nvim",
  build = ":Cord update",
  lazy = false,
  config = function()
    require("cord").setup({
      autostart = true,
      variables = true,

      ipc = {
        socket = "/tmp/discord-ipc-0",
      },

      editor = {
        tooltip = "Sometimes dumb text editor",
      },

      display = {
        theme = "classic",
        swap_fields = true,
      },

      text = {
        editing = "Cooking in ${filename}",
        file_browser = "Searching stuff in ${name}",
        docs = "Reading docs in ${name}",
        workspace = "Shitting myself in ${workspace}",
      },

      idle = {
        tooltip = "Doing something irl (probably)",
      },

      advanced = {
        workspace = {
          limit_to_cwd = true,
        },
      },
    })
  end,
}

require("render-markdown").setup(
    {
        heading = {
            icons = {"⑴ ", "⑵ ", "⑶ ", "⑷ ", "⑸ ", "⑹ "},
            sign = false
        },
        sign = {
            -- Turn on / off sign rendering.
            enabled = false
        },
        callout = {},
        anti_conceal = {
            enabled = true,
        },
        checkbox = {
            unchecked = {
                icon = '☐'
            },
            checked = {
                icon = '☑'
            }
        },
        html = {
            enabled = false
        }
    }
)

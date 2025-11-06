require("avante").setup(
    {
        provider = "litellm",
        auto_suggestions_provider = "litellm",
        providers = {
            litellm = {
                __inherited_from = "openai",
                endpoint = "https://gcjs.whu.edu.cn/",
                model = "glm-4.6-local",
                api_key_name = "LITELLM_API_KEY"
            }
        },
        behaviour = {
            auto_suggestions = false
        }
    }
)

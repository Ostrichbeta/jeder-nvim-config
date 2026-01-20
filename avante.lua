require("mcphub").setup(
    {
        extensions = {
            avante = {
                make_slash_commands = true -- make /slash commands from MCP server prompts
            }
        }
    }
)

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
        },
        system_prompt = function()
            local hub = require("mcphub").get_hub_instance()
            return hub and hub:get_active_servers_prompt() or ""
        end,
        -- Using function prevents requiring mcphub before it's loaded
        custom_tools = function()
            return {
                require("mcphub.extensions.avante").mcp_tool()
            }
        end,
        disabled_tools = {
            "list_files", -- Built-in file operations
            "search_files",
            "read_file",
            "create_file",
            "rename_file",
            "delete_file",
            "create_dir",
            "rename_dir",
            "delete_dir",
            "bash" -- Built-in terminal access
        }
    }
)

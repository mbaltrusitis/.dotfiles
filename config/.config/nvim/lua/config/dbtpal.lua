return {
  path_to_dbt = "dbt",
  path_to_dbt_project = "",
  path_to_dbt_profiles_dir = vim.fn.expand("~/.dbt"),
  include_profiles_dir = true,
  include_project_dir = true,
  include_log_level = true,
  extended_path_search = true,
  protect_compiled_files = true,
  pre_cmd_args = {},
  post_cmd_args = {},
}

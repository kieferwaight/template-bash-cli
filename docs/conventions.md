# Conventions

| Concern | Convention |
| --- | --- |
| Public Bash API | `app::module::function` |
| Private Bash API | `_app::module::function` |
| Global variables | `APP_UPPERCASE_NAME` |
| CLI hierarchy | `app config get` |
| External commands | `app-command` |
| argc metadata | `# @tag` |
| Template directives | `#%directive` |

Runtime output belongs on stdout only when it is requested data. Diagnostics and logs belong on stderr.


# TODO

- [ ] make (dotnet)
- [ ] dap (dotnet, node, lua)
- [ ] bugs
- [ ] zeal/doc integration
- [ ] test conf
- [ ] org mode / agenda + notes w/ zk
- [ ] # 2.0 release
- [ ] refactor modules, lib, configs, plugins
- [ ] # 3.0 release

# NOTES

- modules: export API and setup function
- lib: provide helper functions through a single import/global object
- configs: call setup() on plugins and modules
- plugins: export API and setup function

| what   | depends on what     |
| ------ | ------------------- |
| module | plugin, module, lib |
| lib    | -                   |
| config | plugin, lib         |
| plugin | plugin              |

1. `lib` should be turned into a single plugin
2. `modules` should be turned into multiple plugins
3. `configs` should be turned into a single plugin
4. `configs` need to make sure the plugins they depend on are installed and do
   enabled/disabled checks.
5. `plugins` need to be placed in the runtime path to be available from the
   start

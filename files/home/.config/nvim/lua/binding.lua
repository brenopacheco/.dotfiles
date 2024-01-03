--- bindings for the most common use neovim functions
--TODO: check what I want - look at configs

local M = {}

--[[

join
merge
split
append
push
map


json.stringify
json.parse
print




]]





-- vim.diff({a}, {b}, {opts})                                        *vim.diff()*
-- vim.json.decode({str}, {opts})                             *vim.json.decode()*
-- vim.json.encode({obj})                                     *vim.json.encode()*
-- vim.base64.decode({str})                                 *vim.base64.decode()*
-- vim.base64.encode({str})                                 *vim.base64.encode()*
-- vim.api.{func}({...})                                                    *vim.api*
-- vim.empty_dict()                                            *vim.empty_dict()*
-- vim.iconv({str}, {from}, {to}, {opts})                           *vim.iconv()*
-- vim.schedule({fn})                                            *vim.schedule()*
-- vim.stricmp({a}, {b})                                          *vim.stricmp()*
-- vim.wait({time}, {callback}, {interval}, {fast_only})             *vim.wait()*
-- vim.call({func}, {...})                                           *vim.call()*
-- vim.cmd({command})
-- vim.fn.{func}({...})                                                  *vim.fn*
-- vim.defer_fn({fn}, {timeout})                                 *vim.defer_fn()*
-- vim.deprecate({name}, {alternative}, {version}, {plugin}, {backtrace})
-- vim.inspect                                                    *vim.inspect()*
-- vim.keycode({str})                                             *vim.keycode()*
-- vim.notify({msg}, {level}, {opts})                              *vim.notify()*
-- vim.on_key({fn}, {ns_id})                                       *vim.on_key()*
-- vim.paste({lines}, {phase})                                      *vim.paste()*
-- vim.print({...})                                                 *vim.print()*
-- vim.region({bufnr}, {pos1}, {pos2}, {regtype}, {inclusive})
-- vim.schedule_wrap({fn})                                  *vim.schedule_wrap()*
-- vim.system({cmd}, {opts}, {on_exit})                            *vim.system()*
-- vim.inspect_pos({bufnr}, {row}, {col}, {filter})           *vim.inspect_pos()*
-- vim.show_pos({bufnr}, {row}, {col}, {filter})                 *vim.show_pos()*
-- vim.deep_equal({a}, {b})                                    *vim.deep_equal()*
-- vim.deepcopy({orig})                                          *vim.deepcopy()*
-- vim.defaulttable({createfn})                              *vim.defaulttable()*
-- vim.endswith({s}, {suffix})                                   *vim.endswith()*
-- vim.gsplit({s}, {sep}, {opts})                                  *vim.gsplit()*
-- vim.is_callable({f})                                       *vim.is_callable()*
-- vim.list_contains({t}, {value})                          *vim.list_contains()*
-- vim.list_extend({dst}, {src}, {start}, {finish})           *vim.list_extend()*
-- vim.list_slice({list}, {start}, {finish})                   *vim.list_slice()*
-- vim.pesc({s})                                                     *vim.pesc()*
-- vim.ringbuf({size})                                            *vim.ringbuf()*
-- vim.Ringbuf:clear()                                          *Ringbuf:clear()*
-- vim.Ringbuf:peek()                                            *Ringbuf:peek()*
-- vim.Ringbuf:pop()                                              *Ringbuf:pop()*
-- vim.Ringbuf:push({item})                                      *Ringbuf:push()*
-- vim.spairs({t})                                                 *vim.spairs()*
-- vim.split({s}, {sep}, {opts})                                    *vim.split()*
-- vim.startswith({s}, {prefix})                               *vim.startswith()*
-- vim.tbl_add_reverse_lookup({o})                 *vim.tbl_add_reverse_lookup()*
-- vim.tbl_contains({t}, {value}, {opts})                    *vim.tbl_contains()*
-- vim.tbl_count({t})                                           *vim.tbl_count()*
-- vim.tbl_deep_extend({behavior}, {...})                 *vim.tbl_deep_extend()*
-- vim.tbl_extend({behavior}, {...})                           *vim.tbl_extend()*
-- vim.tbl_filter({func}, {t})                                 *vim.tbl_filter()*
-- vim.tbl_flatten({t})                                       *vim.tbl_flatten()*
-- vim.tbl_get({o}, {...})                                        *vim.tbl_get()*
-- vim.tbl_isarray({t})                                       *vim.tbl_isarray()*
-- vim.tbl_isempty({t})                                       *vim.tbl_isempty()*
-- vim.tbl_islist({t})                                         *vim.tbl_islist()*
-- vim.tbl_keys({t})                                             *vim.tbl_keys()*
-- vim.tbl_map({func}, {t})                                       *vim.tbl_map()*
-- vim.tbl_values({t})                                         *vim.tbl_values()*
-- vim.trim({s})                                                     *vim.trim()*
-- vim.validate({opt})                                           *vim.validate()*
-- vim.loader.disable()                                    *vim.loader.disable()*
-- vim.loader.enable()                                      *vim.loader.enable()*
-- vim.loader.find({modname}, {opts})                         *vim.loader.find()*
-- vim.loader.reset({path})                                  *vim.loader.reset()*
-- vim.uri_decode({str})                                       *vim.uri_decode()*
-- vim.uri_encode({str}, {rfc})                                *vim.uri_encode()*
-- vim.uri_from_bufnr({bufnr})                             *vim.uri_from_bufnr()*
-- vim.uri_from_fname({path})                              *vim.uri_from_fname()*
-- vim.uri_to_bufnr({uri})                                   *vim.uri_to_bufnr()*
-- vim.uri_to_fname({uri})                                   *vim.uri_to_fname()*
-- vim.ui.input({opts}, {on_confirm})                            *vim.ui.input()*
-- vim.ui.open({path})                                            *vim.ui.open()*
-- vim.ui.select({items}, {opts}, {on_choice})                  *vim.ui.select()*
-- vim.filetype.add({filetypes})                             *vim.filetype.add()*
-- vim.filetype.get_option({filetype}, {option})
-- vim.filetype.match({args})                              *vim.filetype.match()*
-- vim.keymap.del({modes}, {lhs}, {opts})                      *vim.keymap.del()*
-- vim.keymap.set({mode}, {lhs}, {rhs}, {opts})                *vim.keymap.set()*
-- vim.fs.basename({file})                                    *vim.fs.basename()*
-- vim.fs.dir({path}, {opts})                                      *vim.fs.dir()*
-- vim.fs.dirname({file})                                      *vim.fs.dirname()*
-- vim.fs.find({names}, {opts})                                   *vim.fs.find()*
-- vim.fs.joinpath({...})                                     *vim.fs.joinpath()*
-- vim.fs.normalize({path}, {opts})                          *vim.fs.normalize()*
-- vim.fs.parents({start})                                     *vim.fs.parents()*
-- vim.secure.read({path})                                    *vim.secure.read()*
-- vim.secure.trust({opts})                                  *vim.secure.trust()*
-- vim.version.cmp({v1}, {v2})                                *vim.version.cmp()*
-- vim.version.eq({v1}, {v2})                                  *vim.version.eq()*
-- vim.version.gt({v1}, {v2})                                  *vim.version.gt()*
-- vim.version.last({versions})                              *vim.version.last()*
-- vim.version.lt({v1}, {v2})                                  *vim.version.lt()*
-- vim.version.parse({version}, {opts})                     *vim.version.parse()*
-- vim.version.range({spec})                                *vim.version.range()*

_G.v = M


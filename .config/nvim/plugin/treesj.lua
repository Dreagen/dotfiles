vim.pack.add({ 'https://github.com/wansmer/treesj' })

local treesj = require('treesj')
local lang_utils = require('treesj.langs.utils')

treesj.setup({
    use_default_keymaps = false,
    max_join_length = 500,
    langs = {
        c_sharp = {
            parameter_list = lang_utils.set_preset_for_args(),
            bracketed_parameter_list = lang_utils.set_preset_for_args(),
            argument_list = lang_utils.set_preset_for_args(),
            initializer_expression = lang_utils.set_preset_for_dict(),
            collection_expression = lang_utils.set_preset_for_list(),
            block = lang_utils.set_preset_for_statement(),
            declaration_list = lang_utils.set_default_preset(),
            accessor_list = lang_utils.set_default_preset(),
            enum_member_declaration_list = lang_utils.set_preset_for_list(),
            switch_body = lang_utils.set_default_preset(),
            method_declaration = { target_nodes = { 'parameter_list', 'block' } },
            constructor_declaration = { target_nodes = { 'parameter_list', 'block' } },
            property_declaration = { target_nodes = { 'accessor_list' } },
            class_declaration = { target_nodes = { 'declaration_list' } },
            struct_declaration = { target_nodes = { 'declaration_list' } },
            interface_declaration = { target_nodes = { 'declaration_list' } },
            namespace_declaration = { target_nodes = { 'declaration_list' } },
            enum_declaration = { target_nodes = { 'enum_member_declaration_list' } },
            switch_statement = { target_nodes = { 'switch_body' } },
        },
    },
})
vim.keymap.set('n', '<leader>sp', treesj.toggle, { desc = 'Toggle split/join' })

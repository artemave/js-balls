# Vjs [![CircleCI](https://circleci.com/gh/artemave/vjs.svg?style=svg)](https://circleci.com/gh/artemave/vjs)

## What is this?

A Vim plugin that adds a bunch of power tricks for writing Javascript/TypeScript. Namely:

- extract variable
- extract function/method
- extract class/function/variable declaration into a separate file
- autocomplete `require`/`import` paths
- update imports on file rename/move
- list imports for current file
- auto generate and keep up to date `tags` file
- list Express routes

For test related stuff I have a dedicated [plugin](https://github.com/artemave/vigun).

## Installation

Use [a plugin manager](https://github.com/junegunn/vim-plug):

```vim script
Plug 'artemave/vjs', { 'do': 'npm install' }
```

If you don't use a plugin manager, don't forget to run `npm install` in the plugin directory.

### Example bindings

```vim script
au FileType {javascript,javascript.jsx,typescript} vmap <leader>vv :VjsExtractVariable<cr>
au FileType {javascript,javascript.jsx,typescript} vmap <leader>vf :VjsExtractFunctionOrMethod<cr>
au FileType {javascript,javascript.jsx,typescript} nmap <leader>vd :VjsExtractDeclarationIntoFile<cr>
au FileType {javascript,javascript.jsx,typescript} nmap <leader>vr :VjsRenameFile<cr>
au FileType {javascript,javascript.jsx,typescript} nmap <leader>vl :VjsListDependents<cr>
```

There are no default bindings.

### Configuration

`g:vjs_tags_enabled` - enable tags file auto generation. Defaults to `1`.

`g:vjs_tags_ignore` - additional paths to ignore when generating tags file. By default vjs tags all non git ignored js/jsx/mjs files. Array.

`g:vjs_tags_regenerate_at_start` - when vim starts and this is set to `0`, it will update existing tags file rather than regenerating it. Defaults to `1`.

## Usage

#### Complete require paths

Vjs registers `omnifunc` for `require`/`import` path completion - `CTRL-X CTRL-O` - which gives you this:

<img src="https://user-images.githubusercontent.com/23721/80413735-38752d80-88d0-11ea-8030-de1b17ee4796.gif" loading="lazy">

#### `:VjsRenameFile`

Rename/move file and update imports. It updates both imports in current file and all files that import current file.

![vjs_rename_file](https://user-images.githubusercontent.com/23721/82894765-62fbea00-9f53-11ea-8a64-d3bd123fe553.gif)

#### `:'<,'>VjsExtractVariable`

Extracts selected code into a variable.

![vjs_extract_variable](https://user-images.githubusercontent.com/23721/80576166-01ecff00-8a05-11ea-8826-01ae86e227e1.gif)

#### `:'<,'>VjsExtractFunctionOrMethod`

Extracts selected code into a global function.

![vjs_extract_function](https://user-images.githubusercontent.com/23721/80576556-b38c3000-8a05-11ea-8be8-5b1b18e5ac87.gif)

#### `:VjsListDependents`

Shows list of modules that require/import current file in quickfix window.

![vjs_list_dependents](https://user-images.githubusercontent.com/23721/80421625-0f0ece80-88dd-11ea-8057-93ff00adbf3e.gif)

#### `:VjsListRoutes`

Shows list of express routes of current file in quickfix window.

![vjs_list_routes](https://user-images.githubusercontent.com/23721/80421959-9d835000-88dd-11ea-87ae-3f65638c7de4.gif)

## Development

```
git clone https://github.com/artemave/vjs.git
cd vjs
git clone https://github.com/junegunn/vader.vim.git
npm install
npm run test
```

" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Ron Aaron <ronaharon@yahoo.com>
" Last Change:	2003 May 02

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "norm"

hi Normal       ctermfg=Gray 
hi Comment      ctermfg=DarkGray
hi Constant     ctermfg=Green
hi Identifier   ctermfg=Blue
hi Statement    ctermfg=Cyan
hi Special  term=bold ctermfg=Magenta guifg=Magenta
hi PreProc  term=bold ctermfg=Magenta guifg=Purple
hi Type     term=underline ctermfg=Blue gui=NONE guifg=Blue
hi Visual   term=reverse ctermfg=Yellow ctermbg=Red gui=NONE guifg=Black guibg=Yellow
hi Search   term=reverse ctermfg=Black ctermbg=Cyan gui=NONE guifg=Black guibg=Cyan
hi Tag      term=bold ctermfg=DarkYellow guifg=DarkGreen
hi Error    term=reverse ctermfg=15 ctermbg=9 guibg=Red guifg=White
hi Todo     term=standout ctermbg=Yellow ctermfg=Black guifg=Blue guibg=Yellow
hi StatusLine term=bold,reverse cterm=NONE ctermfg=Yellow ctermbg=DarkGray gui=NONE guifg=Yellow guibg=DarkGray
hi! link MoreMsg    Comment
hi! link ErrorMsg   Visual
hi! link WarningMsg ErrorMsg
hi! link Question   Comment
hi link String	    Constant
hi link Character	Constant
hi link Number	    Constant
hi link Float		Number
hi link Boolean	    Special
hi link Function	Identifier
hi link Conditional	Statement
hi link Repeat	    Statement
hi link Label		Statement
hi link Operator	Special
hi link Keyword	    Statement
hi link Exception	Statement
hi link Include	    PreProc
hi link Define	    PreProc
hi link Macro		PreProc
hi link PreCondit	PreProc
hi link StorageClass	Type
hi link Structure	Type
hi link Typedef	    Type
hi link SpecialChar	Special
hi link Delimiter	Special
hi link SpecialComment Special
hi link Debug		Special

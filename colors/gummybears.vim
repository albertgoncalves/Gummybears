" Vim color file - gummybears
" Generated by http://bytefluent.com/vivify 2012-02-05
set background=dark

if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

let g:colors_name = "gummybears"

if !has("gui_running") && &t_Co != 88 && &t_Co != 256
	finish
endif

" functions {{{
" returns an approximate grey index for the given grey level
fun <SID>grey_number(x)
	if &t_Co == 88
		if a:x < 23
			return 0
		elseif a:x < 69
			return 1
		elseif a:x < 103
			return 2
		elseif a:x < 127
			return 3
		elseif a:x < 150
			return 4
		elseif a:x < 173
			return 5
		elseif a:x < 196
			return 6
		elseif a:x < 219
			return 7
		elseif a:x < 243
			return 8
		else
			return 9
		endif
	else
		if a:x < 14
			return 0
		else
			let l:n = (a:x - 8) / 10
			let l:m = (a:x - 8) % 10
			if l:m < 5
				return l:n
			else
				return l:n + 1
			endif
		endif
	endif
endfun

" returns the actual grey level represented by the grey index
fun <SID>grey_level(n)
	if &t_Co == 88
		if a:n == 0
			return 0
		elseif a:n == 1
			return 46
		elseif a:n == 2
			return 92
		elseif a:n == 3
			return 115
		elseif a:n == 4
			return 139
		elseif a:n == 5
			return 162
		elseif a:n == 6
			return 185
		elseif a:n == 7
			return 208
		elseif a:n == 8
			return 231
		else
			return 255
		endif
	else
		if a:n == 0
			return 0
		else
			return 8 + (a:n * 10)
		endif
	endif
endfun

" returns the palette index for the given grey index
fun <SID>grey_color(n)
	if &t_Co == 88
		if a:n == 0
			return 16
		elseif a:n == 9
			return 79
		else
			return 79 + a:n
		endif
	else
		if a:n == 0
			return 16
		elseif a:n == 25
			return 231
		else
			return 231 + a:n
		endif
	endif
endfun

" returns an approximate color index for the given color level
fun <SID>rgb_number(x)
	if &t_Co == 88
		if a:x < 69
			return 0
		elseif a:x < 172
			return 1
		elseif a:x < 230
			return 2
		else
			return 3
		endif
	else
		if a:x < 75
			return 0
		else
			let l:n = (a:x - 55) / 40
			let l:m = (a:x - 55) % 40
			if l:m < 20
				return l:n
			else
				return l:n + 1
			endif
		endif
	endif
endfun

" returns the actual color level for the given color index
fun <SID>rgb_level(n)
	if &t_Co == 88
		if a:n == 0
			return 0
		elseif a:n == 1
			return 139
		elseif a:n == 2
			return 205
		else
			return 255
		endif
	else
		if a:n == 0
			return 0
		else
			return 55 + (a:n * 40)
		endif
	endif
endfun

" returns the palette index for the given R/G/B color indices
fun <SID>rgb_color(x, y, z)
	if &t_Co == 88
		return 16 + (a:x * 16) + (a:y * 4) + a:z
	else
		return 16 + (a:x * 36) + (a:y * 6) + a:z
	endif
endfun

" returns the palette index to approximate the given R/G/B color levels
fun <SID>color(r, g, b)
	" get the closest grey
	let l:gx = <SID>grey_number(a:r)
	let l:gy = <SID>grey_number(a:g)
	let l:gz = <SID>grey_number(a:b)

	" get the closest color
	let l:x = <SID>rgb_number(a:r)
	let l:y = <SID>rgb_number(a:g)
	let l:z = <SID>rgb_number(a:b)

	if l:gx == l:gy && l:gy == l:gz
		" there are two possibilities
		let l:dgr = <SID>grey_level(l:gx) - a:r
		let l:dgg = <SID>grey_level(l:gy) - a:g
		let l:dgb = <SID>grey_level(l:gz) - a:b
		let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
		let l:dr = <SID>rgb_level(l:gx) - a:r
		let l:dg = <SID>rgb_level(l:gy) - a:g
		let l:db = <SID>rgb_level(l:gz) - a:b
		let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
		if l:dgrey < l:drgb
			" use the grey
			return <SID>grey_color(l:gx)
		else
			" use the color
			return <SID>rgb_color(l:x, l:y, l:z)
		endif
	else
		" only one possibility
		return <SID>rgb_color(l:x, l:y, l:z)
	endif
endfun

" returns the palette index to approximate the 'rrggbb' hex string
fun <SID>rgb(rgb)
	let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
	let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
	let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0
	return <SID>color(l:r, l:g, l:b)
endfun

" sets the highlighting for the given group
fun <SID>X(group, fg, bg, attr)
	if a:fg != ""
		exec "hi ".a:group." guifg=#".a:fg." ctermfg=".<SID>rgb(a:fg)
	endif
	if a:bg != ""
		exec "hi ".a:group." guibg=#".a:bg." guisp=#".a:bg." ctermbg=".<SID>rgb(a:bg)
	endif
	if a:attr != ""
		if a:attr == 'italic'
			exec "hi ".a:group." gui=".a:attr." cterm=none"
		else
			exec "hi ".a:group." gui=".a:attr." cterm=".a:attr
		endif
	endif
endfun
" }}}
call <SID>X("Boolean","8197bf","","none")
call <SID>X("CTagsClass","e2e4e5","","none")
call <SID>X("CTagsGlobalConstant","e2e4e5","","none")
call <SID>X("CTagsGlobalVariable","e2e4e5","","none")
call <SID>X("CTagsImport","e2e4e5","","none")
call <SID>X("CTagsMember","e2e4e5","","none")
call <SID>X("Character","cf6a4c","","none")
call <SID>X("Comment","3d3b3d","","italic")
call <SID>X("Conditional","ffb964","","none")
call <SID>X("Constant","de5833","","bold")
call <SID>X("Cursor","d6d615","fff700","none")
call <SID>X("CursorColumn","e2e4e5","1c1c1c","none")
" call <SID>X("CursorLine","none","000000","none")
call <SID>X("Debug","799d6a","","none")
call <SID>X("Define","8fbfdc","","none")
call <SID>X("DefinedName","e2e4e5","","none")
call <SID>X("Delimiter","668799","","none")
call <SID>X("DiffAdd","fcfcfc","034a08","none")
call <SID>X("DiffChange","e8e8d3","65337a","italic")
call <SID>X("DiffDelete","ff0000","330000","none")
call <SID>X("DiffText","000000","b84fb8","bold")
call <SID>X("Directory","dad085","","none")
call <SID>X("EnumerationName","e2e4e5","","none")
call <SID>X("EnumerationValue","e2e4e5","","none")
call <SID>X("Error","e2e4e5","902020","none")
call <SID>X("ErrorMsg","e8e8d3","902020","none")
call <SID>X("Exception","e843b9","","none")
call <SID>X("Float","72c1e8","","none")
call <SID>X("FoldColumn","a0a8b0","384048","none")
" call <SID>X("Folded","a0a8b0","384048","italic")
call <SID>X("Function","edbf62","","none")
call <SID>X("Identifier","7e749c","","none")
call <SID>X("Ignore","e2e4e5","","none")
call <SID>X("IncSearch","101314","21d0eb","none")
call <SID>X("Include","8fbfdc","","none")
call <SID>X("Keyword","ffb964","","italic")
call <SID>X("Label","ffb964","","none")
call <SID>X("LineNr","3d3c21","000000","none")
call <SID>X("LocalVariable","663d7a","","none")
call <SID>X("Macro","8fbfdc","","none")
call <SID>X("MatchParen","ffffff","80a090","bold")
call <SID>X("ModeMsg","bdbd49","","none")
call <SID>X("MoreMsg","e2e4e5","","none")
call <SID>X("NonText","a800a8","000000","none")
" call <SID>X("Normal","e8e8d3","151515","none")
call <SID>X("Normal","ababa4","0d0c0d","none")
call <SID>X("Number","cf6a4c","","none")
call <SID>X("Operator","6ab6ba","0d0c0d","none")
call <SID>X("PMenu","4984d1","050505","none")
call <SID>X("PMenuSbar","4984d1","848688","none")
call <SID>X("PMenuSel","000000","bdc267","none")
call <SID>X("PMenuThumb","4984d1","a4a6a8","none")
call <SID>X("PreCondit","8fbfdc","","none")
call <SID>X("PreProc","2688bd","","bold")
call <SID>X("Question","59aba7","","none")
call <SID>X("Repeat","ffb964","","none")
call <SID>X("Search","f0a0c0","302028","underline")
call <SID>X("SignColumn","a0a8b0","384048","none")
call <SID>X("Special","458c27","","none")
call <SID>X("SpecialChar","799d6a","","none")
call <SID>X("SpecialComment","799d6a","","none")
call <SID>X("SpecialKey","808080","343434","none")
call <SID>X("SpellBad","e2e4e5","","none")
call <SID>X("SpellCap","e2e4e5","","none")
call <SID>X("SpellLocal","e2e4e5","","none")
call <SID>X("SpellRare","e2e4e5","","none")
call <SID>X("Statement","6894de","","italic")
call <SID>X("StatusLine","f0f0f0","101010","italic")
call <SID>X("StatusLineNC","a0a0a0","181818","italic")
call <SID>X("StorageClass","c59f6f","","none")
call <SID>X("String","9fba4d","","none")
call <SID>X("Structure","8fbfdc","","none")
call <SID>X("TabLine","000000","b0b8c0","italic")
call <SID>X("TabLineFill","9098a0","","none")
call <SID>X("TabLineSel","000000","f0f0f0","italic")
call <SID>X("Tag","799d6a","","none")
call <SID>X("Title","498994","","italic,bold")
call <SID>X("Todo","a1178a","e8db27","bold,underline")
call <SID>X("Type","b86e1e","","italic,bold")
call <SID>X("Typedef","ffb964","","none")
call <SID>X("Underlined","e2e4e5","","none")
call <SID>X("Union","e2e4e5","","none")
call <SID>X("VertSplit","181818","181818","italic")
call <SID>X("Visual","e2e4e5","404040","none")
call <SID>X("VisualNOS","e2e4e5","","none")
call <SID>X("WarningMsg","e2e4e5","","none")
call <SID>X("WildMenu","e2e4e5","","none")
call <SID>X("pythonBuiltin","50bf95","","italic")
call <SID>X("JavaScriptStrings","26b3ac","","italic")
call <SID>X("phpStringSingle","e8e8d3","","none")
call <SID>X("phpStringDouble","e2e4e5","","none")
call <SID>X("htmlString","799668","","none")
call <SID>X("htmlTagName","b097b0","","none")
" delete functions {{{
delf <SID>X
delf <SID>rgb
delf <SID>color
delf <SID>rgb_color
delf <SID>rgb_level
delf <SID>rgb_number
delf <SID>grey_color
delf <SID>grey_level
delf <SID>grey_number
" }}}


hi  Cursor       guifg=#000000 guibg=#f0f000 gui=NONE      ctermfg=0     ctermbg=11   cterm=reverse
hi  LineNr       guifg=#3D3D3D guibg=#000000 gui=NONE      ctermfg=237   ctermbg=0    cterm=NONE
hi  Folded       guifg=#a0a8b0 guibg=#384048 gui=NONE      ctermfg=248   ctermbg=238  cterm=NONE
hi CursorLine   guifg=NONE    guibg=#000000 gui=NONE      ctermfg=NONE ctermbg=16  cterm=NONE


" Special for XML
hi link xmlTag          Keyword
hi link xmlTagName      Conditional
hi link xmlEndTag       Identifier


" Special for HTML
hi htmlH1 guifg=#22ABA4   gui=underline ctermfg=167 cterm=UNDERLINE
hi htmlLink guifg=#c777ff ctermfg=177
hi link htmlTag         Keyword
hi link htmlTagName     Conditional
hi link htmlEndTag      Identifier
hi link htmlH2 htmlH1
hi link htmlH3 htmlH1
hi link htmlH4 htmlH1

" Special for CSS
hi cssTagName guifg=#70a8dd gui=BOLD  ctermfg=74 cterm=BOLD
hi cssBoxProp guifg=#d0af76  gui=NONE  ctermfg=180 gui=NONE
hi link cssColorProp cssBoxProp
hi link cssFontProp cssBoxProp
hi link cssTextProp cssBoxProp
hi cssPseudoClassId guifg=#9ccfdd gui=italic ctermfg=152 cterm=NONE
" hi cssIdentifier    guifg=#a2ddb8 gui=italic ctermfg=151 cterm=NONE

" Special for Markdown
hi markdownUrl guifg=#e48944 ctermfg=173
hi markdownCode guifg=#a7bee4   gui=BOLD ctermfg=151 cterm=BOLD
hi markdownCodeBlock guifg=#c5b1e4 ctermfg=182

" Special for Javascript
hi link javaScriptBrowserObjects  Constant
hi link javaScriptDOMObjects      Constant
hi link javaScriptDOMMethods           Exception

hi link javaScriptDOMProperties Type

hi link javaScriptAjaxObjects          Type
hi link javaScriptAjaxMethods          Exception
hi link javaScriptAjaxProperties       Keyword

hi link javaScriptFuncName            Title
hi link javaScriptHtmlElemProperties   Keyword
hi link javaScriptEventListenerKeyword Keyword

hi link javaScriptNumber      Number
hi link javaScriptPropietaryObjects Exception

" Special for Python
"hi  link pythonEscape         Keyword


" Special for CSharp
hi  link csXmlTag             Keyword

" Special for PHP
hi phpDefine  guifg=#ffc795    gui=BOLD ctermfg=209 cterm=BOLD

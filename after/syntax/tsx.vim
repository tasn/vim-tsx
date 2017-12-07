"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim syntax file
"
" Language: TSX (JavaScript)
" Depends: leafgarland/typescript-vim
"
" CREDITS: Inspired by Facebook.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Prologue; load in XML syntax.
if exists('b:current_syntax')
  let s:current_syntax=b:current_syntax
  unlet b:current_syntax
endif
syn include @XMLSyntax syntax/xml.vim
if exists('s:current_syntax')
  let b:current_syntax=s:current_syntax
endif

syntax region tsBlock start=/{/  end=/}/  contains=@typescriptAll extend fold


" JSX attributes should color as JS.  Note the trivial end pattern; we let
" tsBlock take care of ending the region.
syn region xmlString contained start=+{+ end=++ contains=tsBlock,typescriptBlock

" JSX child blocks behave just like JSX attributes, except that (a) they are
" syntactically distinct, and (b) they need the syn-extend argument, or else
" nested XML end-tag patterns may end the outer tsxRegion.
syn region tsxChild contained start=+{+ end=++ contains=tsBlock,typescriptBlock
  \ extend

" Highlight JSX regions as XML; recursively match.
"
" Note that we prohibit JSX tags from having a < or word character immediately
" preceding it, to avoid conflicts with, respectively, the left shift operator
" and generic Flow type annotations (http://flowtype.org/).
syn region tsxRegion
  \ contains=@Spell,@XMLSyntax,tsxRegion,tsxChild,tsBlock,typescriptBlock
  \ start=+\%(<\|\w\)\@<!<\z([a-zA-Z][a-zA-Z0-9:\-.]*\>[:,]\@!\)\([^>]*>(\)\@!+
  \ skip=+<!--\_.\{-}-->+
  \ end=+</\z1\_\s\{-}>+
  \ end=+/>+
  \ keepend
  \ extend

" Add tsxRegion to the lowest-level JS syntax cluster.
syn cluster typescriptExpression add=tsxRegion

" Allow tsxRegion to contain reserved words.
syn cluster javascriptNoReserved add=tsxRegion

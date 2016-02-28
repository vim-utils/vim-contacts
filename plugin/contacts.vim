if exists("g:loaded_contacts") || v:version < 700 || &cp
  finish
endif
let g:loaded_contacts = 1

function! contacts#contacts(match)
  if !executable('contacts')
    call s:throw('contacts is required')
  endif

  if !exists("s:all_contacts")
    let s:all_contacts = systemlist('contacts --all')
  end
  return filter(copy(s:all_contacts), 'v:val =~? "\\<' . a:match . '"')
endfunction

function! contacts#formatted_contacts(match)
  let contacts = contacts#contacts(a:match)
  let output = []
  for contact in contacts
    let [email, name] = split(contact, "\t")
    let clean_name = substitute(name, '\s*(null)\s*', '', 'g')
    call add(output, clean_name . " " . "<" . email . ">")
  endfor
  return output
endfunction

function! contacts#omnifunc(findstart, base)
  if a:findstart
    let existing = matchstr(getline('.')[0:col('.')-1],'\w*$')
    return col('.')-1-strlen(existing)
  endif
  return contacts#formatted_contacts(a:base)
endfunction

augroup contacts
  autocmd!
  autocmd Filetype mail
        \ if exists('+omnifunc') |
        \   setlocal omnifunc=contacts#omnifunc |
        \ endif
augroup END

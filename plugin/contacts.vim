if exists("g:loaded_contacts") || v:version < 700 || &cp
  finish
endif
let g:loaded_contacts = 1

function! contacts#add(output, identifier, email)
  if !empty(a:email)
    call add(a:output, a:identifier . " " . "<" . a:email . ">")
  end
endfunction

function! contacts#contacts(match)
  if !executable('contacts')
    call s:throw('contacts is required')
  endif

  if !exists("s:all_contacts")
    let s:all_contacts = systemlist('contacts -H -S -f "%fn %ln|%c|%he|%we|%oe"')
  end
  return filter(copy(s:all_contacts), 'v:val =~? "\\<' . a:match . '"')
endfunction

function! contacts#formatted_contacts(match)
  let contacts = contacts#contacts(a:match)
  let output = []
  for contact in contacts
    let [name, company, home_email, work_email, other_email] = split(contact, "|", 1)
    let identifier = empty(name) ? company : name
    call contacts#add(output, identifier, home_email)
    call contacts#add(output, identifier, work_email)
    call contacts#add(output, identifier, other_email)
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

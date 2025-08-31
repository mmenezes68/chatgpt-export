local function is_chapter(s)
  s = s:lower()
  return s:match('^cap[íi]tulo%s+%d+') or s:match('^chapter%s+%d+')
end
local SUB = {
  ['introdução']=true,['introduction']=true,
  ['apresentação']=true,['objetivo do capítulo']=true,['objective of the chapter']=true,
  ['ideias principais']=true,['main ideas']=true,
  ['conceitos-chave']=true,['key concepts']=true,
  ['questões de reflexão']=true,['reflection questions']=true,
  ['trechos relevantes']=true,['relevant passages']=true
}
function Header(h)
  local txt = pandoc.utils.stringify(h.content)
  if is_chapter(txt) then h.level = 1; return h end
  if SUB[txt:lower()] then h.level = 2; return h end
  if h.level == 1 then h.level = 2 end
  return h
end

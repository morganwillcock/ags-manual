-- invoke as Pandoc writer
-- write an a-z index as an HTML document

package.path = package.path .. ';lua/agsman.lua'
local agsman = require('agsman')
local stringify = (require 'pandoc.utils').stringify

function Doc(body, metadata, variables)
  local buffer = {}
  local header_format = '<h3 id="%s">%s</h3>'
  local indices = {}
  local link_format = '<a href="%s">%s</a>'
  local meta = PANDOC_DOCUMENT.meta
  local menu = {}
  local section

  -- get all of the heading info into a table
  for k, v in pairs(meta) do
    local title = stringify(v.title)
    if v.index then
      for itemtype, item in pairs(v.index) do
        for name, id in pairs(item) do
          local pagelink = k .. '.html#' .. stringify(id)

          if itemtype == 'script' or name == title then
            indices[name] = pagelink
          else
            indices[string.format('%s (%s)', name, title)] = pagelink
          end
        end
      end
    end
  end

  order = function(a, b)
    return b:lower() > a:lower()
  end

  -- sort the table and write it
  for name, id in agsman.pairs_by_keys(indices, order) do
    local letter = name:sub(1, 1):lower()

    if letter ~= section then
      table.insert(menu, string.format(link_format, '#' .. letter, letter:upper()))
      table.insert(buffer, string.format(header_format, letter, letter:upper()))
      section = letter
    end

    table.insert(buffer, string.format(link_format, id, name) .. '<br>')
  end

  return table.concat(menu, '&nbsp;\n') .. '\n' .. table.concat(buffer, '\n')
end

local meta = {}
meta.__index =
  function(_, key)
    return function() return '' end
  end
setmetatable(_G, meta)

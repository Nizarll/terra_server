local tools = {}
function tools.concat_table(t1, t2)
  for i, v in pairs(t2) do
    table.insert(t1, v)
  end
end

return tools

local M = {}

function M.print(t, indent, visited)
  -- Default values for indentation and visited tables (to avoid circular loops)
  indent = indent or 0  -- Indentation for readability (e.g., 2 spaces per level)
  visited = visited or {}  -- Track visited tables to detect cycles
 
  -- If the value is not a table, print it directly
  if type(t) ~= "table" then
    print(string.rep("  ", indent) .. tostring(t))
    return
  end
 
  -- Check for circular references
  if visited[t] then
    print(string.rep("  ", indent) .. "table (circular reference)")
    return
  end
 
  -- Mark the table as visited to avoid reprocessing
  visited[t] = true
 
  -- Print the table opening brace with indentation
  print(string.rep("  ", indent) .. "{")
  indent = indent + 1  -- Increase indent for nested content
 
  -- Iterate over all key-value pairs in the table
  for key, value in pairs(t) do
    -- Print the key (formatted to handle numeric/string keys)
    local key_str = type(key) == "string" and '"' .. key .. '"' or tostring(key)
    io.write(string.rep("  ", indent) .. key_str .. " = ")
 
    -- Recursively print the value (handles nested tables)
    print_table(value, indent, visited)
  end
 
  -- Print the table closing brace with indentation
  indent = indent - 1  -- Decrease indent after nested content
  print(string.rep("  ", indent) .. "}")
end

return M

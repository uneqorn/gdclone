global = {}

function global.fileExists(file)
  return os.rename(file,file)
end

function global.scandir(directory)
  local i, t, popen = 0, {}, io.popen --POSIX
  for filename in popen('ls "'..directory..'"'):lines() do
      i = i + 1
      t[i] = filename
  end
  if t[1] == nil then --NT
    for filename in popen('dir "'..directory..'" /b'):lines() do
        i = i + 1
        t[i] = filename
        print(t[i])
    end
  end
  if t[1] == nil then --Levels folder doesn't exist or it's empty
    os.execute("mkdir levels")
    os.execute("mkdir levels/placeholder")
  end
  return t
end

return global

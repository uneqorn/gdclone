global = {}

function global.fileExists(file)
  return os.rename(file,file)
end

function global.scandir(directory)
    local i, t, popen = 0, {}, io.popen
    for filename in popen('ls "'..directory..'"'):lines() do
        i = i + 1
        t[i] = filename
    end
    return t
end

return global

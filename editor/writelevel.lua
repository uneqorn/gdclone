writelevel = function(blocks, spikes)
  blockF = io.open(LEVELDIR.."/"..levels[selectedLevel].."/blocks.txt", "w")
  spikeF = io.open(LEVELDIR.."/"..levels[selectedLevel].."/spikes.txt", "w")
  local blockS = ""
  local spikeS = ""
  for k, v in pairs(blocks) do
    blockS = blockS.. v.x .." ".. v.y .."\n"
  end

  for k, v in pairs(spikes) do
    spikeS = spikeS.. v.x .." ".. v.y .."\n"
  end
  blockF:write(blockS)
  spikeF:write(spikeS)

  print("\nLEVEL SAVED AS:\n")
  print("Blocks:\n".. blockS)
  print("Spikes:\n".. spikeS)

  blockF:close()
  spikeF:close()
end

return writelevel

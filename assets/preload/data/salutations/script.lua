function opponentNoteHit(id, direction, AltAnimation, isSustainNote)
  if AltAnimation == 'Alt Animation' then
    health = getProperty('health')
    if getProperty('health') > 0.2 then
      setProperty('health', health -0.05);
    end
  end
end

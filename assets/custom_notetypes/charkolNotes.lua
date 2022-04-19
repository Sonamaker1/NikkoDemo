-- This is a Part of the Multiple Character Script 
-- Put this in custom_notetypes


function onCreate()

		for i = 0, getProperty('unspawnNotes.length')-1 do

			if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') and getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'charkolNotes' then
				setPropertyFromGroup('unspawnNotes', i, 'texture', 'luacharacters/notes/charkolNotes'); --Change texture Use this to change note texture but not necessary
				local e = getPropertyFromGroup('unspawnNotes', i, 'offsetX')+2; 
				setPropertyFromGroup('unspawnNotes', i, 'offsetX', e); 

				if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
					setPropertyFromGroup('unspawnNotes', i, 'offsetX', e-6); 
					setPropertyFromGroup('unspawnNotes', i, 'offsetY', 15);
					local scl = getPropertyFromGroup('unspawnNotes', i, 'scale.y');
					setPropertyFromGroup('unspawnNotes', i, 'scale.y', scl*0.975); 
					setPropertyFromGroup('unspawnNotes', i, 'multAlpha', 0.8); 
				end
				setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true); --Make it so Dad doesn't do animation
				
				
			end
		end
	
end

function onCreate()
    makeLuaSprite('nikkosketchbg', 'bg_sketch', -600, -200);
    setLuaSpriteScrollFactor('nikkosketchbg', 0.95, 0.95);
    addLuaSprite('nikkosketchbg', false); --false for BG and true for FG
    close(true);
end
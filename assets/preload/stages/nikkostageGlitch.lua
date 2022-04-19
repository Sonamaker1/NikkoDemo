function onCreate()
    makeLuaSprite('nikkoglitchbg', 'bg_glitch', -600, -200);
    setLuaSpriteScrollFactor('nikkoglitchbg', 0.95, 0.95);
    addLuaSprite('nikkoglitchbg', false); --false for BG and true for FG
    close(true);
end
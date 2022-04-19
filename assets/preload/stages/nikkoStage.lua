function onCreate()
    makeLuaSprite('nikkobg', 'nikko_bg', -600, -200);
    setLuaSpriteScrollFactor('nikkobg', 0.95, 0.96);
    addLuaSprite('nikkobg', false); --false for BG and true for FG
    close(true);
end
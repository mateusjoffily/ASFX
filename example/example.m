
Cfg = ASFX_setCfg([], 'lab', true);

Cfg.text.texture = {0 0 [0 0 -1] 0 0};

expinfo = ASFX(...
    '.\example.std', ...    %stimulus definition file
    '.\example.trd', ...    %trial definitions file
    '.\log.txt', ...        %results file
    Cfg);                   %configuration structure

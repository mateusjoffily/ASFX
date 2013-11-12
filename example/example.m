
Cfg = ASFX_setCfg([], 'lab', true);
Cfg.issueTriggers = 0;

Cfg.text.texture = {0 0 [0 0 -1] 0 0};

expinfo = ASFX(...
    '.\example.std', ...    %stimulus definition file
    '.\example.trd', ...    %trial definitions file
    '.\log.mat', ...        %results file
    Cfg);                   %configuration structure

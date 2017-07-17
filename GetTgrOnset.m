tgrch = 2; % trigger 電極編號
diff = 1000; % trigger channel 相鄰兩點振幅差距；根據病床設定
% Bed 2~5 = 1000; Bed 1 = ??
k = 1;
sigpt= [];

% eeglab;

% find tgr onset
for i = 2:length(EEG.data(tgrch,:))
    if EEG.data(tgrch,i) - EEG.data(tgrch,i-1) > diff 
        % 20170627-Bed 2: tgr onset threshold = diff > 1000 
        sigpt(k) = i;
        k = k+1;
    end
end

% transform tgr onset to events
for nevents = 1:length(sigpt)
    EEG.event(nevents).type = 33; %add event code = 1
    EEG.event(nevents).latency = sigpt(nevents);
    EEG.event(nevents).urevent = nevents;
end
    
% delete closed events within 200 msec
mark=zeros(1,length(EEG.event));
for k=2:length(EEG.event)
    if EEG.event(k).latency-EEG.event(k-1).latency < 99
        mark(k)=1;
    end
end
EEG.event(mark==1) = [];

clear all;
close all;

subno = 11; % subj no
expabbv = 'BE'; %exp name
blockno = [1 2 3]; % block no
tgrch = 130; % trigger ¹q·¥½s¸¹
rawdatapath = 'C:\Users\HJ\Dropbox\Exp\1610_sEEG_VGH\s011\EEG_BodyEmotion\raw\\';
datasetpath = 'C:\Users\HJ\Dropbox\Exp\1610_sEEG_VGH\s011\EEG_BodyEmotion\\';

if subno < 10
    subid = ['s00' num2str(subno)];
else 
    subid = ['s0' num2str(subno)];
end

eeglab;
for b = 1:length(blockno)
    EEG = pop_biosig([rawdatapath,subid,'_',expabbv,'#',num2str(blockno(b)),'.edf'], 'importevent','off','importannot','off');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, num2str(b-1),'setname',[expabbv,'#',num2str(blockno(b))],'gui','off'); 
    
% find tgr onset
k = 1;
sigpt= [];
for i = 2:length(EEG.data(tgrch,:))
    if EEG.data(tgrch,i) - EEG.data(tgrch,i-1) > 10000 
        % 20170627-Bed 2: tgr onset threshold = diff > 1000 
        % 20170625-Bed 1: 10000
        sigpt(k) = i;
        k = k+1;
    end
end

% transform tgrch onset to event
for nevents = 1:length(sigpt)
    EEG.event(nevents).type = 1; %add event code = 1
    EEG.event(nevents).latency = sigpt(nevents);
    EEG.event(nevents).urevent = nevents;
end
    
% delete closed events within 200 msec
mark=zeros(1,length(EEG.event));
for k=2:length(EEG.event)
    if EEG.event(k).latency-EEG.event(k-1).latency < 99
        mark(k)=99;
    end
end
EEG.event(mark==99) = [];

% save as a set file
EEG = pop_saveset(EEG,'filename',[subid,'_',expabbv,'#',num2str(blockno(b)),'.set'],'filepath',datasetpath);
end

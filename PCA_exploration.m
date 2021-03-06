function PCA_exploration
close all
% purpose: this function examines how the transition between different taps
% as defined in PCA space is

% a goal is to be able to visualize how taps are explored in a space for% a goal is to be able to visualize how taps are explored in a space for
% lesioned vs nonlesioned animals


%% adding dependencies
addpath('/Volumes/GoogleDrive/Team Drives/MC Learning Project/Matlab')
addpath('/Volumes/GoogleDrive/Team Drives/MC Learning Project/Matlab/output/')
addpath('/Volumes/GoogleDrive/Team Drives/MC Learning Project/Matlab/gerald new code/')

%% a list of all files:
% these are reconstructed from the dimreduced files
% lesioned
%GP1829_001_061_taps_pv_aah
%GP1830_001_084_taps_pv_aah
%GP1831_001_045_taps_pv_aah

% intact
%GP1832_001_070_taps_pv_aah
%GP1838_001_099_taps_pv_aah
%GP1840_001_059_taps_pv_aah

%% all rats
%tap_exploration('cmulti_taps_p_aah.mat')% this guy systematically undershot IPI, no stereotyped ITI but did learn some low CV for IPI

%% position AND velocity (taps)

% 16889 trials
tap_exploration('GP1829_001_061_taps_pv_aah.mat') %naive partial lesion but seemed to learn IPI kind of (after 5000 trials), and ITI kind of!!

% 16869 trials
tap_exploration('GP1830_001_084_taps_pv_aah.mat')% this guy was switched to auditory feedback but before then did not learn ANY structure

% 20321 trials
tap_exploration('GP1831_001_045_taps_pv_aah.mat')% this guy systematically undershot IPI, no stereotyped ITI but did learn some low CV for IPI

% 17084 trials
tap_exploration('GP1832_001_070_taps_pv_aah.mat') %learned around 13k trials

% 16751 trials
tap_exploration('GP1838_001_099_taps_pv_aah.mat')% learned around 5k trials

% 17800 trials
tap_exploration('GP1840_001_059_taps_pv_aah.mat')% learned around 5k trials



%% position (taps)

% 16889 trials
tap_exploration('GP1829_001_061_taps_p_aah.mat') %naive partial lesion but seemed to learn IPI kind of (after 5000 trials), and ITI kind of!!

% 16869 trials
tap_exploration('GP1830_001_084_taps_p_aah.mat')% this guy was switched to auditory feedback but before then did not learn ANY structure

% 20321 trials
tap_exploration('GP1831_001_045_taps_p_aah.mat')% this guy systematically undershot IPI, no stereotyped ITI but did learn some low CV for IPI

% 17084 trials
tap_exploration('GP1832_001_070_taps_p_aah.mat') %learned around 13k trials

% 16751 trials
tap_exploration('GP1838_001_099_taps_p_aah.mat')% learned around 5k trials

% 17800 trials
tap_exploration('GP1840_001_059_taps_p_aah.mat')% learned around 5k trials



%% velocity (taps)
% 16889 trials
tap_exploration('GP1829_001_061_taps_v_aah.mat') %naive partial lesion but seemed to learn IPI kind of (after 5000 trials), and ITI kind of!!

% 16869 trials
tap_exploration('GP1830_001_084_taps_v_aah.mat')% this guy was switched to auditory feedback but before then did not learn ANY structure

% 20321 trials
tap_exploration('GP1831_001_045_taps_v_aah.mat')% this guy systematically undershot IPI, no stereotyped ITI but did learn some low CV for IPI

% 17084 trials
tap_exploration('GP1832_001_070_taps_v_aah.mat') %learned around 13k trials

% 16751 trials
tap_exploration('GP1838_001_099_taps_v_aah.mat')% learned around 5k trials

% 17800 trials
tap_exploration('GP1840_001_059_taps_v_aah.mat')% learned around 5k trials


%% multi rat
% multiple rats
tap_exploration('multi_trials_v_aah.mat',3)% this guy systematically undershot IPI, no stereotyped ITI but did learn some low CV for IPI


end

function tap_exploration(rat)

%struct_unzip(analysis);

%% here add different resolutions in ways of parsing the data
%% plot distance against time
analysis = load(rat);
analysis=reconstructTrajectories(analysis);

%trajPC: ntrials/ntaps x nPCs
% 28928 x 69

%analysis = embedTrajectories(behStruct);



%% first plot the first two PCAs

figure;
subplot 331;
struct_unzip(analysis);
% group numss = {'ratnum (for multi)','1 ipi','2 taptype','3 tapnum','4 rewards','5 rewarded','6 trialnum','7 sessnum','8 daynum'};
% {'tap1','holdtime'} 'rewards50' 'rewarded50'
[dims,plt,idx]=vis(analysis,1); axis square; % group 1 is ipi

subplot 332;
[dims,plt,idx]=vis(analysis,2); axis square; % group 2
taptype = taptype(idx);

subplot 333; hold on
[dims,plt,idx]=vis(analysis,3); axis square; % group 3
tapnum = tapnum(idx);

subplot 334; hold on
[dims,plt,idx,rewards]=vis(analysis,4); axis square; % group 4
rewards = rewards(idx);

subplot 335; hold on
[dims,plt,idx]=vis(analysis,5); axis square; % group 5

subplot 336; hold on
[dims,plt,idx]=vis(analysis,6); axis square; % group 6

subplot 337; hold on
[dims,plt,idx]=vis(analysis,7); axis square; % group 7


subplot 338; hold on
[dims,plt,idx]=vis(analysis,8); axis square; % group 8


%% bin the PCs into 10 equal parts
%taptype = taptype(idx);
%tapnum = tapnum(idx);
%rewards = rewards(idx);

dims = dims(taptype>0,:);% take out 1-tap trials
rewards = rewards(taptype>0);
N = 5; %dividing the space of PCs equally depending on the range of max PCs
%[bins,bounds] = discretize(dims(:,1:2),N);
[n,xb,yb,xbin,ybin] = histcounts2(dims(:,1),dims(:,2),[N N]);
bins = [xbin ybin];
line([xb' xb'], [min(yb) max(yb)],'Color','k')
line([min(xb) max(xb)],[yb' yb'],'Color','k')

% need to define the space in which
plots = 0
if plots == 1
    cmap=colormap(gca,jet(size(bins,1)));
    % plot the transitions between taps
    figure; hold on
    axis([0 50 0 50])
    for i =1:25:length(plt)-25
        % scatter(dims(plt,1),dims(plt,2),[],sessnum(idx),'.'); str = 'Session #'; colormap(jet(max(sessions)));
        scatter(bins(i:i+24,1),bins(i:i+24,2),[],cmap(i:i+24,:),'.');
        pause(0.01)
        
        
    end
end
%% make the bins into a matrix (NxN)
% these are the N^2 diff kinds of taps

tapNum = transformMatrix(bins); %the tap "number"

% have to assign each tap to a bin
% T is N^2
subplot 339; hold on;

T = zeros(N^2);
R = zeros(N^2);
%T_plt=zeros(N^2,N^2, mod(size(tapNum),100));
for i = 1:2:size(tapNum,2)-2 %only look at the tap 1--> tap 2 transitions
    
    T(tapNum(i), tapNum(i+1)) =  T(tapNum(i), tapNum(i+1))+1; %fill in transition matrix
    R(tapNum(i), tapNum(i+1)) = R(tapNum(i), tapNum(i+1))+rewards(i);%rewards for that transition
end

counts =histcounts(tapNum);
sumCts = sum(counts);
%TT = T/sumCts; %proportion transition matrix

%% counts the kollomergen way
% for i = 1:length(counts)
%     for j = 1:length(counts)
%         NH(i,j) = (counts(i).*counts(j))./sumCts;
%     end
% end

%% shuffling all taps
T2 = zeros(N^2);
for p = 1:500
    tapNum2= tapNum(randperm(length(tapNum)));
    %disp(tapNum2(1:5))
    for i = 1:2:size(tapNum2,2)-1
        T2(tapNum2(i), tapNum2(i+1),p) =  T2(tapNum2(i), tapNum2(i+1))+1; %fill in transition matrix
        
    end
   % T2(:,:,p) = T2(:,:,p)./sumCts;
end

TTT=T./prctile(T2,97.5,3); %most conservative estimate
TTT(TTT<1) =0; % only the significant ratios (>1)

%log(TTT)
%TTT=TT./max(T2,[],3); %most conservative estimate
%figure;
imagesc(log(TTT))
%imagesc(T)

xlabel('tap(t+1)')
ylabel('tap(t)')
axis square
c = colorbar;
c.Label.String =  'Expected:Shuffled Transitions';
title('Transition Matrix')
suptitle(rat(1:6))

set(gcf,'color','w');
set(gcf,'Position',[100 100 700 600]);


%% raw counts
% figure;subplot 131; imagesc(T);axis square
% subplot 132;imagesc(R); colormap(gca,flipud(hot));axis square;
% subplot 133;scatter(reshape(T,[1 N^4]),reshape(R,[1 N^4]));axis square; dline;
% 

% plot the kind of tap (tap #?) by time
if plots == 1
    id = 1;
    skp = 300; %how many frames to plot at once
    figure; maxx=histogram(tapNum);
    axismax = max(maxx.BinCounts);
    for i = 1:size(tapNum,2)-1
        T(tapNum(i), tapNum(i+1)) =  T(tapNum(i), tapNum(i+1))+1; %fill in transition matrix
        if mod(i,skp) == 1
            % plot a time varying transition matrix
            %  figure(2)
            %   imagesc(T)
            pause(0.001)
            
            % plot a time varying histogram
            
            histogram(tapNum(1:i))
            axis([0 26 0 axismax])
            xlabel('tap kind')
            ylabel('number of taps')
        end
        %pause(0.01)
    end
end





%% separate by first and second tap in a trial

%% do taps converge over time?
figure;
subplot 121
plot(tapNum,'.')
xlabel('time')
ylabel('tap kind')
axis square
prettyplot
subplot 122
histogram(tapNum);
xlabel('tap kind')
ylabel('number of taps')
axis square
prettyplot

%% looking at how rewards relates to tapNum overall

for i = 1:max(tapNum)
    tap_reward(i) = size(rewards(tapNum==i),1);
    tap_cumsum(i,:) = cumsum(tapNum==i);
end
figure;
subplot 121
bar(tap_reward)
xlabel('tap kind')
ylabel('cumulative rewards')
prettyplot

subplot 122
plot(tap_cumsum','LineWidth',2)
xlabel('taps (time)')
ylabel('cumulative sum')
legend('1','2','3','4','5','6','7','8','9')
prettyplot


%figure; scatter(tapNum,rewards);

%% separate by first and second tap in a trial


%struct_unzip(analysis)
%plot(rewards,'.')
end

function [dims, plt,idx,rewards]=vis(analysis,g)

struct_unzip(analysis);

%home = 'G:\OneDrive - Harvard University\RatStructs\OpCon2\tsne';
%cd(home)
%% parameters

dimname = 'pca'; % 'tsne' or 'pca
showVideo = 4; %1 for paw arcs, 2 whole body arcs, 3 for limbs, 4 for limbs+arcs

plot_parts = [4 5 7]; % parts to plot (Fig2/4). default dom/opp paw, ear

plotOpp = false; % plot opp paw and camera

%% color scatter plot by groups
groups = {'ratnum','ipi','taptype','tapnum','rewards','rewarded','trialnum','sessnum','daynum'};
% 'ratnum','taptype','ipi','rewarded','daynum','pdiff'
% 'rewards','tapnum','rewarded50','rewards50','sday','rday'

% define custom grouping
% groups = {'custom'};
% custom = bi2de([tapnum==2, sessnum>prctile(sessnum,50)]);
% customstr = 'Tap# and Session#';

%% show subset of trials
plt = true(size(ipi));
% plt = sessnum>90;
% plt = mod(daynum,10)==9;
% plt = daynum==9;
% plt = sessnum<prctile(sessnum,25) | sessnum>prctile(sessnum,75);
% plt = rewards>0;% & (sessnum<188 | sessnum>205);
% plt = sessnum<166;
% plt = sessnum>45 & ipi>600 & ipi<800;
% plt = (sessnum>30 & sessnum<40);% & rewards==0;

%% default parameters
useRecon = 1; % reconstruct

pnames = {'ear','dom elbow','nose','dom paw','opp paw','opp elbow','lever'};

% heatmap (Fig2) and line graphs (Fig3)
select3 = true; % click selects 3 nearby trials
plotTapDur = 0; % show dashed lines for tap hold times
plotVel = true; % plot velocity instead of position
plotWarped = true; % plot warped velocity traces
anRaw = false; % plot raw analog instead of velocity

% video stuff
repeats = 1; % video replay
slow_factor = 5; % video speed

% k nearest neighbors
recomputeNN = false; % if true, recompute
k=20;
neighbors=[1 2]; % which neighbors to select

cmap = distinguishable_colors(njoints,{'w','k'});

% figure positions
% if strcmp(getenv('COMPUTERNAME'),'GERALD_LAB')
%     fpos = [5   547   512   420; ...
%         6    43   793   415; ...
%         520   546   278   420;...
%         803    40   873   418;...
%         801   427   441   539;...
%         801   202   553   764];
% else
%     fpos = [5   547   512   420; ...
%         6    43   793   415; ...
%         520   546   278   420;...
%         803    40   873   418;...
%         801   427   441   539;...
%         801   202   553   764];
% end

multiFlag = contains(datatype,'multi');
n=length(plot_parts);
%% load appropriate data

if ~exist('traj','var')
    useRecon=1;
elseif tapFlag && ~exist('tap_filt_rc','var')
    useRecon=0;
elseif ~tapFlag && ~exist('traj_warp_rc','var')
    useRecon=0;
end
if useRecon>0 || tapFlag
    plotWarped = true;
end

% store parameters
vnames = who;
fnames = [fieldnames(analysis); 'analysis'; 'vnames'; 'ans'];
params = struct_zip(vnames(~ismember(vnames,fnames)));
analysis.params = params;

if useRecon>0
    disp('using reconstructed trajectories')
    if tapFlag
        tap_filt = tap_filt_rc;
        tap_vel = tap_vel_rc;
        tap_speed = sqrt(nansum(tap_vel.^2,3));
    else
        traj_warp = traj_warp_rc;
        traj_warp_vel = traj_warp_vel_rc;
        traj_warp_speed = sqrt(nansum(traj_warp_vel.^2,3));
    end
end

if tapFlag
    % replace traj variables with tap variables
    time_warp = time_tap;
    traj_warp = tap_filt;
    traj_warp_vel = tap_vel;
    traj_warp_speed = tap_speed;
    warpFactor = ones(size(tap_filt,1),1);
    
    % re-index trial-based variables with taps
    fnames = fieldnames(analysis);
    ntrials = length(ipi);
    for i = 1:length(fnames)
        if size(analysis.(fnames{i}),1)==ntrials
            eval(sprintf('%s=%s(tap_trial(:,1),:,:,:);',fnames{i},fnames{i}));
        end
    end
    tap1 = tap_trial(:,3);
    tap2 = nan(size(tap1));
    tapnum = tap_trial(:,2);
    
    plt = plt(tap_trial(:,1));
else
    groups(strcmp(groups,'tapnum'))=[];
    groups(strcmp(groups,'taptype'))=[];
end

if ~multiFlag
    groups(strcmp(groups,'ratnum'))=[];
end

% recompute trial number in session
if ~exist('sesstrialnum','var')
    sesstrialnum = nan(size(sessnum));
    if ~multiFlag; rats = 1; end
    for r = 1:length(rats)
        if multiFlag
            behStruct = output{r}.behStruct;
        end
        for s = 1:max(sessnum)
            ix = sessnum==s;
            if multiFlag
                ix = ix & ratnum==r;
            end
            sesstrialnum(ix) = round(trialnum(ix)*length(behStruct(s).rewards));
        end
    end
end

if anRaw
    traj_speed(:,:,1,an) = traj_filt(:,:,1,an);
    traj_warp_speed(:,:,1,an) = traj_warp(:,:,1,an);
end

plt = plt(kp);

%g = 1; % group index
%close all
value = 0;
plotted1 = false; % has heatmap been plotted?
plotted2 = false; % have individual trials been plotted
%while value(1)~=113
%% figure 1: scatter plot of embeddings
% h1=figure(1);
%figure
%    WinOnTop(h1);
%  set(h1,'pos',fpos(1,:))

if ~strcmpi(dimname,'pca')
    dims = trajTSNE;
else
    dims = trajPC;
end
groupby = groups{g};
idx = kp(plt);

selectMode = 2; % 1: select points; 2: select trials;
ix = find(rewards>3); % 0: starting selection

switch lower(groupby)
    case 'ipi'
        
        scatter(dims(plt,1),dims(plt,2),[],ipi(idx),'.'); str = 'IPI (ms)'; cmap1 = parula(1201); cmap1(1,:) = 0; colormap(gca,cmap1);
        title(str)
    case {'sessnum','session','sess'}
        
        scatter(dims(plt,1),dims(plt,2),[],sessnum(idx),'.'); str = 'Session #'; colormap(gca,jet(max(sessnum)));
        title(str)
    case {'tap1','holdtime'}
        
        scatter(dims(plt,1),dims(plt,2),[],tap1(idx),'.'); caxis([0 500]); str = 'Hold time (ms)';
        title(str)
    case 'daynum'
        
        scatter(dims(plt,1),dims(plt,2),[],daynum(idx),'.'); str = 'Day'; colormap(gca,jet(max(daynum)));
        title(str)
    case 'trialnum'
        scatter(dims(plt,1),dims(plt,2),[],trialnum(idx),'.'); str = 'Trial number';
        title(str)
    case 'rewards'
        scatter(dims(plt,1),dims(plt,2),[],rewards(idx),'.'); str = 'Rewards'; colormap(gca,jet(6));
        title(str)
    case 'rewarded'
        scatter(dims(plt,1),dims(plt,2),[],rewards(idx)>0,'.'); str = 'Rewarded';
        title(str)
    case 'tapnum'
        scatter(dims(plt,1),dims(plt,2),[],tapnum(idx),'.'); str = 'Tap #'; colormap(gca,jet)
        title(str)
    case 'taptype'
        colors=[0 0 0; 0 0 1; 0.5 0.5 1; 1 0.5 0.5; 1 0 0];
        scatter(dims(plt,1),dims(plt,2),[],colors(taptype(idx)+1,:),'.'); str = 'Tap Type';
        colormap(gca,colors)
        title(str)
    case 'rewards50'
        scatter(dims(plt,1),dims(plt,2),[],rewards50(idx),'.'); str = 'Avg Rewards';
        title(str)
    case 'rewarded50'
        scatter(dims(plt,1),dims(plt,2),[],rewarded50(idx),'.'); str = 'Avg Reward Rate';
        title(str)
    case 'ratnum'
        scatter(dims(plt,1),dims(plt,2),[],ratnum(idx),'.'); str = 'Rat'; colormap(gca,distinguishable_colors(max(ratnum),'w'))
        title(str)
end


xlabel([dimname ' 1'])
c = colorbar;
c.Label.String = str;
ylabel([dimname ' 2'])



%end
end
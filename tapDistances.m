function tapDistances
close all
% purpose: this function quantifies the Euclidian distance between tap
% trajectories

% a goal is to be able to visualize how taps are explored in a space for% a goal is to be able to visualize how taps are explored in a space for
% lesioned vs nonlesioned animals


%% adding dependencies
addpath('/Users/lucy/Google Drive File Stream/Team Drives/MC Learning Project/Matlab/output/')
addpath('/Users/lucy/Google Drive File Stream/Team Drives/MC Learning Project/Matlab/gerald new code/')

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


% 16889 trials
tap_exploration('GP1829_001_061_taps_p_aah.mat',1) %naive partial lesion but seemed to learn IPI kind of (after 5000 trials), and ITI kind of!!

% 16869 trials
tap_exploration('GP1830_001_084_taps_p_aah.mat',2)% this guy was switched to auditory feedback but before then did not learn ANY structure

% 20321 trials
tap_exploration('GP1831_001_045_taps_p_aah.mat',3)% this guy systematically undershot IPI, no stereotyped ITI but did learn some low CV for IPI

% 17084 trials
tap_exploration('GP1832_001_070_taps_p_aah.mat',4) %learned around 13k trials

% 16751 trials
tap_exploration('GP1838_001_099_taps_p_aah.mat',5)% learned around 5k trials

% 17800 trials
tap_exploration('GP1840_001_059_taps_p_aah.mat',6)% learned around 5k trials
end

function tap_exploration(rat,s)
%% plot distance against time
analysis = load(rat);
analysis=reconstructTrajectories(analysis);
% calculate distances
%take x and y coordinates and compute displacement
displacement = squeeze(sqrt(analysis.tap_filt_rc(:,:,1,:).^2+analysis.tap_filt_rc(:,:,2,:).^2));
%displacement = displacement-displacement(:,50,:);


tap_rewards = analysis.rewards(analysis.tap_trial(:,1)); %which taps were rewarded by how much
cmap=colormap(flipud(hot(7)));
cmap=[1 1 1; 0 0 0];
tap_rewards(tap_rewards>0) = 1;
tap_rewards (tap_rewards==0) = 0;

for i = 1:7
    norms(i,:) =  vecnorm(displacement(:,:,i)');
    
end


figure(1); subplot(2,3,s);hold on;axis([1000 5000 1000 5000])
xlabel('paw1 ||tap||')
ylabel('paw2 ||tap||')
x = 100;
for tr = 1:x:length(norms)-x

    scatter(norms(4,tr:tr+x-1),norms(5,tr:tr+x-1),[],cmap(tap_rewards(tr:tr+x-1)+1,:),'filled'); %paw 1 and paw 2
    pause(0.001);
end





end

function exploration(rat)

analysis = load(rat);
analysis=reconstructTrajectories(analysis);

%% plot distance against time

% calculate distances
%take x and y coordinates and compute displacement
displacement = squeeze(sqrt(analysis.tap_filt_rc(:,:,1,:).^2+analysis.tap_filt_rc(:,:,2,:).^2));
%displacement = displacement-displacement(:,50,:);


for i = 1:7
    norms(i,:) =  vecnorm(displacement(:,:,i)');
    
end

figure; hold on; axis([0 nanmax(norms(4,:)) 0 max(norms(5,:))])
xlabel('paw1 displacement')
ylabel('paw2 displacement')
x = 20;
for tr = 1:x:length(norms)-x
    
    plot(norms(4,tr:tr+x-1),norms(5,tr:tr+x-1),'ro'); %paw 1 and paw 2
    pause(0.001);
end

%just use x coordinates as displacement
%displacement = squeeze(analysis.tap_filt_rc(:,:,1,:));

%just use y coordinates as displacement
%displacement = squeeze(analysis.tap_filt_rc(:,:,2,:));


holder = NaN*ones(1,61,7);
displacement_shift = cat(1, holder,displacement); %(t-1)
displacement_shift2 = cat(1, holder,displacement_shift); %(t-1)

displacement_shift = displacement_shift(1:end-1,:,:);
displacement_shift2 = displacement_shift2(1:end-2,:,:);


differ = displacement_shift-displacement; %difference in one trial ahead and one trial back [(t-1) - t]
differ2 = displacement_shift2-displacement; %difference in one trial ahead and one trial back [(t-1) - t]

figure; hold on;
for i = 1:size(differ,3)
    euclid_dist(i,:) = vecnorm(differ(:,:,i)');
    euclid_dist2(i,:) = vecnorm(differ2(:,:,i)');
    subplot(4,2,i);plot(euclid_dist(i,:),'.');
    
end
subplot(4,2,1); title('ear')
xlabel('taps')
ylabel('distance between tap(t) and tap(t+1)')
subplot(4,2,2); title('elbow')
subplot(4,2,3); title('nose')
subplot(4,2,4); title('paw')
subplot(4,2,5); title('paw2')
subplot(4,2,6); title('elbow2')
subplot(4,2,7); title('lever')



tap_rewards = analysis.rewards(analysis.tap_trial(:,1)); %which taps were rewarded by how much
figure; hold on;
for i = 1:size(differ,3)
    subplot(4,2,i);scatter(tap_rewards, euclid_dist(i,:));
    
end

subplot(4,2,1); title('ear')
xlabel('reward')
ylabel('distance between tap(t) and tap(t+1)')
subplot(4,2,2); title('elbow')
subplot(4,2,3); title('nose')
subplot(4,2,4); title('paw')
subplot(4,2,5); title('paw2')
subplot(4,2,6); title('elbow2')
subplot(4,2,7); title('lever')


%% are taps following a rewarded tap on average more similar than taps
% following unrewarded taps?
rewarded_taps = euclid_dist(tap_rewards>0);
unrewarded_taps = euclid_dist(tap_rewards==0);
nanmean(euclid_dist(tap_rewards>0))
nanmean(euclid_dist(tap_rewards==0))

figure;hold on
histogram(unrewarded_taps)
histogram(rewarded_taps)
legend('unrewarded','rewarded')

ylabel('distance between tap(t) and tap(t+1)')
xlabel('# taps')

%% same analysis but with magnitude of taps

%color taps by magnitude of reward

figure;hold on
histogram(unrewarded_taps)
histogram(euclid_dist(tap_rewards==1))
histogram(euclid_dist(tap_rewards==2))
histogram(euclid_dist(tap_rewards==3))
histogram(euclid_dist(tap_rewards==4))
histogram(euclid_dist(tap_rewards==5))
histogram(euclid_dist(tap_rewards==6))
legend('unrewarded', 'rew=1','rew=2','rew=3','rew=4','rew=5','rew=6')

ylabel('distance between tap(t) and tap(t+1)')
xlabel('# taps')

nanmean(euclid_dist(tap_rewards==0))
nanmean(euclid_dist(tap_rewards==1))
nanmean(euclid_dist(tap_rewards==2))
nanmean(euclid_dist(tap_rewards==3))
nanmean(euclid_dist(tap_rewards==4))
nanmean(euclid_dist(tap_rewards==5))


%% scatter the distance between t and t+1 and t and t+2 and color by reward
figure; hold on;
for k = 0:6
    subplot(4,2,k+1);scatter(euclid_dist(1,tap_rewards==k), euclid_dist2(1,tap_rewards==k))
    
end

subplot(4,2,1); title('unrewarded')
ylabel('distance between tap(t) and tap(t+2)')
xlabel('distance between tap(t) and tap(t+1)')
subplot(4,2,2); title('rew = 1')
subplot(4,2,3); title('rew = 2')
subplot(4,2,4); title('rew = 3')
subplot(4,2,5); title('rew = 4')
subplot(4,2,6); title('rew = 5')
subplot(4,2,7); title('rew = 6')
equalabscissa(4,2)


idx = find(tap_rewards==5);
figure; hold on;
plot(idx,euclid_dist(1,idx),'.');
xlabel('taps')
ylabel('distance between tap(t) and tap(t+1)')
title('rew =5')

figure; hold on;
for i = 1:size(find(tap_rewards>0))
    plot(idx(i),euclid_dist(1,idx(i)),'.');
    pause(.01)
end
plot(idx,euclid_dist(1,idx),'.');



% plot separate, the taps that were rewarded a lot and the ones that were
% not

figure; hold on
for i = 1:size(differ,3)
    subplot(4,2,i);hold on;plot(find(tap_rewards>0),euclid_dist(i,tap_rewards>0),'b.');
    plot(find(tap_rewards==0),euclid_dist(i,tap_rewards==0),'r.');
end


%scatter(vecnorm(displacement(tap_rewards>0,:,1)'), vecnorm(displacement_shift(tap_rewards>0,:,1)'));
%axis square; axis equal;dline;

%figure
%scatter(vecnorm(displacement(tap_rewards==0,:,1)'), vecnorm(displacement_shift(tap_rewards==0,:,1)'));
%axis square; axis equal;dline;

%take only taps that were rewarded a lot (5) and scatter plot the distance
% between the two



hold on; plot(find(rew1==1),euclid_dist(rew1==1),'rx')


end
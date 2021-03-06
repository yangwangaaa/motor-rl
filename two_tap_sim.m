function two_tap_sim
% purpose: simulate the task structure of the 2-tap task
% todo: separate the agent from the environment
% make it in continuous time

%% begin with simple 1-tap regime

S = [1 2];         % states: start, tone
A = [1 2 3];       % actions: tap, wait, lick

% set "free" parameters
lr = 0.2;          % learning rate
gamma = 0.3;       % gamma
decay = 0.05;       % decay
epsilon = 1;    % starting epsilon value for e-g search

% agent's knowledge of the environment
% P = [];         % transition function
R = [0 0 0; 0 0 1];        % reward function (how much reward do you get in each state)
DA = [30,4;
     15,2;
     20,3];       % dwell time function for each action (how much time do you spend in each state)

c.s = 1;    % current state
c.a = []; % current action (null)
c.r = []; % current reward (null)

% 1. initialize Q-table: maximum expected future rewards for action at each state.
Q = zeros(length(S),length(A));

% training
for n = 1:100 %100 decisions 
    
    
    % 2. choose action
    if rand() > epsilon && n>10
         [~,c.a(n)] = max(Q(S(c.s(n)),:));% exploitation
    else 
        c.a(n) = randi([1 3]);% exploration
    end
       
    % 3. choose how much time you're spending in this state
     c.d(n) = normrnd(DA(c.a(n),1),DA(c.a(n),2)); % over time, you discover that there should be a new mean for each state you discover
     
    
    % 4. update the state
    if c.a(n) == 1     % tap
        c.s(n+1) = S(2); % go to: tone
        c.r(n) = 0;
    elseif c.a(n) == 2 % wait
        c.s(n+1) = S(1); % go to: start
        c.r(n) = 0;
    elseif c.a(n) == 3 % lick
        c.s(n+1) = S(1);   % go to: start
        c.r(n) = 1;
    end
    
    
    % 5. measure reward
    
    
    % 6. update reward function
    Q(c.s(n),c.a(n)) = Q(c.s(n),c.a(n)) + lr*( (R(c.s(n),c.a(n)) + gamma*max(Q(c.s(n+1),:)) - Q(c.s(n),c.a(n))) );  % update values (q-learning)
    
    if epsilon>0.1
    epsilon = epsilon-decay*epsilon;
    else
        epsilon = 0.1;
    end
end

figure; hold on
subplot 311;
plot(c.a,'-o')
y_values = [1 2 3];
y_labels ={'tap' 'wait' 'lick'};
set(gca, 'Ytick',y_values,'YTickLabel',y_labels);

title(strcat('actions'))
subplot 312
plot(c.r,'-o')

y_values = [0 1];
y_labels ={'no reward' 'reward'};
set(gca, 'Ytick',y_values,'YTickLabel',y_labels);
title('rewards')

subplot 313
plot(c.s(1:n),'-o')
y_values = [1 2];
y_labels ={'start' 'tone'};
set(gca, 'Ytick',y_values,'YTickLabel',y_labels);
title('states')


end

function agent

end

function environment

end
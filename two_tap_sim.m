function two_tap_sim
% purpose: simulate the task structure of the 2-tap task

%% begin with simple 1-tap regime

S = [1 2];         % states: start, tone
A = [1 2 3];       % actions: tap, wait, lick

% set "free" parameters
lr = 0.5;          % learning rate
gamma = 0.1;       % gamma
decay = 0.1;       % decay
epsilon = 1;    % starting epsilon value for e-g search

% agent's knowledge of the environment
% P = [];         % transition function
R = [0 1];        % reward function (how much reward do you get in each state)
D = [10 2];       % dwell time function (how much time do you spend in each state)

c.s = 1; %current state
c.a = []; % current action (null)
c.r = []; % current reward (null)

% 1. initialize Q-table
Q = zeros(length(S),length(A));
% Q- table: maximum expected future rewards for action at each state.

% training
for n = 1:10 %100 trials
    
    % 2. choose action
    if rand() < epsilon % exploration
        c.a(n) = randi([1 3]);
    else % exploration
        c.a(n) = max(Q(S(c.s),:));
        epsilon = epsilon-decay*epsilon;
    end
    
    % 3. update the state
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
    
    % 3. measure reward
    
    
    % 4. update reward function
    Q(c.s(n),c.a(n)) = Q(c.s(n),c.a(n)) + lr*(c.r(n) - Q(c.s(n),c.a(n)));  % update values (q-learning)
    
    
end


end
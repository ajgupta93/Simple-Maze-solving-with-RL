%% Load data
load rewards.txt;
load prob_a1.txt;
load prob_a2.txt;
load prob_a3.txt;
load prob_a4.txt;

%% Initialize variables
n_states = size(rewards,1);
disc_factor = 0.9925;
n_actions = 4;

a = zeros([n_states, n_states, 4]);
a(:,:,1) = full(spconvert(prob_a1));
a(:,:,2) = full(spconvert(prob_a2));
a(:,:,3) = full(spconvert(prob_a3));
a(:,:,4) = full(spconvert(prob_a4));

policy = zeros([n_states, 1]);
for i=1:n_states
    policy(i) = ceil(4*rand);
end

P_pi = zeros(n_states);
prev_V = zeros([n_states,1]);
I = eye(n_states);
count = 0;

%% Run policy iteration till no change in policy
while(1)
    count = count+1;
    for i=1:n_states
        P_pi(i,:) = a(i,:,policy(i));
    end
    V_pi = (I-disc_factor.*P_pi)\rewards;
    for i=1:n_states
        sums = [sum(a(i,:,1)'.*V_pi);...
            sum(a(i,:,2)'.*V_pi);...
            sum(a(i,:,3)'.*V_pi);...
            sum(a(i,:,4)'.*V_pi)];
        [m, idx] = max(sums);
        policy(i) = idx;
    end
    if(all(policy==prev_policy))
        break;
    end
    prev_policy = policy;
    prev_V = V_pi;
end
disp(count);

%% Plot values
v = reshape(V_pi,[9,9]);
figure,imagesc(v),colormap(summer);
hold on;

[X,Y] = meshgrid(1:9,1:9);
X = reshape(X,[81,1]);
Y = reshape(Y,[81,1]);
txt = num2str(V_pi);
text(X,Y,txt,'VerticalAlignment','middle','HorizontalAlignment','center');
hold off;

%% Plot paths
figure,imagesc(v),colormap(summer);
hold on;
directions = ['<','^','>','v',' '];
id = V_pi<=0;
p = policy;
p(id) = 5;
p(79) = 5;
txt2 = directions(p);
txt2 = num2str(txt2');
text(X,Y,txt2,'VerticalAlignment','middle','HorizontalAlignment','center');
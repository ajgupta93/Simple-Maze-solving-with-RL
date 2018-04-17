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

v = zeros([n_states,1]);
v_prev = zeros([n_states,1]);
policy = zeros([n_states,1]);
count = 0;

%% Run value iteration till difference in values is less than delta
while(1)
    count = count + 1;
    for i=1:n_states
        sums = [sum(a(i,:,1)'.*v);...
                sum(a(i,:,2)'.*v);...
                sum(a(i,:,3)'.*v);...
                sum(a(i,:,4)'.*v)];
        [m, idx] = max(sums);
        v(i) = rewards(i) + disc_factor*m;
        policy(i) = idx;
    end
    if(all(abs(v_prev-v)<0.001))
        break;
    end
    v_prev = v;
end

disp(count);

%% Plot values
vx = reshape(v,[9,9]);
figure,imagesc(vx),colormap(summer);
hold on;

[X,Y] = meshgrid(1:9,1:9);
X = reshape(X,[81,1]);
Y = reshape(Y,[81,1]);
txt = num2str(v);
text(X,Y,txt,'VerticalAlignment','middle','HorizontalAlignment','center');
hold off;

%% Plot paths
figure,imagesc(vx),colormap(summer);
hold on;
directions = ['<','^','>','v',' '];
id = v<=0;
p = policy;
p(id) = 5;
p(79) = 5;
txt2 = directions(p);
txt2 = num2str(txt2');
text(X,Y,txt2,'VerticalAlignment','middle','HorizontalAlignment','center');
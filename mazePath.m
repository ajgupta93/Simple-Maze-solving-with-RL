function [] = mazePath(startState, endState, policy)
state = startState;
path = [];
while(state~=endState)
    disp(state);
    action = policy(state);
    if(action==1)
        disp('left');
        path = [path, 'left'];
        state = state-9;
    elseif(action==2)
        disp('up');
        path = [path, 'up'];
        state = state-1;
    elseif(action==3)
        disp('right');
        path = [path, 'right'];
        state = state+9;
    else
        disp('down');
        path = [path, 'down'];
        state = state+1;
    end
end
disp(path);
end
% Single Sample Variable Increment
function [accuracy] = q2_1singlevar(filename, training_percentage, b)
file = dlmread(filename);
n_sample = size(file);
c = 0;

% loop for determing number of classes
for i = 1:n_sample(1)
    if(c < file(i, 1))
        c = file(i, 1);
    end
end

% Initializations
shuffle = randperm(n_sample(1));
tr = floor(training_percentage*n_sample(1)/100);
te = n_sample(1) - tr;
trg = zeros(tr, n_sample(2));
tst = zeros(te, n_sample(2));
accuracy = 0;

% Assignment of testing and training dataset
a = 0;
b1 = 0;
for i = 1:n_sample(1)
    if(shuffle(i) <= tr)
        trg(a+1, :) = file(i, :);
        a = a + 1;
    else
        tst(b1+1, :) = file(i, :);
        b1 = b1 + 1;
    end
end

nc2 = zeros(c, c, n_sample(2));
for i = 1:c
    for j = i+1:c
        subtrg = zeros(1, n_sample(2));
        a = zeros(1, n_sample(2));
        constraint = 12000;
        n_misclassified = 0;
        minimum = 0;
        
        % Finding the subset which belong to 'i'th and 'j'th class
        for k = 1:tr
            if (trg(k,1)==i || trg(k,1)==j)
                subtrg = [subtrg; trg(k,:)];
                minimum = minimum + 1;
            end
        end
        
        mod_min = minimum;
        
        % Optimization of 'a' vector
        for k = 1:constraint
            mod_i = mod(k, mod_min)+1;
            Y=[1,subtrg(mod_i,2:end)];
            if(subtrg(mod_i, 1) == j)
                Y = -Y;
            end
            if(a*Y'<= b)
                n_misclassified = n_misclassified + 1;
                a = a + Y*(1/k); % 1/k is the decreasing function
            end
            if(mod_i == mod_min)
                if(n_misclassified < minimum)
                    minimum = n_misclassified;
                    best_a = a;
                end
                if n_misclassified==0
                    break;
                end
                n_misclassified=0;
            end
        end
        
        nc2(i,j,:) = best_a(1,:);
    end
end

% Finding the accuracy
for i=1:te
    class = zeros(1, c);
    for j=1:c
        
        for k=j+1:c
            y=[1,tst(i,2:end)];
            subnc2 = zeros(1, n_sample(2));
            subnc2(1,:)= nc2(j,k,:);
            if(subnc2*y' < b)
                class(k)=class(k)+1;
            else
                class(j)=class(j)+1;  
            end
        end
        
    end
    
    [maximum, index]=max(class);
    if(index == tst(i,1))
        accuracy = accuracy + 1;
    end
end

accuracy = accuracy/(n_sample(1) - tr);
end
function [accuracy] = k_NN(filename, p, training_percentage)
file = dlmread(filename);
n_sample = size(file);
c = 0;
k=1;
% loop for determing number of classes
for i = 1:n_sample(1)
    if(c < file(i, 1))
        c = file(i, 1);
    end
end

shuffle = randperm(n_sample(1));
tr = floor(training_percentage*n_sample(1)/100);
te = n_sample(1) - tr;
trg = zeros(tr, n_sample(2));
tst = zeros(te, n_sample(2));
accuracy = 0;

%Assignment of testing and training dataset
a = 0;
b = 0;
for i = 1:n_sample(1)
    if(shuffle(i) <= tr)
        trg(a+1, :) = file(i, :);
        a = a + 1;
    else
        tst(b+1, :) = file(i, :);
        b = b + 1;
    end
end

for i = 1:b
    d = zeros(a, 2);
    for j = 1:a
        sum = 0;
        d(j,1)=trg(j,1);
        for h=2:n_sample(2)
            sum = sum + (abs(tst(i,h) - trg(j,h)))^p;
        end
        d(j,2)=sum^1/p;
    end
    class=zeros(1,c);
    d = sortrows(d,2);
    for j=1:k
        class(d(j,1)) = class(d(j,1)) + 1/d(j,2);
    end
    [max_val index]=max(class);
    if(tst(i,1) == index)
        accuracy = accuracy + 1;
    end
end
accuracy = accuracy/b;
end
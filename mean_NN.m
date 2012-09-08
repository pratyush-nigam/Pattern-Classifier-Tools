function [accuracy] = k_NN(filename, k, p, training_percentage)
file = dlmread(filename);
n_sample = size(file);
c = 0;

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
        class(d(j,1)) = class(d(j,1)) + 1;
    end
    [max_val index]=max(class);
    if(tst(i,1) == index)
        accuracy = accuracy + 1;
    end
end
accuracy = accuracy/b;
end



mean=zeros(c,sz(2));
count=zeros(c,1);
for i=1:a-1
    count(trg(i))=count(trg(i))+1;
    for j=2:sz(2)
        mean(trg(i,1),j)=mean(trg(i,1),j)+trg(i,j);
    end
end
for i=1:c
    mean(i,1)=i;
    for j=2:sz(2)
        mean(i,j)=mean(i,j)./count(i);
    end
end
acc=0;
for i=1:b-1
    dist=zeros(c,2);
    for l=1:c
        dist(l,1)=mean(l,1);
        y=0;
        for m=2:sz(2)
            y=y+(abs(tst1(i,m)-mean(l,m)))^p;
        end
        dist(l,2)=y^1/p;
    end
    dist=sortrows(dist,2);
    if(dist(1,1)==tst1(i,1))
        acc=acc+1;
    end
end

load ORLfacedata;
%extract images for subjects 1 & 30
X = data([1:10, 301:310], :);
Y = labels([1:10, 301:310]);
Xtr = zeros(6, 1024);
Xte = zeros(14, 1024);
Ytr = zeros(6);
Yte = zeros(14);
avr_tr = zeros(6, 1);
avr_te = zeros(6, 1);
accuracy_tr = zeros(50, 1);
accuracy_te = zeros(50, 1);
k = [1, 2, 3, 4, 5, 6];
for p = 1: 6    
for i = 1: 50
    %training set containing 3*2 examples
    [Xtr, Xte, Ytr, Yte] = PartitionData(X, Y, 3);
    predict_te = zeros(14,1);
    predict_tr = zeros(6, 1);
    c_tr = 0;
    c_te = 0;
    for j = 1: 14
        predict_te(j) = knearest(k(p), Xte(j, :), Xtr, Ytr);
        if predict_te(j) == Yte(j)
            c_te = c_te + 1;
        end
    end
    for j = 1: 6
        predict_tr(j) = knearest(k(p), Xtr(j, :), Xtr, Ytr);
        if predict_tr(j) == Ytr(j)
            c_tr = c_tr + 1;
        end
    end
    %figure(1); ShowResult(Xte, Yte, predict_te, 4);
    %figure(2); ShowResult(Xtr, Ytr, predict_tr, 4);
    %fprintf('Dataset No. %i: \n', i)
    accuracy_tr(i) = c_tr / 6.0;
    accuracy_te(i) = c_te / 14.0;
    avr_tr(p) = avr_tr(p) + accuracy_tr(i);
    avr_te(p) = avr_te(p) + accuracy_te(i);
end
avr_tr(p) = avr_tr(p) / 50.0;
avr_te(p) = avr_te(p) / 50.0;
fprintf('k = %i, average training accuracy = %f\n', k(p), avr_tr(p))
fprintf('k = %i, average testing accuracy = %f\n', k(p), avr_te(p))
end

figure(1);
x = k;
y = avr_tr;
err = std(avr_tr)*ones(size(y));
errorbar(x, y, err)
xlabel('x: hyperparameter k');
ylabel('y: training accuracy');

figure(2);
x = k;
y = avr_te;
err = std(avr_te)*ones(size(y));
errorbar(x, y, err)
xlabel('x: hyperparameter k');
ylabel('y: testing accuracy');

function [] = Q2f(nEpochs, eta, minibatch, dropout0, dropout1, dropout2)

% number of epochs for training
%nEpochs = 5000;

% learning rate
%eta = 0.01;

% number of hidden layer units
H1 = 512;
H2 = 64;
K = 1;
%minibatch = 64;
%dropout1 = 0.35;
%dropout2 = 0.25;

File = ['steering/data.txt'];
X = fopen(File, 'r');
C = textscan(X, '%c%c%s%f');
fully = C{4};
imname = C{3};
I = size(imname,1);
c = 0.8;
T = round(c*I);
V = round((1-c)*I);
trname = imname(1:T,:);
trname = char(trname);
valname = imname(T+1:T+V,:);
valname = char(valname);

ytrain = fully(1:T,:);
yval = fully(T+1:T+V,:);

% im = imread('steering/img_1.jpg');
% im = rgb2gray(im);
% im = im(:);

s = 'steering/';
% s1 = strcat(s,trname(1,:));
%     im = imread(strcat(s,trname(1,:)));

for i=1:T
    s1 = strcat(s,trname(i,:));
    im = imread(s1);
    im = rgb2gray(im);
    im = im(:);
    im = im';
    if i==1
        X = im;
    else
        X = [X ; im];
    end
end

for i=T+1:T+V
    s1 = strcat(s,valname(i-T,:));
    im = imread(s1);
    im = rgb2gray(im);
    im = im(:);
    im = im';
    if i==T+1
        XV = im;
    else
        XV = [XV ; im];
    end
end

X = double(X);
X=(X- meshgrid(mean(X),1:size(X,1)))./meshgrid(std(X),1:size(X,1));

XV = double(XV);
XV=(XV- meshgrid(mean(XV),1:size(XV,1)))./meshgrid(std(XV),1:size(XV,1));

D = size(X,2);

w1 = -0.01+(0.02)*rand(H1,D);
w1=[zeros(H1,1) w1];

w2 = -0.01+(0.02)*rand(H2,H1);
w2=[zeros(H2,1) w2];

w3 = -0.01+(0.02)*rand(K,H2);
w3=[zeros(K,1) w3];

rnd = randperm(size(X,1));

X = X(rnd,:);
Y = ytrain;
Y = Y(rnd,:);

X = [ones(size(X,1),1) X];

XV = [ones(size(XV,1),1) XV];
YV = yval;

for epoch = 1:nEpochs
    drop0 = randperm(D , round(dropout0*D));
    drop1 = randperm(H1 , round(dropout1*H1));
    drop2 = randperm(H2 , round(dropout2*H2));
    for n=1:minibatch:size(X,1)
        
        if n+minibatch < size(X,1)
            X1 = X(n:n+minibatch,:); 
            Y1 = Y(n:n+minibatch,:);
        else
            X1 = X(n:size(X,1),:);
            Y1 = Y(n:size(X,1),:);
        end
        
        if dropout0 ~= 0
            X1(:,drop0)=0;
        end
        
        inp = double(X1) * double(w1'); 
        z1 = defsigmoid(inp);
      
        z1 = [ones(size(z1,1),1) z1];
        if dropout1~=0
            z1(:,drop1)=0;
        end
        
        inp = double(z1) * double(w2');
        z2 = defsigmoid(inp);
        z2 = [ones(size(z2,1),1) z2];
        if dropout2~=0
            z2(:,drop2)=0;
        end
        
        ydash = double(z2) * double(w3');
        
       % Backward Pass
       
       delz3 = ydash - Y1;
       
       delz2 = ((delz3*w3).*z2).*(1-z2);
       delz2 = delz2(:,2:size(delz2,2));
       
       delz1 = ((delz2*w2).*z1).*(1-z1);
       delz1 = delz1(:,2:size(delz1,2));
       
       w3 = w3 - (eta/minibatch)* delz3' * z2;
       
       w2 = w2 - (eta/minibatch)* delz2' * z1;
       
       w1 = w1 - (eta/minibatch)* delz1' * double(X1);
       
            
    end
    
    % dhara 180 in CoI  
    ydash = l3test(X, w1, w2, w3);
    
    trainerror(epoch) = 0.5 * sum( (Y -   ydash).^2);
    trainerror(epoch) = trainerror(epoch)/T;
    
    disp(sprintf('training error after epoch %d: %f\n',epoch,...
         trainerror(epoch)));
     
     ydashval = l3test(XV, w1, w2, w3);
     
     validationerror(epoch) = 0.5 * sum( (YV -   ydashval).^2);
     validationerror(epoch) = validationerror(epoch)/V;
     
     disp(sprintf('validation error after epoch %d: %f\n',epoch,...
         validationerror(epoch)));
    
end

figure; plot(1:nEpochs, trainerror, 1:nEpochs, validationerror);

save('savew1.mat','w1');
save('savew2.mat','w2');
save('savew3.mat','w3');


end
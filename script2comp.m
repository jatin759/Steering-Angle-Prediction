nEpochs = 1830;
eta = 0.005;
minibatch = 64;
dropout0 = 0;
dropout1 = 0;
dropout2 = 0;
d3 = 0;
Q2fcomp(nEpochs, eta, minibatch, dropout0, dropout1, dropout2);

File = ['l3-test/test-data.txt'];
X = fopen(File, 'r');
C = textscan(X, '%c%c%s');

imname = C{3};
imname = char(imname);
I = size(imname,1);

s = 'l3-test/';

for i=1:I
    s1 = strcat(s,imname(i,:));
    im = imread(s1);
    im = rgb2gray(im);
    h=fspecial('average');
    im=imfilter(im,h);
    im = im(:);
    im = im';
    if i==1
        X = im;
    else
        X = [X ; im];
    end
end


X = double(X);
X=(X- meshgrid(mean(X),1:size(X,1)))./meshgrid(std(X),1:size(X,1));
D = size(X,2);

X = [ones(size(X,1),1) X];

example = matfile('savew1.mat');
w1 = example.w1;

example = matfile('savew2.mat');
w2 = example.w2;

example = matfile('savew3.mat');
w3 = example.w3;

% example = matfile('savew4.mat');
% w4 = example.w4;


ydash = l3test(X, w1, w2, w3);
save('ydash.mat','ydash');
example = matfile('ydash.mat');
ydash = example.ydash;

nEpochs = 1000;
H = 2;
[trainerror] = l31(H);
figure
plot(1:nEpochs, trainerror, 'color' , 'y')
hold on

[trainerror] = l31(4);
plot(1:nEpochs, trainerror, 'color' , 'g')
hold on

[trainerror] = l31(8);
plot(1:nEpochs, trainerror, 'color' , 'b')
hold on

[trainerror] = l31(16);
plot(1:nEpochs, trainerror, 'color' , 'r')
hold on

[trainerror] = l31(32);
plot(1:nEpochs, trainerror, 'color' , 'm')
hold on

[trainerror] = l31(64);
plot(1:nEpochs, trainerror, 'color' , 'c')

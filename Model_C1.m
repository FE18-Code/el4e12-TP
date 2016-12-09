%Name, Date, Version
%Description

%Model_C1.m

clear all, close all, clc,
A=[0 1;5 -4]
B=[0;1]
C=[1 0]
D=0

%Simulink variables
Nbar=1
Step_final=4

%system: poles
poles=eig(A)

%step
figure(1)
system=ss(A, B, C, D);
[y, x, t]=step(system);
plot(t, x), grid
title('reaction to a step for this system')

%system to transfer fct
tf(system)
[num, den]=ss2tf(A, B, C, D)
roots(den)

%commandability
Com=ctrb(system) %[B AB A2B]
rankC=rank(Com)

%controllability
%Ctrl=(rankC==length(Com))

%state feedback : set up poles
Pcom=[-1 -5]
display('state feedback poles (continous)')
K=place(A, B, Pcom) %see also : fct acker()

%Discrete
Tech=0.1
[Ad, Bd, Cd, Dd]=c2dm(A, B, C, D, Tech, 'zoh'); %continous to discrete conv

%state feedback : set up poles (discrete)
Pcom_discrete=[0.5 0.5]
display('state feedback poles (discrete)')
Kd=acker(Ad, Bd, Pcom_discrete)

%input scaling; unit loop gain (when established)
%N=inv([A, B;C, D])*[zeros([1, size(A, 1)]) 1];
%Nx=N(1:size(A, 1));
%Nu=N(1+size(A, 1));
%Nnorm=Nu+Kd*Nx;

%start Simulink model
sim('model_statex')
sim('model_statex_discrete')

%display (continous)
figure(2)
subplot(211)
plot(time, input), grid
axis([0 max(time) -0.1 1.5])
title('command signal (continous)')
subplot(212)
%hold on
plot(time, states), grid
axis([0 max(time) -1 1.5])
xlabel('time')
title('output signal (continous)')

%display (discrete)
figure(3)
subplot(211)
plot(time_discrete, input_discrete), grid
axis([0 max(time_discrete) -0.1 1.5])
title('command signal (discrete)')
subplot(212)
%hold on
plot(time_discrete, states_discrete), grid
axis([0 max(time_discrete) -1 1.5])
xlabel('time')
title('output signal (discrete)')

%Name, Date, Version
%Description

%Model_C1.m

clear all, close all, clc,

%Model variables
Mchar=900; %Mchar=900 kg
Mbal=500; %Mbal=500 kg
Len=10; %Len=10 m
g=9.81; %g=9.81 m/s^2
Gs=100; %Gs=100 N/V
tau=1; %tau=1 s

A=[0 1 0 0 0;0 0 ((Mbal/Mchar)*g) 0 (1/Mchar);0 0 0 1 0;0 0 -((1+Mbal/Mchar)*(g/Len)) 0 -(1/Mchar*Len);0 0 0 0 -(1/tau)]
B=[0;0;0;0;Gs/tau]
C=[1 0 Len 0 0]
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
Pcom=[-1 -1 -1 -0.15+0.15*i -0.15-0.15*i]
display('state feedback poles')
K=acker(A, B, Pcom) %see also : fct acker()

%input scaling; unit loop gain (when established)
%N=inv([A, B;C, D])*[zeros([1, size(A, 1)]) 1];
%Nx=N(1:size(A, 1));
%Nu=N(1+size(A, 1));
%Nnorm=Nu+Kd*Nx;

%start Simulink model
sim('model_statex')

%display
figure(2)
subplot(211)
plot(time, input), grid
axis([0 max(time) -0.1 1.5])
title('command signal')
subplot(212)
%hold on
plot(time, states), grid
axis([0 max(time) -1 1.5])
xlabel('time')
title('output signal')

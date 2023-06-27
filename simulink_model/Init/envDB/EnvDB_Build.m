clear all
clc

% Get the variable from Excel, and build vector Osim and Asim
envDB.g = 9.81; % m/s^2
envDB.RE = 6378137; % m
envDB.R = 287.05287; % KJ/(Kg*K)
envDB.T0 = 288.15; % K
envDB.P0 = 101325; % N/m^2
save envDB.mat
%syms al be p q r et xi zet etk ets
%AeroVar = [al be p q r et xi zet etk ets];
%AeroVar = ones(1,10);

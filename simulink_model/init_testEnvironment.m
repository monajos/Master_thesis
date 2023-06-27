clear all
close all


% add path for initialization
addpath(genpath(pwd))

% initialize
modelInit('myInitData.mat')

% open model
open("testEnvironment.slx")


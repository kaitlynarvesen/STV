clc; clear; close all; format long;

file='results.csv'; %put name of your .csv or .xlsx file here
seats=2; %put number of people to be elected here
winners=STV(file, seats);
% clear the command window
clc

% Read in the data for the FIS
filename = ('C:\Users\emily\Desktop\Fuzzy Logic Coursework\DiagnosisInput.xlsx');
filename = ('DiagnosisInput.xlsx');
testData = xlsread('DiagnosisInput.xlsx');

% Declare a new FIS
diabetes = newfis('Diagnosis');

% Input variable: Fasting Glucose Level (mg/dl)
diabetes = addvar(diabetes, 'input', 'Glucose', [0 150]);
diabetes = addmf(diabetes, 'input', 1, 'Low', 'trapmf', [0 0 60 65]);
diabetes = addmf(diabetes, 'input', 1, 'Normal', 'trapmf', [60 65 95 100]);
diabetes = addmf(diabetes, 'input', 1, 'High', 'trapmf', [95 100 120 125]);
diabetes = addmf(diabetes, 'input', 1, 'Very High', 'trapmf', [120 125 150 150]);

% Input variable: Diastolic Blood Pressure(mmHg)
diabetes = addvar(diabetes, 'input', 'DBP', [0 120]);
diabetes = addmf(diabetes, 'input', 2, 'Normal', 'trapmf', [0 0 60 65]);
diabetes = addmf(diabetes, 'input', 2, 'Elevated', 'trapmf', [60 65 95 100]);
diabetes = addmf(diabetes, 'input', 2, 'Very High', 'trapmf', [95 100 120 120]);

% Input variable: Body Mass Index(kg/m^2)
diabetes = addvar(diabetes, 'input', 'BMI', [0 50]);
diabetes = addmf(diabetes, 'input', 3, 'Underweight', 'trapmf', [0 0 10 15]);
diabetes = addmf(diabetes, 'input', 3, 'Normal', 'gaussmf', [5 20]);
diabetes = addmf(diabetes, 'input', 3, 'Overweight', 'gaussmf', [5 30]);
diabetes = addmf(diabetes, 'input', 3, 'Obese', 'trapmf', [35 40 50 50]);

% Input variable: Age(Years)
diabetes = addvar(diabetes, 'input', 'Age', [0 110]);
diabetes = addmf(diabetes, 'input', 4, 'Young', 'gaussmf', [14 0]);
diabetes = addmf(diabetes, 'input', 4, 'Middle', 'gaussmf', [10 40]);
diabetes = addmf(diabetes, 'input', 4, 'Old', 'gaussmf', [10 70]);
diabetes = addmf(diabetes, 'input', 4, 'Very Old', 'gaussmf', [15 110]);


% Input variable: Likleyhood of Diabetes(Percentage %)
diabetes = addvar(diabetes, 'output', 'Likleyhood', [0 100]);
diabetes = addmf(diabetes, 'output', 1, 'Normal', 'trapmf', [0 0 20 30]);
diabetes = addmf(diabetes, 'output', 1, 'Prediabetic', 'trapmf', [25 30 55 60]);
diabetes = addmf(diabetes, 'output', 1, 'Diabetic', 'trapmf', [55 60 120 120]);

% Create rules for the FIS
% Lowest Weighting
rule1 = [4 0 0 0 3 0.05 2];
rule2 = [2 0 0 0 1 0.05 2];
rule3 = [1 0 0 0 3 0.05 2];
rule4 = [3 0 0 0 2 0.05 2];
rule5 = [4 3 0 0 3 0.2 2];
rule6 = [3 2 0 0 2 0.2 2];

% Normal Weighting
rule7 = [4 3 4 3 3 1 1];
rule8 = [4 3 3 3 3 1 1];
rule9 = [4 3 3 4 3 1 1];
rule10 = [3 3 3 3 2 1 1];
rule11 = [3 3 4 3 2 1 1];
rule12 = [2 2 2 2 1 1 1];
rule13 = [2 3 3 3 2 1 1];
rule14 = [2 1 2 2 1 1 1];
rule15 = [2 1 2 1 1 1 1];
rule16 = [1 3 3 3 3 1 1];
rule17 = [1 3 3 4 3 1 1];
rule18 = [1 3 1 1 3 1 1];
rule19 = [1 1 2 2 1 1 1];
rule20 = [1 1 2 3 1 1 1];
rule21 = [1 1 2 2 1 1 1];

% Pass the rules to an array
ruleList = [rule1; rule2; rule3; rule4;...
    rule5; rule6; rule7; rule8; rule9; rule10;... 
    rule11; rule12; rule13; rule14; rule15;...
    rule16; rule17; rule18; rule19; rule20; rule21];

% Add the rules to the FIS
diabetes = addRule(diabetes,ruleList);

% Print the rules to the workspace
rules = showrule(diabetes);

% Set the defuzzification method
diabetes.defuzzMethod = 'centroid';

for i=1:size(testData,1)
       eval = evalfis([testData(i, 1), testData(i, 2), testData(i, 3), testData(i, 4)], diabetes);
       fprintf('%d) In(1): %.2f, In(2) %.2f, In(3) %.2f In(4) %.2f => Out: %.2f \n\n',i,testData(i, 1),testData(i, 2),testData(i, 3),testData(i, 4), eval);  
end

%Plot the the membership functions for the inputs
figure(1)
subplot(5,1,1), plotmf(diabetes,'input',1);
subplot(5,1,2), plotmf(diabetes,'input',2);
subplot(5,1,3), plotmf(diabetes,'input',3);
subplot(5,1,4), plotmf(diabetes,'input',4);

%Plot the the membership functions for the output
subplot(5,1,5), plotmf(diabetes,'output',1);


getfis(diabetes);

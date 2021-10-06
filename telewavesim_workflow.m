% Telewavesim Workflow
% Author: Evan Zhang
%
% Input: (1) layered structure,
%        (2) ray parameters,
%        (3) other parameters.
%
% Output: MatLab structure, containing
%            (1) synthetic RF traces,
%            (2) time vector,
%            (3) bin vector (epicentral distances);
%         Synthetic RF plot with predicted arrival times.

%% Parameters Setup

% directory

localBaseDir = '/scratch/tolugboj_lab/';
workDir = [localBaseDir 'Prj4_Nomelt/seus_test/evan/'];
modelDir = [workDir 'model/'];
sacDir = [workDir 'sac/'];
matDir = [workDir 'matfile/'];

% volocity model

modname = 'shi';

Dz = [20 15 175 200 0];
rho = [2720 2920 3390 3500 3970];
Vp = [5.8 6.5 8.17 8.72 9.83];
Vs = [3.46 3.85 4.51 4.72 5.37];
Vperc = [0.0 0.0 0.0 0.0 0.0];
Trend = [0.0 0.0 0.0 0.0 0.0];
Plunge = [0.0 0.0 0.0 0.0 0.0];

% ray parameter

rayp_file = 'linspace.txt';
rayp_file_full = [workDir 'rayP/' rayp_file];

% options

DelSac = 0;
npts = 10000; % Number of data points in RFs. Sample rate is 0.02.
loco = 0.01;
hico = 2.00;

%% Make Velocity Model File
% This section generates velocity model file based on your input strucrure.

genRFsyn(Dz, rho, Vp, Vs, Vperc, Trend, Plunge, modelDir, modname);

%% Run Telewavesim Python Program
% This section calls a bash script to run the Telewavesim program.

telewavesim_cmd = ['bash ./job_Telewavesim.sh' ' ' workDir ' ' modname ' ' ...
    rayp_file ' ' num2str(npts) ' ' num2str(loco) ' ' num2str(hico)];
system(telewavesim_cmd);

%% Wrap Output SAC Files into MatLab Structure
% This section reads the output files of Telewavesim program and wrap them
% into a MatLab structure for further analysis.

slow = load(rayp_file_full);
[garc, ~] = raypToEpiDist(slow, 0, 1, localBaseDir);

sac2strucwrap(sacDir, matDir , modname, garc);

if DelSac
    DelCmd = strcat('rm -f ',sacDir,'*sac');
end

%% Plot Synthetic RFs with predicted arrival times

RFWigglePlot_SYN(localBaseDir,workDir,modname,Dz,Vp,Vs);
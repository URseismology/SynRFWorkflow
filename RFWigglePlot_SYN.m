function RFWigglePlot_SYN(localBaseDir,workdir, modname, H, Vp, Vs)

% Authors: Tolulope Olugboji, Liam Moser, Evan Zhang
% Plotting RF as traces, assist in visualizing data quality and selected
% arrival times.

%% Prepping values to be plotted from RF

SED = 0;

tWin = [1 50];
epiDistRange = [30 95];

% RF variables
RFmat = load(strcat(workdir,'matfile/',modname,'_syn.mat'));

R = RFmat.rRF;
t = RFmat.time; y = RFmat.garc; nY = length(y);
[epiDist, rayP] = raypToEpiDist(y, 1, 1, localBaseDir);

% sediment filter
figtitle = ['Synthetic RF:' modname];
if SED
    R = filterRF(R,t,rayP);
    figtitle = 'PLUME filtered';
end

tStart = tWin(1); tEnd = tWin(2);

%Time window to smooth over where location conversion and reverberation
it = find(t>tStart, 1); %Removing negative time
endt = find(t>tEnd, 1);

% Summary stack
RR = R(:,it:endt);
sumR = sum(RR,  1);

% calculate arrival times
[tPs_1, tPps_1, tPss_1] = travelTimesAppx(Vp, Vs, H, rayP, 1);
[tPs_2, tPps_2, tPss_2] = travelTimesAppx(Vp, Vs, H, rayP, 2);

%% Plot pure RF traces with out weighting

h1 = figure(1);
clf;

set(gcf,'position',[50,50,1000,1000]);

subplot(5,3,1:15);
hold on;

tshft = 0;
mm = max(abs(R(:,it:endt)), [] ,'all');

for iY = 1:nY
    
    Rn = R(iY,it:endt) ./ mm;
    Tn = t(it:endt); sizeT = length(Tn);
    
    yLev = (nY-iY);
    yVec = repmat(yLev, 1, sizeT);
    
    jbfill(Tn, max(Rn+yLev, yLev), yVec, [0 0 1],'k', 1, 1.0);
    jbfill(Tn, min(Rn+yLev, yLev), yVec, [1 0 0],'k', 1, 1.0);
    
end

% Plotting optimized arrival times
hold on;
p1 = plot(tPs_1, nY-1:-1:0,  '-k', 'LineWidth', 1);
p2 = plot(tPps_1, nY-1:-1:0, '-k', 'LineWidth', 1); % tPps_H
p3 = plot(tPss_1, nY-1:-1:0, '-k', 'LineWidth', 1); % tPss_H
p4 = plot(tPs_2, nY-1:-1:0, '-r', 'LineWidth', 1);
p5 = plot(tPps_2, nY-1:-1:0, '-r', 'LineWidth', 1);
p6 = plot(tPss_2, nY-1:-1:0, '-r', 'LineWidth', 1);

% Plotting axis
yticks([0:5:nY]);
set(gca,'yticklabel', floor(linspace(epiDistRange(1),epiDistRange(2),(nY/5)+1)))
% set(gca,'xticklabel', '')
xlim([0 tEnd])
ylim([-1 nY+1])
%xlabel('Time (s)','FontSize', 24)
ylabel('Epicentral distance (deg)','FontSize', 20)

title([figtitle] ,'FontSize', 24)
grid on

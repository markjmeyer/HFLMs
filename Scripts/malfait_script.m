%%%%%%%%%%%%%%%%%% Malfait & Ramsay (2003) Sample Script %%%%%%%%%%%%%%%%%%
% Simulated data example for Meyer (2023)                                 %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% add paths %%
addpath('~/Code/fdaM')  % requires Malfait & Ramsay fdaM MATLAB toolbox

%% load data %%
% cd('./Data')
Xl  = readmatrix('X_l.txt');
Yl  = readmatrix('X_l.txt');

%%
T   = size(Xl,2);

%% MR model set up %%
ts          = (T-1);
timevec     = linspace(0,ts,T);
tfine       = (0:0.0025:ts)';
nfine       = length(tfine);

%% convert to func data objs %%
ymatlag   = zeros(nfine, N);
xmatlag   = zeros(nfine, N);

for i=1:N
    ytemp = interp1(timevec,Yl(i,:),tfine);
    xtemp = interp1(timevec,Xl(i,:),tfine);
    ymatlag(:,i) = ytemp;
    xmatlag(:,i) = xtemp;
end

tfine = tfine(1:nfine);

nbasis = 93;
norder =  6;
basis  = create_bspline_basis([0,ts], nbasis, norder);

yfd = data2fd(ymatlag, tfine, basis);
xfd = data2fd(xmatlag, tfine, basis);

yfd0 = center(yfd);
xfd0 = center(xfd);

%% define finite element basis %%
M = 13; % as suggested in Malfait & Ramsay (2003)
lambda = ts/M;    
B = M;
eleNodes = NodeIndexation(M, B);
[Si, Ti] = ParalleloGrid(M, ts, B);

%% estimating the regression function %%
npts  = 4; %4
ntpts = M*npts;
delta = lambda/(2*npts);
tpts  = linspace(delta, ts-delta, M*npts)';

psiMat  = DesignMatrixFD(xfd0, npts, M, eleNodes, Si, Ti, B);

singvals  = svd(full(psiMat));
condition = max(singvals)/min(singvals);
%     disp(['Condition number = ',num2str(condition)])

yMat  = eval_fd(yfd0,tpts)';
yVect = reshape(yMat, N*M*npts, 1);

bHatc = psiMat\yVect;

%% estimated surface
figure1 = figure; axes1 = axes('Parent',figure1);
trisurf(eleNodes, Si, Ti, bHatc,'FaceColor','interp','EdgeColor','none')
xlabel('\fontsize{14} v');
ylabel('\fontsize{14} t');
title('\fontsize{16} Malfait & Ramsay (2003)')
view(axes1,[0, 90]);
xlim([1 T-1]); ylim([1 T-1]);
grid(axes1,'on');
set(axes1,'FontSize',14);
colorbar(axes1,'Ticks',[0 0.5 1 1.5 2],'FontSize',14);



%%%%%%%%%%%%%%% Meyer, Malloy, & Coull (2021) Sample Script %%%%%%%%%%%%%%%
% Simulated data example for Meyer (2023)                                 %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% add paths %%
addpath('~/Code');

%% load data %%
% cd('./Data')
Xl  = readmatrix('X_l.txt');
Yl  = readmatrix('X_l.txt');
N   = size(Yl,1);

%% model specs %%
model.alf           = 0.05; % global alpha
model.delt          = 0.05; % threshold for Bayesian FDR
model.wpKeep        = 0.25; % keep wpKeep percent of x-space wavelet packets

%% specs for packets %%
wpspecs.wavelet     = 'db3';
wpspecs.wtmode      = 'zpd';
wpspecs.nlevels     = 3;

%% MCMCspecs %%
MCMCspecs.B                 = 1000;
MCMCspecs.burnin            = 1000;
MCMCspecs.thin              = 1;

postout = wphflm(Y, X, model, wpspecs, MCMCspecs);

%% estimated surface
figure1 = figure; axes1 = axes('Parent',figure1); hold(axes1,'on');
surf(postout.bmath','FaceColor','interp','EdgeColor','none'); xlim([1 T]); ylim([1 T]); view(0, 90);
colorbar(axes1,'Ticks',[0 0.5 1 1.5 2],'FontSize',14);
set(axes1,'FontSize',14,'XGrid','on','YGrid','on');
xlabel('v','FontSize',14);
ylabel('t','FontSize',14);
title({'Meyer, Malloy, & Coull (2021)'});

%% simba scores
figure1 = figure; axes1 = axes('Parent',figure1); hold(axes1,'on');
surf(postout.sbs','FaceColor','interp','EdgeColor','none'); xlim([1 T]); ylim([1 T]); view(0, 90); colorbar
colormap(copper)
caxis([0 0.5])
set(axes1,'FontSize',14,'XGrid','on','YGrid','on');
xlabel('v','FontSize',14)
ylabel('t','FontSize',14);
title({'SimBa Scores'});

%% significant coef
figure1 = figure; axes1 = axes('Parent',figure1); hold(axes1,'on');
surf(postout.sbsf','EdgeColor','none'); xlim([1 T]); ylim([1 T]); view(0, 90); colorbar
colormap(copper)
caxis([0 1])
set(axes1,'FontSize',14,'XGrid','on','YGrid','on');
xlabel('v','FontSize',14);
ylabel('t','FontSize',14);
title({'Significant Coefficients'});

%% joint lower
figure1 = figure; axes1 = axes('Parent',figure1); hold(axes1,'on');
surf(postout.sbsl','FaceColor','interp','EdgeColor','none'); xlim([1 T]); ylim([1 T]); view(0, 90); colorbar
set(axes1,'FontSize',14,'XGrid','on','YGrid','on');
xlabel('v','FontSize',14);
ylabel('t','FontSize',14);
title({'Joint Interval, Lower Bound'});

%% joint upper
figure1 = figure; axes1 = axes('Parent',figure1); hold(axes1,'on');
surf(postout.sbsu','FaceColor','interp','EdgeColor','none'); xlim([1 T]); ylim([1 T]); view(0, 90); colorbar
set(axes1,'FontSize',14,'XGrid','on','YGrid','on');
xlabel('v','FontSize',14);
ylabel('t','FontSize',14);
title({'Joint Interval, Upper Bound'});



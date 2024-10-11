%%%%%%%%%%%%%%% Simulated Data Generation for Illustrations %%%%%%%%%%%%%%%
% Simulated data example for Meyer (2023)                                 %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% set number of grid points %%
T       = 2^6; % 2^7
N       = 50;

%% grid for simulation surfaces %%
sDens   = 1; % 1 (64), 0.5 (128)
[v, t]  = meshgrid(0:sDens:(T-sDens));

%% scale to control STNR %%
stnrs   = 83/331; %166/662;
b1var   = 0.005;
b1      = 0.65*stnrs*(1/(sqrt(2*pi*b1var)))*exp(-1/(2*b1var)*(t./T-v./T-0.75).^2) + stnrs*(1/(sqrt(2*pi*b1var)))*exp(-1/(2*b1var)*(t./T-v./T-0.25).^2);
b1      = b1';

%% constrain true surface %%
bh1  = zeros(size(b1));
% bh1  = nan(size(b1)); % for plotting
for i = 1:size(b1,1)
    for j = i:size(b1,2)
        bh1(i,j) = b1(i,j);
    end
end


%% graphics %%
figure1 = figure; axes1 = axes('Parent',figure1); hold(axes1,'on');
surf(bh1','FaceColor','interp','EdgeColor','none'); xlim([1 T]); ylim([1 T]); view(0, 90); colorbar
set(axes1,'FontSize',14,'XGrid','on','YGrid','on');
xlabel('v','FontSize',14);
ylabel('t','FontSize',14);
title({'\beta(v,t)'});

%%

%% scale to control STNR %%
b2  = zeros(size(b1));
% cumulative %
for i = 1:size(b1,2)
%     b2(i,:) = 2*(1-(size(b1,2)-i)/T)*b1(i,:);
    b2(i,:) = 2*(1-(T-i)/T)*b1(i,:);
end

%% constrain true surface %%
bh2      = zeros(size(b2));
% bh2      = nan(size(b2));
for i = 1:size(b2,1)
    for j = i:size(b2,2)
        bh2(i,j) = b2(i,j);
    end
end

%% graphics %%
figure1 = figure; axes1 = axes('Parent',figure1); hold(axes1,'on');
surf(bh2','FaceColor','interp','EdgeColor','none'); xlim([1 T]); ylim([1 T]); view(0, 90); colorbar
set(axes1,'FontSize',14,'XGrid','on','YGrid','on');
xlabel('v','FontSize',14);
ylabel('t','FontSize',14);
title({'\beta(v,t)'});

%% select surface to generate %%
bh = bh1;
% bh = bh2;

%% redefine T %%
T           = size(bh,1);

%% generate ar(1) covariance pattern %%
ar1Corr     = eye(T);
sigma       = 3.5; %1.364658;   % get from Journeyman data
rho         = 0.75; %0.7433461;   % get from Journeyman data
for i = 1:T
    for j = (i+1):T
        ar1Corr(i,j) = rho^(j-i);
        ar1Corr(j,i) = rho^(j-i);
    end
end

ar1Cov      = sigma*ar1Corr;

%% set seed %%
rng(730);

%% generate x(v) based on AR(1) estimated cov %%
simX        = NaN(N,T);
muX         = zeros(T,1);
for i = 1:N
    simX(i,:)   = mvnrnd(muX,ar1Cov);
end

%% Generate Covariance structure for E ~ GP(0, Sigma_E)
CovStr      = eye(T);
sigmae      = 0.1; % 0.3338735, 0.1
rho         = 0.5; % 0.7836909, 0.5
for i = 1:T
    for j = (i+1):T
        CovStr(i,j) = rho^(j-i);
        CovStr(j,i) = rho^(j-i);
    end
end

Sigma_E     = sigmae*CovStr;

%% Use Sigma_E to generate matrix of model errors %%
E           = zeros(N,T);
muE         = zeros(T,1);
for i = 1:N
    E(i,:)  = mvnrnd(muE,Sigma_E);
end

%% construct and decompose Y(t) %%
Y                   = simX*bh + E;

%% export lag data
writematrix(Y, 'Y_l.txt', 'Delimiter','tab')
writematrix(simX, 'X_l.txt', 'Delimiter','tab')
writematrix(bh, 'bh_l.txt', 'Delimiter','tab')

%% export lag data
writematrix(Y, 'Y_c.txt', 'Delimiter','tab')
writematrix(simX, 'X_c.txt', 'Delimiter','tab')
writematrix(bh, 'bh_c.txt', 'Delimiter','tab')

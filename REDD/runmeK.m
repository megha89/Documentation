% Replicate the demo in Section 4 of GCNU TR 2000-004 "Training Products of
% Experts by Minimizing Contrastive Divergence", Geoffrey E. Hinton.
% Iain Murray, July 2004, March 2006

% This version fits using CD_1 and then refines using more and more steps from
% the data. Another thing to try would be to fit with CD and then let the
% fantasy wander around (which didn't seem to work in general, and I suspect
% would lead to similar problems even after CD as it did kinda fit before)
%
% Seems expert positions don't move much. Main thing seems to be that mixing
% fractions get fixed up so that long-term fantasy represents modes better.
% Maybe just hacking learning rates with CD1 would fix this (as Geoff seemd to
% have it working better with CD1). Geoff's frequently sampled points at
% non-existant mode and I thought going to larger K would tend to stop this
% happening more often. But maybe not actually. Not that much of a penalty, and
% once experts in place intermediate states would cost a lot while moving stuff
% around again.

rand('state',0);
randn('state',0);

more 'off'

% Figure1-like data set
D=2;   % number of dimensions
N=300; % number of data points
K=15;  % number of unigauss experts
data=(ceil(rand(D,N)*5)+randn(D,N)*0.04)/6; % DxN training data
% censor one of the grid points:
idx=find(~((abs(data(1,:)-1/3)<0.1)&(abs(data(2,:)-0.5)<0.1)));
data=data(:,idx);
N=size(data,2);

% uniform prior, into which one can absorb bias regularization, is over the unit square.
area=1;

% Step-size for naivish stochastic steepest-descent learning
epsilon=1/N;

% Initialise everything else
mix=repmat(0.5,1,K); % 1xK mixing proportions
LTmix=log(mix./(1-mix)); % logit basis
prec=1./repmat(mean(diag(cov(data'))),D,K); % DxK precisions
Lprec=log(prec);
mu=randn(D,K)./sqrt(prec)+repmat(0.5,D,K); % DxK means
Lprec_old=Lprec; mu_old=mu; LTmix_old=LTmix;


[pgauss,dLTmix0,dmu0,dLprec0]=ug_grad(LTmix,mu,Lprec,area,data);
fantasy=sample_hidden(pgauss,mu,prec);
plotstuff(data,fantasy,mu,prec);
waitforbuttonpress

for CDK=[1,5,10,20,50,100]
	terminatenow=0;
	maxstep=0;
	iter=0;
	while ~terminatenow
		iter=iter+1;
		fprintf('CDK=%d  Iteration %d   maxstep=%g       \r',CDK,iter,maxstep);
		
		% Compute first term of gradient
		[pgauss,dLTmix0,dmu0,dLprec0]=ug_grad(LTmix,mu,Lprec,area,data);
		
		% Second term from fantasy
		fantasy=sample_hidden(pgauss,mu,prec);
		for cdk=1:(CDK-1)
			pgauss=ug_grad(LTmix,mu,Lprec,area,fantasy);
			fantasy=sample_hidden(pgauss,mu,prec);
		end
		[pgauss,dLTmix1,dmu1,dLprec1]=ug_grad(LTmix,mu,Lprec,area,fantasy);
		
		% Move along gradient
		deltaLTmix=epsilon*(dLTmix0-dLTmix1);
		LTmix=LTmix+deltaLTmix;
		%
		deltamu=epsilon*(dmu0-dmu1);
		deltamu=deltamu./prec; % pseudo-natural-gradient hack
		mu=mu+deltamu;
		%
		deltaLprec=epsilon*(dLprec0-dLprec1);
		deltaLprec=deltaLprec.*(1-((Lprec>10)&(deltaLprec>0))); % disallow huge precisions
		Lprec=Lprec+deltaLprec;
		prec=exp(Lprec);
	
		% Hacky termination rule
		if ~mod(iter,100)
			maxstep=max(abs([LTmix(:)-LTmix_old(:);mu(:)-mu_old(:);Lprec(:)-Lprec_old(:)]));
			if maxstep<.1
				terminatenow=1;
			end
			Lprec_old=Lprec; mu_old=mu; LTmix_old=LTmix;
		end
	
		% Visualise
		if terminatenow||(~mod(iter,30))
			plotstuff(data,fantasy,mu,prec);
		end
	end
	
	fprintf('\nNow doing extensive Gibbs sampling under fitted model\n');
	for i=1:iter % sample for as long as original fitting took
		fprintf('Iteration %d / %d        \r',i,iter);
		pgauss=ug_grad(LTmix,mu,Lprec,area,fantasy);
		fantasy=sample_hidden(pgauss,mu,prec);
	end
	fprintf('\nDone. Click to show final plot with original data, fantasy and expert ellipses\n');
	waitforbuttonpress
	plotstuff(data,fantasy,mu,prec);
	fprintf('\nClick to carry on training with more CD steps\n');
	waitforbuttonpress
end

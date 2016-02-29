function [pgauss,dLTmix,dmu,dLprec,p_k] = ug_grad(LTmix,mu,Lprec,area,data)
% function [pgauss,dLTmix,dmu,dLprec,p_k] = ug_grad(LTmix,mu,Lprec,area,data)
%
% unigauss product of experts model. Given current params and data return
% posterior over hiddens and gradient contributions averaged over data. Just ask
% for one output if only want posterior. During learning will run this asking for
% gradient contributions from data and fantasy data and look at difference. See
% Hinton 2000.
%
% Inputs:
% 	    LTmix 1xK Mixing component of each unigauss
% 	       mu DxK Means of Gaussian bits
% 	    Lprec DxK Log precisions of axis-aligned Gaussian bits
% 	     area 1x1 Area of uniform patch (bias regularizer)
% 	     data DxN 
%
% Outputs:
% 	   pgauss NxK Conditional prob of Gaussian given data
% 	   dLTmix 1xK Gradient wrt logit mixing proportions
% 	      dmu DxK (Hacked) gradient wrt means
% 	    dLvar DxK Gradient wrt log variances
% 	      p_k NxK Expert probs (for testing gradients)

% Iain Murray, March 2006

[D,K]=size(mu);
[D,N]=size(data);

% Precomputations
prec=exp(Lprec);
mix=1./(1+exp(-LTmix));
twopid=(2*pi)^D;
dataE=(data.*data)'*prec-... % NxK, bit inside exp(-0.5(.)) in Gaussians
      2*data'*(mu.*prec)+...
      repmat(sum(mu.*mu.*prec,1),N,1);
% NxK expert probs:
p_k=repmat(mix./sqrt(twopid*prod(1./prec,1)),N,1).*exp(-0.5*dataE)+repmat((1-mix)/area,N,1);
stuff=1-repmat((1-mix),N,1)./(area*p_k); % NxK

% Compute distribution over hidden variables
tmp=repmat(sqrt(twopid*prod(1./prec,1)).*(1-mix)./(area*mix),N,1).*exp(+0.5*dataE);
pgauss=1./(1+tmp);

if nargout>1
	% Logit mixing components
	dmix=(N-sum(1./(area*p_k),1))./mix;
	dLTmix=mix.*(1-mix).*dmix;
	
	% Gaussian means
	dmu=data*stuff-mu.*repmat(sum(stuff,1),D,1); % pseudo-natural gradient hack: omit prec
	dmu=prec.*dmu; % true gradient (so testme.m works), divide prec out again in learning code
	
	% Gaussian log-precisions
	repsumstuff=repmat(sum(stuff,1),D,1);
	dLprec=0.5*(repsumstuff-...
	            ((data.*data)*stuff-...
	            2*(data*stuff).*mu+...
	            repsumstuff.*mu.*mu).*prec);
end

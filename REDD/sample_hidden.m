function fantasy = sample_hidden(pgauss,mu,prec)
% function fantasy = sample_hidden(pgauss,mu,prec)
%
% Creates fantasy data for unigauss model given a distribution over hiddens.
% Assumes uniform dist is over unit hypercube if no experts are turned on.
%
% Inputs:
% 	  pgauss NxK probability of expert Gaussian being turned on
% 	      mu DxK experts' Gaussian means
% 	    prec DxK experts' Gaussian precisions
%
% Outputs:
% 	fantasy  DxN data drawn after one Gibbs step

% Iain Murray, March 2006

[N,K]=size(pgauss);
[D,K]=size(mu);

fantasy=zeros(D,N);
ks=rand(K,N)<pgauss';

% Need to treat two situations seperately.
% a) there are 0 Gaussians turned on in the experts:
idxU=find(sum(ks,1)==0);
fantasy(:,idxU)=rand(D,length(idxU));
% b) there are >=1 Gaussians turned on in the experts:
idxG=find(sum(ks,1)~=0);
fprec=prec*ks(:,idxG); % Dxlength(idxG)
fmu=((prec.*mu)*ks(:,idxG))./fprec; % Dxlength(idxG)
fantasy(:,idxG)=randn(D,length(idxG))./sqrt(fprec)+fmu;


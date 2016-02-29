function plotstuff(data,fantasy,mu,prec)
% function plotstuff(data,fantasy,mu,prec)
%
% Plot data, fantasy data and expert covariance ellipses for 2D unigauss demo.
%
% Inputs:
% 	     data DxN 
% 	  fantasy DxN 
% 	       mu DxK 
% 	     prec DxK 

% Iain Murray, March 2006

[D,K]=size(mu);

clf; hold on;
plot(data(1,:),data(2,:),'.r');
axis([0 1 0 1]);
axis('square');
for k=1:K
	plotaxisellipse(mu(:,k),sqrt(1./prec(:,k)));
end
plot(fantasy(1,:),fantasy(2,:),'.k')
drawnow


function plotaxisellipse(c,s)

% ultra-crude

res=30;
x=[-1:1/res:1];
y=[ones(size(x)),-ones(size(x))];
x=[x,x(end:-1:1)];
y=sign(y).*sqrt(1-x.^2);

x=x*s(1)+c(1);
y=y*s(2)+c(2);

plot(x,y,'-b');

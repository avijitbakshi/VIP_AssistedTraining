function h=hv(hv12,in,color,markertype,linewidth)
% exact horizonal or vertical line plotter
% hv12 => 1 h, 2 v
% in= which point
if nargin<3 color=mc('orange');end
% if nargin<3 color=mc('yellow');end

if nargin<4 markertype1='--';markertype2='-.';
else markertype1=markertype;markertype2=markertype;
end

if nargin<5 linewidth=1;end

figure(gcf);

for k=1:length(in)
    if hv12==1
    xl=get(gca,'xlim');
    h=plot(xl,[in(k) in(k)],markertype1,'color',color,'LineWidth',linewidth);
    elseif hv12==2
    yl=get(gca,'ylim');
    h=plot([in(k) in(k)],yl,markertype1,'color',color,'LineWidth',linewidth);
    end
end

    if nargin<3 set(h, 'LineWidth', 0.8);end

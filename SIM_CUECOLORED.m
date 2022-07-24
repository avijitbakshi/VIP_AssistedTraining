
clc;clear all;close all

%SET SIMULATION PARAMETERS
markertype='.';markersize=10;
thlm=60;vlm=120;
Tdur=15;
itermax=20;10;
fs=50;%Hz
% figposn=[0.0010    0.0322    1.2232    0.7504]*1000;
figposn=[0.0010    0.0322    1.9170    0.9618]*1000;


%SET PENDULUM PARAMETERS
parameters_pend.K_G=600;
parameters_pend.K_restoring=0;
parameters_pend.K_damp=0;



%SET JOYSTICK PARAMETERS
first_or_last=2;
load joymanifold_SUP.mat
load joytranstime_SUP.mat
%critgapconst = low for more continuous
% parameters_joy.prob_manifold_to_0_vs_stayonmanifold= 1 for more let go, 0 for no let go
critgapconst=0;parameters_joy.prob_manifold_to_0_vs_stayonmanifold=0;%Continuous
% critgapconst=.3;parameters_joy.prob_manifold_to_0_vs_stayonmanifold=0;%DisContinuous
critgapconst=.35;parameters_joy.prob_manifold_to_0_vs_stayonmanifold=1;%LET GO

% load joymanifold_UPR.mat
% load joytranstime_UPR.mat
% critgapconst=.1;parameters_joy.prob_manifold_to_0_vs_stayonmanifold=.3;

parameters_joy.joyDBmanifold=joymanifold.firstlast(first_or_last).manifold;
parameters_joy.djs=joytranstime.firstlast(first_or_last).dj;
parameters_joy.meandt=joytranstime.firstlast(first_or_last).meandt;
parameters_joy.stddt=joytranstime.firstlast(first_or_last).stddt;


parameters_joy.Joystick_Machine_Amp=19/(1/fs);
parameters_joy.sigmanoise=0.01;


common_sigma_to_manifold=1/20;
sigmamanifold13=common_sigma_to_manifold; sigmamanifold24=common_sigma_to_manifold;
parameters_joy.quad(1).sigma_joy_manifold=sigmamanifold13;parameters_joy.quad(3).sigma_joy_manifold=sigmamanifold13;
parameters_joy.quad(2).sigma_joy_manifold=sigmamanifold24;parameters_joy.quad(4).sigma_joy_manifold=sigmamanifold24;
parameters_joy.sigma_joy_0=1/40;

joystate.transition.movement_style='sigmoid';

 blu=[93 38 248]/255;VIP.HeadcolorOLD=blu;

%SET CRITICAL GAP PARAMETERS
common_sigma_critgap=1/20;
meancritgap13=critgapconst; meancritgap24=critgapconst;
parameters_joy.quad(1).critJoygapmean_frommanifold=meancritgap13;parameters_joy.quad(3).critJoygapmean_frommanifold=meancritgap13;
parameters_joy.quad(2).critJoygapmean_frommanifold=meancritgap13;parameters_joy.quad(4).critJoygapmean_frommanifold=meancritgap24;

sigmacritgap13=common_sigma_critgap; sigmacritgap24=common_sigma_critgap;
parameters_joy.quad(1).critJoygapsigmafrommanifold=sigmacritgap13;parameters_joy.quad(3).critJoygapsigmafrommanifold=sigmacritgap13;
parameters_joy.quad(2).critJoygapsigmafrommanifold=sigmacritgap24;parameters_joy.quad(4).critJoygapsigmafrommanifold=sigmacritgap24;

meancritgap0=critgapconst;sigmacritgap0=common_sigma_critgap;
for q=1:4 parameters_joy.quad(q).critJoygapmean_from0=meancritgap0;parameters_joy.quad(q).critJoygapsigmafrom0=sigmacritgap0;end

nfalls=0;
for simiteration=1:itermax;
%INITIAL CONDITIONS
ini=1;fin=2;       
sigma_th_ini=5;sigma_v_ini=10;
eps_th=sigma_th_ini*randn(1);
eps_v=sigma_v_ini*randn(1);
quadrand(ini)=randi(4,1);q=quadrand(ini);
if q==1 th=eps_th;v=eps_v;elseif q==2 th=-eps_th;v=eps_v; elseif q==3; th=-eps_th;v=-eps_v;  elseif q==4 th=eps_th;v=-eps_v;end  
% NJoytransitions_thisquadrant=0;     
joystate.jDBcurrentheld=0;joystate.jcurrentheld=-sign(th)*joystate.jDBcurrentheld;
ix=find(th>parameters_joy.joyDBmanifold(:,1) & th<parameters_joy.joyDBmanifold(:,2) & v>parameters_joy.joyDBmanifold(:,3) & v<parameters_joy.joyDBmanifold(:,4));
meanjoy_on_DBmanifold=parameters_joy.joyDBmanifold(ix,5);joystate.lastjoygapfrommanifold=abs(meanjoy_on_DBmanifold-joystate.jDBcurrentheld);
joystate.On_manifold_or_0=0;
joystate.maketransition=0;









fntsz=11.5;
rotv=-15;rotth=10;
% RUNGE KUTTA Multivariable integration (th and l ; v and k)
ktm=1;dt=1/fs;h=dt;
nr=2;nc=3;
figure(1);
% simtile=tiledlayout(2,3);simtile.TileSpacing = 'tight';set(gcf,'color','w');
% set(gcf,'position',[46 1 1875 979])
% set(gcf,'position',[42 41 1219 900])
set(gcf,'position',[figposn])
while ktm<=Tdur/dt
disp(['t = ' num2str(ktm*dt)])    
%    figure(1); PUTTING IT HERE HAS EFFECT OF ALWAYS STAY ON TOP. HOW TO
%    INVOKE MANY FIGURES EARLY UP AND NOT HAVE THEM COME IN FRONT.
%    PLOT(figure_Handle, blah blah something?)
if ktm==1    
subplot(nr,nc,1)%subplot(nr,nc,1)
plot(th(ini),v(ini), 'o','Markersize',15);hold on
xlabel('Position \theta^o');ylabel('Velocity v (^o/s)');
xlim([-thlm thlm]); ylim([-vlm vlm]);
hv(1,0,[0 0 0],'--',2);hv(2,0,[0 0 0],'--',2);grid on
color=darken(mc('yellow'),50);
% hv(1,sigma_v_ini,color);hv(1,-sigma_v_ini,color);
% hv(2,sigma_th_ini,color);hv(2,-sigma_th_ini,color);
title('SIMULATED Phase Plot')
title('PHASE SPACE TRAJECTORY')
axis square
set(gca,'fontsize',fntsz)

subplot(nr,nc,2)%subplot(nr,nc,2)
plot3(th(ini),v(ini),joystate.jcurrentheld,'o','Markersize',15);hold on
% xlabel('Position \theta^o','rotation',rotth);ylabel('Velocity v (^o/s)','rotation',rotv);
xlim([-thlm thlm]); ylim([-vlm vlm]);zlim([-1.1 1.1])
Ylim=ylim;Xlim=xlim;Zlim=zlim; %Bring x y labels closer
xlabel('Position \theta^o','position',[mean(Xlim)-40 Ylim(1)-90 Zlim(1)],'rotation',rotth);
ylabel('Velocity  v(^{o}/s)','position',[Xlim(1)-35 mean(Ylim)-140 Zlim(1)],'rotation',rotv);
zlabel('J(\theta,v)');
hv(1,0,[0 0 0],'--',2);hv(2,0,[0 0 0],'--',2);grid on
title('SIMULATED Phase vs SIMULATED Joy Plot')
title('REAL JOYSTICK IN PHASE SPACE')
% subplot(nr,nc,2)
% plot3(th(ini),v(ini),joystate.jDBcurrentheld,'o','Markersize',15);hold on
% xlabel('Theta (deg)');ylabel('Vel (deg/s)');zlabel('Real Joy (-1 :+1)');
% xlim([-thlm thlm]); ylim([-vlm vlm]);zlim([-1.1 1.1])
% hv(1,0);hv(2,0);grid on
% title('SIMULATED Phase vs SIMULATED DoB-BDY Joy Plot')
axis square
set(gca,'fontsize',fntsz)
zlabl=get(gca,'zlabel');zlabl=zlabl.String; % postion zlabel closer
Zlim=zlim;
zlabel(zlabl,'position',[Xlim(1)-15 Ylim(2)  mean(Zlim)])

subplot(nr,nc,3)
plot(nan,nan);hold on
      ht=1.2;ylim([-ht ht]+0.5);xlim([-1 1]*ht);
%       grid on;
    set(gca,'color','k')
    title('TRACK OF CUES PRESENTED')
    
%     axis square
%     f3pos=get(gca,'position');
%     dx3=f3pos(1)*(5/100);
% %     pause
%     set(gca,'position',f3pos-[dx3 0 0 0])
%     set(gca,'xtick',[])
% set(gca,'ytick',[])
%     pause

subplot(nr,nc,4)%subplot(nr,nc,3)
xlim([0 Tdur]);ylim([-1 1]);xlabel('Time (s)');hold on; 
ylabel('J(t)  (- = Lt, + = Rt)');%ylabel('SIMJoy (-1Lt +1Rt)');
title('SIMULATED Joy (-1Lt +1Rt)');hv(1,0,[0 0 0],'--',2);%mc('orange'));
title('JOYSTICK   Vs.  Time')
box on
% subplot(nr,nc,6)%CANT KEEP HERE COZ DO HOLD OFF SO SETTING GOES
% plot(nan,nan)
% grid on;
% ht=1.2;ylim([-ht ht]+0.5);xlim([-1 1]*ht);
% set(gca,'color','k')
axis square
set(gca,'fontsize',fntsz)


subplot(nr,nc,5)%subplot(nr,nc,2)
plot3(th(ini),v(ini),nan,'o','Markersize',15);hold on
% xlabel('Theta (deg)');ylabel('Vel (deg/s)');
% xlabel('Position \theta^o','rotation',rotth);ylabel('Velocity v (^o/s)','rotation',rotv);
xlim([-thlm thlm]); ylim([-vlm vlm]);zlim([-1.1 1.1])
Ylim=ylim;Xlim=xlim;Zlim=zlim; %Bring x y labels closer
xlabel('Position \theta^o','position',[mean(Xlim)-40 Ylim(1)-90 Zlim(1)],'rotation',rotth);
ylabel('Velocity  v(^{o}/s)','position',[Xlim(1)-35 mean(Ylim)-140 Zlim(1)],'rotation',rotv);
zlabel('M(\theta,v)');%zlabel('Real Joy (-1 :+1)');

hv(1,0,[0 0 0],'--',2);hv(2,0,[0 0 0],'--',2);grid on
title('TRANSFORMED MANIFOLD IN PHASE SPACE')
axis square
zlabl=get(gca,'zlabel');zlabl=zlabl.String; % postion zlabel closer
Zlim=zlim;
zlabel(zlabl,'position',[Xlim(1)-15 Ylim(2)  mean(Zlim)])
set(gca,'fontsize',fntsz)




end



joystate.joydrive= joystate.jcurrentheld + parameters_joy.sigmanoise*randn(1);

do_something_vs_nothing_color;
markercolor=joystate.doinganything_but_not_transiton.color;
if joystate.maketransition
   transjoylist=joystate.transition.joylist;L=length(transjoylist);
   if joystate.transition.nstepstomake==L  for j=1:10 disp(joystate.comment(j).txt);end;end
   joystate.jcurrentheld=transjoylist(L-joystate.transition.nstepstomake+1);
   joystate.transition.nstepstomake=joystate.transition.nstepstomake-1;
   if joystate.transition.nstepstomake==0 joystate.maketransition=0;end
   markercolor=joystate.transitiontype.color;
end
 
a=acc_sim(ktm,th(ini),v(ini),parameters_pend,parameters_joy,joystate,1);
k1 = h *a;
l1 = h *v(ini);
k2 = h *acc_sim(ktm,th(ini)+ l1./2, v(ini) + k1./2,parameters_pend,parameters_joy,joystate,2);
l2 = h *(v(ini) + k1./2 );
k3 = h *acc_sim(ktm,th(ini)+ l2./2, v(ini) + k2./2, parameters_pend,parameters_joy,joystate,3);
l3 = h *(v(ini) + k2./2 );
k4 = h *acc_sim(ktm,th(ini)+ l3, v(ini) + k3, parameters_pend,parameters_joy,joystate,4);
l4 = h *(v(ini) + k3 );
v(fin) = v(ini) + 1/6 *(k1 + 2*k2 + 2*k3 +  k4);
th(fin) = th(ini)  + 1/6 *(l1 + 2*l2 + 2*l3 +  l4);
quadrand(fin)=getquadrand(th(fin),v(fin));




if ~joystate.maketransition
joystate=SIM_JOY(th,v,quadrand,joystate,parameters_joy,dt); %kept it after acceleration, coz may need pre transition accln input for transition decision making in future modeling 
end
BACKGNDCOLOR=[1 1 1];[0 0 0];
GRIDCOLOR=[0.1, 0.1, 0.1];%+0.9;
do_something_vs_nothing_color
markercolor=VIP.Headcolor;
gridalpha=0.4;
subplot(nr,nc,1)%subplot(nr,nc,1)
plot(th(fin),v(fin), markertype,'color',markercolor,'markersize',markersize);
ax = gca;%get(hf,'CurrentAxes')
set(ax,'color',BACKGNDCOLOR)
grid on; %grid minor
ax.GridColor = GRIDCOLOR;  % [R, G, B]
set(ax,'GridAlpha',gridalpha,'MinorGridAlpha',gridalpha);

subplot(nr,nc,2)%subplot(nr,nc,2)
plot3(th(fin),v(fin),joystate.joydrive,markertype,'color',markercolor,'markersize',markersize);
% plot3(th(fin),v(fin),joystate.jDBcurrentheld,markertype,'color',markercolor,'markersize',markersize);
% set(gca,'color',[0 0 0])
ax = gca;%get(hf,'CurrentAxes')
set(ax,'color',BACKGNDCOLOR)
grid on; %grid minor
ax.GridColor = GRIDCOLOR;  % [R, G, B]
set(ax,'GridAlpha',gridalpha,'MinorGridAlpha',gridalpha);
view(-35,10)



subplot(nr,nc,4)%subplot(nr,nc,3)
plot(ktm*dt,joystate.joydrive,markertype,'color',markercolor);
% set(gca,'color',[0 0 0])
ax = gca;%get(hf,'CurrentAxes')
set(ax,'color',BACKGNDCOLOR)
% grid on; grid minor
% ax.GridColor = GRIDCOLOR;  % [R, G, B]
% set(ax,'GridAlpha',gridalpha,'MinorGridAlpha',gridalpha);

subplot(nr,nc,5)
  %goodbad  
  pos=th(fin);vel=v(fin);                                                     
  if(pos>0 & vel>0);joystate.M=-joystate.joydrive;%Q1
  elseif(pos<0 & vel<0);joystate.M=joystate.joydrive;%Q3
%speedingslowing 
  elseif (pos>0 & vel<0);joystate.M=-joystate.joydrive;%Q4;
  elseif(pos<0 & vel>0);joystate.M=joystate.joydrive;%Q2;
  end
  plot3(th(fin),v(fin),joystate.M,markertype,'color',markercolor,'markersize',markersize);
% plot3(th(fin),v(fin),joystate.jDBcurrentheld,markertype,'color',markercolor,'markersize',markersize);
% set(gca,'color',[0 0 0])
ax = gca;%get(hf,'CurrentAxes')
set(ax,'color',BACKGNDCOLOR)
grid on; %grid minor
ax.GridColor = GRIDCOLOR;  % [R, G, B]
set(ax,'GridAlpha',gridalpha,'MinorGridAlpha',gridalpha);
view(-35,10)





subplot(nr,nc,6)%subplot(nr,nc,4)
ordinate=cosd(th(ini));% ht added to cos and not sine coz theta wrt vertical
abscissa=sind(th(ini));
% plot([0 abscissa],[0 ordinate],'-','color', mc('orange'),'Linewidth',7);hold on;
plot([0 abscissa],[0 ordinate],'-','color', VIP.Stickcolor,'Linewidth',7);hold on;
plot(0,0,'o','markersize',7,'color',darken(VIP.Stickcolor,200),'Markerfacecolor',darken(VIP.Stickcolor,200))
% Headcolor=VIP.Headcolor;[0 1 0];
% if parameters_joy.prob_manifold_to_0_vs_stayonmanifold>=.5
%     do_something_vs_nothing_color_PROPOSAL22_color
% elseif parameters_joy.prob_manifold_to_0_vs_stayonmanifold<=.5
%     if joystate.maketransition==1 VIP.Headcolor=[0 0 1];end
% end
% Headtype='o';
plot(abscissa,ordinate,VIP.Headtype,'color',VIP.Headcolor,'Linewidth',5,'Markerfacecolor',VIP.Headcolor,'markersize',20);
itertitle=['Iter:' num2str(simiteration) '/' num2str(itermax) '    Fallen:' num2str(nfalls) '/' num2str(simiteration) '  '];title(itertitle)
title('SUBJECT''S VIEW')
grid on;
ht=1.2;ylim([-ht ht]+0.5);xlim([-1 1]*ht);
set(gca,'color','k')
axis square
set(gca,'xtick',[])
set(gca,'ytick',[])
hold off

if ~isempty(find(VIP.Headcolor~=VIP.HeadcolorOLD))
    
%     if vel>0 Headarrow='+';elseif vel<0 Headarrow='<';else Headarrow='o';end
%     darkenbyvelocity=255;min(abs(vel)*5,255); %50*5 ~ 255close
%     VelHEADcolor=darken(VIP.Headcolor,darkenbyvelocity)
   if vel>0 LineType='-';elseif vel<0 LineType='--';end
    
    
    subplot(nr,nc,3) % make shadow trace VIP
    ordinate=r*cosd(th(ini));% ht added to cos and not sine coz theta wrt vertical
    abscissa=r*sind(th(ini));
    % plot([0 abscissa],[0 ordinate],'-','color', mc('orange'),'Linewidth',7);hold on;
    plot([0 abscissa],[0 ordinate],LineType,'color', VIP.Stickcolor,'Linewidth',1);hold on;
%     plot(0,0,'o','markersize',7,'color',darken(VIP.Stickcolor,200),'Markerfacecolor',darken(VIP.Stickcolor,200))
    plot(abscissa,ordinate,VIP.Headtype,'color',VIP.Headcolor,'Linewidth',1,'markersize',10);
axis square
end
VIP.HeadcolorOLD=VIP.Headcolor;












if mod(ktm,10)==1 
    pause(.1/3);
%     pause(.01/10000);
end

if abs(th(fin))>60 fallentxt='BOUNDARY FALLEN';nfalls=nfalls+1;
    disp(fallentxt);title([itertitle fallentxt]);% ' (Hit Enter for next iteration)']);
    pause(3);
    break;
end


th(ini)=th(fin);
v(ini)=v(fin);
quadrand(ini)=quadrand(fin);
ktm=ktm+1;



end









shiftdxpc=16;dypos=-.05;
subplot(nr,nc,2)
 f3pos=get(gca,'position');
    d3x=f3pos(1)*(shiftdxpc/100);
    set(gca,'position',f3pos-[d3x 0 0 0])
    box on
subplot(nr,nc,5)
 f3pos=get(gca,'position');
    d3x=f3pos(1)*(shiftdxpc/100);
    set(gca,'position',f3pos-[d3x dypos 0 0]) 
    box on
    
    
    shiftdxpc=1.3*shiftdxpc;
subplot(nr,nc,3)
axis square
set(gca,'xtick',[])
set(gca,'ytick',[])
 f3pos=get(gca,'position');
    d3x=f3pos(1)*(shiftdxpc/100);
    set(gca,'position',f3pos-[d3x 0 0 0])
set(gca,'fontsize',fntsz)



subplot(nr,nc,6)
axis square
set(gca,'xtick',[])
set(gca,'ytick',[])
 f3pos=get(gca,'position');
    d3x=f3pos(1)*(shiftdxpc/100);
    set(gca,'position',f3pos-[d3x dypos 0 0])
    set(gca,'fontsize',fntsz)
    
    subplot(nr,nc,4)
 f4pos=get(gca,'position');
 set(gca,'position',f4pos-[0 dypos 0 0])
    set(gca,'fontsize',fntsz)
    
    set(gcf,'color','white')
    set(gcf,'name','SIMJOY')
    
    
    save_figs=1;
loc='C:\Users\abakshi\Desktop\Work 2020\MARS Simulation\SIM_MARS\FIGS STORE 4 PROPOSAL22\';
if save_figs
    fH = findobj('Type', 'figure');
    for k=1:length(fH)
        n=get(fH(k),'name');
        %     n(findstr(n,' '))='_';
%         savefig(fH(k),[loc n])
%         saveas(fH(k), [loc n '.jpg']);
exportgraphics(fH(k),[loc num2str(simiteration) '-' strrep(datestr(now),':','-') '-' n '.jpg'])
    end
end
    
    
% error
if simiteration~=itermax close all;end
% if simiteration~=itermax pause();close all;end
end

 
 
 
 
 
 
 

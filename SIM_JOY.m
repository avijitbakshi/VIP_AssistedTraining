function joystate=SIM_JOY(th,v,quad,joystate,parameters_joy,dt);
c=0; c=c+1;joystate.comment(c).txt=' --------------------';
c=c+1;joystate.comment(c).txt='Start transition decision:';
ini=1; fin=2;joystate.maketransition=0;joystate.transition_timedur=0;joystate.transition.joylist=[];joystate.transition.nsteps=[];
do_something_vs_nothing_color
for j=1:10
    joystate.comment(j).txt=' ';
end

if sign(th(fin))~=sign(th(ini)) joystate.jDBcurrentheld=-joystate.jDBcurrentheld;joystate.jcurrentheld=-sign(th(fin))*joystate.jDBcurrentheld;end

joyDBmanifold=parameters_joy.joyDBmanifold;
ix=find(th(fin)>joyDBmanifold(:,1) & th(fin)<joyDBmanifold(:,2) & v(fin)>joyDBmanifold(:,3) & v(fin)<joyDBmanifold(:,4));
meanjoy_on_DBmanifold=joyDBmanifold(ix,5);
joystate.newjoygapfrommanifold=abs(meanjoy_on_DBmanifold-joystate.jDBcurrentheld);

meanjoy_on_DBmanifold_goingsmall=0;
if sign(meanjoy_on_DBmanifold)==sign(joystate.jDBcurrentheld) 
    if  abs(meanjoy_on_DBmanifold)<abs(joystate.jDBcurrentheld) meanjoy_on_DBmanifold_goingsmall=1;
    c=c+1;joystate.comment(c).txt='checked: Manifold says do less than what doing now';
    end
end

% meanjoy_on_DBmanifold
% [joystate.newjoygapfrommanifold joystate.lastjoygapfrommanifold]

if joystate.newjoygapfrommanifold < joystate.lastjoygapfrommanifold
    joystate.lastjoygapfrommanifold=joystate.newjoygapfrommanifold;
    joystate.maketransition=0;
    c=c+1;joystate.comment(c).txt='Gap from Manifold is decreasing';
    joystate.away_manifold=0;%AB PROPOSAL22 062522
    return;
    
    
    
elseif joystate.newjoygapfrommanifold > joystate.lastjoygapfrommanifold
    joystate.away_manifold=1;%AB PROPOSAL22 062522
    if joystate.On_manifold_or_0==1
        critgap=parameters_joy.quad(quad(fin)).critJoygapmean_frommanifold + parameters_joy.quad(quad(fin)).critJoygapsigmafrommanifold*randn(1);
    whereweare='manifold itself';
    else %if joystate.On_manifold_or_0==0
        critgap=parameters_joy.quad(quad(fin)).critJoygapmean_from0 + parameters_joy.quad(quad(fin)).critJoygapsigmafrom0*randn(1);
    whereweare='0plane';
    end
    joystate.critgap=critgap;
    c=c+1;joystate.comment(c).txt='Gap from Manifold increased';
    
    
    if joystate.newjoygapfrommanifold<=critgap 
         joystate.maketransition=0;
         c=c+1;joystate.comment(c).txt='Manifold gap less than critical, no need for transition';
         joystate.inside_thresh=1;%AB PROPOSAL22 062522
         return
    else%if joystate.newjoygapfrommanifold>critgap 
        joystate.maketransition=1;
        c=c+1;joystate.comment(c).txt=['Manifold gap more than critical = ' num2str(critgap) ', while on: ' whereweare];
        joystate.inside_thresh=0;%AB PROPOSAL22 062522
    end
    
    
    
    if joystate.maketransition
       c=c+1;joystate.comment(c).txt='Make transition'; %joystate.flag=1;
                         if meanjoy_on_DBmanifold_goingsmall==0 % going large or is on 0manifold
                             if joystate.On_manifold_or_0==0 joystate.transitiontype.color=mc('blue');
                                 c=c+1;joystate.comment(c).txt='Transition type: Manifold says=do MORE, Decision moveJoy = 0plane -> manifold';
                             elseif joystate.On_manifold_or_0==1 joystate.transitiontype.color=mc('dblue');
                                 c=c+1;joystate.comment(c).txt='Transition type: Manifold says = do MORE,  Decision moveJoy = small manifold -> large manifold';
                             end
                             joystate.jDBcurrentheld=meanjoy_on_DBmanifold + parameters_joy.quad(quad(fin)).sigma_joy_manifold*randn(1);
                             joystate.lastjoygapfrommanifold=abs(meanjoy_on_DBmanifold-joystate.jDBcurrentheld); %near 0+-sigma
                             joystate.On_manifold_or_0=1; 
                             
                         else%if meanjoy_on_DBmanifold_goingsmall==1 going small (was doing something, manifold said do less something)
                             p=parameters_joy.prob_manifold_to_0_vs_stayonmanifold;%(th(fin),v(fin));
                            
                             if rand<p 
                               joystate.jDBcurrentheld=0+parameters_joy.sigma_joy_0;
                               joystate.lastjoygapfrommanifold=abs(meanjoy_on_DBmanifold-joystate.jDBcurrentheld); 
                               joystate.On_manifold_or_0=0;
                               c=c+1;joystate.comment(c).txt='Transition type: Manifold says=do LESS, Decision moveJoy = manifold -> 0plane(DO NOTHING)';
                               joystate.transitiontype.color=mc('lred');
                             else
                               joystate.jDBcurrentheld=meanjoy_on_DBmanifold + parameters_joy.quad(quad(fin)).sigma_joy_manifold*randn(1);
                               joystate.lastjoygapfrommanifold=abs(meanjoy_on_DBmanifold-joystate.jDBcurrentheld); %near 0+-sigma
                               joystate.On_manifold_or_0=1; 
                               c=c+1;joystate.comment(c).txt='Transition type: Manifold says=do LESS, Decision moveJoy = large manifold = small manifold(DO LESS SOMETHING)';
                               joystate.transitiontype.color=mc('lblue');
                             end
                         end
                         if joystate.jDBcurrentheld>1 joystate.jDBcurrentheld=1; elseif joystate.jDBcurrentheld<-1 joystate.jDBcurrentheld=-1;end %max joy =+-1;
                         joystate.transition_from=joystate.jcurrentheld;
                         joystate.transition_to=-sign(th(fin))*joystate.jDBcurrentheld;
                         transition_absdJ=abs(joystate.transition_to-joystate.transition_from);
                         ix=find(transition_absdJ>parameters_joy.djs);if isempty(ix) ix=1;else ix=ix(end);end
                         joystate.transition_timedur=parameters_joy.meandt(ix)+ parameters_joy.stddt(ix)*randn(1);
                         
                         c=c+1;joystate.comment(c).txt=['Transition movement style: ' joystate.transition.movement_style];
                         switch joystate.transition.movement_style
                             case 'sudden'
                                 joystate.transition.joylist=-sign(th(fin))*joystate.jDBcurrentheld;
                             case 'linear'
                                 joystate.transition.joylist=linspace(joystate.transition_from,joystate.transition_to,joystate.transition_timedur/dt +1); 
                             case 'sigmoid'
                                 nsigmoidsteps=[1:joystate.transition_timedur/dt];
                                 joystate.transition.joylist=joystate.transition_from + (1./(1 + exp(-1*(nsigmoidsteps-mean(nsigmoidsteps)))))*(joystate.transition_to - joystate.transition_from);
                         end
                       
                         joystate.transition.nstepstomake=length(joystate.transition.joylist);
                         do_something_vs_nothing_color
    end
    
    
    
    
    
end









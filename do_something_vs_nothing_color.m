% if joystate.On_manifold_or_0==0 joystate.doinganything_but_not_transiton.color=mc('red');elseif joystate.On_manifold_or_0==1 joystate.doinganything_but_not_transiton.color=mc('green');end
 blu=[93 38 248]/255;
VIP.Stickcolor=blu;
VIP.Headtype='o';
dreps=.1;ro=1;
if joystate.On_manifold_or_0==0 
    lgray=lighten(mc('grey'),100);
    joystate.doinganything_but_not_transiton.color=lgray;
    VIP.Headcolor=lgray;
    VIP.Stickcolor=lgray;
    r=ro-1*dreps;
elseif joystate.On_manifold_or_0==1 
       VIP.Headcolor=blu;%mc('green');
       
       if joystate.inside_thresh==1 && joystate.away_manifold==0%AB PROPOSAL22 062522
            VIP.Headcolor=[4 188 35]/255; %green %mc('green');
             r=ro+0*dreps;
       elseif joystate.inside_thresh==1 && joystate.away_manifold==1
           VIP.Headcolor=[246 116 8]/255;%orange hue
           r=ro+2*dreps;
       elseif joystate.inside_thresh==0 && joystate.away_manifold==0
           VIP.Headcolor=[182 186 6]/255;%olive
            r=ro+1*dreps;
       elseif joystate.inside_thresh==0 && joystate.away_manifold==1
           VIP.Headcolor=[1 0 0];
           VIP.Headtype='x';
            r=ro+3*dreps;
       end
end




function a=accl_MARS(ktm,th,v,parameters_pend,parameters_joy,joystate,anum)
K_G=parameters_pend.K_G;
K_restoring=parameters_pend.K_restoring;
K_damp=parameters_pend.K_damp;



% Joy=parameters_joy.Joystick_Machine_Amp*joystate.jcurrentheld;
Joy=parameters_joy.Joystick_Machine_Amp*joystate.joydrive;
% th
% v
a_g=K_G*sind(th);
a_r=K_restoring*th;
a_d=K_damp*v;
% a=K_G*sind(th)-K_restoring*th- K_damp*v + Joy
a=  a_g - a_r - a_d + Joy; % sign of Joy taken care of within jcurrentheld
% if anum==1
%     figure(3000)
%     plot(ktm,a_g,'ro');hold on
%     plot(ktm,Joy,'go');
%     plot(ktm,a,'bo');
% end
 

















% Joy=Joy_manifold(th,v,parameters_joy)  
 
% a=K_G*sin(th)-K_restoring*th- K_damp*v-sign(th)*Joy;


% function Joy=Joy_manifold(th,v,parameters_joy)
% 
% sign_joytoDOB=sign(th);
% K_joy_th=parameters_joy.quad(quad).K_joy_th;
% K_joy_v=parameters_joy.quad(quad).K_joy_v;
% c_joy=parameters_joy.quad(quad).c_joy;
% Joystick_Machine_Amp=parameters_joy.quad(quad).Joystick_Machine_Amp;
% sigma_joy=parameters_joy.quad(quad).sigma_joy;
% intermittent_continuous_th_thresh=parameters_joy.quad(quad).intermittent_continuous_th_thresh;
% intermittent_continuous_v_thresh=parameters_joy.quad(quad).intermittent_continuous_v_thresh;
% Joy1mean= K_joy_th*abs(th) + K_joy_v*abs(v) + c_joy;
% Joy1=Joy1mean+sigma_joy*randn(1);
% if Joy1>1 Joy1=1; elseif Joy1<-1 Joy1=-1;end %max joy =+-1;
%  
% %Slowing down
% % if quadrant==2||quadrant==4 end;
%  
% Joy=Joystick_Machine_Amp*(sign_joytoDOB*Joy1);% THERE SHUD BE A MINUS
% SIGN?, RIGHT? OR NOT GIVEN sign(th) in Eqn of a
%  
% end


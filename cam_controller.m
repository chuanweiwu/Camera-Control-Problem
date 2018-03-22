function u=cam_controller(Pt,s_old,Rphi,Rpsi)%,u_old,t)

temp=Rpsi'*(Rphi'*[Pt;3]);
k=-3/temp(3);
Xt=[temp(1)*k+50;temp(2)*k+50;temp(3)*k+3];

if Xt(1)>=50&&Xt(2)>=50
    angle=atan((Xt(2)-50)/(Xt(1)-50));
elseif Xt(1)>=50&&Xt(2)<50
    angle=2*pi+atan((Xt(2)-50)/(Xt(1)-50));
elseif Xt(1)<50&&Xt(2)>=50
    angle=pi+atan((Xt(2)-50)/(Xt(1)-50));
elseif Xt(1)<50&&Xt(2)<50
    angle=pi+atan((Xt(2)-50)/(Xt(1)-50));
end


s(1)=angle;
s(2)=pi/2+atan(3/sqrt((Xt(1)-50)^2+(Xt(2)-50)^2));
s(3)=(s(1)-s_old(1));
s(4)=(s(2)-s_old(2));
u(1)=(s(3)-s_old(3))/(100/180*pi);
u(2)=(s(4)-s_old(4))/(100/180*pi);

% du(1)=u(1)-u_old(1);
% du(2)=u(2)-u_old(2);

% u(1)=0.03*u(1)+100*du(1)*t;
% u(2)=0.03*u(2)+100*du(2)*t;

u(1)=max(min(u(1),1),-1);
u(2)=max(min(u(2),1),-1);
end
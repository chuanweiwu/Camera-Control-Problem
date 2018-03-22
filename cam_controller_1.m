function u=cam_controller_1(Xt,s_old,u_old)



if Xt(1)>=50&&Xt(2)>=50
    angle=3/2*pi+atan((Xt(2)-50)/(Xt(1)-50));
elseif Xt(1)>=50&&Xt(2)<50
    angle=3/2*pi+atan((Xt(2)-50)/(Xt(1)-50));
elseif Xt(1)<50&&Xt(2)>=50
    angle=pi/2+atan((Xt(2)-50)/(Xt(1)-50));
elseif Xt(1)<50&&Xt(2)<50
    angle=pi/2+atan((Xt(2)-50)/(Xt(1)-50));
end


s(1)=angle;
s(2)=pi/2+atan(3/sqrt((Xt(1)-50)^2+(Xt(2)-50)^2));
s(3)=(s(1)-s_old(1));
s(4)=(s(2)-s_old(2));
u(1)=(s(3)-s_old(3))/(100/180*pi);
u(2)=(s(4)-s_old(4))/(100/180*pi);

du(1)=u(1)-u_old(1);
du(2)=u(2)-u_old(2);

u(1)=0.29*u_old(1)+du(1);
u(2)=0.29*u_old(2)+du(2);

u(1)=max(min(u(1),1),-1);
u(2)=max(min(u(2),1),-1);
end
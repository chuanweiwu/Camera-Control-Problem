clc
clear
close all

testlength=100;
time=linspace(0,10,testlength);
deltat=1;
Xc=[50;50;3];
s=zeros(4,testlength);
% s(:,1)=[5/4*pi;pi/2+0.0424;0;0];
s(:,1)=[0;pi;0;0];
% s=repmat(s,1,1000);

x=linspace(-1*pi*1,pi*1,testlength);
r=10;
Xt(1,:)=sin(x(1:testlength)).*r+50;
Xt(2,:)=cos(x(1:testlength)).*r+50;
% x=linspace(-1*pi*2,pi*2,testlength);
% r=linspace(0,10,testlength);
% Xt(1,:)=sin(x(1:testlength)).*r(1:testlength)+50;
% Xt(2,:)=cos(x(1:testlength)).*r(1:testlength)+50;
% Xt(1,:)=linspace(0,10,testlength);
% Xt(2,:)=linspace(0,100,testlength);
% Xt(1,:)=linspace(0,100,testlength);
% Xt(2,:)=linspace(0,100,testlength);

lmd=3;
Qt=zeros(3,testlength);
Pt=zeros(2,testlength);
dPt=zeros(2,testlength);
Pt_est=zeros(2,testlength);
u=[0;0];
A=[1 0 deltat 0;    
   0 1 0 deltat;
   0 0 1 0;
   0 0 0 1];
B=[0 0;
   0 0;
   100 0; 
   0 100];
Xt_check=zeros(3,testlength);
Xt_est=zeros(3,testlength);
figure
% xlim([0 150])
% ylim([0 22500])
hold on


for i=1:testlength
    Rphi=[1 0 0;
          0 cos(s(2,i)) sin(s(2,i));
          0 -sin(s(2,i)) cos(s(2,i))];  
    Rpsi=[cos(s(1,i)) sin(s(1,i)) 0;
          -sin(s(1,i)) cos(s(1,i)) 0;
          0 0 1];
    Qt(:,i)=Rphi*Rpsi*([Xt(:,i);0]-Xc);
    Pt(:,i)=lmd*[Qt(1,i)/Qt(3,i);Qt(2,i)/Qt(3,i)];
    
    if i>=2
        dPt(:,i)=Pt(:,i)-Pt(:,i-1);
        Pt_est(:,i+1)=Pt(:,i)+dPt(:,i);
        temp=Rpsi'*(Rphi'*[Pt_est(:,i+1);lmd]);
        t=-3/temp(3);
        Xt_est(:,i+1)=[temp(1)*t+50;temp(2)*t+50;temp(3)*t+3];        
    end
    
    
    
    u=cam_controller(Pt_est(:,i+1),s(:,i),Rphi,Rpsi);%,u,deltat);
    s(3,i+1)=s(3,i)+(100/180*pi)*u(1);
%     s(3,i+1)=min(s(3,i+1),(100/180*pi));
    s(4,i+1)=s(4,i)+(100/180*pi)*u(2);
%     s(4,i+1)=min(s(4,i+1),(100/180*pi));
    s(1,i+1)=s(1,i)+0.01*s(3,i);
    
    s(2,i+1)=s(2,i)+0.01*s(4,i);
    
    
    plot(Xt_est(1,i),Xt_est(2,i),'r.','MarkerSize',19)
%     pause(0.1)
    
    temp=Rpsi'*(Rphi'*[Pt(:,i);lmd]);
    t=-3/temp(3);
    Xt_check(:,i)=[temp(1)*t+50;temp(2)*t+50;temp(3)*t+3];
    
%     
%     
%     z=cat(1,Pt(:,i),dPt(:,i));
%     s(1,i+1)=s(1,i)+deltat*s(3,i);
%     s(2,i+1)=s(2,i)+deltat*s(4,i);
%     s(3,i+1)=s(3,i)+100*u(1,i);
%     s(4,i+1)=s(4,i)+100*u(2,i);
    
        
end
    
    


figure

plot(Xt(1,:),Xt(2,:))

figure

plot(Xt_check(1,:),Xt_check(2,:),'b.','MarkerSize',19)

% figure

figure
plot(1:testlength,s(1,1:testlength)*180/pi,'b.','MarkerSize',19)
figure
plot(1:testlength,s(2,1:testlength)*180/pi,'b.','MarkerSize',19)

% Rphi=[1 0 0;
%           0 cos(s(2,i+1)) sin(s(2,i+1));
%           0 -sin(s(2,i+1)) cos(s(2,i+1))];  
%     Rpsi=[cos(s(1,i+1)) sin(s(1,i+1)) 0;
%           -sin(s(1,i+1)) cos(s(1,i+1)) 0;
%           0 0 1];
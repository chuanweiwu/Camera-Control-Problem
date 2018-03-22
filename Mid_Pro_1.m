clc
clear
close all

testlength=1000;
deltat=1;
Xc=[50;50;3];
s=zeros(4,testlength);
% s(:,1)=[5/4*pi;pi/2+0.0424;0;0];
s(:,1)=[0;pi;0;0];
lmd=3;
% 
Xt(1,:)=linspace(50,80,testlength);
Xt(2,:)=linspace(50,80,testlength);
x=linspace(-1*pi*1,0,testlength);
r=20;
Xt(1,:)=sin(x(1:testlength)).*r+50;
Xt(2,:)=cos(x(1:testlength)).*r+50;

x=linspace(-1*pi*2,pi*2,testlength);
r=linspace(0,10,testlength);
Xt(1,:)=sin(x(1:testlength)).*r(1:testlength)+50;
Xt(2,:)=cos(x(1:testlength)).*r(1:testlength)+50;

plot(Xt(1,2:end),Xt(2,2:end),'r.','MarkerSize',19)
Xt_est=zeros(2,testlength);
Xt_est(:,1)=[50;50];
dXt=[0;0];
u=[0;0];
hold on
xlim([0,100])
ylim([0,100])

for i=1:testlength
    Rphi=[1 0 0;
          0 cos(s(2,i)) sin(s(2,i));
          0 -sin(s(2,i)) cos(s(2,i))];  
    Rpsi=[cos(s(1,i)) sin(s(1,i)) 0;
          -sin(s(1,i)) cos(s(1,i)) 0;
          0 0 1];
    Qt(:,i)=Rphi*Rpsi*([Xt(:,i);0]-Xc);
    Pt(:,i)=lmd*[Qt(1,i)/Qt(3,i);Qt(2,i)/Qt(3,i)];
    
    temp=Rpsi'*(Rphi'*[Pt(:,i);lmd]);
    t=-3/temp(3);
    Xt(:,i)=[temp(1)*t+50;temp(2)*t+50];
    
    if i>=2
    dXt=Xt(:,i)-Xt(:,i-1);
%     H=[-lmd/Qt(3,i) 0 Pt(1,i)/Qt(3,i) Pt(1,i)*Pt(2,i)/lmd -(lmd^2+Pt(1,i)^2)/lmd Pt(2,i);
%        0 -lmd/Qt(3,i) Pt(2,i)/Qt(3,i) (lmd^2+Pt(1,i)^2)/lmd -Pt(1,i)*Pt(2,i)/lmd -Pt(1,i)];
%     dPt(:,i)=H*cat(1,cat(2,Rphi'*Rpsi',zeros(3)),cat(2,zeros(3),-Rphi'))*[dXt(:,i);0;s(3,i);0;s(4,i)];
    
    end
    Xt_est(:,i+1)=dXt+Xt(:,i);
    
    u=cam_controller_1(Xt_est(:,i+1),s(:,i),u);%,u,deltat);
    s(3,i+1)=s(3,i)+(100/180*pi)*u(1);
%     s(3,i+1)=min(s(3,i+1),(100/180*pi));
    s(4,i+1)=s(4,i)+(100/180*pi)*u(2);
%     s(4,i+1)=min(s(4,i+1),(100/180*pi));
    s(1,i+1)=s(1,i)+s(3,i);
    if s(1,i+1)>2*pi
        s(1,i+1)=s(1,i+1)-2*pi;
    end
    
    s(2,i+1)=s(2,i)+s(4,i);  
end



plot(Xt_est(1,2:end),Xt_est(2,2:end),'k--','Linewidth',2)
set(gca,'FontSize',28)
legend('Input trajectory','Detected trajectory')


figure
alf=30;
D=zeros(testlength-1,testlength);
for i=1:testlength-1
    D(i,i)=-1;
    D(i,i+1)=1;
end
A=zeros(2*testlength-1,testlength);
A(1:testlength,:)=eye(testlength);
A(testlength+1:end,:)=alf*D;
b=[s(1,1:testlength)';zeros(testlength-1,1)];
y_corr_1=pinv(A)*b;

plot(1:820,y_corr_1(81:900)*180/pi,'k--')
xlim([1,820])
ylim([0,360])
set(gca,'FontSize',28)
hold on
plot(1:40:820,y_corr_1(81:40:900)*180/pi,'bs','MarkerSize',9)

alf=30;
D=zeros(testlength-1,testlength);
for i=1:testlength-1
    D(i,i)=-1;
    D(i,i+1)=1;
end
A=zeros(2*testlength-1,testlength);
A(1:testlength,:)=eye(testlength);
A(testlength+1:end,:)=alf*D;
b=[s(2,1:testlength)';zeros(testlength-1,1)];
y_corr_2=pinv(A)*b;

plot(1:testlength,y_corr_2(1:testlength)*180/pi,'k-.')
plot(1,s(2,1)*180/pi,'b*','MarkerSize',9)
plot(40:40:testlength,y_corr_2(40:40:testlength)*180/pi,'b*','MarkerSize',9)
legend('Pan angle','Sample pan angle points','Tilt angle','Sample tilt angle points')
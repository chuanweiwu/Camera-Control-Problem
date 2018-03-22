clc
clear
close all

number=1;
for i=1:100
    for j=1:100
        if j>=50&&i>=50
            angle(j,i)=3/2*pi+atan((i-50)/(j-50));
        elseif j>=50&&i<50
            angle(j,i)=3/2*pi+atan((i-50)/(j-50));
        elseif j<50&&i>=50
            angle(j,i)=pi/2+atan((i-50)/(j-50));
        elseif j<50&&i<50
            angle(j,i)=pi/2+atan((i-50)/(j-50));
        end
    end
end
angle=angle*180/pi;

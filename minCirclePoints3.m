function R=minCirclePoints3(A,B,C)

X=[A(1) B(1) C(1)];

Y=[A(2) B(2) C(2)];

%计算三边的长度AB BC CA

len=[sqrt((X(1)-X(2))^2+(Y(1)-Y(2))^2) sqrt((X(2)-X(3))^2+(Y(2)-Y(3))^2) sqrt((X(3)-X(1))^2+(Y(3)-Y(1))^2)];

%在非特殊情况下计算三角形三角的余弦值 cosA,cosB,cosC

if(sum(len>0)==3)

abc=[cosABC(len(2),len(1),len(3)) cosABC(len(3),len(1),len(2)) cosABC(len(1),len(2),len(3))];

end

%两点重合、三点重合、三点共线

if(len(1)==len(2)+len(3))

    r=len(1)/2;

    a=(X(1)+X(2))/2;

    b=(Y(1)+Y(2))/2;

    R=[a b r];

elseif(len(2)==len(1)+len(3))

    r=len(2)/2;

    a=(X(2)+X(3))/2;

    b=(Y(2)+Y(3))/2;

    R=[a b r];

elseif(len(3)==len(1)+len(2))

    r=len(3)/2;

    a=(X(1)+X(3))/2;

    b=(Y(1)+Y(3))/2;

    R=[a b r];

%--------------------------------------------------------------------------

else

    tmp=(abc<=0);

    if(tmp(1))

        r=len(2)/2;

        a=(X(2)+X(3))/2;

        b=(Y(2)+Y(3))/2;

        R=[a b r];

    elseif(tmp(2))

        r=len(3)/2;

        a=(X(1)+X(3))/2;

        b=(Y(1)+Y(3))/2;

        R=[a b r];

    elseif(tmp(3))

        r=len(1)/2;

        a=(X(1)+X(2))/2;

        b=(Y(1)+Y(2))/2;

        R=[a b r];

    elseif(sum(tmp)==0)

        a=(((X(1)^2-X(2)^2+Y(1)^2-Y(2)^2)*(Y(2)-Y(3)))-((X(2)^2-X(3)^2+Y(2)^2-Y(3)^2)*(Y(1)-Y(2))))/(2*(X(1)-X(2))*(Y(2)-Y(3))-2*(X(2)-X(3))*(Y(1)-Y(2)));

        b=(((X(1)^2-X(2)^2+Y(1)^2-Y(2)^2)*(X(2)-X(3)))-((X(2)^2-X(3)^2+Y(2)^2-Y(3)^2)*(X(1)-X(2))))/(2*(Y(1)-Y(2))*(X(2)-X(3))-2*(Y(2)-Y(3))*(X(1)-X(2)))  ;

        r=sqrt((X(1)-a)^2+(Y(1)-b)^2);

        R=[a b r];
    end

    end

end



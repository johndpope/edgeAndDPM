function  [radius,circleCenter] = minCircle(xx,im)

%xx=[-1.2 3;0 0;0 1;0 2;0 3;0 4;0 5;1 -1.5;1 0;1 1;1 2;1 3;1 4;1 5;2 0;2 1;2 2;2 3;2 4;2 5;3 0;3 1;3 2;3 3;3 4;3 5;4 0;4 1;4 2;4 3;4 4;4 5;5 0;5 1;5 2;5 3;5 4;5 5;2.5 3;];

    if nargin>1
        image(im);hold on;
    end
    z=xx(:,1);
    y=xx(:,2);

    plot(z,y,'*');hold on;

    %grid on%

    if length(z)==2
        cc=sqrt(((z(1)-z(2))^2+(y(1)-y(2))^2));
        r=cc/2;
        a=(z(1)+z(2))/2;
        b=(y(1)+y(2))/2;
        R=[a b r]
    %     alpha=0:pi/20:2*pi;%角度[0,2*pi]
    %     plot(a+r*cos(alpha),b+r*sin(alpha),'--r');%中心点在（a,b）半径为r的圆
    %     axis equal;
        
    end

    if length(z)>=3
        [s,d]=size(xx);
        for i=1:1:s
            for j=i:1:s
                summ=0;
                for k=1:1:d
                    summ=summ+(xx(i,k)-xx(j,k))^2;   %计算数据集中的点间距，
                end
                DistanceBO(i,j)=sqrt(summ);       %构造出点间距矩阵DistanceBO
                DistanceBO(j,i)=sqrt(summ); 
            end
        end
        for i=1:1:s                            %找到各个点间距离
            for j=i:1:s
                DD(i,j)=DistanceBO(i,j);
            end;
        end;
        aaa=DD(:);
        TempSortDistanceBO=sort(aaa);
        bbb=fliplr(TempSortDistanceBO');

        %下边找出3个距离最远的点
        maxfrist=[];
        maxsecond=[];
        maxtwo=[];
        allmaxfrist=[];
        finalpoints=[];

        for i=1:1:s                            %找到各个点间距离
        for j=i:1:s
            if DD(i,j)==bbb(1)
                maxfrist=[i j];
            end;
        end;
        end;
        for i=1:1:s                            %找到各个点间距离
            for j=i:1:s
                if i==maxfrist(1)&&j==maxfrist(2)
                    d=0;
                elseif bbb(2)~=bbb(1)
                    if DD(i,j)==bbb(2)
                        maxsecond=[i j];
                        if maxsecond(1)==maxfrist(1)||maxsecond(1)==maxfrist(2)
                        maxtwo=maxsecond(2);       
                        elseif maxsecond(2)==maxfrist(1)||maxsecond(2)==maxfrist(2)
                        maxtwo=maxsecond(1);
                        else maxtwo=maxsecond;
                        end;
                        finalpoints=[maxfrist maxtwo];
                    end;
                elseif bbb(2)==bbb(1)
                    if DD(i,j)==bbb(2)
                        bb=[i j];
                        allmaxfrist=[allmaxfrist bb];
                    %maxtwo=[allmaxfrist(2)]; 
        %                 if allmaxfrist(1)-allmaxfrist(2)==0||allmaxfrist(1)-allmaxfrist(3)==0||allmaxfrist(1)-allmaxfrist(4)==0
        %                     finalpoints=[allmaxfrist(2) allmaxfrist(3) allmaxfrist(4)] ;
        %                 elseif allmaxfrist(2)-allmaxfrist(3)==0||allmaxfrist(2)-allmaxfrist(4)==0
        %                     finalpoints=[allmaxfrist(1) allmaxfrist(3) allmaxfrist(4)] ;
        %                 elseif allmaxfrist(4)-allmaxfrist(3)==0
        %                     finalpoints=[allmaxfrist(1) allmaxfrist(2) allmaxfrist(4)] ;
        %                 else finalpoints=[allmaxfrist(1) allmaxfrist(2) allmaxfrist(3) allmaxfrist(4)];
                        if allmaxfrist(1)==maxfrist(1)||allmaxfrist(1)==maxfrist(2)
                            finalpoints=[maxfrist allmaxfrist(2)];
                        elseif allmaxfrist(2)==maxfrist(1)||allmaxfrist(2)==maxfrist(2)
                            finalpoints=[maxfrist allmaxfrist(1)];
                        else
                            finalpoints=[maxfrist allmaxfrist(1)];%此时最终三个点取前三个点                      
                        end;
                    end;
                end;
            end;
        end;
    %finalpoints=[maxfrist maxtwo];


%set_3P=nchoosek(1:length(finalpoints),3);

%AI=set_3P(1,1);

%BI=set_3P(1,2);

%CI=set_3P(1,3);

%while 1
    A=[z(finalpoints(1)) y(finalpoints(1))];

    B=[z(finalpoints(2)) y(finalpoints(2))];

    C=[z(finalpoints(3)) y(finalpoints(3))];


    R=minCirclePoints3(A,B,C);

    cr=[R(1),R(2)];

    r=zeros(1,length(z));

    for i=1:length(z)

       r(i)=sqrt((z(i)-cr(1))^2+(y(i)-cr(2))^2);

    end;

    maxValue=max(r);    %或者N=max(r(:))

    [mc]=find(maxValue==r);

    

    if r(mc)-R(3)<=0.000001%没有点在圆外，结束回家吃饭去

        alpha=0:pi/20:2*pi;%角度[0,2*pi]
        % 
        circleCenter = R(1,1:2);
        radius = R(3)

        plot(R(1,1)+R(1,3)*cos(alpha),R(1,2)+R(1,3)*sin(alpha),'--r');%中心点在（rSet(i,1),rSet(i,2)）半径为rSet(i,3)的圆     

    else

       %距离圆心最远的点在圆外       

    end;
    r(mc)-R(3)
    if r(mc)-R(3)>0.000001
    
        D=[z(mc),y(mc)];

        P=[A;B;C;D];%保存这四个点的坐标

         

        DI=mc;

        set_3P=nchoosek([finalpoints(1),finalpoints(2),finalpoints(3),DI],3);

        rSet=[];

        for i=1:length(set_3P)

            A=[z(set_3P(i,1)) y(set_3P(i,1))];

            B=[z(set_3P(i,2)) y(set_3P(i,2))];

            C=[z(set_3P(i,3)) y(set_3P(i,3))];

          

            R=minCirclePoints3(A,B,C);
        %         alpha=0:pi/20:2*pi;%角度[0,2*pi]
        %  
        %         plot(R(1)+R(3)*cos(alpha),R(2)+R(3)*sin(alpha),'--r');%中心点在（R(1),R(2)）半径为R(3)的圆
        % 
        %          axis equal;


            rSet=[rSet;[R,i]];%每行：圆心坐标,半径,第几组(每组包括随机的三个点)

        end;

        rSet=sortrows(rSet,3);%按照半径排序



        %   在四个圆中找一个最小半径圆包含这四个点

        for i=1:1:size(rSet,1)
            k=1;
            for j=1:1:4

              if sqrt((rSet(i,1)-(P(j,1) ))^2+ ( rSet(i,2)-(P(j,2)))^2) -rSet(i,3)>0.00001%这个圆不行

                break;  
              else 
                  k=k+1;
              end

            end;

            if k>4%第i组三个点产生的圆可行--必然可以找到一个

                break;

            end;

        end;

        mc=rSet(i,4);

        A=[z(set_3P(mc,1)) y(set_3P(mc,1))];

        B=[z(set_3P(mc,2)) y(set_3P(mc,2))];

        C=[z(set_3P(mc,3)) y(set_3P(mc,3))];

        alpha=0:pi/20:2*pi;%角度[0,2*pi]
        % 
        circleCenter = [rSet(i,1),rSet(i,2)];
        radius = rSet(i,3);

        plot(rSet(i,1)+rSet(i,3)*cos(alpha),rSet(i,2)+rSet(i,3)*sin(alpha),'--r');%中心点在（rSet(i,1),rSet(i,2)）半径为rSet(i,3)的圆
        % 
        %     axis equal;
        %     
    end;
end;




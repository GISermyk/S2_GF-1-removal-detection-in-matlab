%该函数的作用 ：应用在（t1,t2）时段出现潮点时的 情况 
% input :
%list_time_2021：观测值 时间数组
%y2021_WSG :观测值 NDVI时序
%t1,t2：y2021潜在收割时段的 起始时间
%output
%flag : 表示是 潮点的差值（0） or 潮点前观测点时段的最大差值（1）
%T :表示 收割时段的 启点
%max ：表示为 在（t1,t2）内 观测点的最大差值
function [max,T,flag] = one_water_point_get_max(list_time_2021,y2021_WSG,t1,t2)
    flag = 1;
    %获取观测点，n为起始点，m为终点
    [n,m] = get_observe_point(list_time_2021,t1,t2);
    if m - n == 1  % 只存在2个观测点
        max = y2021_WSG(n) - y2021_WSG(m);
        T = n; 
        flag = 0; % 不取值
    else % 存在 
        %u 表示为 潮点 在观测值的 索引序号
        [~,u] = is_water_point(y2021_WSG,n,m);
        %
        if u - n == 1
            max = y2021_WSG(n) - y2021_WSG(u);
            T = n; 
            flag = 0;
             
        elseif u - n == 2

              if y2021_WSG(n) - y2021_WSG(n+1) > 0.15
                  max = y2021_WSG(n) - y2021_WSG(n+1);
                  T = n;
              else
                  max = y2021_WSG(n+1) - y2021_WSG(u);
                  T = n+1;
                  flag = 0;
              end
           
        else
            f = n;
            temp = 0;
            for k = n : u-2
                dif = y2021_WSG(k) - y2021_WSG(k+1);
                if temp < dif
                    temp = dif;
                    f = k;
                end
            end
            if  y2021_WSG(f) - y2021_WSG(f+1) > 0.15
                max = y2021_WSG(f) - y2021_WSG(f+1);
                T = f ;
            else
                max = y2021_WSG(u-1) - y2021_WSG(u);
                T = u-1 ;  
                flag = 0;
            end

        end
    end
end
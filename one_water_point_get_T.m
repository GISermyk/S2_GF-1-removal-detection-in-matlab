function [T] = one_water_point_get_T(list_time_2021,y2021_WSG,t1,t2)
    [n,m] = get_observe_point(list_time_2021,t1,t2);%获取观测点
    if m - n == 1  % 只存在2个观测点
        [T] = fix((list_time_2021(n)+list_time_2021(m)- 738406*2)/2);
    else % 存在至少3个观测点
        
        [flag,u] = is_water_point(y2021_WSG,n,m);
        %-----------------如果（n,m）有淹没点---------------------%
        if flag
            if u - n == 1
                [T] = fix((list_time_2021(n)+list_time_2021(u)- 738406*2)/2);
            elseif u - n == 2
                if y2021_WSG(n) - y2021_WSG(n+1) > 0.15
                    [T] = fix((list_time_2021(n)+list_time_2021(n+1)- 738406*2)/2);
                else
                    [T] = fix((list_time_2021(n+1)+list_time_2021(u)- 738406*2)/2);
                end
            else
                temp = 0;
                for k = n : u-2
                    dif = y2021_WSG(k) - y2021_WSG(k+1);
                    if temp < dif
                        temp = dif;
                        f = k;
                    end
                end
                if temp > 0.15
                    [T] = fix((list_time_2021(f)+list_time_2021(f+1)- 738406*2)/2);
                else
                    [T] = fix((list_time_2021(u-1)+list_time_2021(u)- 738406*2)/2);
                end
            end
          %-----------------------------------------------%
          %-------如果（n,m）没有淹没点--------------------%
        else 
            max = 0;
            if  m - n == 1
                max = y2021_WSG(n) - y2021_WSG(m);
                z = n;
            else
                for k = n:m-1
                    dif = y2021_WSG(n) - y2021_WSG(n+1);
                    if max < dif 
                        max = dif;
                        z = k;
                    end
                end
            end
            
            if max > 0.15
                [T] = fix((list_time_2021(z)+list_time_2021(z+1)- 738406*2)/2);
            else 
                 T = 0; 
            end
        end
        %===========================%
    end
end
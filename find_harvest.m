%x 为输入影像时间数组
%y2021-WSG 为输入的 观测点NDVI时序
%函数作用为 找到y2021时序在（t1,t2）范围里的所有观测点，并输出差值最大的两个观测点中值 为最终收割日期
function [T] =  find_harvest(x,y2021_WSG,t1,t2)
    %y = [];
    t1 = t1 + 738406;
    t2 = t2 + 738406;
    n = length(x);
    s = 1;
    t =1;
    
%找到t1前的最近的 监测日期
    
    if  x(1) == t1 
        s = 1;
    else
        for i = 2:n
            if x(i) == t1
                s = i;
            elseif x(i) > t1 
                s = i-1;
                break
            end
        end    
    end
    
    %找到t2后的最近的 监测日期
    if x(n) == t2
        t = n;
    else
        for i = n:-1:1
            if x(i) == t2
                t = i;
            elseif x(i) < t2
                t = i+1;
                break
            end
        end
    end
    
    
    temp = -1;
    if s == t-1
        T = fix((x(s)+x(t)- 738406*2)/2);
    else
        k = s;
        for j = s:t-1
            if  temp <= y2021_WSG(j) - y2021_WSG(j+1)
                temp = y2021_WSG(j) - y2021_WSG(j+1);
                k = j;
            end
        end
        T = fix((x(k)+ x(k+1) - 738406*2)/2);
    end
end

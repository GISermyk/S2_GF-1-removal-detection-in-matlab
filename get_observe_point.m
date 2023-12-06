%获取观测值y2021在（t1,t2）时序 对应于观测点时段 的起始值
function[s,t] = get_observe_point(x,t1,t2)
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
    
   
end
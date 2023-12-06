%寻找dif曲线的在[t1,t2]中间的凹点，并且存入t数组中
function [apices_min,apices_max] = find_apices2(x)
    apices_min = [];
    apices_max = [];
    n = length(x);
    t1 = 1;
    t2 = n;
    %k = double(x(t2))/2 ;
    if  (t1+1) >= (t2-1)
        s = t1;      
    else    
        for i = (t1+1):(t2-1)
            k1 = x(i) - x(i-1);
            k2 = x(i+1) - x(i);
            if k1<0 && k2>0
                %min_point = i
                apices_min = [apices_min i];
            elseif k1>0 && k2<0
                apices_max = [apices_max i];    
            end     
        end  
        
        if x(1) > x(2)% 表明是向下型
            if x(n-1) < x(n)
                apices_max = [apices_max n];
            end
        else %表明是向上型
            apices_min = [apices_min 1];
            if x(n-1) < x(n)
                apices_max = [apices_max n];
            end
        end
    end   
    apices_min = sort(apices_min);
    apices_max = sort(apices_max);
end

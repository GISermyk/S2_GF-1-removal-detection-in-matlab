function [num,s] = get_max_dif(y2021_GCZ,t1,t2)
    num = -1;
    if t1 >= t2-1
        s = t1; 
        num = y2021_GCZ(t1) - y2021_GCZ(t2);
    else  
        for j = t1:t2-1
            k = j+1;
            if  num <= y2021_GCZ(j) - y2021_GCZ(k)
                num = y2021_GCZ(j) - y2021_GCZ(k);
                s = j;
            
            end
        end
 
    end
end
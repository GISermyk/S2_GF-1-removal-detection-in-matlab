function[flag,k] = is_water_point(y2021,t1,t2)
    flag = 0;
    k = t1;
    for i = t1 : t2       
        if y2021(i) < 0 
            k = i;
            flag = 1;
            break
        end
       
    end
end
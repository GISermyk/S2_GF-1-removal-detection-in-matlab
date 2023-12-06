row_up = 813;
row_down =1777;
column_left = 1519;
column_right = 2300;
% row_up = 715;
% row_down =1427;
% column_left = 461;
% column_right = 1946;

% row_up = 945;
% row_down =1277;
% column_left = 367;
% column_right = 824;
% row_up = 1100;
% row_down =1438;
% column_left = 1970;
% column_right = 2312;
% row_up = 1779;
% row_down =2255;
% column_left = 1692;
% column_right = 2158;
% row_up = 1538;
% row_down =1660;
% column_left = 2021;
% column_right = 2354;
% row_up = 1;
% row_down =3100;
% column_left = 1;
% column_right = 2940;
%创建一个空的矩阵
Q = zeros(row_down-row_up+1,column_right-column_left+1);
%A = zeros(18,19);
h=waitbar(0,'Running','name','processing'); %进度条1
for row =   1:row_down-row_up
   for column =  1:column_right-column_left%column_left:column_right   
        
        %[y2020,y2020_WSG] = insert_value2(data2020,list_time_2020,row,column);
        [y2021,y2021_WSG] = insert_value2(data2021,list_time_2021,row,column);
       % y_dif = y2020-y2021;
        y_dif = y2020 - y2021;
        slope = [];
        slope = [slope 0]; 
        for i = 1:100
            k = y_dif(i+1) - y_dif(i);
            slope = [slope k];   
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        %将2021_NDVI<0.25的像元判别为非植被，且赋值为1
        if y2021_WSG(1) < 0.25
            Q(row,column)  = -1;
        else
            %找到y_dif中的极值点，分别存储到apices_max,apices_min数组中
            [apices_min,apices_max] = find_apices2(y_dif);
            if isempty(apices_min)||isempty(apices_max)
                Q(row,column) = -0.1;
            else
                n = length(apices_min);
        %start数组和terminatr数组分别存放潜在收割时段的起始点
        %count计数，代表输出潜在收割时段的数量
                start = [];
                terminate = [];
                count = 0;
                for i = 1:n
                    t2 = apices_max(i);
                    t1 = apices_min(i);
                    dif = y2021(t1) - y2021(t2);
                    %判断潜在收割时段的阈值
                    m = 0;
                    for j = t1:t2
                        m = m + slope(j);
                    end
                    if   m >= 0.1 && dif >= 0.15
                        start = [start t1];
                        terminate = [terminate t2];
                        count = count+1;
                    end
                end
%%%%%%%%%%%%%%%%%%%%%%%%%
                num = [];
                if count == 0 %没有输出潜在时段，认定为未收割，赋值为0
                    T = 0;       
                elseif count == 1  %只存在一个潜在收割时段的情况
                    
                    %判断 y2021NDVIS 时序是否 存在 潮点，flag为判别标致，p为潮点输出位置
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %[flag,p] = is_water_point(y2021_WSG,1,16);
                    [flag,p] = is_water_point(y2021_WSG,1,11);
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if ~flag % 不存在water_point的情况
                        [T] = find_harvest(list_time_2021,y2021_WSG,start(1),terminate(1));
                    else %存在water_point的情况   
                        
                        [T] = one_water_point_get_T(list_time_2021,y2021_WSG,start(1),terminate(1));
                    end
   
                else  %存在2个及以上的潜在收割时段
                    
                    %max_dif 表示为 在各个潜在时段中(非潮点) 的观测点的最大差值
                    %start_time 表示为 （非潮点）收割时段 启点
                    %water_time 表示为 当潮点作为收割时段 的启点
                    max_dif = [];
                    start_time = [];
                    water_time = [];
                    for j = 1: count
                        %[flag,g] = is_water_point(y2021,start(j),t(j));
                        [n,m] = get_observe_point(list_time_2021,start(j),terminate(j));
                        [flag,g] = is_water_point(y2021_WSG,n,m);
                        
                        if flag
                            [num,d,flag2] = one_water_point_get_max(list_time_2021,y2021_WSG,start(j),terminate(j));
                            if flag2 
                                max_dif = [max_dif num];
                                start_time = [start_time d];
                            else
                                water_time = [water_time d];
                            end
                            break;
                        else
                            [n,m] = get_observe_point(list_time_2021,start(j),terminate(j));
                            [num,d] = get_max_dif(y2021_WSG,n,m);
                            max_dif = [max_dif num];
                            start_time = [start_time d];
                        end
                    end
                    
                    if isempty(max_dif) && isempty(water_time)
                        T = 0;
                    elseif isempty(max_dif) && ~isempty(water_time)
                        d = water_time(1);
                        T = fix((list_time_2021(d)+list_time_2021(d+1)- 738406*2)/2);
                    elseif max(max_dif) > 0.15
                        g = find(max_dif == max(max_dif),1);
                        d = start_time(g);
                        T = fix((list_time_2021(d)+list_time_2021(d+1)- 738406*2)/2);        
                    elseif max(max_dif) <= 0.15 && ~isempty(water_time)
                        d = water_time(1);
                        T = fix((list_time_2021(d)+list_time_2021(d+1)- 738406*2)/2);
                    else 
                        T = 0;
                    end
                    
                end
                
                if isempty(T)
                    T = 0;
                else
                    Q(row,column) = T;
                end
                
            end
        end        
   end
   
   str=['Completed:','',num2str(round(row*101/(row_down-row_up+1))),'%'];
   waitbar(row*100/(row_down-row_up+1),h,str); %进度条2 
end
B1 = double(Q/100);
imtool(B1);


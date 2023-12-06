% row_up = 1;
% row_down =3100;
% column_left = 1;
% column_right = 2940;
row_up = 1779;
row_down =2255;
column_left = 1692;
column_right = 2158;
% row_up = 813;
% row_down =1277;
% column_left = 1519;
% column_right = 2000;
%创建一个空的矩阵
Q = zeros(row_down-row_up+1,column_right-column_left+1);
X=waitbar(0,'Running','name','processing'); %进度条1
for row = 1:row_down - row_up
    for column = 1:column_right - column_left
        
        %[y2020,y2020_WSG] = insert_value2(data2020,list_time_2020,row,column);
        [y2021,y2021_WSG] = insert_value2(data2021,list_time_2021,row,column);
        y_dif = y2020 - y2021;
        
        if y2021_WSG(1) < 0.25
            Q(row,column) = -1;
        else
            [apices_min,apices_max] = find_apices2(y_dif);
            if isempty(apices_min)||isempty(apices_max)
                Q(row,column) = -0.1;
            else
                n = length(apices_min);
                start = [];
                terminate = [];
                count = 0;
                for i = 1:n
                    t1 = apices_min(i);
                    t2 = apices_max(i);
                    dif = y2021(t1) - y2021(t2);
                    
                    if dif >= 0.15
                        start = [start t1];
                        terminate = [terminate t2];
                        count = count+1;
                    end
                end
                
                num = [];
                if count == 0
                    T = 0;
                elseif count == 1
                    [T] = find_harvest(list_time_2021,y2021_WSG,start(1),terminate(1));
                else
                    temp = 0;
                    max_dif = [];
                    start_time = [];
                    for j = 1:count
                         [n,m] = get_observe_point(list_time_2021,start(j),terminate(j));
                         [num,d] = get_max_dif(y2021_WSG,n,m);
                         max_dif = [max_dif num];
                         start_time = [start_time d];
                    end                  
                    k = find(max_dif == max(max_dif),1);
                    k = start_time(k);
                    T = fix((list_time_2021(k)+list_time_2021(k+1)- 738406*2)/2);   
%                       max_dif = [];
%                       start_time = [];
%                       for j = 1:count
%                            [num,d] = get_max_dif(y_dif,start(j),terminate(j));
%                            max_dif = [max_dif num];
%                            start_time = [start_time d];
%                       end
%                       k = find(max_dif == min(max_dif),1);
%                       %k = start_time(k);
%                       [T] = find_harvest(list_time_2021,y2021_WSG,start(k),terminate(k));
                end
                
                Q(row,column) = T;
            end
        end
        
    end
    str=['Completed:','',num2str(round(row*101/(row_down-row_up+1))),'%'];
    waitbar(row*100/(row_down-row_up+1),X,str); %进度条2 
end

imtool(Q/100);
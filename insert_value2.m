 

%生成2020/2021年行列号为（row，column）的插值后的时序数据
% x 代表输入的时序数据集 
% list_time 为时序的影像时间
%row代表行号
%column代表列号
%b表示插值后为滤波的时序数据
 function [y,b] = insert_value2(x,list_time,row,column) 
%  function [y,SG_group] = insert_value2(x,list_time,row,column) 
    %设置参数
    order = 1;
    framelen = 3;
%     row1 = row+714 ;
%     column1 = column+460;
% row1 = row ;
% column1 = column;
%     row1 = row+1778;
%     column1 = column+1691;
%         row1 = row+1537;
%     column1 = column+2020;
    row1 = row + 812 ;
    column1 = column+1518;
%     row1 = row +1099;
%     column1 = column + 1969;
    n1 = length(list_time)+2;
    
    if  n1 > 12
        day = 738407:1:738507;
    else 
        day = 738042:1:738142;
    end
    
    %提取像素点的时序数据
    b = [];
    for i = 3:n1
        b = [b x(row1,column1,i)];
    end
    %将NAN的值变为0,并进行线性插值
    b(isnan(b)) = 0 ;
    k = length(b);
    for  i = 1:k
        if i==1 && b(i)==0 
            b(i) = (double(b(i+2) - b(i+1))/(list_time(i+2)-list_time(i+1)))*(list_time(i)-list_time(i+1)) + b(i+1);
        elseif i < k && b(i)==0
            b(i) = (double(b(i+1) - b(i-1))/(list_time(i+1)-list_time(i-1)))*(list_time(i)-list_time(i-1)) + b(i-1);
        elseif i == k && b(i)==0
            b(i) = (double(b(i-1) - b(i-2))/(list_time(i-1)-list_time(i-2)))*(list_time(i)-list_time(i-1)) + b(i-1);
        else 
            b(i) = b(i);
        end    
    end
    
    SG_group = sgolayfilt(double(b),order,framelen);
    y = interp1(list_time(1:end),SG_group(1:end),day,'spline');
%     b = double(b);
%     y = interp1(list_time(1:end),b(1:end),day,'spline');
%     y = double(y);

end


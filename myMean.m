function [result]=myMean(n);

result = 0;
count = 0;
for i = 1 : 1 : length(n)
    if ( n(i) ~= 0 ) 
        result = result+n(i);
        count = count + 1;
    end
end

result = result/count
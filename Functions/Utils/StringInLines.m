function [ str_lines ] = StringInLines(str, maxLen)
%     str = 'hola que tal amigo como estas yo bien pero atas';
%     maxLen = 10;
    
    [~, strSize] = size(str);
    
    str_lines = {};
    
    if strSize > maxLen
       NLines = strSize/maxLen;
       if mod(strSize, maxLen) ~= 0
            NLines = floor(NLines)+1;
       end
       for l = 1:1:NLines
           if l == NLines
               str_lines = [str_lines {str(maxLen*(l-1)+1:end)}];
           else
               str_lines = [str_lines {str(maxLen*(l-1)+1:maxLen*l)}];
           end
       end
    else
        str_lines = str;
    end

end


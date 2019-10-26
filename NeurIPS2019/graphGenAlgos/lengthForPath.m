function [cp_1_2] = lengthForPath(l) 
% input ********************
% l: height of one side of the binary tree. Based on the article
% l >=3 for a binary tree will suffice p= 2^l - 2 for a double binary tree
% ********************

% output ********************
% cp_1_2 Choose c in the range specified such that cp^(1/2) is an integer
% ********************

% reference ********************
% On the quality of spectral separators 
% https://www.cs.cmu.edu/~glmiller/Publications/GuatteryMiller98.pdf
% ********************

% theorem 6.3
% restrict p to integers of the form 2^k - 2 for k >=4
% 3.5<=c<4
% cp^(1/2) is an integer up to 4 zeros precision
factor = 10e7;
format long

cp_1_2 = 0;
if l < 1
    disp("The height of the binary tree must be at least 3 to proceed. Aborting")
    return
else
    p = 2^(l+1) - 2;
    for c=3.5*factor:1:4*factor
        test = sqrt(p)*c/factor;
        if round(test,5)==floor(test)
            cp_1_2 = floor(test);
            break
        end
    end
    if cp_1_2 == 0
        disp('Unable to find c so that c*p^(1/2) is an integer')
        return
    end
end

end
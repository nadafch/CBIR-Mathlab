function lbpval = lbp(image, R)

if size(image, 3) == 3
    image = rgb2gray(image);
end;
L = 2*R + 1; %% The size of the LBP label
C = round(L/2);

image = uint8(image);
row_max = size(image,1)-L+1;
col_max = size(image,2)-L+1;

tmpval = zeros(row_max, col_max);

for i = 1:row_max
    for j = 1:col_max
        A = image(i:i+L-1, j:j+L-1);
        A = A+1-A(C,C);
        A(A>0) = 1;
        tmpval(i,j) = A(C,L) + A(L,L)*2 + A(L,C)*4 + A(L,1)*8 + A(C,1)*16 + A(1,1)*32 + A(1,C)*64 + A(1,L)*128;
    end;
end;

lbpval = hist(tmpval(:), 255);
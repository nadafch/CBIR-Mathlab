function colorMoments = colorMoment(image)

image = rgb2hsv(image);

H = double(image(:, :, 1));
S = double(image(:, :, 2));
V = double(image(:, :, 3));

H = H(:);
S = S(:);
V = V(:);

meanH = mean(H);
stdH = std(H);
skwH = skewness(H);

meanS = mean(S);
stdS = std(S);
skwS = skewness(S);

meanV = mean(V);
stdV = std(V);
skwV = skewness(V);

colorMoments = zeros(1, 9);
colorMoments(1, :) = [meanH, stdH, skwH, meanS, stdS, skwS, meanV, stdV, skwV];

end
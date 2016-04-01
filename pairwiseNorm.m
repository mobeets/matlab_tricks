function D = pairwiseNorm(X, Y)
% X [n x d]
% Y [m x d]
% returns D [n x m], where D(i,j) = norm(X(i,:) - Y(j,:))
%
    XX = sum(X.*X,2);
    YY = sum(Y'.*Y',1);
    D = XX(:,ones(1,size(Y,1))) + YY(ones(1,size(X,1)),:) - 2*X*Y';
    D = sqrt(D);
end

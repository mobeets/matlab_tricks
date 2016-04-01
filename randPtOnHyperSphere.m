function pts = randPtOnHyperSphere(d, N)
% http://mathworld.wolfram.com/SpherePointPicking.html

    S = normrnd(0, 1, [d, N]);
    pts = bsxfun(@times, S, 1./sqrt(sum(S.^2)))';

%     figure; hold on;
%     for ii = 1:N
%         pt = pts(ii,:);
%         plot(pt(1), pt(2), '.');
%     end

end

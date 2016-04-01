function [Phatfcn, PhatfcnAlt] = ksdensity_nd(Xtrain, h, Kfcn)
% Xtrain [n x d] - training data
% h - bandwidth
% Kfcn - Kernel function (default: RBF) (alt example: @normpdf)
%
% returns:
%     Phatfcn (vectorized, if RBF)
%     Phatfcnalt (for large Xtest)
% 
    if nargin < 2
        h = 1;
    end
    if nargin < 3
        doRBF = true;
    else
        doRBF = false;
    end
    
    if doRBF        
        Phatfcn = @(Xtest) mean(RBFKernel(Xtrain, Xtest, h));
        Phat = @(x) mean(RBFKernel(Xtrain, x, h));
        PhatfcnAlt = blockEvalFcn(Phat, size(Xtrain,1));
        return;
    end

    % super slow version
    K = @(X,h) h^(-size(X,2))*Kfcn(sqrt(sum(X.^2, 2))/h);
    Phat = @(x) mean(K(bsxfun(@plus, Xtrain, -x), h));
    Phatfcn = unvectorizedFcn(Phat);
    PhatfcnAlt = Phatfcn;

end

function fcn = unvectorizedFcn(Phat)
% unvectorized p-hat function
    fcn = @(Xtest) arrayfun(@(ii) Phat(Xtest(ii,:)), 1:size(Xtest,1));
end

function fcn = blockEvalFcn(Phat, nTrPts)
% vectorized p-hat function in blocks
    fcn = @(Xtest) innerBlkEvalFcn(Phat, Xtest, nTrPts);
end

function P = innerBlkEvalFcn(Phat, pts, nTrPts)

    maxArrSize = 1e5;
    curArrSize = size(pts,1)*nTrPts;
    nbins = ceil(curArrSize/maxArrSize);
    
    P = nan(size(pts,1),1);
    bins = round(linspace(1, size(pts,1), nbins));
    for ii = 1:nbins-1
        inds = bins(ii):bins(ii+1);
        if ii < nbins-1
            inds = inds(1:end-1);
        end
        P(inds) = Phat(pts(inds,:));
    end

end

function K = RBFKernel(X1, X2, h, sig)
    if nargin < 3
        h = 1;
    end
    if nargin < 4
%         sig = 1; % standard RBF
        sig = 1/(sqrt(2*pi)*h); % yields normpdf
    end
    
    K = normpdf(pairwiseNorm(X1, X2), 0, h);    
    K = K*(sqrt(2*pi)*h)*sig;

end

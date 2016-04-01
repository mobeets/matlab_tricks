function C = randCovariance(d)
% http://math.stackexchange.com/a/358092/116525

    C = rand(d);
    C = C + C' + d*eye(d);

end

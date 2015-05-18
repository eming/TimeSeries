function [U,V,J]=myFcm(X,t,c,m)

% [U,V,J]=fcm(X,t,c,m)
%
% fuzzy c-means clustering
%
% U = membership matrix
% V = cluster centers
% J(1:t) = objective function values for each update step
%
% X = data set
% t = number of iterations
% c = number of clusters
% m = fuzziness index (e.g. 2)
%
% (c) Siemens AG, Thomas Runkler

[n,p]=size(X);
imm=m-1;
mm=1/imm;
J=zeros(1,t);

% initializations
U=rand(c,n);
U=U./(ones(c,1)*sum(U));
V=zeros(c,p);
D=zeros(c,n);

for tt=1:t

    % compute cluster centers
    for i=1:c
        if sum(U(i,:))
            V(i,:)=sum((U(i,:)'.^m)*ones(1,p).*X)/sum(U(i,:).^m);
        else
            V(i,:)=zeros(1,p);
        end
    end

    % compute modified distance matrix D
    for i=1:c
        D(i,:)=sum((X-ones(n,1)*V(i,:)).^2,2)'.^mm;
    end

    % compute memberships
    % U=1./D./(ones(c,1)*sum(1./D));
    for k=1:n
        z=(D(:,k)<eps);
        if max(z)==0
            U(:,k)=1./D(:,k)/sum(1./D(:,k));
        else
            U(:,k)=z/sum(z);
        end
    end

    % compute objective function

    % J(tt)=sum(sum(U.^m.*D.^imm));
    J(tt)=sum(sum(U.^m.*D));
end


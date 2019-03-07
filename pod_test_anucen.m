function failed = pod_test_anucen(snapshot_file,my_index)
close all;

if nargin==0 || nargin>2
    error('One or two arguments must be specified');
end
if nargin==1
    warning('The first train point is used for testing the ROM');
    my_index=1;
end

% to store the index of the failed points
failed = zeros(2,1);

% T/F: whether to compute Keff at the becnhmark nominal value (as a sanity check)
solve_nominal_eigenproblem = false;

% T/F: whether to plot the singular values
plot_singular_values = false;

% loads:
%    m: number of materials
%    n: number of unknowns (all groups)
%    nnz_: number of nonzeros in the final group-wise matrix
%    R: Robin boundary condition matrix (1 matrix)
%    M: mass matrix per unit cross section, per material (m matrices)
%    S: stiffmess matrix per unit cross section, per material (m matrices)
%    S: stiffmess matrix per unit cross section, per material (m matrices)
load FEM_matrices.mat;
% load FEM_matrices_ref1.mat;

% loads:
%    xs: benchmark cross section (nominal values)
load nominal_xs.mat

%% compute Keff at the becnhmark nominal value (as a sanity check)
if solve_nominal_eigenproblem
    % build single system matrix
    [A,B] = build_full_system_matrix(m,n,nnz_,R,M,S,xs);
    [eigenvect_nominal,eigenval_nominal]=eigs(B,A,1);
    fprintf('Keff with nominal xs values: Keff=%g\n',eigenval_nominal);
end

%% reload snapshots
load(snapshot_file);
n_snapshots = length(lambda);

%% compute POD modes using multigroup snapshots
[U,L,V]=svd(eigenvect,0);
if plot_singular_values
    figure;
    semilogy(sort(diag(L),'descend'),'+-'); hold all;
end

%% pick one training set xs for testing
% build single system matrix for the selected xs database
xs=db{my_index};
[A,B]=build_full_system_matrix(m,n,nnz_,R,M,S,xs);
for imat=1:length(xs)
    if(xs{imat}.sigr(1)<xs{imat}.sigs)
        fprintf('\nTraining data point: %d\n',my_index);
        fprintf('material %d, sigr1 %d, sigs %d, %d\n',imat,xs{imat}.sigr(1),xs{imat}.sigs,abs(xs{imat}.sigr(1)-xs{imat}.sigs)/max(xs{imat}.sigr(1),xs{imat}.sigs));
    end
end
%% ROM using full MG modes
% U from eigpb
Ar = U'*A*U;
Br = U'*B*U;
[ev_mg1,val_mg1]=eig(Br,Ar);
keff_mg1=max(diag(val_mg1));
% diag(val_mg1)
% sort(abs(diag(val_mg1)));
c=U'*eigenvect(:,my_index);
% for k=1:10
%     ev_mg1(:,k)./c
% end

%% compute group-wise POD modes using multigroup snapshots
[U1,L1,V1]=svd(eigenvect(1:n    ,:),0);
[U2,L2,V2]=svd(eigenvect(n+1:2*n,:),0);
if plot_singular_values
    semilogy(sort(diag(L1),'descend'),'o-');
    semilogy(sort(diag(L2),'descend'),'x-');
end

%% ROM per group
U=[U1 zeros(size(U1)); zeros(size(U2)) U2];
Ar = U'*A*U;
Br = U'*B*U;
[ev_mg2,val_mg2]=eig(Br,Ar);
keff_mg2=max(diag(val_mg2));
% diag(val_mg2)
% sort(abs(diag(val_mg2)));

%% summary
fprintf('\nTraining data point: %d\n',my_index);

fprintf('FOM   Keff = %g\n',lambda(my_index));

fprintf('ROM-1 Keff = %g\n',keff_mg1);
delta=(keff_mg1-lambda(my_index))*1e5;
fprintf('  Delta(pcm) = %g',delta);
if abs(delta)>10
    fprintf('=====Error is too large=====\n');
    failed(1)=my_index;
else
    fprintf('\n');
end

fprintf('ROM-2 Keff = %g\n',keff_mg2);
delta=(keff_mg2-lambda(my_index))*1e5;
fprintf('  Delta(pcm) = %g',delta);
if abs(delta)>10
    fprintf('=====Error is too large=====\n');
    failed(2)=my_index;
else
    fprintf('\n');
end

return
end


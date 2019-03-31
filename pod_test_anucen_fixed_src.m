function failed = pod_test_anucen_fixed_src(snapshot_file,my_index)
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
%    Q: rhs fixed source vector, per material (m vectors)
load FEM_matrices_fixed_src.mat;
% load FEM_matrices_ref1.mat;

% loads:
%    xs: benchmark cross section (nominal values)
load nominal_xs_fixed_src.mat

%% reload snapshots
load(snapshot_file);
n_snapshots = length(sol(1,:));

%% compute POD modes using multigroup snapshots
[U,L,V]=svd(sol,0);
if plot_singular_values
    figure;
    semilogy(sort(diag(L),'descend'),'+-'); hold all;
end

%% pick one training set xs for testing
% build single system matrix for the selected xs database
xs=db{my_index};
[A,b]=build_full_system_matrix_fixed_src(m,n,nnz_,R,M,S,Q,xs);
for imat=1:length(xs)
    if(xs{imat}.sigr(1)<xs{imat}.sigs)
        fprintf('\nTraining data point: %d\n',my_index);
        fprintf('material %d, sigr1 %d, sigs %d, %d\n',imat,xs{imat}.sigr(1),xs{imat}.sigs,abs(xs{imat}.sigr(1)-xs{imat}.sigs)/max(xs{imat}.sigr(1),xs{imat}.sigs));
    end
end
%% ROM using full MG modes
% uncommenthing these lines does not change the answer
% so, for fixed source problem, one can use U as is and solve a
% group-collapsed ROM
% U1=U(1:n,:);                                     
% U2=U(n+1:2*n,:);                                 
% U=[U1 zeros(size(U1)); zeros(size(U2)) U2];      
Ar = U'*A*U;
br = U'*b;
xr1=Ar\br;
x1=U*xr1;
c=U'*sol(:,my_index);

%% compute group-wise POD modes using multigroup snapshots
[U1,L1,V1]=svd(sol(1:n    ,:),0);
[U2,L2,V2]=svd(sol(n+1:2*n,:),0);
if plot_singular_values
    semilogy(sort(diag(L1),'descend'),'o-');
    semilogy(sort(diag(L2),'descend'),'x-');
end

%% ROM per group
U=[U1 zeros(size(U1)); zeros(size(U2)) U2];
Ar = U'*A*U;
br = U'*b;
xr2=Ar\br;
x2=U*xr2;


%% summary
fprintf('\nTraining data point: %d\n',my_index);

mm=1000;
fprintf('FOM   Val = %g\n',sol(mm,my_index));

fprintf('ROM-1 Val = %g\n',x1(mm));
delta=norm(x1-sol(:,my_index));
fprintf('  Delta = %g',delta);
if abs(delta)>1e-4
    fprintf('=====Error is too large=====\n');
    failed(1)=my_index;
else
    fprintf('\n');
end
delta_mono=delta;

fprintf('ROM-2 Val = %g\n',x2(mm));
delta=norm(x1-sol(:,my_index));
fprintf('  Delta = %g',delta);
if abs(delta)>1e-4
    fprintf('=====Error is too large=====\n');
    failed(2)=my_index;
else
    fprintf('\n');
end
delta_gw=delta;

% fprintf('%d %s %3.1f %s %3.1f %s \n',my_index,' & ', delta_gw,' & ',delta_mono,' \\ ');

return
end


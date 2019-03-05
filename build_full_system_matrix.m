function [A,B]=build_full_system_matrix(nmat,ndofs,nnz_,R,M,S,xs)
% build full system matrix using the FEM matrices per material zone and the
% passed-in material properties (xs)
% R= Robin BC matrix (1)
% M= cell of unit mass matrices (nmat)
% S= cell of unit stifness matrices (nmat)
% nmat = number of materail
% ndofs = number of degrees of freedom (per energy group)
% nnz_ = number of non-zeros entries per group

A=spalloc(2*ndofs,2*ndofs,3*nnz_);
B=A;
% diagonal group 1/2
for g=1:2
    if g==1
        i1=1;i2=ndofs;
    else
        i1=ndofs+1;i2=2*ndofs;
    end
    A(i1:i2,i1:i2)=R;
    for im=1:nmat
        A(i1:i2,i1:i2)=A(i1:i2,i1:i2) + xs{im}.cdif(g)*S{im} ...
                                      + xs{im}.sigr(g)*M{im};
    end
end
% downscattering
i1=ndofs+1;i2=2*ndofs;
j1=1;j2=ndofs;
for im=1:nmat
    A(i1:i2,j1:j2)=A(i1:i2,j1:j2) - xs{im}.sigs*M{im};
end
% fission
i1=1;i2=ndofs;
j1=ndofs+1;j2=2*ndofs;
for im=1:nmat
    B(i1:i2,j1:j2)=B(i1:i2,j1:j2) + xs{im}.sigf(2)*M{im};
end

return
end

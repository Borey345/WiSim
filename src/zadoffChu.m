function sequence = zadoffChu( u_column, N_zc )

n = 0:(N_zc-1);
sequence = exp( (-1i.*pi.* bsxfun(@times, u_column, (n.*(n+1)) ) )./N_zc  ); 

end


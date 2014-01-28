%-------------------Simulator of MIMO system M*N-antennaes------------------%
%-------------------------The function for demapper-------------------------%
function [a_new] = demodulator1(r,H,Modulation)
if (Modulation == 1) % BPSK
    
    r = real(r);
    %r = r.*H;
    
    z = limits( r );
    
    %z = reshape(z,1,[]);
    a_new = z;
end
if (Modulation == 2) % QPSK
    
%     for i=1:64
%         r(i,:) = r(i,:)*(abs( H(i) )^2);
%     end
    inPhase = real( sqrt(2)*r ); 
    quadrature = imag( sqrt(2)*r ); 
    inPhase = reshape( inPhase, 1, [] );
    quadrature = reshape( quadrature, 1, [] );
    a_new = [inPhase; quadrature];
    a_new = reshape( a_new, 1, [] );
    %a_new = a_new.*H;
    a_new = limits( a_new );

end
if (Modulation == 4) % 16_QAM
    inPhase = real( sqrt(10)*r ); 
    quadrature = imag( sqrt(10)*r );
    
    inPhaseBit1 = zeros( 1, size( r, 2 ));
    
    for i=1:size( r, 2 )
        if inPhase( 1, i ) > 2
            inPhaseBit1( 1, i ) = 2*( inPhase( 1, i ) - 1 );
        else if inPhase( 1, i ) < -2
                inPhaseBit1( 1, i ) = 2*( inPhase( 1, i ) + 1 );
            else
                inPhaseBit1( 1, i ) = inPhase( 1, i );
            end
        end
    end
    
    quadratureBit1 = zeros( 1, size( r, 2 ) );
    for i=1:size( r, 2 )
        if quadrature( 1, i ) > 2
            quadratureBit1( 1, i ) = 2*( quadrature( 1, i ) - 1 );
        else if quadrature( 1, i ) < -2
                quadratureBit1( 1, i ) = 2*( quadrature( 1, i ) + 1 );
            else
                quadratureBit1( 1, i ) = quadrature( 1, i );
            end
        end
    end
    
    inPhaseBit2 = -abs( inPhase ) + 2;
    quadratureBit2 = -abs( quadrature ) + 2;
    
%     inPhaseBit1 = limits( inPhaseBit1 );
%     inPhaseBit2 = limits( inPhaseBit2 );
%     quadratureBit1 = limits( quadratureBit1 );
%     quadratureBit2 = limits( quadratureBit2 );
    quadrature = [inPhaseBit1; inPhaseBit2; quadratureBit1; quadratureBit2 ];
    a_new = reshape( quadrature, 1, [] );
    a_new = a_new.*H/4;
    a_new = limits( a_new );
    
end
if (Modulation == 6) % 64_QAM
    inPhase = real( sqrt( 42 )*r );
    quadrature = imag( sqrt( 42 )*r );
    
    inSize = size( inPhase, 2 );
    
    inPhaseBit1 = zeros( inSize, 1 );
    inPhaseBit2 = zeros( inSize, 1 );
    inPhaseBit3 = zeros( inSize, 1 );
    quadratureBit1 = zeros( inSize, 1 );
    quadratureBit2 = zeros( inSize, 1 );
    quadratureBit3 = zeros( inSize, 1 );    
    
    for i = 1:inSize
        inPhaseSample = inPhase( 1, i );
        
        inPhaseBit1(i) = qam64SoftDemod1( inPhaseSample );
        inPhaseBit2(i) = qam64SoftDemod2( inPhaseSample );
        inPhaseBit3(i) = qam64SoftDemod3( inPhaseSample );
        
        quadSample = quadrature( 1, i );
        
        quadratureBit1(i) = qam64SoftDemod1( quadSample );
        quadratureBit2(i) = qam64SoftDemod2( quadSample );
        quadratureBit3(i) = qam64SoftDemod3( quadSample );
    end
    
    a_new = [ inPhaseBit1'; inPhaseBit2'; inPhaseBit3'; ...
        quadratureBit1'; quadratureBit2'; quadratureBit3' ];
    a_new = reshape( a_new, 1, [] );
    a_new = a_new.*H/4;
    a_new = limits( a_new );
    
end
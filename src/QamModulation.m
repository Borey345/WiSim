classdef QamModulation
    properties(Constant)
        MODULATION_BPSK = 1;
        MODULATION_QPSK = 2;
        MODULATION_16QAM = 3;
        MODULATION_64QAM = 4;
        
        NORMALIZE_COEFFICIENT_BPSK = 1/sqrt(2);
        NORMALIZE_COEFFICIENT_16QAM = sqrt(10);
    end
    
    properties(Access=private)
        modulation = QamModulation.MODULATION_BPSK;
        isSoft = 0;
    end
    
    methods
        
        function obj = QamModulation(modulation)
            obj.modulation = modulation;
        end
        
        function signal = modulate(obj, bitStream)
            switch(obj.modulation)
                case QamModulation.MODULATION_BPSK
                    signal=(2*bitStream-1);
                case QamModulation.MODULATION_QPSK
                   bitStream = reshape(bitStream, 2,[]);
                   b=bitStream(1,:);
                   c=bitStream(2,:);
                   signal=( (2*b-1) + 1i*(2*c-1) );
                   signal=signal*QamModulation.NORMALIZE_COEFFICIENT_BPSK;
                case QamModulation.MODULATION_16QAM
                   bitStream = reshape(bitStream,4,[]);
                   b=bitStream(1,:);
                   c=bitStream(2,:);
                   d=bitStream(3,:);
                   e=bitStream(4,:);
                   z=2*d+e;
                   y=2*b+c;
                   signal=((-4/3)*(y.^3)+5*(y.^2)-(5/3)*y-3)+1i*((-4/3)*(z.^3)+5*(z.^2)-(5/3)*z-3);
                   signal=signal/sqrt(10);
                case QamModulation.MODULATION_64QAM
                   bitStream = reshape(bitStream,6,[]);
                   b=bitStream(1,:);
                   c=bitStream(2,:);
                   d=bitStream(3,:);
                   e=bitStream(4,:);
                   g=bitStream(5,:);
                   h=bitStream(6,:);
                   x=4*b+2*c+d;
                   y=4*e+2*g+h;
                   f_real=-0.0508*x.^7+1.2667*x.^6-12.4556*x.^5+61.0833*x.^4-155.1556*x.^3+189.6500*x.^2-82.3381*x-7;
                   f_imag=-0.0508*y.^7+1.2667*y.^6-12.4556*y.^5+61.0833*y.^4-155.1556*y.^3+189.6500*y.^2-82.3381*y-7;
                   sz = size(f_real);
                   for jj=1:sz(1,2)
                       if (f_real(1,jj) >= 0.8504 && f_real(1,jj) <= 0.8506)
                           f_real(1,jj) = 3;
                       end
                       if (f_imag(1,jj) >= 0.8504 && f_imag(1,jj) <= 0.8506)
                           f_imag(1,jj) = 3;
                       end
                   end
                   signal=f_real+1i*f_imag;
                   signal=ceil(signal);
                   signal=signal/sqrt(42);
               otherwise
                   error('Unknown modulation');
            end
        end
        
        
        
        function bitStream = demodulate(obj, signal,H)
            switch obj.modulation
                case QamModulation.MODULATION_BPSK
                    signal = real(signal);
                    z = limits( signal );
                    bitStream = z;
                case QamModulation.MODULATION_QPSK
                    inPhase = real( sqrt(2)*signal ); 
                    quadrature = imag( sqrt(2)*signal ); 
                    inPhase = reshape( inPhase, 1, [] );
                    quadrature = reshape( quadrature, 1, [] );
                    bitStream = [inPhase; quadrature];
                    bitStream = reshape( bitStream, 1, [] );
                    bitStream = limits( bitStream );

                case QamModulation.MODULATION_16QAM
                    inPhase = sqrt(10)*real( signal ); 
                    quadrature = sqrt(10)*imag( signal );

                    inPhaseQuadrature = [inPhase; quadrature];
                    bit1Array = inPhaseQuadrature;

                    moreThan2 = bit1Array > 2;
                    bit1Array(moreThan2) = 2*( bit1Array(moreThan2) - 1 );
                    lessThan2 = bit1Array < -2;
                    bit1Array(lessThan2) = 2*( bit1Array(lessThan2) + 1);

                    bit2Array = inPhaseQuadrature;
                    bit2Array = -abs( bit2Array ) + 2;
                    bitStream = [bit1Array(1,:); bit2Array(1,:); bit1Array(2,:); bit2Array(2, :)];
                    bitStream = reshape( bitStream, 1, [] );
                    bitStream = bitStream.*H/4;
                    bitStream = QamModulation.limits( bitStream );

                case QamModulation.MODULATION_64QAM
                    inPhase = real( sqrt( 42 )*signal );
                    quadrature = imag( sqrt( 42 )*signal );

                    inPhaseBit = QamModulation.qam64SoftDemod(inPhase);
                    quadratureBit = QamModulation.qam64SoftDemod(quadrature);

                    bitStream = [inPhaseBit; quadratureBit];
                    bitStream = reshape( bitStream, 1, [] );
                    bitStream = bitStream.*H/4;
                    bitStream = QamModulation.limits( bitStream );
                otherwise
                    error('Unknown modulation')
            end
        end
    end
    
    methods(Static)
        function out = limits( in )

            out = floor( (7/2)*( in + 1 ) + 0.5 );
            out(out > 7) = 7;
            out(out < 0) = 0;
        end
        
        function out = qam64SoftDemod(in)
            out = zeros(3, size(in, 2));

            currentDiapasonValuesIndices = in > 6;
            currentDiapasonValues = in(currentDiapasonValuesIndices);
            out(1, currentDiapasonValuesIndices) = 4*(currentDiapasonValues - 3 );
            out(2, currentDiapasonValuesIndices) = 2*( -currentDiapasonValues + 5 );
            out(3, currentDiapasonValuesIndices) = -currentDiapasonValues + 6;
            
            currentDiapasonValuesIndices = in < -6;
            currentDiapasonValues = in(currentDiapasonValuesIndices);
            out(1, currentDiapasonValuesIndices) = 4*(currentDiapasonValues + 3 );
            out(2, currentDiapasonValuesIndices) = 2*( currentDiapasonValues + 5 );
            out(3, currentDiapasonValuesIndices) = currentDiapasonValues + 6;

            currentDiapasonValuesIndices = (in > 4) & (in <= 6);
            currentDiapasonValues = in(currentDiapasonValuesIndices);
            out(1, currentDiapasonValuesIndices) = 3*(currentDiapasonValues - 2 );
            out(2, currentDiapasonValuesIndices) = 4 - currentDiapasonValues;
            out(3, currentDiapasonValuesIndices) = -currentDiapasonValues + 6;
            
            currentDiapasonValuesIndices = (in >= -6) & (in < -4);
            currentDiapasonValues = in(currentDiapasonValuesIndices);
            out(1, currentDiapasonValuesIndices) = 3*(currentDiapasonValues + 2 );
            out(2, currentDiapasonValuesIndices) = 4 + currentDiapasonValues;
            out(3, currentDiapasonValuesIndices) = currentDiapasonValues + 6;
            
            currentDiapasonValuesIndices = (in > 2) & (in <= 4 );
            currentDiapasonValues = in(currentDiapasonValuesIndices);
            out(1, currentDiapasonValuesIndices) = 2*(currentDiapasonValues - 1 );
            out(2, currentDiapasonValuesIndices) = 4 - currentDiapasonValues;
            out(3, currentDiapasonValuesIndices) = currentDiapasonValues - 2;
            
            currentDiapasonValuesIndices = (in >= -4) & (in < -2 );
            currentDiapasonValues = in(currentDiapasonValuesIndices);
            out(1, currentDiapasonValuesIndices) = 2*(currentDiapasonValues + 1 );
            out(2, currentDiapasonValuesIndices) = 4 + currentDiapasonValues;
            out(3, currentDiapasonValuesIndices) = -currentDiapasonValues - 2;
            
            currentDiapasonValuesIndices = (in >= -2) & (in <= 2 );
            currentDiapasonValues = in(currentDiapasonValuesIndices);
            out(1, currentDiapasonValuesIndices) = currentDiapasonValues;
            out(2, currentDiapasonValuesIndices) =  2*( -abs(currentDiapasonValues) + 3 );
            out(3, currentDiapasonValuesIndices) = abs(currentDiapasonValues) - 2;
        end
        
        function modulationType = nModulatedBitsToModulationType(nModulatedBits)
            switch nModulatedBits
                case 1
                    modulationType = QamModulation.MODULATION_BPSK;
                case 2
                    modulationType = QamModulation.MODULATION_QPSK;
                case 4
                    modulationType = QamModulation.MODULATION_16QAM;
                case 6
                    modulationType = QamModulation.MODULATION_64QAM;
                otherwise
                    error('Unknown modulation');
            end
                    
        end
    end
    
end
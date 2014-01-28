%-------------------Simulator of MIMO system M*N-antennaes------------------%
%-------------------------The function for demapper-------------------------%
function [a_new] = demapper(r,Modulation)
if (Modulation == 1) % BPSK
    z = sign(real(r));
    z = reshape(z,1,[]);
    a_new = (1+z)/2;
end
if (Modulation == 2) % QPSK
    z_1 = sign(real(sqrt(2)*r));
    z_1 = reshape(z_1,1,[]);
    z_0 = sign(imag(sqrt(2)*r));
    z_0 = reshape(z_0,1,[]);
    a_1 = (1+z_1)/2;
    a_0 = (1+z_0)/2;
    a_new = [a_1;a_0];
    a_new = reshape(a_new,1,[]);
end
if (Modulation == 4) % 16_QAM
    z_0 = sign(real(sqrt(10)*r));
    z_0 = reshape(z_0,1,[]);
    z_1 = sign(2-abs(real(sqrt(10)*r)));
    z_1 = reshape(z_1,1,[]);
    z_2 = sign(imag(sqrt(10)*r));
    z_2 = reshape(z_2,1,[]);
    z_3 = sign(2-abs(imag(sqrt(10)*r)));
    z_3 = reshape(z_3,1,[]);
    a_0 = (1+z_0)/2;
    a_1 = (1+z_1)/2;
    a_2 = (1+z_2)/2;
    a_3 = (1+z_3)/2;
    a_new = [a_0;a_1;a_2;a_3];
    a_new = reshape(a_new,1,[]);
end
if (Modulation == 6) % 64_QAM
                DM = r;
                DM = DM * sqrt(42);
            for ss = 1:size(DM,1)
                DS = DM(ss,:);
                
                D000000 = (-7-7j-DS) .* conj(-7-7j-DS);
                D001000 = (-5-7j-DS) .* conj(-5-7j-DS);
                D011000 = (-3-7j-DS) .* conj(-3-7j-DS);
                D010000 = (-1-7j-DS) .* conj(-1-7j-DS);
                D110000 = (+1-7j-DS) .* conj(+1-7j-DS);
                D111000 = (+3-7j-DS) .* conj(+3-7j-DS);
                D101000 = (+5-7j-DS) .* conj(+5-7j-DS);
                D100000 = (+7-7j-DS) .* conj(+7-7j-DS);
                
                D000001 = (-7-5j-DS) .* conj(-7-5j-DS);
                D001001 = (-5-5j-DS) .* conj(-5-5j-DS);
                D011001 = (-3-5j-DS) .* conj(-3-5j-DS);
                D010001 = (-1-5j-DS) .* conj(-1-5j-DS);
                D110001 = (+1-5j-DS) .* conj(+1-5j-DS);
                D111001 = (+3-5j-DS) .* conj(+3-5j-DS);
                D101001 = (+5-5j-DS) .* conj(+5-5j-DS);
                D100001 = (+7-5j-DS) .* conj(+7-5j-DS);
                
                D000011 = (-7-3j-DS) .* conj(-7-3j-DS);
                D001011 = (-5-3j-DS) .* conj(-5-3j-DS);
                D011011 = (-3-3j-DS) .* conj(-3-3j-DS);
                D010011 = (-1-3j-DS) .* conj(-1-3j-DS);
                D110011 = (+1-3j-DS) .* conj(+1-3j-DS);
                D111011 = (+3-3j-DS) .* conj(+3-3j-DS);
                D101011 = (+5-3j-DS) .* conj(+5-3j-DS);
                D100011 = (+7-3j-DS) .* conj(+7-3j-DS);
                
                D000010 = (-7-1j-DS) .* conj(-7-1j-DS);
                D001010 = (-5-1j-DS) .* conj(-5-1j-DS);
                D011010 = (-3-1j-DS) .* conj(-3-1j-DS);
                D010010 = (-1-1j-DS) .* conj(-1-1j-DS);
                D110010 = (+1-1j-DS) .* conj(+1-1j-DS);
                D111010 = (+3-1j-DS) .* conj(+3-1j-DS);
                D101010 = (+5-1j-DS) .* conj(+5-1j-DS);
                D100010 = (+7-1j-DS) .* conj(+7-1j-DS);
                 
                D000110 = (-7+1j-DS) .* conj(-7+1j-DS);
                D001110 = (-5+1j-DS) .* conj(-5+1j-DS);
                D011110 = (-3+1j-DS) .* conj(-3+1j-DS);
                D010110 = (-1+1j-DS) .* conj(-1+1j-DS);
                D110110 = (+1+1j-DS) .* conj(+1+1j-DS);
                D111110 = (+3+1j-DS) .* conj(+3+1j-DS);
                D101110 = (+5+1j-DS) .* conj(+5+1j-DS);
                D100110 = (+7+1j-DS) .* conj(+7+1j-DS);
                 
                D000111 = (-7+3j-DS) .* conj(-7+3j-DS);
                D001111 = (-5+3j-DS) .* conj(-5+3j-DS);
                D011111 = (-3+3j-DS) .* conj(-3+3j-DS);
                D010111 = (-1+3j-DS) .* conj(-1+3j-DS);
                D110111 = (+1+3j-DS) .* conj(+1+3j-DS);
                D111111 = (+3+3j-DS) .* conj(+3+3j-DS);
                D101111 = (+5+3j-DS) .* conj(+5+3j-DS);
                D100111 = (+7+3j-DS) .* conj(+7+3j-DS);
                
                D000101 = (-7+5j-DS) .* conj(-7+5j-DS);
                D001101 = (-5+5j-DS) .* conj(-5+5j-DS);
                D011101 = (-3+5j-DS) .* conj(-3+5j-DS);
                D010101 = (-1+5j-DS) .* conj(-1+5j-DS);
                D110101 = (+1+5j-DS) .* conj(+1+5j-DS);
                D111101 = (+3+5j-DS) .* conj(+3+5j-DS);
                D101101 = (+5+5j-DS) .* conj(+5+5j-DS);
                D100101 = (+7+5j-DS) .* conj(+7+5j-DS);
                
                D000100 = (-7+7j-DS) .* conj(-7+7j-DS);
                D001100 = (-5+7j-DS) .* conj(-5+7j-DS);
                D011100 = (-3+7j-DS) .* conj(-3+7j-DS);
                D010100 = (-1+7j-DS) .* conj(-1+7j-DS);
                D110100 = (+1+7j-DS) .* conj(+1+7j-DS);
                D111100 = (+3+7j-DS) .* conj(+3+7j-DS);
                D101100 = (+5+7j-DS) .* conj(+5+7j-DS);
                D100100 = (+7+7j-DS) .* conj(+7+7j-DS);
                
                [C,symbols] = min([D000000; D001000; D011000; D010000; D110000; D111000; D101000; D100000;...
                                   D000001; D001001; D011001; D010001; D110001; D111001; D101001; D100001;... 
                                   D000011; D001011; D011011; D010011; D110011; D111011; D101011; D100011;... 
                                   D000010; D001010; D011010; D010010; D110010; D111010; D101010; D100010;... 
                                   D000110; D001110; D011110; D010110; D110110; D111110; D101110; D100110;...                           
                                   D000111; D001111; D011111; D010111; D110111; D111111; D101111; D100111;...
                                   D000101; D001101; D011101; D010101; D110101; D111101; D101101; D100101;...
                                   D000100; D001100; D011100; D010100; D110100; D111100; D101100; D100100]);

                b6 = double(rem(symbols,8)>4) + double(rem(symbols,8)==0);
                b5 = double(rem(symbols,8)>=3).*double(rem(symbols,8)<=6);
                b4 = double(rem(symbols,8)==2) + double(rem(symbols,8)==3) + double(rem(symbols,8)==6) + double(rem(symbols,8)==7);
                b3 = double(symbols>32);
                b2 = double(symbols>16).*double(symbols<49);
                b1 = double(symbols>=9).*double(symbols<=24) + double(symbols>=41).*double(symbols<=56);
                
                D(ss,1:length(symbols)*6) = reshape([b6; b5; b4; b3; b2; b1],1,length(symbols)*6);            
            end
             a_new = D;
    end

end



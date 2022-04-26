function Br_delay= SEMI_spec_chan_derive_delay(mag, phase, delay, AOA, ZOA, position_elements_nor, L, N, M, Nt)
%Nt   % number of transmit antennas
%Nr   % number of receive antennas
%L    % channel order
%N    % number of TCs
%M    % number of sub-paths per TC 

    Br_delay_tmp = zeros(N,M,L,Nt);
    for jj = 1 : Nt
        for nn = 1 : N
            for mm = 1 : M
                for l = 1 : L
                    r_x = sin(ZOA(nn,mm,jj)) * cos(AOA(nn,mm,jj));
                    r_y = sin(ZOA(nn,mm,jj)) * sin(AOA(nn,mm,jj));
                    r_z = cos(ZOA(nn,mm,jj));
                    Br_delay_tmp(nn,mm,l,jj) = mag(nn,mm,jj)* exp(1i * phase(nn,mm,jj)) ...
                        * ((sin((l-1)-delay(nn,mm,jj))/(((l-1)-delay(nn,mm,jj))^2))...
                           -(cos((l-1)-delay(nn,mm,jj))/((l-1)-delay(nn,mm,jj)))) ...
                        * exp(-1i*2*pi*(position_elements_nor(1)*r_x + position_elements_nor(2)*r_y + position_elements_nor(3)*r_z));
                end
            end
        end
    end
    
    Br_delay_tmp0 = cell(Nt, N);
    for nt = 1 : Nt
        for nn = 1 : N
            Br_delay_tmp0{nt, nn} = squeeze(Br_delay_tmp(nn,:,:,nt));
        end
    end
    
    Br_delay_tmp1 = cell(1,Nt);
    for nt = 1 : Nt
        Br_delay_tmp1{1, nt} = blkdiag(Br_delay_tmp0{nt,:});
    end
    
    Br_delay = blkdiag(Br_delay_tmp1{:});
end


function [AC,BC,AD,BD]=parseSelection(III,V)
if length(III) > 2
    if length(V) > 2
        %quaternary A_(x)B_(1-x)C_(y)D_(1-y)
        AC=strcat(III(1:2),V(1:2));
        BC=strcat(III(7:8),V(1:2));
        if length(V) == 14 
            %eg: AlGaAsSb (no P)
            AD=strcat(III(1:2),V(7:8));
            BD=strcat(III(7:8),V(7:8));
        else
            %eg: AlGaAsP
            AD=strcat(III(1:2),V(7));
            BD=strcat(III(7:8),V(7));
        end
    else
        %ternary A_(x)B_(1-x)C
        AC=strcat(III(1:2),V);
        AD='';
        BC=strcat(III(7:8),V);
        BD='';
    end
else
    if length(V) > 2
        %ternary AC_(y)D_(1-y)
        if length(V) == 14 
            %eg: GaAsSb (no P)
            AC=strcat(III,V(1:2));
            AD=strcat(III,V(7:8));
        else
            %eg: GaAsP
            AC=strcat(III,V(1:2));
            AD=strcat(III,V(7));
        end
        BC='';
        BD='';
    else
        %binary AC
        AC=strcat(III,V);
        AD='';
        BC='';
        BD='';
    end
end
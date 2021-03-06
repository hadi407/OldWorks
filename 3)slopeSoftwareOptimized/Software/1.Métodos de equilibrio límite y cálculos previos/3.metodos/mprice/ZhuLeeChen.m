function [FS,lambda,num,den] = ZhuLeeChen(alfa,pasovector,fi,R,T,f)
% Esta funcion forma parte de la funcion mMorgPri. Esta calcula el FS de
% Mogenstern-Price por el m�todo de Zhu, Lee y Chen.
% Inputs
% alfa,pasovector,fi: Imputs de la duncion mMorgPri
% R,T,f: Variable calculada en la funcion mMorgPri
% Outputs
% FS: FS en la iteracion i por el m�todo de Morgenster-Price
% lambda: Factor de correcci�n en la iteraci�n i.
% num,den: numerador y denominador del cociente FS=num/den.
%
%
%
%
% Definicion de variables necesarias
toleranciaMP=0.0001;
FS(1)=1;lambda(1)=0;
contadorFS=1;contadorlambda=1;
errorFS=1;errorlambda=1;
        while (errorFS>=toleranciaMP || errorlambda>=toleranciaMP )
         if contadorFS>=20
             FS=nan;lambda=nan;
         break
         end       
                contadorFS=contadorFS+1;
                
            for j=1:2
                 % FI (FI1....FIn)
                 fsinfo=f;fsinfo(1)=[];   
                 FI=(sind(alfa)-lambda(end)*fsinfo.*cosd(alfa))...
                      *tand(fi)+(cosd(alfa)+lambda(end)*fsinfo...
                      .*sind(alfa))*FS(end);                    
                % PSI  (PSI1....PSI(n-1))
                fsinfofn=fsinfo; fsinfofn(end)=[];
                asint1=alfa;asint1(1)=[];
                FIsinFIn=FI;FIsinFIn(end)=[];
  
                PSI=((sind(asint1)-lambda(end)*fsinfofn.*cosd(asint1))...
                    *tand(fi)+(cosd(asint1)+lambda(end)...
                    *fsinfofn.*sind(asint1))*FS(end))./FIsinFIn;
                % FS
                N=length(alfa); %N rebanadas; 
                numi=zeros(1,N-1);deni=zeros(1,N-1);  
                for i=1:N-1
                    prodPSI=prod(PSI(i:end));
                 % numerador
                    numi(i)=R(i)*prodPSI;
                 % denominador
                    deni(i)=T(i)*prodPSI;
                end
                num=sum(numi)+R(end);den=sum(deni)+T(end);
                FS(contadorFS)=abs(num/den); %#ok<AGROW>
            end

    % E (E1...E(n-1))
         E=zeros(1,N-1);
         E(1)=FS(end)*T(1)-R(1)/FI(1);
   
        for i=2:N-1
            E(i)=(PSI(i-1)*E(i-1)*FIsinFIn(i-1)+FS(end)*T(i)-R(i))/FI(i);
        end
    % Lambda    
    % Adaptamos E a la ecuaci�n de lambda. Eo y En =0.
        fsinfn=f;
        fsinfn(end)=[];
        
        Eimenos1=[0 E];Ei=[E 0]; 
        Enum=Ei+Eimenos1;
        fsinfnEimenos1=Eimenos1.*fsinfn;fsinfoEi=Ei.*fsinfo;
        fEden=fsinfoEi+fsinfnEimenos1;

        contadorlambda=contadorlambda+1;

        lambdanum=sum(pasovector.*(Enum).*tand(alfa));
        lambdaden=sum(pasovector.*fEden);
        lambda(contadorlambda)=lambdanum/lambdaden;
      
    % errores
        errorFS=abs(FS(end)-FS(end-1)); 
        errorlambda=abs(lambda(end)-lambda(end-1));
            
        end
    end

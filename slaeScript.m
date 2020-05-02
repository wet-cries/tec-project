%%  ������ ��� �� �������
    span=90; % ������ �������� ���� �������� � ��������
    dt=300;
    N=size(dt:dt:86400-dt,2);
%%  ������ �������������� ���������    
     E=wgs84Ellipsoid;
     Re=E.SemiminorAxis; % ������ �����
     H=350000;                 % ������ ������ �������������� ����� � ��
     alpha=0.87;
%% �������������� �������� ����� 
    A=zeros(32*(2*span+1)*N,N+32);
    B=zeros(32*(2*span+1)*N,1);
    sats=double(isnan(Elev)~=1);
    x=0; % ���� �� ��������
%% �������� ����� � ������� � hmF2
%     load(['D:\Internet\YandexDisk\Work\GPS\SolarFlares\' mask '_hmF2'],'hmF2');
N_SAT=zeros(N,1);
for i=dt:dt:86400-dt
%         disp(i/dt);
%         qq=find(abs(hmF2(:,1)-i)==min(abs((hmF2(:,1)-i)))); % ������ � ������� hmF2
%         H=hmF2(qq,3);
        n_sat=zeros(span*2+1,1);
        y=0;    % ���� �� ��������
    for k=-span:span
        n=i+k+1;
            n_sat(k+span+1,1)=size(find(isnan(stec(n,:))==0),2);
        for s=1:32
            I=x+y*32+s; % �������� ������ �� �������� ������� 
            if isnan(Elev(n,s))==0
                A(I,i/dt)=1./(cos(asin(Re/(Re+H)*sin(alpha*(pi/2-Elev(n,s)*pi/180)))));
                A(I,N+s)=sats(n,s);
                B(I,1)=stec(n,s);
                if  isnan(B(I,1))==1
                    B(I,1)=0;
                end
            end            
        end       
       y=y+1;
    end
    x=x+(2*span+1)*32;
    N_SAT(i/dt,1)=mean(n_sat);
end
MATRIX = sparse(A);
solution = MATRIX \ B;
        C=[A B];
        C = C(any(C,2),: );
        save('solution.mat', 'solution', 'C');
%         e=C(:,1:end-1)\C(:,end); % �������� �������, e(1:N)- �������� ����������� ��� e(N+1:end) - ��� �������� + �������
% finput='E:\YandexDisk\Work\GPS\DATA\SigmaRinex\2015_01_07\log_2015_01_07_00.00.00.15H';
% ������ ��������� ��������� ��������� ���������� ��������� �������
%   finput - ���� � �����
%   �� ������ �������� ����� 
%   Eph_GLO=(t,SatNum,X,Xv,Xa,Y,Yv,Ya,Z,Zv,Za,Health)
%   1 �������: t - ����� �������� �������� � �������  MatLab
%   2 �������: SatNum - ���������� ����� �������� �������
%   3 �������: X - X ���������� �������� � ������� ECEF
%   4 �������: Xv - Xv �������� �������� � ������� ECEF
%   5 �������: Xa - Xa ��������� �������� � ������� ECEF 
%   6 �������: Y - Y ���������� �������� � ������� ECEF
%   7 �������: Yv - Yv �������� �������� � ������� ECEF
%   8 �������: Ya - Ya ��������� �������� � ������� ECEF 
%   9 �������: Z - Z ���������� �������� � ������� ECEF
%   10 �������: Zv - Zv �������� �������� � ������� ECEF
%   11 �������: Za - Za ��������� �������� � ������� ECEF  
%   12 �������: Health - Health ����������� ���������
function Eph_SBAS = SBAS_ephemeris(finput)
%% ���������� � �����
    fid=fopen(finput,'r');
%% ���������� ������ RINEX ������
    line = fgetl(fid); 
    RinVer=line(6:9); %#ok<NASGU>
    NumLine=0;
%% ���������� ���������
    while 1
       line = fgetl(fid);
       answer = findstr(line,'END OF HEADER');  %#ok<FSTR>
       if  ~isempty(answer),
            NumLine=NumLine+1;
            break
       end 
    end
    clear answer;
    %% ��������� �������� ��������
        Eph_SBAS=[];
        while  ~feof(fid) 
            line = fgetl(fid);
                SatNum=str2double(line(2:3));
                Year=str2double(line(5:8));
                Month=str2double(line(10:11));
                Day=str2double(line(13:14));
                Hour=str2double(line(16:17));
                Min=str2double(line(19:20));
                Sec=str2double(line(22:23));
                t=datenum(Year, Month, Day, Hour, Min, Sec);
                clear Year Month Day Hour Min Sec;
                
                SvClock=str2num(line(24:42));   %#ok<*ST2NM> % � ��������
                ScFrenq=str2num(line(43:61));
                MFT=str2num(line(62:80));
                
            %% BROADCAST ORBIT - 1
                line = fgetl(fid);
                    X=str2num(line(5:23))*1000;     % X ���������� �������� � ������� ECEF
                    Xv=str2num(line(24:42))*1000;   % Xv �������� �������� � ������� ECEF
                    Xa=str2num(line(43:61))*1000;   % Xa ��������� �������� � ������� ECEF 
                    Health=str2num(line(62:80));    % �������� 0 ��� OK
            %% BROADCAST ORBIT - 2
                line = fgetl(fid);
                    Y=str2num(line(5:23))*1000;     % Y ���������� �������� � ������� ECEF
                    Yv=str2num(line(24:42))*1000;   % Yv �������� �������� � ������� ECEF
                    Ya=str2num(line(43:61))*1000;   % Ya ��������� �������� � ������� ECEF
                    FreqNum=str2num(line(62:80));   %#ok<NASGU> % ����� �������
            %% BROADCAST ORBIT - 3
                line = fgetl(fid);
                    Z=str2num(line(5:23))*1000;     % Z ���������� �������� � ������� ECEF
                    Zv=str2num(line(24:42))*1000;   % Zv �������� �������� � ������� ECEF
                    Za=str2num(line(43:61))*1000;   % Za ��������� �������� � ������� ECEF
                    Age=str2num(line(62:80));       %
            %% ���������� � �������
                if Health==0
                    Eph_SBAS=[Eph_SBAS;t,SatNum,X,Xv,Xa,Y,Yv,Ya,Z,Zv,Za,Health]; %#ok<AGROW>
                else
                    Eph_SBAS=[Eph_SBAS;t,SatNum,0,0,0,0,0,0,0,0,0,Health]; %#ok<AGROW>
                end
                clear t SatNum X Xv Xa Y Yv Ya Z Zv Za Health FreqNum Age SvClock ScFrenq MFT                
        end
        fclose(fid);      
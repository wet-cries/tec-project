% ������ ��������� ��������� ��������� ���������� ��������� �������
%   finput - ���� � �����
%   �� ������ �������� ����� 
%   Eph_GLO=(t,SatNum,,Xv,Xa,Y,Yv,Ya,Z,Zv,Za,Health)
%   t - ����� �������� �������� � �������  MatLab
%   SatNum - ���������� ����� �������� �������
%   X - X ���������� �������� � ������� ECEF
%   Xv - Xv �������� �������� � ������� ECEF
%   Xa - Xa ��������� �������� � ������� ECEF 
%   Y - Y ���������� �������� � ������� ECEF
%   Yv - Yv �������� �������� � ������� ECEF
%   Ya - Ya ��������� �������� � ������� ECEF 
%   Z - Z ���������� �������� � ������� ECEF
%   Zv - Zv �������� �������� � ������� ECEF
%   Za - Za ��������� �������� � ������� ECEF  
%   Health - Health ����������� ���������
function Eph_GLO = GLO_ephemeris2_1(finput)
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
    %% ��������� �������� ��������
        Eph_GLO=[];
        while  ~feof(fid) 
            line = fgetl(fid);
                SatNum=str2double(line(1:2));
                Year=str2double(line(4:5));
                Month=str2double(line(7:8));
                Day=str2double(line(10:11));
                Hour=str2double(line(13:14));
                Min=str2double(line(16:17));
                Sec=str2double(line(18:22));
                t=datenum(Year + 2000, Month, Day, Hour, Min, Sec+16); %�������� �� ������� � ������� GPS
                clear Year Month Day Hour Min Sec;
                
                SvClock=str2num(line(23:41));   %#ok<*ST2NM> % � ��������
                ScFrenq=str2num(line(42:60));
                MFT=str2num(line(61:79));
                
            %% BROADCAST ORBIT - 1
                line = fgetl(fid);
                    X=str2num(line(4:22))*1000;     % X ���������� �������� � ������� ECEF
                    Xv=str2num(line(23:41))*1000;   % Xv �������� �������� � ������� ECEF
                    Xa=str2num(line(42:60))*1000;   % Xa ��������� �������� � ������� ECEF 
                    Health=str2num(line(61:79));    % �������� 0 ��� OK
            %% BROADCAST ORBIT - 2
                line = fgetl(fid);
                    Y=str2num(line(4:22))*1000;     % Y ���������� �������� � ������� ECEF
                    Yv=str2num(line(23:41))*1000;   % Yv �������� �������� � ������� ECEF
                    Ya=str2num(line(42:60))*1000;   % Ya ��������� �������� � ������� ECEF
                    FreqNum=str2num(line(61:79));   %#ok<NASGU> % ����� �������
            %% BROADCAST ORBIT - 3
                line = fgetl(fid);
                    Z=str2num(line(4:22))*1000;     % Z ���������� �������� � ������� ECEF
                    Zv=str2num(line(23:41))*1000;   % Zv �������� �������� � ������� ECEF
                    Za=str2num(line(42:60))*1000;   % Za ��������� �������� � ������� ECEF
                    Age=str2num(line(61:79));       %
            %% ���������� � �������
                if Health==0
                    Eph_GLO=[Eph_GLO;t,SatNum,X,Xv,Xa,Y,Yv,Ya,Z,Zv,Za,Health]; %#ok<AGROW>
                else
                    Eph_GLO=[Eph_GLO;t,SatNum,0,0,0,0,0,0,0,0,0,Health]; %#ok<AGROW>
                end
                clear t SatNum X Xv Xa Y Yv Ya Z Zv Za Health FreqNum Age SvClock ScFrenq MFT                
        end
        fclose(fid);      
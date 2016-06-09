library killaqrepl;

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  tlHelp32;

{$R *.res}

function DetectAqrepl(aTerminate : boolean): Boolean; export; stdcall;
const
  ExeFileName = 'aqrepl.exe';
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
    begin
      //Result := True;
      if not aTerminate then
        result := TRUE
      else
        result := TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), fProcessEntry32.th32ProcessID), 0);
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

exports DetectAqrepl;

begin
end.

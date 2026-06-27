[Setup]
AppName=wifipass
AppVersion=1.0
DefaultDirName={pf}\wifipass
DefaultGroupName=wifipass
OutputDir=output
OutputBaseFilename=wifipass_setup

[Tasks]
Name: "addtopath"; Description: "Add to PATH (type 'wifipass' from anywhere)"; Flags: checked
Name: "desktopicon"; Description: "Create a desktop shortcut"

[Files]
Source: "password.ps1"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\wifipass"; Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\password.ps1"""
Name: "{commondesktop}\wifipass"; Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\password.ps1"""; Tasks: desktopicon

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}"; Tasks: addtopath; Check: NeedsAddPath(ExpandConstant('{app}'))

[Run]
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\password.ps1"""; Description: "Run wifipass now"; Flags: nowait postinstall skipifsilent

[Code]
function NeedsAddPath(Param: string): boolean;
var
  OrigPath: string;
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', OrigPath)
  then begin
    Result := True;
    exit;
  end;
  Result := Pos(';' + Param + ';', ';' + OrigPath + ';') = 0;
end;

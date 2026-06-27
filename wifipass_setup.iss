; wifipass Inno Setup Script

#define MyAppName "wifipass"
#define MyAppVersion "1.0"
#define MyAppPublisher "hafizdev99"
#define MyAppURL "https://github.com/hafizdev99/wifipass"

[Setup]
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
DefaultDirName={autopf}\wifipass
DefaultGroupName={#MyAppName}
OutputDir=.\output
OutputBaseFilename=wifipass_setup
SetupIconFile=icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "addtopath"; Description: "Add to PATH (type 'wifipass' from anywhere)"; GroupDescription: "Additional options:"; Flags: checked
Name: "desktopicon"; Description: "Create a desktop shortcut"; GroupDescription: "Additional options:"

[Files]
Source: "password.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "icon.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\wifipass"; Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\password.ps1"""; IconFilename: "{app}\icon.ico"
Name: "{commondesktop}\wifipass"; Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\password.ps1"""; IconFilename: "{app}\icon.ico"; Tasks: desktopicon

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

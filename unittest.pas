unit unitTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ListBox1: TListBox;
    ListBox2: TListBox;
    procedure FormCreate(Sender: TObject);
  private
    procedure DelFiles(aFiles: TStringList);
    procedure Output(aFiles: TStringList);
    function FmtFilesSize(aFiles: TStringList): string;
  public

  end;

var
  Form1: TForm1;

implementation

uses
  unitBackend, LazFileUtils, Math;

{$R *.lfm}

{ TForm1 }

procedure TForm1.DelFiles(aFiles: TStringList);
var
  i: integer;
begin
  for i := 0 to aFiles.Count - 1 do
  begin
    DeleteFile(aFiles[i]);
  end;
end;

procedure TForm1.Output(aFiles: TStringList);
var
  i: integer;
  l: TStringList;
begin
  Caption := Format('These %d orphan saves where deleted (%s freed)',
    [aFiles.Count, FmtFilesSize(aFiles)]);
  l := TStringList.Create;
  l.Sorted:= true;
  l.Duplicates:= dupIgnore;
  try
    for i := 0 to aFiles.Count - 1 do
    begin
      l.Add(ExtractFileNameOnly(aFiles[i]));
    end;
    ListBox1.Items.Text:= l.Text;
  finally
    l.Free;
  end;
end;

function TForm1.FmtFilesSize(aFiles: TStringList): string;
var
  s: int64;
  MB, GB, r: real;
  units: string;
begin
  s := FileSizes(aFiles);
  MB := s / 1024 / 1024;
  GB := MB / 1024;

  if Floor(GB) > 0.0 then
  begin
    r := GB;
    units := 'GB';
  end
  else
  begin
    r := MB;
    units := 'MB';
  end;
  Result := Format('%.2f %s', [r, units]);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  l: TStringList;
begin
  l := FindOrphans(Application.Location);
  try
    Output(l);
    DelFiles(l);
  finally
    l.Free;
  end;
end;

end.







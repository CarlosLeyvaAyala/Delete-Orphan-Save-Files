unit unitBackend;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function FileSizes(aFiles: TStringList): int64;
function FindOrphans(aDir: string): TStringList;

implementation

uses
  FileUtil, LazFileUtils;

function FileSizes(aFiles: TStringList): int64;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to aFiles.Count - 1 do
  begin
    Result := Result + FileSizeUtf8(aFiles[i]);
  end;
end;

function FindOrphanByExt(aDir: string; aExt: string): TStringList;
var
  i: integer;
  fileN: string;
  l: TStringList;
begin
  l := FindAllFiles(aDir, '*.' + aExt);
  try
    Result := TStringList.Create;
    for i := 0 to l.Count - 1 do
    begin
      fileN := ExtractFileNameWithoutExt(l[i]);
      if not FileExistsUTF8(fileN + '.ess') then
        Result.Append(l[i]);
    end;
  finally
    l.Free;
  end;
end;

function FindOrphans(aDir: string): TStringList;
var
  skse, bak: TStringList;
begin
  skse := FindOrphanByExt(aDir, 'skse');
  bak := FindOrphanByExt(aDir, 'bak');
  try
    Result := TStringList.Create;
    Result.Text := skse.Text + bak.Text;
  finally
    skse.Free;
    bak.Free;
  end;
end;

end.

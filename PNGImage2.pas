unit pngimage2;

interface

uses PNGImage, Windows, Classes, Graphics;

type TPNGImage = class(TBitmap)
       Function P:TPNGObject;
 public
       procedure Assign(Source: TPersistent); override;
       constructor Create; override;
       Destructor Destroy; override;
       procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle; APalette: HPALETTE); override;
       procedure LoadFromResourceID(Instance: THandle; ResID: Integer); reintroduce;
       procedure LoadFromResourceName(Instance: THandle; const ResName: string); reintroduce;

       procedure LoadFromStream(Stream: TStream); override;

       procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle; var APalette: HPALETTE); override;

       procedure SaveToStream(Stream: TStream); override;
end;

implementation

Function TPNGImage.P:TPNGObject;
begin
 Result:=TPNGObject.Create;
end;

Constructor TPNGImage.Create;
begin
 inherited;
end;
Destructor TPNGImage.Destroy;
begin
 inherited;
end;

procedure TPNGImage.Assign(Source: TPersistent);
var po:TPNGObject;
    x, y:integer;
    d:pCardinal;
    al:pByteArray;
begin

 if Source is TPNGObject then begin
  po:=source as TPNGObject;

  if po.PixelFormat=pf32bit then begin

  inherited;
  // Convert to RGBA, add alpha
  if ( self.PixelFormat<>pf32bit) then begin
   self.PixelFormat:=pf32bit;
    for y:=0 to po.Height-1 do begin
     d:=self.ScanLine[y];
     al:=po.AlphaScanline[y];
      for x:=0 to po.Width-1 do begin
       d^:=(d^ and $FFFFFF) or (al[x] shl 24);
       d:=pcardinal(cardinal(d)+4);
      end;
    end;
   end;
  end else inherited;

 end else inherited;


end;


procedure TPNGImage.LoadFromClipboardFormat(AFormat: Word; AData: THandle; APalette: HPALETTE);
var png:TPNGObject;
begin
 png:=P;
 with png do begin
  try
   LoadFromClipboardFormat(AFormat, AData, APalette);
   self.PixelFormat:=png.PixelFormat;
   self.Assign(Png);
  finally
   Free;
  end;
 end;

end;

procedure TPNGImage.LoadFromResourceID(Instance: THandle; ResID: Integer);
var png:TPNGObject;
begin
 png:=P;
 with png do begin
  try
   LoadFromResourceID(InstanceSize, ResID);
   self.PixelFormat:=png.PixelFormat;
   self.Assign(png);
  finally
   Free;
  end;
 end;
end;

procedure TPNGImage.LoadFromResourceName(Instance: THandle; const ResName: string);
var png:TPNGObject;
begin
 png:=P;
 with png do begin
  try
   LoadFromResourceName(Instance, ResName);
   self.PixelFormat:=png.PixelFormat;
   self.Assign(png);
  finally
   Free;
  end;
 end;
end;

procedure TPNGImage.LoadFromStream(Stream: TStream);
var png:TPNGObject;
begin
 png:=P;
 with png do begin
  try
   LoadFromStream(Stream);
   self.PixelFormat:=png.PixelFormat;
   self.Assign(Png);
  finally
   Free;
  end;
 end;
end;

procedure TPNGImage.SaveToClipboardFormat(var AFormat: Word; var AData: THandle; var APalette: HPALETTE);
begin
 with P do begin
  try
   Assign(self);
   SaveToClipboardFormat(AFormat, AData, APalette);
  finally
   Free;
  end;
 end;

end;

procedure TPNGImage.SaveToStream(Stream: TStream);
begin
 with P do begin
  try
   Assign(self);
   SaveToStream(Stream);
  finally
   Free;
  end;
 end;

end;



end.

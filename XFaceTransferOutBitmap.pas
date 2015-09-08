unit XFaceTransferOutBitmap;

(*
 *  Compface - 48x48x1 image compression and decompression
 *
 *  Copyright (c) James Ashton - Sydney University - June 1990.
 *
 *  Written 11th November 1989.
 *
 *  Delphi conversion Copyright (c) Nicholas Ring February 2012
 *
 *  Permission is given to distribute these sources, as long as the
 *  copyright messages are not removed, and no monies are exchanged.
 *
 *  No responsibility is taken for any errors on inaccuracies inherent
 *  either to the comments or the code of this program, but if reported
 *  to me, then an attempt will be made to fix them.
 *)

{$IFDEF FPC}{$mode delphi}{$ENDIF}

interface

uses
  XFaceInterfaces,
  Graphics;

type
  ITransferOutBitmapAccess = interface(IInterface)
    ['{B40C494B-4AD4-4B2C-BE86-8293D305BDE7}']
    function Bitmap : Graphics.TBitmap;
  end;

type

  { TXFaceTransferOutBitmap }

  TXFaceTransferOutBitmap = class(TInterfacedObject, IXFaceTransferOut, ITransferOutBitmapAccess)
  private
    FBitmap : Graphics.TBitmap;
    FColourUnset : TColor;
    FColourSet : TColor;
  public
    constructor Create();
    destructor Destroy; override;

    function Bitmap : Graphics.TBitmap;

    procedure StartTransfer();
    procedure TransferOut(const AByte : Byte; const AIndex : Cardinal);
    procedure EndTransfer();
  end;


implementation

uses
  XFaceConstants,
  XFaceHelper;

{ TXFaceTransferOutBitmap }

function TXFaceTransferOutBitmap.Bitmap: Graphics.TBitmap;
begin
  Result := FBitmap;
end;

constructor TXFaceTransferOutBitmap.Create;
begin
  inherited Create;
  FColourUnset := clWhite;
  FColourSet   := clBlack;

  FBitmap := TXFaceHelper.CreateXFaceBitmap(FColourUnset, FColourSet);
end;

destructor TXFaceTransferOutBitmap.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

procedure TXFaceTransferOutBitmap.EndTransfer();
begin
end;

procedure TXFaceTransferOutBitmap.StartTransfer();
begin
end;

procedure TXFaceTransferOutBitmap.TransferOut(const AByte: Byte; const AIndex: Cardinal);
var
  LPixelIdx : Byte;
  LY : integer;
  LX : integer;
begin
  LPixelIdx := 1 shl (XFaceConstants.cBITS_PER_WORD - 1);
  LY := (AIndex - 1) div XFaceConstants.cBYTES_PER_LINE;
  LX := ((AIndex - 1) mod XFaceConstants.cBYTES_PER_LINE) * XFaceConstants.cBITS_PER_WORD;

  while LPixelIdx <> 0 do
  begin
    if (AByte and LPixelIdx) <> 0 then
      FBitmap.Canvas.Pixels[LX, LY] := FColourSet
    else
      FBitmap.Canvas.Pixels[LX, LY] := FColourUnset;

    Inc(LX, 1);
    LPixelIdx := LPixelIdx shr 1;
  end;
end;

end.


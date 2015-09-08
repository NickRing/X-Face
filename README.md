# X-Face

This is an Object Pascal implementation of monochrome [X-Face](https://en.wikipedia.org/wiki/X-Face) encoder/decoder.

It came about because XanaNews was moving towards being a 64 bit application but the only implementation available to XanaNews was some 32 bit [.OBJ files](https://en.wikipedia.org/wiki/Object_file).

It was written with a portable version of [FreePascal](http://www.freepascal.org/)/[Lazarus](http://www.lazarus-ide.org/) while on holidays, so it should be compatible with both Delphi and FreePascal.


## Convert from string to image ##
    var
      LConvertedBitMap : TBitmap;
      LXFace : IXFace;
      LXFaceTransferOutBitmap : ITransferOutBitmapAccess;
      LXFaceString: string;
    begin
      LXFace := TXFace.Create;
      LXFaceTransferOutBitmap := TXFaceTransferOutBitmap.Create;
      LXFace.UncompressXFace(LXFaceString, LXFaceTransferOutBitmap as IXFaceTransferOut);

      LConvertedBitMap := TBitmap.Create;
      try
        LConvertedBitMap.Assign(LXFaceTransferOutBitmap.Bitmap);
        // Do something with the image.
      finally
        LConvertedBitMap.Free;
      end;    
    end;

## Convert from image to string ##

    function ImageToXFace(const ABitmap : TBitmap; const ATopLeft : TPoint) : string;
    var
      LXFace : IXFace;
      LXFaceTransferIn : IXFaceTransferIn;
    begin
      LXFace := TXFace.Create;
      LXFaceTransferIn := TXFaceTransferInGraphic.Create(ABitMap, ATopLeft);
      Result := LXFace.CompressXFace(LXFaceTransferIn);
    end;

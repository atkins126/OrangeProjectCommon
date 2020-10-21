unit uWindowsSelectMediaUI;

interface

uses
  FMX.Forms,
  Classes,
//  StdCtrls,
  FMX.Types,
//  FMX.UITypes,
  FMX.Graphics,
  uFileCommon,
  uFuncCommon,
  uUIFunction,
  AllImageFrame,
  uSelectMediaDialog;

type
  TWindowsSelectMediaUI=class(TBaseSelectMediaUI)
  public
    procedure TakePhotoFromLibraryAction1DidFinishTaking(Sender:TObject;Image: TBitmap);
    //从多选图片返回
    procedure DoReturnFrameFromAllImageFrame(AFrame:TFrame);
    procedure DoStartSelect;override;
  end;

implementation

{ TWindowsSelectMediaUI }

procedure TWindowsSelectMediaUI.DoReturnFrameFromAllImageFrame(AFrame: TFrame);
var
  I: Integer;
  J: Integer;
  ScaleFactor: Single;
  AFileName:String;
//  AThumbFileName:String;
  APictureName:String;
//var
//  I: Integer;
//  ScaleFactor: Single;
//var
//  AListViewItem:TSkinListViewItem;
  ABitmap:TBitmap;
//  APictures:TStringList;
  ABitmapCodecSaveParams:TBitmapCodecSaveParams;
  AFilePath:String;
begin
  for I := 0 to GAllImageFrame.FSelectedOriginPhotoList.Count-1 do
  begin
      //照片返回
      //尺寸如果超过1024,那么需要按比例缩小
//      if GAllImageFrame.FSelectedOriginPhotoList[I].Width > 1024 then
//      begin
//          ABitmap:=TBitmap.Create;
//          ScaleFactor := GAllImageFrame.FSelectedOriginPhotoList[I].Width / 1024;
////          GAllImageFrame.FSelectedOriginPhotoList[I].Resize(Round(GAllImageFrame.FSelectedOriginPhotoList[I].Width / ScaleFactor), Round(GAllImageFrame.FSelectedOriginPhotoList[I].Height / ScaleFactor));
//          //避免花掉
//          CopyBitmap(GAllImageFrame.FSelectedOriginPhotoList[I],ABitmap);
//          ABitmap.Resize(Round(ABitmap.Width / ScaleFactor),
//                        Round(ABitmap.Height / ScaleFactor));
//      end
//      else
//      begin

          //默认发原图
          ABitmap:=GAllImageFrame.FSelectedOriginPhotoList[I];


          AFilePath:=GetApplicationPath+CreateGUIDString()+'.png';
          ABitmap.SaveToFile(AFilePath);
          FSelectMediaDialog.FSelectedFilePaths.Add(AFilePath);

//      end;


//      ABitmap:=GAllImageFrame.FSelectedOriginPhotoList[I];
//      //添加一张图片
//      AListViewItem:=Self.lvPictures.Prop.Items.Insert(Self.lvPictures.Prop.Items.Count-1);
//      //要放在Icon.Assign前面
//      AListViewItem.Icon.Url:='';
//      AListViewItem.Icon.Assign(ABitmap);
//      //避免花掉
//      CopyBitmap(ABitmap,AListViewItem.Icon);




//      //照片返回
//      APictureName:=GlobalClient.Upload.NewFileId;
//      AFileName:=GlobalClient.CurrentUser.GetUserPath_ChatFiles+PathDelim+APictureName+'.png';
////      AThumbFileName:=GlobalClient.CurrentUser.GetUserPath_ChatFiles+PathDelim+APictureName+'.thumb.png';
//
//      ABitmapCodecSaveParams.Quality:=70;
//      GAllImageFrame.FSelectedOriginPhotoList[I].SaveToFile(AFileName,@ABitmapCodecSaveParams);
//
//
//
//      //生成消息内容结构
//      AChatContent:=TChatContent.Create;
//      try
//          AChatContent.AddImageElement(AFileName);
//
//          if Assigned(OnSendMessage) then
//          begin
//            OnSendMessage(Self,AChatContent.ToJSON);
//          end;
//
//      finally
//        FreeAndNil(AChatContent);
//      end;


  end;


  if Assigned(FSelectMediaDialog.OnSelectMediaResult) then
  begin
    FSelectMediaDialog.OnSelectMediaResult(FSelectMediaDialog,
                                          FSelectMediaDialog.FSelectedFilePaths);
  end;


  //释放下相册管理中的缩略图和原图所占用的内存
  GAllImageFrame.ClearAfterReturn;


end;

procedure TWindowsSelectMediaUI.DoStartSelect;
begin
  HideFrame;
  //多选照片
  ShowFrame(TFrame(GAllImageFrame),TFrameAllImage,Application.MainForm,nil,nil,DoReturnFrameFromAllImageFrame,Application,True,False,ufsefNone);
//  GAllImageFrame.FrameHistroy:=CurrentFrameHistroy;
  GAllImageFrame.OnGetPhotoFromCamera:=TakePhotoFromLibraryAction1DidFinishTaking;
  GAllImageFrame.Load(True,0,9);

end;


procedure TWindowsSelectMediaUI.TakePhotoFromLibraryAction1DidFinishTaking(
  Sender: TObject; Image: TBitmap);
var
  AFilePath:String;
begin

  AFilePath:=GetApplicationPath+CreateGUIDString()+'.png';
  Image.SaveToFile(AFilePath);
  FSelectMediaDialog.FSelectedFilePaths.Add(AFilePath);


  if Assigned(FSelectMediaDialog.OnSelectMediaResult) then
  begin
    FSelectMediaDialog.OnSelectMediaResult(FSelectMediaDialog,
                                          FSelectMediaDialog.FSelectedFilePaths);
  end;

end;

initialization
  GlobalSelectMediaUIClass:=TWindowsSelectMediaUI;

end.

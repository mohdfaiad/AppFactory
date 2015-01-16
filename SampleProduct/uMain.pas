unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,

  // AppFactory Units
  AppProduct, Content, ContentCollection, Widgets, uIcons,

  // Widgets
  wuBrowser, wuContact, wuImage, wuMap, wuText;

type
  TfrmApp = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    fAppProduct: TAppProduct;
  end;

var
  frmApp: TfrmApp;

implementation

uses System.IOUtils;

{$R *.fmx}

procedure TfrmApp.FormCreate(Sender: TObject);
var
  Background0: TBackground;
  Image1: TImageItem;
  Image2: TImageItem;
  TBottomTabNavigationContent3: TBottomTabNavigationContent;
  ImageWidget0: TWidget;
  TextWidget1: TWidget;
  TextWidget2: TWidget;
  TextWidget3: TWidget;
begin
  frmIcons := TfrmIcons.Create(Application);
  fAppProduct := TAppProduct.Create(Self);
  fAppProduct.Content.Resources.Add(TPath.Combine('Resources', 'O3T59LZp.P9m.jpg'));
  fAppProduct.Content.Resources.Add(TPath.Combine('Resources', '3n8D7hLY.FDI.jpg'));
  fAppProduct.Content.Resources.Add(TPath.Combine('Resources', '9KH34FD4.8k5.jpg'));

// Application Settings
  fAppProduct.Settings.SetValue('Name', 'Muesli');
  fAppProduct.Settings.SetValue('Version', '1.0');
  fAppProduct.Settings.SetValue('Icon', '0');
  fAppProduct.Settings.SetValue('Background', '#FFFAE775');
  fAppProduct.Settings.SetValue('NavigationStyle', 'TBottomTabNavigationContent');
  fAppProduct.Settings.SetValue('Preview', '-1');

// Content
  Background0 := TBackground.Create;
  fAppProduct.Content.Add(Background0);
  Background0.Settings.SetValue('Position', '0');
  Background0.Settings.SetValue('Align', '1');
  Background0.Settings.SetValue('Height', '50');
  Background0.Settings.SetValue('Width', '50');
  Background0.Settings.SetValue('Color', '#FFFAE775');
  Image1 := TImageItem.Create;
  fAppProduct.Content.Add(Image1);
  Image1.Settings.SetValue('Position', '0');
  Image1.Settings.SetValue('Align', '1');
  Image1.Settings.SetValue('Height', '151');
  Image1.Settings.SetValue('Width', '400');
  Image1.Settings.SetValue('Image', '0');
  Image1.Settings.SetValue('WrapMode', '2');
  Image2 := TImageItem.Create;
  fAppProduct.Content.Add(Image2);
  Image2.Settings.SetValue('Position', '0');
  Image2.Settings.SetValue('Align', '4');
  Image2.Settings.SetValue('Height', '50');
  Image2.Settings.SetValue('Width', '400');
  Image2.Settings.SetValue('Image', '2');
  Image2.Settings.SetValue('WrapMode', '3');
  TBottomTabNavigationContent3 := TBottomTabNavigationContent.Create;
  fAppProduct.Content.Add(TBottomTabNavigationContent3);
  TBottomTabNavigationContent3.Settings.SetValue('Position', '0');

// Widgets
  ImageWidget0 := WidgetsLibrary.Find('ImageWidget').Clone;
  fAppProduct.Widgets.Add(ImageWidget0);
  ImageWidget0.Settings.SetValue('Position', '0');
  ImageWidget0.Settings.SetValue('Caption', 'Bon Appetit!');
  ImageWidget0.Settings.SetValue('Icon', '2');
  ImageWidget0.Settings.SetValue('ShowIcon', '-1');
  ImageWidget0.Settings.SetValue('Image', '1');
  ImageWidget0.Settings.SetValue('WrapMode', '1');
  TextWidget1 := WidgetsLibrary.Find('TextWidget').Clone;
  fAppProduct.Widgets.Add(TextWidget1);
  TextWidget1.Settings.SetValue('Position', '0');
  TextWidget1.Settings.SetValue('Caption', 'Info');
  TextWidget1.Settings.SetValue('Icon', '30');
  TextWidget1.Settings.SetValue('ShowIcon', '-1');
  TextWidget1.Settings.SetValue('Text', 'Muesli is a popular breakfast meal'+
  ' based on uncooked rolled oats and other products based on grain, fresh '+
  'or dried fruits, nuts, and mixed with milk, soy milk, yogurt or/and frui'+
  't juice. It was developed around 1900 by Swiss physician Maximilian Bircher-Benner for patients in his hospital. It is available in a packaged dry form, ready made, or it can be made fresh.');
  TextWidget1.Settings.SetValue('FontSize', '20');
  TextWidget1.Settings.SetValue('FontColor', 'Black');
  TextWidget1.Settings.SetValue('TextAlign', '0');
  TextWidget2 := WidgetsLibrary.Find('TextWidget').Clone;
  fAppProduct.Widgets.Add(TextWidget2);
  TextWidget2.Settings.SetValue('Position', '0');
  TextWidget2.Settings.SetValue('Caption', 'Ingredients');
  TextWidget2.Settings.SetValue('Icon', '31');
  TextWidget2.Settings.SetValue('ShowIcon', '-1');
  TextWidget2.Settings.SetValue('Text', '•   3 cups of rolled oats' + #13#10 + '•   ? cup of sunflower seeds' + #13#10 + '•   ? cup of slivered almonds' + #13#10 + '•   ? cup of hazelnuts' + #13#10 + '•   ? cup of desiccated coconut' + #13#10 + '•   ? cup of pumpkin seeds' + #13#10 + '•   ? cup of honey' + #13#10 + '•   1 ? tbs of canola oil' + #13#10 + '•   ? cup of dried cranberries or apricots, roughly chopped' + #13#10 + '•   Milk and or yogurt to serve');
  TextWidget2.Settings.SetValue('FontSize', '18');
  TextWidget2.Settings.SetValue('FontColor', 'Black');
  TextWidget2.Settings.SetValue('TextAlign', '1');
  TextWidget3 := WidgetsLibrary.Find('TextWidget').Clone;
  fAppProduct.Widgets.Add(TextWidget3);
  TextWidget3.Settings.SetValue('Position', '0');
  TextWidget3.Settings.SetValue('Caption', 'Directions');
  TextWidget3.Settings.SetValue('Icon', '32');
  TextWidget3.Settings.SetValue('ShowIcon', '-1');
  TextWidget3.Settings.SetValue('Text', '1.   Pre-heat the oven to 300F.' + #13#10 + '2.   Heat the honey and vegetable oil in a small saucepan over a low heat. Gently simmer for 4 minutes.' + #13#10 + '3.   Meanwhile, in a large bowl combine the rolled oats, the nuts, the seeds and the coconut.' + #13#10 + '4.   Add the warm honey mixture to the bowl and stir well to coat the dry ingredients.' + #13#10 + '5.   Spoon the oats onto a large rimmed baking sheet and spread out.' + #13#10 + '6.   Bake the ingredients for 10 minutes, stirring occasionally.' + #13#10 + '7.   Remove from oven and allow to cool. Add the dried fruit and stir to combine.' + #13#10 + '8.   Serve with milk and/or yogurt.');
  TextWidget3.Settings.SetValue('FontSize', '18');
  TextWidget3.Settings.SetValue('FontColor', 'Black');
  TextWidget3.Settings.SetValue('TextAlign', '1');
    fAppProduct.Build;
   end;

end.

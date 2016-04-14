//
//  MPulishTopicViewController.m
//  推盟
//
//  Created by joinus on 16/3/9.
//  Copyright © 2016年 joinus. All rights reserved.
//

#import "MPublishTopicViewController.h"
#import "TZImagePickerController.h"

@interface MPublishTopicViewController ()<UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
}

@property(nonatomic,strong)SView                * chooseImageView;
@property(nonatomic,strong)NSMutableArray       * selectedImageArray;
@property(nonatomic,strong)UIButton             * chooseImageButton;

@end

@implementation MPublishTopicViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title_label.text = @"发表话题";
    [self setMyViewControllerLeftButtonType:MyViewControllerButtonTypePhoto WihtLeftString:@"system_close_image"];
    UIButton * rightButton                  = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame                       = CGRectMake(0, 0, 45, 25);
    rightButton.layer.cornerRadius          = 3;
    rightButton.layer.borderWidth           = 1;
    rightButton.layer.borderColor           = [UIColor whiteColor].CGColor;
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    rightButton.titleLabel.font             = [ZTools returnaFontWith:13];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(uploadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [self createMainView];
}

-(void)leftButtonTap:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)uploadButtonClicked:(UIButton *)sender{
    
}

-(void)createMainView{
    
    UITextField * textField = [ZTools createTextFieldWithFrame:CGRectMake(15, 15, DEVICE_WIDTH-30, 30) font:15 placeHolder:@"输入标题" secureTextEntry:NO];
    [self.view addSubview:textField];
    
    CSNPlaceholderTextView * textView = [[CSNPlaceholderTextView alloc] initWithFrame:CGRectMake(15, textField.bottom+10, DEVICE_WIDTH-30, 100)];
    textView.placeholder = @"输入内容";
    textView.font = [ZTools returnaFontWith:13];
    textView.textColor = DEFAULT_BLACK_TEXT_COLOR;
    [self.view addSubview:textView];
    
    
    
    _chooseImageButton        = [UIButton buttonWithType:UIButtonTypeCustom];
    _chooseImageButton.frame             = CGRectMake(15, textView.bottom+20, 70, 100);
    _chooseImageButton.layer.borderColor = [UIColor grayColor].CGColor;
    _chooseImageButton.layer.borderWidth = 1;
    [_chooseImageButton addTarget:self action:@selector(chooseImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chooseImageButton];
    
    
    /*
    _chooseImageView                    = [[SView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT-40-64, DEVICE_WIDTH, 40)];
    _chooseImageView.backgroundColor    = RGBCOLOR(248, 248, 248);
    _chooseImageView.lineColor          = DEFAULT_MOVIE_LINE_COLOR;
    _chooseImageView.isShowTopLine      = YES;
    _chooseImageView.isShowBottomLine   = YES;
    
    UIButton * chooseImageButton        = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseImageButton.frame             = CGRectMake(15, (_chooseImageView.height-30)/2.0f, 40, 30);
    [chooseImageButton setImage:[UIImage imageNamed:@"movieGrayTopicChooseImage"] forState:UIControlStateNormal];
    [chooseImageButton setImage:[UIImage imageNamed:@"movieTopicChooseImage"] forState:UIControlStateSelected];
    [chooseImageButton addTarget:self action:@selector(chooseImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_chooseImageView addSubview:chooseImageButton];
    [self.view addSubview:_chooseImageView];
     */
}

#pragma mark ------  创建选择照片视图
-(void)createChooseImageKeyboardView{
    UIView * keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 256)];
    keyboardView.backgroundColor = RGBCOLOR(238, 238, 238);
    
    
    
    
    
    
    
}



#pragma mark ------- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            
        }
            break;
        case 1://相机
        {
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
                
            }
            pickerImage.delegate = self;
            pickerImage.allowsEditing = NO;
            [self presentViewController:pickerImage animated:YES completion:nil];

        }
            break;
        case 2://相册
        {
            //选择多图上传
            /*
            __weak typeof(self)wself = self;
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
                if(photos.count){
                    [wself.chooseImageButton setImage:photos[0] forState:UIControlStateNormal];
                }
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
             */
            
            
            //单图上传
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
                
            }
            pickerImage.delegate = self;
            pickerImage.allowsEditing = NO;
            [self presentViewController:pickerImage animated:YES completion:nil];
            
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -------  UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
    if ([type isEqualToString:(NSString*)kUTTypeImage]&&(picker.sourceType==UIImagePickerControllerSourceTypeCamera || picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)) {
        //获取照片的原图
        UIImage* original = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage * newImage = [ZTools OriginImage:original scaleToSize:CGSizeMake(750, 1134)];
        original = nil;
        [_chooseImageButton setImage:newImage forState:UIControlStateNormal];
        
    }else{
        
    }

}


#pragma mark ------  选取照片
-(void)chooseImageClicked:(UIButton *)button{
    [self pictureSource];
}

#pragma mark ------ 选择照片来源
-(void)pictureSource{
    UIAlertView * sourceAlertView = [[UIAlertView alloc] initWithTitle:@"请选择方式" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照上传",@"从手机相册选取", nil];
    [sourceAlertView show];
}




@end
    
    
    
    
    
    
    
    

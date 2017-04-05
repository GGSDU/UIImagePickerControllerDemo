//
//  ViewController.m
//  UIImagePickerControllerDemo
//
//  Created by Story5 on 4/5/17.
//  Copyright © 2017 Story5. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIImagePickerController *picker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openPhoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:true completion:nil];
    }
}

- (IBAction)openCamera:(id)sender {
    // 1.Verify that the device is capable of picking content from the desired source. Do this by calling the isSourceTypeAvailable: class method, providing a constant from the UIImagePickerControllerSourceType enumeration.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 2.Check which media types are available for the source type you’re using, by calling the availableMediaTypesForSourceType: class method. This lets you distinguish between a camera that can be used for video recording and one that can be used only for still images.
        
//        NSArray *array = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        // 3.Tell the image picker controller to adjust the UI according to the media types you want to make available—still images, movies, or both—by setting the mediaTypes property.
        
//        self.picker.mediaTypes = @[UIImagePickerControllerOriginalImage];
        
        // 4.Present the user interface. On iPhone or iPod touch, do this modally (full-screen) by calling the presentViewController:animated:completion: method of the currently active view controller, passing your configured image picker controller as the new view controller.
        [self presentViewController:self.picker animated:true completion:nil];
        // 5.When the user taps a button to pick a newly-captured or saved image or movie, or cancels the operation, dismiss the image picker using your delegate object. For newly-captured media, your delegate can then save it to the Camera Roll on the device. For previously-saved media, your delegate can then use the image data according to the purpose of your app.
    }
    
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:true completion:nil];
    
    NSLog(@"%@",image);
    [self facedetectWithImage:image];
}


#pragma mark - getter
- (UIImagePickerController *)picker
{
    if (_picker == nil) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
    }
    return _picker;
}

- (BOOL)VerifySourceType:(UIImagePickerControllerSourceType)sourceType
{
    return false;
}

- (void)facedetectWithImage:(UIImage *)image {
    
    NSDictionary *imageOptions =  [NSDictionary dictionaryWithObject:@(5) forKey:CIDetectorImageOrientation];
    CIImage *personciImage = [CIImage imageWithCGImage:image.CGImage];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:
                          CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
    NSArray *features = [faceDetector featuresInImage:personciImage options:imageOptions];
    
    if (features.count > 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到了人脸" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未检测到人脸" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

@end

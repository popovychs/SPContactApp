//
//  DetailViewController.m
//  SPContactApp
//
//  Created by popovychs on 02.11.15.
//  Copyright © 2015 popovychs. All rights reserved.
//

#import "DetailViewController.h"
#import "SPContactData.h"



@interface DetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong) UIImagePickerController * imagePicker;
@property (weak, nonatomic) IBOutlet UIImageView *contactImage;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveContactButton;

- (IBAction)textFieldReturn:(UITextField*)sender;
@property (nonatomic,strong )SPContactData* contactData;



@end

@implementation DetailViewController

#pragma mark - Managing the detail item

//- (void) setOrEditContact
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"contact.plist"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    NSMutableDictionary *data;
//    
//    if ([fileManager fileExistsAtPath: path]) {
//        data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
//    }
//    else {
//        // If the file doesn’t exist, create an empty dictionary
//        data = [[NSMutableDictionary alloc] init];
//    }
//    
//    //To insert the data into the plist
//    data[@"value"] = @(5);
//    
//    [data writeToFile: path atomically:YES];
//    
//    //To reterive the data from the plist
//    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
//    int value1;
//    value1 = [savedStock[@"value"] intValue];
//    NSLog(@"%i",value1);
//
//}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.imagePicker=[[UIImagePickerController alloc]init];
    
    self.contactData=[SPContactData getClassInstance];
}

- (IBAction)saveContactButton:(UIButton *)sender {
    
    if (!self.contactDataDictionary) {
        self.contactDataDictionary=[[NSMutableDictionary alloc]init];
    }
    
    //To insert the data into the plist
    self.contactDataDictionary[SPFirstNameKey] = self.firstNameTextField.text;
    self.contactDataDictionary[SPSecondNameKey] = self.secondNameTextField.text;
    self.contactDataDictionary[SPPhoneNumberKey] = self.phoneNumberTextField.text;
    self.contactDataDictionary[SPEmailKey] = self.emailTextField.text;
    
    [self.contactData addImage:self.contactImage.image WithContactData:self.contactDataDictionary];
    
    [self.contactData addContactData:self.contactDataDictionary];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onAddImageClicked:(id)sender {
    
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
    
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else {
        [self presentModalViewController:self.imagePicker animated:YES];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //NSURL* imageURL=(NSURL*)[info valueForKey:UIImagePickerControllerMediaURL];
    UIImage* image=(UIImage*)[info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.contactImage.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textFieldReturn:(UITextField*)sender
{
    [sender resignFirstResponder];
}

//- (void)setDetailItem:(id)newDetailItem {
//    if (_detailItem != newDetailItem) {
//        _detailItem = newDetailItem;
//            
//        // Update the view.
//        [self configureView];
//    }
//}
//
//- (void)configureView {
//    // Update the user interface for the detail item.
//    if (self.detailItem) {
//        self.detailDescriptionLabel.text = [self.detailItem description];
//    }
//}

@end
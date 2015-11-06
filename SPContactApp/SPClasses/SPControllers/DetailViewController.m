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

@property (weak, nonatomic) IBOutlet UILabel *labelFirstName;
@property (weak, nonatomic) IBOutlet UILabel *labelSecondName;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;

- (IBAction)textFieldReturn:(UITextField*)sender;
@property (nonatomic,strong )SPContactData* contactData;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.imagePicker=[[UIImagePickerController alloc]init];
    
    self.contactData=[SPContactData getClassInstance];
    
    if (!self.contactDataDictionary) {
        self.contactDataDictionary=[[NSMutableDictionary alloc]init];
    }else
        [self setDetailData];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isWhiteOfBlackColorTheme"]) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.labelFirstName.textColor = [UIColor blueColor];
        self.labelSecondName.textColor = [UIColor blueColor];
        self.labelPhoneNumber.textColor =[UIColor blueColor];
        self.labelEmail.textColor = [UIColor blueColor];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    } else {
        self.view.backgroundColor = [UIColor blackColor];
        self.labelFirstName.textColor = [UIColor whiteColor];
        self.labelSecondName.textColor = [UIColor whiteColor];
        self.labelPhoneNumber.textColor =[UIColor whiteColor];
        self.labelEmail.textColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    }
    self.title = @"Details";
    
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                  target:self
                                  action:@selector(openCamera:)];
    
    self.navigationItem.rightBarButtonItem = cameraButton;
    
    
}

-(void)openCamera:(id)sender{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error"
                                      message:@"Device has no camera"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* showAlert = [UIAlertAction
                                    actionWithTitle:@"Ok"
                                    style:UIAlertActionStyleDefault
                                    handler:nil];
        
        [alert addAction:showAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


- (IBAction)saveContactButton:(UIButton *)sender {
   
    //To insert the data into the plist
    self.contactDataDictionary[SPFirstNameKey] = self.firstNameTextField.text;
    self.contactDataDictionary[SPSecondNameKey] = self.secondNameTextField.text;
    self.contactDataDictionary[SPPhoneNumberKey] = self.phoneNumberTextField.text;
    self.contactDataDictionary[SPEmailKey] = self.emailTextField.text;
    
    [self.contactData addImage:self.contactImage.image WithContactData:self.contactDataDictionary];
    
    [self.contactData addContactData:self.contactDataDictionary];
    
    UINavigationController* navCon=[self.splitViewController.viewControllers objectAtIndex:0];
    [navCon popToRootViewControllerAnimated:YES];
    
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

-(void)setDetailData{
    UIImage* image=[self.contactData getImageFromDictionary:self.contactDataDictionary];
    self.contactImage.image=image;
    
    self.firstNameTextField.text=self.contactDataDictionary[SPFirstNameKey];
    self.secondNameTextField.text=self.contactDataDictionary[SPSecondNameKey];
    self.phoneNumberTextField.text=self.contactDataDictionary[SPPhoneNumberKey];
    self.emailTextField.text=self.contactDataDictionary[SPEmailKey];
    
}

@end
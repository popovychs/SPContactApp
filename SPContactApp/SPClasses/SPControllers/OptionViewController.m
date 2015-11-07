//
//  OptionViewController.m
//  SPContactApp
//
//  Created by popovychs on 05.11.15.
//  Copyright © 2015 popovychs. All rights reserved.
//

#import "OptionViewController.h"
#import "AppDelegate.h"

@interface OptionViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *changeColorSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sortSwitch;
@property (weak, nonatomic) IBOutlet UILabel *labelWhiteBlack;
@property (weak, nonatomic) IBOutlet UILabel *labelNameSurname;

@end

@implementation OptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"App Settings";
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    self.changeColorSwitch.on= [defaults boolForKey:@"isWhiteOfBlackColorTheme"];
    self.sortSwitch.on = [defaults boolForKey:@"isFirstNameOrLastName"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self changeColor];
}

- (IBAction)colorSwitch:(UISwitch *)sender {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.changeColorSwitch.on forKey:@"isWhiteOfBlackColorTheme"];
    [defaults synchronize];
    [self viewDidLoad];
}

- (IBAction)sortSwitch:(UISwitch *)sender {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.sortSwitch.on forKey:@"isFirstNameOrLastName"];
    [defaults synchronize];
}

- (void) changeColor
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"isWhiteOfBlackColorTheme"]) {
        self.view.backgroundColor = [UIColor whiteColor];
        _labelWhiteBlack.textColor = [UIColor blackColor];
        _labelNameSurname.textColor = [UIColor blackColor];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
        
    } else {
        
        self.view.backgroundColor = [UIColor blackColor];
        _labelWhiteBlack.textColor = [UIColor whiteColor];
        _labelNameSurname.textColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    }
}

@end
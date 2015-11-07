//
//  MasterViewController.m
//  SPContactApp
//
//  Created by popovychs on 02.11.15.
//  Copyright © 2015 popovychs. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SPContactData.h"
#import "OptionViewController.h"
#import "SPCustomTableViewCell.h"

@interface MasterViewController ()

@property (nonatomic,strong )NSMutableArray *contacts;
@property (nonatomic,strong )SPContactData* contactData;

@property (nonatomic) BOOL * isFirstNameOrLastName;
@property (nonatomic) BOOL * isWhiteOfBlackColorTheme;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Contacts";
    
    self.contactData=[SPContactData getClassInstance];
    self.contacts=[self.contactData getData];
    
    UIBarButtonItem * optionButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                      target:self
                                      action:@selector(loadOption:)];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:optionButton, self.editButtonItem, nil];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(createNewContact:)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}


-(void)viewWillAppear:(BOOL)animated{
    
    self.contacts=[self.contactData getData];
    [self.tableView reloadData];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isWhiteOfBlackColorTheme"]) {
        super.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
        
    } else {
        
        super.view.backgroundColor = [UIColor blackColor];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    }
    
}

-(void)createNewContact:(id)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DetailViewController *viewController = (DetailViewController *)[storyboard  instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) loadOption: (id) sender
{
    UIStoryboard * optionStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    OptionViewController * optionController = (OptionViewController *)[optionStoryboard instantiateViewControllerWithIdentifier:@"OptionViewController"];
    
    [self.navigationController pushViewController:optionController animated:YES];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSDate *object = self.contacts[indexPath.item];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        NSMutableDictionary *contactDictionary=self.contacts[indexPath.row];
        controller.contactDataDictionary=contactDictionary;
        
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SPCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSMutableDictionary *contactDictionary=self.contacts[indexPath.row];
    
    UIImage *loadedImage =[self.contactData getImageFromDictionary:contactDictionary];
    cell.imageView.image = loadedImage;
    
    cell.firstName.text =contactDictionary[SPFirstNameKey];
    cell.secondName.text = contactDictionary[SPSecondNameKey];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isWhiteOfBlackColorTheme"]) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.firstName.textColor = [UIColor blueColor];
        cell.secondName.textColor = [UIColor blueColor];
        
    } else {
        
        cell.backgroundColor = [UIColor blackColor];
        cell.firstName.textColor = [UIColor whiteColor];
        cell.secondName.textColor = [UIColor whiteColor];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableDictionary *contactDictionary=self.contacts[indexPath.row];
        [self.contactData removeDataWithDictionary:contactDictionary];
        [self.contacts removeObjectAtIndex:indexPath.row];
        
        //-----------[self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
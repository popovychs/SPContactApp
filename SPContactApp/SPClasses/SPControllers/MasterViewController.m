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

@interface MasterViewController ()

@property (nonatomic,strong )NSMutableArray *contacts;
@property (nonatomic,strong )SPContactData* contactData;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.contactData=[SPContactData getClassInstance];
    self.contacts=[self.contactData getData];
    
    UIBarButtonItem * optionButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                      target:self
                                      action:@selector(loadOption:)];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:optionButton, self.editButtonItem, nil];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewContact:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}


-(void)viewWillAppear:(BOOL)animated{
    
    self.contacts=[self.contactData getData];
    [self.tableView reloadData];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_data) name:@"reload_data" object:nil];
}

-(void)createNewContact:(id)sender{
    
    //[self insertNewObject:sender];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DetailViewController *viewController = (DetailViewController *)[storyboard  instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) loadOption: (id) sender
{
    
}

//- (void)insertNewObject:(id)sender {
//    if (!self.objects) {
//        self.objects = [[NSMutableArray alloc] init];
//    }
//    [self.objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.contacts[indexPath.item];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
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
    
    
    cell.firstName.text =contactDictionary[SPFirstNameKey];
    cell.secondName.text = contactDictionary[SPSecondNameKey];
    
    //loading image
   // NSString * imageFolderPath = [dataPath stringByAppendingPathComponent:@"/ImageData"];
   // NSString * pathImage = [imageFolderPath stringByAppendingPathComponent:contact[SPImageIDKey]];
    
    UIImage *loadedImage =[self.contactData getImageFromDictionary:contactDictionary];
    cell.imageView.image = loadedImage;
    
 //   NSLog(@"contact[SPImageFolderKey] : %@",contact[SPImageIDKey]);
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //-----------[self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(NSArray *)getData{
    
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/SPContactData"];
    return [self listFileAtPath:dataPath];
}



-(NSArray *)listFileAtPath:(NSString *)path
{
    
    NSLog(@"LISTING ALL FILES FOUND");
    
    int count;
    
    NSArray *directoryContent = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:path error:nil];
    
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
}

@end

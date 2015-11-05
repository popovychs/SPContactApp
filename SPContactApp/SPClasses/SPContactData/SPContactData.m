//
//  SPContactData.m
//  SPContactApp
//
//  Created by popovychs on 04.11.15.
//  Copyright © 2015 popovychs. All rights reserved.
//

#import "SPContactData.h"

NSString * const SPFirstNameKey = @"firstName";
NSString * const SPSecondNameKey = @"secondName";
NSString * const SPPhoneNumberKey = @"phoneNumber";
NSString * const SPEmailKey = @"email";

NSString * const SPContactIDKey = @"contactID";
NSString * const SPContactImageKey = @"contactImage";

@implementation SPContactData

#pragma mark -
#pragma mark obtaining method

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError* error;
        
        //creating directory
        if (![fileManager fileExistsAtPath:[self getContactFolderPath]])
            [fileManager createDirectoryAtPath:[self getContactFolderPath] withIntermediateDirectories:NO attributes:nil error:&error];
        
        NSString * imageFolderPath = [self getImageFolderPath];
        if (![fileManager fileExistsAtPath:imageFolderPath])
            [fileManager createDirectoryAtPath:imageFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    return self;
}

+(id)getClassInstance{
    static SPContactData* contactData=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contactData=[[SPContactData alloc]init];
    });
    return contactData;
}

#pragma mark -
#pragma mark add data methods

-(void)addContactData:(NSMutableDictionary *)contactData{
   
    //get present key
    NSString *presentID=contactData[SPContactIDKey];
    
    if (presentID) {
        NSString *pathPlist = [[self getContactFolderPath] stringByAppendingPathComponent:presentID];
        [contactData writeToFile:pathPlist atomically:YES];
    }else{
        
    NSString *ID =[[NSUUID new] UUIDString] ;
    NSString *plistID = [ID stringByAppendingString:@".plist"];
    NSString *pathPlist = [[self getContactFolderPath] stringByAppendingPathComponent:plistID];
    contactData[SPContactIDKey]=plistID;
        
    [contactData writeToFile:pathPlist atomically:YES];
    }
}

-(void)addImage:(UIImage *)imageOfContact WithContactData:(NSMutableDictionary* )contactData{
  
    NSString * imageFolderPath = [self getImageFolderPath];
    
    NSString *presentImageID=contactData[SPContactImageKey];
    if (presentImageID) {
        NSString *pathImage = [imageFolderPath stringByAppendingPathComponent:presentImageID];
        [UIImageJPEGRepresentation(imageOfContact,0.3) writeToFile:pathImage atomically:YES];
    }else{
        NSString *ID =[[NSUUID new] UUIDString] ;
        NSString * imageID=[ID stringByAppendingString:@".jpg"];
        NSString * pathImage=[imageFolderPath stringByAppendingPathComponent:imageID];
        contactData[SPContactImageKey]=imageID;
        
        [UIImageJPEGRepresentation(imageOfContact,0.3) writeToFile:pathImage atomically:YES];
    }
}

#pragma mark -
#pragma mark obtaining data methods

-(NSMutableArray *)getData{
    NSString *dataPath = [self getContactFolderPath];
    NSArray *directoryContent = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:dataPath error:nil];
    NSMutableArray* dictionariesWithContactData=[[NSMutableArray alloc]init];
    
    for (int i=0;i<[directoryContent count];i++) {
        if (![directoryContent[i]isEqualToString:@"ImageData"]) {
            NSString *pathPlist = [[self getContactFolderPath] stringByAppendingPathComponent:directoryContent[i]];
            NSMutableDictionary* dict= [[NSMutableDictionary alloc] initWithContentsOfFile:pathPlist];
            dictionariesWithContactData[i]=dict;
        }
    }
    
    NSLog(@"dictionariesWithContactData : %@",[dictionariesWithContactData description]);
    return dictionariesWithContactData;
}

-(UIImage *)getImageFromDictionary:(NSMutableDictionary *)contactData{
    NSString * imageFolderPath = [self getImageFolderPath];
    NSString * pathImage=[imageFolderPath stringByAppendingPathComponent:contactData[SPContactImageKey]];
    UIImage *loadedImage =[UIImage imageWithContentsOfFile:pathImage];
    return loadedImage;
}

#pragma mark -
#pragma mark remove file methods

-(void)removeDataWithDictionary:(NSMutableDictionary *)contactDictionary{
    NSError* error;
    
    NSString* imageID=contactDictionary[SPContactImageKey];
    NSString *pathImage = [[self getImageFolderPath] stringByAppendingPathComponent:imageID];
    if (imageID)
    [[NSFileManager defaultManager] removeItemAtPath:pathImage error:&error];
    
    NSString* plistID=contactDictionary[SPContactIDKey];
    NSString *pathPlist = [[self getContactFolderPath] stringByAppendingPathComponent:plistID];
    if (plistID)
        [[NSFileManager defaultManager] removeItemAtPath:pathPlist error:&error];
    
}

#pragma mark -
#pragma mark Supporting methods

-(NSString*)getContactFolderPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/SPContactData"];
    return dataPath;
}

-(NSString*)getImageFolderPath{
    NSString *dataPath = [self getContactFolderPath];
    NSString * imageFolderPath = [dataPath stringByAppendingPathComponent:@"/ImageData"];
    return imageFolderPath;
}

@end
//
//  SPContactData.h
//  SPContactApp
//
//  Created by popovychs on 04.11.15.
//  Copyright © 2015 popovychs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

extern NSString * const SPContactImageKey;
extern NSString * const SPFirstNameKey;
extern NSString * const SPSecondNameKey;
extern NSString * const SPPhoneNumberKey;
extern NSString * const SPEmailKey;

extern NSString * const SPContactIDKey;
extern NSString * const SPImageIDKey;

@interface SPContactData : NSObject

+(id)getClassInstance;

-(void)addContactData:(NSMutableDictionary*)contactData;
-(void)addImage:(UIImage *)imageOfContact WithContactData:(NSMutableDictionary* )contactData;

-(NSMutableArray*)getData;
-(UIImage*)getImageFromDictionary:(NSMutableDictionary*)contactData;

-(void)removeDataWithDictionary:(NSMutableDictionary*)contactDictionary;

@end
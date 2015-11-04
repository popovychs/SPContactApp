//
//  SPContactDetail.h
//  SPContactApp
//
//  Created by popovychs on 04.11.15.
//  Copyright © 2015 popovychs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPContactDetail : NSObject

@property (nonatomic,strong)NSMutableDictionary* contactDict;

-(instancetype)initWithContact:(NSMutableDictionary*)dictionary;

@end

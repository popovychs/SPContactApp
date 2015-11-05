//
//  SPCustomTableViewCell.h
//  SPContactApp
//
//  Created by popovychs on 02.11.15.
//  Copyright © 2015 popovychs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPCustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *secondName;
@property (weak, nonatomic) IBOutlet UIImageView *contactImage;

@end
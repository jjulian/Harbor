//
//  ListItem.h
//  Harbor
//
//  Created by Anthony Mattox on 1/22/12.
//  Copyright (c) 2012 Friends of The Web. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListItem : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *urlLabel;

@end

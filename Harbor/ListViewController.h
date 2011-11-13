//
//  ListViewController.h
//  Harbor
//
//  Created by Jonathan Julian on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowserViewController.h"

@interface ListViewController : UITableViewController

@property (nonatomic, retain) NSArray *urlsArray;
@property (nonatomic, retain) BrowserViewController *browserViewController;

- (IBAction)chooseSite :(id)sender;

@end

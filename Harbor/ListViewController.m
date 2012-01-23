//
//  ListViewController.m
//  Harbor
//
//  Created by Jonathan Julian on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"

#import "ListItem.h"

@implementation ListViewController

@synthesize urlsArray;
@synthesize browserViewController;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setRowHeight:62];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.urlsArray.count/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListItem" owner:self options:nil] objectAtIndex:0];
    }
    
    // Again, this is dependant on alternating page titles/urls in the array which isn't ideal
    ((ListItem *) cell).titleLabel.text = [self.urlsArray objectAtIndex:indexPath.row*2+1];
    ((ListItem *) cell).urlLabel.text = [self.urlsArray objectAtIndex:indexPath.row*2];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Once more, adjusting for alternating data array
    NSString *url = [self.urlsArray objectAtIndex:indexPath.row*2];
    if (url == @"Reload") {
        [browserViewController refresh];
    } else {
        [browserViewController loadUrl:url];
        [browserViewController closePopover];
    }
}

@end

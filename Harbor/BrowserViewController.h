//
//  HarborViewController.h
//  Harbor
//
//  Created by Jonathan Julian on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController {
    IBOutlet UIWebView *webView;
    IBOutlet UINavigationBar *navBar;
    NSArray *data;
    UIPopoverController *popoverController;
}

@property (nonatomic, retain) UIWebView *webView;

- (void)loadUrl:(NSString*)urlAddress;
- (void)refresh;
- (IBAction)showSites :(id)sender;
- (IBAction)closePopover;

@end


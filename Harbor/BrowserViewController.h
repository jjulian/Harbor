//
//  HarborViewController.h
//  Harbor
//
//  Created by Jonathan Julian on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"

@interface BrowserViewController : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *webView;
    IBOutlet UINavigationBar *navBar;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *forwardButton;
    IBOutlet UILabel *pageTitle;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    NSArray *data;
    UIPopoverController *popoverController;
    ServerConnection *conn;
    
    BOOL loadingNewSite;
}

@property (nonatomic, retain) UIWebView *webView;

- (void)loadUrl:(NSString*)urlAddress;
- (void)refresh;
- (IBAction)showSites :(id)sender;
- (IBAction)reloadSites :(id)sender;
- (IBAction)closePopover;
- (void)handleNewData:(NSArray *)d;

- (IBAction)goBack :(id)sender;
- (IBAction) goForward:(id) sender;
- (IBAction) refreshButtonPressed:(id)sender;

@end


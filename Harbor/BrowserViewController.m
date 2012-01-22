//
//  HarborViewController.m
//  Harbor
//
//  Created by Jonathan Julian on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BrowserViewController.h"
#import "ListViewController.h"


@interface BrowserViewController (private)
- (void) updateForwardBackButtons;
@end

@implementation BrowserViewController
@synthesize webView;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webView.delegate = self;
    
    conn = [[ServerConnection alloc] init];
    [conn callback:self];
    [conn reload];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}




#pragma mark - 

- (void)handleNewData:(NSArray *)d {
    data = d;
    //load the first url into the browser
    [self loadUrl:[data objectAtIndex: 0]];
}

- (void)loadUrl:(NSString*)urlAddress {
    NSLog (@"Displaying %@", urlAddress);
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    webView.scalesPageToFit = YES;
    //todo set the title of the navBar
}

- (IBAction)reloadSites :(id)sender {
    //NSLog (@"Reload requested");
    [conn reload];
}





#pragma mark - Web View Actions

- (void)refresh {
    [conn reload];
}

- (IBAction) goBack:(id) sender {
    [webView goBack];
}

- (IBAction) goForward:(id) sender {
    [webView goForward];
}

- (void) updateForwardBackButtons {
    if (webView.canGoBack) {
        backButton.enabled = YES;
    } else {
        backButton.enabled = NO;
    }
    if (webView.canGoForward) {
        forwardButton.enabled = YES;
    } else {
        forwardButton.enabled = NO;
    }
}




#pragma mark - Popup List

- (IBAction)showSites :(id)sender {
    if (!popoverController) {
        ListViewController *vc = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
        [vc setUrlsArray:data];
        [vc setBrowserViewController:self];
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
        popover.delegate = (id)self;
        popover.popoverContentSize = CGSizeMake(420, 44 * data.count);
        popoverController = popover;
        [popoverController presentPopoverFromBarButtonItem:sender
                                  permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover :(UIPopoverController *)pc {
    popoverController = nil;
}

- (IBAction)closePopover {
    [popoverController dismissPopoverAnimated:YES];
    popoverController = nil;
}




#pragma mark - Webview Delegate

- (BOOL) webView:(UIWebView *) view shouldStartLoadWithRequest:(NSURLRequest *) request navigationType:(UIWebViewNavigationType) navigationType {
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *) view {
}

- (void) webViewDidFinishLoad:(UIWebView *) view {
    [self updateForwardBackButtons];
}

- (void) webView:(UIWebView *) view didFailLoadWithError:(NSError *) error {
}






@end

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
- (void) fadeOutPage;
- (void) fadeInPage;
@end




@implementation BrowserViewController
@synthesize webView;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    NSLog(@"initWithCoder");
    if (self) {
        loadingNewSite = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webView.delegate = self;
    activityIndicator.alpha = 0;
    
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
    
    loadingNewSite = YES;
}

- (IBAction)reloadSites :(id)sender {
    //NSLog (@"Reload requested");
    [conn reload];
}





#pragma mark - Web View Actions

- (IBAction) refreshButtonPressed:(id)sender {
    [self refresh];
}

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
    if (loadingNewSite || [view.request.URL.host isEqualToString:request.URL.host]) {
        return YES;
    }
    return NO;
}

- (void) webViewDidStartLoad:(UIWebView *) view {
    [self fadeOutPage];
}

- (void) webViewDidFinishLoad:(UIWebView *) view {
    [self updateForwardBackButtons];
    loadingNewSite = NO;
    
    pageTitle.text = [view stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [self fadeInPage];
}

- (void) webView:(UIWebView *) view didFailLoadWithError:(NSError *) error {
}


- (void) fadeOutPage {
    webView.userInteractionEnabled = NO;
    activityIndicator.hidden = NO;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        webView.alpha = 0;
        pageTitle.alpha = 0;
        activityIndicator.alpha=1;
        [activityIndicator startAnimating];
    } completion:^(BOOL finished) {
    }];
}

- (void) fadeInPage {
    webView.userInteractionEnabled = YES;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        webView.alpha = 1;
        pageTitle.alpha = 1;
        activityIndicator.alpha = 0;
    } completion:^(BOOL finished) {
        [activityIndicator stopAnimating];
        activityIndicator.hidden = YES;
    }];
}






@end

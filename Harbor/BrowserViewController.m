//
//  HarborViewController.m
//  Harbor
//
//  Created by Jonathan Julian on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BrowserViewController.h"
#import "ListViewController.h"

@implementation BrowserViewController

@synthesize webView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    conn = [[ServerConnection alloc] init];
    [conn callback:self];
    [conn reload];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)handleNewData:(NSArray *)d {
    data = d;
    //load the first url into the browser
    [self loadUrl:[data objectAtIndex: 0]];
}

- (void)loadUrl:(NSString*)urlAddress
{
    NSLog (@"Displaying %@", urlAddress);
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    webView.scalesPageToFit = YES;
    //todo set the title of the navBar
}

- (IBAction)showSites :(id)sender
{
    //NSLog (@"Sites requested");
    if (!popoverController) {
        //NSLog (@"building popover");
        ListViewController *vc = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
        [vc setUrlsArray:data];
        [vc setBrowserViewController:self];
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
        popover.delegate = (id)self;
        popover.popoverContentSize = CGSizeMake(420, 44 * (sizeof(data) - 1)); // todo - this computation needs work, it's always too small
        popoverController = popover;
        [popoverController presentPopoverFromBarButtonItem:sender
               permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)refresh {
    [conn reload];
}

- (IBAction)reloadSites :(id)sender
{
    //NSLog (@"Reload requested");
    [conn reload];
}

- (IBAction)goBack :(id)sender
{
    [webView goBack];
}

- (void)popoverControllerDidDismissPopover :(UIPopoverController *)pc
{
    popoverController = nil;
}

- (IBAction)closePopover
{
    [popoverController dismissPopoverAnimated:YES];
    popoverController = nil;
}

@end

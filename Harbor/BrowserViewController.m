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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refresh];
    
    //load the first url
    [self loadUrl:[data objectAtIndex: 0]];
}

- (void)refresh
{
    // todo read the teacher id from Settings

    //todo get the data from the server
    // http://example.com/<teacher_id>/current.json
    // { "name": "Set Name", urls: [] }
    
    data = [NSArray arrayWithObjects: @"http://google.com/", @"http://facebook.com/", @"http://yahoo.com/", nil];
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

- (void)loadUrl:(NSString*)urlAddress
{
    NSLog (@"Loading url %@", urlAddress);
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    webView.scalesPageToFit = YES;
    //todo set the title of the navBar
}

- (IBAction)showSites :(id)sender
{
    if (!popoverController) {
        ListViewController *vc = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
        [vc setUrlsArray:data];
        [vc setBrowserViewController:self];
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
        popover.delegate = self;
        popoverController = popover;
        [popoverController presentPopoverFromBarButtonItem:sender
               permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
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

@synthesize webView;
@end

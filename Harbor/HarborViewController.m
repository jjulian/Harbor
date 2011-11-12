//
//  HarborViewController.m
//  Harbor
//
//  Created by Jonathan Julian on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HarborViewController.h"

@implementation HarborViewController

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
    //todo get the data from the server
    // http://example.com/<teacher_id>/current.json
    // { "name": "Set Name", urls: [] }
    // todo read the teacher id from Settings
    
    data = [NSArray arrayWithObjects: @"http://google.com/", @"http://facebook.com/", nil];

    //todo populate the popover
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

@synthesize webView;
@end

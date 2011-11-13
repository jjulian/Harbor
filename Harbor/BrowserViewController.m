//
//  HarborViewController.m
//  Harbor
//
//  Created by Jonathan Julian on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BrowserViewController.h"
#import "ListViewController.h"
#import "SBJson.h"

@implementation BrowserViewController

@synthesize webView;
@synthesize responseData;

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
}

- (void)refresh
{
    // read the teacher id from Settings
    NSString *teacherId = [[NSUserDefaults standardUserDefaults] stringForKey:@"teacherIdKey"];
    if (teacherId == nil) {
        teacherId = @"default";
    }
    NSLog(@"teacherId is %@", teacherId);
    
    // use this switch to load urls from an array in development (no server needed)
    if (true) {
        // set up the request for JSON data
        //NSString *baseUrl = @"http://localhost:4567/text?keys=";
        NSString *baseUrl = @"https://api.cloudmine.me/v1/app/b6f343a25cac4b39a7aa799bdd8c0f47/text?keys=";
        NSString *requestUrl = [baseUrl stringByAppendingString:teacherId];
        self.responseData = [NSMutableData data];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
        [request setValue:@"99ca2c5973394422a839c30948d46b87" forHTTPHeaderField:@"X-CloudMine-ApiKey"];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    } else {
        data = [NSArray arrayWithObjects: @"http://google.com/", @"http://facebook.com/", @"http://yahoo.com/", nil];
        [self handleNewData];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [responseData appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.responseData = nil;
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Connection Error"
                              message:@"Could not get data. Make sure you are connected to the Internet and re-start Harbor."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark -
#pragma mark Process loan data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	self.responseData = nil;

    NSString *teacherId = [[NSUserDefaults standardUserDefaults] stringForKey:@"teacherIdKey"];  
	data = [[[(NSDictionary*)[responseString JSONValue] objectForKey:@"success"] objectForKey:teacherId] objectForKey:@"sites"];
    [self handleNewData];
}

- (void)handleNewData {
    //load the first url into the browser
    [self loadUrl:[data objectAtIndex: 0]];
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
    NSLog (@"Sites requested");
    if (!popoverController) {
        NSLog (@"building popover");
        ListViewController *vc = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
//        [vc setUrlsArray:[data arrayByAddingObject:@"Reload"]];
        [vc setUrlsArray:data];
        [vc setBrowserViewController:self];
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
        popover.delegate = self;
        popoverController = popover;
        [popoverController presentPopoverFromBarButtonItem:sender
               permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (IBAction)reloadSites :(id)sender
{
    NSLog (@"Reload requested");
    [self refresh];
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

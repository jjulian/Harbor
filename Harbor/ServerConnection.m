//
//  ServerConnection.m
//  Harbor
//
//  Created by Jonathan Julian on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ServerConnection.h"
#import "SBJson.h"
#import "BrowserViewController.h"

@implementation ServerConnection

@synthesize responseData;
@synthesize teacherId;
@synthesize callback;
@synthesize teacherIdInput;

- (void)callback:(BrowserViewController *)c {
    self.callback = c;
    [self findTeacherId];
}

/*
 * read the teacher id from Settings
 */
- (void)findTeacherId {
    teacherId = [[NSUserDefaults standardUserDefaults] stringForKey:@"teacherIdKey"];
    NSLog(@"teacherId is %@", teacherId);
}

-(void)reload {
    if (teacherId != nil && teacherId.length > 0) {
#if NO_SERVER
        NSLog(@"NO_SERVER");
        NSArray *data = [NSArray arrayWithObjects: @"http://google.com/", @"http://facebook.com/", @"http://yahoo.com/", nil];
        [self completion:data];
#else
#if LOCAL_SERVER
        NSLog(@"LOCAL_SERVER");
        NSString *baseUrl = @"http://localhost:4567/text?keys=";
#else
        NSString *baseUrl = @"https://api.cloudmine.me/v1/app/b6f343a25cac4b39a7aa799bdd8c0f47/text?keys=";
#endif
        NSString *requestUrl = [baseUrl stringByAppendingString:teacherId];
        NSLog(@"getting instructions from url %@", requestUrl);
        responseData = [NSMutableData data];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
        [request setValue:@"99ca2c5973394422a839c30948d46b87" forHTTPHeaderField:@"X-CloudMine-ApiKey"];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
#endif
    } else {
        UIAlertView* dialog = [[UIAlertView alloc] init];
        [dialog setDelegate:self];
        [dialog setTitle:@"Enter Teacher Id"];
        [dialog setMessage:@"\n"]; // give it space to breathe
        [dialog addButtonWithTitle:@"Cancel"];
        [dialog addButtonWithTitle:@"OK"];
        teacherIdInput = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
        [teacherIdInput setBackgroundColor:[UIColor whiteColor]];
        [dialog addSubview:teacherIdInput];
        [dialog show];        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        teacherId = [teacherIdInput text];
        [[NSUserDefaults standardUserDefaults] setValue:teacherId forKey:@"teacherIdKey"];
        if (teacherId != nil && teacherId.length > 0) {
            [self reload];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [responseData appendData:d];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"connection failed %@", error);
	responseData = nil;
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Connection Error"
                              message:@"Make sure you are connected to the network."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	responseData = nil;
    // here we walk the json
	NSArray *data = [[[(NSDictionary*)[responseString JSONValue] objectForKey:@"success"] objectForKey:teacherId] objectForKey:@"sites"];
    [self completion:data];
}

- (void)completion:(NSArray *)data {
    [(BrowserViewController *)self.callback handleNewData:data];
#ifdef TEST_FLIGHT
    [TestFlight passCheckpoint:@"UrlsLoaded"];
#endif
}


@end

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

- (void)callback:(BrowserViewController *)c {
    self.callback = c;
    [self findTeacherId];
}

/*
 * read the teacher id from Settings
 */
- (NSString *)findTeacherId {
    NSLog(@"looking up teacherId");
    teacherId = [[NSUserDefaults standardUserDefaults] stringForKey:@"teacherIdKey"];
    NSLog(@"teacherId is %@", teacherId);
    if (teacherId == nil) {
        // todo ask
        teacherId = @"default";
    }
    return teacherId;
}

-(void)reload {
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

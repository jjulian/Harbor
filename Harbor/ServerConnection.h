//
//  ServerConnection.h
//  Harbor
//
//  Created by Jonathan Julian on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConnection : NSObject

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSString *teacherId;
@property (nonatomic, strong) NSObject *callback;
@property (nonatomic, strong) UITextField *teacherIdInput;

- (void)callback:(NSObject *)c;
- (void)reload;
- (void)findTeacherId;
- (void)completion:(NSArray *)data;


@end

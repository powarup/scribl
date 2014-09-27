//
//  JPTaskFetcher.m
//  Scribl
//
//  Created by Jovan Powar on 27/09/2014.
//  Copyright (c) 2014 powarup. All rights reserved.
//

#import "JPTaskFetcher.h"
#import <PodioKit/PodioKit.h>

@implementation JPTaskFetcher

+(instancetype)defaultTaskFetcher {
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

-(instancetype)init {
  self = [super init];
  if (self) {
    if (![PodioKit isAuthenticated]) {
      PKTAsyncTask *authTask = [PodioKit authenticateAsUserWithEmail:@"lefthand@powarup.com" password:@"facepunch1"];
      
      [authTask onComplete:^(PKTResponse *response, NSError *error) {
        if (!error) {
          // Successfully authenticated
          NSLog(@"successfully authenticated");
        } else {
          // Failed to authenticate, double check your credentials
          NSLog(@"failed to authenticate\n%@",error);
        }
      }];
    }
  }
  return self;
}

@end

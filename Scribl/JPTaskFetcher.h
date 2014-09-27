//
//  JPTaskFetcher.h
//  Scribl
//
//  Created by Jovan Powar on 27/09/2014.
//  Copyright (c) 2014 powarup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPTaskFetcher : NSObject

@property (nonatomic, copy, readonly) NSArray *tasks;

+(instancetype)defaultTaskFetcher;

@end

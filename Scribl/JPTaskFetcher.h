//
//  JPTaskFetcher.h
//  Scribl
//
//  Created by Jovan Powar on 27/09/2014.
//  Copyright (c) 2014 powarup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPTaskTextStorage.h"

@interface JPTaskFetcher : NSObject

@property (nonatomic, copy, readonly) NSArray *tasks;
@property (nonatomic, weak) JPTaskTextStorage *textStorage;
+(instancetype)defaultTaskFetcher;

@end

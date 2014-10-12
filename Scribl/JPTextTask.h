//
//  JPTextTask.h
//  Scribl
//
//  Created by Jovan Powar on 27/09/2014.
//  Copyright (c) 2014 powarup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PodioKit/PodioKit.h>

@interface JPTextTask : NSObject

@property (nonatomic) BOOL willDelete;
@property (nonatomic) NSRange range;

-(instancetype)initWithTask:(PKTTask*)task range:(NSRange)range parentString:(NSString*)parentString;
-(void)sync;

@end

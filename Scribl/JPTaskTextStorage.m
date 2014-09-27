//
//  JPTaskTextStorage.m
//  Scribl
//
//  Created by Jovan Powar on 27/09/2014.
//  Copyright (c) 2014 powarup. All rights reserved.
//

#import "JPTaskTextStorage.h"

@interface JPTaskTextStorage ()

@property (nonatomic, strong) NSMutableAttributedString *backingString;

@end

@implementation JPTaskTextStorage

- (NSString *)string {
  return self.backingString.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location
                     effectiveRange:(NSRangePointer)range {
  return [self.backingString attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
  [self.backingString replaceCharactersInRange:range withString:str];
  [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
  [self.backingString setAttributes:attrs range:range];
  [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}

@end

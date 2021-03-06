//
//  ScrollOperation.m
//  Calabash
//
//  Created by Karl Krukow on 18/08/11.
//  Copyright (c) 2011 LessPainful. All rights reserved.
//

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LPScrollToRowOperation.h"

@implementation LPScrollToRowOperation

- (NSIndexPath *) indexPathForRow:(NSUInteger) row inTable:(UITableView *) table {
  NSInteger numberOfSections = [table numberOfSections];
  NSInteger i = 0;
  for (; i < numberOfSections; i++) {
    NSInteger numberOfRowsInSection = [table numberOfRowsInSection:i];
    if (row < numberOfRowsInSection) {
      return [NSIndexPath indexPathForRow:row inSection:i];
    } else {
      row -= numberOfSections;
    }
  }
  return nil;
}


- (id) performWithTarget:(id) target error:(NSError *__autoreleasing*) error {
  NSArray *arguments = self.arguments;

  if ([target isKindOfClass:[UITableView class]]) {
    UITableView *table = (UITableView *) target;
    NSNumber *rowNum = [arguments objectAtIndex:0];
    if ([arguments count] >= 2) {
      NSInteger row = [rowNum integerValue];
      NSInteger sec = [[arguments objectAtIndex:1] integerValue];
      NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:sec];

      if ((sec >= 0 && sec < [table numberOfSections]) && (row >= 0 && row < [table numberOfRowsInSection:sec])) {
        UITableViewScrollPosition sp = UITableViewScrollPositionTop;
        BOOL animate = YES;
        if ([arguments count] >= 3) {
          NSString *pos = [arguments objectAtIndex:2];
          if ([@"middle" isEqualToString:pos]) {
            sp = UITableViewScrollPositionMiddle;
          } else if ([@"bottom" isEqualToString:pos]) {
            sp = UITableViewScrollPositionBottom;
          } else if ([@"none" isEqualToString:pos]) {
            sp = UITableViewScrollPositionNone;
          }
        }
        if ([arguments count] >= 4) {
          NSNumber *ani = [arguments objectAtIndex:3];
          animate = [ani boolValue];
        }

        [table scrollToRowAtIndexPath:path
                     atScrollPosition:sp
                             animated:animate];

        return target;
      } else {
        NSLog(@"Warning: table doesn't contain indexPath: %@", path);
        return nil;
      }
    } else {
      NSIndexPath *indexPathForRow = [self indexPathForRow:[rowNum unsignedIntegerValue]
                                                   inTable:table];
      if (!indexPathForRow) { return nil;  }

      [table scrollToRowAtIndexPath:indexPathForRow
                   atScrollPosition:UITableViewScrollPositionTop
                           animated:YES];
      return target;
    }
  }

  NSLog(@"Warning view: %@ should be a table view for scrolling to row/cell to make sense",
          target);
  return nil;
}
@end

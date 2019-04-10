//
//  NSDate+SuDatePiker.h
//  Suplus
//
//  Created by Zilon on 2019/2/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (SuDatePiker)

+ (NSDateFormatter *)shareDateFormatter;

- (NSInteger)daysBetween:(NSDate *)aDate;

- (NSDate *)dateByAddingDays:(NSInteger)days;

- (NSString *)stringForFormat:(NSString *)format;
@end

@interface NSCalendar (AT)

+ (instancetype)sharedCalendar;

@end

NS_ASSUME_NONNULL_END

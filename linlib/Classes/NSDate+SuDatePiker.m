//
//  NSDate+SuDatePiker.m
//  Suplus
//
//  Created by Zilon on 2019/2/3.
//

#import "NSDate+SuDatePiker.h"

@implementation NSDate (SuDatePiker)

+ (NSDateFormatter *)shareDateFormatter {
    static NSDateFormatter *currentFormatter = nil;
    static dispatch_once_t sharedDateFormatter_onceToken;
    dispatch_once(&sharedDateFormatter_onceToken, ^{
        if (!currentFormatter) {
            currentFormatter = [[NSDateFormatter alloc] init];
            [currentFormatter setDateFormat:@"yyyy-MM-dd"];
            [currentFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        }
    });
    return currentFormatter;
}

- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSCalendar *calendar = [NSCalendar sharedCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSInteger)daysBetween:(NSDate *)aDate {
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSDate *from = [NSDate at_dateFromString:[self stringForYearMonthDayDashed]];
    NSDate *to = [NSDate at_dateFromString:[aDate stringForYearMonthDayDashed]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:unitFlags fromDate:from toDate:to options:0];
    return labs([components day]) + 1;
}

- (NSString *) stringForYearMonthDayDashed {
    return [self stringForFormat:@"yyyy-MM-dd"];
}

- (NSString *)stringForFormat:(NSString *)format {
    if (!format) {
        return nil;
    }
    
    NSDateFormatter *formatter = [NSDate shareDateFormatter];
    [formatter setDateFormat:format];
    
    NSString *timeStr = [formatter stringFromDate:self];
    return timeStr;
}

+ (NSDate *)at_dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [self shareDateFormatter];
  
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSDate *date = [dateFormatter dateFromString:dateString];
    if (!date) {
        date = [NSDate date];
    }
    return date;
}

@end

@implementation NSCalendar (AT)

+ (instancetype)sharedCalendar
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NSCalendar currentCalendar];
    });
    return instance;
}

@end

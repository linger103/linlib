//
//  SuDatePicker.h
//  Suplus
//
//  Created by Zilon on 2019/1/31.
//

#import <UIKit/UIKit.h>
#import "NSDate+SuDatePiker.h"

NS_ASSUME_NONNULL_BEGIN

@class SuDatePicker;

@protocol SuDatePickerDelegate<NSObject>

@optional
- (void)datePicker:(SuDatePicker *)datePicker dateDidChange:(NSDate *)date;
- (void)datePicker:(SuDatePicker *)datePicker didCancel:(UIButton *)sender;
- (void)datePicker:(SuDatePicker *)dataPicker didSelectedDate:(NSDate *)date;

@end

@interface SuDatePicker : UIControl

/**
 *  标题
 */
//@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSDate *date;

/**
 *  最小/最大范围，默认为nil。当最小>最大，这两个值忽略
 */
@property (nonatomic, strong) NSDate *minimumDate;

@property (nonatomic, strong) NSDate *maximumDate;
/**
 *  默认 [NSLocale currentLocale]. 设置为nil时，返回默认值
 */
@property(nonatomic,strong) NSLocale *locale;
/**
 *  默认 [NSCalendar currentCalendar]. 设置为nil时，返回默认值
 */
@property(nonatomic,copy) NSCalendar *calendar;
/**
 *   默认 nil. 使用当前时区或者calendar的时区
 */
@property(nonatomic,strong) NSTimeZone *timeZone;

/**
 *  只读属性，指示datepicker中为打开状态。
 */
//@property(nonatomic,assign) BOOL isOpen;

@property (nonatomic, weak) id<SuDatePickerDelegate> delegate;

- (instancetype)initWithSuperView:(UIView*)superView;

- (instancetype)initWithSuperView:(UIView *)superView minDate:(NSDate *)minimumDate maxMamDate:(NSDate *)maximumDate;

- (void)setDate:(NSDate *)date animated:(BOOL)animated;

- (void)setHighlightColor:(UIColor *)highlightColor;


@end

NS_ASSUME_NONNULL_END

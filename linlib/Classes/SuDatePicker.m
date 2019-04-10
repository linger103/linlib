//
//  SuDatePicker.m
//  Suplus
//
//  Created by Zilon on 2019/1/31.
//

#import "SuDatePicker.h"
#import "NSDate+SuDatePiker.h"
#import "UIColor+Theme.h"
#import "UIView+Line.h"
#import <QMUIKit/QMUIKit.h>
#import <Masonry/Masonry.h>
#import <YYKit_fork/YYKit.h>

typedef NS_ENUM(NSInteger,ScrollViewTagValue) {
    ScrollViewTagValue_DAYS = 1,
    ScrollViewTagValue_MONTHS = 2,
    ScrollViewTagValue_YEARS = 3,    
};


@interface SuDatePicker ()<UIScrollViewDelegate>

/**
 选中日期上下线条
 */
@property(nonatomic, strong) UIView *lineYearsTop;
@property(nonatomic, strong) UIView *lineYearsBottom;
@property(nonatomic, strong) UIView *lineMonthsTop;
@property(nonatomic, strong) UIView *lineMonthsBottom;
@property(nonatomic, strong) UIView *lineDaysTop;
@property(nonatomic, strong) UIView *lineDaysBottom;

@property(nonatomic, strong) NSMutableArray *labelsYears;
@property(nonatomic, strong) NSMutableArray *labelsMonths;
@property(nonatomic, strong) NSMutableArray *labelsDays;

@property(nonatomic, assign) NSInteger selectedYear;
@property(nonatomic, assign) NSInteger selectedMonth;
@property(nonatomic, assign) NSInteger selectedDay;

@property(nonatomic, assign) BOOL isInitialized;

@property(nonatomic, strong) NSMutableArray *years;
@property(nonatomic, strong) NSMutableArray *months;
@property(nonatomic, strong) NSMutableArray *days;

@property (nonatomic, strong) UIScrollView *scrollViewYears;
@property (nonatomic, strong) UIScrollView *scrollViewMonths;
@property (nonatomic, strong) UIScrollView *scrollViewDays;

@property (nonatomic, weak) UIView *superView;

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, assign) NSInteger minYear;
@property(nonatomic, assign) NSInteger minMonth;
@property(nonatomic, assign) NSInteger minDay;

@property(nonatomic, assign) NSInteger maxYear;
@property(nonatomic, assign) NSInteger maxMonth;
@property(nonatomic, assign) NSInteger maxDay;


@end

@implementation SuDatePicker 
@synthesize date = _date;
#pragma mark - Initializers
- (instancetype)initWithSuperView:(UIView*)superView {
    NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *maxDate = [dateFormatter dateFromString:@"3000-12-31"];
    NSDate *minDate = [dateFormatter dateFromString:@"1970-01-01"];
    self = [self initWithSuperView:superView minDate:maxDate maxMamDate:minDate];
    return self;
}
- (instancetype)initWithSuperView:(UIView *)superView minDate:(NSDate *)minimumDate maxMamDate:(NSDate *)maximumDate {
    if (self = [super initWithFrame:CGRectMake(0.0, DEVICE_HEIGHT - 320, DEVICE_WIDTH, 320)]) {
        [superView addSubview:self];
        self.superView = superView;

        [self initWithMaximumDate:maximumDate];
        [self initWithMinimumDate:minimumDate];
        
        self.tintColor = UIColor.t9Color;
        self.highlightColor = UIColor.mainColor;
        [self initWithHeaderView];
        [self setupControl];
        [self initWithBottomView];
    }
    return self;
}
/**
 初始化最大日期
 */
- (void)initWithMaximumDate:(NSDate *)maxDate{
    NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *maximumDate = [dateFormatter dateFromString:@"3000-12-31"];
    if (maxDate) {
        maximumDate = [maximumDate earlierDate:maxDate];
    }
    NSDateComponents* componentsMax = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:maximumDate];
    self.maxYear = [componentsMax year];
    self.maxMonth = [componentsMax month];
    self.maxDay = [componentsMax day];
    self.maximumDate = maximumDate;
}
/**
 初始化最小日期
 */
- (void)initWithMinimumDate:(NSDate *)minDate{
    NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *minimumDate = [dateFormatter dateFromString:@"1970-01-01"];
    if (minDate) {
        minimumDate = [minimumDate laterDate:minDate];
    }
    NSDateComponents* componentsMin = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:minimumDate];
    self.minYear = [componentsMin year];
    self.minMonth = [componentsMin month];
    self.minDay = [componentsMin day];
    self.minimumDate = minimumDate;
}
/**
 选择日期的界面
 */
- (void)setupControl {
    // Generate collections days, months, years:
    
    // Background :
    self.backgroundColor = UIColor.whiteColor;
    
    CGFloat buttonW = 50.f;
    CGFloat space = 55.f;
    CGFloat yearOffsetX = (DEVICE_WIDTH - buttonW * 3 - space * 2) / 2;
    // Date Selectors :
    [self buildSelectorYearsOffsetX:yearOffsetX andWidth:buttonW];
    [self buildSelectorMonthsOffsetX:(yearOffsetX + buttonW + space) andWidth:buttonW];
    [self buildSelectorDaysOffsetX:(yearOffsetX + buttonW * 2 + space * 2) andWidth:buttonW];
    
    //加Labels 哈哈哈哈
    [self buildSelectorLabels];
}
- (void)initWithHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = UIColor.whiteColor;
    [headerView whc_AddBottomLine:PixelOne lineColor:UIColor.tE6Color];
    [self addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(DEVICE_WIDTH, 50)));
        make.top.left.equalTo(@0);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"选择日期";
    titleLabel.textColor = UIColor.t3Color;
    titleLabel.font = UIFontBoldMake(18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView);
        make.height.width.greaterThanOrEqualTo(@0);
    }];
}

- (void)initWithBottomView {
    CGFloat buttonW = (DEVICE_WIDTH - 1)/2;
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = UIFontMake(16);
    [cancelButton setTitleColor:UIColor.t6Color forState:UIControlStateNormal];
    cancelButton.userInteractionEnabled = YES;
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton whc_AddTopLine:PixelOne lineColor:UIColor.tE6Color];
    [cancelButton whc_AddBottomLine:PixelOne lineColor:UIColor.tE6Color];

    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setTitle:@"确定" forState:UIControlStateNormal];
    commitButton.titleLabel.font = UIFontMake(16);
    [commitButton setTitleColor:UIColor.mainColor forState:UIControlStateNormal];
    commitButton.userInteractionEnabled = YES;
    [commitButton addTarget:self action:@selector(commitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [commitButton whc_AddTopLine:PixelOne lineColor:UIColor.tE6Color];
    [commitButton whc_AddBottomLine:PixelOne lineColor:UIColor.tE6Color];

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColor.t8Color;
    [self addSubview:cancelButton];
    [self addSubview:line];
    [self addSubview:commitButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(@(buttonW));
        make.height.equalTo(@50);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelButton.mas_right);
        make.bottom.equalTo(@(-10));
        make.size.equalTo(@(CGSizeMake(1, 30)));
    }];
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(line.mas_right);
        make.width.equalTo(@(buttonW));
        make.height.equalTo(@50);
    }];
}
#pragma mark - Build Selector ScrollViewLabels
-(void)buildSelectorLabels
{
    //数组处理
    NSMutableArray *years = [self getYears];
    if (self.years.count != years.count) {
        self.years = years;
    }
    NSMutableArray *months = [self getMonths];
    if (self.months.count != months.count) {
        self.months = months;
    }
    NSMutableArray *days = [self getDaysInMonth:self.date];
    if (self.days.count != days.count) {
        self.days = days;
    }
    
    //buildSelectorLabels
    if (self.scrollViewYears) {
        // Update ScrollView Data
        [self buildSelectorLabelsYears];
    }
    if (self.scrollViewMonths) {
        // Update ScrollView Data
        [self buildSelectorLabelsMonths];
    }
    if (self.scrollViewDays) {
        // Update ScrollView Data
        [self buildSelectorLabelsDays];
    }
}
#pragma mark - Build Selector Days

- (void)buildSelectorDaysOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    
    // ScrollView Days :
    self.scrollViewDays = [[UIScrollView alloc] initWithFrame:CGRectMake(x, 50 + 1.0, width, self.frame.size.height - 100 - 1.0)];
    self.scrollViewDays.tag = ScrollViewTagValue_DAYS;
    self.scrollViewDays.delegate = self;
    self.scrollViewDays.backgroundColor = UIColor.whiteColor;
    self.scrollViewDays.showsHorizontalScrollIndicator = NO;
    self.scrollViewDays.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollViewDays];
    
    self.lineDaysTop = [[UIView alloc] initWithFrame:CGRectMake(x, self.scrollViewDays.frame.origin.y + (self.scrollViewDays.frame.size.height / 2) - (45.0f / 2), width, 1.0f)];
    self.lineDaysTop.backgroundColor = self.highlightColor;
    [self addSubview:self.lineDaysTop];
    
    self.lineDaysBottom = [[UIView alloc] initWithFrame:CGRectMake(x, self.scrollViewDays.frame.origin.y + (self.scrollViewDays.frame.size.height / 2) + (45.0f / 2), width, 1.0f)];
    self.lineDaysBottom.backgroundColor = self.highlightColor;
    [self addSubview:self.lineDaysBottom];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureDaysCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.scrollViewDays addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsDays {
    CGFloat offsetContentScrollView = (self.scrollViewYears.frame.size.height - 45.0f) / 2.0;
    if (self.labelsDays && self.labelsDays.count > 0) {
        for (UILabel *label in self.labelsDays) {
            [label removeFromSuperview];
        }
    }
    self.labelsDays = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.days.count; i++) {
        NSString *day = (NSString*)[self.days objectAtIndex:i];
        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0, (i * 45.0f) + offsetContentScrollView, self.scrollViewDays.frame.size.width, 45.0f)];
        labelDay.text = day;
        labelDay.font = UIFontMake(13);
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = self.tintColor;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [self.labelsDays addObject:labelDay];
        [self.scrollViewDays addSubview:labelDay];
    }
    self.scrollViewDays.contentSize = CGSizeMake(self.scrollViewDays.frame.size.width, (45.0f * self.days.count) + (offsetContentScrollView * 2));
}
#pragma mark - Build Selector Months

- (void)buildSelectorMonthsOffsetX:(CGFloat)x andWidth:(CGFloat)width {

    self.scrollViewMonths = [[UIScrollView alloc] initWithFrame:CGRectMake(x, 50 + 1.0, width, self.frame.size.height - 100 - 1.0)];
    self.scrollViewMonths.tag = ScrollViewTagValue_MONTHS;
    self.scrollViewMonths.delegate = self;
    self.scrollViewMonths.backgroundColor = UIColor.whiteColor;
    self.scrollViewMonths.showsHorizontalScrollIndicator = NO;
    self.scrollViewMonths.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollViewMonths];
    
    self.lineMonthsTop = [[UIView alloc] initWithFrame:CGRectMake(x, self.scrollViewMonths.frame.origin.y + (self.scrollViewMonths.frame.size.height / 2) - (45.0f / 2), width, 1.0f)];
    self.lineMonthsTop.backgroundColor = self.highlightColor;
    [self addSubview:self.lineMonthsTop];
    
    self.lineMonthsBottom = [[UIView alloc] initWithFrame:CGRectMake(x, self.scrollViewMonths.frame.origin.y + (self.scrollViewMonths.frame.size.height / 2) + (45.0f / 2), width, 1.0f)];
    self.lineMonthsBottom.backgroundColor = self.highlightColor;
    [self addSubview:self.lineMonthsBottom];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureMonthsCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.scrollViewMonths addGestureRecognizer:singleTap];
}
- (void)buildSelectorLabelsMonths {
    
    CGFloat offsetContentScrollView = (self.scrollViewYears.frame.size.height - 45.0f) / 2.0;
    
    if (self.labelsMonths && self.labelsMonths.count > 0) {
        for (UILabel *label in self.labelsMonths) {
            [label removeFromSuperview];
        }
    }
    
    self.labelsMonths = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.months.count; i++) {
        
        NSString *day = (NSString*)[self.months objectAtIndex:i];
        
        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (i * 45.0f) + offsetContentScrollView, self.scrollViewMonths.frame.size.width, 45.0f)];
        labelDay.text = day;
        labelDay.font = UIFontMake(13);
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = self.tintColor;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [self.labelsMonths addObject:labelDay];
        [self.scrollViewMonths addSubview:labelDay];
    }
    
    self.scrollViewMonths.contentSize = CGSizeMake(self.scrollViewMonths.frame.size.width, (45.0f * self.months.count) + (offsetContentScrollView * 2));
}
#pragma mark - Build Selector Years
- (void)buildSelectorYearsOffsetX:(CGFloat)x andWidth:(CGFloat)width {
    // ScrollView Years
    self.scrollViewYears = [[UIScrollView alloc] initWithFrame:CGRectMake(x, 50 + 1.0, width, self.frame.size.height - 100 - 1.0)];
    self.scrollViewYears.tag = ScrollViewTagValue_YEARS;
    self.scrollViewYears.delegate = self;
    self.scrollViewYears.backgroundColor = UIColor.whiteColor;
    self.scrollViewYears.showsHorizontalScrollIndicator = NO;
    self.scrollViewYears.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollViewYears];
    
    self.lineYearsTop = [[UIView alloc] initWithFrame:CGRectMake(x, self.scrollViewYears.frame.origin.y + (self.scrollViewYears.frame.size.height / 2) - (45.0f / 2), width, 1.0f)];
    self.lineYearsTop.backgroundColor = self.highlightColor;
    [self addSubview:self.lineYearsTop];
    
    self.lineYearsBottom = [[UIView alloc] initWithFrame:CGRectMake(x, self.scrollViewYears.frame.origin.y + (self.scrollViewYears.frame.size.height / 2) + (45.0f / 2), width, 1.0f)];
    self.lineYearsBottom.backgroundColor = self.highlightColor;
    [self addSubview:self.lineYearsBottom];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureYearsCaptured:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.scrollViewYears addGestureRecognizer:singleTap];
}

- (void)buildSelectorLabelsYears {
    
    CGFloat offsetContentScrollView = (self.scrollViewYears.frame.size.height - 45.0f) / 2.0;
    
    if (self.labelsYears && self.labelsYears.count > 0) {
        for (UILabel *label in self.labelsYears) {
            [label removeFromSuperview];
        }
    }
    
    self.labelsYears = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.years.count; i++) {
        
        NSString *day = (NSString*)[self.years objectAtIndex:i];
        
        UILabel *labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0.0, (i * 45.0f) + offsetContentScrollView, self.scrollViewYears.frame.size.width, 45.0f)];
        labelDay.text = day;
        labelDay.font = UIFontMake(13);
        labelDay.textAlignment = NSTextAlignmentCenter;
        labelDay.textColor = self.tintColor;
        labelDay.backgroundColor = [UIColor clearColor];
        
        [self.labelsYears addObject:labelDay];
        [self.scrollViewYears addSubview:labelDay];
    }
    
    self.scrollViewYears.contentSize = CGSizeMake(self.scrollViewYears.frame.size.width, (45.0f * self.years.count) + (offsetContentScrollView * 2));
}
#pragma mark - Actions
- (void)cancelButtonClick:(id)sender {    
    if ([self.delegate respondsToSelector:@selector(datePicker:didCancel:)]) {
        [self.delegate datePicker:self didCancel:sender];
    }
}
- (void)commitButtonClick:(id)sender {    
    if ([self.delegate respondsToSelector:@selector(datePicker:didSelectedDate:)]) {
        NSDate *date = [self getDate];
        if ([[date earlierDate:self.minimumDate] isEqualToDate:date]) {
            date = self.minimumDate;
        } else if ([[date laterDate:self.maximumDate] isEqualToDate:date]) {
            date = self.maximumDate;
        }
        [self.delegate datePicker:self didSelectedDate:date];
    }
}
#pragma mark - Collections

- (NSMutableArray*)getYears {
    NSMutableArray *years = [[NSMutableArray alloc] init];
    if (self.minYear <= 1970) {
        self.minYear = 1970;
    }
    if (self.maxYear > 3000) {
        self.maxYear = 3000;
    }
    for (NSInteger i = self.minYear; i <= self.maxYear; i++) {
        [years addObject:[NSString stringWithFormat:@"%ld年", (long)i]];
    }
    return years;
}

- (NSMutableArray *)getMonths{
    NSMutableArray *months = [[NSMutableArray alloc] init];
    for (NSInteger monthNumber = 1; monthNumber <= 12; monthNumber++) {
        NSString *monthStr = [NSString stringWithFormat: @"%ld月", monthNumber];
        if (monthNumber < 10) {
            monthStr = [NSString stringWithFormat:@"0%@", monthStr];
        }
        [months addObject:monthStr];
    }
    return months;

}
- (NSMutableArray*)getDaysInMonth:(NSDate*)date {
    if (date == nil) date = [NSDate date];
    NSRange daysRange = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSMutableArray *days = [[NSMutableArray alloc] init];
    for (int i = 1; i <= daysRange.length; i++) {
        NSString *dayStr = [NSString stringWithFormat:@"%d%@", i, @"日"];
        if (i < 10) {
            dayStr = [NSString stringWithFormat:@"0%@", dayStr];
        }
        [days addObject:dayStr];
    }
    return days;
}

/**
 ？？？？
 */
- (NSInteger)getIndexOfArray:(NSArray *)array selectedDate:(NSInteger)selectedDate {
    NSInteger index = 0;
    if (!array) {
        return 0;
    }
    if (!selectedDate) {
        return 0;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *dateString in array) {
        NSString *date = [dateString substringWithRange:NSMakeRange(0, (dateString.length - 1))];
        [tempArray addObject:date];
    }
    if (selectedDate < 10) {
        index = [tempArray indexOfObject:[NSString stringWithFormat:@"0%ld", (long)selectedDate]];
    } else {
        index = [tempArray indexOfObject:[NSString stringWithFormat:@"%ld", (long)selectedDate]];
    }
    if (index == NSNotFound) {
        index = 0;
    }
    return index;
}
/**
 ？？？？
 */
- (NSInteger)getDayOfArray:(NSArray *)array index:(NSInteger)index {
    if (!index) {
        index = 0;
    }
    if (index >= array.count) {
        index = array.count - 1;
    }
    NSString *dayString = [array objectAtIndex:index];
    NSInteger day = [[dayString substringWithRange:NSMakeRange(0, (dayString.length - 1))] integerValue];
    if (!day) {
        return 0;
    }
    return day;
}

#pragma mark - UITapGestureRecognizer Actions

- (void)singleTapGestureDaysCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    if (touchY < (self.lineDaysTop.frame.origin.y)) {
        NSInteger minDay = 1;
        if (self.selectedYear == self.minYear && self.selectedMonth == self.minMonth && self.minDay) {
            minDay = self.minDay;
        }
        if (self.selectedDay > minDay) {
            self.selectedDay -= 1;
            NSInteger index = [self getIndexOfArray:self.days selectedDate:self.selectedDay];
            if (index < 1) {
                index = 1;
            }
            [self setScrollView:self.scrollViewDays atIndex:(index - 1) animated:YES];
        }
        
    } else if (touchY > (self.lineDaysBottom.frame.origin.y)) {
        NSString *maxDayString = [self.days lastObject];
        NSInteger maxDay = [[maxDayString substringWithRange:NSMakeRange(0, (maxDayString.length - 1))] integerValue];
        if (self.selectedDay < maxDay) {
            self.selectedDay += 1;
            NSInteger index = [self getIndexOfArray:self.days selectedDate:self.selectedDay];
            if (index < 1) {
                index = 1;
            }
            [self setScrollView:self.scrollViewDays atIndex:(self.selectedDay - 1) animated:YES];
        }
    }
}

- (void)singleTapGestureMonthsCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    if (touchY < (self.lineMonthsTop.frame.origin.y)) {
        NSInteger minMonth = 1;
        if (self.selectedYear == self.minYear ) {
            minMonth = self.minMonth;
        }
        if (self.selectedMonth > minMonth) {
            self.selectedMonth -= 1;
            NSInteger index = [self getIndexOfArray:self.months selectedDate:self.selectedMonth];
            [self setScrollView:self.scrollViewMonths atIndex:(index - 1) animated:YES];
        }
        
    } else if (touchY > (self.lineMonthsBottom.frame.origin.y)) {
        NSInteger maxMonth = 12;
        if (self.selectedYear == self.maxYear) {
            maxMonth = self.maxMonth;
        }
        
        if (self.selectedMonth < maxMonth) {
            self.selectedMonth += 1;
            NSInteger index = [self getIndexOfArray:self.months selectedDate:self.selectedMonth];

            [self setScrollView:self.scrollViewMonths atIndex:(index - 1) animated:YES];
        }
    }
}

- (void)singleTapGestureYearsCaptured:(UITapGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGFloat touchY = touchPoint.y;
    
    NSInteger minYear = self.minYear;
    
    if (touchY < (self.lineYearsTop.frame.origin.y)) {
        
        if (self.selectedYear > minYear) {
            self.selectedYear -= 1;
            [self setScrollView:self.scrollViewYears atIndex:(self.selectedYear - minYear) animated:YES];
        }
        
    } else if (touchY > (self.lineYearsBottom.frame.origin.y)) {
        
        if (self.selectedYear < (self.years.count + (minYear - 1))) {
            self.selectedYear += 1;
            [self setScrollView:self.scrollViewYears atIndex:(self.selectedYear - minYear) animated:YES];
        }
    }

}
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = [self getIndexForScrollViewPosition:scrollView];
    [self updateSelectedDateAtIndex:index forScrollView:scrollView];
    //更新显示的
    [self showHighlightLabelForScrollView:scrollView index:index];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    int index = [self getIndexForScrollViewPosition:scrollView];
    [self setScrollView:scrollView atIndex:index animated:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int index = [self getIndexForScrollViewPosition:scrollView];
    [self setScrollView:scrollView atIndex:index animated:NO];
}
#pragma mark - Did Scroll Actions
/**
 更新选择的日期
 @param index 索引
 @param scrollView scrollView
 */
- (void)updateSelectedDateAtIndex:(NSInteger)index forScrollView:(UIScrollView*)scrollView {
    
    if (scrollView.tag == ScrollViewTagValue_DAYS) {
        if (index+1 > self.labelsDays.count||index < 0) {
            return;
        }
        //如果不是最小的月份 minDay为1号 傻蛋
        NSInteger minDay = 1;
        if (self.selectedYear == self.minYear&&self.selectedMonth == self.minMonth) {
            minDay = self.minDay;
        }
        //选择的天数
       NSInteger selectedDay = [self checkSelectedDay:self.selectedDay minDay:minDay daysArray:self.days index:index];
        self.selectedDay = selectedDay;
        //更新显示
        [self updateNumberOfDays];
    } else if (scrollView.tag == ScrollViewTagValue_MONTHS) {
        if (index+1 > self.labelsMonths.count||index < 0) {
            return;
        }
        //如果不是最小的x年份 minDay为1号 傻蛋
        NSInteger minMonth = 1;
        if (self.selectedYear == self.minYear) {
            minMonth = self.minMonth;
        }
        //选择的月数
        NSInteger selectedMonth = [self checkSelectedDay:self.selectedMonth minDay:minMonth daysArray:self.months index:index];
        self.selectedMonth = selectedMonth;
        //更新显示
        [self updateNumberOfDays];
        //移动日的ScrollView
        NSInteger dayIndex = [self updateHighlightLabelIndexWithDaysArray:self.days selectedDay:self.selectedDay];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.scrollViewDays.contentOffset = CGPointMake(0.0, (dayIndex * 45.0f));
        });
        
    } else if (scrollView.tag == ScrollViewTagValue_YEARS) {
        if (index+1 > self.labelsYears.count||index < 0) {
            return;
        }
        //选择的年数
        NSInteger selectedYear = [self checkSelectedDay:self.selectedYear minDay:self.minYear daysArray:self.years index:index];
        self.selectedYear = selectedYear;
        //更新显示
        [self updateNumberOfMonths];
        //更新显示
        [self updateNumberOfDays];
        //移动月的ScrollView
        NSInteger dayIndex = [self updateHighlightLabelIndexWithDaysArray:self.months selectedDay:self.selectedMonth];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.scrollViewMonths.contentOffset = CGPointMake(0.0, (dayIndex * 45.0f));
        });
    }
}
/**
 选择选择中的的天。月。年
 @param selectedDay 之前c选中的
 @param minDay 最小的
 @param daysArray 天。月。年 数组
 @param index 索引
 @return 新的 选择选择中的的天。月。年
 */
-(NSInteger)checkSelectedDay:(NSInteger)selectedDay minDay:(NSInteger)minDay daysArray:(NSArray *)daysArray index:(NSInteger)index
{
    if (!selectedDay) {
        NSInteger tempIndex = index + minDay;
        if (tempIndex > daysArray.count) {
            tempIndex = daysArray.count?daysArray.count-1:0;
        }
        if (tempIndex <= minDay) {
            tempIndex = minDay;
        }
        NSInteger day = [self getDayOfArray:daysArray index:tempIndex];
        if (!day) {
            day = 1;
        }
        selectedDay = day; // 1 to 31
    } else {
        selectedDay =  minDay + index;
    }
    return selectedDay;
}

/**
 下级的需要高亮的索引获取
 @param daysArray s日期数组
 @param selectedDay 选择的天数
 @return 新的索引
 */
-(NSInteger)updateHighlightLabelIndexWithDaysArray:(NSArray *)daysArray selectedDay:(NSInteger)selectedDay
{
    for (NSInteger i = 0; i<daysArray.count; i++) {
        NSString *dayString = daysArray[i];
        NSString *day = [dayString substringWithRange:NSMakeRange(0, (dayString.length - 1))];
        if ([day integerValue] == selectedDay) {
            return i;
        }
    }
    return 0;
}
#pragma mark - Update Date
/**
更新月份
 */
- (void)updateNumberOfMonths {
    //每年有多少月
    NSMutableArray *newMonths = [self getMonths];
    if (self.maxYear == self.minYear && self.minMonth && self.maxMonth) {
        newMonths = [NSMutableArray arrayWithArray:[newMonths subarrayWithRange:NSMakeRange((self.minMonth - 1), (self.maxMonth - self.minMonth + 1))]];
    } else {
        if (self.selectedYear == self.minYear && self.minMonth) {
            newMonths = [NSMutableArray arrayWithArray:[newMonths subarrayWithRange:NSMakeRange((self.minMonth - 1), (newMonths.count - self.minMonth + 1))]]; 
        }
        if (self.selectedYear == self.maxYear && self.maxMonth) {
            newMonths = [NSMutableArray arrayWithArray:[newMonths subarrayWithRange:NSMakeRange(0, (newMonths.count - (12-self.maxMonth)))]];
        }
    }
    if (newMonths.count != self.months.count) {
        if (self.months) {
            [self.months removeAllObjects];
        }
        self.months = newMonths;
        //显示在days的scrollView上
        [self buildSelectorLabelsMonths];
        //selectedDay de 选取
        NSString *maxiMonthString = [self.months lastObject];
        NSString *maxiMonth = [maxiMonthString substringWithRange:NSMakeRange(0, (maxiMonthString.length - 1))];
        NSString *miniMonthString = [self.months firstObject];
        NSString *miniMonth = [miniMonthString substringWithRange:NSMakeRange(0, (miniMonthString.length - 1))];
        if (self.selectedMonth > [maxiMonth integerValue]) {
            self.selectedMonth = [maxiMonth integerValue];
        }else if (self.selectedMonth < [miniMonth integerValue]) {
            self.selectedMonth = [miniMonth integerValue];
        }else if (self.selectedMonth < 1) {
            self.selectedMonth = 1;
        }
        //scrollView显示上的位置
        NSInteger index = 0;
        if (self.selectedYear == self.minYear) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSString *monthString in self.months) {
                NSString *month = [monthString substringWithRange:NSMakeRange(0, (monthString.length-1))];
                [tempArray addObject:[NSNumber numberWithInteger:[month integerValue]]];
            }
            index = [tempArray indexOfObject:[NSNumber numberWithInteger:self.selectedMonth]];
            if (index == NSNotFound) {
                self.selectedMonth = [[tempArray objectAtIndex:0] integerValue];
                index = 0;
            }
        } else {
            index = self.selectedMonth - 1;
        }
        [self highlightLabelInArray:self.labelsMonths atIndex:index];
    }
}
//获取新的天数数组
-(NSMutableArray *)gainNewDays{
    // Updates days :
    NSDate *date = [self convertToDateDay:1 month:self.selectedMonth year:self.selectedYear];
    if (!date) return [NSMutableArray array];
    //每月有多少天
    NSMutableArray *newDays = [self getDaysInMonth:date];
    NSInteger allDayCount = newDays.count;
    if (self.maxYear == self.minYear && self.maxMonth == self.minMonth && self.minDay && self.maxDay) {
        newDays = [NSMutableArray arrayWithArray:[newDays subarrayWithRange:NSMakeRange((self.minDay - 1), (self.maxDay - self.minDay + 1))]];
    } else {
        if (self.selectedYear == self.minYear && self.selectedMonth == self.minMonth && self.minDay) {
            newDays = [NSMutableArray arrayWithArray:[newDays subarrayWithRange:NSMakeRange((self.minDay - 1), (newDays.count - self.minDay + 1))]];
        }
        if (self.selectedYear == self.maxYear && self.selectedMonth == self.maxMonth && self.maxDay) {
            newDays = [NSMutableArray arrayWithArray:[newDays subarrayWithRange:NSMakeRange(0, (newDays.count - (allDayCount - self.maxDay)))]];
        }
        
    }
    return newDays;
}
/**
 更新日期
 */
- (void)updateNumberOfDays {

    NSMutableArray *newDays = [self gainNewDays];
    if (newDays.count != self.days.count) {
        if (self.days) {
            [self.days removeAllObjects];
        }
        self.days = newDays;
        //显示在days的scrollView上
        [self buildSelectorLabelsDays];
        
        //selectedDay de 选取
        NSString *maxiDayString = [self.days lastObject];
        NSString *maxiDay = [maxiDayString substringWithRange:NSMakeRange(0, (maxiDayString.length - 1))];
        NSString *miniDayString = [self.days firstObject];
        NSString *miniDay = [miniDayString substringWithRange:NSMakeRange(0, (miniDayString.length - 1))];
        if (self.selectedDay > [maxiDay integerValue]) {
            self.selectedDay = [maxiDay integerValue];
        }else if (self.selectedDay < [miniDay integerValue]) {
            self.selectedDay = [miniDay integerValue];
        }else if (self.selectedDay < 1) {
            self.selectedDay = 1;
        }
        //scrollView显示上的位置
        NSInteger index = 0;
        if (self.selectedYear == self.minYear && self.selectedMonth == self.minMonth) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSString *dayString in self.days) {
                NSString *day = [dayString substringWithRange:NSMakeRange(0, (dayString.length-1))];
                [tempArray addObject:[NSNumber numberWithInteger:[day integerValue]]];
            }
            index = [tempArray indexOfObject:[NSNumber numberWithInteger:self.selectedDay]];
            if (index == NSNotFound) {
                self.selectedDay = [[tempArray objectAtIndex:0] integerValue];
                index = 0;
            }
        } else {
            index = self.selectedDay-1;
        }
        [self highlightLabelInArray:self.labelsDays atIndex:index];
    }

}

/**
 获得scrollView索引
 */
- (int)getIndexForScrollViewPosition:(UIScrollView *)scrollView {
    
    CGFloat offsetContentScrollView = (scrollView.frame.size.height - 45.0f) / 2.0;
    CGFloat offetY = scrollView.contentOffset.y;
    CGFloat index = floorf((offetY + offsetContentScrollView) / 45.0f);
    index = (index - 1);
    return index;
}

/**
 设置scrollView 的偏移 用于点移手势
 */
- (void)setScrollView:(UIScrollView*)scrollView atIndex:(NSInteger)index animated:(BOOL)animated {
    
    if (!scrollView) return;
    
    if (animated) {
//        UIView.areAnimationsEnabled
        [UIView beginAnimations:@"ScrollViewAnimation" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        scrollView.contentOffset = CGPointMake(0.0, (index * 45.0f));
    });
    if (animated) {
        [UIView commitAnimations];
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(datePicker:dateDidChange:)]) {
        [self.delegate datePicker:self dateDidChange:[self getDate]];
    }
}

#pragma mark - 高亮显示
/**
 显示高亮的label
 @param scrollView scrollView
 @param index 索引
 */
-(void)showHighlightLabelForScrollView:(UIScrollView *)scrollView index:(NSInteger)index
{
    if (scrollView.tag == ScrollViewTagValue_DAYS) {
        [self highlightLabelInArray:self.labelsDays atIndex:index];
    } else if (scrollView.tag == ScrollViewTagValue_MONTHS) {
        [self highlightLabelInArray:self.labelsMonths atIndex:index];
    } else if (scrollView.tag == ScrollViewTagValue_YEARS) {
        [self highlightLabelInArray:self.labelsYears atIndex:index];
    }
}
/**
 高亮label
 */
- (void)highlightLabelInArray:(NSMutableArray*)labels atIndex:(NSInteger)index {
    if (!labels) return;
    if (index > labels.count) return;
    if (index < 0) return;
    @autoreleasepool {
        //添加当前的label的选中标记
         [self changeLabelTextColorInArray:labels index:index];
    }

}
/**
 改变label的颜色
 @param labels 数组
 @param index 索引
 */
-(void)changeLabelTextColorInArray:(NSMutableArray*)labels index:(NSInteger)index
{
    if (index < labels.count) {
        //渐变处理标记
        for (int i = 0; i < labels.count; i++) {
            UILabel *label = (UILabel *)[labels objectAtIndex:i];
            if (CGColorEqualToColor(label.textColor.CGColor, self.tintColor.CGColor)) {
                label.textColor = UIColor.tCColor;
            }
        }
        //删除标记
        NSInteger beforeIndex = -1;
        //之前标记的显示的label的index
        for (int i = 0; i < labels.count; i++) {
            UILabel *label = (UILabel *)[labels objectAtIndex:i];
            if (CGColorEqualToColor(label.textColor.CGColor, self.highlightColor.CGColor)) {
                beforeIndex = i;
                break;
            }
        }
        //清除之前的label 选中标记
        if (beforeIndex > -1) {
            [self createLabelForArray:labels index:beforeIndex font:UIFontMake(13) textColor:UIColor.tCColor];
        }
        /**
         显示标记
         */
        //头一个
        if (index == 0) {
            [self createLabelForArray:labels index:index font:UIFontBoldMake(13) textColor:self.highlightColor];
            if (labels.count >=2) {
                [self createLabelForArray:labels index:index+1 font:UIFontMake(13) textColor:self.tintColor];
            }
        }
        //最后一个
        if (index == labels.count-1 && labels.count >=2) {
            [self createLabelForArray:labels index:index font:UIFontBoldMake(13) textColor:self.highlightColor];
            [self createLabelForArray:labels index:index-1 font:UIFontMake(13) textColor:self.tintColor];
        }
        //中间的
        if (index > 0 && index < labels.count-1) {
            [self createLabelForArray:labels index:index font:UIFontBoldMake(13) textColor:self.highlightColor];
            [self createLabelForArray:labels index:index-1 font:UIFontMake(13) textColor:self.tintColor];
            [self createLabelForArray:labels index:index+1 font:UIFontMake(13) textColor:self.tintColor];
        }
    }
}

/**
 创建label的s显示样式
 @param labels 数组
 @param index 索引
 @param font 字体大小
 @param textColor 颜色
 */
-(void)createLabelForArray:(NSMutableArray*)labels index:(NSInteger)index font:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *label = (UILabel *)[labels objectAtIndex:index];
    label.font = font;
    label.textColor = textColor;
}
#pragma mark - Date

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    
    if (!date) return;
    NSDateComponents* components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    self.selectedDay = [components day];
    self.selectedMonth = [components month];
    self.selectedYear = [components year];
    
    [self updateNumberOfMonths];
    [self updateNumberOfDays];
    //年
    [self setScrollView:self.scrollViewYears atIndex:(self.selectedYear - self.minYear) animated:animated];
    [self highlightLabelInArray:self.labelsYears atIndex:(self.selectedYear - self.minYear)];
    //月
    [self setScrollView:self.scrollViewMonths atIndex:(self.selectedYear == self.minYear)?(self.selectedMonth - self.minMonth):self.selectedMonth-1 animated:animated];
    [self highlightLabelInArray:self.labelsMonths atIndex:(self.selectedYear == self.minYear)?(self.selectedMonth - self.minMonth):self.selectedMonth-1];
    //日
    [self setScrollView:self.scrollViewDays atIndex:(self.selectedYear == self.minYear&&self.selectedMonth == self.minMonth)?(self.selectedDay - self.minDay):self.selectedDay-1 animated:animated];
    [self highlightLabelInArray:self.labelsDays atIndex:(self.selectedYear == self.minYear&&self.selectedMonth == self.minMonth)?(self.selectedDay - self.minDay):self.selectedDay-1];
    //代理
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(datePicker:dateDidChange:)]) {
        [self.delegate datePicker:self dateDidChange:[self getDate]];
    }
}

#pragma mark - Get Date
/**
 获得date
 */
- (NSDate*)getDate {
    return [self convertToDateDay:self.selectedDay month:self.selectedMonth year:self.selectedYear];
}
/**
 根据年月日返回date
 */
- (NSDate*)convertToDateDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year {
    
    NSMutableString *dateString = [[NSMutableString alloc] init];
    
    NSDateFormatter *dateFormatter = self.dateFormatter;
    if (self.timeZone) [dateFormatter setTimeZone:self.timeZone];
    [dateFormatter setLocale:self.locale];
    if (day < 10) {
        [dateString appendFormat:@"0%ld-", (long)day];
    } else {
        [dateString appendFormat:@"%ld-", (long)day];
    }
    if (month > 12) {
        month = 12;
    } else if (month <= 0) {
        month = 1;
    }
    if (month < 10) {
        [dateString appendFormat:@"0%ld-", (long)month];
    } else {
        [dateString appendFormat:@"%ld-", (long)month];
    }
    
    [dateString appendFormat:@"%ld", (long)year];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    return [dateFormatter dateFromString:dateString];
}
#pragma mark - Getters

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
        _dateFormatter = dateFormatter;
    }
    _dateFormatter.dateFormat = @"yyyy-MM-dd";
    return _dateFormatter;
}

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _calendar.timeZone = self.timeZone;
        _calendar.locale = self.locale;
    }
    return _calendar;
}

- (NSTimeZone *)timeZone {
    if (!_timeZone) {
        _timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    }
    return _timeZone;
}

- (NSLocale *)locale {
    if (!_locale) {
        _locale = [NSLocale currentLocale];
    }
    return _locale;
}
-(NSDate *)date
{
    if (!_date) {
        _date = [NSDate date];
    }
    return _date;
}

#pragma mark - Setters
- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
}

- (void)setHighlightColor:(UIColor *)highlightColor {
    _highlightColor = highlightColor;
}

-(void)setDate:(NSDate *)date {
    _date = date;
    [self setDate:date animated:NO];
}

-(void)setMaximumDate:(NSDate *)maximumDate
{
    _maximumDate = maximumDate;
    [self buildSelectorLabels];
}
-(void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;
    [self buildSelectorLabels];
}
@end

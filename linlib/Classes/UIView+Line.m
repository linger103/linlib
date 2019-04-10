//
//  UIView+Line.m
//  framework
//
//  Created by suger on 2018/10/25.
//  Copyright © 2018 Maimaimai Co.,Ltd. All rights reserved.
//

#import "UIView+Line.h"
#import <Masonry/Masonry.h>
#import <YYKit_fork/YYKit.h>

@interface WHC_Line : WHC_CLASS_VIEW
@end

@implementation WHC_Line
@end


@implementation UIView (Line)
+ (CGFloat)borderLineHeight {
    return  1.f / YYScreenScale();
}


#if TARGET_OS_IPHONE || TARGET_OS_TV

static const int kLeft_Line_Tag = 100000;
static const int kRight_Line_Tag = kLeft_Line_Tag + 1;
static const int kTop_Line_Tag = kRight_Line_Tag + 1;
static const int kBottom_Line_Tag = kTop_Line_Tag + 1;

- (WHC_Line *)createLineWithTag:(int)lineTag {
    WHC_Line * line = nil;
    for (WHC_CLASS_VIEW * view in self.subviews) {
        if ([view isKindOfClass:[WHC_Line class]] &&
            view.tag == lineTag) {
            line = (WHC_Line *)view;
            break;
        }
    }
    if (line == nil) {
        line = [WHC_Line new];
        line.tag = lineTag;
        [self addSubview:line];
    }
    return line;
}

- (void)safe_addView:(WHC_CLASS_VIEW *)subView {
    
    WHC_Line * line = nil;
    for (WHC_CLASS_VIEW * view in self.subviews) {
        if ([view isKindOfClass:[WHC_Line class]] &&
            view.tag == kBottom_Line_Tag) {
            line = (WHC_Line *)view;
            break;
        }
    }
    if (line == nil) {
        [self addSubview:line];
    }
}

- (WHC_CLASS_VIEW *)whc_AddBottomLine:(CGFloat)value lineColor:(UIColor *)color {
    return [self whc_AddBottomLine:value lineColor:color pading:0];
}

- (WHC_CLASS_VIEW *)whc_AddBottomLine:(CGFloat)value lineColor:(UIColor *)color pading:(CGFloat)pading {
    WHC_Line * line = [self createLineWithTag:kBottom_Line_Tag];
    line.backgroundColor = color;
    [self safe_addView:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.left.mas_offset(pading);
        make.height.mas_offset(value);
        make.bottom.mas_offset(pading);
    }];
    
    return line;
}

- (WHC_CLASS_VIEW *)whc_AddTopLine:(CGFloat)value lineColor:(UIColor *)color {
    return [self whc_AddTopLine:value lineColor:color pading:0];
}

- (WHC_CLASS_VIEW *)whc_AddTopLine:(CGFloat)value lineColor:(UIColor *)color pading:(CGFloat)pading {
    WHC_Line * line = [self createLineWithTag:kTop_Line_Tag];
    line.backgroundColor = color;
    [self safe_addView:line];
    
    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.and.left.mas_offset(pading);
        make.height.mas_offset(value);
        make.top.mas_offset(pading);
    }];
    return line;
}

- (WHC_CLASS_VIEW *)whc_AddLeftLine:(CGFloat)value lineColor:(UIColor *)color padding:(CGFloat)padding
{
    WHC_Line * line = [self createLineWithTag:kLeft_Line_Tag];
    line.backgroundColor = color;
    [self safe_addView:line];
    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(value);
        make.left.mas_offset(0);
        make.top.and.bottom.mas_offset(padding);
    }];
//    [line whc_Width:value];
//    [line whc_LeftSpace:0];
//    [line whc_TopSpace:padding];
//    [line whc_BottomSpace:padding];
    return line;
}

- (WHC_CLASS_VIEW *)whc_AddLeftLine:(CGFloat)value lineColor:(UIColor *)color {
    WHC_Line * line = [self createLineWithTag:kLeft_Line_Tag];
    line.backgroundColor = color;
    [self safe_addView:line];
    
    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.width.mas_offset(value);
        make.left.top.bottom.mas_offset(0);
    }];
    
//    [line whc_Width:value];
//    [line whc_LeftSpace:0];
//    [line whc_TopSpace:0];
//    [line whc_BottomSpace:0];
    return line;
}

- (WHC_CLASS_VIEW *)whc_AddRightLine:(CGFloat)value lineColor:(UIColor *)color {
    WHC_Line * line = [self createLineWithTag:kRight_Line_Tag];
    line.backgroundColor = color;
    [self safe_addView:line];
    
    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(value);
        make.top.right.bottom.mas_offset(0);
    }];
//    [line whc_Width:value];
//    [line whc_TrailingSpace:0];
//    [line whc_TopSpace:0];
//    [line whc_BottomSpace:0];
    return line;
}

- (WHC_CLASS_VIEW *)whc_AddRightLine:(CGFloat)value lineColor:(UIColor *)color padding:(CGFloat)padding
{
    WHC_Line * line = [self createLineWithTag:kRight_Line_Tag];
    line.backgroundColor = color;
    [self safe_addView:line];

    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(value);
        make.trailing.mas_offset(0);
        make.top.bottom.mas_offset(padding);
    }];
    
//    [line whc_Width:value];
//    [line whc_TrailingSpace:0];
//    [line whc_TopSpace:padding];
//    [line whc_BottomSpace:padding];
    return line;
}
#endif


+ (WHC_CLASS_VIEW *)createLineWithColor:(UIColor *)color {
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = color;
    return line;
}
@end

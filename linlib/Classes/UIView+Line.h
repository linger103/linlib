//
//  UIView+Line.h
//  framework
//
//  Created by suger on 2018/10/25.
//  Copyright © 2018 Maimaimai Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef WHC_CLASS_VIEW
#define WHC_CLASS_VIEW UIView
#endif


@interface UIView (Line)


+ (CGFloat)borderLineHeight;


+ (WHC_CLASS_VIEW *)createLineWithColor:(UIColor *)color;

#pragma mark - 自动加边线模块 -

/**
 对视图底部加线
 
 @param value 线宽
 @param color 线的颜色
 @return 返回线视图
 */

- (WHC_CLASS_VIEW *)whc_AddBottomLine:(CGFloat)value lineColor:(UIColor *)color ;

/**
 对视图底部加线
 
 @param value 线宽
 @param color 线的颜色
 @param pading 内边距
 @return 返回线视图
 */

- (WHC_CLASS_VIEW *)whc_AddBottomLine:(CGFloat)value lineColor:(UIColor *)color pading:(CGFloat)pading;

/**
 对视图顶部加线
 
 @param value 线宽
 @param color 线的颜色
 @return 返回线视图
 */

- (WHC_CLASS_VIEW *)whc_AddTopLine:(CGFloat)value lineColor:(UIColor *)color;

/**
 对视图顶部加线
 
 @param value 线宽
 @param color 线的颜色
 @param pading 内边距
 @return 返回线视图
 */

- (WHC_CLASS_VIEW *)whc_AddTopLine:(CGFloat)value lineColor:(UIColor *)color pading:(CGFloat)pading;

/**
 对视图左边加线
 
 @param value 线宽
 @param color 线的颜色
 @return 返回线视图
 */


- (WHC_CLASS_VIEW *)whc_AddLeftLine:(CGFloat)value lineColor:(UIColor *)color;

/**
 对视图左边加线
 
 @param value   线宽
 @param color   线的颜色
 @param padding 边距
 @return 返回线视图
 */
- (WHC_CLASS_VIEW *)whc_AddLeftLine:(CGFloat)value lineColor:(UIColor *)color padding:(CGFloat)padding;

/**
 对视图右边加线
 
 @param value 线宽
 @param color 线的颜色
 @return 返回线视图
 */

- (WHC_CLASS_VIEW *)whc_AddRightLine:(CGFloat)value lineColor:(UIColor *)color;

/**
 对视图右边加线
 
 @param value 线宽
 @param color 线的颜色
 @param padding 边距
 @return 返回线视图
 */

- (WHC_CLASS_VIEW *)whc_AddRightLine:(CGFloat)value lineColor:(UIColor *)color padding:(CGFloat)padding;





@end

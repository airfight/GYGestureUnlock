//
//  GYCircleConst.swift
//  GYGestureUnlock
//
//  Created by zhuguangyang on 16/8/19.
//  Copyright © 2016年 Giant. All rights reserved.
//

import UIKit




/// 单个圆的背景色
public var CircleBackgroundColor = UIColor.clear

/// 解锁背景色
public var CircleViewBackgroundColor = UIColor.colorWithRgba(13, g: 52, b: 89, a: 1)

/// 普通状态下外空心颜色
public var CircleStateNormalOutsideColor = UIColor.colorWithRgba(241, g: 241, b: 241, a: 1)

/// 选中状态下外空心圆颜色
public var CircleStateSelectedOutsideColor = UIColor.colorWithRgba(34, g: 178, b: 246, a: 1)

/// 错误状态下外空心圆颜色
public var CircleStateErrorOutsideColor = UIColor.colorWithRgba(254, g: 82, b: 92, a: 1)

/// 普通状态下内实心圆颜色
public var CircleStateNormalInsideColor = UIColor.clear

/// 选中状态下内实心圆颜色
public var CircleStateSelectedInsideColor = UIColor.colorWithRgba(34, g: 178, b: 246, a: 1)

/// 错误状态内实心圆颜色
public var CircleStateErrorInsideColor = UIColor.colorWithRgba(254, g: 82, b: 92, a: 1)

/// 普通状态下三角形颜色
public var CircleStateNormalTrangleColor = UIColor.clear

/// 选中状态下三角形颜色
public var CircleStateSelectedTrangleColor = UIColor.colorWithRgba(34, g: 178, b: 246, a: 1)

/// 错误状态三角形颜色
public var CircleStateErrorTrangleColor = UIColor.colorWithRgba(254, g: 82, b: 92, a: 1)

/// 三角形边长
public var kTrangleLength:CGFloat = 10.0

/// 普通时连线颜色
public var CircleConnectLineNormalColor = UIColor.colorWithRgba(34, g: 178, b: 246, a: 1)

/// 错误时连线颜色
public var CircleConnectLineErrorColor = UIColor.colorWithRgba(254, g: 82, b: 92, a: 1)

/// 连线宽度
public var CircleConnectLineWidth:CGFloat = 1.0

/// 单个圆的半径
public var CircleRadius:CGFloat = 30.0

/// 单个圆的圆心
public var CircleCenter = CGPoint(x: CircleRadius, y: CircleRadius)

/// 空心圆圆环宽度
public var CircleEdgeWidth:CGFloat = 1.0

/// 九宫格展示infoView 单个圆的半径
public var CircleInfoRadius:CGFloat = 5.0

/// 内部实心圆占空心圆的比例系数
public var CircleRadio:CGFloat = 0.4

/// 整个解锁View居中时，距离屏幕左边和右边的距离
public var CircleViewEdgeMargin:CGFloat = 30.0

/// 整个解锁View的Center.y值 在当前屏幕的3/5位置
public var CircleViewCenterY = UIScreen.main.bounds.size.height * 3/5

/// 连接的圆最少的个数
public var CircleSetCountLeast = 4

/// 错误状态下回显的时间
public var kdisplayTime:CGFloat = 1.0

/// 最终的手势密码存储key
public var gestureFinalSaveKey = "gestureFinalSaveKey"

/// 第一个手势密码存储key
public var gestureOneSaveKey = "gestureOneSaveKey"

/// 普通状态下文字提示的颜色
public var textColorNormalState = UIColor.colorWithRgba(241, g: 241, b: 241, a: 1)

/// 警告状态下文字提示的颜色
public var textColorWarningState = UIColor.colorWithRgba(254, g: 82, b: 92, a: 1)

/// 绘制解锁界面准备好时，提示文字
public var gestureTextBeforeSet = "绘制解锁图案"

/// 设置时，连线个数少，提示文字
public var gestureTextConnectLess = NSString(format: "最少连接%@点,请重新输入",CircleSetCountLeast)

/// 确认图案，提示再次绘制
public var gestureTextDrawAgain = "再次绘制解锁图案"

/// 再次绘制不一致，提示文字
public var gestureTextDrawAgainError = "与上次绘制不一致，请重新绘制"

/// 设置成功
public var gestureTextSetSuccess = "设置成功"

/// 请输入原手势密码
public var gestureTextOldGesture = "请输入原手势密码"

/// 密码错误
public var gestureTextGestureVerifyError = "密码错误"




public class GYCircleConst: NSObject {
    /**
     偏好设置:存字符串(手势密码)
     
     - parameter gesture: 字符串对象
     - parameter key:     存储key
     */
    
    public static func saveGesture(_ gesture: String?,key: String) {
        UserDefaults.standard.set(gesture, forKey: key)
        UserDefaults.standard.synchronize()
        
    }
    
    /**
     取字符串手势密码
     
     - parameter key: 字符串对象
     */
    public static func getGestureWithKey(_ key: String) -> String?{
        
        return UserDefaults.standard.object(forKey: key) as? String ?? nil
    }
    
    
}

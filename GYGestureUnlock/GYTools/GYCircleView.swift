//
//  GYCircleView.swift
//  GYGestureUnlock
//
//  Created by zhuguangyang on 16/8/19.
//  Copyright © 2016年 Giant. All rights reserved.
//

import UIKit

enum CircleViewType: Int {
    /// 设置手势密码
    case CircleViewTypeSetting = 1
    /// 登陆手势密码
    case CircleViewTypeLogin
    /// 验证旧手势密码
    case CircleViewTypeVerify
}

protocol GYCircleViewDelegate {
    
    /**
     *  连线个数少于4个时，通知代理
     *
     *  @param view    circleView
     *  @param type    type
     *  @param gesture 手势结果
     */
    func circleViewConnectCirclesLessThanNeedWithGesture(view: GYCircleView,type: CircleViewType,gesture: String)
    
    /**
     *  连线个数多于或等于4个，获取到第一个手势密码时通知代理
     *
     *  @param view    circleView
     *  @param type    type
     *  @param gesture 第一个次保存的密码
     */
    func circleViewdidCompleteSetFirstGesture(view: GYCircleView,type: CircleViewType,gesture: String)
    
    /**
     *  获取到第二个手势密码时通知代理
     *
     *  @param view    circleView
     *  @param type    type
     *  @param gesture 第二次手势密码
     *  @param equal   第二次和第一次获得的手势密码匹配结果
     */
    func circleViewdidCompleteSetSecondGesture(view: GYCircleView,type: CircleViewType,gesture: String,result: Bool)
    
    func circleViewdidCompleteLoginGesture(view: GYCircleView,type: CircleViewType,gesture: String,result: Bool)
    
}

class GYCircleView: UIView {
    
    /// 是否裁剪
    var clip: Bool = true
    
    /// 是否有箭头
    var _arrow: Bool?
    var arrow: Bool?
        {
        set {
            _arrow = newValue
            (self.subviews as NSArray).enumerateObjectsUsingBlock { (_,_,_) in
                let circle:GYCircle = GYCircle()
                circle.isArrow = newValue!
                
            }
            
            
        }
        get {
            return _arrow
        }
    }
    /// 解锁类型
    var type: CircleViewType?
    
    var delegate: GYCircleViewDelegate?
    
    /// 选中圆的集合
    var circleSet: NSMutableArray?
    
    /// 当前点
    var currentPoint: CGPoint?
    
    /// 数组清空标志
    var hasClean: Bool?
    
    
    
    
    
    
    
    
    
    
    
    
}

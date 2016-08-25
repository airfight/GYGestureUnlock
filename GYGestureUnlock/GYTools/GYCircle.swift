//
//  GYCircle.swift
//  GYGestureUnlock
//
//  Created by zhuguangyang on 16/8/19.
//  Copyright © 2016年 Giant. All rights reserved.
//

import UIKit

/**
 单个圆的各种状态
 
 - CircleStateNormal:          正常
 - CircleStateSelected:        锁定
 - CircleStateError:           错误
 - CircleStateLastOneSelected: 最后一个锁定
 - CircleStateLastOneError:    最后一个错误
 */
enum CircleState:Int {
    case CircleStateNormal = 1
    case CircleStateSelected
    case CircleStateError
    case CircleStateLastOneSelected
    case CircleStateLastOneError
}

/**
 圆的用途
 
 - CircleTypeInfo:    正常
 - CircleTypeGesture: 手势下的圆
 */
enum CircleTye:Int {
    case CircleTypeInfo = 1
    case CircleTypeGesture
}

class GYCircle: UIView {
    
    /// 圆所处状态
    var _state: CircleState!
    var state:CircleState?
        {
        set{
            _state = newValue
            setNeedsDisplay()
        }
        
        get{
            return _state
        }
    }
    /// 圆的类型
    var type: CircleTye?
    /// 是否带有箭头  默认有
    var isArrow:Bool = true
    /// 角度
    var _angle:CGFloat?
    var angle:CGFloat?
        {
        set {
            _angle = newValue
            setNeedsDisplay()
        }
        get {
            return _angle
        }
        
    }
    
    /// 外环颜色
    var outCircleColor: UIColor?
    {
        var color: UIColor?
        
        
        guard (self.state != nil) else {
            return  CircleStateNormalOutsideColor

        }
        switch self.state! {
        case CircleState.CircleStateNormal:
            color = CircleStateNormalOutsideColor
            
        case CircleState.CircleStateSelected:
            color = CircleStateSelectedOutsideColor
            
        case CircleState.CircleStateError:
            color = CircleStateErrorOutsideColor
            
        case CircleState.CircleStateLastOneSelected:
            color = CircleStateSelectedOutsideColor
            
        case CircleState.CircleStateLastOneError:
            color = CircleStateErrorOutsideColor
            
        }
        return color
    }
    /// 实心圆颜色
    var inCircleColor: UIColor?
    {
        
        var color: UIColor?
        
        guard (self.state != nil) else {
            return  CircleStateNormalInsideColor
            
        }
        switch self.state! {
        case CircleState.CircleStateNormal:
            color = CircleStateNormalInsideColor
            
        case CircleState.CircleStateSelected:
            color = CircleStateSelectedInsideColor
            
        case CircleState.CircleStateError:
            color = CircleStateErrorInsideColor
            
        case CircleState.CircleStateLastOneSelected:
            color = CircleStateSelectedInsideColor
            
        case CircleState.CircleStateLastOneError:
            color = CircleStateErrorInsideColor
            
        }
        return color
    }
    /// 三角形颜色
    var trangleColor: UIColor?
    {
        var color: UIColor?
        
        guard (self.state != nil) else {
            return  CircleStateNormalTrangleColor
            
        }
        switch self.state! {
        case CircleState.CircleStateNormal:
            color = CircleStateNormalTrangleColor
            
        case CircleState.CircleStateSelected:
            color = CircleStateSelectedTrangleColor
            
        case CircleState.CircleStateError:
            color = CircleStateErrorTrangleColor
            
        case CircleState.CircleStateLastOneSelected:
            color = CircleStateNormalTrangleColor
            
        case CircleState.CircleStateLastOneError:
            color = CircleStateNormalTrangleColor
            
        }
        return color
    }
    
    init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = CircleBackgroundColor
    
        self.angle = 5
    }
    //    
    //    convenience  init() {
    //        self.init()
    //        self.backgroundColor = CircleBackgroundColor
    //        
    //    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = CircleBackgroundColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        backgroundColor = CircleBackgroundColor
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func drawRect(rect: CGRect) {
        
        /// 获取画布
        let ctx = UIGraphicsGetCurrentContext()
        
        /// 所占圆比例
        var radio:CGFloat = 0
        let circleRect = CGRectMake(CircleEdgeWidth, CircleEdgeWidth, rect.size.width - 2 * CircleEdgeWidth, rect.size.height - 2 * CircleEdgeWidth)
        
        if self.type == CircleTye.CircleTypeGesture {
            radio = CircleRadio
        } else if self.type == CircleTye.CircleTypeInfo {
            radio = 1
        }
        
        //上下文旋转
        transFormCtx(ctx!, rect: rect)
        
        //画圆环
        drawEmptyCircleWithContext(ctx!, rect: circleRect, color: self.outCircleColor!)
        
        // 画实心圆
        drawSolidCircleWithContext(ctx!, rect: rect, radio: radio, color: self.inCircleColor!)
        
        if self.isArrow {
            
            //画三角形箭头
            drawTrangleWithContext(ctx!, point:CGPointMake(rect.size.width/2, 10) , length: kTrangleLength, color: self.trangleColor!)
        }
        
    }
    
    //MARK:- 画三角形
    
    /**
     上下文旋转
     
     - parameter ctx:  画布
     - parameter rect: Rect
     */
    private func transFormCtx(ctx: CGContextRef,rect: CGRect) {
        
        let translateXY = rect.size.width * 0.5
        //平移
        CGContextTranslateCTM(ctx, translateXY, translateXY)
        //TODO:-
        angle = 0
        CGContextRotateCTM(ctx, angle!)
        //再平移回来
        CGContextTranslateCTM(ctx, -translateXY, -translateXY)
        
    }
    
    //MARK:- 画外圆环
    
    /**
     画外圆环
     
     - parameter ctx:   图形上下文
     - parameter rect:  绘图范围
     - parameter color: 绘制颜色
     */
    
    private func drawEmptyCircleWithContext(ctx: CGContextRef,rect: CGRect,color: UIColor) {
        
        
        let circlePath = CGPathCreateMutable()
        
        CGPathAddEllipseInRect(circlePath, nil, rect)
        CGContextAddPath(ctx, circlePath)
        color.set()
        CGContextSetLineWidth(ctx, CircleEdgeWidth)
        CGContextStrokePath(ctx)
        //        CGPathRelease(circlePath)
        
        
    }
    //MARK:- 花实心圆
    /**
     画实心圆
     
     - parameter ctx:   图形上下文
     - parameter rect:  绘制范围
     - parameter radio: 占大圆比例
     - parameter color: 绘制颜色
     */
    private func drawSolidCircleWithContext(ctx: CGContextRef,rect: CGRect, radio: CGFloat, color: UIColor) {
        
        let circlePath = CGPathCreateMutable()
        CGPathAddEllipseInRect(circlePath, nil, CGRect(x: rect.size.width / 2 * (1 - radio) + CircleEdgeWidth, y: rect.size.width / 2 * (1 - radio) + CircleEdgeWidth, width: rect.size.width * radio - CircleEdgeWidth * 2, height: rect.size.width * radio - CircleEdgeWidth * 2))
        color.set()
        CGContextAddPath(ctx, circlePath)
        CGContextFillPath(ctx)
        //
        CGContextStrokePath(ctx)
        //        CGPathRelease(circlePath)
        
    }
    
    
    //MARK:- 画三角形
    private func drawTrangleWithContext(ctx: CGContextRef,point: CGPoint,length: CGFloat,color: UIColor) {
        
        
        let trianglePathM = CGPathCreateMutable()
        CGPathMoveToPoint(trianglePathM, nil, point.x , point.y)
        CGPathAddLineToPoint(trianglePathM, nil, point.x - length/2, point.y + length/2)
        CGPathAddLineToPoint(trianglePathM, nil, point.x + length/2, point.y + length/2)
        
        CGContextAddPath(ctx, trianglePathM)
        color.set()
        CGContextFillPath(ctx)
        //
        CGContextStrokePath(ctx)
        //        CGPathRelease(trianglePathM)
        
    }
    
    
    
}

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
    //    @objc(init)
    init(){
        
        super.init(frame: CGRectZero)
        lockViewPrepare()
        circleSet = NSMutableArray()
        //        super.init()
    }
    //    convenience init() {
    //        self.init()
    //        lockViewPrepare()
    //    }
    
    
    
    init(frame: CGRect,type: CircleViewType,clip: Bool,arrow: Bool) {
        super.init(frame: frame)
        self.type = type
        self.clip = clip
        self.arrow = arrow
        lockViewPrepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.lockViewPrepare()
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func lockViewPrepare() {
        
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width - CircleViewEdgeMargin * 2, height: UIScreen.mainScreen().bounds.size.width - CircleViewEdgeMargin * 2)
        self.center = CGPoint(x: UIScreen.mainScreen().bounds.size.width / 2, y: CircleViewCenterY)
        
        /**
         *  默认裁剪子控件
         */
        self.clip = true
        self.arrow = true
        
        self.backgroundColor = CircleBackgroundColor
        
        for _ in 0..<9 {
            
            let circle = GYCircle()
            circle.type = CircleTye.CircleTypeGesture
            circle.isArrow = self.arrow!
         
            addSubview(circle)
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let itemViewWH = CircleRadius * 2
        let marginValue = (self.frame.size.width - 3 * itemViewWH) / 3.0
        (self.subviews as NSArray).enumerateObjectsUsingBlock { (object, idx, stop) in
            let row: NSInteger = idx % 3;
            let col = idx / 3;
            
            let x:CGFloat = marginValue * CGFloat(row) + CGFloat(row) * itemViewWH + marginValue/2
            let y: CGFloat = marginValue * CGFloat(col) + CGFloat(col) * itemViewWH + marginValue/2
            
            let frame = CGRect(x: x, y: y, width: itemViewWH, height: itemViewWH)
            
            //设置tag->用于记录密码的单元
            (object as! UIView).tag = idx + 1
            (object as! UIView).frame = frame
        }
        
        
    }
    
    override func drawRect(rect: CGRect) {
        //如果没有任何选中按钮  直接return
        if self.circleSet == nil || self.circleSet?.count == 0 {
            return
        }
        
        let color: UIColor?
        if getCircleState() == CircleState.CircleStateError {
            color = CircleConnectLineErrorColor
        } else {
            color = CircleConnectLineNormalColor
        }
        
        //绘制图案
        connectCirclesInRect(rect, color: color!)
        
    }
    
    //MARK: - 连线绘制图案(以设定颜色绘制)
    
    /**
     将选中的圆形以color颜色链接起来
     
     - parameter rect:  图形上下文
     - parameter color: 连线颜色
     */
    func connectCirclesInRect(rect: CGRect, color: UIColor) {
        
        //获取上下文
        let ctx = UIGraphicsGetCurrentContext()
        
        //添加路径
        CGContextAddRect(ctx, rect)
        
        //是否剪裁
        clipSubviewsWhenConnectInContext(ctx!, clip: self.clip)
        
        //剪裁上下文
        CGContextEOClip(ctx!)
        
        //遍历数组中的circle
        let num = self.circleSet?.count
        
        for i in 0..<num! {
            //取出选中按钮
            let circle = self.circleSet![i] as! GYCircle
            
            if i == 0 {//第一个按钮
                CGContextMoveToPoint(ctx!, circle.center.x,circle.center.y)
                
                
            } else {
                //全部是线
                CGContextAddLineToPoint(ctx!, circle.center.x, circle.center.y)
            }
            
        }
        weak var weakSelf = self
        //连接最后一个按钮到手指当前触摸的点
        if CGPointEqualToPoint(self.currentPoint!, CGPointZero) == false {
            (subviews as NSArray).enumerateObjectsUsingBlock({ (circle, idx, stop) in
                
                if weakSelf?.getCircleState() == CircleState.CircleStateError || weakSelf?.getCircleState() == CircleState.CircleStateLastOneError {
                    //如果是错误的状态下不连接到当前点
                } else {
                    CGContextAddLineToPoint(ctx, (self.currentPoint?.x)!, (self.currentPoint?.y)!)
                }
            })
        }
        
        //线条转角样式
        CGContextSetLineCap(ctx, CGLineCap.Round)
        CGContextSetLineJoin(ctx, CGLineJoin.Round)
        
        //设置绘图的属性
        CGContextSetLineWidth(ctx, CircleConnectLineWidth)
        
        //线条贪色
        color.set()
        
        //渲染路径
        CGContextStrokePath(ctx)
    }
    
    //MARK: - 是否剪裁
    func clipSubviewsWhenConnectInContext(ctx: CGContextRef,clip:Bool) {
        
        if clip {
            //遍历所有子控件
            (subviews as NSArray).enumerateObjectsUsingBlock({ (circle, idx, stop) in
                
                //确定剪裁的形状
                CGContextAddEllipseInRect(ctx, (circle as! GYCircle).frame)
                
            })
        }
        
    }
    //MARK:- 手势方法 began - moved - end
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        gestureEndResetMembers()
        currentPoint = CGPointZero
        let touch = (touches as NSSet).anyObject()
        
        let point = touch?.locationInView(self)
        (subviews as NSArray).enumerateObjectsUsingBlock { (circle, idx, stop) in
            
            
            let cir = circle as! GYCircle
            if CGRectContainsPoint(cir.frame, point!) {
                
                cir.state = CircleState.CircleStateSelected
                self.circleSet?.addObject(cir)
            }
            
        }
        
        //数组中最后一个对象的处理
        circleSetLastObjectWithState(CircleState.CircleStateLastOneSelected)
        setNeedsDisplay()
        
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        currentPoint = CGPointZero
        let touch = (touches as NSSet).anyObject()
        
        let point = touch?.locationInView(self)
        (subviews as NSArray).enumerateObjectsUsingBlock { (circle, idx, stop) in
            
            
            let cir = circle as! GYCircle
            if CGRectContainsPoint(cir.frame, point!) {
                
                if ((self.circleSet?.containsObject(cir)) != nil) {
                    
                } else {
                    self.circleSet?.addObject(cir)
                    
                    //move过程中的连线(包含跳跃连线的处理)
                    self.calAngleAndconnectTheJumpedCircle()
                }
            } else {
                self.currentPoint = point
            }
            
        }
        
        guard (self.circleSet != nil) else {
            return
        }
        
        (self.circleSet! as NSArray).enumerateObjectsUsingBlock { (circle, idx, stop) in
            
            let circlel = circle as! GYCircle
            circlel.state = CircleState.CircleStateSelected
            
            // 如果是登录或者验证原手势密码  就改为对应的状态
            if self.type != CircleViewType.CircleViewTypeSetting {
                circlel.state = CircleState.CircleStateLastOneSelected
            }
            
        }
        
        //数组中最后一个对象的处理
        self.circleSetLastObjectWithState(CircleState.CircleStateLastOneSelected)
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.hasClean = false
        guard self.circleSet != nil else {
            return
        }
        let gesture = self.getGestureResultFromCircleSet(self.circleSet!)
        
        let length = gesture.length
        
        if length == 0 {
            return
        }
        
        //手势绘制结果处理
        switch self.type! {
        case CircleViewType.CircleViewTypeSetting:
            gestureEndByTypeSettingWithGesture(gesture, length: CGFloat(length))
            break
        case CircleViewType.CircleViewTypeLogin:
            gestureEndByTypeLoginWithGesture(gesture, length: CGFloat(length))
        case CircleViewType.CircleViewTypeVerify:
            gestureEndByTypeVerifyWithGesture(gesture, length: CGFloat(length))
     
        }
        
        //手势结束后是否错误回显重绘，取决于是否延时清空数组和状态复原
        errorToDisplay()
        
    }
    
    func errorToDisplay() {
        weak var weakSelf = self
        if getCircleState() == CircleState.CircleStateError || getCircleState() == CircleState.CircleStateLastOneError {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(kdisplayTime) * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                
                weakSelf?.gestureEndResetMembers()
            })
            
            
        } else {
            gestureEndResetMembers()
        }
        
    }
    
    //MARK:- 手势结束时的清空操作
    func gestureEndResetMembers() {
        
        /**
         *  保证线程安全
         */
        synchronized(self) {
            self.hasClean = true
            if !self.hasClean! {
                
                //手势完毕、选中的圆回归普通状态
                self.changeCircleInCircleSetWithState(CircleState.CircleStateNormal)
                
                //清空数组
                self.circleSet?.removeAllObjects()
                
                //清空方向
                self.resetAllCirclesDirect()
                
                //完成之后改变clean的状态
                self.hasClean = true
            }
            
            
        }
        
    }
    
    // 雷同于OC 中 synchronized 所线程
    func synchronized(lock:AnyObject,block:() throws -> Void)  rethrows{
        objc_sync_enter(lock)
        defer{
            objc_sync_exit(lock)
        }
        try block()
    }
    
    //MARK:- 获取当前选中圆的状态
    func getCircleState() -> CircleState {
        return (self.circleSet?.firstObject as! GYCircle).state!
    }
    
    //MARK: - 清空所有子控件的方向
    func resetAllCirclesDirect() {
        
        (subviews as NSArray).enumerateObjectsUsingBlock { (obj, idx, stop) in
            (obj as! GYCircle).angle = 0
        }
    }
    
    //MARK:- 对数组最后一个对象的处理
    func circleSetLastObjectWithState(state: CircleState) {
        guard (self.circleSet != nil)  else {
            return
        }
        (self.circleSet?.lastObject as! GYCircle).state = state
    }
    
    //MARK: - 解锁类型: 设置 手势路径处理
    
    func gestureEndByTypeSettingWithGesture(gesture: NSString,length: CGFloat) {
        
        if Int(length) < CircleSetCountLeast {
            //连接少于最少个数(默认4个)
            
            //1.通知代理
            self.delegate?.circleViewConnectCirclesLessThanNeedWithGesture(self, type: self.type!, gesture: gesture as String)
            
            //2.改变状态为error
            changeCircleInCircleSetWithState(CircleState.CircleStateError)
        } else { //>= 4个
            let gestureOne = GYCircleConst.getGestureWithKey(gestureOneSaveKey)! as NSString
            
            if gestureOne.length < CircleSetCountLeast  { //接收并存储第一个密码
                
                // 记录第一次密码
                GYCircleConst.saveGesture(gesture as String, key: gestureOneSaveKey)
                
                self.delegate?.circleViewdidCompleteSetFirstGesture(self, type: self.type!, gesture:gesture as String )
                
                
            } else { //接收第二个密码并与第一个密码匹配，一致后存储起来
                let equal = gesture.isEqual(GYCircleConst.getGestureWithKey(gestureOneSaveKey)) //匹配两次手势
                
                //通知代理
                self.delegate?.circleViewdidCompleteSetSecondGesture(self, type: self.type!, gesture: gesture as String, result: equal)
                
                if equal {
                    // 一致，存储密码
                    GYCircleConst.saveGesture(gesture as String, key: gestureFinalSaveKey)
                } else {
                    //不一致 重绘回显
                    changeCircleInCircleSetWithState(CircleState.CircleStateError)
                }
            }
            
        }
        
    }
    
    //MARK: - 解锁类型:登陆  手势路径的处理
    func gestureEndByTypeLoginWithGesture(gesture: NSString, length:CGFloat) {
        
        let password = GYCircleConst.getGestureWithKey(gestureFinalSaveKey)! as NSString
        
        let  equal = gesture.isEqual(password)
        
        self.delegate?.circleViewdidCompleteLoginGesture(self, type: self.type!, gesture: gesture as String, result: equal)
        
        if equal {
            
        } else {
            self.changeCircleInCircleSetWithState(CircleState.CircleStateError)
        }
        
        
        
    }
    
    //MARK: - 解锁类型:验证 手势路径的处理
    func gestureEndByTypeVerifyWithGesture(gesture: NSString,length: CGFloat) {
        
        gestureEndByTypeLoginWithGesture(gesture, length: CGFloat(length))
        
    }
    
    
    
    //MARK: - 改变选中数组CircleSet子控件状态
    func changeCircleInCircleSetWithState(state: CircleState) {
        
        self.circleSet?.enumerateObjectsUsingBlock({ (circle, idx, stop) in
            
            let circleTy = circle as! GYCircle
            
            circleTy.state = state
            
            // 如果是错误状态，那就将最后一个按钮特殊处理
            if state == CircleState.CircleStateError {
                if idx == (self.circleSet?.count)! - 1 {
                    circleTy.state = CircleState.CircleStateLastOneError
                }
            }
            
        })
        
        setNeedsDisplay()
        
    }
    
    //MARK:- 每添加一个圆，就计算一次方向
    func calAngleAndconnectTheJumpedCircle() {
        
        if circleSet == nil || circleSet?.count <= 1 {
            return
        }
        
        //取出最后一个对象
        let lastOne = circleSet?.lastObject as! GYCircle
        
        //倒数第二个
        let lastTwo = circleSet?.objectAtIndex(self.circleSet!.count - 2) as! GYCircle
        
        //计算倒数第二个的位置
        let last_1_x = lastOne.center.x
        let last_1_y = lastOne.center.y
        
        let last_2_x = lastTwo.center.x
        let last_2_y = lastTwo.center.y
        
        //1.计算角度（反正切函数）
        let angle = atan2f(Float(last_1_y) - Float(last_2_y), Float(last_1_x) - Float(last_2_x)) + Float( M_PI_2)
        lastTwo.angle = CGFloat(angle)
        
        //2.处理跳跃连线
        let center = centerPointWithPointOneandTwo(lastOne.center, pointTwo: lastTwo.center)
        
        let centerCircle = self.enumCircleSetToFindWhichSubviewContainTheCenterPoint(center)
        
        if centerCircle != nil {
            //把跳过的圆加到数组中，他的位置是倒数第二个
            if !((self.circleSet?.containsObject(centerCircle!)) != nil) {
                self.circleSet?.insertObject(centerCircle!, atIndex: (self.circleSet?.count)! - 1)
                
            }
        }
        
    }
    
    //提供两个点，返回一个中心点
    func centerPointWithPointOneandTwo(pointOne: CGPoint,pointTwo: CGPoint) -> CGPoint
    {
        let x1 = pointOne.x > pointTwo.x ? pointOne.x : pointTwo.x
        let x2 = pointOne.x < pointTwo.x ? pointOne.x : pointTwo.x
        let y1 = pointOne.y > pointTwo.y ? pointOne.y : pointTwo.y
        let y2 = pointOne.y < pointTwo.y ? pointOne.y : pointTwo.y
        
        return CGPointMake((x1 + x2)/2, (y1 + y2)/2)
        
        
    }
    //MARK:- 给一个点，判断这个点是否被圆包含，如果包含就返回当前圆，如果不包含返回的是nil
    
    func enumCircleSetToFindWhichSubviewContainTheCenterPoint(point: CGPoint) ->  GYCircle? {
        
        var  centerCircle: GYCircle?
        
        for circle: GYCircle in subviews as! [GYCircle] {
            if CGRectContainsPoint(circle.frame, point) {
                centerCircle = circle
            }
        }
        
        if !(self.circleSet?.containsObject(centerCircle!))! {
            //这个circle的角度和倒数第二个circle角度一致
            
            centerCircle?.angle = self.circleSet?.objectAtIndex((self.circleSet?.count)! - 2).angle
        }
        guard (centerCircle != nil) else {
            print("此点不在圆内")
            return nil
        }
        return centerCircle!
    }
    
    
    //MARK: - 将circleSet数组解析遍历，拼手势密码字符串
    func getGestureResultFromCircleSet(circleSet: NSMutableArray) -> NSString {
        
        let gesture = NSMutableString.init()
        let circleSetArr = NSArray.init(array: circleSet)
        for circle: GYCircle in circleSetArr as! [GYCircle] {
            //遍历取tag拼接字符串
            gesture.appendString(String(circle.tag))
        }
        
        return gesture
        
    }
    
}

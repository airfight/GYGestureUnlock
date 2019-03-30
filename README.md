# GYGestureUnlock
***
Swift版仿支付宝的手势解锁，而且提供方法进行参数修改，能解决项目开发中所有手势解锁的开发
[swift3.0](https://github.com/airfight/GYGestureUnlock/tags)
## 此项目起因
* 个人学习OC版手势解锁，感觉只看源码，没有太大效果，于是乎将其完全照抄转化为了神奇的Swift
* [源OC版手势解锁](https://github.com/iosdeveloperpanc/PCGestureUnlock)
* 为更深入的了解奇妙的Swift

### 项目简介
1. 文件包GYTools      
    GYCircleConst:系统配置参数，错误语言提示，背景颜色等等，可根据自己的项目需要进行修改      
    GYCircleView:手势View
    GYCircle:单个圆
    GestureViewController:设置密码和登录两种情况的VC
    GestureVerifyViewController:验证手势和修改手势的VC
2. 核心实现方法
    GYCircleView:
    实现原理:每个圆添加tag拼接为字符串保存本地(项目中可传至服务器)进行比较      
        
        ` 
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
                print("添加子View的tag:\(cir.tag)")
            }
            
            
        }
        
        //数组中最后一个对象的处理
        circleSetLastObjectWithState(CircleState.CircleStateLastOneSelected)
        setNeedsDisplay()
        
        
         }
    
        override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        currentPoint = CGPointZero
        let touch = (touches as NSSet).anyObject()
        
        //获取手势所在的点坐标
        let point = touch?.locationInView(self)
        (subviews as NSArray).enumerateObjectsUsingBlock { (circle, idx, stop) in
        
        //我说
        let cir = circle as! GYCircle
        if CGRectContainsPoint(cir.frame, point!) {
                
                //此处脑残了 self.circleSet?.containsObject(cir) != nil
                // 判断数组中是否包含此view 包含不添加 不包含则添加
                if self.circleSet!.containsObject(cir) {
                    //                    print("添加子View的tag:\(cir.tag)")
                    //                    self.circleSet?.addObject(cir)
                    //                    self.calAngleAndconnectTheJumpedCircle()
                } else {
                    self.circleSet?.addObject(cir)
                    
                    // move过程中的连线(包含跳跃连线的处理)
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
        let angle = atan2(Float(last_1_y) - Float(last_2_y), Float(last_1_x) - Float(last_2_x)) + Float( M_PI_2)
        lastTwo.angle = CGFloat(angle)
        print(lastTwo.angle)
        //2.处理跳跃连线
        let center = centerPointWithPointOneandTwo(lastOne.center, pointTwo: lastTwo.center)
        
        let centerCircle = self.enumCircleSetToFindWhichSubviewContainTheCenterPoint(center)
        
        if centerCircle != nil {
            //把跳过的圆加到数组中，他的位置是倒数第二个
            if !(self.circleSet!.containsObject(centerCircle!)) {
                //插入数组中
                self.circleSet?.insertObject(centerCircle!, atIndex: (self.circleSet?.count)! - 1)
                //指定此圆的角度与上一个角度相同。否则会造成移位
                centerCircle?.angle = lastTwo.angle
                
            }
           }
         
        }
        `
3. 遇到的swift的坑      
    1)各处nil     
    2)Swift的重写GET和SET方法     
    3)init初始化      
    4)一些可选值未初始化时会nil导致崩溃、等等宝宝好像哭。        
    
    [简书](http://www.jianshu.com/p/c2b437faee67)
   毕竟我是一个菜菜菜鸟，望有Bug和好的建议了邮件我GiantForJade@163.com QQ(270535693),求Star,3Q。

  



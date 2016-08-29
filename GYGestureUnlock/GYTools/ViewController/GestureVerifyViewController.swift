//
//  GestureVerifyViewController.swift
//  GYGestureUnlock
//
//  Created by zhuguangyang on 16/8/29.
//  Copyright © 2016年 Giant. All rights reserved.
//

import UIKit

class GestureVerifyViewController: UIViewController {
    
    
    /// 默认为验证手势
    var isToSetNewGesture:Bool = false
    
    private var msgLabel: GYLockLabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CircleViewBackgroundColor
        self.title = "验证手势解锁"
        
        let lockView = GYCircleView()
        lockView.delegate = self
        lockView.type = CircleViewType.CircleViewTypeVerify
        view.addSubview(lockView)
        
        let msgLabel = GYLockLabel()
        msgLabel.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 14)
        msgLabel.center = CGPoint(x: kScreenW/2, y: CGRectGetMinY(lockView.frame) - 30)
        msgLabel.showNormalMag(gestureTextOldGesture)
        self.msgLabel = msgLabel
        view.addSubview(msgLabel)
        
        
        
    }
}

extension GestureVerifyViewController:GYCircleViewDelegate{
    
    
    func circleViewdidCompleteLoginGesture(view: GYCircleView, type: CircleViewType, gesture: String, result: Bool) {
        
        if type == CircleViewType.CircleViewTypeVerify {
            if result {
                print("验证成功")
        
                if isToSetNewGesture {
                    let gesture = GestureViewController()
                    gesture.type = GestureViewControllerType.Setting
                    
                    navigationController?.pushViewController(gesture, animated: true)
                    
                } else {
                    navigationController?.popToRootViewControllerAnimated(true)
                }
                
            } else {
                print("密码错误!")
                self.msgLabel?.showWarnMsg(gestureTextGestureVerifyError)
            }
        }
        
    }
    
    func circleViewdidCompleteSetFirstGesture(view: GYCircleView, type: CircleViewType, gesture: String) {
        
    }
    
    func circleViewConnectCirclesLessThanNeedWithGesture(view: GYCircleView, type: CircleViewType, gesture: String) {
        
    }
    
    func circleViewdidCompleteSetSecondGesture(view: GYCircleView, type: CircleViewType, gesture: String, result: Bool) {
        
    }
    
}

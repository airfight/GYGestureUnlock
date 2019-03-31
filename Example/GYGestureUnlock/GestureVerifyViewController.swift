//
//  GestureVerifyViewController.swift
//  GYGestureUnlock
//
//  Created by zhuguangyang on 16/8/29.
//  Copyright © 2016年 Giant. All rights reserved.
//

import UIKit
import GYGestureUnlock

public let kScreenW = UIScreen.main.bounds.size.width
public let kScreenH = UIScreen.main.bounds.size.height


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
        lockView.type = CircleViewType.circleViewTypeVerify
        view.addSubview(lockView)
        
        let msgLabel = GYLockLabel()
        msgLabel.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 14)
        msgLabel.center = CGPoint(x: kScreenW/2, y: lockView.frame.minY - 30)
        msgLabel.showNormalMag(gestureTextOldGesture as NSString)
        self.msgLabel = msgLabel
        view.addSubview(msgLabel)
        
        
        
    }
}

extension GestureVerifyViewController:GYCircleViewDelegate{
    
    
    func circleViewdidCompleteLoginGesture(_ view: GYCircleView, type: CircleViewType, gesture: String, result: Bool) {
        
        if type == CircleViewType.circleViewTypeVerify {
            if result {
                print("验证成功")
        
                if isToSetNewGesture {
                    let gesture = GestureViewController()
                    gesture.type = GestureViewControllerType.setting
                    
                    navigationController?.pushViewController(gesture, animated: true)
                    
                } else {
                    navigationController?.popToRootViewController(animated: true)
                }
                
            } else {
                print("密码错误!")
                self.msgLabel?.showWarnMsg(gestureTextGestureVerifyError)
            }
        }
        
    }
    
    func circleViewdidCompleteSetFirstGesture(_ view: GYCircleView, type: CircleViewType, gesture: String) {
        
    }
    
    func circleViewConnectCirclesLessThanNeedWithGesture(_ view: GYCircleView, type: CircleViewType, gesture: String) {
        
    }
    
    func circleViewdidCompleteSetSecondGesture(_ view: GYCircleView, type: CircleViewType, gesture: String, result: Bool) {
        
    }
    
}

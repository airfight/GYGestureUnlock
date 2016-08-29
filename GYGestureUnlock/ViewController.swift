//
//  ViewController.swift
//  GYGestureUnlock
//
//  Created by zhuguangyang on 16/8/19.
//  Copyright © 2016年 Giant. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UIAlertViewDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "手势解锁"
        
    }
    
    @IBAction func btnAction(sender: UIButton) {
        
        switch sender.tag {
        case 1:
            //设置手势密码
            let gesture = GestureViewController()
            gesture.type = GestureViewControllerType.Setting
            
            navigationController?.pushViewController(gesture, animated: true)
            
            break
        case 2:
            //登录手势密码
            print(GYCircleConst.getGestureWithKey(gestureOneSaveKey))
            if GYCircleConst.getGestureWithKey(gestureFinalSaveKey) != nil {
                
                let gestureVC = GestureViewController()
                gestureVC.type = GestureViewControllerType.Login
                
                navigationController?.pushViewController(gestureVC, animated: true)
                
                
            } else {
                let  alertView = UIAlertView(title: "温馨提示", message: "暂未设置手势密码,是否前往设置", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "设置")
            
                alertView.show()
            }
            
            break
        case 3:
            //验证手势密码
            let gestureVerifyVc  = GestureVerifyViewController()
            navigationController?.pushViewController(gestureVerifyVc, animated: true)
            
            break
        case 4:
            //修改手势密码
            let gestureVerifyVc  = GestureVerifyViewController()
            gestureVerifyVc.isToSetNewGesture = true
            navigationController?.pushViewController(gestureVerifyVc, animated: true)
            break
        default:
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UIALertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 1 {
            let gesture = GestureViewController()
            gesture.type = GestureViewControllerType.Setting
            
            navigationController?.pushViewController(gesture, animated: true)
            
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = false
    }
    
}


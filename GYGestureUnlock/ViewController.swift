//
//  ViewController.swift
//  GYGestureUnlock
//
//  Created by zhuguangyang on 16/8/19.
//  Copyright © 2016年 Giant. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController ,UIAlertViewDelegate{
    
    @IBOutlet weak var touchIDSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "手势解锁"
        
       
        touchIDSwitch.addTarget(self, action: #selector(ViewController.touchIDAction(_:)), for: UIControl.Event.valueChanged)
        
    }
    
    
    @objc func touchIDAction(_ touchSw: UISwitch) {
        switch touchSw.isOn {
        case false:
            print("指纹解锁已关闭关闭")
        case true:
            print("指纹解锁已开启")
            
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            //设置手势密码
            let gesture = GestureViewController()
            gesture.type = GestureViewControllerType.setting
            
            navigationController?.pushViewController(gesture, animated: true)
            
            break
        case 2:
            //登录手势密码
            if GYCircleConst.getGestureWithKey(gestureFinalSaveKey) != nil {
                
                let gestureVC = GestureViewController()
                gestureVC.type = GestureViewControllerType.login
                
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
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 1 {
            let gesture = GestureViewController()
            gesture.type = GestureViewControllerType.setting
            
            navigationController?.pushViewController(gesture, animated: true)
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
}


//
//  AppDelegate.swift
//  GYGestureUnlock
//
//  Created by zhuguangyang on 16/8/19.
//  Copyright © 2016年 Giant. All rights reserved.
//

import UIKit
import LocalAuthentication

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let context = LAContext()
        var autherror: NSError?
        var errorReason = "Secret"
        
        context.localizedFallbackTitle = "忘记密码"
        
        if Float(UIDevice.currentDevice().systemVersion) < 8.0 {
            return false
        }
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &autherror) {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason:errorReason, reply: { (sucess, error) in
                
                if sucess {
                    print("sucess")
                } else {
                    print("failed")
                    guard autherror != nil else {
                        return
                    }
                    switch autherror!.code {
                    case LAError.SystemCancel.rawValue:
                        print("系统取消授权")
                     
                    case LAError.UserCancel.rawValue:
                        print("用户取消验证")
                   
                    case LAError.AuthenticationFailed.rawValue:
                        print("授权失败")
                  
                    case LAError.PasscodeNotSet.rawValue:
                        print("系统未设置密码")
              
                    case LAError.TouchIDNotAvailable.rawValue:
                        print("设备touchID不可用:未打开等等")
      
                    case LAError.TouchIDNotEnrolled.rawValue:
                        print("用户未录入指纹")
                    case LAError.UserFallback.rawValue:
                        print("用户选择输入密码")
                        
                    default:
                        print("-----")
                    }
                }
                
            })
        } else {
            
            print("搞搞搞")
            //不支持指纹识别
           print(autherror?.localizedDescription)
        }
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


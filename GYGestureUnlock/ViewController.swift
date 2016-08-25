//
//  ViewController.swift
//  GYGestureUnlock
//
//  Created by zhuguangyang on 16/8/19.
//  Copyright © 2016年 Giant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "手势解锁"
     
    }

    @IBAction func btnAction(sender: UIButton) {
        
        switch sender.tag {
        case 1:
            let gesture = GestureViewController()
            gesture.type = GestureViewControllerType.Setting
            
            navigationController?.pushViewController(gesture, animated: true)
            
            break
        case 2:
            
            break
        case 3:
            
            break
        case 4:
            
            break
        default:
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


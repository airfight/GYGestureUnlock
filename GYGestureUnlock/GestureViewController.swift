//
//  GestureViewController.swift
//  GYGestureUnlock
//
//  Created by zhuguangyang on 16/8/24.
//  Copyright © 2016年 Giant. All rights reserved.
//

import UIKit

enum GestureViewControllerType: Int {
    case Setting = 1
    case Login
}

enum buttonTag: Int {
    case Rest = 1
    case Manager
    case Forget
}

class GestureViewController: UIViewController {
    
    
    /// 控制器的来源类型:设置密码、登录
    var type:GestureViewControllerType?
    
    /// 重置按钮
    private var resetBtn: UIButton?
    
    /// 提示Label
    private var msgLabel: GYLockLabel?
    
    /// 解锁界面
    private  var lockView: GYCircleView?
    
    /// infoView
    private var infoView: GYCircleInfoView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CircleViewBackgroundColor
        
        //1.界面相同部分生成器
        setupSameUI()
        
        //2.界面不同部分生成器
        setupDifferentUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        if self.type == GestureViewControllerType.Login {
            navigationController?.navigationBarHidden = true
        }
        
        //进来先清空存储的第一个密码
        GYCircleConst.saveGesture("", key: gestureOneSaveKey)
    }
    
    
    func setupSameUI(){
        
        //创建导航栏右边按钮
        self.navigationItem.rightBarButtonItem = itemWithTile("重设", target: self, action: #selector(GestureViewController.didClickBtn(_:)), tag: buttonTag.Rest.rawValue)
        
        //解锁界面
        let lockView = GYCircleView()
        lockView.delegate = self
        self.lockView = lockView
        view.addSubview(lockView)
        
        let msgLabel = GYLockLabel.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 14))
        msgLabel.center = CGPoint(x: kScreenW/2, y: CGRectGetMinY(lockView.frame) - 30)
        
        self.msgLabel = msgLabel
        
        view.addSubview(msgLabel)
        
    }
    
    //MARK:- 创建UIBarButtonItem
    
    func itemWithTile(title: NSString,target: AnyObject,action: Selector,tag: NSInteger) -> UIBarButtonItem{
        
        let button = UIButton(type: UIButtonType.Custom)
        button.setTitle(title as String, forState: UIControlState.Normal)
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        button.tag = tag
        button.contentHorizontalAlignment = .Right
        button.hidden = true
        self.resetBtn = button
        
        return UIBarButtonItem(customView: button)
        
        
        
    }
    //    
    //    func didClickBtn(sender: UIButton) {
    //        
    //        
    //        switch sender.tag {
    //        case buttonTag.Rest.rawValue:
    //            
    //            self.resetBtn?.hidden = true
    //            
    //            self.infoViewDeselectedSubviews()
    //            
    //            self.msgLabel?.showNormalMag(gestureTextBeforeSet)
    //            
    //            GYCircleConst.saveGesture("", key: gestureOneSaveKey)
    //            
    //            break
    //        case buttonTag.Manager:
    //            print("点击了管理手势密码")
    //            break
    //            
    //        default:
    //            <#code#>
    //        }
    //        
    //    }
    //    
    func setupDifferentUI() {
        
        switch self.type! {
        case GestureViewControllerType.Setting:
            setupSubViewsSettingVc()
            break
        case GestureViewControllerType.Login:
            setupSubViewsLoginVc()
            break
            
        }
    }
    
    //MARK: -设置手势密码界面
    func setupSubViewsSettingVc() {
        
        self.lockView?.type = CircleViewType.CircleViewTypeSetting
        
        title = "设置手势密码"
        
        self.msgLabel?.showNormalMag(gestureTextBeforeSet)
        
        let infoView = GYCircleInfoView()
        infoView.frame = CGRect(x: 0, y: 0, width: CircleRadius * 2 * 0.6, height: CircleRadius * 2 * 0.6)
        
        infoView.center = CGPoint(x: kScreenW/2, y: CGRectGetMinY(self.msgLabel!.frame) - CGRectGetHeight(infoView.frame)/2 - 10)
        self.infoView = infoView
        view.addSubview(infoView)
        
        
    }
    
    //MARK: - 登录手势密码
    func setupSubViewsLoginVc() {
        self.lockView?.type = CircleViewType.CircleViewTypeLogin
        
        //头像
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
        imageView.center = CGPoint(x: kScreenW/2, y: kScreenH/2)
        imageView.image = UIImage(named: "head")
        view.addSubview(imageView)
        
        //管理手势密码
        let leftBtn = UIButton(type: UIButtonType.Custom)
        
        creatButton(leftBtn, frame: CGRectMake(CircleViewEdgeMargin + 20, kScreenH - 60, kScreenW/2, 20) , titlr: "管理手势密码", alignment: UIControlContentHorizontalAlignment.Left, tag: buttonTag.Manager.rawValue)
        
        //登录其它账户
        let rightBtn = UIButton(type: UIButtonType.Custom)
        
        creatButton(rightBtn, frame: CGRectMake(kScreenW/2 - CircleViewEdgeMargin - 20, kScreenH - 60, kScreenW/2, 20), titlr: "登录其他账户", alignment: UIControlContentHorizontalAlignment.Right, tag: buttonTag.Forget.rawValue)
        
        
        
    }
    
    //MARK: - 创建Button
    func creatButton(btn: UIButton,frame: CGRect,titlr: NSString,alignment: UIControlContentHorizontalAlignment,tag: NSInteger) {
        btn.frame = frame
        btn.tag = tag
        btn.setTitle(titlr as String, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.contentHorizontalAlignment = alignment
        btn.titleLabel?.font = UIFont.systemFontOfSize(14)
        btn.addTarget(self, action: #selector(GestureViewController.didClickBtn(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(btn)
        
    }
    
    func didClickBtn(sender:UIButton){
        
        switch sender.tag {
        case buttonTag.Rest.rawValue:
            //1.隐藏按钮
            self.resetBtn?.hidden = true
            
            //2.infoView取消选中
            infoViewDeselectedSubviews()
            
            //3.msgLabel提示文字复位
            self.msgLabel?.showNormalMag(gestureTextBeforeSet)
            
            //4.清除之前存储的密码
            GYCircleConst.saveGesture(nil, key: gestureOneSaveKey)
            break
        case buttonTag.Manager.rawValue:
            print("点击了手势管理密码按钮")
            break
        case buttonTag.Forget.rawValue:
            print("点击了登录其他账户按钮")
            break
        default:
            break
        }
        
    }
    
    //MARK: - 让infoView对应按钮取消选中
    func infoViewDeselectedSubviews() {
        
        ((self.infoView?.subviews)! as NSArray).enumerateObjectsUsingBlock { (obj, idx, stop) in
            
            (obj as! GYCircle).state = CircleState.CircleStateNormal
        }
        
    }
}

extension GestureViewController: GYCircleViewDelegate {
    
    func circleViewConnectCirclesLessThanNeedWithGesture(view: GYCircleView, type: CircleViewType, gesture: String) {
        
        let gestureOne = GYCircleConst.getGestureWithKey(gestureOneSaveKey)! as NSString
        
        //看是否存在第一个密码
        if gestureOne.length == 0 {
            self.resetBtn?.hidden = false
            self.msgLabel?.showWarnMsgAndShake(gestureTextDrawAgainError)
        } else {
            print("密码长度不合格\(gestureOne.length)")
            self.msgLabel?.showWarnMsgAndShake(gestureTextConnectLess as String)
        }
        
        
    }
    
    func circleViewdidCompleteSetFirstGesture(view: GYCircleView, type: CircleViewType, gesture: String) {
        
        print("获取第一个手势密码\(gesture)")
        
        self.msgLabel?.showWarnMsgAndShake(gestureTextDrawAgain)
        
        //infoView展示对应选中的圆
        infoViewSelectedSubviewsSameAsCircleView(view)
        
        
        
    }
    
    
    
    func circleViewdidCompleteSetSecondGesture(view: GYCircleView, type: CircleViewType, gesture: String, result: Bool) {
        
        print("获得第二个手势密码\(gesture)")
        
        if result {
            print("两次手势匹配！可以进行本地化保存了")
            
            self.msgLabel?.showWarnMsg(gestureTextSetSuccess)
            GYCircleConst.saveGesture(gesture, key: gestureFinalSaveKey)
            navigationController?.popViewControllerAnimated(true)
        } else {
            print("两次手势不匹配")
            self.msgLabel?.showWarnMsgAndShake(gestureTextDrawAgainError)
            self.resetBtn?.hidden = false
        }
        
    }
    
    func circleViewdidCompleteLoginGesture(view: GYCircleView, type: CircleViewType, gesture: String, result: Bool) {
        
        
        //此时的type有两种情况 Login or verify
        if type == CircleViewType.CircleViewTypeLogin {
            if result {
                print("登录成功!")
                navigationController?.popViewControllerAnimated(true)
            } else {
                print("密码错误")
                self.msgLabel?.showWarnMsgAndShake(gestureTextGestureVerifyError)
            }
        } else  if type == CircleViewType.CircleViewTypeVerify {
            if result {
                print("验证成功，跳转到设置手势界面")
            } else {
                print("原手势密码输入错误!")
            }
            
        }
    }
    
    
    //MARK: - 相关方法
    
    func infoViewSelectedSubviewsSameAsCircleView(circleView: GYCircleView){
        for circle: GYCircle in circleView.subviews as! [GYCircle] {
            
            if circle.state == CircleState.CircleStateSelected || circle.state == CircleState.CircleStateLastOneSelected {
                for infoCircle:GYCircle in self.infoView?.subviews as! [GYCircle]{
                    if infoCircle.tag == circle.tag {
                        infoCircle.state = CircleState.CircleStateSelected
                    }
                }
            }
            
        }
    }
    
}

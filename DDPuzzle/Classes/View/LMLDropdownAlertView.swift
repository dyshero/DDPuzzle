//
//  LMLDropdownAlertView.swift
//  LMLDropdownAlertView
//
//  Created by 优谱德 on 2016/11/13.
//  Copyright © 2016年 youpude. All rights reserved.
//

import UIKit

let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.size.width  //屏幕宽度
let SCREEN_HEIGHT:CGFloat = UIScreen.main.bounds.size.height
let MAIN_COLOR = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)

class LMLDropdownAlertView: UIView {

    var contentView = UIView()
    var titleLabel: UILabel = UILabel()
    var subTitleTextView = UILabel()
    
    let margin_ver: CGFloat = 12.0
    let margin_top: CGFloat = 15
    let margin_hor: CGFloat = 10.0
    
    let max_height: CGFloat = 300.0
    var content_width: CGFloat = 300.0
    var tv_height: CGFloat = 90.0
    var title_height:CGFloat = 44.0
    var btnArr: [UIButton] = []
    var clickResponse:((_ button: UIButton) -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        self.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.7)
        self.addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 初始化界面
    func setupContentView() {
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleTextView)
        contentView.backgroundColor = UIColor.colorFromRGB(rgbValue: 0xFFFFFF)
        contentView.layer.borderColor = UIColor.colorFromRGB(rgbValue: 0xCCCCCC).cgColor
        self.addSubview(contentView)
    }
    
    func setupTitleLabel() {
        titleLabel.text = "提示"
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Helvetica", size:18)
    }
    
    func setupSubtitleTextView() {
        subTitleTextView.text = "确定要退出游戏？"
        subTitleTextView.textAlignment = .center
        subTitleTextView.font = UIFont(name: "Helvetica", size:14)
        subTitleTextView.textColor = UIColor.colorFromRGB(rgbValue: 0x797979)
    }
    
    //MARK: -布局
    func resizeAndRelayout() {
        self.alpha = 0.0
        let mainScreenBounds = UIScreen.main.bounds
        self.frame.size = mainScreenBounds.size
        let x: CGFloat = margin_hor
        var y: CGFloat = margin_top
        let width: CGFloat = content_width - (margin_hor*2)
        // Title
        if self.titleLabel.text != nil {
            let titleString = titleLabel.text! as NSString
            let rect = titleString.boundingRect(with: CGSize(width: width, height: 0.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleLabel.font!], context: nil)
            title_height = ceil(rect.size.height)
            titleLabel.frame = CGRect(x: 0, y: y, width: content_width, height: title_height)
            contentView.addSubview(titleLabel)
            y += title_height + margin_ver
        }
        
        if self.subTitleTextView.text != nil {
            let subtitleString = subTitleTextView.text! as NSString
            let rect = subtitleString.boundingRect(with: CGSize(width: width, height: 0.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:subTitleTextView.font!], context: nil)
            tv_height = ceil(rect.size.height) + margin_ver
            subTitleTextView.frame = CGRect(x: x, y: y, width: width, height: tv_height)
            contentView.addSubview(subTitleTextView)
            y += tv_height + margin_ver
        }
        
        let lineView = UIView(frame: CGRect.init(x: 0, y: y, width: content_width, height: 0.5))
        lineView.backgroundColor = MAIN_COLOR
        self.contentView.addSubview(lineView)
        y += 0.5;
        
        var buttonRect:[CGRect] = []
        for button in btnArr {
            let string = button.title(for: UIControlState.normal)! as NSString
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            buttonRect.append(string.boundingRect(with: CGSize(width: width, height:0.0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:[NSFontAttributeName:button.titleLabel!.font], context:nil))
        }
        
        var totalWidth: CGFloat = 0.0
        if btnArr.count == 2 {
            totalWidth = buttonRect[0].size.width + buttonRect[1].size.width + margin_hor + 40.0
        }
        else{
            totalWidth = buttonRect[0].size.width + 20.0
        }
        var buttonX = (content_width - totalWidth ) / 2.0
        
        // 如果只有2个按钮
        if btnArr.count == 2 {

            let button_one = btnArr[0]
            let button_two = btnArr[1]

            let btn_height: CGFloat = 40.0

            button_one.frame = CGRect.init(x: 0, y: y, width: (content_width - 0.5)/2.0 , height: btn_height)
            button_one.titleLabel?.font = UIFont(name: "Helvetica", size:16)
            button_one.setTitleColor(UIColor.black, for: UIControlState.normal)
            
            let secondLineView = UIView.init(frame: CGRect.init(x: (content_width - 0.5)/2.0, y: y, width: 0.5, height: btn_height))
            secondLineView.backgroundColor = MAIN_COLOR
            self.contentView.addSubview(secondLineView)
            
            button_two.frame = CGRect.init(x: content_width / 2.0, y: y, width: (content_width - 0.5)/2.0 , height: btn_height)
            button_two.titleLabel?.font = UIFont(name: "Helvetica", size:16)
            button_two.setTitleColor(UIColor.black, for: UIControlState.normal)
            
            self.contentView.addSubview(btnArr[0])
            self.contentView.addSubview(btnArr[1])
            
        }else {
            for i in 0 ..< btnArr.count {
                btnArr[i].frame = CGRect(x: buttonX, y: y, width: buttonRect[i].size.width + 20.0, height: buttonRect[i].size.height + 10.0)
                buttonX = btnArr[i].frame.origin.x + margin_hor + buttonRect[i].size.width + 20.0
                btnArr[i].layer.cornerRadius = 5.0
                self.contentView.addSubview(btnArr[i])
        
            }
        }
        
        y += margin_ver + buttonRect[0].size.height + 10.0
        if y > max_height {
            let diff = y - max_height
            let sFrame = subTitleTextView.frame
            subTitleTextView.frame = CGRect(x: sFrame.origin.x, y: sFrame.origin.y, width: sFrame.width, height: sFrame.height - diff)
            
            for button in btnArr {
                let bFrame = button.frame
                button.frame = CGRect(x: bFrame.origin.x, y: bFrame.origin.y - diff, width: bFrame.width, height: bFrame.height)
                
            }
            y = max_height
        }
        
        contentView.frame = CGRect(x: (mainScreenBounds.size.width - content_width) / 2.0, y: (mainScreenBounds.size.height - y) / 2.0, width: content_width, height: y)
        contentView.clipsToBounds = true
        
        //进入时的动画
        contentView.transform = CGAffineTransform(translationX: 0, y: -SCREEN_HEIGHT/2)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            
            self.contentView.transform = CGAffineTransform.identity    // CGAffineTransformIdentity
            self.alpha = 1.0
            }, completion: nil)
    }

    //MARK: -取消
    func doCancel(sender:UIButton){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.alpha = 0.0
            self.contentView.transform = CGAffineTransform(translationX: 0, y: SCREEN_HEIGHT)
        }) { (Bool) -> Void in
            self.removeFromSuperview()
            self.cleanUpAlert()
        }
    }
    
    private func cleanUpAlert() {
        self.contentView.removeFromSuperview()
        self.contentView = UIView()
    }
    func pressed(sender: UIButton!) {
        if clickResponse !=  nil {
            clickResponse!(sender)
        }
    }
   
    
}

extension LMLDropdownAlertView {

    func showAlert(title: String, detail_Title:String, cancleButtonTitle:String, confirmButtonTitle:String, action:@escaping((_ confirmButton:UIButton) -> Void) ) {
        
        clickResponse = action
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(self)
        window.bringSubview(toFront: self)
        self.frame = window.bounds
        self.setupContentView()
        self.setupTitleLabel()
        self.setupSubtitleTextView()
        
        self.titleLabel.text = title
        
        self.subTitleTextView.text = detail_Title
        
        btnArr = []
        if cancleButtonTitle.isEmpty == false {
            let button: UIButton = UIButton()
            button.setTitle(cancleButtonTitle, for: UIControlState.normal)
            button.isUserInteractionEnabled = true
            button.addTarget(self, action: #selector(doCancel), for: UIControlEvents.touchUpInside)
            button.tag = 0
            btnArr.append(button)
        }
        
        if confirmButtonTitle.isEmpty == false {
            
            let button: UIButton = UIButton(type: UIButtonType.custom)
            button.setTitle(confirmButtonTitle, for: UIControlState.normal)
            button.addTarget(self, action: #selector(pressed(sender:)), for: UIControlEvents.touchUpInside)
            button.addTarget(self, action: #selector(doCancel), for: UIControlEvents.touchUpInside)
            
            button.tag = 1
            btnArr.append(button)
        }
        resizeAndRelayout()
        
    }
}

extension UIColor {
    class func colorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

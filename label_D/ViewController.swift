//
//  ViewController.swift
//  label_D
//
//  Created by idea on 2017/12/26.
//  Copyright © 2017年 idea. All rights reserved.
//

import UIKit
import LTMorphingLabel
import Cupcake
import TextFieldEffects
import Async

class ViewController: UIViewController {
    var lab:LTMorphingLabel!
    var lab1:LTMorphingLabel!
    var ang = ["炉烟缭绕","像一尺纱"]
    var i=1
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUIlab()
        setupUItextField()
        setupUIbtn()
        setupAsync()
        setupGCD()
    }
    /**
    Swift 3 在GCD的语法上改变了很多，更加贴近了swift的语法，而且关于队列的优先级也改变了不少。
    原先的GCD只有四个优先级，high，default，low，background
    然而现在的GCD有六个优先级，background，utility，default，userInitiated，userInteractive，unspecified
    
    经过试验，得出了几个结论，
    userInteractive的优先级最高，相当于high
    background的优先级最低，相当于原来的background
    
    default的优先级高于unspecified，userInitiated，utility
    unspecified的优先级高于userInitiated，utility
    userInitiated的优先级高于utility
    
    userInteractive>default>unspecified>userInitiated>utility>background
    **/
    func setupGCD(){
        let group = AsyncGroup()
        group.background {
            //在后台队列上运行
        }
        group.utility {
            //在实用程序队列上运行，并行于上一个块
        }
        group.wait()
    }
    
    func setupAsync(){
        Async.userInteractive {
            return 10
            }.background {
                return "结果：\($0)"
            }.main {
                print("\($0)")
        }
        let group = AsyncGroup()
        group.background {
            print("this is  backgroup..")
        }
        group.background {
            print("this is also banckgroup...")
        }
        group.userInitiated {
            print("this is userInitiated")
        }
        group.wait()
        print("both async 完成。。。")
        
//        延迟
        let seconds = 0.5
        Async.main(after: seconds) {
            
            print("after 0.5 seconds")
            }.background(after: 0.4) {
                print("0.4 + 0.5 seconds")
        }
    }
    func setupUIlab(){
        lab = LTMorphingLabel(frame: CGRect(x: 50, y: 80, width: 100, height: 50))
        lab.text = " "
        lab.morphingEffect = .sparkle
        view.addSubview(lab)
        //        let style1 = Styles.color("darkGray").font(15)
        lab1 = LTMorphingLabel()
        lab1.text = "  "
        lab1.makeCons { (make) in
            make.left.top.equal(lab).left.bottom.offset(0)
            make.width.height.equal(lab)
        }
        lab1.morphingEffect = .anvil
        view.addSubview(lab1)
    }
        func setupUItextField(){
            
            let textField = KaedeTextField()
            textField.placeholderColor = .darkGray
            textField.foregroundColor = .lightGray
            textField.makeCons { (make) in
                make.left.top.equal(lab1).left.bottom.offset(0)
                make.width.equal(lab).multiply(2)
                make.height.equal(lab)
            }
            view.addSubview(textField)
            
    }
    func setupUIbtn(){
        let btn = Button.str("按钮").bg("#ffbbcc").border(1).makeCons { (make) in
            make.left.top.equal(lab1).left.bottom.offset(150)
            make.width.equal(100)
            make.height.equal(50)
            
            }.onClick { (_) in
                self.lab.text = self.ang[self.i]
                self.lab1.text = self.ang[self.i]
                if self.i == 1{
                    self.i = 0
                }else{
                    self.i = 1
                }
                
        }
        view.addSubview(btn)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


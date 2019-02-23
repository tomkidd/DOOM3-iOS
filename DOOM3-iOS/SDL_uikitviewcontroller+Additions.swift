//
//  SDL2ViewController+Additions.swift
//  DOOM3-iOS
//
//  Created by Tom Kidd on 1/28/19.
//

import UIKit

extension SDL_uikitviewcontroller {
    
    // A method of getting around the fact that Swift extensions cannot have stored properties
    // https://medium.com/@valv0/computed-properties-and-extensions-a-pure-swift-approach-64733768112c
    struct Holder {
        static var _fireButton = UIButton()
        static var _jumpButton = UIButton()
        static var _joystickView = JoyStickView(frame: .zero)
        static var _tildeButton = UIButton()
        static var _expandButton = UIButton()
        static var _escapeButton = UIButton()
        static var _quickSaveButton: UIButton!
        static var _quickLoadButton: UIButton!
        static var _buttonStack = UIStackView(frame: .zero)
        static var _buttonStackExpanded = false
        static var _f1Button = UIButton()
        static var _prevWeaponButton = UIButton()
        static var _nextWeaponButton = UIButton()
 }
    
    var fireButton:UIButton {
        get {
            return Holder._fireButton
        }
        set(newValue) {
            Holder._fireButton = newValue
        }
    }
    
    var jumpButton:UIButton {
        get {
            return Holder._jumpButton
        }
        set(newValue) {
            Holder._jumpButton = newValue
        }
    }
    
    var joystickView:JoyStickView {
        get {
            return Holder._joystickView
        }
        set(newValue) {
            Holder._joystickView = newValue
        }
    }

    var tildeButton:UIButton {
        get {
            return Holder._tildeButton
        }
        set(newValue) {
            Holder._tildeButton = newValue
        }
    }

    var escapeButton:UIButton {
        get {
            return Holder._escapeButton
        }
        set(newValue) {
            Holder._escapeButton = newValue
        }
    }

    var expandButton:UIButton {
        get {
            return Holder._expandButton
        }
        set(newValue) {
            Holder._expandButton = newValue
        }
    }
    
    var quickLoadButton:UIButton {
        get {
            return Holder._quickLoadButton
        }
        set(newValue) {
            Holder._quickLoadButton = newValue
        }
    }
    
    var quickSaveButton:UIButton {
        get {
            return Holder._quickSaveButton
        }
        set(newValue) {
            Holder._quickSaveButton = newValue
        }
    }
    
    var buttonStack:UIStackView {
        get {
            return Holder._buttonStack
        }
        set(newValue) {
            Holder._buttonStack = newValue
        }
    }

    var buttonStackExpanded:Bool {
        get {
            return Holder._buttonStackExpanded
        }
        set(newValue) {
            Holder._buttonStackExpanded = newValue
        }
    }
    
    var f1Button:UIButton {
        get {
            return Holder._f1Button
        }
        set(newValue) {
            Holder._f1Button = newValue
        }
    }
    
    var prevWeaponButton:UIButton {
        get {
            return Holder._prevWeaponButton
        }
        set(newValue) {
            Holder._prevWeaponButton = newValue
        }
    }

    var nextWeaponButton:UIButton {
        get {
            return Holder._nextWeaponButton
        }
        set(newValue) {
            Holder._nextWeaponButton = newValue
        }
    }

    @objc func fireButton(rect: CGRect) -> UIButton {
        fireButton = UIButton(frame: CGRect(x: rect.width - 155, y: rect.height - 90, width: 75, height: 75))
        fireButton.setTitle("FIRE", for: .normal)
        fireButton.setBackgroundImage(UIImage(named: "JoyStickBase")!, for: .normal)
        fireButton.addTarget(self, action: #selector(self.firePressed), for: .touchDown)
        fireButton.addTarget(self, action: #selector(self.fireReleased), for: .touchUpInside)
        fireButton.alpha = 0.5
        return fireButton
    }
    
    @objc func jumpButton(rect: CGRect) -> UIButton {
        jumpButton = UIButton(frame: CGRect(x: rect.width - 90, y: rect.height - 135, width: 75, height: 75))
        jumpButton.setTitle("JUMP", for: .normal)
        jumpButton.setBackgroundImage(UIImage(named: "JoyStickBase")!, for: .normal)
        jumpButton.addTarget(self, action: #selector(self.jumpPressed), for: .touchDown)
        jumpButton.addTarget(self, action: #selector(self.jumpReleased), for: .touchUpInside)
        jumpButton.alpha = 0.5
        return jumpButton
    }
    
    @objc func joyStick(rect: CGRect) -> JoyStickView {
        let size = CGSize(width: 100.0, height: 100.0)
        let joystick1Frame = CGRect(origin: CGPoint(x: 50.0,
                                                    y: (rect.height - size.height - 50.0)),
                                    size: size)
        joystickView = JoyStickView(frame: joystick1Frame)
        joystickView.delegate = self
        
        joystickView.movable = false
        joystickView.alpha = 0.5
        joystickView.baseAlpha = 0.5 // let the background bleed thru the base
        joystickView.handleTintColor = UIColor.darkGray // Colorize the handle
        return joystickView
    }
    
    @objc func buttonStack(rect: CGRect) -> UIStackView {
        
        
        expandButton = UIButton(type: .custom)
        expandButton.setTitle(" > ", for: .normal)
        expandButton.addTarget(self, action: #selector(self.expand), for: .touchUpInside)
        expandButton.sizeToFit()
        expandButton.alpha = 0.5
        expandButton.frame.size.width = 50

        tildeButton = UIButton(type: .custom)
        tildeButton.setTitle(" ~ ", for: .normal)
        tildeButton.addTarget(self, action: #selector(self.tildePressed), for: .touchDown)
        tildeButton.addTarget(self, action: #selector(self.tildeReleased), for: .touchUpInside)
        tildeButton.alpha = 0
        tildeButton.isHidden = true

        escapeButton = UIButton(type: .custom)
        escapeButton.setTitle(" ESC ", for: .normal)
        escapeButton.addTarget(self, action: #selector(self.escapePressed), for: .touchDown)
        escapeButton.addTarget(self, action: #selector(self.escapeReleased), for: .touchUpInside)
        escapeButton.layer.borderColor = UIColor.white.cgColor
        escapeButton.layer.borderWidth = CGFloat(1)
        escapeButton.alpha = 0
        escapeButton.isHidden = true

        quickSaveButton = UIButton(type: .custom)
        quickSaveButton.setTitle(" QS ", for: .normal)
        quickSaveButton.addTarget(self, action: #selector(self.quickSavePressed), for: .touchDown)
        quickSaveButton.addTarget(self, action: #selector(self.quickSaveReleased), for: .touchUpInside)
        quickSaveButton.layer.borderColor = UIColor.white.cgColor
        quickSaveButton.layer.borderWidth = CGFloat(1)
        quickSaveButton.alpha = 0
        quickSaveButton.isHidden = true

        quickLoadButton = UIButton(type: .custom)
        quickLoadButton.setTitle(" QL ", for: .normal)
        quickLoadButton.addTarget(self, action: #selector(self.quickLoadPressed), for: .touchDown)
        quickLoadButton.addTarget(self, action: #selector(self.quickLoadReleased), for: .touchUpInside)
        quickLoadButton.layer.borderColor = UIColor.white.cgColor
        quickLoadButton.layer.borderWidth = CGFloat(1)
        quickLoadButton.alpha = 0
        quickLoadButton.isHidden = true

        
//        buttonStack = UIStackView(frame: CGRect(x: 20, y: 20, width: 30, height: 300))
        buttonStack = UIStackView(frame: .zero)
        buttonStack.frame.origin = CGPoint(x: 50, y: 50)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.spacing = 8.0
        buttonStack.alignment = .leading
        buttonStack.addArrangedSubview(expandButton)
//        buttonStack.addArrangedSubview(tildeButton)
        buttonStack.addArrangedSubview(escapeButton)
        buttonStack.addArrangedSubview(quickSaveButton)
        buttonStack.addArrangedSubview(quickLoadButton)

        return buttonStack
        
    }
    
    @objc func f1Button(rect: CGRect) -> UIButton {
        f1Button = UIButton(frame: CGRect(x: rect.width - 40, y: 10, width: 30, height: 30))
        f1Button.setTitle(" F1 ", for: .normal)
        f1Button.addTarget(self, action: #selector(self.f1Pressed), for: .touchDown)
        f1Button.addTarget(self, action: #selector(self.f1Released), for: .touchUpInside)
        f1Button.layer.borderColor = UIColor.white.cgColor
        f1Button.layer.borderWidth = CGFloat(1)
        f1Button.alpha = 0.5
        return f1Button
    }
    
    @objc func prevWeaponButton(rect: CGRect) -> UIButton {
        prevWeaponButton = UIButton(frame: CGRect(x: (rect.width / 3), y: rect.height/2, width: (rect.width / 3), height: rect.height/2))
        prevWeaponButton.addTarget(self, action: #selector(self.prevWeaponPressed), for: .touchDown)
        prevWeaponButton.addTarget(self, action: #selector(self.prevWeaponReleased), for: .touchUpInside)
        return prevWeaponButton
    }
    
    @objc func nextWeaponButton(rect: CGRect) -> UIButton {
        nextWeaponButton = UIButton(frame: CGRect(x: (rect.width / 3), y: 0, width: (rect.width / 3), height: rect.height/2))
        nextWeaponButton.addTarget(self, action: #selector(self.nextWeaponPressed), for: .touchDown)
        nextWeaponButton.addTarget(self, action: #selector(self.nextWeaponReleased), for: .touchUpInside)
        return nextWeaponButton
    }

    
    @objc func firePressed(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(137, qboolean(1), qboolean(1))
    }
    
    @objc func fireReleased(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(137, qboolean(0), qboolean(1))
    }
    
    @objc func jumpPressed(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(32, qboolean(1), qboolean(1))
    }
    
    @objc func jumpReleased(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(32, qboolean(0), qboolean(1))
    }
    
    @objc func tildePressed(sender: UIButton!) {
//        Key_Event(32, qboolean(1), qboolean(1))
    }
    
    @objc func tildeReleased(sender: UIButton!) {
//        Key_Event(32, qboolean(0), qboolean(1))
    }
    
    @objc func escapePressed(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(27, qboolean(1), qboolean(1))
    }
    
    @objc func escapeReleased(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(27, qboolean(0), qboolean(1))
    }
    
    @objc func quickSavePressed(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(150, qboolean(1), qboolean(1))
    }
    
    @objc func quickSaveReleased(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(150, qboolean(0), qboolean(1))
    }
    
    @objc func quickLoadPressed(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(153, qboolean(1), qboolean(1))
    }
    
    @objc func quickLoadReleased(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(153, qboolean(0), qboolean(1))
    }
    
    @objc func f1Pressed(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(145, qboolean(1), qboolean(1))
    }
    
    @objc func f1Released(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(145, qboolean(0), qboolean(1))
    }
    
    @objc func prevWeaponPressed(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(183, qboolean(1), qboolean(1))
    }
    
    @objc func prevWeaponReleased(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(183, qboolean(0), qboolean(1))
    }
    
    @objc func nextWeaponPressed(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(184, qboolean(1), qboolean(1))
    }
    
    @objc func nextWeaponReleased(sender: UIButton!) {
        // todo: fix for DOOM3 -tkidd
        //Key_Event(184, qboolean(0), qboolean(1))
    }


    @objc func expand(_ sender: Any) {
        buttonStackExpanded = !buttonStackExpanded
        
        UIView.animate(withDuration: 0.5) {
            self.expandButton.setTitle(self.buttonStackExpanded ? " < " : " > ", for: .normal)
            self.expandButton.alpha = self.buttonStackExpanded ? 1 : 0.5
            self.escapeButton.isHidden = !self.buttonStackExpanded
            self.escapeButton.alpha = self.buttonStackExpanded ? 1 : 0
            self.tildeButton.isHidden = !self.buttonStackExpanded
            self.tildeButton.alpha = self.buttonStackExpanded ? 1 : 0
            self.quickLoadButton.isHidden = !self.buttonStackExpanded
            self.quickLoadButton.alpha = self.buttonStackExpanded ? 1 : 0
            self.quickSaveButton.isHidden = !self.buttonStackExpanded
            self.quickSaveButton.alpha = self.buttonStackExpanded ? 1 : 0
        }
        
    }
    
}

extension SDL_uikitviewcontroller: JoystickDelegate {
    
    func handleJoyStickPosition(x: CGFloat, y: CGFloat) {
        // todo: fix for DOOM3 -tkidd
//        if y > 0 {
//            cl_joyscale_y.0 = Int32(abs(y) * 60)
//            Key_Event(132, qboolean(1), qboolean(1))
//            Key_Event(133, qboolean(0), qboolean(1))
//        } else if y < 0 {
//            cl_joyscale_y.1 = Int32(abs(y) * 60)
//            Key_Event(132, qboolean(0), qboolean(1))
//            Key_Event(133, qboolean(1), qboolean(1))
//        } else {
//            cl_joyscale_y.0 = 0
//            cl_joyscale_y.1 = 0
//            Key_Event(132, qboolean(0), qboolean(1))
//            Key_Event(133, qboolean(0), qboolean(1))
//        }
//
//        cl_joyscale_x.0 = Int32(x * 20)
    }
    
    func handleJoyStick(angle: CGFloat, displacement: CGFloat) {
//        print("angle: \(angle) displacement: \(displacement)")
    }
    
}

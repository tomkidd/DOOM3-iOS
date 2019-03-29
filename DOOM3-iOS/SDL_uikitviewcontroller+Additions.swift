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
        static var _pdaButton = UIButton()
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
    
    var pdaButton:UIButton {
        get {
            return Holder._pdaButton
        }
        set(newValue) {
            Holder._pdaButton = newValue
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
    
    func Key_Event(key: Int, pressed: Bool) {
        var event = SDL_Event()
        event.type = SDL_KEYDOWN.rawValue
        event.key.keysym.sym = SDL_Keycode(key)
        event.key.state = Uint8(pressed ? SDL_PRESSED : SDL_RELEASED)
        SDL_PushEvent(&event)
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
    
    @objc func pdaButton(rect: CGRect) -> UIButton {
        pdaButton = UIButton(frame: CGRect(x: 10, y: rect.height - 40, width: 30, height: 30))
        pdaButton.setTitle(" PDA ", for: .normal)
        pdaButton.addTarget(self, action: #selector(self.pdaPressed), for: .touchDown)
        pdaButton.addTarget(self, action: #selector(self.pdaReleased), for: .touchUpInside)
        pdaButton.layer.borderColor = UIColor.white.cgColor
        pdaButton.layer.borderWidth = CGFloat(1)
        pdaButton.alpha = 0.5
        return pdaButton
    }
    
    @objc func prevWeaponButton(rect: CGRect) -> UIButton {
        prevWeaponButton = UIButton(frame: CGRect(x: (rect.width / 3), y: rect.height/2, width: (rect.width / 3), height: rect.height/2))
        prevWeaponButton.addTarget(self, action: #selector(self.prevWeaponPressed), for: .touchDown)
        prevWeaponButton.addTarget(self, action: #selector(self.prevWeaponReleased), for: .touchUpInside)
        return prevWeaponButton
    }
    
    @objc func nextWeaponButton(rect: CGRect) -> UIButton {
        nextWeaponButton = UIButton(frame: CGRect(x: (rect.width / 3), y: rect.height - rect.height/4, width: (rect.width / 3), height: rect.height/4))
        nextWeaponButton.addTarget(self, action: #selector(self.nextWeaponPressed), for: .touchDown)
        nextWeaponButton.addTarget(self, action: #selector(self.nextWeaponReleased), for: .touchUpInside)
//        nextWeaponButton.layer.borderColor = UIColor.white.cgColor
//        nextWeaponButton.layer.borderWidth = CGFloat(1)
        return nextWeaponButton
    }
    
    @objc func firePressed(sender: UIButton!) {
        Key_Event(key: SDLK_RCTRL, pressed: true)
    }
    
    @objc func fireReleased(sender: UIButton!) {
        Key_Event(key: SDLK_RCTRL, pressed: false)
    }
    
    @objc func jumpPressed(sender: UIButton!) {
        Key_Event(key: SDLK_SPACE, pressed: true)
    }
    
    @objc func jumpReleased(sender: UIButton!) {
        Key_Event(key: SDLK_SPACE, pressed: false)
    }
    
    @objc func tildePressed(sender: UIButton!) {
//        Key_Event(32, qboolean(1), qboolean(1))
    }
    
    @objc func tildeReleased(sender: UIButton!) {
//        Key_Event(32, qboolean(0), qboolean(1))
    }
    
    @objc func escapePressed(sender: UIButton!) {
        Key_Event(key: SDLK_ESCAPE, pressed: true)
    }
    
    @objc func escapeReleased(sender: UIButton!) {
        Key_Event(key: SDLK_ESCAPE, pressed: false)
    }
    
    @objc func quickSavePressed(sender: UIButton!) {
        Key_Event(key: SDLK_F5, pressed: true)
    }
    
    @objc func quickSaveReleased(sender: UIButton!) {
        Key_Event(key: SDLK_F5, pressed: false)
    }
    
    @objc func quickLoadPressed(sender: UIButton!) {
        Key_Event(key: SDLK_F9, pressed: true)
    }
    
    @objc func quickLoadReleased(sender: UIButton!) {
        Key_Event(key: SDLK_F9, pressed: false)
    }
    
    // repurposing for flashlight
    @objc func f1Pressed(sender: UIButton!) {
        Key_Event(key: SDLK_f, pressed: true)
    }
    
    @objc func f1Released(sender: UIButton!) {
        Key_Event(key: SDLK_f, pressed: false)
    }
    
    @objc func pdaPressed(sender: UIButton!) {
        Key_Event(key: SDLK_TAB, pressed: true)
    }
    
    @objc func pdaReleased(sender: UIButton!) {
        Key_Event(key: SDLK_TAB, pressed: false)
    }
    
    @objc func prevWeaponPressed(sender: UIButton!) {
        Key_Event(key: SDLK_LEFTBRACKET, pressed: true)
    }
    
    @objc func prevWeaponReleased(sender: UIButton!) {
        Key_Event(key: SDLK_LEFTBRACKET, pressed: true)
    }
    
    @objc func nextWeaponPressed(sender: UIButton!) {
//        Key_Event(key: SDLK_RIGHTBRACKET, pressed: true)
        var wevent = SDL_Event()
        wevent.type = SDL_MOUSEWHEEL.rawValue
        wevent.wheel.y = 1
        
        SDL_PushEvent(&wevent)

    }
    
    @objc func nextWeaponReleased(sender: UIButton!) {
//        Key_Event(key: K_MWHEELUP, pressed: false)
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
        
        var eventY = SDL_Event()
        eventY.type = SDL_CONTROLLERAXISMOTION.rawValue
        eventY.caxis.axis = Uint8(SDL_CONTROLLER_AXIS_LEFTY.rawValue)
        eventY.caxis.value =  -Sint16(y * 10)
        
        SDL_PushEvent(&eventY)
        
        var eventX = SDL_Event()
        eventX.type = SDL_CONTROLLERAXISMOTION.rawValue
        eventX.caxis.axis = Uint8(SDL_CONTROLLER_AXIS_RIGHTX.rawValue)
        eventX.caxis.value = Sint16(x * 10)
        
        SDL_PushEvent(&eventX)
    }
    
    func handleJoyStick(angle: CGFloat, displacement: CGFloat) {
//        print("angle: \(angle) displacement: \(displacement)")
    }
    
}

//
//  ControllerInputSystem.swift
//  DOOM3-iOS
//
//  Created by Joan Westenberg on 8/11/24.
//


import GameController

class ControllerInputSystem {
    static let shared = ControllerInputSystem()
    
    var connectedController: GCController?
    weak var delegate: JoystickDelegate?
    
    private init() {
        setupControllerConnectivityHandler()
    }
    
    func setupControllerConnectivityHandler() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controllerConnected),
                                               name: .GCControllerDidConnect,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controllerDisconnected),
                                               name: .GCControllerDidDisconnect,
                                               object: nil)
    }
    
    @objc func controllerConnected(_ notification: Notification) {
        guard let controller = notification.object as? GCController else { return }
        print("Controller connected: \(controller.productCategory)")
        connectedController = controller
        setupControllerInputHandling(controller)
    }
    
    @objc func controllerDisconnected(_ notification: Notification) {
        guard let controller = notification.object as? GCController else { return }
        print("Controller disconnected: \(controller.productCategory)")
        if controller == connectedController {
            connectedController = nil
        }
    }
    
    func setupControllerInputHandling(_ controller: GCController) {
        guard let gamepad = controller.extendedGamepad else { return }
        
        gamepad.leftThumbstick.valueChangedHandler = { [weak self] (_, xValue, yValue) in
            let angle = atan2(xValue, -yValue) * (180 / .pi)
            let displacement = sqrt(xValue * xValue + yValue * yValue)
            self?.delegate?.handleJoyStick(angle: CGFloat(angle), displacement: CGFloat(displacement))
            self?.delegate?.handleJoyStickPosition(x: CGFloat(xValue), y: CGFloat(yValue))
        }
    }
}
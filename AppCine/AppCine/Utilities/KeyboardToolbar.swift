//
//  KeyboardToolbar.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 31/3/22.
//

import UIKit

protocol KeyboardToolbarDelegate: AnyObject {
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, isInputAccessoryViewOf textField: UITextField)
}

class KeyboardToolbar: UIToolbar {
    private weak var toolBarDelegate: KeyboardToolbarDelegate?
    private weak var textField: UITextField!
    
    init(for textField: UITextField, toolBarDelegate: KeyboardToolbarDelegate) {
        super.init(frame: .init(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 44)))
        barStyle = .default
        isTranslucent = true
        self.textField = textField
        self.toolBarDelegate = toolBarDelegate
        textField.inputAccessoryView = self
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}
    
    func setup(leftButtons: [KeyboardToolbarButton], rightButtons: [KeyboardToolbarButton]) {
        let leftBarButtons = leftButtons.map {
            $0.createButton(target: self, action: #selector(buttonTapped))
        }
        
        let rightBarButtons = rightButtons.map {
            $0.createButton(target: self, action: #selector(buttonTapped(sender:)))
        }
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setItems(leftBarButtons + [spaceButton] + rightBarButtons, animated: false)
    
    }
    
    @objc func buttonTapped(sender: UIBarButtonItem) {
        guard let type = KeyboardToolbarButton.detectType(barButton: sender) else { return }
        toolBarDelegate?.keyboardToolbar(button: sender, type: type, isInputAccessoryViewOf: textField)
    }
}


enum KeyboardToolbarButton: Int {
    case done = 0, send
    
    func createButton(target: Any?, action: Selector?) -> UIBarButtonItem {
        var button: UIBarButtonItem!
        switch self {
        case .done: button = .init(title: ACLabel.done, style: .done,  target: target, action: action)
        case .send: button = .init(title: ACLabel.send, style: .plain, target: target, action: action)
        }
        
        button.tag = rawValue
        return button
    }
    
    static func detectType(barButton: UIBarButtonItem) -> KeyboardToolbarButton? {
        return KeyboardToolbarButton(rawValue: barButton.tag)
    }
}


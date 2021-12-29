//
//  ViewController.swift
//  Mystery Journal
//
//  Created by Chema Martinez on 29/12/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tvSecret: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector:
        #selector(adjustForKeyboard), name:
        UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector:
        #selector(adjustForKeyboard), name:
                                        UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        
       guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
       let keyboardScreenEndFrame = keyboardValue.cgRectValue
       let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            tvSecret.contentInset = .zero
        } else {
            tvSecret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        tvSecret.scrollIndicatorInsets = tvSecret.contentInset
        let selectedRange = tvSecret.selectedRange
        tvSecret.scrollRangeToVisible(selectedRange)
        
    }


}


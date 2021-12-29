//
//  ViewController.swift
//  Mystery Journal
//
//  Created by Chema Martinez on 29/12/21.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var tvSecret: UITextView!
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        context.localizedFallbackTitle = ""
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock secret message") { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success == true {
                            self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
        
    }
    
    // MARK: - Secret
    
    private func unlockSecretMessage() {
        tvSecret.isHidden = false
        title = "Secret stuff!"
        
        tvSecret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc private func saveSecretMessage() {
        guard tvSecret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(tvSecret.text ?? "", forKey: "SecretMessage")
        tvSecret.resignFirstResponder()
        tvSecret.isHidden = true
        title = "Nothing to see here"
        
    }
    
    // MARK: - Keyboard
    
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


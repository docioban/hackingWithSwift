//
//  ViewController.swift
//  Project28
//
//  Created by Macbook Pro on 11/26/20.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var secret: UITextView!
    
    @IBOutlet weak var authenticationWithPassword: UIButton!
    
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)

        password = KeychainWrapper.standard.string(forKey: "Password") ?? nil
        authenticationWithPassword.isHidden =  password != nil ? false : true
    }
    
    @IBAction func authenticationWithPasswordTapped(_ sender: Any) {
        guard authenticationWithPassword.isHidden == false else {
            return
        }
        
        let ac = UIAlertController(title: "Password", message: "write you password", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Ok", style: .default) {[weak self, weak ac] _ in
            guard let pas = ac?.textFields?[0].text else { return }
            if pas == KeychainWrapper.standard.string(forKey: "Password") {
                self?.unlockSecretMessage()
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Error", message: "You could not be verified; try again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "ok", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }

    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"

        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(lockApp))
        
        if KeychainWrapper.standard.string(forKey: "Password") == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Create Password", style: .plain, target: self, action: #selector(createPassword))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Chenge Password", style: .plain, target: self, action: #selector(changePassword))
        }
    }
    
    @objc func changePassword() {
        let ac = UIAlertController(title: "Change Password", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Old password"
        }
        ac.addTextField { (textField) in
            textField.placeholder = "NewPassword"
        }
        ac.addAction(UIAlertAction(title: "Save", style: .default){ [weak self, weak ac] _ in
            guard let old = ac?.textFields?[0].text else { return }
            guard let new = ac?.textFields?[1].text else { return }
            if old == KeychainWrapper.standard.string(forKey: "Password") {
                KeychainWrapper.standard.set(new, forKey: "Password")
            } else {
                let ac2 = UIAlertController(title: "Wrong", message: "This in not old Password", preferredStyle: .alert)
                ac2.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac2, animated: true)
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func lockApp() {
        secret.isHidden = true
        title = "Nothing to see here"
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
    }
    
    @objc func createPassword() {
        let ac = UIAlertController(title: "Create pasword", message: "create a new password", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "save", style: .default) { [weak ac] _ in
            guard let pas = ac?.textFields?[0].text else { return }
            KeychainWrapper.standard.set(pas, forKey: "Password")
        })
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else {
            return
        }
    
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see"
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
    }
    
    

}


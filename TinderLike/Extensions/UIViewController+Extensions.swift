//
//  UIViewController+Extensions.swift
//  TinderLike
//
//  Created by HuyLH3 on 9/12/20.
//  Copyright © 2020 HuyLH3. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, alertActions: [UIAlertAction] = [], cancelAction: ((UIAlertAction) -> ())? = nil) {
        if presentedViewController is UIAlertController {
            dismiss(animated: false)
        }
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelAction)
        alertController.addAction(OKAction)
        for alertAction in alertActions {
            alertController.addAction(alertAction)
        }
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func show(error: Error, alertActions: [UIAlertAction] = [], cancelAction: ((UIAlertAction) -> ())? = nil) {
        showAlert(title: nil, message: (error as? APIError)?.localizedDescription ?? "Got Error", alertActions: alertActions, cancelAction: cancelAction)
    }
}

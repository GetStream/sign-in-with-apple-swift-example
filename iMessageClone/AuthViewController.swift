//
//  AuthViewController.swift
//  iMessageClone
//
//  Created by Matheus Cardoso on 4/16/20.
//  Copyright © 2020 Stream.io. All rights reserved.
//

import UIKit
import AuthenticationServices

class AuthViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSignInButton()
    }
    
    func setupSignInButton() {
        let button = ASAuthorizationAppleIDButton()
        button.center = view.center
        view.addSubview(button)
        button.addTarget(self, action: #selector(handleSignInPress), for: .touchUpInside)
    }
    
    @objc func handleSignInPress() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

import StreamChatClient

extension AuthViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        let cred = authorization.credential as! ASAuthorizationAppleIDCredential
        let code = String(data: cred.authorizationCode!, encoding: .utf8)!
        
        var name: String? = nil
        if let fullName = cred.fullName {
            name = PersonNameComponentsFormatter().string(from: fullName)
        }
        
        let request = AuthRequest(appleUid: cred.user, appleAuthCode: code, name: name)

        authenticate(request: request) { [weak self] res, error in 
            DispatchQueue.main.async {
                guard let res = res else {
                    let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                    return
                }
                
                Client.config = .init(apiKey: res.apiKey, logOptions: .info)
                let extraData = UserExtraData(name: res.name)
                let user = User(id: res.streamId, extraData: extraData)
                Client.shared.set(user: user, token: res.streamToken)
            
                self?.performSegue(withIdentifier: "kAuthToContactsSegueId", sender: nil)
            }
        }
    }
}

extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

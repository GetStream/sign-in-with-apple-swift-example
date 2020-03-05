//
//  AppDelegate.swift
//  iMessageClone
//
//  Created by Bahadir Oncel on 28.01.2020.
//  Copyright © 2020 Stream.io. All rights reserved.
//

import UIKit
import StreamChatClient

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Client.config = .init(apiKey: "b67pax5b2wdq", logOptions: .info)
        Client.shared.set(user: User(id: "polished-poetry-5",
                                     name: "Polished poetry"),
                          token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoicG9saXNoZWQtcG9ldHJ5LTUifQ.o8SWzSlb68EntudwjVul1rUCYGpla-CimXNKxj3wKOc")
        return true
    }
}


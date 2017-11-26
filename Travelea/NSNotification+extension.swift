//
//  NSNotification+extension.swift
//  Travelea
//
//  Created by Momentum Lab 1 on 11/25/17.
//  Copyright © 2017 MomentumLab. All rights reserved.
//

import Foundation

extension NSNotification.Name{
    ///Key for notification for bagde update
    static let onDidNewNotification = Notification.Name("didNewNotification")
    static let onDidRedirectNewNotification = Notification.Name("didRedirectNewNotification")
}

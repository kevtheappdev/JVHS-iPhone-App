//
//  JVRequestDelegate.swift
//  GradeChecker
//
//  Created by Kevin Turner on 3/2/16.
//  Copyright © 2016 Kevin Turner. All rights reserved.
//

import Foundation

public protocol JVRequestDelegate {
    func requestCompleted(_ data: Data, type: JVRequester.JVRequestType)
    func requestFailed()
}

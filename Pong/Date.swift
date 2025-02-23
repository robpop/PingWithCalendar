//
//  Date.swift
//  Pong
//
//  Created by Jared Macias on 10/4/19.
//  Copyright © 2019 Jared Macias. All rights reserved.
//

import Cocoa

extension Date {
    private func returnTime() -> (hour: Int, minute: Int, second: Int){
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        let second = calendar.component(.second, from: self)
        
        return (
            hour: hour,
            minute: minute,
            second: second
        )
    }
}

//
//  String+Subscript.swift
//  Mars Rover
//
//  Created by Wael Saad - r00tdvd on 6/19/19.
//  Copyright © 2019 NetTrinity. All rights reserved.
//

public extension String {
    subscript(_ i: Int) -> String {
        let idx1 = index(startIndex, offsetBy: i)
        let idx2 = index(idx1, offsetBy: 1)
        return String(self[idx1..<idx2])
    }
}


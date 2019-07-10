//
//  Mars_RoverTests.swift
//  Mars RoverTests
//
//  Created by Wael Saad - r00tdvd on 6/19/19.
//  Copyright © 2019 NetTrinity. All rights reserved.
//

import XCTest
@testable import Mars_Rover

class Mars_RoverTests: XCTestCase {

    override func setUp() {

    }
    
    func testRoverOrientation() {
        let rover: Rover = Rover()
        rover.setPosition(x: 1, y: 2, orientation: Direction.North)
        assert(rover.orientation == Direction.North)
    }
    
    func testRoverPosition1() {
        let rover: Rover = Rover()
        rover.setPosition(x: 1, y: 2, orientation: Direction.North)
        rover.process(commands: "LMLMLMLMM")
        
        assert(rover.x == 1)
        assert(rover.y == 3)
        assert(rover.position == "N")
    }
    
    
    func testRoverPosition2() {
        let rover: Rover = Rover()
        rover.setPosition(x: 3, y: 3, orientation: Direction.East)
        rover.process(commands: "MMRMMRMRRM")
        
        assert(rover.x == 5)
        assert(rover.y == 1)
        assert(rover.position == "E")
    }
    
    func test(test: () -> ()) {
        test()
    }
    
    override func tearDown() {
    }
}

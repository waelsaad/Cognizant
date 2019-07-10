//
//  Rover.swift
//  Mars Rover
//
//  Created by Wael Saad - r00tdvd on 6/19/19.
//  Copyright © 2019 NetTrinity. All rights reserved.
//

import Foundation

protocol RoverType {
    
    // MARK: - Properties
    var x: Int { get set }
    var y: Int { get set }
    var position: String { get }

    // MARK: - Functions
    
    func setPosition(x: Int, y: Int, orientation: Direction)
    
    func turnLeft()
    func turnRight()
    func move ()
    func process(commands: String)
}

public class Rover: RoverType {
    
    var x: Int = 0
    var y: Int = 0
    
    var orientation: Direction = Direction.North
    
    var position: String {
        var direction: String = "N"
        if (orientation == Direction.North) {
            direction = "N"
        } else if (orientation == Direction.East) {
            direction = "E"
        } else if (orientation == Direction.South) {
            direction = "S"
        } else if (orientation == Direction.West) {
            direction = "W"
        }
        
        return direction
    }
    
    func setPosition(x: Int, y: Int, orientation: Direction) {
        self.x = x
        self.y = y
        self.orientation = orientation
    }
    
    func process(commands: String) {
        for command in commands {
            switch (command) {
            case ("L"):
                turnLeft()
            case ("R"):
                turnRight()
            case ("M"):
                move()
            default:
                break
            }
        }
    }
    
    func move () {
        if orientation == Direction.North {
            self.y += 1
        } else if orientation == Direction.East {
            self.x += 1
        } else if orientation == Direction.South {
            self.y -= 1
        } else if orientation == Direction.West {
            self.x -= 1
        }
    }
    
    func turnLeft() {
        orientation = (orientation.rawValue - 1) < Direction.North.rawValue ? Direction.West : Direction.left(orientation)()
    }
    
    func turnRight() {
        orientation = (orientation.rawValue + 1) > Direction.West.rawValue ? Direction.North : Direction.right(orientation)()
    }
    
    func getOrientation (direction: String) -> Direction {
        
        //print(Direction.allCases.map { $0.rawValue })
        
        let orientation: Direction = Direction.North
        
        switch direction {
        case "N":
            return Direction.North
        case "E":
            return Direction.East
        case "S":
            return Direction.South
        case "W":
            return Direction.West
        default:
            break
        }
        
        return orientation
    }
}


enum Constants {
    static var mximumNumberOfPositionCharacters: Int = 3
    
    static var orientations = ["N", "E", "S", "W"]
    
    // I didn't have enough time to implement a regex but a level of strict validation has been implemented in the viewController
    static let positionRegex: String = "(?:(?:n)(?:[ ](?:e))?|w(?:s))"
}

enum Instructions: String {
    case M, L, R
}

enum Direction: Int, CaseIterable {
    case North = 1, East, South, West
    
    func left() -> Direction {
        if let nextDirection = Direction(rawValue: (self.rawValue - 1)) {
            return nextDirection
        } else {
            return Direction.West
        }
    }
    
    func right() -> Direction {
        if let nextDirection = Direction(rawValue: (self.rawValue + 1)) {
            return nextDirection
        } else {
            return Direction.North
        }
    }
}

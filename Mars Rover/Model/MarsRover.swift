//
//  Rover.swift
//  Mars Rover
//
//  Created by r00tdvd on 6/20/19.
//  Copyright © 2019 NetTrinity. All rights reserved.
//

import Foundation

class MarsRover {
    
    var landingPlace: Position
    
    init(startingPoint: (Int, Int)) {
        let (x, y) = startingPoint
        landingPlace = Position(x: x, y: y)
    }
    
    func land(planet: Planet) -> LandedMarsRover {
        let targetPosition = planet.locate(position: landingPlace)
        return LandedMarsRover(planet: planet, position: targetPosition)
    }
}

class LandedMarsRover {
    
    var position: Position
    var direction: Direction = .North
    let planet: Planet
    
    init(planet: Planet, position: Position) {
        self.planet = planet
        self.position = position
    }
    
    func move(commands: String) {
        for command in commands {
            switch command {
            case "f":
                self.position = planet.locate(position: position + direction.relativePosition())
            case "b":
                self.position = planet.locate(position: position - direction.relativePosition())
            case "l":
                self.direction = self.direction.turnLeft()
            case "r":
                self.direction = self.direction.turnRight()
            default: return
            }
        }
    }
}



enum Direction: Int {
    
    case North, East, South, West
    
    func relativePosition() -> Position {
        switch self {
        case .North: return Position(x: 0, y: 1)
        case .South: return Position(x: 0, y: -1)
        case .West: return Position(x: -1, y: 0)
        case .East: return Position(x: 1, y: 0)
        }
    }
    
    func turnRight() -> Direction {
        if let nextDirection = Direction(rawValue: ((self.rawValue + 1) % 4)) {
            return nextDirection
        } else {
            return Direction.North
        }
    }
    
    func turnLeft() -> Direction {
        if let nextDirection = Direction(rawValue: (self.rawValue - 1)) {
            return nextDirection
        } else {
            return Direction.West
        }
    }
}

class Position : Equatable {
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

func +(originalPosition: Position, relativePosition: Position) -> Position {
    return Position(
        x: originalPosition.x + relativePosition.x,
        y: originalPosition.y + relativePosition.y)
}

prefix func -(position: Position) -> Position {
    return Position(
        x: -position.x,
        y: -position.y)
}

func -(originalPosition: Position, relativePosition: Position) -> Position {
    return originalPosition + (-relativePosition)
}

func ==(left: Position, right: Position) -> Bool {
    return left.x == right.x && left.y == right.y
}

struct Planet: Equatable {
    let name: String
    let sizeX: Int
    let sizeY: Int
    
    func locate(position: Position) -> Position {
        let x = position.x % sizeX
        let y = position.y % sizeY
        
        func wrap(coord: Int, max: Int) -> Int {
            let remainder = coord % max
            if (remainder >= 0) {
                return remainder
            } else {
                return max + remainder
            }
        }
        
        return Position(
            x: wrap(coord: position.x, max: sizeX),
            y: wrap(coord: position.y, max: sizeY))
    }
}

func ==(left: Planet, right: Planet) -> Bool {
    return left.name == right.name && left.sizeX == right.sizeX && left.sizeY == right.sizeY
}

//Tests
let mars = Planet(name: "Mars", sizeX: 100, sizeY: 100)

func test(test: () -> ()) {
    test()
}

func marsRoverTests() {
    //create a mars rover
    test(test: {
        () -> () in
        let rover = MarsRover(startingPoint: (0, 0))
        assert(rover.landingPlace == Position(x: 0, y: 0))
    })
    
    //land it on mars
    test(test: {
        () -> () in
        let rover = MarsRover(startingPoint: (0, 0))
        let landedRover = rover.land(planet: mars)
        assert(landedRover.planet == mars)
        assert(landedRover.direction == .North)
    })
}

func landedMarsRoverTests() {
    func landedMarsRover() -> LandedMarsRover {
        let rover = MarsRover(startingPoint: (0, 0))
        return rover.land(planet: mars)
    }
    
    // drive forward
    test(test: {
        () -> () in
        let landedRover = landedMarsRover()
        landedRover.move(commands: "f")
        assert(landedRover.position == Position(x: 0, y: 1))
    })
    
    // drive backward
    test(test: {
        () -> () in
        let landedRover = landedMarsRover()
        landedRover.move(commands: "b")
        assert(landedRover.position == Position(x: 0, y: 99))
    })
    
    // turn left
    test(test: {
        () -> () in
        let landedRover = landedMarsRover()
        landedRover.move(commands: "l")
        assert(landedRover.direction == .West)
    })
    
    //turn right
    test(test: {
        () -> () in
        let landedRover = landedMarsRover()
        landedRover.move(commands: "r")
        assert(landedRover.direction == .East)
    })
    
    // drive around to Position (2, 1) facing North
    test(test: {
        () -> () in
        let landedRover = landedMarsRover()
        landedRover.move(commands: "ffrff")
        assert(landedRover.position == Position(x: 2, y: 2))
        assert(landedRover.direction == .East)
        
        landedRover.move(commands: "lb")
        assert(landedRover.position == Position(x: 2, y: 1))
        assert(landedRover.direction == .North)
    })
}

func planetTests() {
    
    //test location wrapping on planet
    test(test: {
        () -> () in
        let positionOnMars = mars.locate(position: Position(x: mars.sizeX, y: mars.sizeY))
        assert(positionOnMars == Position(x: 0, y: 0))
    })
    
    test(test: {
        () -> () in
        let positionOnMars = mars.locate(position: Position(x: -1, y: -1))
        assert(positionOnMars == Position(x: mars.sizeX-1, y: mars.sizeY-1))
    })
}

func directionTests() {
    //test relativePosition from Direction
    test(test: {
        () -> () in
        assert(Direction.North.relativePosition() == Position(x: 0, y: 1))
        assert(Direction.South.relativePosition() == Position(x: 0, y: -1))
        assert(Direction.West.relativePosition() == Position(x: -1, y: 0))
        assert(Direction.East.relativePosition() == Position(x: 1, y: 0))
    })
    
    //test turning from a Direction
    test(test: {
        () -> () in
        assert(Direction.North.turnLeft() == .West)
        assert(Direction.West.turnLeft() == .South)
        assert(Direction.South.turnLeft() == .East)
        assert(Direction.East.turnLeft() == .North)
        
        assert(Direction.North.turnRight() == .East)
        assert(Direction.East.turnRight() == .South)
        assert(Direction.South.turnRight() == .West)
        assert(Direction.West.turnRight() == .North)
    })
}

func positionTests() {
    
    // test equality
    test(test: {
        () -> () in
        let originalPosition = Position(x: 10, y: 100)
        let equalPosition = Position(x: 10, y: 100)
        let differentPosition = Position(x: 0, y: 0)
        
        assert(originalPosition == equalPosition)
        assert(originalPosition != differentPosition)
    })
    
    // test position adding
    test(test: {
        () -> () in
        let originalPosition = Position(x: 10, y: 20)
        let relativePosition = Position(x: -5, y: 5)
        
        let resultingPosition = Position(x: 5, y: 25)
        
        assert((originalPosition + relativePosition) == resultingPosition)
    })
}

//marsRoverTests()
//landedMarsRoverTests()
//planetTests()
//positionTests()
//directionTests()
//println("All tests passed")

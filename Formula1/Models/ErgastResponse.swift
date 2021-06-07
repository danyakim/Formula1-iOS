//
//  ErgastResponse.swift
//  Formula1
//
//  Created by Daniil Kim on 01.06.2021.
//

import Foundation

// MARK: - Typealias

typealias DriverResult = (driver: Driver, time: String)
typealias Position = (driver: Driver, race: Race)

// MARK: - Response
struct ErgastResponse: Codable {
    
    let mrData: MRData
    
    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
    
    func getPositions() -> [Position] {
        var result = [Position]()
        
        let races = mrData.raceTable.races
        for race in races {
            if let driver = race.results.first?.driver {
                result.append((driver: driver, race: race))
            } else {
                print("error")
            }
        }
        
        return result
    }
    
    func getDriversResults() -> ([DriverResult])? {
        guard let race = mrData.raceTable.races.first else { return nil }
        
        var driversResults = [DriverResult]()
        for result in race.results {
            let driver = result.driver
            
            if let time = result.time?.time {
                driversResults.append((driver, time))
            } else {
                var status = result.status
                if !status.contains("Lap"),
                   !status.contains("Accident"),
                   !status.contains("Injured"),
                   !status.contains("Retired"),
                   !status.contains("Collision") {
                    status.append(" issue")
                }
                driversResults.append((driver, status))
            }
        }
        return driversResults
    }
    
}

// MARK: - MRData
struct MRData: Codable {
    
    let series: String
    let url: String
    let raceTable: RaceTable
    
    enum CodingKeys: String, CodingKey {
        case series, url
        case raceTable = "RaceTable"
    }
    
}

// MARK: - RaceTable
struct RaceTable: Codable {
    
    let season: String
    let races: [Race]
    
    enum CodingKeys: String, CodingKey {
        case season
        case races = "Races"
    }
    
}

// MARK: - Race
struct Race: Codable {
    
    let season, round: String
    let url: String
    let raceName: String
    let circuit: Circuit
    let date: String
    let results: [RaceResult]
    
    enum CodingKeys: String, CodingKey {
        case season, round, url, raceName
        case circuit = "Circuit"
        case date
        case results = "Results"
    }
    
}

// MARK: - Circuit
struct Circuit: Codable {
    
    let circuitID: String
    let url: String
    let circuitName: String
    
    enum CodingKeys: String, CodingKey {
        case circuitID = "circuitId"
        case url, circuitName
    }
    
}

// MARK: - RaceResult
struct RaceResult: Codable {
    
    let number, position, positionText: String
    let driver: Driver
    let grid, laps: String
    let status: String
    let time: ResultTime?
    
    enum CodingKeys: String, CodingKey {
        case number, position, positionText
        case driver = "Driver"
        case grid, laps, status
        case time = "Time"
    }
    
}

// MARK: - Driver
struct Driver: Codable {
    
    let driverID: String
    let permanentNumber: String?
    let url: String
    let givenName, familyName, dateOfBirth, nationality: String
    
    enum CodingKeys: String, CodingKey {
        case driverID = "driverId"
        case permanentNumber, url, givenName, familyName, dateOfBirth, nationality
    }
    
}

// MARK: - ResultTime
struct ResultTime: Codable {
    let time: String
}

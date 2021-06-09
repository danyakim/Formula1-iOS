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
                let status = complete(result.status)
                driversResults.append((driver, status))
            }
        }
        return driversResults
    }
    
    func complete(_ status: String) -> String {
        let statusCompleted = [
            "Lap",
            "Finished",
            "Disqualified",
            "Accident",
            "Spun off",
            "Retired",
            "Withdrew",
            "fire",
            "Out of fuel",
            "Injured",
            "Power loss",
            "107% Rule",
            "Did not qualify",
            "Stalled",
            "Safety concerns",
            "Not restarted",
            "Underweight",
            "Excluded",
            "Did not prequalify",
            "Driver unwell",
            "Fatal accident",
            "injury",
            "damage",
            "misfire",
            "Illness",
            "Collision"
        ]
        if !statusCompleted.filter({ status.contains($0) }).isEmpty {
            return status
        }
        return status + " issue"
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
    
    let circuitId: String
    let url: String
    let circuitName: String
    
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
    
    let driverId: String
    let permanentNumber: String?
    let url: String
    let givenName, familyName, dateOfBirth, nationality: String
    
}

// MARK: - ResultTime
struct ResultTime: Codable {
    let time: String
}

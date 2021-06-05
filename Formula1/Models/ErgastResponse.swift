//
//  ErgastResponse.swift
//  Formula1
//
//  Created by Daniil Kim on 01.06.2021.
//

import Foundation

// MARK: - Response
struct ErgastResponse: Codable {
    let mrData: MRData

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
    
    func getDetails() -> [(driver: Driver, race: Race)] {
        var result = [(driver: Driver, race: Race)]()
        
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
    
    func getRaceDetails() -> (drivers: [Driver], times: [String])? {
        if let race = mrData.raceTable.races.first {
            let drivers = race.getAllDrivers()
            let times = race.getTimes()
            return (drivers, times)
        }
        return nil
    }
}

// MARK: - MRData
struct MRData: Codable {
    let xmlns: String
    let series: String
    let url: String
    let raceTable: RaceTable

    enum CodingKeys: String, CodingKey {
        case xmlns, series, url
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
        fileprivate let results: [Result]

    enum CodingKeys: String, CodingKey {
            case season, round, url, raceName
            case circuit = "Circuit"
            case date
            case results = "Results"
        }
    
    func getAllDrivers() -> [Driver] {
        var drivers = [Driver]()
        
        for result in results {
            drivers.append(result.driver)
        }
        
        return drivers
    }
    
    func getTimes() -> [String] {
        var times = [String]()
        
        for result in results {
            var status = result.status
            if !result.status.contains("Lap"),
               !result.status.contains("Accident"),
               !result.status.contains("Injured"),
               !result.status.contains("Retired"),
               !result.status.contains("Collision") {
                status.append(" issue")
            }
            times.append(result.time?.time ?? status)
        }
        
        return times
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

// MARK: - Result
private struct Result: Codable {
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

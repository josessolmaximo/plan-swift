//
//  Unit.swift
//  Plan
//
//  Created by Joses Solmaximo on 01/02/24.
//

import Foundation

extension UnitLength {
    static var units: [UnitLength] = [
        UnitLength.meters,
        UnitLength.feet,
        UnitLength.millimeters,
        UnitLength.centimeters,
        UnitLength.inches,
        UnitLength.kilometers,
        UnitLength.miles,
        UnitLength.yards,
    ]
}

extension UnitVolume {
    static var units: [UnitVolume] = [
        UnitVolume.cups,
        UnitVolume.gallons,
        UnitVolume.liters,
        UnitVolume.milliliters
    ]
}

extension UnitMass {
    static var units: [UnitMass] = [
        UnitMass.kilograms,
        UnitMass.grams,
        UnitMass.milligrams,
        UnitMass.ounces,
        UnitMass.pounds,
    ]
}

extension UnitPressure {
    static var units: [UnitDuration] = [
        UnitDuration.hours,
        UnitDuration.minutes,
        UnitDuration.hours,
        UnitDuration.seconds
    ]
}



//
//  Participant.swift
//  Assignment1
//

protocol Participant {
    init(name: String)
    func completionTime(for: Sport, in: Triathlon, randomValue: Double) -> Int
    var name: String { get }
    var favoriteSport: Sport? { get }
}


extension Participant {
    func metersPerMinute(for sport: Sport, randomValue: Double) -> Int{
        var value: Double
        switch sport {
        case .swimming:
            value = 43
        case .cycling:
            value = 500
        case .running:
            value = 157
        }
        
        var modifier = 0.8 + (randomValue * 0.4)
            if let favoriteSport = self.favoriteSport {
                if favoriteSport == sport {
                    modifier += 0.1
                }
                else {
                    modifier -= 0.1
                }
            }
        return Int(value * modifier)
    }
    
    func completionTime(for sport: Sport, in triathlon: Triathlon) -> Int {
        return completionTime(for: sport, in: triathlon, randomValue: Double.random())
    }
    
    func completionTime(for sport: Sport, in triathlon: Triathlon, randomValue: Double) -> Int {
        let distance: Int = triathlon.distance(for: sport)
        let velocity: Int = metersPerMinute(for: sport, randomValue: randomValue)
        return distance / velocity
    }
}

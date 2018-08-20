//
//  Athlete.swift
//  Assignment1
//

class Athlete: Participant {
    var name: String
    
    var favoriteSport: Sport? {
        get {
            return nil
        }
    }
    
    required init(name: String) {
        self.name = name
    }
}

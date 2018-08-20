//
//  TriathlonEvent.swift
//  Assignment1
//

class TriathlonEvent {
    var triathlon: Triathlon
    private var registered = [Participant]()
    private var eventTime = [Int?]()
    
    private(set) var eventPerformed: Bool = false //public on r, private on w

    init(triathlon: Triathlon) {
        self.triathlon = triathlon
    }
    
    func register(_ participant: Participant) -> Void {
        guard eventPerformed == false else {
            fatalError()
        }
        registered.append(participant)
        eventTime.append(0)
    }
    
    var registeredParticipants: [Participant] {
        get {
            return registered
        }
    }
    
    func raceTime(for participant: Participant) -> Int? {
        let index: Int? = registered.index(where: {$0.name == participant.name})
        if index == nil {
            return nil
        }
        return eventTime[index!]
    }
    
    func simulate(_ sport: Sport, for participant: Participant, randomValue: Double = Double.random())  -> Void {
        let index = registered.index(where: {$0.name == participant.name})!
        guard eventTime[index] != nil else {
            return
        }
        print(participant.name, "is about to begin ", sport.description)

        if sport == participant.favoriteSport || randomValue >= 0.06 {
            var result: Int = 0
            result = participant.completionTime(for: sport, in: triathlon)
            eventTime[index] = result + eventTime[index]!
            print(participant.name, "finish the ", sport, "event in ", result, "minutes; thier total race time is now ", eventTime[index]!, "minutes")
        }
        
        if sport != participant.favoriteSport && randomValue < 0.06 {
            eventTime[index] = nil
            print(participant.name, "could not finish the", sport, "event and will not finish the race")
        }
    }
    
    func simulate() -> Void {
        guard eventPerformed == false else {
            fatalError()
        }
        for sport in Triathlon.sports {
            for each in registeredParticipants {
                simulate(sport, for: each)
            }
        }
        eventPerformed = true
    }
    
    var winner: Participant? {
        get {
            guard eventPerformed == true else {
                fatalError()
            }
            
            var minTime: Int = Int.max
            var minPart: Participant? = nil
            for i in 0..<registered.count {
                let time = eventTime[i]
                    if time == nil {
                        continue
                    }
                    if time! < minTime {
                        minTime = time!
                        minPart = registered[i]
                    }
            }
            return minPart
        }
    }
}

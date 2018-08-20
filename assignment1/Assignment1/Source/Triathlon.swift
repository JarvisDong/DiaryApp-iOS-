//
//  Triathlon.swift
//  Assignment1
//

enum Triathlon {
    case sprint
    case olympic
    case halfIronman
    case ironman
    static let sports: [Sport] = [Sport.swimming, Sport.cycling, Sport.running]
    
    func distance(for sport: Sport) -> Int {
        switch (self, sport) {
        case (.sprint, .swimming):
            return 750
        case (.sprint, .cycling):
            return 20000
        case (.sprint, .running):
            return 5000
        case (.olympic, .swimming):
            return 1500
        case (.olympic, .cycling):
            return 40000
        case (.olympic, .running):
            return 10000
        case (.halfIronman, .swimming):
            return 1930
        case (.halfIronman, .cycling):
            return 90000
        case (.halfIronman, .running):
            return 21090
        case (.ironman, .swimming):
            return 3860
        case (.ironman, .cycling):
            return 180000
        case (.ironman, .running):
            return 42200
        }
    }
}

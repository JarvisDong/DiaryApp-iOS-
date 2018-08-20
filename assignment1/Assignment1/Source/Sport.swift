//
//  Sport.swift
//  Assignment1
//

enum Sport: CustomStringConvertible{
    case cycling
    case swimming
    case running
    
    public var description: String {
        switch self {
        case .cycling:
            return "cycling"
        case .swimming:
            return "swimming"
        case .running:
            return "running"
        }
    }
}//end of enum Sport



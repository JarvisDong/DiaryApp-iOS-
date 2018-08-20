//
//  main.swift
//  Assignment1
//

let Event = TriathlonEvent(triathlon: Triathlon.ironman)

let Swimmer1 = Swimmer(name: "Cassi")
let Swimmer2 = Swimmer(name: "Jason")
let Swimmer3 = Swimmer(name: "Kathy")
let Cyclist1 = Cyclist(name: "Asia")
let Cyclist2 = Cyclist(name: "David")
let Runner1 = Runner(name: "Sigh")
let Runner2 = Runner(name: "Becky")
let Athlete1 = Athlete(name: "Charles")
let Athlete2 = Athlete(name: "Chunck")

Event.register(Swimmer1)
Event.register(Swimmer2)
Event.register(Swimmer3)
Event.register(Cyclist1)
Event.register(Cyclist2)
Event.register(Runner1)
Event.register(Runner2)
Event.register(Athlete1)
Event.register(Athlete2)

Event.simulate()
let winner = Event.winner
if winner == nil {
    print("No one won!")
}
else {
    print(Event.winner!.name, "wins first place with a total time of ", Event.raceTime(for: Event.winner!)!, "minutes")
}

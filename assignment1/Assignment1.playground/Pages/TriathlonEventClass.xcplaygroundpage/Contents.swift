/*:
[Previous](@previous)

# TriathlonEvent class

This work should be done in the TriathlonEvent.swift file that already exists in the project.

The `TriathlonEvent` class implements the functionality necessary to simulate a triathlon race event.

1. The class will implement a constant property named `triathlon` of the type `Triathlon` with no initial value defined.

2. The class will implement an initializer that takes a parameter with the identifier `triathlon` of type `Triathlon`
and set the initial value of the `triathlon` property to the value passed as a parameter.

3. The class will implement a variable property named `eventPerformed` of the type `Bool` with the initial value of
`false`. This variable should have public access for reading and private access for writing. Hint: this is
accomplished by adding the `private(set)` keyword before the `var` keyword.

4. The class will implement a method that can be used to register a `Participant` in the event. This method should be
named `register`, and take a single parameter with the empty label `_` of type `Participant`. The implementation of
this method should add this participant to the event and give them an initial time of 0 minutes. This method should use
a guard statement to verify that `eventPerformed` is false and call the `fatalError()` function if that verification
fails. How you store participant data is up to you, you may create whatever additional properties and private methods
you like. It is acceptable to assume that participant names will be unique.

5. The class will implement a computed property named `registeredParticipants` of type `[Participant]` that only
specifies a get block which returns an array of all currently registered participants.

6. The class will implement a method that returns the race time for a particular registered participant. This method
should be named `raceTime`, take a single parameter with the label `for` of type `Participant`, and return the type
`Int?`.

7. The class will implement a method that simulates one sport of the triathlon for a specific participant with some
random variance. This method should be named `simulate`, take a first parameter with the empty label `_` of type
`Sport`, a second parameter with the label `for` of type `Participant`, and a third parameter with the label
`randomValue` of type `Double` which has a default value of `Double.random()`. If the sport is equal to the
participant's favorite sport or the random value is >= 0.06 the implementation should call the `completionTime(for:in:)`
method on the participant for the sport and store the result. This resulting time should then be added to the
participants event time (which was initialized to 0 upon registration). If the sport is not the participant's favorite
sport and the random value is < 0.06, the participants event time should be set to nil to indicate they have failed at
the sport and dropped out of the race. This method should use a guard statement to verify that the participant's event
time is not already nil, returning if it is. The method should print the text "<participant name> is about to begin
<sport>". If the participant finishes the sport the method should print the text "<participant name> finished the
<sport> event in <time for sport> minutes; their total race time is now <event time> minutes." If the participant does
not finish the sport the method should print the text "<participant name> could not finish the <sport> event and will
not finish the race.".

8. The class will implement a method that simulates the entire triathlon event for all registered participants. This
method should be named `simulate` and take no parameters. The implementation of this method should loop through
`Triathlon.sports` and for each sport loop through all registered participants calling the `simulate(_:forParticipant:)`
method. After simulating each participant in each sport, it should set the `eventPerformed` variable to `true`.
This method should use a guard statement to verify that `eventPerformed` is false and call the `fatalError()` function
if that verification fails.

9. The class will implement a computed property named `winner` of type `Participant?` that only specifies a get block
which determines the winner of the triathlon event based on all the participant event times. A participant with a nil
event time should never win. If two or more participants are tied with the same winning event time, the one who
registered first should win. It is possible for no participant to win if the event time for all participants is set to
nil during `performEvent()`, although this should be extremely rare in practice. This method should use a guard
statement to verify that `eventPerformed` is true and call the `fatalError()` function if that verification fails.

Remember to enable the related test bundle and run the tests to validate your work.

The next page will describe how to [implement the Main.swift file](@next).
*/

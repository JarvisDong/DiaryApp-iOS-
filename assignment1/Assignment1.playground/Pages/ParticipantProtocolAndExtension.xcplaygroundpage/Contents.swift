/*:
[Previous](@previous)

# Participant protocol and extension

### Participant protocol

This work should be done in the Participant.swift file that already exists in the project.

The `Participant` protocol defines a set of methods and properties that must be implemented by a type in order to be a
`Participant` in a `TriathlonEvent`.

1. The `Participant` protocol should require an initializer that takes a single parameter with the label `name` of type
`String`.
2. The `Participant` protocol should require a method named `completionTime` that takes a first parameter with the label
`for` of type `Sport`, a second parameter with the label `in` of type `Triathlon`, a third parameter with the label
`randomValue` of type `Double`, and returns a value of type `Int`. Note that the `randomValue` parameter will be used
by the unit tests in the project to pass known values which will remove the randomization during testing.
3. The `Participant` protocol should require a variable named `name` of type `String` that provides at least a `get`
implementation.
4. The `Participant` protocol should require a variable named `favoriteSport` of the optional type `Sport?` that
provides a `get` implementation.

### Extension of Participant

The extension to the `Participant` protocol defines default functionality that will be added to any type conforming to
the `Participant` protocol if that type does not provide its own implementation. Add your implementation of the
extension to the `Participant` protocol below your `Participant` protocol implementation in the same file.

1. The extension will add a method to the `Participant` protocol that can be used to get the participants speed for a
given sport. This method should be named `metersPerMinute`, take a first parameter with the label `for` of type
`Sport`, a second parameter with the label `randomValue` of type `Double` which has a default value of
`Double.random()`, and return a value of type `Int`.

The body of this method should use the following logic:

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

2. The extension will provide a variation of the `completionTime(for:in:randomValue:)` function without the third
parameter for convenience. Add a method with the name `completionTime` that takes a first parameter with the label
`for` of type `Sport`, a second parameter with the label `in` of type `Triathlon`, and returns a value of type `Int`.
The implementation of this method should return the result of calling the version of the method that takes all three
parameters, passing through the two parameters it was invoked with for the first two parameters and `Double.random()`
for the third parameter.

3. The extensions will also provide a default implementation of the `completionTime(for:in:randomValue:)` function as
declared in the `Participant` protocol. The implementation of this method should call the `distance(for:)` method on
the received `Triathlon` instance passing through the received `Sport` instance as the parameter value and store the
result in a constant. It should then call the `metersPerMinute(for:randomValue:)` method passing through the received
`Sport` and `Double` instances and store the result in a constant. Finally it should return the result of dividing the
first stored value by the second stored value.

Remember to enable the related test bundle and run the tests to validate your work.

The next page will describe how to [implement the Athlete class](@next).
*/

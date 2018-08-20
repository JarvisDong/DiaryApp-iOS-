/*:
[Previous](@previous)

# Triathlon enum

This work should be done in the Triathlon.swift file that already exists in the project.

The `Triathlon` enum represents the collection of four of the common triathlon distances. It should contain four
different enum cases: `sprint`, `olympic`, `halfIronman`, and `ironman`.

Reminder: When declaring a function, each parameter in the parameter list has a label and an identifier. The label is
used when invoking the method and is part of the method name. The identifier is used to reference the parameter in the
implementation body. Here is an example of a function named doStuff that takes a single parameter with the label `with`
of type `Sport`:

	func doStuff(with sport: Sport)

In addition to the cases listed above, the `Triathlon` enum should contain a function named `distance` that takes a
single parameter with the label `for` of type `Sport` (the identifier for the parameter is not important, but `sport`
would be a good choice) and returns a value of type `Int`. Based on the value of `self` and the passed parameter value,
it should return the number of meters as appropriate based on the following data:
* Sprint distances
	* Swimming: 750 meters
	* Cycling: 20000 meters
	* Running: 5000 meters
* Olympic distances
	* Swimming: 1500 meters
	* Cycling: 40000 meters
	* Running: 10000 meters
* HalfIronman distances
	* Swimming: 1930 meters
	* Cycling: 90000 meters
	* Running: 21090 meters
* Ironman distances
	* Swimming: 3860 meters
	* Cycling: 180000 meters
	* Running: 42200 meters

Hint: You can create a tuple value of `self` and the parameter value (named `sport` in the example below) and use a
switch statement like the following:

	switch (self, sport) {
	case (.sprint, .swimming):
		// ...
	// Other cases...
	}

Lastly, you will need to add a static constant named `sports` to the Triathlon enum which will represent the sports that
occur during a triathlon and their order. The value should be an array of `Sport` objects, containing exactly and in
this order: `Sport.swimming`, `Sport.cycling`, and `Sport.running`.

Hint: A static constant or variable is a constant or variable that is a part of a type itself, rather than part of each
instance of that type. You declare the constant or variable as normal, except that you add the `static` keyword before
the `let` or `var` keyword.

Remember to enable the related test bundle and run the tests to validate your work.

The next page will describe how to [implement the Participant protocol](@next).
*/

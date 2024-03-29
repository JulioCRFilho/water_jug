# water_jug

This project aims to satisfy the conditions for the `Water Jug Challenge`
It's presented in a pretty UI with light animations
The state management used is Flutter's native `setState` method and `Stream Functions and Builders`
There's no third party libraries used in this project

## Public Github repository link
<a href="https://github.com/JulioCRFilho/water_jug">Repository</a>

## Algorithmic Approach
The algorithm chose was `BFS` (Breadth-First Search)
This approach check all possibilities derived from the current state
It receives the BFS name due to checking every possibility in the current layer before going in depth

## Test cases for validation
The testing cases ensures the core logic is working through testing small units of code.
Currently the main method being tested is the `Calculate`
This method receives 3 `int` values and ensures they meet the requirements for the BFS algorithm to execute
Our testing covers successful, failure and edge cases to ensure the application doesn't break.

## Instructions to run the program
This application is made using the `Flutter` sdk within the `Dart` language.

`Steps to run`: </br>
    `1` - Download the <a href="https://docs.flutter.dev/get-started/install">Flutter SDK</a> accordingly to your Operation System </br>
    `2` - Ensure the Flutter version is compatible with the project's version </br>
    `3` - Add the Flutter path to your Environment Variables </br>
    `4` - Clone the project using Git clone </br>
    `5` - Open the project using your favorite IDE </br>
    `6` - Install the Flutter plugin </br>
    `7` - Run the project through your IDE or using the command line flutter run (optionally pass the platform argument)

## Observation
This project was built for Android and iOS. But also runs on Web, Linux and Windows

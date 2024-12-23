This is a simple project to select a list of players and add them to another one called "Favourite Players."

The App does not include third-party libraries and has the following characteristics:

Architecture: The app is based on the native iOS UIkit framework and does not use storyboards. Its pattern is a hybrid between MVVM and Clean Architecture.
Repository: The repository is implemented as an Actor to avoid race conditions. However, a classic singleton could have handled the same operations.
Persistence: Favourite players are stored in UserDefaults in a lightweight manner, saving only their primitive IDs (integers) within an array.
Custom Components: There are only two custom components: a custom cell and a search component.
Testability: The architecture is designed so that the repository and its exposed use cases can be tested and reused in any other part of the application.
Alternatives to using UserDefaults (which is not ideal for complex data structures) could include the following:

File System: Use disk storage (e.g., saving to a JSON file) if more details about each player are needed, such as the entire Player object.
Core Data: A data management framework that allows you to persistently store structured objects, which would be suitable for storing your favourite players.


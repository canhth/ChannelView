## A simple MindValley Channel app.

# Technical notes
- [x] Following VIPER architechture.
- [x] Pull to refresh.
- [x] Images and Network caching.
- [x] UI improved, support iPad screens.
- [x] UnitTests.
- [x] Swiftlint for coding styles & clean code.
- [x] Support `fastlane`. Run `fastlane scan` in Xcode project directory.
- [x] Prepared to support multi environments (dev and prod).

# What parts of the test did you find challenging and why?
- Caching Image and JSON data. I tried to simply use URLCache for both Images and Datas but it's keeping on Memory only.
so I decided to use a framework to reduce the workload. 

# What feature would you like to add in the future to improve the project?
 - Make Channel simpler by move `Latest Episode` to tableHeaderView and `Categories` to tableFooterView.
 - Apply SkeletonView for loading animation.
 - Intergrate CI/CD with this repo, to double check every commit/PR pass the test cases. 
 - Make Test Coverage > 90% (Now is 75.5%)
 - Add UI tests.
 - Improve UI on Ipads.

 
## Project structures
```
MindValley
├── Resources
├── Models
├── Modules
├── Core
│  └── Helper
|  └── Extensions
|  └── Networking
│  └── BaseVIPER
|     └── Presenter
|     └── Router
|     └── View

MindValleyTests
```

### VIPER
[VIPER](https://medium.com/@smalam119/viper-design-pattern-for-ios-application-development-7a9703902af6) is a very clean architecture. It isolates each module from others. So changing or fixing bugs are very easy as you only have to update a specific module. Also for having modular approach VIPER creates a very good environment for unit testing.
###### Other Key Advantages of VIPER Architecture:
- Good for large teams.
- Makes it scalable. Enable developers to simultaneously work on it as seamlessly as possible.
- Makes it easy to add new features.
- Makes it easy to write automated tests since your UI logic is separated from the business logic.
- Makes it easier to track issues via crash reports due to the Single Responsibility Principle.
- Makes the source code cleaner, more compact, and reusable.
- Reduces the number of conflicts within the development team.
- Applies SOLID principles.

#### VIPER Template
I created a VIPER Xcode template to make the work easier, reduce time for create new files and repeate the same code per module.

[Installation Instruction](https://github.com/m-rec/524ad38f766143bd5e1f804e231ba7a3b8877ce6/tree/master/XCode%20Templates)

To create new module: `Create new Group as your module name ---> Add new File --> Scroll down to select VIPER template --> type your module name.`

### BaseNetworking
A very lightweight URLSession wrapper to work with REST APIs. Easy to use and flexible with diffirent endpoints, methods.

```swift
networkClient.fetch(endPoint: ListUsersEndpoint.fetchListCategories(), type: [Cateogy].self) { (result) in
            switch result {
            case .success(let categories):
                print("Fetched list categories: \(categories)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
```

### TestCases

Add test cases for each modules or base components to make sure we won't break it after changes. Can run `fastlane scan` 
- [x] CategoriesTests.
- [x] ChannelsTests.
- [x] CollectionCellTests.
- [x] Load data from cache.
- [x] Support Mockable test or load data from local JSON.


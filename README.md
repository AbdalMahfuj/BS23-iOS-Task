# BS23-iOS-Task
Assignment: iOS Task


|-------------------------------------------------------------------------------|
|                                                                               |<br>
|                 Brain Station 23 Ltd. iOS Practical Test                     |<br>
|                       Name:  Abdullah Al Mahfug                              |<br>
|                       Email:  abdalmahfuj@gmail.com                          |<br>
|                       Phone: 01953720564                                    |<br>
|_______________________________________________________________________________|<br>


# Brain Station 23 Ltd.
iOS Practical Test

## Overview

This is an iOS application that allows users to explore a curated list of movies. Users can view a list of movies, access detailed information about each movie and can search movie from Themoviedb.org free API.

-  I used the API from Themoviedb.org, that shows movie list, and help to search movie based on title.
-  API link: "https://api.themoviedb.org/3/search/movie?api_key=\(APIConstant.apiKey)&query=\(queryString)&page=\(page)"
-  api_key:  Got token from Themoviedb.org. 'Query' is from search text. If the search field is empty, I show the list with "marvel" query as for empty search no result is being responded.
-  And 'page' paramter is used for pagination.
-  For networking, I used URLSession
-  Architectural design pattern: MVVM

## Features

- Movie List: Browse through a comprehensive list of movies with relevant details.
- Movie Details: View detailed information about a selected movie, including title, overview, release date, popularity and ratings.
- Search Functionality: Easily search for specific movies based on titles or keywords.
- User-Friendly Interface: Enjoy a clean user interface for effortless navigation.
- Responsive Design: Access the app on various iOS devices, with a responsive layout for both iPhone and iPad.


### Prerequisites

- Xcode (version 14.0)
- Minimum iOS Target (15.0)

### Installation

1. Clone the repository: 'https://github.com/AbdalMahfuj/BS23-iOS-Task.git'
2. Install dependencies: sdWebImage for Image caching and smooth scrolling.
3. Xcode -> File -> Add Packages -> 'github.com/SDWebImage/SDWebImage.git' paste this link. Add this to project.


### Run

1. Select a simulator or a physical device from the Xcode toolbar.
2. For physical device it need to sign in with apple id.

## Screenshots

![welcome](https://github.com/AbdalMahfuj/BS23-iOS-Task/assets/54243174/b694ebfe-d286-4ffd-a88b-d648f4c89e14)   ![movieList](https://github.com/AbdalMahfuj/BS23-iOS-Task/assets/54243174/68b6c958-ea22-4461-b1ff-33f5fdcac433)       ![movieDetails](https://github.com/AbdalMahfuj/BS23-iOS-Task/assets/54243174/4e777212-845f-43ef-b4cf-751459c31cb0)


## Acknowledgments

- Movie data provided by [Movie Database API](https://developer.themoviedb.org/docs).

## Contact
For any inquiries, please contact at [abdalmahfuj@gmail.com].


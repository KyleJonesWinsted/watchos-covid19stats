# COVID-19 Stats (watchOS)

### Keep track of the latest numbers regarding the coronavirus SARS-COV-2 right on your Apple Watch

![App Screenshots](https://i.imgur.com/lNjBq3a.png)

## Usage

To get started simply open app on your Apple Watch. By default the only listing will be statistics for the entire world. You can tap "+ Add Country" and select a country from the list to start tracking stats for that country.

The main list view of the app shows the total number of active cases in each given country. You can reorder items in the list by tapping and holding on a country and dragging it to the desired position. You can also delete a country by swiping left and tapping the red delete button.

The complication on your watch face represents the topmost country in the apps main list view.

Tapping on a country will reveal all the available stats for that country. Stats include:

* Active Cases
* Total Cases
* New Cases (as of midnight GMT)
* Cases in Critical Condition
* Recovered
* Total Deaths
* New Deaths (as of midnight GMT)
* Tests Performed (not all countries report this)

Data is updated every 15 minutes or as often as watchOS allows given your current conditions (battery life, data connection, etc.).

## Installation

Due to App Store Review Guidelines 5.1.1(ix) this app cannot be distributed via the watchOS App Store. Since this app technically provides a service related to the healthcare field, it cannot be submitted by an individual developer like myself.

However, feel free to clone this repository and build and run on your own devices.

In order to build the application you will need to create a file called "Config.swift" and add the following code.

    import Foundation

    enum ConfigString: String {
        case rapidApiKey = "XXXXXXXX"
    }

Replace the string "XXXXXXXX" with the authentication key you receive when you sign up for an account at [RapidAPI.com](https://rapidapi.com/). This account and the API used in this project are both 100% free to use.

Details about the API used for this project can be found [here.](https://rapidapi.com/api-sports/api/covid-193/details)
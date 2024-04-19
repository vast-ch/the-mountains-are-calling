# The mountains are calling

## Idea

Based on the idea of *simple*, location sharing first introduced in [Google Latitude](https://en.wikipedia.org/wiki/Google_Latitude), and then expanded in various other projects [1](https://support.strava.com/hc/en-us/articles/224357527-Strava-Beacon), [2](https://support.strava.com/hc/en-us/articles/207294450-Strava-Beacon-for-Garmin) this app is here for outdoor enthusiasts that want to:

- Give their loved ones peace of mind by being able to see their (near) real-time location.
- Give themselves peace of mind by *not* requiring to remember to enable live tracking. It's **always** on.
- Not having to share the data with big brother:
  - The dataset gathered is minimal to allow full functionality & prevent any spying.
  - No registration, login or any other [PII](https://en.wikipedia.org/wiki/Personal_data)s are required.
  - No app installation necessary.
  - Although the default setup shares the location data to **our servers**, the project is fully [Open Source](https://en.wikipedia.org/wiki/Open_source) with detailed manual on how to self host. So you can have the data completely under control.

## Functionality

- Allows audit of location history of a device for security purposes.
  - This person went to the mountains and is not responding. What was their last known location? Where were they heading to? What is the expected where they might be?
  - Their phone disappeared from the network for some time, did it come back online?
- Is not useable for spying on people.
  - There is no direct functionality that shares location data, only (location) data gathering and analysis. If your device already shares information about your position to other parties without your consent, then you have different kind of problems.
  - The service only collects minimum necessary data to provide unesful information:
    - `id` - unique identifier for device, that is also used for access to data analytics
    - `coordinates` - GPS location
    - `accuracy` - How precise is the `coordinates` information
    - `timestamp` - When was the GPS location obtaines

## Usage

### Client

- Client is any device which location is supposed to be tracked.

### Server

- Server gathers the location data and can visualize them.

## Architecture

- TODO

## Self hosting

- TODO


## Name

> The mountains are calling and I must go.
>
> -- <cite>[John Muir](https://en.wikiquote.org/wiki/John_Muir) - letter to sister Sarah Muir Galloway (3 September 1873)</cite>

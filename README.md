# Renewed Weathersync

## Description
Renewed Weathersync is made so you do not need to worry about syncing time and weather inside your server!

## Features
- Custom weather sequences
- pre-render the entire weather queue
- admin can change the weather sequence while in game
- customizeable time scale, you can choose if u want short/long days!
- customizeable time scale depending on time, preconfigured to make night time longer than day time
- HUGE performance boost compared to other weather sync resources, such as qb-weathersync
- drag and drop compatability with qb-weathersync
- a lot of other features, feel free to test it out!

## Installation
1. Clone the repository: `git clone https://github.com/Renewed-Scripts/Renewed-Weathersync.git`
2. Copy the `Renewed-Weathersync` folder into your server directory.
3. Add `start Renewed-Weathersync` to your `server.cfg` file.

## Removing compatability files
Currently we have compatability files for qb and cd easy time, qb is automatically detected but if you have never used cd_easytime before simply remove dependencies by doing the following:
1. Headover to your server.cfg
2. Copy and paste `setr weather_disablecd true` into your server.cfg
3. and that's it you now disabled cd_easytime compatability!

## Configuration
You can configure the resource by modifying the `weather.lua` & `time.lua` files.

## Usage
Once the resource is installed and configured, it will automatically sync the weather and time, the entire weather synchronization is handled upon resource start.

## Contributing
Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## Credits
- I took a lot of inspiration from https://github.com/JnKTechstuff/ParadoxWorldSync so a big thanks to them for their work on that resource.

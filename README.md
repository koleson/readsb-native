# readsb-native
(In Progress) Native macOS/iOS/tvOS client to view ADS-B aircraft data from readsb protobuf servers

<img width="1794" alt="Screenshot 2023-04-14 at 16 00 29" src="https://user-images.githubusercontent.com/569012/232168145-4f0878a9-c67c-4c23-a9a9-2408a800e4fc.png">

## Goals
- Replicate functionality of `readsb` web UI with native code and controls for macOS/iOS/tvOS
  - Aircraft map
    - Trails
    - Custom Icons for types
    - basic filters
  - Aircraft details
    - ADS-B encoded data
    - Data derived from ICAO hex / ICAO24 database
  - Aircraft list
    - selectable display fields
    - selecting aircraft on list highlights it in map/details

## Background
- Mictonic's [`readsb` protobuf fork](https://github.com/Mictronics/readsb-protobuf) exposes flight data as bandwidth/parsing-efficient protocol buffer files.
  - You can get an idea of what information is available in [`readsb.proto`](https://github.com/Mictronics/readsb-protobuf/blob/dev/readsb.proto).
- not all information commonly seen on FlightRadar24/FlightAware is available from ADS-B alone - much of it is retrieved from databases that map ICAO hex identifiers in ADS-B messages to the more useful forms.

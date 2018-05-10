# PokemonBot

An iOS Swift Client using a BFF (Backend for Frontend) service implemented in Node.js to simplify access to Pokemon APIs exposed on https://pokeapi.co


## BFF

The BFF Node.js sercvice is implemented in two different flavors exposing REST or GRPC interfaces.

The REST BFF version use classic Promise/Future and use a in process memory cache to optimize responsiveness.

The GRPC BFF version use Async/Await and GRPC (HTTP/2) streaming capabilities to optimize responsiveness.

## Client

The client Swift iOS App consume the BFF services to search and display Pokemon info.

As the BFF service also the Swift client App is implemented in two different flavors using respectlivly REST or GRPC networking.

The REST Swift client use Codable protocol and URLSession to easily implement the REST client calls.

The GRPC Swift client use Swift GRPC stack. 

If you waant customize the GRPC/proto interface file please follow the instructions on https://github.com/grpc/grpc-swift about how to install the Protocol Buffer Compiler, build SwiftGRPC and install the protoc-gen-swift and the protoc-gen-swiftgrpc plugin.

The SwiftGRPC and depency libraries are added to the XCode project using CocoaPod.

The generated Swift protobuf and grpc files are included in this repo so in order to build and test this sample you only need to run `pod install`


## Demo:
![Alt Text](https://github.com/JacopoMangiavacchi/PokemonBot/blob/master/demo.mov?raw=true)


## BFF Install instructions

- run `npm install` to install node dependencies
- run `node server.js` to start the BFF server


## Client Install instructions

- run `pod install` to install Swift GRPC dependencies
- open the solution in Xcode
- update the REST or GRPC endpoint in the ViewController.swift file according to where you are running the BFF
- build and run on simulator or device 


## BFF GRPC Internet tunnelling

In order to run the BFF GRPC service on your workstation and being able to run the app on iPhone devices you need to connect the client and the server using a tcp tunnel solution.

- install ngrok from https://ngrok.com
- run `ngrok tcp 50051`

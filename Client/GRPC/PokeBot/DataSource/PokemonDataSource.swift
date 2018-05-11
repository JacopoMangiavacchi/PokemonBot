//
//  PokemonDataSource.swift
//  PokeBot
//
//  Created by Jacopo Mangiavacchi on 5/11/18.
//  Copyright © 2018 Jacopo Mangiavacchi. All rights reserved.
//

import Foundation
import SwiftGRPC


class PokemonDataSource {
    var pokemons = [Pokebot_Pokemon]()
    
    var address: String
    
    var client: Pokebot_PokeBotServiceClient!
    var event: Pokebot_PokeBotsearchPokemonCall!
    var searching = false
    
    init() {
        address = Bundle.main.object(forInfoDictionaryKey: "GRPC_Address") as! String

        gRPC.initialize()
        print("GRPC version \(gRPC.version) - endpoint: \(address)")
    }

    func reset() {
        pokemons = [Pokebot_Pokemon]()
    }
    
    func searchNewPokemon(searchText: String, completition: @escaping () -> Void) {
        do {
            searching = true
            var input = Pokebot_PokeInput()
            input.name = searchText
            
            self.client = Pokebot_PokeBotServiceClient(address: address, secure: false)
            self.event = try self.client.searchPokemon(input, completion: { (result) in
                self.searching = false
                print(result)
            })
            
            DispatchQueue.global().async {
                do {
                    while (self.searching) {
                        if let newPokemon = try self.event.receive() {
                            self.pokemons.append(newPokemon)
                            DispatchQueue.main.async {
                                completition()
                            }
                        }
                    }
                }
                catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
}



/*
 *
 * Copyright 2018 Jacopo Mangiavacchi.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

const NodeCache = require( "node-cache" );
const request = require("request-promise");
  
const pokemonCache = new NodeCache({ stdTTL: 0, checkperiod: 0 });
const habitatCache = new NodeCache({ stdTTL: 0, checkperiod: 0 });
const typeCache = new NodeCache({ stdTTL: 0, checkperiod: 0 });


var PROTO_PATH = __dirname + '/pokemon.proto';

var fs = require('fs');
var parseArgs = require('minimist');
var path = require('path');
var _ = require('lodash');
var grpc = require('grpc');
var pokebot = grpc.load(PROTO_PATH).pokebot;


async function searchPokemon(call) {
  let name = call.request.name;

  try {
    call.write(await getPokemon(name));
  }
  catch (error) {
    console.log(error);
    try {
      let pokemons = await getTypes(name);
      await Promise.all(pokemons.map(async p => {
        call.write(await getPokemon(p.pokemon.name));
      }))
    }
    catch (error) {
      console.log(error);
    }
  }

  call.end();
}

async function getTypes(name) {
  let cachedTypes = typeCache.get(name);
  if (cachedTypes == undefined) {
    var options = {
      method: 'GET',
      headers: {
          'Content-Type': 'application/json'
      },
      uri: `https://pokeapi.co/api/v2/type/${name}/`
    };
  
    let resp = JSON.parse(await request(options));
  
    return resp.pokemon;
  }
  else {
    return cachedTypes;
  }
}

async function getPokemon(name) {
  var pokemonObject = {}

  let cachedPokemon = pokemonCache.get(name);
  if (cachedPokemon == undefined) {
    var options = {
      method: 'GET',
      headers: {
          'Content-Type': 'application/json'
      },
      uri: `https://pokeapi.co/api/v2/pokemon/${name}/`
    };
  
    let pokemon = JSON.parse(await request(options));
  
    var types = [];
    pokemon.types.forEach(element => {
        types.push(element.type.name);
    });
  
    var species = pokemon.species.name;

    var pokemonSpecies = habitatCache.get(name);
    if (pokemonSpecies == undefined) {
      options.uri = `https://pokeapi.co/api/v2/pokemon-species/${species}/`
      pokemonSpecies = JSON.parse(await request(options));
    }
  
    var habitatats = ""
    var flavorText = "";
  
    if(pokemonSpecies != null) {
      if(pokemonSpecies.habitat != null) {
        habitatats = pokemonSpecies.habitat.name;
      }
  
      var flavors = pokemonSpecies.flavor_text_entries;
  
      flavors.forEach(element => {
          if(element.language.name === "en") {
              flavorText = element.flavor_text.replace(/(?:\r\n|\r|\n|\f)/g, ' ');
          }
      });
  
      pokemon.flavorText = flavorText;
    }
  
    pokemonObject =  {
                "id": pokemon.id,
                "name": pokemon.name,
                "height": pokemon.height,
                "weight": pokemon.weight,
                "types": types,
                "thumbnail": `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png`,
                "image": `https://img.pokemondb.net/artwork/${pokemon.name}.jpg`,
                "habitats" : habitatats,
                "flavorText" : flavorText
            };
    
    pokemonCache.set(name, pokemonObject);
  }
  else {
    pokemonObject = cachedPokemon;
  }

  return pokemonObject;
}


/**
 * Get a new server with the handler functions in this file bound to the methods
 * it serves.
 * @return {Server} The new server object
 */
function getServer() {
  var server = new grpc.Server();

  server.addService(pokebot.PokeBot.service, {
    searchPokemon: searchPokemon
  });
  return server;
}

if (require.main === module) {
  // If this is run as a script, start a server on an unused port
  var routeServer = getServer();
  routeServer.bind('0.0.0.0:50051', grpc.ServerCredentials.createInsecure());
  routeServer.start();
}

exports.getServer = getServer;

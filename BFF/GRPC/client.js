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

var PROTO_PATH = __dirname + '/pokemon.proto';

var async = require('async');
var fs = require('fs');
var parseArgs = require('minimist');
var path = require('path');
var _ = require('lodash');
var grpc = require('grpc');
var pokebot = grpc.load(PROTO_PATH).pokebot;

//var client = new pokebot.PokeBot('0.tcp.ngrok.io:12138', grpc.credentials.createInsecure());
var client = new pokebot.PokeBot('localhost:50051', grpc.credentials.createInsecure());


function runSearchPokemons(callback) {
  console.log('calling server');
  var call = client.searchPokemon( { "name" : "bulbasaur" } );  //bulbasaur | poison
  call.on('data', function(pokemon) {
      console.log(pokemon);
  });
  call.on('end', callback);
}


/**
 * Run all of the demos in order
 */
function main() {
  async.series([
    runSearchPokemons,
  ]);
}

if (require.main === module) {
  main();
}

exports.runSearchPokemons = runSearchPokemons;


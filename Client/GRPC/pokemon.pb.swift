// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: pokemon.proto
//
// For information on using the generated types, please see the documenation:
//   https://github.com/apple/swift-protobuf/

// Copyright 2015 gRPC authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that your are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct Pokebot_Pokemon {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var id: Int32 = 0

  var name: String = String()

  var height: Int32 = 0

  var weight: Int32 = 0

  var types: [String] = []

  var thumbnail: String = String()

  var image: String = String()

  var habitats: String = String()

  var flavorText: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Pokebot_PokeInput {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var name: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "pokebot"

extension Pokebot_Pokemon: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Pokemon"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "id"),
    2: .same(proto: "name"),
    3: .same(proto: "height"),
    4: .same(proto: "weight"),
    5: .same(proto: "types"),
    6: .same(proto: "thumbnail"),
    7: .same(proto: "image"),
    8: .same(proto: "habitats"),
    9: .same(proto: "flavorText"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularInt32Field(value: &self.id)
      case 2: try decoder.decodeSingularStringField(value: &self.name)
      case 3: try decoder.decodeSingularInt32Field(value: &self.height)
      case 4: try decoder.decodeSingularInt32Field(value: &self.weight)
      case 5: try decoder.decodeRepeatedStringField(value: &self.types)
      case 6: try decoder.decodeSingularStringField(value: &self.thumbnail)
      case 7: try decoder.decodeSingularStringField(value: &self.image)
      case 8: try decoder.decodeSingularStringField(value: &self.habitats)
      case 9: try decoder.decodeSingularStringField(value: &self.flavorText)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.id != 0 {
      try visitor.visitSingularInt32Field(value: self.id, fieldNumber: 1)
    }
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 2)
    }
    if self.height != 0 {
      try visitor.visitSingularInt32Field(value: self.height, fieldNumber: 3)
    }
    if self.weight != 0 {
      try visitor.visitSingularInt32Field(value: self.weight, fieldNumber: 4)
    }
    if !self.types.isEmpty {
      try visitor.visitRepeatedStringField(value: self.types, fieldNumber: 5)
    }
    if !self.thumbnail.isEmpty {
      try visitor.visitSingularStringField(value: self.thumbnail, fieldNumber: 6)
    }
    if !self.image.isEmpty {
      try visitor.visitSingularStringField(value: self.image, fieldNumber: 7)
    }
    if !self.habitats.isEmpty {
      try visitor.visitSingularStringField(value: self.habitats, fieldNumber: 8)
    }
    if !self.flavorText.isEmpty {
      try visitor.visitSingularStringField(value: self.flavorText, fieldNumber: 9)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  func _protobuf_generated_isEqualTo(other: Pokebot_Pokemon) -> Bool {
    if self.id != other.id {return false}
    if self.name != other.name {return false}
    if self.height != other.height {return false}
    if self.weight != other.weight {return false}
    if self.types != other.types {return false}
    if self.thumbnail != other.thumbnail {return false}
    if self.image != other.image {return false}
    if self.habitats != other.habitats {return false}
    if self.flavorText != other.flavorText {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Pokebot_PokeInput: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".PokeInput"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "name"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self.name)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  func _protobuf_generated_isEqualTo(other: Pokebot_PokeInput) -> Bool {
    if self.name != other.name {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

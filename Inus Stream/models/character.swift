//
//  character.swift
//  Inus Stream
//
//  Created by Inumaki on 07.11.22.
//

import Foundation

struct Character: Codable {
    let id: Int?
    let role: String
    let name: Name
    let image: String
    let voiceActors: [VoiceActor]?
}

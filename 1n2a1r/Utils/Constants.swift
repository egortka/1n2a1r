//
//  Constants.swift
//  InstagramClone
//
//  Created by Egor Tkachenko on 18/03/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import Firebase

//MARK: - Root references

let DB_REF = Database.database().reference()
let STORAGE_REF = Storage.storage().reference()

//MARK: - Storage references

let STORAGE_PROFILE_IMAGES_REF = STORAGE_REF.child("profile_images")

//MARK: - Database References

let USERS_REF = DB_REF.child("users")
let MESSAGES_REF = DB_REF.child("Messages")
let REPORTS_REF = DB_REF.child("reports")
let BLOCKS_REF = DB_REF.child("blocks")

//MARK: - Sources References

let STREAM_REF = "http://1n2a1r.com:8000/"
let LIBRARY_REF = "http://1n2a1r.com/"
let PLAYLIST_REF = "http://1n2a1r.com/api/audio.json"

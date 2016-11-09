import Foundation

class FavoritesManager {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let userDefaultKey = "favoriteVideos"

    func contain(videoId: String) -> Bool {
        let videos = get()
        for video in videos {
            if video.videoId == videoId {
                return true
            }
        }
        return false
    }
    
    func get() -> [Video] {
        var favoriteVideos: Dictionary<String, String> = [:]
        if let saveFavoriteVideos = userDefaults.dictionaryForKey(userDefaultKey) as? Dictionary<String, String> {
            favoriteVideos = saveFavoriteVideos
        }
        
        var videos: [Video] = []
        
        for (key, value) in favoriteVideos {
        
            var video = Video()
            video.videoId = key
            
            let videoArray = value.componentsSeparatedByString(",")
            
            video.title = videoArray[0]
            video.imageUrl = videoArray[1]
            video.publishedAt = videoArray[2]
            
            videos.append(video)
        }

        return videos
    }
    
    func save(video: Video) {

        var favoriteVideos: Dictionary<String, String> = [:]
        
        if let saveFavoriteVideos = userDefaults.dictionaryForKey(userDefaultKey) as? Dictionary<String, String> {
            favoriteVideos = saveFavoriteVideos
        }
        
        favoriteVideos[video.videoId] =
            video.title + "," +
            video.imageUrl + "," +
            video.publishedAt
        
        userDefaults.setObject(
            favoriteVideos,
            forKey: userDefaultKey
        )

    }
    
    func delete(videoId: String) {
        let videos = get()
        allDelete()
        for video in videos {
            if video.videoId != videoId {
                save(video)
            }
        }
    }
    
    func allDelete() {
        userDefaults.removeObjectForKey(userDefaultKey)
    }
}
